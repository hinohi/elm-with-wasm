port module Main exposing (Model, Msg(..), init, main, revAdd, sendAdd, subscriptions, update, view)

import Browser
import Html exposing (Attribute, Html, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Json.Encode as Encode



-- Port


port sendAdd : ( Encode.Value, Encode.Value ) -> Cmd msg


port revAdd : (Float -> msg) -> Sub msg


port sendPrime : Encode.Value -> Cmd msg


port revPrime : (Bool -> msg) -> Sub msg



-- Main


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- Model


type Ans a
    = NoAns
    | Pending
    | Ans a


type alias Model =
    { a : String
    , b : String
    , add : Ans Float
    , n : String
    , is_prime : Ans Bool
    }


init : () -> ( Model, Cmd msg )
init _ =
    ( Model "" "" NoAns "" NoAns, Cmd.none )



-- Update


type Msg
    = ChangeA String
    | ChangeB String
    | GetAns Float
    | ChangeN String
    | GetPrime Bool


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        ChangeA s ->
            let
                ( cmd, post ) =
                    sendPortAdd s model.b
            in
            ( { model | a = s, add = post }, cmd )

        ChangeB s ->
            let
                ( cmd, post ) =
                    sendPortAdd model.a s
            in
            ( { model | b = s, add = post }, cmd )

        GetAns ans ->
            ( { model | add = Ans ans }, Cmd.none )

        ChangeN s ->
            let
                ( cmd, post ) =
                    sendPortPrime s
            in
            case model.is_prime of
                Pending ->
                    ( model, Cmd.none )

                _ ->
                    ( { model | n = s, is_prime = post }, cmd )

        GetPrime b ->
            ( { model | is_prime = Ans b }, Cmd.none )


sendPortAdd : String -> String -> ( Cmd msg, Ans Float )
sendPortAdd a b =
    let
        toFloat : String -> Maybe Encode.Value
        toFloat v =
            Maybe.map Encode.float (String.toFloat v)
    in
    case Maybe.map sendAdd (Maybe.map2 Tuple.pair (toFloat a) (toFloat b)) of
        Just pair ->
            ( pair, Pending )

        Nothing ->
            ( Cmd.none, NoAns )


sendPortPrime : String -> ( Cmd msg, Ans Bool )
sendPortPrime s =
    if not (String.isEmpty s) && (String.toList s |> List.all Char.isDigit) then
        ( sendPrime (Encode.string s), Pending )

    else
        ( Cmd.none, NoAns )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch [ revAdd GetAns, revPrime GetPrime ]



-- View


view : Model -> Html Msg
view model =
    let
        viewAns =
            case model.add of
                NoAns ->
                    text ""

                Pending ->
                    text "??"

                Ans ans ->
                    text (String.fromFloat ans)

        viewPrime =
            case model.is_prime of
                Ans b ->
                    if b then
                        text " is a prime!"

                    else
                        text " is not a prime"

                NoAns ->
                    text " is not a number"

                Pending ->
                    text " calculating..."
    in
    div []
        [ div []
            [ input [ value model.a, onInput ChangeA ] []
            , text " + "
            , input [ value model.b, onInput ChangeB ] []
            , text " = "
            , viewAns
            ]
        , div []
            [ input [ value model.n, onInput ChangeN ] []
            , viewPrime
            ]
        ]
