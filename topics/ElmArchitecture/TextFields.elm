module ElmArchitecture.TextFields exposing (..)

import Html exposing (Html, Attribute, div, input, text)
import Html.App as App
import Html.Attributes exposing (placeholder, type')
import Html.Events exposing (onInput, onCheck)
import String


{-
   LEARN: How to take input from text fields
-}


main =
    App.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { content : String
    , checked : Bool
    }


model : Model
model =
    { content = "", checked = False }



-- UPDATE


type Msg
    = Change String
    | ChangeCheckBox Bool


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newContent ->
            { model | content = newContent }

        ChangeCheckBox bool ->
            { model | checked = bool }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Text to reverse", onInput Change ] []
        , div []
            [ text
                (if model.checked then
                    String.reverse model.content
                 else
                    model.content
                )
            ]
        , input
            [ type' "checkbox"
            , onCheck ChangeCheckBox
            ]
            []
        ]



-- EXERCISE: Add a checkbox that reverses the text when checked.
