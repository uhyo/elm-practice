module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Components exposing (app, page_container, page_wrapper)
import Footer
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
    { prevHistory : List Page
    , currentPage : Page
    , forwardHistory : List Page
    }


init : Model
init =
    { prevHistory = []
    , currentPage = Page2 P2.init
    , forwardHistory = []
    }



-- UPDATE


type Msg
    = Page1Msg P1.Msg
    | Page2Msg P2.Msg
    | FooterMsg Footer.Msg


goto : Page -> Model -> Model
goto page model =
    { prevHistory = model.currentPage :: model.prevHistory
    , currentPage = page
    , forwardHistory = []
    }


updateFooterMsg : Footer.Msg -> Model -> Model
updateFooterMsg msg model =
    case msg of
        Footer.GotoPage1 ->
            goto (Page1 P1.init) model

        Footer.GotoPage2 ->
            goto (Page2 P2.init) model

        Footer.Prev ->
            case model.prevHistory of
                [] ->
                    model

                last :: rest ->
                    { prevHistory = rest
                    , currentPage = last
                    , forwardHistory = model.currentPage :: model.forwardHistory
                    }

        Footer.Forward ->
            case model.forwardHistory of
                [] ->
                    model

                last :: rest ->
                    { prevHistory = model.currentPage :: model.prevHistory
                    , currentPage = last
                    , forwardHistory = rest
                    }


update : Msg -> Model -> Model
update msg model =
    let
        page =
            model.currentPage
    in
    case msg of
        FooterMsg m ->
            updateFooterMsg m model

        _ ->
            let
                page2 =
                    case ( msg, page ) of
                        ( Page1Msg m, Page1 p ) ->
                            Page1 <| P1.update m p

                        ( Page2Msg m, Page2 p ) ->
                            Page2 <| P2.update m p

                        _ ->
                            page
            in
            { model
                | currentPage = page2
            }



-- VIEW


renderPage : Page -> Html Msg
renderPage page =
    let
        pagev =
            case page of
                Page1 m ->
                    P1.view m |> Html.map Page1Msg

                Page2 m ->
                    P2.view m |> Html.map Page2Msg
    in
    page_wrapper [ pagev ]


view : Model -> Html Msg
view model =
    let
        footer_props =
            { prev_available = not <| List.isEmpty model.prevHistory
            , forward_available = not <| List.isEmpty model.forwardHistory
            }
    in
    app
        [ page_container [ renderPage model.currentPage ]
        , Footer.view footer_props |> Html.map FooterMsg
        ]
