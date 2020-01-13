module App exposing (main)

import Browser
import Cart
import Html exposing (button, div, h1, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Products



-- model


type Model
    = Loading
    | Loaded
        { products : Products.Products
        , cart : Cart.Cart
        }
    | Purchased


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, Products.fetch ProductFetched )



-- update


type Msg
    = ProductFetched (Result Http.Error Products.Products)
    | AddProductToCart String
    | Purchase
    | BackToProducts


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

                Loaded _ ->
                    ( model, Cmd.none )

                Purchased ->
                    ( model, Cmd.none )

        AddProductToCart id ->
            case model of
                Loading ->
                    ( model, Cmd.none )

                Loaded loaded ->
                    ( Loaded { loaded | cart = Cart.add id loaded.products loaded.cart }
                    , Cmd.none
                    )

                Purchased ->
                    ( model, Cmd.none )

        Purchase ->
            case model of
                Loading ->
                    ( model, Cmd.none )

                Loaded _ ->
                    ( Purchased, Cmd.none )

                Purchased ->
                    ( model, Cmd.none )

        BackToProducts ->
            init ()



-- view


view : Model -> Browser.Document Msg
view model =
    { title = "ECサイト"
    , body =
        case model of
            Loading ->
                [ div [] [ text "Loading..." ] ]

            Loaded loaded ->
                [ div
                    [ class "banner" ]
                    [ h1
                        [ class "title" ]
                        [ text "ECサイト" ]
                    ]
                , div
                    [ class "contents" ]
                    [ Products.view AddProductToCart loaded.products
                    , Cart.view Purchase loaded.products loaded.cart
                    ]
                ]

            Purchased ->
                [ div
                    [ class "contents purchased" ]
                    [ div
                        [ class "container" ]
                        [ div
                            [ class "title" ]
                            [ text "Thank You!" ]
                        , button
                            [ class "back"
                            , onClick BackToProducts
                            ]
                            [ text "商品一覧へもどる" ]
                        ]
                    ]
                ]
    }



-- main


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
