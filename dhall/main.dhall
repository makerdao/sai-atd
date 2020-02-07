let atd = ../atd/package

let schema = ./schema.dhall

let modules = ./modules.dhall

let outputAddresses = atd.Plan/outputs atd.Address atd.Address/output

in    λ(config : schema.Config)
    → λ(import : schema.Import)
    → let plan =
            modules.fab
              (   λ(fabOut : schema.FabOutput)
          → modules.core
              config
              import
              fabOut
              (   λ(coreOut : schema.CoreOutput)
          → atd.Plan/concat
              [ outputAddresses (toMap fabOut)
              , outputAddresses (toMap coreOut)
              ]
        ))

      in  atd.Plan/run plan
