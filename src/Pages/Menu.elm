module Pages.Menu exposing (..)

import Bootstrap.Button as Button
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Form exposing (group)
import Bootstrap.Form.Input as Input
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row
import Bootstrap.Modal as Modal
import Bootstrap.Utilities.Border as Border
import Bootstrap.Utilities.Display as Display
import Bootstrap.Utilities.Flex as Flex
import Bootstrap.Utilities.Size as Size
import Bootstrap.Utilities.Spacing as Spacing
import Html exposing (..)
import Html.Attributes exposing (for, required, style)
import Html.Events exposing (onSubmit)


type alias Model =
    { playerName : Maybe String
    , modalInfo : ModalInfo
    }


type alias ModalInfo =
    { playerName : String
    , visibility : Modal.Visibility
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

        modalInfo =
            { playerName = playerName
            , visibility =
                if playerName == "" then
                    Modal.shown

                else
                    Modal.hidden
            }

        model =
            { playerName = Nothing
            , modalInfo = modalInfo
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
                modalInfo =
                    model.modalInfo
            in
            ( { model | modalInfo = { modalInfo | playerName = inputValue } }, Cmd.none )

        SaveName ->
            let
                modalInfo =
                    model.modalInfo
            in
            ( { playerName = Just model.modalInfo.playerName
              , modalInfo = { modalInfo | playerName = "", visibility = Modal.hidden }
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
    in
    Grid.containerFluid [ Size.h100 ]
        [ Grid.row [ Row.middleXs, Row.middleSm, Row.middleMd, Row.middleLg, Row.middleXl ]
            [ Grid.col [] [ welcomeMessage, menuOptions, introModal model.modalInfo ]
            ]
        ]


menuOptions : Html Msg
menuOptions =
    Card.config
        [ Card.attrs
            [ Size.w75
            , Spacing.mxAuto
            , style "max-width" "40rem"
            ]
        ]
        |> Card.headerH1 [] [ text "Main Menu" ]
        |> Card.block [ Block.attrs [ Flex.block, Flex.col ] ]
            [ Block.custom (Button.linkButton [] [ text "Play" ])
            , Block.custom (Button.linkButton [] [ text "Settings" ])
            ]
        |> Card.view


introModal : ModalInfo -> Html Msg
introModal modalInfo =
    Modal.config NoOp
        |> Modal.centered True
        |> Modal.body [ Border.all, Border.rounded ]
            [ Grid.containerFluid []
                [ Grid.row []
                    [ Grid.col
                        []
                        [ introForm modalInfo.playerName
                        ]
                    ]
                ]
            ]
        |> Modal.view modalInfo.visibility


introForm : String -> Html Msg
introForm modalName =
    let
        title =
            h1 [ Spacing.mb5 ] [ text "Hi! First time? What's your name?" ]

        nameGroup =
            group []
                [ label [ for "name" ] []
                , Input.text
                    [ Input.id "name"
                    , Input.onInput ChangeName
                    , Input.placeholder "Name"
                    , Input.value modalName
                    , Input.attrs [ required True, Spacing.mb4 ]
                    ]
                ]

        submitButton =
            Button.submitButton
                [ Button.primary
                , Button.large
                , Button.attrs [ Spacing.mxAuto, Display.block ]
                ]
                [ text "Continue" ]
    in
    form [ onSubmit SaveName, Spacing.p4 ]
        [ title
        , nameGroup
        , submitButton
        ]
