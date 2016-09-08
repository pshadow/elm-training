module Routing.Screens.Post exposing (..)

import Html exposing (Html, button, div, text, a)
import Html.Attributes exposing (href, style)
import Html.App as App
import Html.Events exposing (onClick)
import Routing.Routes exposing (url, Route(..))
import Http
import Task


-- MODEL ---------------------------


type alias Model =
    { postId : Int
    , liked : Bool
    , time : String
    }


init : Int -> ( Model, Cmd Msg )
init id =
    ( { postId = id, liked = False, time = "" }
    , getTime
    )



-- UPDATE ---------------------------


type Msg
    = Like
    | UpdateTime String
    | RequestError


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Like ->
            ( model, Cmd.none )

        UpdateTime str ->
            ( { model | time = str }, Cmd.none )

        RequestError ->
            ( model, Cmd.none )


getTime : Cmd Msg
getTime =
    Task.perform (always RequestError) UpdateTime <|
        Http.getString "http://www.timeapi.org/utc/now"



-- VIEW --------------------------


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text "Post: ", text (toString model.postId) ]
        , div [] [ text "Time: ", text model.time ]
        , div []
            [ a [ href (url (Post (model.postId - 1))) ]
                [ text "Previous" ]
            , text " "
            , a [ href (url (Post (model.postId + 1))) ]
                [ text "Next" ]
            ]
        ]
