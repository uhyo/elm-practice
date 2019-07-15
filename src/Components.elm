module Components exposing (app, page_wrapper)

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Util exposing (styles)


app children =
    div
        (styles
            [ ( "width", "320px" )
            , ( "margin", "100px auto" )
            ]
        )
        children


page_wrapper p =
    div
        (styles
            [ ( "height", "260px" )
            , ( "padding", "16px" )
            , ( "border", "1px solid #999999" )
            ]
        )
        p