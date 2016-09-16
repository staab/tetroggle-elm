module Messages exposing (Msg(..))

import Tetris.Messages

type Msg
  = NoOp
  | TetrisMsg Tetris.Messages.Msg
