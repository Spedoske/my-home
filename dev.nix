{ pkgs, isDev, isDesktop, ... }:
if !isDev then { } else
{
  programs = {
    vscode = {
      enable = isDesktop;
      extensions = with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
      ];
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
    ruby-mine
  ] ++ (with pkgs; [
    (rust-bin.nightly."2023-08-13".default.override {
      extensions = [ "rust-src" "rust-std" ];
    })
    rust-analyzer
    lldb
    protobuf
    pkg-config
    opencv
    utm
    cmake
    python311
    jdk17
    poetry
    nodejs
    nodejs.pkgs.pnpm
    marksman
    ocaml
    dune_3
    julia-bin
    ocamlPackages.seq
    ocamlPackages.stdlib-shims
    ocamlPackages.findlib
    ocamlPackages.core
    ocamlPackages.core_extended
    ocamlPackages.batteries
    ocamlPackages.ocaml-lsp
    ocamlPackages.ounit2
    ocamlPackages.utop
    ocamlPackages.ocamlformat-rpc-lib
    cachix
  ]);
}
