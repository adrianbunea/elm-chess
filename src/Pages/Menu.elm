module Pages.Menu exposing (..)

import Components.IntroForm as IntroForm
import Components.Menu as Menu
import Components.Modal as Modal exposing (Config, defaultConfig)
import Css exposing (Style, color, column, flexDirection, fontSize, rem)
import Html.Styled as Html exposing (Attribute, Html, div, h1, text)
import Html.Styled.Attributes exposing (css)
import Store exposing (Store)
import Styles as Styles
import Theme.Color as Color



-- MODEL


type alias Model =
    { store : Store
    , introFormConfig : IntroForm.Config
    , modalConfig : Modal.Config Msg
    }


type alias FormFields =
    { name : String
    }


type Msg
    = GotIntroFormMsg IntroForm.Msg


init : Store -> ( Model, Cmd Msg )
init store =
    let
        modalConfig =
            { defaultConfig
                | isVisible =
                    case store.playerName of
                        "" ->
                            True

                        _ ->
                            False
            }

        model =
            { store = store
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
            case model.store.playerName of
                "" ->
                    text ""

                playerName ->
                    h1 [ css welcomeMessageStyles ] [ text ("Hi, " ++ playerName ++ "!") ]

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
        GotIntroFormMsg subMsg ->
            let
                ( newModel, cmd ) =
                    handleIntroFormMessage subMsg model
            in
            ( newModel, cmd )


handleIntroFormMessage : IntroForm.Msg -> Model -> ( Model, Cmd Msg )
handleIntroFormMessage subMsg model =
    let
        newIntroFormConfig =
            IntroForm.update subMsg model.introFormConfig

        newPlayerName =
            case subMsg of
                IntroForm.SaveName playerName ->
                    playerName

                _ ->
                    model.store.playerName

        store =
            model.store

        newStore =
            { store | playerName = newPlayerName }

        modalConfig =
            model.modalConfig

        newModalConfig =
            case subMsg of
                IntroForm.SaveName _ ->
                    { modalConfig | isVisible = False }

                _ ->
                    modalConfig

        cmd =
            case subMsg of
                IntroForm.SaveName _ ->
                    Store.save newStore

                _ ->
                    Cmd.none
    in
    ( { model
        | store = newStore
        , introFormConfig = newIntroFormConfig
        , modalConfig = newModalConfig
      }
    , cmd
    )
