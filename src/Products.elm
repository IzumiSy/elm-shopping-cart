module Products exposing
    ( Products
    , empty
    , fetch
    , view
    )

import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (height, src, width)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline


type alias Product =
    { id : Int
    , name : String
    , price : Int
    , imageUrl : String
    }


type Products
    = Products (List Product)


empty : Products
empty =
    Products []


fetch : (Result Http.Error Products -> msg) -> Cmd msg
fetch msg =
    Http.get
        { url = "https://api.myjson.com/bins/dx2ds"
        , expect = Http.expectJson msg decode
        }


view : (Int -> msg) -> Products -> Html msg
view onAddMsg (Products products) =
    div []
        (List.map
            (\{ name, id, imageUrl } ->
                div
                    []
                    [ img
                        [ src imageUrl
                        , width 170
                        , height 170
                        ]
                        []
                    , text name
                    , button
                        [ onClick (onAddMsg id) ]
                        [ text "追加" ]
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
        |> Pipeline.required "id" Decode.int
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "price" Decode.int
        |> Pipeline.required "image_url" Decode.string
