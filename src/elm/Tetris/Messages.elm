module Tetris.Messages exposing (Msg(..))

import Time exposing (Time)

type Msg
  = Tick Time
  | AddShape