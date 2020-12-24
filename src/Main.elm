module Main exposing (..)

import Browser
import Html exposing (Html, text)
import Material
import Material.Button as Button
import Material.Elevation as Elevation
import Material.Options as Options exposing (css, styled)
import Material.TextField as TextField



--model


type alias Model =
    { mdc : Material.Model Msg
    }


defaultModel : Model
defaultModel =
    { mdc = Material.defaultModel }


type Msg
    = Mdc (Material.Msg Msg)
    | Submit


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init, subscriptions = subscriptions, update = update, view = view }


subscriptions : Model -> Sub Msg
subscriptions model =
    Material.subscriptions Mdc model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdc msg_ ->
            Material.update Mdc msg_ model

        Submit ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Html.div
        [ style "display" "flex"
        , style "justify-content" "center"
        , style "height" "auto"
        ]
        [ Html.div
            [ style "display" "flex"
            , style "flex-direction" "column"
            , style "justify-content" "center"
            , style "width" "auto"
            ]
            [ form model ]
        ]


form : Model -> Html Msg
form model =
    styled Html.div
        [ Elevation.transition
        , css "display" "flex"
        , css "justify-content" "space-evenly"
        , css "flex-direction" "column"
        , css "height" "auto"
        , css "padding" "8%"
        , css "margin" "auto"
        ]
        []
