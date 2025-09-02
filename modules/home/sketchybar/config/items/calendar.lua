local colors = require("colors")
local settings = require("settings")

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

local cal = sbar.add("item", {
  icon = {
    color = colors.white,
    padding_left = 8,
    font = {
      size = 12.0,
    },
  },
  label = {
    color = colors.white,
    padding_right = 8,
    width = 74,
    align = "right",
    font = { family = settings.font.numbers },
  },
  position = "right",
  update_freq = 1,
  padding_left = 1,
  padding_right = 1,
  background = {
    color = colors.bg1,
    border_color = colors.bg2,
    border_width = 1,
  },
})

sbar.add("bracket", { cal.name }, {
  background = {
    color = colors.transparent,
    height = 30,
    border_color = colors.bg2,
  },
})

sbar.add("item", { position = "right", width = settings.group_paddings })

cal:subscribe({ "forced", "routine", "system_woke" }, function()
  cal:set({ icon = os.date("%a. %d %b."), label = os.date("%H:%M:%S") })
end)
