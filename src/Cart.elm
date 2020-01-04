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
import Products
import Set


type Cart
    = Cart (Set.Set String)


empty : Cart
empty =
    Cart Set.empty


add : String -> Cart -> Cart
add productId (Cart ids) =
    Cart (Set.insert productId ids)


view : msg -> Products.Products -> Cart -> Html msg
view onPurchaseMsg products cart =
    let
        taxes =
            totalTaxes products cart

        shipping =
            totalShipping products cart

        subTotal_ =
            subTotal products cart

        total =
            subTotal_ + shipping + taxes
    in
    div
        [ class "section cart" ]
        [ h2
            [ class "title" ]
            [ text "現在のカート" ]
        , div
            [ class "block selection" ]
            [ div [] (viewProductNames products cart) ]
        , div
            [ class "seperator" ]
            []
        , div
            [ class "block subtotal" ]
            [ span
                [ class "label" ]
                [ text "小計:" ]
            , span
                [ class "value" ]
                [ text (String.concat [ "¥", String.fromInt subTotal_ ]) ]
            ]
        , div
            [ class "block shipping" ]
            [ span
                [ class "label" ]
                [ text "送料:" ]
            , span
                [ class "value" ]
                [ text (String.concat [ "¥", String.fromInt shipping ]) ]
            ]
        , div
            [ class "block tax" ]
            [ span
                [ class "label" ]
                [ text "税:" ]
            , span
                [ class "value" ]
                [ text (String.concat [ "¥", String.fromInt taxes ]) ]
            ]
        , div
            [ class "block total" ]
            [ span
                [ class "label" ]
                [ text "合計:" ]
            , span
                [ class "value" ]
                [ text (String.concat [ "¥", String.fromInt total ]) ]
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



-- Internals


{-| 現在選択されている商品一覧をdivのリストにする
-}
viewProductNames : Products.Products -> Cart -> List (Html msg)
viewProductNames products (Cart cart) =
    products
        |> Products.getByIdSet cart
        |> List.map (\{ name, id } -> div [] [ text (String.concat [ "#", id, " ", name ]) ])


{-| 合計の税額を計算する
-}
totalTaxes : Products.Products -> Cart -> Int
totalTaxes products (Cart cart) =
    products
        |> Products.getByIdSet cart
        |> List.foldl (\{ price } acc -> acc + truncate (toFloat price * 0.08)) 0


{-| 税と配送料を抜いた小計を計算する
-}
subTotal : Products.Products -> Cart -> Int
subTotal products (Cart cart) =
    products
        |> Products.getByIdSet cart
        |> List.foldl (\{ price } acc -> acc + price) 0


{-| 送料を計算する。1500円を上限配送料とする。
-}
totalShipping : Products.Products -> Cart -> Int
totalShipping products cart =
    let
        price =
            ceiling (toFloat (subTotal products cart) / 500) * 500
    in
    if price < 1500 then
        price

    else
        1500
