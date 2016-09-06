module Tetris.Update exposing (update, tick)

import Time
import Tetris.Messages exposing (Msg(..))
import Tetris.Models exposing (Model, newShape)

update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
  case message of
    Tick ->
      ( model, Cmd.none )

    AddShape ->
      ( { model | shape = newShape [] }, Cmd.none )

tick : Model -> Time.Time -> ( Model, Cmd Msg )
tick model time =
  ( model, Cmd.none )