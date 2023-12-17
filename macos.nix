{ lib, pkgs, system, isDesktop, homeDirectory, fontFamily, mac-app-util, ... }:
if system != "aarch64-darwin" then { } else
{
  home.activation = {
    trampolineApps = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      fromDir="$HOME/Applications/Home Manager Apps"
      toDir="$HOME/Applications/Home Manager Trampolines"
      ${mac-app-util}/bin/mac-app-util sync-trampolines "$fromDir" "$toDir"
    '';
  };
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
            family = fontFamily;
            style = "Regular";
          };
        };
      };
    };
  };
}
