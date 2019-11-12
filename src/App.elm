module App exposing (main)

import Browser
import Html exposing (Html)
import Http
import Products


type alias Model =
    { text : String }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { text = "This is shopping cart" }
    , Products.fetch ProductFetched
    )


type Msg
    = NoOp
    | ProductFetched (Result Http.Error Products.Results)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "elm-shopping-cart"
    , body = [ Html.div [] [ Html.text model.text ] ]
    }


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
