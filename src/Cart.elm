module Cart exposing
    ( Cart
    , add
    , empty
    , view
    )

-- カートの状態を表現するモジュール
-- 現状複数の商品をカートにいれることができない

import Html exposing (Html, button, div, h2, span, text)
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
            [ class "block selection" ]
            [ div
                []
                [ text "選択された商品:" ]
            , div
                []
                [ text ids ]
            ]
        , div
            [ class "seperator" ]
            []
        , div
            [ class "block shipping" ]
            [ span
                [ class "label" ]
                [ text "送料:" ]
            , span
                [ class "value" ]
                [ text "¥500" ]
            ]
        , div
            [ class "block tax" ]
            [ span
                [ class "label" ]
                [ text "税:" ]
            , span
                [ class "value" ]
                [ text "¥20" ]
            ]
        , div
            [ class "block total" ]
            [ span
                [ class "label" ]
                [ text "合計:" ]
            , span
                [ class "value" ]
                [ text "¥220" ]
            ]
        , div
            [ class "actions" ]
            [ button
                [ class "purchase"
                , onClick onPurchaseMsg
                ]
                [ text "購入" ]
            ]
        ]
