module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, article, button, div, h1, input, span, text)
import Html.Attributes exposing (value)
import Html.Events exposing (onClick, onInput)
import Page.Page1 as P1
import Page.Page2 as P2


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type Page
    = Page1 P1.Model
    | Page2 P2.Model


type alias Model =
    Page


init : Model
init =
    Page2 P2.init



-- UPDATE


type Msg
    = Page1Msg P1.Msg
    | Page2Msg P2.Msg


update : Msg -> Model -> Model
update msg model =
    let
        page =
            model
    in
    case ( msg, page ) of
        ( Page1Msg m, Page1 p ) ->
            Page1 <| P1.update m p

        ( Page2Msg m, Page2 p ) ->
            Page2 <| P2.update m p

        _ ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Page1 m ->
            P1.view m |> Html.map Page1Msg

        Page2 m ->
            P2.view m |> Html.map Page2Msg
