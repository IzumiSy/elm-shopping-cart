module Cart exposing
    ( Cart
    , add
    , empty
    , view
    )

-- カートの状態を表現するモジュール
-- 送料や税額計算などのビジネスルールを凝集

import Html exposing (Html, button, div, h2, span, text)
import Html.Attributes exposing (class, disabled)
import Html.Events exposing (onClick)
import Products
import Set



-- model


type alias ProductIds =
    Set.Set String


type Cart
    = Cart
        { productIds : ProductIds
        , shipping : Int
        , taxes : Int
        , subTotal : Int
        , total : Int
        }


empty : Cart
empty =
    Cart
        { productIds = Set.empty
        , shipping = 0
        , taxes = 0
        , subTotal = 0
        , total = 0
        }


add : String -> Products.Products -> Cart -> Cart
add productId products (Cart cart) =
    let
        nextProductIds =
            Set.insert productId cart.productIds

        taxes =
            totalTaxes products nextProductIds

        shipping =
            totalShipping products nextProductIds

        subTotal_ =
            subTotal products nextProductIds
    in
    Cart
        { productIds = nextProductIds
        , shipping = shipping
        , taxes = taxes
        , subTotal = subTotal_
        , total = subTotal_ + shipping + taxes
        }



-- view


view : msg -> Products.Products -> Cart -> Html msg
view onPurchaseMsg products (Cart cart) =
    div
        [ class "section cart" ]
        [ h2
            [ class "title" ]
            [ text "現在のカート" ]
        , div
            [ class "block selection" ]
            [ div [] (viewProductNames products cart.productIds) ]
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
                [ text (String.concat [ "¥", String.fromInt cart.subTotal ]) ]
            ]
        , div
            [ class "block shipping" ]
            [ span
                [ class "label" ]
                [ text "送料:" ]
            , span
                [ class "value" ]
                [ text (String.concat [ "¥", String.fromInt cart.shipping ]) ]
            ]
        , div
            [ class "block tax" ]
            [ span
                [ class "label" ]
                [ text "税:" ]
            , span
                [ class "value" ]
                [ text (String.concat [ "¥", String.fromInt cart.taxes ]) ]
            ]
        , div
            [ class "block total" ]
            [ span
                [ class "label" ]
                [ text "合計:" ]
            , span
                [ class "value" ]
                [ text (String.concat [ "¥", String.fromInt cart.total ]) ]
            ]
        , div
            [ class "actions" ]
            [ button
                [ class "purchase"
                , onClick onPurchaseMsg
                , disabled (Set.isEmpty cart.productIds)
                ]
                [ text "購入" ]
            ]
        ]



-- internals


{-| 現在選択されている商品一覧をdivのリストにする
-}
viewProductNames : Products.Products -> ProductIds -> List (Html msg)
viewProductNames products productIds =
    products
        |> Products.getByIdSet productIds
        |> List.map (\{ name, id } -> div [] [ text (String.concat [ "#", id, " ", name ]) ])


{-| 合計の税額を計算する
-}
totalTaxes : Products.Products -> ProductIds -> Int
totalTaxes products productIds =
    products
        |> Products.getByIdSet productIds
        |> List.foldl (\{ price } acc -> acc + truncate (toFloat price * 0.08)) 0


{-| 税と配送料を抜いた小計を計算する
-}
subTotal : Products.Products -> ProductIds -> Int
subTotal products productIds =
    products
        |> Products.getByIdSet productIds
        |> List.foldl (\{ price } acc -> acc + price) 0


{-| 送料を計算する。1500円を上限配送料とする。
-}
totalShipping : Products.Products -> ProductIds -> Int
totalShipping products productIds =
    let
        price =
            ceiling (toFloat (subTotal products productIds) / 500) * 500
    in
    if price < 1500 then
        price

    else
        1500
