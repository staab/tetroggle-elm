module Utils exposing (fromJust, last, between)

import Debug

fromJust : Maybe a -> a
fromJust x =
  case x of
    Just y -> y
    Nothing -> Debug.crash "error: fromJust Nothing"

last : List a -> Maybe a
last =
    List.foldl (Just >> always) Nothing

between : Int -> Int -> Int -> Bool
between min max value =
  value >= min && value <= max