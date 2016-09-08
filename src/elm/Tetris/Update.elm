module Tetris.Update exposing (update, tick)

import Time
import Random.Pcg exposing (Seed, step)
import Tetris.Messages exposing (Msg(..))
import Tetris.Models exposing (Model, Block, BlockType(..), newShape)
import Tetris.Utils exposing (randomShapeType)

update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
  ( model, Cmd.none )

tick : Model -> Time.Time -> Seed -> ( Model, Cmd Msg )
tick model time seed =
  case model.shape of
    Nothing ->
      ( addShape seed model, Cmd.none )

    Just shape ->
      ( model, Cmd.none )

addShape : Seed -> Model -> Model
addShape seed model =
  let
    ( shapeType, seed ) = randomShapeType seed
  in
    { model |
      shape = newShape shapeType
    }
