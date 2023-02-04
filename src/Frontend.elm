port module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Data
import Element as E exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Expression
import Html exposing (Html)
import Html.Attributes as Attr
import Lamdera
import Task
import Theme
import Types exposing (..)
import Url
import VegaLite as V


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \m -> Sub.none
        , view = view
        }


send : msg -> Cmd msg
send msg =
    Task.succeed msg
        |> Task.perform identity


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key
      , message = "Welcome to Lamdera! You're looking at the auto-generated base implementation. Check out src/Frontend.elm to start coding!"
      , sourceText = Data.initialText
      }
      --, send Do_VegaLiteOp
    , Cmd.none
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        UrlClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            ( model, Cmd.none )

        NoOpFrontendMsg ->
            ( model, Cmd.none )

        Do_VegaLiteOp ->
            ( model, vegaLiteElmToJs <| toVegaLiteSpec model )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )


view : Model -> Browser.Document FrontendMsg
view model =
    { title = "KaTeX!"
    , body =
        [ layout
            [ Font.size 20 ]
            (viewElements model)
        ]
    }


viewElements : Model -> Element FrontendMsg
viewElements model =
    column
        [ width fill
        , height fill
        , centerX
        , Border.width 1
        , Border.color Theme.black
        , spacing 5
        ]
        [ viewScriptaDemo model
        , el [ centerX ] <| E.text "Now let's try a Vega-Lite plot, click button to trigger port"
        , Input.button
            [ padding 3
            , Border.rounded 9
            , Border.width 3
            , Border.color Theme.gray
            , centerX
            ]
            { onPress = Just Do_VegaLiteOp
            , label =
                el
                    [ clip
                    , Border.rounded 6
                    ]
                <|
                    E.text "Click to Render!"
            }
        , viewVegaLiteElements model
        , el [ centerX ] <| E.text "=("
        ]


viewScriptaDemo : Model -> Element FrontendMsg
viewScriptaDemo model =
    el
        [ centerX
        ]
    <|
        E.html (Expression.compile model.sourceText)


viewVegaLiteElements : Model -> Element FrontendMsg
viewVegaLiteElements model =
    el
        [ E.htmlAttribute (Attr.id "vega-lite-viz")
        , width (px 250)
        , centerX
        , height (px 250)
        , Border.width 1
        , Border.color Theme.black
        ]
        E.none


toVegaLiteSpec : Model -> V.Spec
toVegaLiteSpec _ =
    let
        data =
            V.dataFromColumns []
                << V.dataColumn "x" (V.nums [ 10, 20, 30 ])

        enc =
            V.encoding
                << V.position V.X [ V.pName "x", V.pQuant ]
    in
    V.toVegaLite
        [ V.title "Hello, World!" []
        , data []
        , enc []
        , V.circle []
        ]


port vegaLiteElmToJs : V.Spec -> Cmd msg
