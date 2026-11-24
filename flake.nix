{
  description = "Portables GNOME-Live-System mit grafischer NixOS-Installation";

  inputs.nixpkgs.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.xz";
  inputs.hermes.url = "github:NousResearch/hermes-agent/v0.23.3";
  inputs.windscribe.url = "github:ParkerrDev/nixpkgs-windscribe";
  inputs.windscribe.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { nixpkgs, hermes, windscribe, ... }:
    let
      system = "x86_64-linux";
      mkSystem = module: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs.hermesDesktop = hermes.packages.${system}.desktop;
        modules = [ windscribe.nixosModules.default ./programs.nix module ];
      };
      live = mkSystem ./live.nix;
      installed = mkSystem ./configuration.nix;
    in
    # Calamares writes configuration.nix with the target's disks and user.
    if builtins.pathExists ./configuration.nix then {
      nixosConfigurations = { inherit installed; } // {
        ${installed.config.networking.hostName} = installed;
      };
    } else
    {
      nixosConfigurations.live = live;
      packages.${system}.iso = live.config.system.build.isoImage;
    };
}
