{ config, pkgs, ... }:

let homeDirectory = if pkgs.system == "aarch64-darwin" then "/Users/kashun" else "/home/kashun";
    isDesktop = pkgs.system == "aarch64-darwin";
    isDev = pkgs.system == "aarch64-darwin";
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kashun";
  home.homeDirectory = homeDirectory;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  programs = {
    alacritty = {
      enable = isDesktop;
      settings = {
        shell = {
          program = "/bin/zsh";
          args = [ "--login" "-i" "-c" "/Users/kashun/.nix-profile/bin/nu" ];
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
    vscode = {
      enable = isDesktop;
      extensions = with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
      ];
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
'';
    };
    bash = {
      enable = true;
      profileExtra = "${pkgs.nushell + "/bin/nu"}";
    };
    helix = {
      enable = true;
      defaultEditor = true;
      package = pkgs.helix.overrideAttrs (oldAttrs: rec {
        src = pkgs.fetchzip {
          url = "https://github.com/Spedoske/helix/releases/download/23.06/helix-23.06-source.tar.xz";
          hash = "sha256-LcXGbw4EQqLarC9oxoEuNBat8+ehsB6LtHmF73qR0HQ=";
          stripRoot = false;
        };
        cargoDeps = oldAttrs.cargoDeps.overrideAttrs (pkgs.lib.const {
          name = "${oldAttrs.pname}-vendor.tar.gz";
          inherit src;
          outputHash = "sha256-kpiUCH5ov33pgvVXzdlD89GSxHYuG+2mQ0YKILXQltM=";
        });
      });
    };
    starship = {
      enable = true;
      # Configuration written to ~/.config/starship.toml
      settings = builtins.fromTOML (builtins.readFile (builtins.fetchurl "https://raw.githubusercontent.com/VictorPLopes/starship/master/docs/.vuepress/public/presets/toml/tokyo-night.toml"));
    };
    bat.enable = true;
    git = {
      enable = true;
      userEmail = "leomundspedoske@gmail.com";
      userName = "Spedoske";
    };
    gitui.enable = true;
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    tealdeer
    carapace
    nil
    iftop

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ] ++ (if isDesktop then with pkgs.jetbrains; [
    clion
    datagrip
    gateway
    goland
    pycharm-professional
    webstorm
  ] else []) ++ (if isDev then with pkgs; [
    rust-bin.nightly."2023-08-13".default
    rust-analyzer
    lldb
  ] else []);

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/kashun/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
