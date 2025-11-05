{ ... }:
{
  programs.zellij = {
    enable = true;
    settings = {
      show_startup_tips = false;
      show_release_notes = false;
      copy_on_select = false;
      scroll_buffer_size = 100000;
      ui.pane_frames.rouded_corners = true;
      
      theme = "rose-pine";
      themes.rose-pine = {
        bg = "#403d52";
        fg = "#e0def4";
    		red = "#eb6f92";
    		green = "#31748f";
    		blue = "#9ccfd8";
    		yellow = "#f6c177";
    		magenta = "#c4a7e7";
    		orange = "#fe640b";
    		cyan = "#ebbcba";
    		black = "#26233a";
    		white = "#e0def4";
      };
    };
  };
}
