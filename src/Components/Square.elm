module Components.Square exposing (Msg(..), Square, getPosition, init, setPiece, update, view)

import Components.Piece as Piece exposing (Piece(..))
import Css exposing (Style, backgroundColor, borderRadius, borderStyle, boxShadow5, deg, hover, none, px, rem, rotate3d, transforms, translate3d)
import Css.Transitions as Transitions exposing (transition)
import Html.Styled exposing (Attribute, Html, button, div, text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Theme.Color as Color
import Types exposing (ChessColor(..))



-- MODEL


type Square
    = Square Attributes (Maybe Piece)


type alias Attributes =
    { row : Int
    , col : Int
    , selected : Bool
    }


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
                    Just (Queen White)

                ( 7, 4 ) ->
                    Just (King White)

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
                    Just (Queen Black)

                ( 0, 4 ) ->
                    Just (King Black)

                ( 1, _ ) ->
                    Just (Pawn Black)

                _ ->
                    Nothing
    in
    Square
        { row = row
        , col = col
        , selected = False
        }
        piece


setPiece : Square -> Piece -> Square
setPiece (Square attributes _) newPiece =
    Square attributes (Just newPiece)



-- VIEW


view : Bool -> Square -> Html Msg
view isRotated (Square attributes piece) =
    let
        squareColor =
            if modBy 2 (attributes.row + attributes.col) == 0 then
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
    button
        [ onClick Touched
        , css (squareStyles attributes isRotated squareColor)
        ]
        [ pieceIcon
        ]



-- STYLES


squareStyles : Attributes -> Bool -> ChessColor -> List Style
squareStyles attributes isRotated squareColor =
    let
        squareBackgroundColor =
            case ( squareColor, attributes.selected ) of
                ( White, False ) ->
                    Color.getHexColor Color.theme.brand.primaryVariant

                ( Black, False ) ->
                    Color.getHexColor Color.theme.neutral.greyDarkest

                ( _, True ) ->
                    Color.getHexColor Color.theme.brand.secondary

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
    , borderStyle none
    , borderRadius (rem 1)
    , boxShadow5 (px 0) (px 12) (px 8) (px 0) (Color.getHexColor Color.theme.neutral.greyDark)
    , transforms rotationTransforms
    , transition [ Transitions.transform 250, Transitions.boxShadow 250 ]
    , hover hoverStyles
    ]



-- UPDATE


type Msg
    = Touched


update : Msg -> Square -> ( Square, Cmd Msg )
update msg square =
    case msg of
        Touched ->
            let
                selected =
                    getSelected square |> not

                newSquare =
                    setSelected selected square
            in
            ( newSquare, Cmd.none )



-- HELPERS


getSelected : Square -> Bool
getSelected (Square { selected } _) =
    selected


setSelected : Bool -> Square -> Square
setSelected selected (Square attributes piece) =
    Square { attributes | selected = selected } piece


getPosition : Square -> { row : Int, col : Int }
getPosition (Square { row, col } _) =
    { row = row, col = col }
