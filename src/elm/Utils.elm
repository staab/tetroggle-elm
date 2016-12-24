module Utils exposing (fromJust, last, between, divide)

import Debug


fromJust : Maybe a -> a
fromJust x =
    case x of
        Just y ->
            y

        Nothing ->
            Debug.crash "error: fromJust Nothing"


last : List a -> Maybe a
last =
    List.foldl (Just >> always) Nothing


between : Int -> Int -> Int -> Bool
between min max value =
    value >= min && value <= max


divide : Int -> Int -> Float
divide a b =
    if b == 0 then
        0
    else
        (toFloat a) / (toFloat b)
