module Tetris.Update exposing (update)

import Random.Pcg exposing (Seed, step)
import Matrix
import Matrix exposing (loc, mapWithLocation, Matrix)
import Utils exposing (fromJust)
import Tetris.Messages exposing (Msg(..))
import Tetris.Models exposing (Model, Shape, Block, BlockType(..), newShape, emptyBlock)
import Tetris.Utils exposing (randomShapeType, randomShapeBlocks)

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

addShape : Model -> Seed -> Model
addShape model seed =
  let
    ( shapeType, seed1 ) = randomShapeType seed
    ( blocks, seed2 ) = randomShapeBlocks shapeType seed1
    shape = newShape shapeType blocks
  in
    { model |
      shape = shape,
      blocks = applyShape model.blocks ( fromJust shape )
    }

moveShape : Model -> Model
moveShape model =
  let
    oldShape = fromJust model.shape
    newShape =
      { oldShape |
        blocks = List.map
          (\block ->
            { block |
              location = ( loc ( (Matrix.row block.location) + 1 ) ( Matrix.col block.location ) )
            })
          oldShape.blocks
      }
  in
    { model |
      shape = Just newShape,
      blocks = applyShape ( unapplyShape model.blocks oldShape ) newShape
    }

unapplyShape : Matrix Block -> Shape -> Matrix Block
unapplyShape blocks shape =
  List.foldr
    (\block blocks -> Matrix.set block.location ( emptyBlock block.location ) blocks )
    blocks shape.blocks

applyShape : Matrix Block -> Shape -> Matrix Block
applyShape blocks shape =
  List.foldr
    (\block blocks -> Matrix.set block.location block blocks )
    blocks shape.blocks
