local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local max_items = 15
local spaces = {}
local space_watcher = sbar.add("item", { drawing = false, updates = false })

sbar.add("event", "aerospace_workspace_change")
sbar.add("event", "swap_menus_and_spaces")

for i = 1, max_items do
  local space_item = sbar.add("item", "space." .. i, {
    icon = {
      font = { family = settings.font.numbers },
      string = tostring(i),
      padding_left = 15,
      padding_right = 15,
      color = colors.white,
      highlight_color = colors.red,
    },
    label = {
      padding_right = 20,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
      drawing = false,
    },
    padding_right = 1,
    padding_left = 1,
    background = { color = colors.bg1, border_width = 1, height = 26, border_color = colors.bg2 },
    popup = { background = { border_width = 5, border_color = colors.bg2 } },
    drawing = false,
    associated_display = 1,
  })

  local space_bracket = sbar.add("bracket", "bracket.space." .. i, { space_item.name }, {
    background = { color = colors.transparent, border_color = colors.bg2, height = 28, border_width = 2 },
  })

  sbar.add("space", "space.padding." .. i, { width = settings.group_paddings, drawing = false })

  local space_popup = sbar.add("item", {
    position = "popup." .. space_item.name,
    padding_left = 5,
    padding_right = 0,
    background = { drawing = true, image = { corner_radius = 9, scale = 0.2 } },
  })

  space_item:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "other" then
      space_popup:set({ background = { image = "space." .. i } })
      space_item:set({ popup = { drawing = "toggle" } })
    else
      sbar.exec("aerospace workspace " .. i)
    end
  end)

  space_item:subscribe("mouse.exited", function() space_item:set({ popup = { drawing = false } }) end)

  spaces[i] = { item = space_item, bracket = space_bracket }
end

local function update_spaces()
  sbar.exec("aerospace list-workspaces --all", function(result)
    local workspace_nums = {}
    for line in result:gmatch("[^\r\n]+") do
      local n = tonumber(line)
      if n then table.insert(workspace_nums, n) end
    end

    for i = 1, max_items do
      local space = spaces[i]
      if space then
        local number = workspace_nums[i]
        if number then
          space.item:set({ icon = { string = tostring(number) }, drawing = true })
          sbar.set("space.padding." .. i, { drawing = true })
        else
          space.item:set({ drawing = false })
          sbar.set("space.padding." .. i, { drawing = false })
        end
      end
    end

    sbar.exec("aerospace list-workspaces --focused", function(res)
      local focused = tonumber(res:match("%d+"))
      if focused then
        for i = 1, max_items do
          local space = spaces[i]
          if space then
            local is_active = (workspace_nums[i] == focused)
            space.item:set({
              icon = { highlight = is_active },
              label = { highlight = is_active },
              background = { border_color = is_active and colors.grey or colors.bg2 },
            })
            space.bracket:set({ background = { border_color = is_active and colors.grey or colors.bg2 } })
          end
        end
      end
    end)
  end)
end

space_watcher:subscribe("aerospace_workspace_change", function() update_spaces() end)

local spaces_indicator = sbar.add("item", {
  padding_left = -3,
  padding_right = 0,
  icon = { padding_left = 8, padding_right = 9, color = colors.grey, string = icons.switch.on },
  label = { width = 0, padding_left = 0, padding_right = 8, string = "Spaces", color = colors.bg1 },
  background = { color = colors.with_alpha(colors.grey, 0.0), border_color = colors.with_alpha(colors.bg1, 0.0) },
})

spaces_indicator:subscribe("swap_menus_and_spaces", function()
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({ icon = currently_on and icons.switch.off or icons.switch.on })

  if currently_on then
    space_watcher:set({ updates = false })
    for i = 1, max_items do
      if spaces[i] then
        spaces[i].item:set({ drawing = false })
        sbar.set("space.padding." .. i, { drawing = false })
      end
    end
    sbar.set("/menu\\..*/", { drawing = true })
    sbar.set("front_app", { drawing = true })
  else
    space_watcher:set({ updates = true })
    sbar.set("/menu\\..*/", { drawing = false })
    sbar.set("front_app", { drawing = false })
    update_spaces()
  end
end)

spaces_indicator:subscribe("mouse.entered", function()
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({ background = { color = { alpha = 1.0 }, border_color = { alpha = 1.0 } },
      icon = { color = colors.bg1 }, label = { width = "dynamic" } })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function()
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({ background = { color = { alpha = 0.0 }, border_color = { alpha = 0.0 } },
      icon = { color = colors.grey }, label = { width = 0 } })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function() sbar.trigger("swap_menus_and_spaces") end)

update_spaces()
space_watcher:set({ updates = true })
spaces_indicator:set({ icon = icons.switch.on })

return space_watcher
