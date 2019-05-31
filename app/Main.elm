port module Main exposing (Model, Msg(..), init, main, rev, send, subscriptions, update, view)

import Browser
import Html exposing (Attribute, Html, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Json.Encode as Encode



-- Port


port send : ( Encode.Value, Encode.Value ) -> Cmd msg


port rev : (Float -> msg) -> Sub msg



-- Main


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- Model


type alias Model =
    { a : String
    , b : String
    , ans : Maybe Float
    }


init : () -> ( Model, Cmd msg )
init _ =
    ( Model "" "" Nothing, Cmd.none )



-- Update


type Msg
    = ChangeA String
    | ChangeB String
    | GetAns Float


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        ChangeA s ->
            ( { model | a = s, ans = Nothing }, sendPort s model.b )

        ChangeB s ->
            ( { model | b = s, ans = Nothing }, sendPort model.a s )

        GetAns ans ->
            ( { model | ans = Just ans }, Cmd.none )


sendPort : String -> String -> Cmd msg
sendPort a b =
    let
        toFloat : String -> Maybe Encode.Value
        toFloat v =
            Maybe.map Encode.float (String.toFloat v)
    in
    Maybe.withDefault Cmd.none <| Maybe.map send (Maybe.map2 Tuple.pair (toFloat a) (toFloat b))


subscriptions : Model -> Sub Msg
subscriptions _ =
    rev GetAns



-- View


view : Model -> Html Msg
view model =
    let
        viewAns =
            case model.ans of
                Just ans ->
                    text (String.fromFloat ans)

                Nothing ->
                    text ""
    in
    div []
        [ input [ value model.a, onInput ChangeA ] []
        , text " + "
        , input [ value model.b, onInput ChangeB ] []
        , text " = "
        , viewAns
        ]
