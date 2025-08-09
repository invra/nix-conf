use clap::Parser;
use core_foundation::base::{CFTypeRef, TCFType};
use core_foundation::boolean::kCFBooleanTrue;
use core_foundation::dictionary::CFDictionaryRef;
use core_foundation::string::CFString;
use objc::runtime::{Class, Object};
use objc::{msg_send, sel, sel_impl};
use std::os::raw::c_void;
use std::ptr;
use std::thread;
use std::time::Duration;

use core_foundation_sys::string::{
    CFStringGetCString, CFStringGetLength, CFStringRef, kCFStringEncodingUTF8,
};

#[allow(unexpected_cfgs)]
fn main() {
    unsafe { ax_init() };

    let args = Args::parse();

    if !args.list && args.select.is_none() {
        eprintln!(
            "Usage: {} [-l | -s id ]",
            std::env::current_exe()
                .map(|p| p.display().to_string())
                .unwrap_or_else(|_| "menus".to_string())
        );
        return;
    }

    if args.list {
        unsafe {
            let app = ax_get_front_app();
            if app.is_null() {
                eprintln!("Failed to get frontmost application");
                return;
            }
            ax_print_menu_options(app);
            if !app.is_null() {
                CFRelease(app as *const c_void);
            }
        }
    } else if let Some(id_or_alias) = args.select {
        unsafe {
            let app = ax_get_front_app();
            if app.is_null() {
                eprintln!("Failed to get frontmost application");
                return;
            }
            if let Ok(id) = id_or_alias.parse::<i32>() {
                ax_select_menu_option(app, id);
            } else {
                eprintln!("Selecting by alias '{}' is not supported", id_or_alias);
            }
            if !app.is_null() {
                CFRelease(app as *const c_void);
            }
        }
    }
}

#[cfg(not(target_os = "macos"))]
compile_error!("This program requires macOS");

type AXUIElementRef = *mut c_void;
#[allow(dead_code)]
type CFStringRefAlias = *const c_void;
type CFArrayRef = *const c_void;

#[link(name = "ApplicationServices", kind = "framework")]
#[link(name = "CoreFoundation", kind = "framework")]
#[link(name = "AppKit", kind = "framework")]
unsafe extern "C" {
    fn AXUIElementCreateApplication(pid: i32) -> AXUIElementRef;
    fn AXUIElementCopyAttributeValue(
        element: AXUIElementRef,
        attr: *const c_void,
        value: *mut *mut c_void,
    ) -> i32;
    fn AXUIElementPerformAction(element: AXUIElementRef, action: *const c_void) -> i32;
    fn CFArrayGetCount(array: CFArrayRef) -> isize;
    fn CFArrayGetValueAtIndex(array: CFArrayRef, index: isize) -> *mut c_void;
    fn AXIsProcessTrustedWithOptions(options: CFDictionaryRef) -> bool;
    fn AXIsProcessTrusted() -> bool;
    fn CFRelease(cf: *const c_void);
    fn CFDictionaryCreate(
        allocator: *const c_void,
        keys: *const *const c_void,
        values: *const *const c_void,
        num_values: isize,
        key_callbacks: *const c_void,
        value_callbacks: *const c_void,
    ) -> CFDictionaryRef;
}

const K_AX_TRUSTED_CHECK_OPTION_PROMPT: &str = "AXTrustedCheckOptionPrompt";
const K_AX_TITLE_ATTRIBUTE: &str = "AXTitle";
const K_AX_MENU_BAR_ATTRIBUTE: &str = "AXMenuBar";
const K_AX_VISIBLE_CHILDREN_ATTRIBUTE: &str = "AXVisibleChildren";
const K_AX_CANCEL_ACTION: &str = "AXCancel";
const K_AX_PRESS_ACTION: &str = "AXPress";

unsafe fn ax_init() {
    let key = CFString::new(K_AX_TRUSTED_CHECK_OPTION_PROMPT);
    let keys = [key.as_CFTypeRef() as *const c_void];
    let values = [kCFBooleanTrue as *const c_void];
    let options = CFDictionaryCreate(
        ptr::null(),
        keys.as_ptr(),
        values.as_ptr(),
        1,
        ptr::null(),
        ptr::null(),
    );
    if options.is_null() {
        eprintln!("Failed to create options dictionary");
        std::process::exit(1);
    }
    let trusted = AXIsProcessTrustedWithOptions(options);
    CFRelease(options as *const c_void);
    if !trusted {
        eprintln!("Accessibility permissions not granted");
        std::process::exit(1);
    }
}

unsafe fn ax_get_front_app() -> AXUIElementRef {
    let cls = match Class::get("NSWorkspace") {
        Some(cls) => cls,
        None => {
            eprintln!("Failed to get NSWorkspace class");
            return ptr::null_mut();
        }
    };
    let workspace: *mut Object = msg_send![cls, sharedWorkspace];
    if workspace.is_null() {
        eprintln!("Failed to get shared workspace");
        return ptr::null_mut();
    }
    let front_app: *mut Object = msg_send![workspace, frontmostApplication];
    if front_app.is_null() {
        eprintln!("No frontmost app found");
        return ptr::null_mut();
    }
    let pid: i32 = msg_send![front_app, processIdentifier];
    AXUIElementCreateApplication(pid)
}

unsafe fn ax_get_title(element: AXUIElementRef) -> Option<CFString> {
    let mut title: *mut c_void = ptr::null_mut();
    let result = AXUIElementCopyAttributeValue(
        element,
        CFString::new(K_AX_TITLE_ATTRIBUTE).as_concrete_TypeRef() as *const c_void,
        &mut title,
    );
    if result == 0 && !title.is_null() {
        Some(CFString::wrap_under_create_rule(title as *const _))
    } else {
        None
    }
}

unsafe fn ax_perform_click(element: AXUIElementRef) {
    if element.is_null() {
        return;
    }
    let cancel_action = CFString::new(K_AX_CANCEL_ACTION);
    let press_action = CFString::new(K_AX_PRESS_ACTION);
    AXUIElementPerformAction(
        element,
        cancel_action.as_concrete_TypeRef() as *const c_void,
    );
    thread::sleep(Duration::from_micros(150000));
    AXUIElementPerformAction(element, press_action.as_concrete_TypeRef() as *const c_void);
}

unsafe fn ax_print_menu_options(app: AXUIElementRef) {
    let menubar = match axui_element_copy_attribute(app, K_AX_MENU_BAR_ATTRIBUTE) {
        Ok(mb) => mb,
        Err(e) => {
            eprintln!("Failed to get menu bar: {}", e);
            return;
        }
    };

    let menus = match axui_element_copy_attribute(menubar, K_AX_VISIBLE_CHILDREN_ATTRIBUTE) {
        Ok(menus) => menus,
        Err(e) => {
            eprintln!("Failed to get menu bar children: {}", e);
            if !menubar.is_null() {
                CFRelease(menubar as *const c_void);
            }
            return;
        }
    };

    let count = axui_array_get_count(menus);
    for i in 0..count {
        let menu = axui_array_get_value_at_index(menus, i);
        if !menu.is_null() {
            if let Some(title) = ax_get_title(menu) {
                let buffer_len = CFStringGetLength(title.as_concrete_TypeRef() as CFStringRef) * 2;
                let mut buffer = vec![0i8; buffer_len as usize];
                if CFStringGetCString(
                    title.as_concrete_TypeRef() as CFStringRef,
                    buffer.as_mut_ptr(),
                    buffer_len,
                    kCFStringEncodingUTF8,
                ) != 0
                {
                    let cstr = std::ffi::CStr::from_ptr(buffer.as_ptr());
                    if let Ok(str_slice) = cstr.to_str() {
                        println!("{}", str_slice);
                    }
                }
            }
        }
    }

    if !menus.is_null() {
        CFRelease(menus as *const c_void);
    }
    if !menubar.is_null() {
        CFRelease(menubar as *const c_void);
    }
}

unsafe fn ax_select_menu_option(app: AXUIElementRef, id: i32) {
    let menubar = match axui_element_copy_attribute(app, K_AX_MENU_BAR_ATTRIBUTE) {
        Ok(mb) => mb,
        Err(e) => {
            eprintln!("Failed to get menu bar: {}", e);
            return;
        }
    };

    let menus = match axui_element_copy_attribute(menubar, K_AX_VISIBLE_CHILDREN_ATTRIBUTE) {
        Ok(menus) => menus,
        Err(e) => {
            eprintln!("Failed to get menu bar children: {}", e);
            if !menubar.is_null() {
                CFRelease(menubar as *const c_void);
            }
            return;
        }
    };

    let count = axui_array_get_count(menus);
    if (id as isize) < count {
        let item = axui_array_get_value_at_index(menus, id as isize);
        ax_perform_click(item);
    } else {
        eprintln!("Menu index {} out of range (max: {})", id, count - 1);
    }

    if !menus.is_null() {
        CFRelease(menus as *const c_void);
    }
    if !menubar.is_null() {
        CFRelease(menubar as *const c_void);
    }
}

unsafe fn check_accessibility_permissions() -> bool {
    AXIsProcessTrusted()
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
    let result = AXUIElementCopyAttributeValue(element, attr_ptr, &mut value);
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

unsafe fn axui_array_get_count(array: AXUIElementRef) -> isize {
    if array.is_null() {
        0
    } else {
        CFArrayGetCount(array as CFArrayRef)
    }
}

unsafe fn axui_array_get_value_at_index(array: AXUIElementRef, index: isize) -> AXUIElementRef {
    if array.is_null() {
        ptr::null_mut()
    } else {
        CFArrayGetValueAtIndex(array as CFArrayRef, index) as AXUIElementRef
    }
}

#[derive(Parser)]
#[command(about = "Retrieve menu bar titles or select a menu item of the frontmost application")]
struct Args {
    #[arg(short = 'l')]
    list: bool,

    #[arg(short = 's')]
    select: Option<String>,
}
