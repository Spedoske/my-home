{ pkgs, homeDirectory, username, email, ... }:
{
  programs = rec {
    zellij = {
      enable = true;
      settings = {
        default_shell = "${homeDirectory}/.nix-profile/bin/nu";
      };
    };
    atuin = {
      enable = true;
    };
    nushell = {
      enable = true;
      configFile.text = ''
        source ~/.cache/carapace/init.nu
      '';
      envFile.text = ''
        $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
        mkdir ~/.cache/carapace
        carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
      '';
    };
    # bash = {
    #   enable = true;
    #   profileExtra = ''
    #     source $HOME/.cargo/env
    #     source $HOME/export-esp.sh
    #   '';
    # };
    # zsh = bash;
    helix = {
      enable = true;
      defaultEditor = true;
    };
    starship = {
      enable = true;
      # Configuration written to ~/.config/starship.toml
      settings = builtins.fromTOML (builtins.readFile (builtins.fetchurl {
        url = "https://raw.githubusercontent.com/VictorPLopes/starship/908cf3e934eacff2f075072337001a41b40e4a6b/docs/.vuepress/public/presets/toml/tokyo-night.toml";
        sha256 = "sha256:0fhkm58zwaa1p0c6xyzlwgmyzixcibapbjpy3c96dfr4ydf5wpqv";
      }));
    };
    bat.enable = true;
    git = {
      enable = true;
      userEmail = email;
      userName = username;
      lfs.enable = true;
    };
    gitui.enable = true;
    direnv = {
      enable = true;
    };
  };
  home.packages = with pkgs; [
    # custom fonts for spaceship
    nerd-fonts.jetbrains-mono
    tealdeer
    carapace
    nil
    neofetch
    htop
    asciinema
    asciinema-agg
    gh
    wget
    wiper
  ];
}
