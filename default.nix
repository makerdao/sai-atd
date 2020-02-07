let srcs = import ./srcs.nix; in

{ pkgs ? import srcs.pkgs {}
, saiDeployScripts ? import srcs.saiDeployScripts {}
}:

let
  inherit (pkgs.abi-to-dhall) buildAbiToDhall deploy;
  inherit (saiDeployScripts) solidityPackages;
in buildAbiToDhall {
  name = "sai";
  src = ./.;

  # smart contract dependencies
  inherit solidityPackages;

  # only build contracts matching list
  abiFileGlobs = [
    "DSToken"
    "DSValue"
    "DSRoles"
    "*Fab"
    "Sai*"
  ];

  # add deploy script
  deployBin = pkgs.callPackage deploy {};
}
