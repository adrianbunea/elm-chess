module Components.Square exposing (..)

import Components.Piece as Piece exposing (Piece(..))
import Css exposing (Style, backgroundColor, borderRadius, boxShadow5, deg, hover, px, rem, rotate3d, transforms, translate3d)
import Css.Transitions as Transitions exposing (transition)
import Html.Styled exposing (Attribute, Html, div, text)
import Html.Styled.Attributes exposing (css)
import Theme.Color as Color
import Types exposing (ChessColor(..))



-- MODEL


type Square
    = Square { row : Int, col : Int } (Maybe Piece)


init : Int -> Int -> Square
init row col =
    let
        piece =
            case ( row, col ) of
                ( 7, 0 ) ->
                    Just (Rook White)

                ( 7, 7 ) ->
                    Just (Rook White)

                ( 7, 1 ) ->
                    Just (Knight White)

                ( 7, 6 ) ->
                    Just (Knight White)

                ( 7, 2 ) ->
                    Just (Bishop White)

                ( 7, 5 ) ->
                    Just (Bishop White)

                ( 7, 3 ) ->
                    Just (King White)

                ( 7, 4 ) ->
                    Just (Queen White)

                ( 6, _ ) ->
                    Just (Pawn White)

                ( 0, 0 ) ->
                    Just (Rook Black)

                ( 0, 7 ) ->
                    Just (Rook Black)

                ( 0, 1 ) ->
                    Just (Knight Black)

                ( 0, 6 ) ->
                    Just (Knight Black)

                ( 0, 2 ) ->
                    Just (Bishop Black)

                ( 0, 5 ) ->
                    Just (Bishop Black)

                ( 0, 3 ) ->
                    Just (King Black)

                ( 0, 4 ) ->
                    Just (Queen Black)

                ( 1, _ ) ->
                    Just (Pawn Black)

                _ ->
                    Nothing
    in
    Square { row = row, col = col } piece


setPiece : Square -> Piece -> Square
setPiece (Square { row, col } _) newPiece =
    Square { row = row, col = col } (Just newPiece)



-- VIEW


view : Bool -> Square -> Html msg
view isRotated (Square { row, col } piece) =
    let
        squareColor =
            if modBy 2 (row + col) == 0 then
                White

            else
                Black

        pieceIcon =
            case piece of
                Just value ->
                    Piece.view value

                Nothing ->
                    text ""
    in
    div
        [ css (squareStyles isRotated squareColor)
        ]
        [ pieceIcon
        ]



-- STYLES


squareStyles : Bool -> ChessColor -> List Style
squareStyles isRotated squareColor =
    let
        squareBackgroundColor =
            case squareColor of
                White ->
                    Color.getHexColor Color.theme.brand.primaryVariant

                Black ->
                    Color.getHexColor Color.theme.neutral.greyDarkest

        rotationTransforms =
            if isRotated then
                [ rotate3d 0 0 1 (deg 180) ]

            else
                []

        hoverStyles =
            [ boxShadow5 (px 0) (px 7) (px 4) (px 0) (Color.getHexColor Color.theme.neutral.greyDarker)
            , if isRotated then
                transforms
                    (rotationTransforms ++ [ translate3d (px 0) (px 0) (px -20) ])

              else
                transforms
                    [ translate3d (px 0) (px 0) (px -20)
                    ]
            ]
    in
    [ backgroundColor squareBackgroundColor
    , borderRadius (rem 1)
    , boxShadow5 (px 0) (px 12) (px 8) (px 0) (Color.getHexColor Color.theme.neutral.greyDark)
    , transforms rotationTransforms
    , transition [ Transitions.transform 250, Transitions.boxShadow 250 ]
    , hover hoverStyles
    ]
