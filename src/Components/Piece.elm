module Components.Piece exposing (..)

import Css exposing (height, pct, position, relative, width)
import Html.Styled exposing (Attribute, Html, img)
import Html.Styled.Attributes exposing (css, src)
import Types exposing (ChessColor(..))


type Piece
    = Pawn ChessColor
    | Rook ChessColor
    | Knight ChessColor
    | Bishop ChessColor
    | Queen ChessColor
    | King ChessColor



-- VIEW


view : Piece -> Html msg
view piece =
    img [ pieceStyle, src (pieceToSVG piece) ] []


pieceStyle : Attribute msg
pieceStyle =
    css
        [ position relative
        , width (pct 100)
        , height (pct 100)
        ]


pieceToSVG : Piece -> String
pieceToSVG piece =
    let
        fileName =
            case piece of
                Pawn White ->
                    "white-pawn"

                Pawn Black ->
                    "black-pawn"

                Rook White ->
                    "white-rook"

                Rook Black ->
                    "black-rook"

                Knight White ->
                    "white-knight"

                Knight Black ->
                    "black-knight"

                Bishop White ->
                    "white-bishop"

                Bishop Black ->
                    "black-bishop"

                Queen White ->
                    "white-queen"

                Queen Black ->
                    "black-queen"

                King White ->
                    "white-king"

                King Black ->
                    "black-king"
    in
    "icons/chess-pieces/" ++ fileName ++ ".svg"
