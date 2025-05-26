do { 
  let timestamp = date now | format date "%Y-%m-%dT%H-%M-%S"; 
  grim -g $"(slurp)" $"($env.HOME)/Pictures/screenshots/screenshot-($timestamp).png";
  open $"($env.HOME)/Pictures/screenshots/screenshot-($timestamp).png" | wl-copy; 
}
