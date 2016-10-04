module Tetris.ShapeUtils exposing (addShape, moveShape, rotateShape, stompShape)

import Random.Pcg exposing (Seed)
import Matrix exposing (set, row, col, loc, Location, Matrix)
import Utils exposing (fromJust, between)
import Tetris.Models exposing (Model, Shape, Block, newShape, emptyBlock, gameSize)
import Tetris.Utils exposing (randomShapeType, randomShapeBlocks)
import Tetris.BlockUtils exposing (
  moveBlock,
  blockCollision,
  isSameBlock,
  getCorner,
  getBBox,
  rotateBlock,
  adjustBlocks)

-- Model Updaters

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

moveShape : Model -> Int -> Int -> (Maybe Shape -> Maybe Shape) -> Model
moveShape model rowDelta colDelta onCollision =
  let
    oldShape = fromJust model.shape
    newBlocks = List.map ( moveBlock rowDelta colDelta ) oldShape.blocks
    collision = shapeCollision oldShape.blocks newBlocks model.blocks
    newShape = Just { oldShape | blocks = newBlocks }
  in
    if collision then
      { model | shape = onCollision model.shape }
    else
      { model |
        shape = newShape,
        blocks = replaceShape model.blocks oldShape ( fromJust newShape )
      }

-- Algorithm from http://stackoverflow.com/a/2259502/1467342
-- translate shape to origin, rotate, translate back
rotateShape : Model -> Model
rotateShape model =
  let
    -- Alias for readability
    oldShape = fromJust model.shape

    -- Get bounding box
    oldBBox = getBBox oldShape.blocks

    -- Get center
    cx = ((oldBBox.maxX - oldBBox.minX) // 2) + oldBBox.minX
    cy = ((oldBBox.maxY - oldBBox.minY) // 2) + oldBBox.minY

    -- Rotate the blocks
    newBlocks =
      adjustBlocks
        oldShape.blocks
        ( List.map ( rotateBlock cx cy ) oldShape.blocks )

    -- Adjust if necessary
    newShape = Just { oldShape | blocks = newBlocks }
  in
    { model |
      shape = newShape,
      blocks = replaceShape model.blocks oldShape ( fromJust newShape )
    }

stompShape : Model -> Model
stompShape model =
  model

-- Helpers

getShapeDimensions : Shape -> (Int, Int)
getShapeDimensions shape =
  ( ( getCorner col List.maximum shape.blocks )
    - ( getCorner col List.minimum shape.blocks )
  , ( getCorner row List.maximum shape.blocks )
    - ( getCorner row List.minimum shape.blocks )
  )

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

replaceShape : Matrix Block -> Shape -> Shape -> Matrix Block
replaceShape blocks old new =
  applyShape ( unapplyShape blocks old ) new

shapeCollision : List Block -> List Block -> Matrix Block -> Bool
shapeCollision oldBlocks newBlocks blocks =
  let
    -- Quick function for checking. Only check blocks that aren't redundant,
    -- And which are in the actual game (not buffered above)
    shouldCheck : Block -> Bool
    shouldCheck block =
      not ( List.any ( isSameBlock block ) oldBlocks )
        && row block.location >= 0
    checkBlocks = List.filter shouldCheck newBlocks
  in
    -- Check the bottom of the game
    List.any ( .location >> isInGame >> not ) checkBlocks
    -- Check any blocks below
      || blockCollision checkBlocks blocks

isInGame : Location -> Bool
isInGame location =
  row location > gameSize.height
  || between 0 gameSize.width ( col location )