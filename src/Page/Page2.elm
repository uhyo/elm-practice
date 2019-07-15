module Page.Page2 exposing (Model, Msg, init, update, view)

import Html exposing (Html, input)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)
import Page.Common exposing (pagewrapper)


type alias Model =
    String


type Msg
    = ChangeText String


init : Model
init =
    ""


update : Msg -> Model -> Model
update msg text =
    case msg of
        ChangeText value ->
            value


view : Model -> Html Msg
view text =
    pagewrapper "Text Field"
        [ input [ value text, onInput ChangeText ] [] ]
