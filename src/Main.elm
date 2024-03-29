module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Components exposing (app, page_container, page_wrapper)
import Footer
import Html exposing (Html, article, button, div, h1, input, span, text)
import Html.Attributes exposing (style, value)
import Html.Events exposing (onClick, onInput)
import Page.Page1 as P1
import Page.Page2 as P2
import Process
import Task


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- MODEL


type PageModel
    = Page1 P1.Model
    | Page2 P2.Model


type alias Page =
    ( String, PageModel )


type PageAnimation
    = None
    | Prev Bool
    | Forward Bool


isNone : PageAnimation -> Bool
isNone a =
    case a of
        None ->
            True

        _ ->
            False


type alias Model =
    { prevHistory : List Page
    , currentPage : Page
    , forwardHistory : List Page
    , animation : PageAnimation
    , nextPageId : Int
    }


init : Int -> ( Model, Cmd Msg )
init _ =
    ( { prevHistory = []
      , currentPage = ( "0", Page2 P2.init )
      , forwardHistory = []
      , animation = None
      , nextPageId = 1
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Page1Msg P1.Msg
    | Page2Msg P2.Msg
    | FooterMsg Footer.Msg
    | StartAnimation
    | EndAnimation


const x y =
    x


nextStartAnimation =
    Cmd.batch
        [ Process.sleep 20 |> Task.perform (const StartAnimation)
        , Process.sleep 300 |> Task.perform (const EndAnimation)
        ]


goto : PageModel -> Model -> ( Model, Cmd Msg )
goto page model =
    ( { prevHistory = model.currentPage :: model.prevHistory
      , currentPage = ( String.fromInt model.nextPageId, page )
      , forwardHistory = []
      , animation = Forward False
      , nextPageId = model.nextPageId + 1
      }
    , nextStartAnimation
    )


updateFooterMsg : Footer.Msg -> Model -> ( Model, Cmd Msg )
updateFooterMsg msg model =
    case msg of
        Footer.GotoPage1 ->
            goto (Page1 P1.init) model

        Footer.GotoPage2 ->
            goto (Page2 P2.init) model

        Footer.Prev ->
            case model.prevHistory of
                [] ->
                    ( model, Cmd.none )

                last :: rest ->
                    ( { model
                        | prevHistory = rest
                        , currentPage = last
                        , forwardHistory = model.currentPage :: model.forwardHistory
                        , animation = Prev False
                      }
                    , nextStartAnimation
                    )

        Footer.Forward ->
            case model.forwardHistory of
                [] ->
                    ( model, Cmd.none )

                last :: rest ->
                    ( { model
                        | prevHistory = model.currentPage :: model.prevHistory
                        , currentPage = last
                        , forwardHistory = rest
                        , animation = Forward False
                      }
                    , nextStartAnimation
                    )


updateStartAnimation : Model -> ( Model, Cmd Msg )
updateStartAnimation model =
    let
        newAnimation =
            case model.animation of
                Prev _ ->
                    Prev True

                Forward _ ->
                    Forward True

                a ->
                    a
    in
    ( { model | animation = newAnimation }, Cmd.none )


updateEndAnimation : Model -> ( Model, Cmd Msg )
updateEndAnimation model =
    ( { model | animation = None }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        page =
            model.currentPage
    in
    case msg of
        FooterMsg m ->
            updateFooterMsg m model

        StartAnimation ->
            updateStartAnimation model

        EndAnimation ->
            updateEndAnimation model

        _ ->
            let
                page2 =
                    case ( msg, page ) of
                        ( Page1Msg m, ( id, Page1 p ) ) ->
                            ( id, Page1 <| P1.update m p )

                        ( Page2Msg m, ( id, Page2 p ) ) ->
                            ( id, Page2 <| P2.update m p )

                        _ ->
                            page
            in
            ( { model
                | currentPage = page2
              }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


type PagePosition
    = PrevPosition
    | CurrentPosition
    | ForwardPosition


renderPage : Bool -> PagePosition -> Page -> ( String, Html Msg )
renderPage animating pos p =
    Tuple.mapSecond
        (\page ->
            let
                pagev =
                    case page of
                        Page1 m ->
                            P1.view m |> Html.map Page1Msg

                        Page2 m ->
                            P2.view m |> Html.map Page2Msg
            in
            let
                attrs =
                    case pos of
                        PrevPosition ->
                            [ style "transform" "translateX(-100%)" ]

                        CurrentPosition ->
                            [ style "transform" "translateX(0%)" ]

                        ForwardPosition ->
                            [ style "transform" "translateX(100%)" ]
            in
            let
                animAttrs =
                    if animating then
                        [ style "transition" "transform 0.3s ease-out" ]

                    else
                        []
            in
            page_wrapper (animAttrs ++ attrs) [ pagev ]
        )
        p


renderPages : Model -> List ( String, Html Msg )
renderPages model =
    let
        current =
            renderPage False CurrentPosition model.currentPage
    in
    case model.animation of
        None ->
            [ current ]

        Prev False ->
            List.head model.forwardHistory
                |> Maybe.map
                    (\lastPage ->
                        [ renderPage True PrevPosition model.currentPage
                        , renderPage True CurrentPosition lastPage
                        ]
                    )
                |> Maybe.withDefault [ current ]

        Prev True ->
            List.head model.forwardHistory
                |> Maybe.map
                    (\lastPage ->
                        [ renderPage True CurrentPosition model.currentPage
                        , renderPage True ForwardPosition lastPage
                        ]
                    )
                |> Maybe.withDefault [ current ]

        Forward False ->
            List.head model.prevHistory
                |> Maybe.map
                    (\lastPage ->
                        [ renderPage True CurrentPosition lastPage
                        , renderPage True ForwardPosition model.currentPage
                        ]
                    )
                |> Maybe.withDefault [ current ]

        Forward True ->
            List.head model.prevHistory
                |> Maybe.map
                    (\lastPage ->
                        [ renderPage True PrevPosition lastPage
                        , renderPage True CurrentPosition model.currentPage
                        ]
                    )
                |> Maybe.withDefault [ current ]


view : Model -> Html Msg
view model =
    let
        footer_props =
            { prev_available = isNone model.animation && not (List.isEmpty model.prevHistory)
            , forward_available = isNone model.animation && not (List.isEmpty model.forwardHistory)
            , goto_available = isNone model.animation
            }
    in
    app <|
        [ page_container <| renderPages model ]
            ++ [ Footer.view footer_props |> Html.map FooterMsg ]
