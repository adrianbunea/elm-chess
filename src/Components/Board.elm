module Components.Board exposing (Board, Msg(..), init, update, view)

import Array exposing (Array)
import Components.Square as Square exposing (Square)
import Css exposing (Style, deg, preserve3d, property, rotate3d, transformStyle, transforms)
import Html.Styled as Html exposing (Attribute, Html, div)
import Html.Styled.Attributes exposing (css)
import Styles as Style
import Types exposing (ChessColor(..))



-- MODEL


type Board
    = Board (Matrix Square)


type alias Matrix a =
    Array (Array a)


init : Board
init =
    let
        squares =
            [ 0, 1, 2, 3, 4, 5, 6, 7 ]
                |> Array.fromList
                |> Array.map cols

        cols row =
            [ 0, 1, 2, 3, 4, 5, 6, 7 ]
                |> Array.fromList
                |> Array.map (Square.init row)
    in
    Board squares



-- VIEW


view : ChessColor -> Board -> Html Msg
view playerColor (Board squares) =
    let
        isRotated =
            case playerColor of
                White ->
                    False

                Black ->
                    True

        squareView square =
            square
                |> Square.view isRotated
                |> Html.map (GotSquareMsg square)

        squaresView =
            squares
                |> Array.toList
                |> List.map Array.toList
                |> List.concat
                |> List.map squareView
    in
    div [ css (boardPerspectiveStyles ++ Style.container) ]
        [ div [ css (boardStyles isRotated) ]
            squaresView
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



-- UPDATE


type Msg
    = GotSquareMsg Square Square.Msg


update : Msg -> Board -> ( Board, Cmd Msg )
update msg board =
    case msg of
        GotSquareMsg square subMsg ->
            let
                ( newSquare, squareCmd ) =
                    handleSquareMsg subMsg square
            in
            ( setSquare newSquare board, Cmd.map (GotSquareMsg square) squareCmd )


handleSquareMsg : Square.Msg -> Square -> ( Square, Cmd Square.Msg )
handleSquareMsg squareMsg square =
    Square.update squareMsg square



-- HELPERS


setSquare : Square -> Board -> Board
setSquare square (Board squares) =
    let
        { row, col } =
            Square.getPosition square

        squareCol =
            Array.get row squares

        newSquareCol =
            squareCol
                |> Maybe.map (Array.set col square)

        newBoard =
            case newSquareCol of
                Nothing ->
                    Board squares

                Just newSquareCol_ ->
                    squares
                        |> Array.set row newSquareCol_
                        |> Board
    in
    newBoard
