module Components.Board exposing (..)

import Components.Square as Square exposing (Square)
import Css exposing (Style, deg, preserve3d, property, rotate3d, transformStyle, transforms)
import Html.Styled exposing (Attribute, Html, div)
import Html.Styled.Attributes exposing (css)
import Styles as Style
import Types exposing (ChessColor(..))



-- MODEL


type Board
    = Board (List Square)


init : Board
init =
    let
        squares =
            [ 0, 1, 2, 3, 4, 5, 6, 7 ]
                |> List.map cols
                |> List.concat

        cols row =
            [ 0, 1, 2, 3, 4, 5, 6, 7 ]
                |> List.map (Square.init row)
    in
    Board squares



-- VIEW


view : ChessColor -> Board -> Html msg
view playerColor (Board squares) =
    let
        isRotated =
            case playerColor of
                White ->
                    False

                Black ->
                    True
    in
    div [ css (boardPerspectiveStyles ++ Style.container) ]
        [ div [ css (boardStyles isRotated) ]
            (List.map (Square.view isRotated) squares)
        ]



-- STYLES


boardStyles : Bool -> List Style
boardStyles isRotated =
    let
        boardTransforms =
            if isRotated then
                [ rotate3d 1 0 0 (deg 25), rotate3d 0 0 1 (deg 180) ]

            else
                [ rotate3d 1 0 0 (deg 25) ]
    in
    [ property "display" "grid"
    , property "grid-template-columns" "repeat(8, [col] 6vw)"
    , property "grid-template-rows" "repeat(8, [row] 6vw)"
    , property "grid-auto-flow" "row"
    , property "align-items" "stretch"
    , property "grid-gap" "1vw"
    , property "column-gap" "1vw"
    , property "row-gap" "1vw"

    -- elm/css doesn't support Grid :(
    , transformStyle preserve3d
    , transforms boardTransforms
    ]


boardPerspectiveStyles : List Style
boardPerspectiveStyles =
    [ property "perspective" "2000px"
    , property "perspective-origin" "50% 100%"

    -- elm/css doesn't support perspective too well
    ]
