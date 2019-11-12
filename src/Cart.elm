module Cart exposing
    ( Cart
    , empty
    )

import Set


type Cart
    = Cart (Set.Set String)


empty : Cart
empty =
    Cart Set.empty
