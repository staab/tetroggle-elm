module Tetris.ShapeUtils exposing (addShape, moveShape, unapplyShape, applyShape)

import Random.Pcg exposing (Seed)
import Matrix exposing (set, row, col, Location, Matrix)
import Utils exposing (fromJust, between)
import Tetris.Models exposing (Model, Shape, Block, newShape, emptyBlock, gameSize)
import Tetris.Utils exposing (randomShapeType, randomShapeBlocks)
import Tetris.BlockUtils exposing (moveBlock, blockCollision, isSameBlock)

addShape : Model -> Seed -> (Model, Seed)
addShape model seed =
  let
    ( shapeType, seed1 ) = randomShapeType seed
    ( blocks, seed2 ) = randomShapeBlocks shapeType seed1
    shape = newShape shapeType blocks
    newModel =
      { model |
        shape = shape,
        blocks = applyShape model.blocks ( fromJust shape )
      }
  in (newModel, seed2)

moveShape : Model -> Model
moveShape model =
  let
    oldShape = fromJust model.shape
    newBlocks = List.map moveBlock oldShape.blocks
    collision = shapeCollision oldShape.blocks newBlocks model.blocks
    newShape = { oldShape | blocks = newBlocks }
  in
    { model |
      shape = if collision then Nothing else Just newShape,
      blocks =
        if collision then
          model.blocks
        else
          applyShape ( unapplyShape model.blocks oldShape ) newShape
    }

unapplyShape : Matrix Block -> Shape -> Matrix Block
unapplyShape blocks shape =
  List.foldr
    (\block blocks -> set block.location ( emptyBlock block.location ) blocks )
    blocks shape.blocks

applyShape : Matrix Block -> Shape -> Matrix Block
applyShape blocks shape =
  List.foldr
    (\block blocks -> set block.location block blocks)
    blocks shape.blocks

shapeCollision : List Block -> List Block -> Matrix Block -> Bool
shapeCollision oldBlocks newBlocks blocks =
  let
    checkBlocks =
      List.filter (\block -> not ( List.any ( isSameBlock block ) oldBlocks ) ) newBlocks
  in
    -- Check the bottom of the game
    List.any ( .location >> isInGame >> not ) checkBlocks
    -- Check any blocks below
      || ( blockCollision checkBlocks blocks )

isInGame : Location -> Bool
isInGame location =
  row location > gameSize.height || between 0 gameSize.width ( col location )