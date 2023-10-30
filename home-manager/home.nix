{ config, pkgs, ... }:

{
  home = {
    stateVersion = "23.05"; 
    username = "leandro_driguez";
    homeDirectory = "/home/leandro_driguez";
  };

  programs = {
    vscode = {
      enable = true;
      userSettings = {
        "extensions.autoUpdate" = false;
        "python.languageServer" = "Pylance";
      };
      extensions = with pkgs.vscode-extensions; [
        ms-dotnettools.csharp
      ];
    };
    rofi = {
      enable = true;
      theme = /nix/store/7didv3595k21rr5ai929grglznym2799-rofi-1.7.5/share/rofi/themes/solarized.rasi;
      modi = "window,drun,ssh";
      show = "drun";
    };
  };
}
