{ pkgs, isDesign, ... }:
if !isDesign then { } else {
  home.packages = with pkgs; [
    (darktable.overrideAttrs rec {
      version = "4.2.1";
      src = fetchurl {
        url = "https://github.com/darktable-org/darktable/releases/download/release-${version}/darktable-${version}.tar.xz";
        sha256 = "603a39c6074291a601f7feb16ebb453fd0c5b02a6f5d3c7ab6db612eadc97bac";
      };
    })
  ];
}
