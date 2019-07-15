module Footer exposing (Msg, view)

import Html exposing (Html, button, div, text)
import Html.Attributes exposing (disabled)
import Html.Events exposing (onClick)
import Util exposing (styles)


type alias ViewProps =
    { prev_available : Bool
    , forward_available : Bool
    }


type Msg
    = Prev
    | Forward
    | GotoPage1
    | GotoPage2


flex_button attrs txt =
    button
        (attrs
            ++ styles
                [ ( "flex", "auto 1 1" )
                ]
        )
        [ text txt ]


view : ViewProps -> Html Msg
view props =
    div
        (styles
            [ ( "display", "flex" )
            , ( "height", "2em" )
            ]
        )
        [ flex_button
            [ disabled (not props.prev_available)
            , onClick Prev
            ]
            "←"
        , flex_button
            [ disabled (not props.forward_available)
            , onClick Forward
            ]
            "→"
        , flex_button
            [ onClick GotoPage1 ]
            "Page 1"
        , flex_button
            [ onClick GotoPage2 ]
            "Page 2"
        ]
