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


type alias Model =
    { a : String
    , b : String
    , ans : Maybe Float
    , n : String
    , is_prime : Maybe Bool
    }


init : () -> ( Model, Cmd msg )
init _ =
    ( Model "" "" Nothing "" Nothing, Cmd.none )



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
            ( { model | a = s, ans = Nothing }, sendPortAdd s model.b )

        ChangeB s ->
            ( { model | b = s, ans = Nothing }, sendPortAdd model.a s )

        GetAns ans ->
            ( { model | ans = Just ans }, Cmd.none )

        ChangeN s ->
            ( { model | n = s, is_prime = Nothing }, sendPortPrime s )

        GetPrime b ->
            ( { model | is_prime = Just b }, Cmd.none )


sendPortAdd : String -> String -> Cmd msg
sendPortAdd a b =
    let
        toFloat : String -> Maybe Encode.Value
        toFloat v =
            Maybe.map Encode.float (String.toFloat v)
    in
    Maybe.withDefault Cmd.none <| Maybe.map sendAdd (Maybe.map2 Tuple.pair (toFloat a) (toFloat b))


sendPortPrime : String -> Cmd msg
sendPortPrime s =
    if not (String.isEmpty s) && (String.toList s |> List.all Char.isDigit) then
        sendPrime (Encode.string s)

    else
        Cmd.none


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch [ revAdd GetAns, revPrime GetPrime ]



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

        viewPrime =
            case model.is_prime of
                Just b ->
                    if b then
                        text "is a prime!"

                    else
                        text "is not a prime"

                Nothing ->
                    text "is not a number"
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
