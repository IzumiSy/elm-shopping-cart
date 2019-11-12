module Products exposing (fetch)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Product


fetch : (Result Http.Error (List Product.Product) -> msg) -> Cmd msg
fetch msg =
    Http.get
        { url = "https://api.myjson.com/bins/o6ssi"
        , expect = Http.expectJson msg decode
        }


decode : Decode.Decoder (List Product.Product)
decode =
    Decode.succeed (\results -> Decode.succeed results)
        |> Pipeline.required "result" (Decode.list Product.decode)
        |> Pipeline.resolve
