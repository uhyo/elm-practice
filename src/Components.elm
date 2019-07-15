module Components exposing (app, page_container, page_wrapper)

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Util exposing (styles)


width =
    "320px"


height =
    "260px"


app children =
    div
        (styles
            [ ( "width", width )
            , ( "margin", "100px auto" )
            ]
        )
        children


page_container children =
    div
        (styles
            [ ( "position", "relative" )
            , ( "height", height )
            , ( "padding", "16px" )
            , ( "border", "1px solid #999999" )
            ]
        )
        children


page_wrapper attrs p =
    div
        (styles
            [ ( "position", "absolute" )
            , ( "width", "100%" )
            , ( "height", height )
            ]
            ++ attrs
        )
        p
