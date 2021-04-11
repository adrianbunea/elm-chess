module Theme.Color exposing (Color, colorToRgba, getColor, getHexColor, theme)

import Color
import Color.Convert
import Css


type BrandColor
    = Primary Color.Color
    | PrimaryVariant Color.Color
    | Secondary Color.Color
    | SecondaryVariant Color.Color


type NeutralColor
    = White Color.Color
    | GreyLightest Color.Color
    | GreyLighter Color.Color
    | GreyLight Color.Color
    | Grey Color.Color
    | GreyDark Color.Color
    | GreyDarker Color.Color
    | GreyDarkest Color.Color
    | Black Color.Color


type Color
    = Brand BrandColor
    | Neutral NeutralColor


type alias ColorTheme =
    { brand :
        { primary : Color
        , primaryVariant : Color
        , secondary : Color
        , secondaryVariant : Color
        }
    , neutral :
        { black : Color
        , greyDark : Color
        , greyDarker : Color
        , greyDarkest : Color
        , grey : Color
        , greyLight : Color
        , greyLighter : Color
        , greyLightest : Color
        , white : Color
        }
    }


theme : ColorTheme
theme =
    { brand =
        { primary = alabaster
        , primaryVariant = platinum
        , secondary = melon
        , secondaryVariant = isabelline
        }
    , neutral =
        { white =
            Neutral
                (White
                    (Color.rgb 1 1 1)
                )
        , greyLightest =
            Neutral
                (GreyLightest
                    (Color.rgb255 243 244 245)
                )
        , greyLighter =
            Neutral
                (GreyLighter
                    (Color.rgb255 236 239 241)
                )
        , greyLight =
            Neutral
                (GreyLight
                    (Color.rgb255 189 197 204)
                )
        , grey =
            Neutral
                (Grey
                    (Color.rgb255 148 155 162)
                )
        , greyDark =
            Neutral
                (GreyDark
                    (Color.rgb255 128 139 140)
                )
        , greyDarker =
            Neutral
                (GreyDarker
                    (Color.rgb255 103 108 112)
                )
        , greyDarkest =
            Neutral
                (GreyDarkest
                    (Color.rgb255 72 71 70)
                )
        , black =
            Neutral
                (Black
                    (Color.rgb255 0 0 0)
                )
        }
    }


alabaster =
    Brand
        (Primary
            (Color.rgb255 216 226 220)
        )


platinum =
    Brand
        (PrimaryVariant
            (Color.rgb255 232 232 228)
        )


melon =
    Brand
        (Secondary
            (Color.rgb255 254 197 187)
        )


isabelline =
    Brand
        (SecondaryVariant
            (Color.rgb255 248 237 235)
        )


getBrandColor : BrandColor -> Color.Color
getBrandColor brandColor =
    case brandColor of
        Primary color ->
            color

        PrimaryVariant color ->
            color

        Secondary color ->
            color

        SecondaryVariant color ->
            color


getNeutralColor : NeutralColor -> Color.Color
getNeutralColor neutral =
    case neutral of
        White color ->
            color

        GreyLightest color ->
            color

        GreyLighter color ->
            color

        GreyLight color ->
            color

        Grey color ->
            color

        GreyDark color ->
            color

        GreyDarker color ->
            color

        GreyDarkest color ->
            color

        Black color ->
            color


getColor : Color -> Color.Color
getColor c =
    case c of
        Brand brandColor ->
            getBrandColor brandColor

        Neutral neutralColor ->
            getNeutralColor neutralColor


getHexColor : Color -> Css.Color
getHexColor =
    getColor >> Color.Convert.colorToHex >> Css.hex


colorToRgba : Color -> Float -> Css.Color
colorToRgba color alpha =
    let
        rgbaColor =
            Color.toRgba (getColor color)

        transparency =
            { rgbaColor | alpha = alpha }
    in
    Css.rgba (floor transparency.red) (floor transparency.green) (floor transparency.blue) transparency.alpha
