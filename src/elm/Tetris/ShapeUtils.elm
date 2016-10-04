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
  adjustBlocksX)

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
    newBlocks = adjustBlocksX ( List.map ( rotateBlock cx cy ) oldShape.blocks )

    -- Adjust if necessary
    newShape = Just { oldShape | blocks = newBlocks }
  in
    { model |
      shape = newShape,
      blocks = replaceShape model.blocks oldShape ( fromJust newShape )
    }

--rotateShape : Model -> Model
--rotateShape model =
--  let
--    shape = (fromJust model.shape)
--    blocks = shape.blocks
--    minX = getCorner col List.minimum blocks
--    maxX = getCorner col List.maximum blocks
--    minY = getCorner row List.minimum blocks
--    maxY = getCorner row List.maximum blocks
--    cx = ((maxX - minX) // 2) + minX
--    cy = ((maxY - minY) // 2) + minY
--    newLocation : Block -> Location
--    newLocation block =
--      let
--        x = col block.location
--        y = row block.location
--      in
--        loc
--          ( ( negate ( x - cx ) ) + cy )
--          ( ( y - cy ) + cx )
--    newBlocks = List.map (\block -> { block | location = newLocation block }) blocks
--    newShape = Just { shape | blocks = newBlocks }
--  in
--    { model |
--      shape = newShape,
--      blocks = replaceShape model.blocks shape ( fromJust newShape )
--    }


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