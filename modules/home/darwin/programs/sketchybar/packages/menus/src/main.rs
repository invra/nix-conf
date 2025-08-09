use clap::Parser;
use core_foundation::base::TCFType;
use core_foundation::string::CFString;
use objc::runtime::{Class, Object};
use objc::{msg_send, sel, sel_impl};
use std::os::raw::c_void;
use std::ptr;

// Suppress unexpected cfg warnings from objc macros
#[allow(unexpected_cfgs)]
fn main() {
    let args = Args::parse();

    // Check for valid arguments
    if !args.list && args.select.is_none() {
        eprintln!(
            "Usage: {} [-l | -s id/alias ]",
            std::env::current_exe()
                .map(|p| p.display().to_string())
                .unwrap_or_else(|_| "menus".to_string())
        );
        return;
    }

    if let Some(id_or_alias) = args.select {
        eprintln!(
            "Selecting application by ID or alias '{}' is not implemented",
            id_or_alias
        );
        return;
    }

    // Proceed with listing menus if -l is provided
    if args.list {
        unsafe {
            // Check Accessibility permissions
            if !check_accessibility_permissions() {
                eprintln!(
                    "This application requires Accessibility permissions. Please enable them in System Preferences > Security & Privacy > Privacy > Accessibility."
                );
                return;
            }

            // Get sharedWorkspace: NSWorkspace *ws = [NSWorkspace sharedWorkspace];
            let workspace: *mut Object = {
                let cls = match Class::get("NSWorkspace") {
                    Some(cls) => cls,
                    None => {
                        eprintln!("Failed to get NSWorkspace class");
                        return;
                    }
                };
                let ws: *mut Object = msg_send![cls, sharedWorkspace];
                if ws.is_null() {
                    eprintln!("Failed to get shared workspace");
                    return;
                }
                ws
            };

            // Get frontmost app: NSRunningApplication *frontApp = [ws frontmostApplication];
            let front_app: *mut Object = msg_send![workspace, frontmostApplication];
            if front_app.is_null() {
                eprintln!("No frontmost app found");
                return;
            }

            // Get processIdentifier: pid_t pid = [frontApp processIdentifier];
            let pid: i32 = msg_send![front_app, processIdentifier];

            // Create AXUIElement for app
            let axapp = match axui_element_create_application(pid) {
                Ok(axapp) => axapp,
                Err(e) => {
                    eprintln!("Error creating AXUIElement: {}", e);
                    return;
                }
            };

            // Get Menu Bar
            let menubar = match axui_element_copy_attribute(axapp, "AXMenuBar") {
                Ok(mb) => mb,
                Err(e) => {
                    eprintln!("Failed to get menu bar: {}", e);
                    if !axapp.is_null() {
                        CFRelease(axapp as *const c_void);
                    }
                    return;
                }
            };

            // Get menu bar children (menus)
            let menus = match axui_element_copy_attribute(menubar, "AXChildren") {
                Ok(menus) => menus,
                Err(e) => {
                    eprintln!("Failed to get menu bar children: {}", e);
                    if !menubar.is_null() {
                        CFRelease(menubar as *const c_void);
                    }
                    if !axapp.is_null() {
                        CFRelease(axapp as *const c_void);
                    }
                    return;
                }
            };

            // Print menu titles, excluding "Apple"
            let count = axui_array_get_count(menus);
            for i in 0..count {
                let menu = axui_array_get_value_at_index(menus, i);
                if !menu.is_null() {
                    if let Ok(title) = axui_element_copy_attribute_string(menu, "AXTitle") {
                        if title != "Apple" {
                            println!("{}", title);
                        }
                    }
                    // Do not release menu, as CFArrayGetValueAtIndex returns non-owned reference
                }
            }

            // Clean up Core Foundation objects
            if !menus.is_null() {
                CFRelease(menus as *const c_void);
            }
            if !menubar.is_null() {
                CFRelease(menubar as *const c_void);
            }
            if !axapp.is_null() {
                CFRelease(axapp as *const c_void);
            }
        }
    }
}

// Ensure macOS platform
#[cfg(not(target_os = "macos"))]
compile_error!("This program requires macOS");

// Type definitions for FFI
type AXUIElementRef = *mut c_void;
#[allow(dead_code)] // Kept for future use
type CFStringRef = *const c_void;
type CFArrayRef = *const c_void;

// FFI bindings to ApplicationServices, CoreFoundation, and AppKit frameworks
#[link(name = "ApplicationServices", kind = "framework")]
#[link(name = "CoreFoundation", kind = "framework")]
#[link(name = "AppKit", kind = "framework")]
unsafe extern "C" {
    unsafe fn AXUIElementCreateApplication(pid: i32) -> AXUIElementRef;
    unsafe fn AXUIElementCopyAttributeValue(
        element: AXUIElementRef,
        attr: *const c_void,
        value: *mut *mut c_void,
    ) -> i32;
    unsafe fn CFArrayGetCount(array: CFArrayRef) -> isize;
    unsafe fn CFArrayGetValueAtIndex(array: CFArrayRef, index: isize) -> *mut c_void;
    unsafe fn AXIsProcessTrusted() -> bool;
    unsafe fn CFRelease(cf: *const c_void);
}

unsafe fn check_accessibility_permissions() -> bool {
    unsafe { AXIsProcessTrusted() }
}

unsafe fn axui_element_create_application(pid: i32) -> Result<AXUIElementRef, &'static str> {
    let axapp = unsafe { AXUIElementCreateApplication(pid) };
    if axapp.is_null() {
        Err("Failed to create AXUIElement for application")
    } else {
        Ok(axapp)
    }
}

unsafe fn axui_element_copy_attribute(
    element: AXUIElementRef,
    attr_name: &str,
) -> Result<AXUIElementRef, &'static str> {
    if element.is_null() {
        return Err("Null element provided");
    }
    let attr_cfstring = CFString::new(attr_name);
    let attr_ptr = attr_cfstring.as_concrete_TypeRef() as *const c_void;
    let mut value: *mut c_void = ptr::null_mut();
    let result = unsafe { AXUIElementCopyAttributeValue(element, attr_ptr, &mut value) };
    if result == 0 && !value.is_null() {
        Ok(value as AXUIElementRef)
    } else {
        Err(match result {
            -25205 => "Invalid UI element",
            -25202 => "Cannot complete operation",
            _ => "Unknown error",
        })
    }
}

unsafe fn axui_element_copy_attribute_string(
    element: AXUIElementRef,
    attr_name: &str,
) -> Result<String, &'static str> {
    if element.is_null() {
        return Err("Null element provided");
    }
    let attr_cfstring = CFString::new(attr_name);
    let attr_ptr = attr_cfstring.as_concrete_TypeRef() as *const c_void;
    let mut value: *mut c_void = ptr::null_mut();
    let result = unsafe { AXUIElementCopyAttributeValue(element, attr_ptr, &mut value) };
    if result == 0 && !value.is_null() {
        let cfstr: CFString = unsafe { TCFType::wrap_under_create_rule(value as *const _) };
        // CFString takes ownership, no need to CFRelease value
        Ok(cfstr.to_string())
    } else {
        Err(match result {
            -25205 => "Invalid UI element",
            -25202 => "Cannot complete operation",
            _ => "Unknown error",
        })
    }
}

unsafe fn axui_array_get_count(array: AXUIElementRef) -> isize {
    if array.is_null() {
        0
    } else {
        unsafe { CFArrayGetCount(array as CFArrayRef) }
    }
}

unsafe fn axui_array_get_value_at_index(array: AXUIElementRef, index: isize) -> AXUIElementRef {
    if array.is_null() {
        ptr::null_mut()
    } else {
        unsafe { CFArrayGetValueAtIndex(array as CFArrayRef, index) as AXUIElementRef }
    }
}

// Command-line argument parsing
#[derive(Parser)]
#[command(about = "Retrieve menu bar titles of the frontmost application")]
struct Args {
    /// List menu bar titles of the frontmost application
    #[arg(short = 'l')]
    list: bool,
    /// Select an application by ID or alias (not implemented)
    #[arg(short = 's')]
    select: Option<String>,
}
