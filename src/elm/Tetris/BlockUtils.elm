module Tetris.BlockUtils exposing (moveBlock, blockCollision, isSameBlock, getCorner)

import Matrix exposing (Location, Matrix, row, col, loc, get)
import Utils exposing (fromJust)
import Tetris.Models exposing (Block, BlockType(EmptyBlock))

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

getCorner : (Location -> Int) -> (List Int -> Maybe a) -> (List Block -> a)
getCorner rowOrCol minOrMax =
  List.map .location >> List.map rowOrCol >> minOrMax >> fromJust