return {
  black = 0xff181819,
  white = 0xffb8b5cf,
  red = 0xffeb6f92,
  green = 0xff9ccfd8,
  blue = 0xff31748f,
  yellow = 0xfff6c177,
  orange = 0xfff6c177,
  magenta = 0xffc4a7e7,
  grey = 0xff403d52,
  transparent = 0x00000000,

  bar = {
    bg = 0xff191724,
    border = 0xff1f1d2e,
  },

  popup = {
    bg = 0xff191724,
    border = 0xff1f1d2e
  },

  bg1 = 0xff1f1d2e,
  bg2 = 0xff26233a,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
