module Components.Menu exposing (view)

import Components.Button as Button
import Css exposing (Style, alignItems, boxShadow5, center, column, displayFlex, flexDirection, fontSize, hover, justifyContent, minHeight, px, rem, scale, spaceAround, textAlign, transform, width)
import Css.Transitions as Transitions exposing (transition)
import Html.Styled exposing (Attribute, Html, nav)
import Html.Styled.Attributes exposing (css)
import Theme.Color as Color



-- VIEW


view : Html msg
view =
    nav [ css menuStyles ]
        menuOptions


menuOptions : List (Html msg)
menuOptions =
    [ Button.link
        (Button.defaultLinkConfig
            |> Button.withHref "play"
            |> Button.withLabel "Play"
            |> Button.withExtraStyles menuButtonStyles
        )
    , Button.link
        (Button.defaultLinkConfig
            |> Button.withLabel "Settings"
            |> Button.withExtraStyles menuButtonStyles
        )
    ]



-- STYLES


menuStyles : List Style
menuStyles =
    [ minHeight (px 200)
    , displayFlex
    , flexDirection column
    , alignItems center
    , justifyContent spaceAround
    ]


menuButtonStyles : List Style
menuButtonStyles =
    let
        hoverStyles =
            hover
                [ transform (scale 1.1) ]

        boxShadow =
            boxShadow5 (px 0) (px 4) (px 0) (px 0) (Color.colorToRgba Color.theme.neutral.black 0.2)
    in
    [ width (rem 10)
    , textAlign center
    , fontSize (rem 2)
    , boxShadow
    , transition [ Transitions.transform 350 ]
    , hoverStyles
    ]
