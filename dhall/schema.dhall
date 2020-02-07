let atd = ../atd/package

let Address = atd.Address

let DaiFabOutput =
      { SAI_SAI : Address
      , SAI_SIN : Address
      , SAI_SKR : Address
      , SAI_DAD : Address
      , SAI_MOM : Address
      , SAI_VOX : Address
      , SAI_TUB : Address
      , SAI_TAP : Address
      , SAI_TOP : Address
      }

in  { Config =
        { tub_cap : Natural
        , tub_mat : Natural
        , tub_tax : Natural
        , tub_fee : Natural
        , tub_axe : Natural
        , tub_gap : Natural
        , tap_gap : Natural
        , vox_way : Natural
        , vox_how : Natural
        , pipPrice : Natural
        , pepPrice : Natural
        }
    , Import =
        { gem : Optional Text
        , gov : Optional Text
        , pip : Optional Text
        , pep : Optional Text
        , adm : Optional Text
        , pit : Optional Text
        }
    , FabOutput =
        { GEM_FAB : Address
        , VOX_FAB : Address
        , TAP_FAB : Address
        , TUB_FAB : Address
        , TOP_FAB : Address
        , MOM_FAB : Address
        , DAD_FAB : Address
        }
    , DaiFabOutput = DaiFabOutput
    , CoreOutput =
          { SAI_GEM : Address
          , SAI_GOV : Address
          , SAI_PIP : Address
          , SAI_PEP : Address
          , SAI_PIT : Address
          , SAI_ADM : Address
          }
        ⩓ DaiFabOutput
    }
