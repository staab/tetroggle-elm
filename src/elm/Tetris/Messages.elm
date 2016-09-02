module Tetris.Messages exposing (Msg)

import Matrix exposing (Matrix)
import Tetris.Models exposing (BlockId, Block, Shape)

type Msg
  = CreateShape Matrix
  | RotateShape Matrix
  | TranslateShape Matrix
  | SelectBlock BlockId
  | UnselectBlock BlockId
  | TranslateBlock BlockId Matrix