module Components.Icon exposing (close)

import Html.Styled exposing (Html, span, text)
import Html.Styled.Attributes exposing (class)


icon : String -> Html msg
icon iconName =
    span
        [ class "material-icons" ]
        [ text iconName ]


close : Html msg
close =
    icon "close"
