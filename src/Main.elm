module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Html.Styled as Html exposing (Html, h3, text)
import Pages.Menu as Menu
import Pages.Play as Play
import Route exposing (Route)
import Store exposing (Store)
import Url exposing (Url)


type alias Flags =
    { playerName : String
    }


type alias Model =
    { route : Route
    , page : Page
    , navKey : Nav.Key
    , store : Store
    }


type Page
    = NotFoundPage
    | MenuPage Menu.Model
    | PlayPage Play.Model


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }



-- MODEL


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        model =
            { route = Route.parseUrl url
            , page = NotFoundPage
            , navKey = navKey
            , store = flags
            }
    in
    initCurrentPage ( model, Cmd.none )


initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, existingCmds ) =
    let
        ( currentPage, mappedPageCmds ) =
            case model.route of
                Route.NotFound ->
                    ( NotFoundPage, Cmd.none )

                Route.Menu ->
                    let
                        ( pageModel, pageCmds ) =
                            Menu.init model.store
                    in
                    ( MenuPage pageModel, Cmd.map MenuPageMsg pageCmds )

                Route.Play ->
                    let
                        ( pageModel, pageCmds ) =
                            Play.init
                    in
                    ( PlayPage pageModel, Cmd.map PlayPageMsg pageCmds )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCmds, mappedPageCmds ]
    )



-- UPDATE


type Msg
    = LinkClicked UrlRequest
    | UrlChanged Url
    | MenuPageMsg Menu.Msg
    | PlayPageMsg Play.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        ( UrlChanged url, _ ) ->
            let
                newRoute =
                    Route.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )
                |> initCurrentPage

        ( MenuPageMsg subMsg, MenuPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    Menu.update subMsg pageModel
            in
            ( { model | page = MenuPage updatedPageModel }
            , Cmd.map MenuPageMsg updatedCmd
            )

        ( PlayPageMsg subMsg, PlayPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    Play.update subMsg pageModel
            in
            ( { model | page = PlayPage updatedPageModel }
            , Cmd.map PlayPageMsg updatedCmd
            )

        _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Chess Game"
    , body = [ currentView model |> Html.toUnstyled ]
    }


currentView : Model -> Html Msg
currentView model =
    case model.page of
        NotFoundPage ->
            notFoundView

        MenuPage pageModel ->
            Menu.view pageModel
                |> Html.map MenuPageMsg

        PlayPage pageModel ->
            Play.view pageModel
                |> Html.map PlayPageMsg


notFoundView : Html msg
notFoundView =
    h3 [] [ text "Oops! The page you requested was not found!" ]
