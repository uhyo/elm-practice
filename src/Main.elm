module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, article, button, div, h1, input, span, text)
import Html.Attributes exposing (value)
import Html.Events exposing (onClick, onInput)


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type Page
    = Page1 Int
    | Page2 String


type alias Model =
    Page


page1update : Msg -> Int -> Int
page1update msg counter =
    case msg of
        Page1Increment ->
            counter + 1

        Page1Decrement ->
            counter - 1

        _ ->
            counter


page2update : Msg -> String -> String
page2update msg text =
    case msg of
        Page2TextChange str ->
            str

        _ ->
            text


init : Model
init =
    Page2 "hi"



-- UPDATE


type Msg
    = Page1Increment
    | Page1Decrement
    | Page2TextChange String


update : Msg -> Model -> Model
update msg model =
    case model of
        Page1 v ->
            Page1 (page1update msg v)

        Page2 v ->
            Page2 (page2update msg v)



-- VIEW


pagewrapper : String -> List (Html m) -> Html m
pagewrapper title p =
    article []
        (h1
            []
            [ text title ]
            :: p
        )


page1view : Int -> Html Msg
page1view counter =
    pagewrapper "Counter Button"
        [ button [ onClick Page1Decrement ] [ text "-" ]
        , span [] [ text (" " ++ String.fromInt counter ++ " ") ]
        , button [ onClick Page1Increment ] [ text "+" ]
        ]


page2view : String -> Html Msg
page2view text =
    pagewrapper "Text Field"
        [ input [ value text, onInput Page2TextChange ] [] ]


view : Model -> Html Msg
view model =
    case model of
        Page1 value ->
            page1view value

        Page2 value ->
            page2view value
