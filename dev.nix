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
#    goland
    pycharm-professional
#    idea-ultimate
    webstorm
#    rider
    rust-rover
  ] ++ (with pkgs; [
    #    (rust-bin.nightly."2024-07-01".default.override {
    #      extensions = [ "rust-src" "rust-std" ];
    #      targets = [ "thumbv6m-none-eabi" ];
    #    })
    rustup
    #    rust-analyzer
    lldb
    pkg-config
    act
    cmake
    python311
    jdk17
    poetry
    poetryPlugins.poetry-plugin-export
    nodejs
    corepack
    marksman
    erlang
    elixir
    ninja
    dfu-util
    ccache
  ]);
}
