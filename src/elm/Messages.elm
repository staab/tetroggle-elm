module Messages exposing (Msg(..))

import Tetris.Messages
import Boggle.Messages

type Msg
  = NoOp
  | TetrisMsg Tetris.Messages.Msg
  | BoggleMsg Boggle.Messages.Msg
