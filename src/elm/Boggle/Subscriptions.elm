module Boggle.Subscriptions exposing (subscriptions)

import Keyboard
import Boggle.Models exposing (Model)
import Boggle.Messages exposing (Msg(KeyPress))

subscriptions : Model -> Sub Msg
subscriptions model =
  Keyboard.downs KeyPress