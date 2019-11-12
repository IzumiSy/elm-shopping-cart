module Products exposing
    ( Results
    , fetch
    )

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Product


fetch : (Result Http.Error (List Product.Product) -> msg) -> Cmd msg
fetch msg =
    Http.get
        { url = "https://example.com"
        , expect = Http.expectJson msg decode
        }


type alias Results =
    { results : List Product.Product }


decode : Decode.Decoder (List Product.Product)
decode =
    Decode.succeed (\results -> Decode.succeed results)
        |> Pipeline.required "results" (Decode.list Product.decode)
        |> Pipeline.resolve
