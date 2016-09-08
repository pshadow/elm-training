module ElmArchitectureModules.Nesting exposing (..)

import Html exposing (div, h1, text, button, ul, li, Html)
import Html.Attributes exposing (disabled)
import Html.App exposing (program)
import Html.Events exposing (onClick)
import Effects.Random as ER
import Effects.Http as EH
import Effects.Subscriptions as ES


{-

   LEARN: How to nest elm architecture programs inside each other.

   We built a few perfectly good apps earlier. We want to show them all off together!

   The Elm Architecture makes it easy to combine elm applications together. Let's build an app switcher that lets us embed a few different Elm apps inside.

-}
-- STARTING STATE
{--
main =
    program { init = init, view = view, update = update, subscriptions = subscriptions }


type alias Model = Int

init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )


type Msg
    = Wat


view model =
    div []
        [ h1 [] [ text "App Switcher" ]
        , ul []
            [ li [] [ button [] [ text "App 1" ] ]
            , li [] [ button [] [ text "App 2" ] ]
            ]
        , renderChild model
        ]

renderChild model =
  text ""

update msg model =
  (model, Cmd.none)

subscriptions model = Sub.none
--}
-- COMPLETED EXAMPLE
{--}


main =
    program { init = init, view = view, update = update, subscriptions = subscriptions }


type CurrentApp
    = RandomApp
    | HttpApp
    | SubscriptionApp


type alias Model =
    { activeApp : CurrentApp
    , random : ER.Model
    , http : EH.Model
    , subscription : ES.Model
    }


init : ( Model, Cmd Msg )
init =
    let
        ( randomModel, randomCmd ) =
            ER.init

        ( httpModel, httpCmd ) =
            EH.init

        ( subscriptionModel, subscriptionCmd ) =
            ES.init
    in
        ( { activeApp = RandomApp
          , random = randomModel
          , http = httpModel
          , subscription = subscriptionModel
          }
        , Cmd.batch
            [ -- our own commands go here, but we have none so we just use Cmd.none
              Cmd.none
            , Cmd.map RandomMsg randomCmd
            , Cmd.map HttpMsg httpCmd
            , Cmd.map SubscriptionMsg subscriptionCmd
            ]
        )


type Msg
    = ChangeCurrentApp CurrentApp
    | RandomMsg ER.Msg
    | HttpMsg EH.Msg
    | SubscriptionMsg ES.Msg


view model =
    div []
        [ h1 [] [ text "App Switcher" ]
        , ul []
            [ li []
                [ button
                    [ onClick (ChangeCurrentApp RandomApp)
                    , disabled (model.activeApp == RandomApp)
                    ]
                    [ text "Random Numbers" ]
                ]
            , li []
                [ button
                    [ onClick (ChangeCurrentApp HttpApp)
                    , disabled (model.activeApp == HttpApp)
                    ]
                    [ text "Http Requests" ]
                ]
            , li []
                [ button
                    [ onClick (ChangeCurrentApp SubscriptionApp)
                    , disabled (model.activeApp == SubscriptionApp)
                    ]
                    [ text "Subscriptions" ]
                ]
            ]
        , renderChild model
        ]


renderChild model =
    case model.activeApp of
        RandomApp ->
            Html.App.map RandomMsg (ER.view model.random)

        HttpApp ->
            Html.App.map HttpMsg (EH.view model.http)

        SubscriptionApp ->
            Html.App.map SubscriptionMsg (ES.view model.subscription)


update msg model =
    case msg of
        ChangeCurrentApp app ->
            ( { model | activeApp = app }, Cmd.none )

        RandomMsg randomMessage ->
            let
                ( random, randomCmd ) =
                    ER.update randomMessage model.random
            in
                ( { model | random = random }, Cmd.map RandomMsg randomCmd )

        HttpMsg httpMessage ->
            let
                ( http, httpCmd ) =
                    EH.update httpMessage model.http
            in
                ( { model | http = http }, Cmd.map HttpMsg httpCmd )

        SubscriptionMsg subscriptionMessage ->
            let
                ( subscription, subscriptionCmd ) =
                    ES.update subscriptionMessage model.subscription
            in
                ( { model | subscription = subscription }, Cmd.map SubscriptionMsg subscriptionCmd )


subscriptions model =
    Sub.batch
        [ -- our own subscriptions would go here
          Sub.none
        , Sub.map RandomMsg (ER.subscriptions model.random)
        , Sub.map HttpMsg (EH.subscriptions model.http)
        ]
--}



{-

      WHEW. That sure is a lot of work, but it looks like our app appears. Notice a few things here.

      * Our elm architecture modules are SUPER reusable. We don't have to know very much at all about what our children are doing. We didn't have to change ANYTHING in our child components to use them in a parent component.
      * Wow there is a LOT of boilerplate here. Look how much code is just forwarding stuff on to the correct children.

   -- EXERCISE: Add a third button to allow them to switch to the subscription app.

-}
