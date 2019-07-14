module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, button, div, span, text)
import Html.Events exposing (onClick)


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type Page
    = Page1 Int


type alias Model =
    Page


page1update : Msg -> Int -> Int
page1update msg counter =
    case msg of
        Page1Increment ->
            counter + 1

        Page1Decrement ->
            counter - 1


init : Model
init =
    Page1 0



-- UPDATE


type Msg
    = Page1Increment
    | Page1Decrement


update : Msg -> Model -> Model
update msg model =
    case model of
        Page1 v ->
            Page1 (page1update msg v)



-- VIEW


page1view : Int -> Html Msg
page1view counter =
    div []
        [ button [ onClick Page1Decrement ] [ text "-" ]
        , span [] [ text (" " ++ String.fromInt counter ++ " ") ]
        , button [ onClick Page1Increment ] [ text "+" ]
        ]


view : Model -> Html Msg
view model =
    case model of
        Page1 value ->
            page1view value
