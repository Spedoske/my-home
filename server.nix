{ pkgs, isDesktop, ... }:
if isDesktop then { } else
{
  home.packages = with pkgs; [
    iftop
  ];
}
