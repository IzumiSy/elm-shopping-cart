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
    | Loaded Session
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


update : Msg -> Model -> ( Model, Cmd msg )
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

                Purchased _ ->
                    ( model, Cmd.none )

        AddProductToCart id ->
            case model of
                Loading ->
                    ( model, Cmd.none )

                Loaded session ->
                    ( Loaded
                        { session
                            | cart = Cart.add id session.products session.cart
                        }
                    , Cmd.none
                    )

                Purchased _ ->
                    ( model, Cmd.none )

        Purchase ->
            case model of
                Loading ->
                    ( model, Cmd.none )

                Loaded session ->
                    ( Purchased session, Cmd.none )

                Purchased _ ->
                    ( model, Cmd.none )

        BackToProducts ->
            case model of
                Loading ->
                    ( model, Cmd.none )

                Loaded _ ->
                    ( model, Cmd.none )

                Purchased { products } ->
                    ( Loaded
                        { products = products
                        , cart = Cart.empty
                        }
                    , Cmd.none
                    )



-- view


view : Model -> Browser.Document Msg
view model =
    { title = "ECサイト"
    , body =
        case model of
            Loading ->
                [ div [] [ text "Loading..." ] ]

            Loaded session ->
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
        , subscriptions = \_ -> Sub.none
        }
