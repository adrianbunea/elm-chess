module Pages.Menu exposing (..)

import Components.Modal as Modal exposing (Config, defaultConfig)
import Html exposing (..)
import Html.Attributes exposing (class, for, required, style)
import Html.Events exposing (onSubmit)


type alias Model =
    { playerName : Maybe String
    , formFields : FormFields
    , modalConfig : Modal.Config Msg
    }


type alias FormFields =
    { name : String
    }


type Msg
    = NoOp
    | ChangeName String
    | SaveName


init : ( Model, Cmd Msg )
init =
    let
        playerName =
            ""

        modalConfig =
            { defaultConfig
                | isVisible =
                    if playerName == "" then
                        True

                    else
                        False
            }

        formFields =
            { name = ""
            }

        model =
            { playerName = Nothing
            , formFields = formFields
            , modalConfig = modalConfig
            }
    in
    ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ChangeName inputValue ->
            let
                formFields =
                    model.formFields
            in
            ( { model | formFields = { formFields | name = inputValue } }, Cmd.none )

        SaveName ->
            let
                modalConfig =
                    model.modalConfig
            in
            ( { playerName = Just model.formFields.name
              , formFields = model.formFields
              , modalConfig = { modalConfig | isVisible = False }
              }
            , Cmd.none
            )



-- VIEWS


view : Model -> Html Msg
view model =
    let
        welcomeMessage =
            case model.playerName of
                Just playerName ->
                    h1 [] [ text playerName ]

                Nothing ->
                    text ""

        modal =
            model.modalConfig
                |> Modal.view [ introForm model.formFields ]
    in
    div [ class "container" ]
        [ welcomeMessage
        , modal
        ]


menuOptions : Html Msg
menuOptions =
    text ""


introForm : FormFields -> Html Msg
introForm { name } =
    text "name"
