local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local max_items = 15
local spaces = {}
local space_watcher = sbar.add("item", {
  drawing = false,
  updates = false,
})

-- Add the new FOCUSED_WORKSPACE event
sbar.add("event", "aerospace_workspace_change")
sbar.add("event", "swap_menus_and_spaces")
sbar.add("event", "redraw_bar", function(env)
  for i = 1, 9 do
    if spaces[i] then
      spaces[i]:set({ drawing = true })
      sbar.set("space.padding." .. i, { drawing = true })
    end
  end
  print("Redraw event processed, forced visibility on spaces 1-9")
end)

for i = 1, max_items do
  local space = sbar.add("item", "space." .. i, {
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
    background = {
      color = colors.bg1,
      border_width = 1,
      height = 26,
      border_color = colors.bg2,
    },
    popup = { background = { border_width = 5, border_color = colors.bg2 } },
    drawing = false,
    associated_display = 1,
  })

  local space_bracket = sbar.add("bracket", { space.name }, {
    background = {
      color = colors.transparent,
      border_color = colors.bg2,
      height = 28,
      border_width = 2,
    },
  })

  local space_padding = sbar.add("space", "space.padding." .. i, {
    width = settings.group_paddings,
    drawing = false,
  })

  local space_popup = sbar.add("item", {
    position = "popup." .. space.name,
    padding_left = 5,
    padding_right = 0,
    background = {
      drawing = true,
      image = {
        corner_radius = 9,
        scale = 0.2,
      },
    },
  })

  space:subscribe("aerospace_workspace_change", function(env)
    if env.FOCUSED_WORKSPACE and tonumber(env.FOCUSED_WORKSPACE) == i then
      space:set({
        icon = { highlight = true },
        label = { highlight = true },
        background = { border_color = colors.grey },
      })
      space_bracket:set({
        background = { border_color = colors.grey },
      })
    else
      space:set({
        icon = { highlight = false },
        label = { highlight = false },
        background = { border_color = colors.bg2 },
      })
      space_bracket:set({
        background = { border_color = colors.bg2 },
      })
    end
  end)

  space:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "other" then
      space_popup:set({ background = { image = "space." .. i } })
      space:set({ popup = { drawing = "toggle" } })
    else
      local op = (env.BUTTON == "right") and "remove" or "focus"
      sbar.exec("aerospace workspace " .. i)
    end
  end)

  space:subscribe("mouse.exited", function(_)
    space:set({ popup = { drawing = false } })
  end)

  spaces[i] = space
end

local function update_spaces()
  sbar.exec("aerospace list-workspaces --all", function(result)
    sbar.set("/space\\..*/", { drawing = false })
    sbar.set("/space\\.padding\\..*/", { drawing = false })

    local workspace_nums = {}
    for line in result:gmatch("[^\r\n]+") do
      local n = tonumber(line)
      if n then
        table.insert(workspace_nums, math.max(0, math.min(255, n)))
      end
    end

    for i = 1, math.min(#workspace_nums, max_items) do
      spaces[i]:set({
        icon = { string = tostring(workspace_nums[i]) },
        drawing = true,
      })
      sbar.set("space.padding." .. i, { drawing = true })
    end

    sbar.trigger("redraw_bar")
  end)
end

local function set_initial_active_workspace()
  sbar.exec("aerospace list-workspaces --focused", function(result)
    local focused_workspace = tonumber(result:match("%d+"))
    if focused_workspace and focused_workspace <= 9 then
      local space = spaces[focused_workspace]
      if space then
        space:set({
          icon = { highlight = true },
          label = { highlight = true },
          background = { border_color = colors.grey },
        })
        sbar.set("bracket." .. space.name, {
          background = { border_color = colors.grey },
        })
      end
    else
      print("No valid focused workspace found, defaulting to none")
    end
  end)
end

local spaces_indicator = sbar.add("item", {
  padding_left = -3,
  padding_right = 0,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.grey,
    string = icons.switch.on,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.bg1,
  },
  background = {
    color = colors.with_alpha(colors.grey, 0.0),
    border_color = colors.with_alpha(colors.bg1, 0.0),
  },
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({
    icon = currently_on and icons.switch.off or icons.switch.on,
  })
  if currently_on then
    space_watcher:set({ updates = false })
    sbar.set("/space\\..*/", { drawing = false })
    sbar.set("/space\\.padding\\..*/", { drawing = false })
    sbar.set("/menu\\..*/", { drawing = true })
    sbar.set("front_app", { drawing = true })
    print("Spaces hidden, menus shown")
  else
    space_watcher:set({ updates = true })
    sbar.set("/menu\\..*/", { drawing = false })
    sbar.set("front_app", { drawing = false })
    update_spaces()
    print("Spaces shown, menus hidden")
  end
  print("spaces_indicator state: " .. spaces_indicator:query().icon.value)
end)

spaces_indicator:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 1.0 },
        border_color = { alpha = 1.0 },
      },
      icon = { color = colors.bg1 },
      label = { width = "dynamic" },
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 0.0 },
        border_color = { alpha = 0.0 },
      },
      icon = { color = colors.grey },
      label = { width = 0 },
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)

spaces_indicator:set({ icon = icons.switch.on })
set_initial_active_workspace()
update_spaces()

return space_watcher