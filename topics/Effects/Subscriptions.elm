module Effects.Subscriptions exposing (..)

{-
Commands work greak for one-time things like HTTP requests or Random number generators.

What about when things happen repeatedly, or when things get pushed to you? Things like websockets, timers, scroll events, etc?

For that, we use Subscriptions.

A `Sub` is like a `Cmd`, in that it is a data structure that represents some kind of side effect that Elm will run and turn in to a `Msg` to your `update` function.

LINK TO GUIDE: http://guide.elm-lang.org/architecture/effects/time.html

-}

import Html exposing (Html)
import Html.App as App
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)
import Task
import Http


main : Program Never
main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
    { time: Time
    , isItChristmas : Maybe String
    , error : Maybe String
    , isLoading : Bool
    }


init : (Model, Cmd Msg)
init =
  ({ time = 0, isItChristmas = Nothing, error = Nothing, isLoading = False}, Cmd.none)


-- UPDATE

type Msg
  = Tick Time
  | CheckChristmas
  | IsItChristmas String
  | RequestError


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
        ( { model | time = newTime }, Cmd.none)

    CheckChristmas ->
        ( { model | isLoading = True }, checkChristmasStatus)

    IsItChristmas str ->
        ( { model | isItChristmas = Just str, error = Nothing, isLoading = False }, Cmd.none )

    RequestError ->
        ( { model | isItChristmas = Nothing, error = Just "OH NO AN ERROR", isLoading = False }, Cmd.none )

checkChristmasStatus : Cmd Msg
checkChristmasStatus =
    Task.perform (always RequestError) IsItChristmas <| Http.getString "https://is-it-christmas-api-bjpuutprrl.now.sh/is-it-christmas"


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [
     Time.every second Tick
    ,Time.every (10 * second) (always CheckChristmas)
    ]


-- VIEW

view : Model -> Html Msg
view model =
  let
    angle =
      turns (Time.inMinutes model.time)

    handX =
      toString (50 + 40 * cos angle)

    handY =
      toString (50 + 40 * sin angle)
  in
    Html.div [] [
        svg [ viewBox "0 0 100 100", width "300px" ]
          [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
          , line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke "#023963" ] []
          ]
    , Html.div [] [ text
        (case  model.isItChristmas of
            Nothing ->
                if model.isLoading then
                    "Loading"
                else
                    "WHO CAN SAY"

            Just str ->
                str
        )]
    ]

-- Show: multiple subscriptions
-- Explain: using the Model to change your subscriptions

-- EXERCISE: Add a pause button
-- EXERCISE: Every 10 seconds, check to see if it is christmas, display below the clock

{-

-}
