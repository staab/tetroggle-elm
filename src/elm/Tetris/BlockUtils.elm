module Tetris.BlockUtils exposing (
  moveBlock,
  blockCollision,
  isSameBlock,
  getCorner,
  getBBox,
  rotateBlock,
  adjustBlocks,
  inBlocks)

import Matrix exposing (Location, Matrix, row, col, loc, get)
import Utils exposing (fromJust)
import Tetris.Models exposing (Block, BlockType(EmptyBlock), BBox, gameSize)

moveBlock : Int -> Int -> Block -> Block
moveBlock rowDelta colDelta block =
  { block |
    location =
      loc ( ( row block.location ) + rowDelta ) ( ( col block.location ) + colDelta )
  }

blockCollision : List Block -> Matrix Block -> Bool
blockCollision list matrix =
  let
    collision : Block -> Bool
    collision block =
      let
        result = get block.location matrix
      in
        case result of
          Nothing -> True
          Just other -> other.blockType /= EmptyBlock
  in
    List.any collision list

isSameBlock : Block -> Block -> Bool
isSameBlock block1 block2 =
  block1.location == block2.location

inBlocks : List Block -> Block -> Bool
inBlocks blocks block =
  List.any ( isSameBlock block ) blocks

getCorner : (Location -> Int) -> (List Int -> Maybe a) -> (List Block -> a)
getCorner rowOrCol minOrMax =
  List.map .location >> List.map rowOrCol >> minOrMax >> fromJust

getBBox : List Block -> BBox
getBBox blocks =
    { minX = getCorner col List.minimum blocks
    , maxX = getCorner col List.maximum blocks
    , minY = getCorner row List.minimum blocks
    , maxY = getCorner row List.maximum blocks
    }

rotateBlock : Int -> Int -> Block -> Block
rotateBlock cx cy block =
  let
    x = col block.location
    y = row block.location
  in
    { block |
      location = loc
                   ( ( negate ( x - cx ) ) + cy )
                   ( ( y - cy ) + cx )
    }

adjustBlock : Int -> Int -> Block -> Block
adjustBlock dx dy block =
  let
    x = col block.location
    y = row block.location
  in
    { block | location = loc ( y + dy ) ( x + dx ) }

getXAdjustment : BBox -> Int
getXAdjustment bbox =
  if bbox.minX < 0 then
    negate bbox.minX
  else if bbox.maxX > gameSize.width then
    negate ( bbox.maxX - gameSize.width )
  else
    0

getYAdjustment : BBox -> BBox -> Int
getYAdjustment oldBBox newBBox =
  oldBBox.maxY - newBBox.maxY

adjustBlocks : List Block -> List Block -> List Block
adjustBlocks oldBlocks newBlocks =
  let
    oldBBox = getBBox oldBlocks
    newBBox = getBBox newBlocks
    dx = getXAdjustment newBBox
    dy = getYAdjustment oldBBox newBBox
  in
    List.map ( adjustBlock dx dy ) newBlocks