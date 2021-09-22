module Pages.Menu exposing (..)

import Components.IntroForm as IntroForm
import Components.Menu as Menu
import Components.Modal as Modal
import Css exposing (Style, color, column, flexDirection, fontSize, rem)
import Html.Styled as Html exposing (Attribute, Html, div, h1, text)
import Html.Styled.Attributes exposing (css)
import Store exposing (Store)
import Styles as Styles
import Theme.Color as Color



-- MODEL


type alias Model =
    { store : Store
    , modal : Modal.State
    , introForm : IntroForm.State
    }


type alias FormFields =
    { name : String
    }


init : Store -> ( Model, Cmd Msg )
init store =
    let
        modal =
            Modal.init
                |> (case store.playerName of
                        "" ->
                            Modal.open

                        _ ->
                            Modal.close
                   )

        model =
            { store = store
            , modal = modal
            , introForm = IntroForm.init
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
            IntroForm.view IntroFormChanged FormSaved model.introForm

        modal =
            model.modal
                |> Modal.view [ introForm ] Nothing Nothing
    in
    div [ css (flexDirection column :: Styles.container) ]
        [ welcomeMessage
        , Menu.view
        , modal
        ]



-- UPDATE


type Msg
    = IntroFormChanged IntroForm.State
    | FormSaved


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        IntroFormChanged introForm ->
            ( { model | introForm = introForm }, Cmd.none )

        FormSaved ->
            let
                store =
                    model.store

                playerName =
                    model.introForm |> IntroForm.getName

                modal =
                    model.modal |> Modal.close

                newStore =
                    { store | playerName = playerName }
            in
            ( { model | store = newStore, modal = modal }, Store.save newStore )



-- STYLES


welcomeMessageStyles : List Style
welcomeMessageStyles =
    [ fontSize (rem 3)
    , color (Color.getHexColor Color.theme.neutral.greyDarkest)
    ]
