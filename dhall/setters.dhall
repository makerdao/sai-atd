let Optional/default = ../atd/Prelude/Optional/default

let Optional/map = ../atd/Prelude/Optional/map

let atd = ../atd/package

let lib = ../atd/lib

let sai = atd.contracts.sai

let schema = ./schema.dhall

let uintToBytes32 = λ(x : Natural) → atd.Bytes32/fromHex (atd.Uint256/hex (atd.Uint256/build x))

let add = atd.add let sub = atd.sub let mul = atd.mul let div = atd.div
let pow = atd.pow let log = atd.log let exp = atd.exp let num = atd.num
let numToHex = atd.numToHex

let year = 60 * 60 * 24 * 365 -- in seconds

-- bc -l <<< "scale=27; e( l(${fee} / 100 + 1)/(60 * 60 * 24 * 365)) * 10^27"
let yearly
    =   λ(scale : Natural)
      → λ(x : atd.Math)
      → (atd.Uint256/fromHex (numToHex scale
          (mul
            (exp
              (div
                (log (add (div x (num 100)) (num 1)))
                (num year)))
            (pow (num 10) (num scale)))
        ))

let sendIfNotImported
    =   λ(plan : atd.Plan)
      → λ(addr : Optional Text)
      → Optional/default
          atd.Plan
          plan
          (Optional/map Text atd.Plan (λ(addr : Text) → atd.Plan/empty) addr)

in    λ(config : schema.Config)
    → { tubCap =
            λ(mom : sai.SaiMom)
          → mom.send/setCap/uint256
              (atd.Uint256/build (config.tub_cap * lib.pow 10 18))

      , tubMat =
            λ(mom : sai.SaiMom)
          → mom.send/setMat/uint256
              (atd.Uint256/build (config.tub_mat * lib.pow 10 25))

      , tubTax =
            λ(mom : sai.SaiMom)
          → mom.send/setTax/uint256
              -- e( l(${tax} / 100 + 1)/(60 * 60 * 24 * 365)) * 10^27
              (yearly 27 (num config.tub_tax))

      , tubFee =
            λ(mom : sai.SaiMom)
          → mom.send/setFee/uint256
              -- e( l(${fee} / 100 + 1)/(60 * 60 * 24 * 365)) * 10^27
              (yearly 27 (num config.tub_fee))

      , tubAxe =
            λ(mom : sai.SaiMom)
          → mom.send/setAxe/uint256
              (atd.Uint256/build ((config.tub_axe + 100) * lib.pow 10 25))

      , tubGap =
            λ(mom : sai.SaiMom)
          → mom.send/setTubGap/uint256
              -- e( l(-${gap} / 100 + 1)/(60 * 60 * 24 * 365)) * 10^18
              (yearly 18 (sub (num 0) (num config.tub_gap)))

      , tapGap =
            λ(mom : sai.SaiMom)
          → mom.send/setTapGap/uint256
              -- e( l(-${gap} / 100 + 1)/(60 * 60 * 24 * 365)) * 10^18
              (yearly 18 (sub (num 0) (num config.tap_gap)))

      , voxWay =
            λ(mom : sai.SaiMom)
          → mom.send/setWay/uint256
              -- e( l(${way} / 100 + 1)/(60 * 60 * 24 * 365)) * 10^27
              (yearly 27 (num config.vox_way))

      , voxHow =
            λ(mom : sai.SaiMom)
          → mom.send/setHow/uint256
              (atd.Uint256/build (config.vox_how * lib.pow 10 27))

      , price =
            λ(import : schema.Import)
          → λ(pip : sai.DSValue)
          → λ(pep : sai.DSValue)

          → atd.Plan/concat
            [ sendIfNotImported
                (pip.send/poke/bytes32
                  (uintToBytes32 (atd.ethToWei config.pipPrice)))
                import.pip

            , sendIfNotImported
                (pep.send/poke/bytes32
                  (uintToBytes32 (atd.ethToWei config.pepPrice)))
                import.pep
            ]
      }
