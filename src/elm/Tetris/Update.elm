module Tetris.Update exposing (update)

import Random.Pcg exposing (Seed)
import Tetris.Messages exposing (Msg(Tick, AddShape))
import Tetris.Models exposing (Model)
import Tetris.ShapeUtils exposing (addShape, moveShape)

update : Msg -> Model -> Seed -> ( Model, Cmd Msg )
update message model seed =
  case message of
    Tick time ->
      case model.shape of
        Nothing ->
          ( addShape model seed, Cmd.none )

        Just shape ->
          ( moveShape model, Cmd.none )

    AddShape ->
      (model, Cmd.none)
