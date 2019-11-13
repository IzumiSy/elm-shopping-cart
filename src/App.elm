module App exposing (main)

import Browser
import Cart
import Html exposing (Html)
import Http
import Product
import Products


type alias Store =
    { products : List Product.Product
    , cart : Cart.Cart
    }


type Model
    = Loading
    | Loaded Store
    | Purchased


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, Products.fetch ProductFetched )


type Msg
    = NoOp
    | ProductFetched (Result Http.Error (List Product.Product))
    | AddProductToCart String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ProductFetched result ->
            case model of
                Loading ->
                    ( Loaded
                        { products = Result.withDefault [] result
                        , cart = Cart.empty
                        }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        AddProductToCart id ->
            case model of
                Loaded store ->
                    ( Loaded { store | cart = Cart.add id store.cart }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "elm-shopping-cart"
    , body =
        case model of
            Loading ->
                [ Html.div [] [ Html.text "Loading" ] ]

            Loaded _ ->
                [ Html.div [] [ Html.text "elm shopping cart" ] ]

            Purchased ->
                [ Html.div [] [ Html.text "Purchased" ] ]
    }


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
