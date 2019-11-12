module App exposing (main)

import Browser
import Cart
import Html exposing (Html)
import Http
import Product
import Products


type alias Model =
    { products : List Product.Product
    , cart : Cart.Cart
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { products = []
      , cart = Cart.empty
      }
    , Products.fetch ProductFetched
    )


type Msg
    = NoOp
    | ProductFetched (Result Http.Error (List Product.Product))
    | AddProductToCart String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ProductFetched result ->
            ( { model | products = Result.withDefault [] result }
            , Cmd.none
            )

        AddProductToCart id ->
            ( { model | cart = Cart.add id model.cart }
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
