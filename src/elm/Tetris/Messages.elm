module Tetris.Messages exposing (Msg)

import Matrix exposing (Matrix, Location)

type Msg a
    = CreateShape (Matrix a)
    | RotateShape (Matrix a)
    | TranslateShape (Matrix a)
    | SelectBlock Location
    | UnselectBlock Location
    | TranslateBlock Location (Matrix a)