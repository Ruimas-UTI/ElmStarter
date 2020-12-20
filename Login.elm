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
    = GotResponse (Result Http.Error Model)
    | FormData FormDataSent
    


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
        , expect = Http.expectJson GotResponse formDecoder
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FormData formdata ->
            case formdata of
                Name name ->
                    ( { model | name = name, validate = False }, Cmd.none )

                Email email ->
                    ( { model | email = email, validate = False }, Cmd.none )

                Password password ->
                    ( { model | password = password, validate = False }, Cmd.none )

                PasswordAgain passwordAgain ->
                    ( { model | passwordAgain = passwordAgain, validate = False }, Cmd.none )

                Validate ->
                    ( { model | validate = True }, sendForm )

        GotResponse result ->
            case result of
                Ok formdata ->
                    ( model, Cmd.none )

                Err err ->
                    let
                        error = Debug.log "Decoding error" err
                    in
                    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



--view


view : Model -> Html Msg
view model =
    div []
        [ viewInput "text" "Name" model.name (\name -> FormData (Name name))
        , viewInput "Email" "Email" model.email (\email -> FormData (Email email))
        , viewInput "password" "Password" model.password (\password -> FormData (Password password))
        , viewInput "password" "Re-enter Password" model.passwordAgain (\passwordAgain -> FormData (PasswordAgain passwordAgain))
        , button [ onClick (FormData (Validate)) ] [ text "Submit" ]
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

