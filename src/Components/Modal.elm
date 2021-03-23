module Components.Modal exposing (Config, defaultConfig, view, withFooter, withHeader)

import Components.Icon as Icon
import Html exposing (Html, button, div, h1, text)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)


type alias Config msg =
    { isVisible : Bool
    , headerConfig : Maybe (HeaderConfig msg)
    , footerConfig : Maybe (FooterConfig msg)
    }


type alias HeaderConfig msg =
    { maybeTitle : Maybe String
    , closeMsg : msg
    }


type alias FooterConfig msg =
    { buttons : List (Html msg)
    }


defaultConfig : Config msg
defaultConfig =
    { isVisible = False
    , headerConfig = Nothing
    , footerConfig = Nothing
    }


view : List (Html msg) -> Config msg -> Html msg
view content { isVisible, headerConfig, footerConfig } =
    let
        display =
            if isVisible then
                "flex"

            else
                "none"

        modalHeader =
            headerConfig
                |> Maybe.map header
                |> Maybe.withDefault (text "")

        modalBody =
            body content

        modalFooter =
            footerConfig
                |> Maybe.map footer
                |> Maybe.withDefault (text "")
    in
    div [ class "modal", style "display" display ]
        [ div [ class "modal__content" ]
            [ modalHeader
            , modalBody
            , modalFooter
            ]
        ]


header : HeaderConfig msg -> Html msg
header { maybeTitle, closeMsg } =
    let
        title =
            maybeTitle
                |> Maybe.map (\value -> h1 [] [ text value ])
                |> Maybe.withDefault (text "")
    in
    div [ class "modal__header" ]
        [ title
        , button
            [ class "close-button"
            , onClick closeMsg
            ]
            [ Icon.close ]
        ]


body : List (Html msg) -> Html msg
body content =
    div [ class "modal__body" ] content


footer : FooterConfig msg -> Html msg
footer { buttons } =
    div [ class "modal__footer" ] buttons


withHeader : Maybe String -> msg -> Config msg -> Config msg
withHeader maybeTitle closeMsg config =
    { config | headerConfig = Just (HeaderConfig maybeTitle closeMsg) }


withFooter : List (Html msg) -> Config msg -> Config msg
withFooter buttons config =
    { config | footerConfig = Just (FooterConfig buttons) }
