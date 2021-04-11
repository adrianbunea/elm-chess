module Components.IntroForm exposing (..)

import Components.Button as Button
import Css exposing (Style, alignItems, center, color, column, displayFlex, flexDirection, justifyContent, margin, marginBottom, maxWidth, padding, pct, px, rem, width)
import Html.Styled exposing (Html, form, h1, input, label, text)
import Html.Styled.Attributes exposing (css, placeholder, required, value)
import Html.Styled.Events exposing (onInput, onSubmit)
import Theme.Color as Color



-- MODEl


type alias Config =
    { name : String
    }


defaultConfig : Config
defaultConfig =
    { name = "" }



-- VIEW


view : Config -> Html Msg
view { name } =
    let
        title =
            h1 [ css formTitleStyles ] [ text "You're new here! First time?" ]

        nameInput =
            label [ css formLabelStyles ]
                [ input
                    [ css formInputStyles
                    , value name
                    , placeholder "Please enter your name to continue..."
                    , onInput ChangeName
                    , required True
                    ]
                    []
                ]

        submitButton =
            Button.submit
                (Button.defaultSubmitConfig
                    |> Button.withLabel "Continue"
                )
    in
    form [ css formStyles, onSubmit (SaveName name) ]
        [ title, nameInput, submitButton ]



-- UPDATE


type Msg
    = ChangeName String
    | SaveName String


update : Msg -> Config -> Config
update msg config =
    case msg of
        ChangeName newName ->
            { config | name = newName }

        SaveName _ ->
            config



-- STYLES


formStyles : List Style
formStyles =
    [ margin (px 0)
    , width (pct 100)
    , displayFlex
    , flexDirection column
    , alignItems center
    , justifyContent center
    ]


formTitleStyles : List Style
formTitleStyles =
    [ color (Color.getHexColor Color.theme.neutral.greyDarkest) ]


formLabelStyles : List Style
formLabelStyles =
    [ marginBottom (rem 1)
    , width (pct 100)
    , maxWidth (px 400)
    ]


formInputStyles : List Style
formInputStyles =
    [ padding (rem 0.5)
    , width (pct 100)
    , color (Color.getHexColor Color.theme.neutral.greyDarkest)
    ]
