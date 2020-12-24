module Main exposing (..)

import Browser
import Html exposing (Html, text)
import Html.Attributes exposing (style)
import Http
import Material
import Material.Button as Button
import Material.Elevation as Elevation
import Material.FormField as FormField
import Material.Options as Options exposing (css, onChange, onClick, styled)
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
    | HandleSubmit


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init, subscriptions = subscriptions, update = update, view = view }


init : ( Model, Cmd Msg )
init =
    ( defaultModel, Material.init Mdc )


subscriptions : Model -> Sub Msg
subscriptions model =
    Material.subscriptions Mdc model



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdc msg_ ->
            Material.update Mdc msg_ model

        HandleSubmit ->
            ( model, formData )


formData : Cmd msg
formData =
    Http.post
        { url = "https://jsonplaceholder.typicode.com/posts"
        , body = Http.emptyBody
        , expect = Http.expectJson Mdc Material.Model
        }



--view


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
        [ FormField.view []
            [ TextField.view Mdc
                "emai"
                model.mdc
                [ TextField.label "email"
                , TextField.email

                --  Options.onChange UpdateTextField
                ]
                []
            , TextField.view Mdc
                "password"
                model.mdc
                [ TextField.label "password"
                , TextField.password

                --  Options.onChange UpdateTextField
                ]
                []
            , Button.view Mdc
                "submit-button"
                model.mdc
                [ Button.ripple
                , Button.raised
                , Options.onClick HandleSubmit
                , css "height" "20%"
                ]
                [ text "Submit" ]
            ]
        ]
