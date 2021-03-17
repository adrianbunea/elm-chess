module Pages.Play exposing (..)

import Html exposing (..)


type alias Model =
    { message : String
    }


type Msg
    = NoOp


init : ( Model, Cmd Msg )
init =
    let
        model =
            { message = "Let's play!"
            }
    in
    ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp -> ( model, Cmd.none )



-- VIEWS


view : Model -> Html Msg
view model =
    h1 [] [ text model.message ]
