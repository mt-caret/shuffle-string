module Main exposing (..)

import Html exposing (Html, Attribute, text, div, h1, input, button)
import Html.Attributes exposing (type_, style, value)
import Html.Events exposing (onClick, onInput)
import Random
import Random.Array
import Array


---- MODEL ----


type alias Model =
    { string : String
    , shuffledString : String
    }


init : ( Model, Cmd Msg )
init =
    let
        initString =
            "今日も一日がんばるゾイ"
    in
        ( Model initString "", shuffleString initString )



---- UPDATE ----


type Msg
    = NewString String
    | ShuffledString String
    | Shuffle


shuffleString : String -> Cmd Msg
shuffleString str =
    let
        stringToArray =
            Array.fromList << String.toList

        arrayToString =
            String.fromList << Array.toList

        shuffle =
            (Random.map arrayToString) << Random.Array.shuffle << stringToArray
    in
        Random.generate ShuffledString (shuffle str)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewString str ->
            ( { model | string = str }, Cmd.none )

        ShuffledString str ->
            ( { model | shuffledString = str }, Cmd.none )

        Shuffle ->
            ( model, shuffleString model.string )



---- VIEW ----


topLevelStyle : Attribute Msg
topLevelStyle =
    style [ ( "height", "100%" ) ]


fontStyleLarge : Attribute Msg
fontStyleLarge =
    style [ ( "font-size", "6vw" ) ]


fontStyleMedium : Attribute Msg
fontStyleMedium =
    style [ ( "font-size", "4vw" ) ]


flex : Attribute Msg
flex =
    style
        [ ( "display", "flex" )
        , ( "flex-direction", "column" )
        , ( "align-items", "center" )
        , ( "justify-content", "center" )
        ]


margin : Attribute Msg
margin =
    style
        [ ( "margin", "10px 0" ) ]


fitWidth : Attribute Msg
fitWidth =
    style [ ( "width", "100%" ) ]


view : Model -> Html Msg
view model =
    div [ flex, topLevelStyle, fitWidth ]
        [ h1 [ margin, fontStyleLarge ] [ text model.shuffledString ]
        , input [ margin, fontStyleMedium, type_ "text", onInput NewString, value model.string ] []
        , button [ margin, fontStyleMedium, onClick Shuffle ] [ text "shuffle" ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
