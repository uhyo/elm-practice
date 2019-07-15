module Page.Common exposing (pagewrapper)

import Html exposing (Html, article, h1, text)


pagewrapper : String -> List (Html m) -> Html m
pagewrapper title p =
    article []
        (h1
            []
            [ text title ]
            :: p
        )
