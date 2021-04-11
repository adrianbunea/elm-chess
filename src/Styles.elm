module Styles exposing (..)

import Css exposing (Style, alignItems, center, displayFlex, height, justifyContent, pct, width)


container : List Style
container =
    [ displayFlex
    , alignItems center
    , justifyContent center
    , width (pct 100)
    , height (pct 100)
    ]
