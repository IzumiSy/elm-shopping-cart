module Products exposing
    ( Products
    , empty
    , fetch
    , view
    )

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline


type alias Product =
    { id : Int
    , name : String
    , price : Int
    }


type Products
    = Products (List Product)


empty : Products
empty =
    Products []


fetch : (Result Http.Error Products -> msg) -> Cmd msg
fetch msg =
    Http.get
        { url = "https://api.myjson.com/bins/14aydc"
        , expect = Http.expectJson msg decode
        }


view : (Int -> msg) -> Products -> Html msg
view onAddMsg (Products products) =
    div []
        (List.map
            (\{ name, id } ->
                div
                    []
                    [ text name
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
