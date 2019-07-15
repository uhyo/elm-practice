module Page.Page1 exposing (Model, Msg, init, update, view)

import Html exposing (Html, button, span, text)
import Html.Events exposing (onClick)
import Page.Common exposing (pagewrapper)


type alias Model =
    Int


type Msg
    = Increment
    | Decrement


init : Model
init =
    0


update : Msg -> Model -> Model
update msg counter =
    case msg of
        Increment ->
            counter + 1

        Decrement ->
            counter - 1


view : Model -> Html Msg
view counter =
    pagewrapper "Counter Button"
        [ button [ onClick Decrement ] [ text "-" ]
        , span [] [ text (" " ++ String.fromInt counter ++ " ") ]
        , button [ onClick Increment ] [ text "+" ]
        ]
