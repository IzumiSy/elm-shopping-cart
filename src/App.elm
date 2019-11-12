module App exposing (main)

import Browser
import Html exposing (Html)
import Http
import Product
import Products


type alias Model =
    { products : List Product.Product }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { products = [] }
    , Products.fetch ProductFetched
    )


type Msg
    = NoOp
    | ProductFetched (Result Http.Error (List Product.Product))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ProductFetched result ->
            ( { products = Result.withDefault [] result }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "elm-shopping-cart"
    , body = [ Html.div [] [ Html.text "elm shopping cart" ] ]
    }


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
