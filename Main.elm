module Main exposing (..)

import Html exposing (Html, Attribute, text, div, h1, p, input, button)
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


columnFlex : Attribute Msg
columnFlex =
    style
        [ ( "display", "flex" )
        , ( "flex-direction", "column" )
        , ( "align-items", "center" )
        ]


rowFlex : Attribute Msg
rowFlex =
    style
        [ ( "display", "flex" )
        , ( "flex-direction", "row" )
        ]


view : Model -> Html Msg
view model =
    div [ columnFlex ]
        [ h1 [] [ text "shuffle string" ]
        , input [ type_ "text", onInput NewString, value model.string ] []
        , p [] [ text model.shuffledString ]
        , button [ onClick Shuffle ] [ text "shuffle" ]
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
