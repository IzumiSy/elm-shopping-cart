module Cart exposing
    ( Cart
    , add
    , empty
    , view
    )

-- カートの状態を表現するモジュール
-- 現状複数の商品をカートにいれることができない

import Html exposing (Html, div, text)
import Set


type Cart
    = Cart (Set.Set Int)


empty : Cart
empty =
    Cart Set.empty


add : Int -> Cart -> Cart
add productId (Cart ids) =
    Cart (Set.insert productId ids)


view : Cart -> Html msg
view (Cart cart) =
    let
        ids =
            cart
                |> Set.toList
                |> List.map String.fromInt
                |> String.join ","
    in
    div [] [ text ("現在のカート: " ++ ids) ]
