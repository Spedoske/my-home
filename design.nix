{ pkgs, isDesign, ... }:
if !isDesign then { } else {
  home.packages = with pkgs; [
    darktable
    inkscape
  ];
}
