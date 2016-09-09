module Tetris.Update exposing (update, tick)

import Time
import Random.Pcg exposing (Seed, step)
import Matrix exposing (loc, mapWithLocation)
import Utils exposing (fromJust)
import Tetris.Messages exposing (Msg(..))
import Tetris.Models exposing (Model, Shape, Block, BlockType(..), newShape, newBlock)
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
    shape = newShape
      shapeType
      [ newBlock FullBlock ( Just "A" ) ( loc 1 0 )
      , newBlock FullBlock ( Just "B" ) ( loc 2 0 )
      ]
  in
    { model |
      shape = shape,
      blocks = applyShape model.blocks ( fromJust shape )
    }

applyShape : List Block -> Shape -> List Block
applyShape blocks shape =
  List.map (\block -> block) blocks


