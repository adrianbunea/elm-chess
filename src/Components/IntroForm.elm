module Components.IntroForm exposing (State, getName, init, view)

import Components.Button as Button
import Components.Modal as Modal
import Css exposing (Style, alignItems, center, color, column, displayFlex, flexDirection, justifyContent, margin, marginBottom, maxWidth, padding, pct, px, rem, width)
import Html.Styled exposing (Html, form, h1, input, label, text)
import Html.Styled.Attributes exposing (css, placeholder, required, value)
import Html.Styled.Events exposing (onInput, onSubmit)
import Theme.Color as Color



-- MODEl


type State
    = State
        { name : String
        }


init : State
init =
    State
        { name = ""
        }



-- VIEW


view : (State -> msg) -> msg -> State -> Html msg
view toMsg saveMsg ((State { name }) as state) =
    let
        title =
            h1 [ css formTitleStyles ] [ text "You're new here! First time?" ]

        nameInput =
            label [ css formLabelStyles ]
                [ input
                    [ css formInputStyles
                    , value name
                    , placeholder "Please enter your name to continue..."
                    , onInput (ChangeName >> (\updatedNameMsg -> update updatedNameMsg state) >> toMsg)
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
    form [ css formStyles, onSubmit saveMsg ]
        [ title, nameInput, submitButton ]



-- UPDATE


type Msg
    = ChangeName String


update : Msg -> State -> State
update msg (State state) =
    case msg of
        ChangeName newName ->
            State { state | name = newName }



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



-- HELPERS


getName : State -> String
getName (State { name }) =
    name
