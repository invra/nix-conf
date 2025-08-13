local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

sbar.exec("killall memory_load >/dev/null; memory_load memory_update 1")

local memory = sbar.add("graph", "widgets.memory" , 42, {
  position = "right",
  graph = { color = colors.blue },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = { string = icons.memory },
  label = {
    string = "mem ??%",
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    align = "right",
    padding_right = 0,
    width = 0,
    y_offset = 4
  },
  padding_right = settings.paddings + 6
})

memory:subscribe("memory_update", function(env)
  local load = tonumber(env.total_load)
  
  memory:push({ load / 100. })
  local color = colors.blue
  if load > 30 then
    if load < 60 then
      color = colors.yellow
    elseif load < 80 then
      color = colors.orange
    else
      color = colors.red
    end
  end

  memory:set({
    graph = { color = color },
    label = "mem " .. env.total_load .. "%",
  })
end)

memory:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Activity Monitor'")
end)

sbar.add("bracket", "widgets.memory.bracket", { memory.name }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.memory.padding", {
  position = "right",
  width = settings.group_paddings
})
