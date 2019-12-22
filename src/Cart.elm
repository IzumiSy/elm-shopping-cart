module Cart exposing
    ( Cart
    , add
    , empty
    )

-- カートの状態を表現するモジュール
-- 現状複数の商品をカートにいれることができない

import Set


type Cart
    = Cart (Set.Set Int)


empty : Cart
empty =
    Cart Set.empty


add : Int -> Cart -> Cart
add productId (Cart ids) =
    Cart (Set.insert productId ids)
