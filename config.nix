{ system }: {
  username = "kashun";
  email = "125161677+KashunCheng@users.noreply.github.com";

  inherit system;

  homeDirectory = if system == "aarch64-darwin" then "/Users/kashun" else "/home/kashun";
  isDesktop = system == "aarch64-darwin";
  isDev = system == "aarch64-darwin";
  isDesign = system == "aarch64-darwin";
  fontFamily = "JetBrainsMono Nerd Font";
}
