{ pkgs, isDev, isDesktop, fontFamily, ... }:
if !isDev then { } else
{
  programs = {
    vscode = {
      enable = isDesktop;
      extensions = with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
      ];
      userSettings = {
        "terminal.integrated.fontFamily" = fontFamily;
      };
    };
  };
  home.packages = with pkgs.jetbrains; [
    clion
    datagrip
    gateway
    goland
    pycharm-professional
    idea-ultimate
    webstorm
    rider
  ] ++ (with pkgs; [
    (rust-bin.nightly."2023-08-13".default.override {
      extensions = [ "rust-src" "rust-std" ];
    })
    rust-analyzer
    lldb
    protobuf
    pkg-config
    utm
    act
    cmake
    python311
    jdk17
    poetry
    nodejs
    nodejs.pkgs.pnpm
    marksman
  ]);
}
