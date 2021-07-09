module Pages.Play exposing (..)

import Components.Board as Board exposing (Board)
import Components.Button as Button
import Components.Square exposing (Square)
import Html.Styled as Html exposing (Html, div)
import Types exposing (ChessColor(..))



-- MODEl


type alias Model =
    { playerColor : ChessColor
    , playerTurn : ChessColor
    , selectedSquare : Maybe Square
    , board : Board
    }


init : ( Model, Cmd Msg )
init =
    let
        model =
            { playerColor = White
            , playerTurn = White
            , selectedSquare = Nothing
            , board = Board.init
            }
    in
    ( model, Cmd.none )



-- VIEWS


view : Model -> Html Msg
view model =
    let
        boardView =
            Board.view model.playerColor model.board
                |> Html.map GotBoardMsg
    in
    div []
        [ boardView
        , Button.view
            (Button.defaultButtonConfig
                |> Button.withLabel "Switch sides"
                |> Button.withAction SwitchSides
            )
        ]



-- UPDATE


type Msg
    = SwitchSides
    | GotBoardMsg Board.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SwitchSides ->
            let
                newPlayerColor =
                    case model.playerColor of
                        White ->
                            Black

                        Black ->
                            White
            in
            ( { model | playerColor = newPlayerColor }, Cmd.none )

        GotBoardMsg subMsg ->
            let
                ( newBoard, boardCmd ) =
                    handleBoardMsg subMsg model.board
            in
            ( { model | board = newBoard }, Cmd.map GotBoardMsg boardCmd )


handleBoardMsg : Board.Msg -> Board -> ( Board, Cmd Board.Msg )
handleBoardMsg boardMsg boardModel =
    Board.update boardMsg boardModel
