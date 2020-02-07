let srcs = import ./srcs.nix; in

{ pkgs ? import srcs.pkgs {}
, saiDeployScripts ? import srcs.saiDeployScripts {}
} @ args:

let
  default = import ./. args;
in default.shell {
  extraBuildInputs = [ pkgs.dapp2nix ];
}
