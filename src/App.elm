module App exposing (main)

import Browser
import Cart
import Html exposing (button, div, h1, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Products



-- model


type alias Session =
    { products : Products.Products
    , cart : Cart.Cart
    }


type Model
    = Loading
    | LoadedProducts Products.Products
    | LoadedAll Session
    | Purchased Session


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, Products.fetch ProductFetched )



-- update


type Msg
    = ProductFetched (Result Http.Error Products.Products)
    | AddProductToCart String
    | Purchase
    | BackToProducts
    | CartLoaded Cart.Cart
    | CartLoadingFailed


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        ProductFetched products ->
            case model of
                Loading ->
                    ( LoadedProducts (Result.withDefault Products.empty products)
                    , Cart.load
                    )

                LoadedProducts _ ->
                    ( model, Cmd.none )

                LoadedAll _ ->
                    ( model, Cmd.none )

                Purchased _ ->
                    ( model, Cmd.none )

        AddProductToCart id ->
            case model of
                Loading ->
                    ( model, Cmd.none )

                LoadedProducts _ ->
                    ( model, Cmd.none )

                LoadedAll session ->
                    let
                        ( nextCart, cmd ) =
                            Cart.add id session.products session.cart
                    in
                    ( LoadedAll { session | cart = nextCart }
                    , cmd
                    )

                Purchased _ ->
                    ( model, Cmd.none )

        Purchase ->
            case model of
                Loading ->
                    ( model, Cmd.none )

                LoadedProducts _ ->
                    ( model, Cmd.none )

                LoadedAll session ->
                    ( Purchased session, Cmd.none )

                Purchased _ ->
                    ( model, Cmd.none )

        BackToProducts ->
            case model of
                Loading ->
                    ( model, Cmd.none )

                LoadedProducts _ ->
                    ( model, Cmd.none )

                LoadedAll _ ->
                    ( model, Cmd.none )

                Purchased { products } ->
                    let
                        ( emptyCart, cmd ) =
                            Cart.empty
                    in
                    ( LoadedAll
                        { products = products
                        , cart = emptyCart
                        }
                    , cmd
                    )

        CartLoaded cart ->
            case model of
                Loading ->
                    ( model, Cmd.none )

                LoadedProducts products ->
                    ( LoadedAll
                        { products = products
                        , cart = cart
                        }
                    , Cmd.none
                    )

                LoadedAll _ ->
                    ( model, Cmd.none )

                Purchased _ ->
                    ( model, Cmd.none )

        CartLoadingFailed ->
            case model of
                Loading ->
                    ( model, Cmd.none )

                LoadedProducts products ->
                    let
                        ( emptyCart, cmd ) =
                            Cart.empty
                    in
                    ( LoadedAll
                        { products = products
                        , cart = emptyCart
                        }
                    , cmd
                    )

                LoadedAll _ ->
                    ( model, Cmd.none )

                Purchased _ ->
                    ( model, Cmd.none )



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Loading ->
            Sub.none

        LoadedProducts products ->
            Cart.loaded products CartLoaded CartLoadingFailed

        LoadedAll _ ->
            Sub.none

        Purchased _ ->
            Sub.none



-- view


view : Model -> Browser.Document Msg
view model =
    { title = "ECサイト"
    , body =
        case model of
            Loading ->
                [ div [] [ text "Loading..." ] ]

            LoadedProducts _ ->
                [ div [] [ text "Loading..." ] ]

            LoadedAll session ->
                [ div
                    [ class "banner" ]
                    [ h1
                        [ class "title" ]
                        [ text "ECサイト" ]
                    ]
                , div
                    [ class "contents" ]
                    [ Products.view AddProductToCart session.products
                    , Cart.view Purchase session.products session.cart
                    ]
                ]

            Purchased _ ->
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
        , subscriptions = subscriptions
        }
