module Cart exposing
    ( Cart
    , add
    , empty
    )

import Set


type Cart
    = Cart (Set.Set String)


empty : Cart
empty =
    Cart Set.empty


add : String -> Cart -> Cart
add productId (Cart ids) =
    Cart (Set.insert productId ids)
