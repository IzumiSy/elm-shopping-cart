module Products exposing
    ( Product
    , Products
    , empty
    , fetch
    , getByIdSet
    , view
    )

-- 商品の一覧に関する処理を表現するモジュール

import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Set



-- model


type Products
    = Products (List Product)


type alias Product =
    { id : String
    , name : String
    , price : Int
    , imageUrl : String
    }


empty : Products
empty =
    Products []


getByIdSet : Set.Set String -> Products -> List Product
getByIdSet ids (Products products) =
    List.filter (\{ id } -> Set.member id ids) products


fetch : (Result Http.Error Products -> msg) -> Cmd msg
fetch msg =
    Http.get
        { url = "https://api.myjson.com/bins/pzugs"
        , expect = Http.expectJson msg decode
        }



-- view


view : (String -> msg) -> Products -> Html msg
view onAddToCart (Products products) =
    div
        [ class "section products" ]
        (List.map (viewProduct onAddToCart) products)


viewProduct : (String -> msg) -> Product -> Html msg
viewProduct onAddToCart { name, id, imageUrl, price } =
    div
        [ class "product" ]
        [ div
            [ class "background" ]
            [ img
                [ src imageUrl
                , class "image"
                ]
                []
            ]
        , div
            [ class "name" ]
            [ text (String.concat [ "#", id, " ", name ])
            ]
        , div
            [ class "price" ]
            [ text ("¥" ++ String.fromInt price)
            ]
        , div
            [ class "actions" ]
            [ button
                [ class "add"
                , onClick (onAddToCart id)
                ]
                [ text "追加" ]
            ]
        ]



-- internals


decode : Decode.Decoder Products
decode =
    Decode.succeed (\results -> Decode.succeed (Products results))
        |> Pipeline.required "result" (Decode.list decodeProduct)
        |> Pipeline.resolve


decodeProduct : Decode.Decoder Product
decodeProduct =
    Decode.succeed Product
        |> Pipeline.required "id" Decode.string
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "price" Decode.int
        |> Pipeline.required "image_url" Decode.string
