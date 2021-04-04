module Pages.Play exposing (..)

import Components.Board as Board exposing (Board)
import Components.Square exposing (Square)
import Html.Styled exposing (Html, button, div, text)
import Html.Styled.Events exposing (onClick)
import Types exposing (ChessColor(..))


type alias Model =
    { playerColor : ChessColor
    , playerTurn : ChessColor
    , selectedSquare : Maybe Square
    , board : Board
    }


type Msg
    = SwitchSides
    | NoOp


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

        NoOp ->
            ( model, Cmd.none )



-- VIEWS


view : Model -> Html Msg
view model =
    div []
        [ Board.view model.playerColor model.board
        , button [ onClick SwitchSides ] [ text "Switch sides" ]
        ]
