module Components.Button exposing (defaultButtonConfig, defaultLinkConfig, defaultSubmitConfig, link, submit, view, withAction, withExtraStyles, withHref, withLabel, withLook)

import Css exposing (Style, active, backgroundColor, bold, border, borderColor, borderRadius, color, cursor, focus, fontWeight, hover, none, outline, padding, pointer, property, px, rem, textDecoration, unset)
import Html.Styled exposing (Attribute, Html, a, button, input, text)
import Html.Styled.Attributes exposing (css, href, type_)
import Html.Styled.Events exposing (onClick)
import Theme.Color as Color



-- MODEL


type Config msg variant
    = Config
        { look : Look
        , label : String
        , extraStyles : List Style
        }
        variant


defaultConfigFields :
    { look : Look
    , label : String
    , extraStyles : List Style
    }
defaultConfigFields =
    { look = Primary
    , label = "Click me!"
    , extraStyles = []
    }


type Button msg
    = Button (Maybe msg)


type Link
    = Link String


type Submit
    = Submit


type Look
    = Primary
    | Secondary
    | Outlined


withLook : Look -> Config msg a -> Config msg a
withLook look (Config fields variant) =
    Config { fields | look = look } variant


withLabel : String -> Config msg a -> Config msg a
withLabel label (Config fields variant) =
    Config { fields | label = label } variant


withExtraStyles : List Style -> Config msg a -> Config msg a
withExtraStyles extraStyles (Config fields variant) =
    Config { fields | extraStyles = fields.extraStyles ++ extraStyles } variant



-- BUTTON


defaultButtonConfig : Config msg (Button msg)
defaultButtonConfig =
    Config
        defaultConfigFields
        (Button Nothing)


withAction : msg -> Config msg (Button msg) -> Config msg (Button msg)
withAction onClickMsg (Config fields (Button _)) =
    Config fields (Button (Just onClickMsg))


view : Config msg (Button msg) -> Html msg
view (Config { look, label, extraStyles } (Button onClickMsg)) =
    let
        onClickAttr =
            case onClickMsg of
                Just msg ->
                    [ onClick msg ]

                Nothing ->
                    []

        styles =
            css (commonStyles look ++ extraStyles)
    in
    button
        (styles
            :: onClickAttr
        )
        [ text label ]



-- LINK


defaultLinkConfig : Config msg Link
defaultLinkConfig =
    Config
        defaultConfigFields
        (Link "#")


withHref : String -> Config msg Link -> Config msg Link
withHref href (Config fields (Link _)) =
    Config fields (Link href)


link : Config msg Link -> Html msg
link (Config { look, label, extraStyles } (Link href_)) =
    let
        styles =
            css (commonStyles look ++ extraStyles)
    in
    a
        [ styles
        , href href_
        ]
        [ text label ]



-- SUBMIT


defaultSubmitConfig : Config msg Submit
defaultSubmitConfig =
    Config
        defaultConfigFields
        Submit


submit : Config msg Submit -> Html msg
submit (Config { look, label, extraStyles } Submit) =
    let
        styles =
            css (commonStyles look ++ extraStyles)
    in
    input
        [ styles
        , type_ "submit"
        ]
        [ text label ]



-- STYLES


commonStyles : Look -> List Style
commonStyles look =
    (case look of
        Primary ->
            primaryStyle

        Secondary ->
            secondaryStyle

        Outlined ->
            outlinedStyle
    )
        ++ buttonStyle


buttonStyle : List Style
buttonStyle =
    let
        hoverStyle =
            hover
                [ property "filter" "brightness(0.95)"
                , cursor pointer
                ]

        focusStyle =
            focus
                [ outline none ]

        activeStyle =
            active
                [ outline none ]
    in
    [ color (Color.getHexColor Color.theme.neutral.greyDarkest)
    , fontWeight bold
    , textDecoration none
    , border (px 0)
    , borderRadius (rem 0.25)
    , padding (rem 1)
    , hoverStyle
    , focusStyle
    , activeStyle
    ]


primaryStyle : List Style
primaryStyle =
    [ backgroundColor (Color.getHexColor Color.theme.brand.primary)
    , borderColor (Color.getHexColor Color.theme.brand.primary)
    ]


secondaryStyle : List Style
secondaryStyle =
    [ backgroundColor (Color.getHexColor Color.theme.brand.secondary)
    , borderColor (Color.getHexColor Color.theme.brand.secondary)
    ]


outlinedStyle : List Style
outlinedStyle =
    [ backgroundColor unset
    ]
