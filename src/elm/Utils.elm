module Utils exposing (fromJust, last)

import Debug

fromJust : Maybe a -> a
fromJust x =
  case x of
    Just y -> y
    Nothing -> Debug.crash "error: fromJust Nothing"

last : List a -> Maybe a
last =
    List.foldl (Just >> always) Nothing