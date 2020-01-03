module Products exposing
    ( Product
    , Products
    , empty
    , fetch
    , getByIdSet
    , view
    )

import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Set


type alias Product =
    { id : String
    , name : String
    , price : Int
    , imageUrl : String
    }


type Products
    = Products (List Product)


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


view : (String -> msg) -> Products -> Html msg
view onAddMsg (Products products) =
    div [ class "section products" ]
        (List.map
            (\{ name, id, imageUrl, price } ->
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
                        [ text (String.concat [ "#", id, " ", name ]) ]
                    , div
                        [ class "price" ]
                        [ text ("¥" ++ String.fromInt price) ]
                    , div
                        [ class "actions" ]
                        [ button
                            [ class "add"
                            , onClick (onAddMsg id)
                            ]
                            [ text "追加" ]
                        ]
                    ]
            )
            products
        )



-- Internals


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
