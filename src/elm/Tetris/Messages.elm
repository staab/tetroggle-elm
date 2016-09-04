module Tetris.Messages exposing (Msg)

import Matrix exposing (Matrix)
import Tetris.Models exposing (BlockId, Block, Shape)

type Msg a
    = CreateShape (Matrix a)
    | RotateShape (Matrix a)
    | TranslateShape (Matrix a)
    | SelectBlock BlockId
    | UnselectBlock BlockId
    | TranslateBlock BlockId (Matrix a)