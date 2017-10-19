module Main exposing (..)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type TrafficLight
    = Red
    | RedAmber
    | Green
    | Amber


advance : TrafficLight -> TrafficLight
advance light =
    case light of
        Red ->
            RedAmber

        RedAmber ->
            Green

        Green ->
            Amber

        Amber ->
            Red


type alias Model =
    TrafficLight


init : ( Model, Cmd Msg )
init =
    ( Red, Cmd.none )



-- UPDATE


type Msg
    = Advance Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Advance _ ->
            ( advance model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Advance



-- VIEW


view : Model -> Html Msg
view model =
    let
        red =
            if model == Red || model == RedAmber then
                "url(#redGradient)"
            else
                "#222"

        amber =
            if model == Amber || model == RedAmber then
                "url(#amberGradient)"
            else
                "#222"

        green =
            if model == Green then
                "url(#greenGradient)"
            else
                "#222"
    in
    svg
        [ width "100", height "300", viewBox "0 0 100 100" ]
        [ defs []
            [ radialGradient [ id "redGradient", cx "50%", cy "50%", r "50%" ]
                [ stop [ offset "0%", stopColor "#ffaa44" ] []
                , stop [ offset "100%", stopColor "#ee0000" ] []
                ]
            , radialGradient [ id "amberGradient", cx "50%", cy "50%", r "50%" ]
                [ stop [ offset "0%", stopColor "#ffe000" ] []
                , stop [ offset "100%", stopColor "#ffa200" ] []
                ]
            , radialGradient [ id "greenGradient", cx "50%", cy "50%", r "50%" ]
                [ stop [ offset "0%", stopColor "#3eff1b" ] []
                , stop [ offset "100%", stopColor "#29a912" ] []
                ]
            ]
        , rect [ x "0", y "-100", width "100", height "300", rx "15", ry "15" ] []
        , circle [ cx "50", cy "-50", r "35", fill red, stroke "white", strokeWidth "3" ] []
        , circle [ cx "50", cy "50", r "35", fill amber, stroke "white", strokeWidth "3" ] []
        , circle [ cx "50", cy "150", r "35", fill green, stroke "white", strokeWidth "3" ] []
        ]
