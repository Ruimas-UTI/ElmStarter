module Main exposing (Model, Msg(..), init, main, update)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode exposing (Decoder, bool, field, int, map5, string)



--main


main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }



--model


type alias Model =
    { name : String
    , email : String
    , password : String
    , passwordAgain : String
    , validate : Bool
    }


init : () -> ( Model, Cmd msg )
init _ =
    ( Model "" "" "" "" False, Cmd.none )



--update


type Msg
    = Sending
    | Success (Result Http.Error FormDataSent)
    | Failure


type FormDataSent
    = Name String
    | Email String
    | Password String
    | PasswordAgain String
    | Validate


formDecoder : Decoder Model
formDecoder =
    map5 Model
        (field "name" string)
        (field "email" string)
        (field "password" string)
        (field "passwordAgain" string)
        (field "validate" bool)


sendForm : Cmd Msg
sendForm =
    Http.post
        { url = "https://jsonplaceholder.typicode.com/posts"
        , body = Http.emptyBody
        , expect = Http.expectJson formDecoder
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Success result ->
            case result of
                Ok formdata ->
                    ( case formdata of
                        Name name ->
                            { model | name = name, validate = False }

                        Email email ->
                            { model | email = email, validate = False }

                        Password password ->
                            { model | password = password, validate = False }

                        PasswordAgain passwordAgain ->
                            { model | passwordAgain = passwordAgain, validate = False }

                        Validate ->
                            { model | validate = True }
                    , sendForm
                    )

                Err _ ->
                    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



--view


view : Model -> Html Msg
view model =
    div []
        [ viewInput "text" "Name" model.name Name
        , viewInput "Email" "Email" model.email Email
        , viewInput "password" "Password" model.password Password
        , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
        , button [ onClick Validate ] [ text "Submit" ]
        , validation model
        ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []


validation : Model -> Html msg
validation model =
    let
        ( color, message ) =
            if model.validate then
                if model.password /= model.passwordAgain then
                    ( "red", "Password Did Not Match!" )

                else
                    ( "green", " Validated " )

            else
                ( "white", " " )
    in
    div [ style "color" color ] [ text message ]
