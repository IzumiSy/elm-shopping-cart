module App exposing (main)

import Browser
import Cart
import Html exposing (button, div, h1, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Products


type alias Store =
    { products : Products.Products
    , cart : Cart.Cart
    }


type Model
    = Loading
    | Loaded Store
    | Purchased Cart.Cart


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, Products.fetch ProductFetched )


type Msg
    = NoOp
    | ProductFetched (Result Http.Error Products.Products)
    | AddProductToCart Int
    | Purchase


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ProductFetched products ->
            case model of
                Loading ->
                    ( Loaded
                        { products = Result.withDefault Products.empty products
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

        Purchase ->
            case model of
                Loaded store ->
                    ( Purchased store.cart, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "ECサイト"
    , body =
        case model of
            Loading ->
                [ div [] [ text "Loading" ] ]

            Loaded loaded ->
                [ div
                    [ class "contents" ]
                    [ h1
                        [ class "title" ]
                        [ text "商品一覧" ]
                    , Products.view AddProductToCart loaded.products
                    , div
                        [ class "section cart" ]
                        [ button [ onClick Purchase ] [ text "購入" ]
                        , Cart.view loaded.cart
                        ]
                    ]
                ]

            Purchased _ ->
                [ div [] [ text "Purchased" ] ]
    }


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
