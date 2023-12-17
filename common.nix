{ pkgs, homeDirectory, username, email, ... }:
{
  programs = {
    zellij = {
      enable = true;
      settings = {
        default_shell = "${homeDirectory}/.nix-profile/bin/nu";
      };
    };
    nushell = {
      enable = true;
      configFile.text = ''
        $env.PATH = if (($env.PATH | describe) == "string") { $env.PATH | split row ":" } else { $env.PATH }

        let carapace_completer = {|spans|
          carapace $spans.0 nushell $spans | from json
        }

        mut current = (($env | default {} config).config | default {} completions)
        $current.completions = ($current.completions | default {} external)
        $current.completions.external = ($current.completions.external
            | default true enable
            | default $carapace_completer completer)

        $env.config = $current
        $env.config.show_banner = false
      '';
    };
    bash = {
      enable = true;
      profileExtra = "${pkgs.nushell + "/bin/nu"}";
    };
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
    };
    gitui.enable = true;
    direnv = {
      enable = true;
    };
  };
  home.packages = with pkgs; [
    # custom fonts for spaceship
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    tealdeer
    carapace
    nil
    neofetch
    htop
    asciinema
    asciinema-agg
    gh
    wget
    diskonaut
  ];
}
