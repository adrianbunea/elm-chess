module Pages.Menu exposing (..)

import Components.Modal as Modal exposing (Config, defaultConfig)
import Html exposing (..)
import Html.Attributes exposing (class, placeholder, required, type_, value)
import Html.Events exposing (onInput, onSubmit)


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
    let
        title =
            h1 [ class "form__title" ] [ text "You're new here! First time?" ]

        nameInput =
            label [ class "form__label" ]
                [ input
                    [ class "form__input"
                    , value name
                    , placeholder "Please enter your name to continue..."
                    , onInput ChangeName
                    , required True
                    ]
                    []
                ]

        submitButton =
            input [ class "form__submit", type_ "submit" ] [ text "Continue" ]
    in
    form [ class "form", onSubmit SaveName ]
        [ title, nameInput, submitButton ]
