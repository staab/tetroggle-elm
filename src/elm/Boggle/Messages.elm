module Boggle.Messages exposing (Msg(..))

import Keyboard exposing (KeyCode)

type Msg
  = KeyPress KeyCode
  | NewInput String
  | SubmitWord Bool
  | NoOp