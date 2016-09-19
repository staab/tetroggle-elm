module Tetris.BlockUtils exposing (moveBlock, blockCollision)

import Matrix exposing (Matrix, row, col, loc, get)
import Tetris.Models exposing (Block, BlockType(EmptyBlock))

moveBlock : Block -> Block
moveBlock block =
  { block |
    location =
      loc ( ( row block.location ) + 1 ) ( col block.location )
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