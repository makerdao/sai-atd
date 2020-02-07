let Optional/map = ../atd/Prelude/Optional/map

let Optional/default = ../atd/Prelude/Optional/default

let atd = ../atd/package

let Address = atd.Address

let Address/build = atd.Address/build

let Boolean/build = atd.Boolean/build

let Module = atd.Module

let Module/default = atd.Module/default

let sai = atd.contracts.sai

let schema = ./schema.dhall

let defaultAddress
    : ∀(t : Type) → (Address → t) → Module t → Optional Text → Module t
    =   λ(t : Type)
      → λ(build : Address → t)
      → λ(default : Module t)
      → λ(opt : Optional Text)
      → atd.Module/default
          t
          default
          (Optional/map Text t (λ(addr : Text) → build (Address/build addr)) opt)

let TokenOutput =
      { gem : sai.DSToken
      , gov : sai.DSToken
      , pip : sai.DSValue
      , pep : sai.DSValue
      , daiFab : sai.DaiFab
      , adm : sai.DSRoles
      , pitAddress : Address
      }

let createTokens
    =   λ(import : schema.Import)
      → λ(fabOut : schema.FabOutput)
      → λ(return : TokenOutput → atd.Plan)

      → defaultAddress
          sai.DSToken
          sai.DSToken/build
          (sai.DSToken/create/bytes32
            (atd.Bytes32/fromHex (atd.asciiToHex "ETH")))
          import.gem
        (λ(gem : sai.DSToken)

      → defaultAddress
          sai.DSToken
          sai.DSToken/build
          (sai.DSToken/create/bytes32
            (atd.Bytes32/fromHex (atd.asciiToHex "GOV")))
          import.gov
        (λ(gov : sai.DSToken)

      → defaultAddress
          sai.DSValue
          sai.DSValue/build
          sai.DSValue/create
          import.pip
        (λ(pip : sai.DSValue)

      → defaultAddress
          sai.DSValue
          sai.DSValue/build
          sai.DSValue/create
          import.pep
        (λ(pep : sai.DSValue)

      → sai.DaiFab/create/address-address-address-address-address-address-address
          fabOut.GEM_FAB
          fabOut.VOX_FAB
          fabOut.TUB_FAB
          fabOut.TAP_FAB
          fabOut.TOP_FAB
          fabOut.MOM_FAB
          fabOut.DAD_FAB
        (λ(daiFab : sai.DaiFab)

      → defaultAddress
          sai.DSRoles
          sai.DSRoles/build
          ( λ(return : sai.DSRoles → atd.Plan)
            → sai.DSRoles/create
              ( λ(adm : sai.DSRoles)
                → atd.Plan/concat
                  [ adm.send/setRootUser/address-bool
                      atd.from
                      (Boolean/build True)
                  , return adm
                  ]
          ))
          import.adm
        (λ(adm : sai.DSRoles)

      → let pitAddress =
              Address/build
                (Optional/default
                  Text
                  "0x0000000000000000000000000000000000000123"
                  import.pit)

        in  return
            { gem = gem
            , gov = gov
            , pip = pip
            , pep = pep
            , daiFab = daiFab
            , adm = adm
            , pitAddress = pitAddress
            }
      ))))))

let setupDaiFab
    =   λ(tokens : TokenOutput)
      → atd.Plan/concat
        [ tokens.daiFab.send/makeTokens
        , tokens.daiFab.send/makeVoxTub/address-address-address-address-address
            tokens.gem.address
            tokens.gov.address
            tokens.pip.address
            tokens.pep.address
            tokens.pitAddress
        , tokens.daiFab.send/makeTapTop
        , tokens.daiFab.send/configParams
        , tokens.daiFab.send/verifyParams
        , tokens.daiFab.send/configAuth/address
            tokens.adm.address
        ]

let getDaiAddresses
    : sai.DaiFab → Module schema.DaiFabOutput
    =   λ(daiFab : sai.DaiFab)
      → λ(return : schema.DaiFabOutput → atd.Plan)
      → daiFab.call/sai
        (λ(saiAddress : Address)
      → daiFab.call/sin
        (λ(sinAddress : Address)
      → daiFab.call/skr
        (λ(skrAddress : Address)
      → daiFab.call/dad
        (λ(dadAddress : Address)
      → daiFab.call/mom
        (λ(momAddress : Address)
      → daiFab.call/vox
        (λ(voxAddress : Address)
      → daiFab.call/tub
        (λ(tubAddress : Address)
      → daiFab.call/tap
        (λ(tapAddress : Address)
      → daiFab.call/top
        (λ(topAddress : Address)
      → return
        { SAI_SAI = saiAddress
        , SAI_SIN = sinAddress
        , SAI_SKR = skrAddress
        , SAI_DAD = dadAddress
        , SAI_MOM = momAddress
        , SAI_VOX = voxAddress
        , SAI_TUB = tubAddress
        , SAI_TAP = tapAddress
        , SAI_TOP = topAddress
        }
      )))))))))

let sendSetters
    =   λ(config : schema.Config)
      → λ(import : schema.Import)
      → λ(tokens : TokenOutput)
      → λ(daiFabOut : schema.DaiFabOutput)

      → let set = ./setters.dhall config

        let mom = sai.SaiMom/build daiFabOut.SAI_MOM

        let tub = sai.SaiTub/build daiFabOut.SAI_TUB

        in  atd.Plan/concat
            [ set.tubCap mom
            , set.tubMat mom
            , set.tubTax mom
            , set.tubFee mom
            , set.tubAxe mom
            , set.tubGap mom
            , set.tapGap mom
            , set.voxWay mom
            , set.voxHow mom
            , set.price import tokens.pip tokens.pep
            , tub.send/drip
            ]

let fabModule
    : Module schema.FabOutput
    = λ(return : schema.FabOutput → atd.Plan)
      → sai.GemFab/create
        (λ(gemFab : sai.GemFab)
      → sai.VoxFab/create
        (λ(voxFab : sai.VoxFab)
      → sai.TubFab/create
        (λ(tubFab : sai.TubFab)
      → sai.TapFab/create
        (λ(tapFab : sai.TapFab)
      → sai.TopFab/create
        (λ(topFab : sai.TopFab)
      → sai.MomFab/create
        (λ(momFab : sai.MomFab)
      → sai.DadFab/create
        (λ(dadFab : sai.DadFab)
      → return
        { GEM_FAB = gemFab.address
        , VOX_FAB = voxFab.address
        , TAP_FAB = tapFab.address
        , TUB_FAB = tubFab.address
        , TOP_FAB = topFab.address
        , MOM_FAB = momFab.address
        , DAD_FAB = dadFab.address
        }
      )))))))

let coreModule
    :   schema.Config
      → schema.Import
      → schema.FabOutput
      → Module schema.CoreOutput
    =   λ(config : schema.Config)
      → λ(import : schema.Import)
      → λ(fabOut : schema.FabOutput)
      → λ(return : schema.CoreOutput → atd.Plan)

      → createTokens import fabOut
        (λ(tokens : TokenOutput)

      → atd.Plan/concat
        [ setupDaiFab tokens

        , getDaiAddresses tokens.daiFab
          (λ(daiFabOut : schema.DaiFabOutput)

        → atd.Plan/concat
          [ sendSetters config import tokens daiFabOut

          , return
            ( { SAI_GEM = tokens.gem.address
              , SAI_GOV = tokens.gov.address
              , SAI_PIP = tokens.pip.address
              , SAI_PEP = tokens.pep.address
              , SAI_PIT = tokens.pitAddress
              , SAI_ADM = tokens.adm.address
              } ⫽ daiFabOut)
          ])
        ]
      )

in  { fab = fabModule
    , core = coreModule
    }
