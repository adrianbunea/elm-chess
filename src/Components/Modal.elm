module Components.Modal exposing (Config, defaultConfig, view, withFooter, withHeader)

import Components.Icon as Icon
import Css exposing (Style, alignItems, animationDuration, animationName, auto, backgroundColor, bold, border3, borderBottom3, borderRadius, borderTop3, boxShadow5, center, color, cursor, display, displayFlex, fixed, float, focus, fontSize, fontWeight, height, hover, inline, int, justifyContent, left, margin, maxWidth, minWidth, none, overflow, padding, paddingBottom, pct, pointer, position, px, relative, rem, right, sec, solid, spaceBetween, textDecoration, top, width, zIndex)
import Css.Animations as Animations exposing (keyframes)
import Html.Styled exposing (Html, button, div, h1, text)
import Html.Styled.Attributes exposing (css, style)
import Html.Styled.Events exposing (onClick)
import Theme.Color as Color



-- MODEL


type alias Config msg =
    { isVisible : Bool
    , headerConfig : Maybe (HeaderConfig msg)
    , footerConfig : Maybe (FooterConfig msg)
    }


type alias HeaderConfig msg =
    { maybeTitle : Maybe String
    , closeMsg : msg
    }


type alias FooterConfig msg =
    { buttons : List (Html msg)
    }


defaultConfig : Config msg
defaultConfig =
    { isVisible = False
    , headerConfig = Nothing
    , footerConfig = Nothing
    }



-- VIEW


view : List (Html msg) -> Config msg -> Html msg
view content { isVisible, headerConfig, footerConfig } =
    let
        display =
            if isVisible then
                "flex"

            else
                "none"

        modalHeader =
            headerConfig
                |> Maybe.map header
                |> Maybe.withDefault (text "")

        modalBody =
            body content

        modalFooter =
            footerConfig
                |> Maybe.map footer
                |> Maybe.withDefault (text "")
    in
    div [ css modalStyles, style "display" display ]
        [ div [ css modalContentStyles ]
            [ modalHeader
            , modalBody
            , modalFooter
            ]
        ]


header : HeaderConfig msg -> Html msg
header { maybeTitle, closeMsg } =
    let
        title =
            maybeTitle
                |> Maybe.map (\value -> h1 [ css modalTitleStyles ] [ text value ])
                |> Maybe.withDefault (text "")
    in
    div [ css modalHeaderStyles ]
        [ title
        , button
            [ css closeButtonStyles
            , onClick closeMsg
            ]
            [ Icon.close ]
        ]


body : List (Html msg) -> Html msg
body content =
    div [ css modalBodyStyles ] content


footer : FooterConfig msg -> Html msg
footer { buttons } =
    div [ css modalFooterStyles ] buttons


withHeader : Maybe String -> msg -> Config msg -> Config msg
withHeader maybeTitle closeMsg config =
    { config | headerConfig = Just (HeaderConfig maybeTitle closeMsg) }


withFooter : List (Html msg) -> Config msg -> Config msg
withFooter buttons config =
    { config | footerConfig = Just (FooterConfig buttons) }



-- STYLES


modalStyles : List Style
modalStyles =
    [ displayFlex
    , alignItems center
    , justifyContent center
    , position fixed
    , zIndex (int 1)
    , left (px 0)
    , top (px 0)
    , width (pct 100)
    , height (pct 100)
    , overflow auto
    , backgroundColor (Color.colorToRgba Color.theme.neutral.greyDark 0.4)
    ]


modalContentStyles : List Style
modalContentStyles =
    [ position relative
    , minWidth (pct 45)
    , maxWidth (pct 80)
    , padding (rem 1)
    , backgroundColor (Color.getHexColor Color.theme.neutral.white)
    , border3 (px 1) solid (Color.getHexColor Color.theme.neutral.greyDarker)
    , borderRadius (rem 0.5)
    , boxShadow5 (px 0) (px 4) (px 8) (px 0) (Color.colorToRgba Color.theme.neutral.black 0.2)
    ]
        ++ animateTop


animateTop : List Style
animateTop =
    let
        animation =
            keyframes
                [ ( 0
                  , [ Animations.property "top" "-300px"
                    , Animations.opacity (int 0)
                    ]
                  )
                , ( 100
                  , [ Animations.property "top" "0"
                    , Animations.opacity (int 1)
                    ]
                  )
                ]
    in
    [ animationName animation
    , animationDuration (sec 0.4)
    ]


modalHeaderStyles : List Style
modalHeaderStyles =
    [ displayFlex
    , alignItems center
    , justifyContent spaceBetween
    , overflow auto
    , paddingBottom (rem 1)
    , borderBottom3 (px 1) solid (Color.getHexColor Color.theme.neutral.grey)
    ]


modalTitleStyles : List Style
modalTitleStyles =
    [ margin (px 0)
    , display inline
    ]


closeButtonStyles : List Style
closeButtonStyles =
    let
        hoverAndFocusStyles =
            [ color (Color.getHexColor Color.theme.neutral.black)
            , textDecoration none
            , cursor pointer
            ]
    in
    [ color (Color.getHexColor Color.theme.neutral.grey)
    , float right
    , fontSize (rem 2)
    , fontWeight bold
    , hover hoverAndFocusStyles
    , focus hoverAndFocusStyles
    ]


modalBodyStyles : List Style
modalBodyStyles =
    [ padding (rem 1) ]


modalFooterStyles : List Style
modalFooterStyles =
    [ padding (rem 1)
    , borderTop3 (px 1) solid (Color.getHexColor Color.theme.neutral.grey)
    ]
