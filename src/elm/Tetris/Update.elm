module Tetris.Update exposing (update)

import Random.Pcg exposing (Seed, step)
import Matrix exposing (loc, mapWithLocation, map, Matrix)
import Utils exposing (fromJust)
import Tetris.Messages exposing (Msg(..))
import Tetris.Models exposing (Model, Shape, Block, BlockType(..), newShape, newBlock)
import Tetris.Utils exposing (randomShapeType)

update : Msg -> Model -> Seed -> ( Model, Cmd Msg )
update message model seed =
  case message of
    Tick time ->
      case model.shape of
        Nothing ->
          ( addShape seed model, Cmd.none )

        Just shape ->
          ( model, Cmd.none )

    AddShape ->
      (model, Cmd.none)

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

applyShape : Matrix Block -> Shape -> Matrix Block
applyShape blocks shape =
  map (\block -> block) blocks


