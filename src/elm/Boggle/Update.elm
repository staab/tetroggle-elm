module Boggle.Update exposing (update)

import Boggle.Models exposing (Model)
import Boggle.Messages exposing (Msg(NewInput))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NewInput input ->
      ( { model | input = input }, Cmd.none )