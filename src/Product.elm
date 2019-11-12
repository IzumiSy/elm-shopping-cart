module Product exposing
    ( Product
    , decode
    )

import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline


type alias Product =
    { id : Int
    , name : String
    }


decode : Decode.Decoder Product
decode =
    Decode.succeed Product
        |> Pipeline.required "id" Decode.int
        |> Pipeline.required "name" Decode.string