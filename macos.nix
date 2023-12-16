{ pkgs, system, isDesktop, homeDirectory, ... }:
if system == "aarch64-darwin" then { } else
{
  programs = {
    alacritty = {
      enable = isDesktop;
      settings = {
        shell = {
          program = "/bin/zsh";
          args = [ "--login" "-i" "-c" "${homeDirectory}/.nix-profile/bin/zellij" ];
        };
        font = {
          size = 15;
          normal = {
            family = "HackGen Console NF";
            style = "Regular";
          };
          bold = {
            family = "HackGen Console NF";
            style = "Bold";
          };
        };
      };
    };
  };
}
