module Pages.Menu exposing (..)

import Components.IntroForm as IntroForm
import Components.Menu as Menu
import Components.Modal as Modal exposing (Config, defaultConfig)
import Css exposing (Style, color, column, flexDirection, fontSize, rem)
import Html.Styled as Html exposing (Attribute, Html, div, h1, text)
import Html.Styled.Attributes exposing (css)
import Styles as Styles
import Theme.Color as Color



-- MODEL


type alias Model =
    { playerName : Maybe String
    , introFormConfig : IntroForm.Config
    , modalConfig : Modal.Config Msg
    }


type alias FormFields =
    { name : String
    }


type Msg
    = NoOp
    | GotIntroFormMsg IntroForm.Msg


init : ( Model, Cmd Msg )
init =
    let
        playerName =
            Nothing

        modalConfig =
            { defaultConfig
                | isVisible =
                    case playerName of
                        Just "" ->
                            True

                        Nothing ->
                            True

                        _ ->
                            False
            }

        model =
            { playerName = playerName
            , introFormConfig = IntroForm.defaultConfig
            , modalConfig = modalConfig
            }
    in
    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        welcomeMessage =
            case model.playerName of
                Just playerName ->
                    h1 [ css welcomeMessageStyles ] [ text ("Hi, " ++ playerName ++ "!") ]

                Nothing ->
                    text ""

        introForm =
            IntroForm.view model.introFormConfig |> Html.map GotIntroFormMsg

        modal =
            model.modalConfig
                |> Modal.view [ introForm ]
    in
    div [ css (flexDirection column :: Styles.container) ]
        [ welcomeMessage
        , Menu.view
        , modal
        ]


welcomeMessageStyles : List Style
welcomeMessageStyles =
    [ fontSize (rem 3)
    , color (Color.getHexColor Color.theme.neutral.greyDarkest)
    ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GotIntroFormMsg subMsg ->
            let
                newModel =
                    handleIntroFormMessage subMsg model
            in
            ( newModel, Cmd.none )


handleIntroFormMessage : IntroForm.Msg -> Model -> Model
handleIntroFormMessage subMsg model =
    let
        newIntroFormConfig =
            IntroForm.update subMsg model.introFormConfig

        newPlayerName =
            case subMsg of
                IntroForm.SaveName playerName ->
                    Just playerName

                _ ->
                    model.playerName

        modalConfig =
            model.modalConfig

        newModalConfig =
            case subMsg of
                IntroForm.SaveName _ ->
                    { modalConfig | isVisible = False }

                _ ->
                    modalConfig
    in
    { model
        | playerName = newPlayerName
        , introFormConfig = newIntroFormConfig
        , modalConfig = newModalConfig
    }
