{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          lib,
          ...
        }:
        {
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.nixfmt
              pkgs.nodejs_22
              pkgs.yarn
            ];
          };
          packages.firefox-dev = pkgs.firefox-devedition.override {
            extraPolicies = {
              BlockAboutConfig = true;
              "3rdparty".Extensions."{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" = {
                options.autoUpdate = 0;
                scripts = [
                  ''
                    // ==UserScript==
                    // @name declarative-testing
                    // @description changes the background-color to black
                    // @match *://*/*
                    // @grant GM_addStyle
                    // @version 0.0.0
                    // @author nobody
                    // ==/UserScript==
                    // GM_addStyle(`* {background-color: black; !important}`);
                  ''
                ];
              };
            };
          };
        };
    };
}
