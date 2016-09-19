module Tetris.Update exposing (update)

import Random.Pcg exposing (Seed)
import Tetris.Messages exposing (Msg(Tick))
import Tetris.Models exposing (Model)
import Tetris.ShapeUtils exposing (addShape, moveShape)

update : Msg -> Model -> Seed -> ( Model, Seed, Cmd Msg )
update message model seed =
  case message of
    Tick time ->
      case model.shape of
        Nothing ->
          let
            ( newModel, newSeed ) = addShape model seed
          in
            ( newModel, newSeed, Cmd.none )

        Just shape ->
          ( moveShape model, seed, Cmd.none )
