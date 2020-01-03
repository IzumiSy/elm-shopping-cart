module Cart exposing
    ( Cart
    , add
    , empty
    , view
    )

-- カートの状態を表現するモジュール
-- 現状複数の商品をカートにいれることができない

import Html exposing (Html, button, div, h2, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Set


type Cart
    = Cart (Set.Set Int)


empty : Cart
empty =
    Cart Set.empty


add : Int -> Cart -> Cart
add productId (Cart ids) =
    Cart (Set.insert productId ids)


view : msg -> Cart -> Html msg
view onPurchaseMsg (Cart cart) =
    let
        ids =
            cart
                |> Set.toList
                |> List.map String.fromInt
                |> String.join ","
    in
    div
        [ class "section cart" ]
        [ h2
            [ class "title" ]
            [ text "現在のカート" ]
        , div
            [ class "products" ]
            [ text ("選択された商品: " ++ ids) ]
        , div
            [ class "shipping" ]
            [ text "送料: ¥500" ]
        , div
            [ class "tax" ]
            [ text "税: ¥20" ]
        , div
            [ class "total" ]
            [ text "合計: ¥220" ]
        , div
            [ class "actions" ]
            [ button
                [ class "purchase"
                , onClick onPurchaseMsg
                ]
                [ text "購入" ]
            ]
        ]
