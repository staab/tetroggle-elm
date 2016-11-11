module Tetris.BlockUtils exposing (
  moveBlock,
  blockCollision,
  isSameBlock,
  getCorner,
  getBBox,
  rotateBlock,
  adjustBlocks,
  inBlocks,
  hasLetter,
  stompBlocks,
  isInGame,
  isBlockType)

import String
import Matrix exposing (Location, Matrix, flatten, row, col, loc, get, set)
import Utils exposing (fromJust, last, between)
import Tetris.Models exposing (Block, BlockType(EmptyBlock, SelectedBlock), BBox, gameSize, emptyBlock)

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

isBlockType : BlockType -> Block -> Bool
isBlockType blockType block =
  block.blockType == blockType

inBlocks : List Block -> Block -> Bool
inBlocks blocks block =
  List.any ( isSameBlock block ) blocks

isInGame : Location -> Bool
isInGame location =
  row location > gameSize.height
  || between 0 gameSize.width ( col location )


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

hasLetter : Char -> Block -> Bool
hasLetter letter block =
  case block.letter of
    Nothing -> False
    Just blockLetter -> blockLetter == ( letter |> String.fromChar |> String.toUpper)

stompColumnBlock : Int -> Int -> Matrix Block -> Matrix Block
stompColumnBlock x y blocks =
  let
    newLocation = ( loc y x )
    maybeAboveBlock = Matrix.get (loc ( y - 1 ) x) blocks
    aboveBlock =
      case maybeAboveBlock of
        Nothing -> emptyBlock newLocation
        Just block -> block
  in
    set newLocation aboveBlock blocks

stompColumn : Matrix Block -> Location -> Matrix Block
stompColumn blocks location =
  List.foldl
    ( stompColumnBlock ( col location ) )
    blocks
    -- Start at bottom
    ( List.reverse [0..(row location)] )

stompBlock : Matrix Block -> Block -> Matrix Block
stompBlock blocks block =
  let
    belowLocation = loc ( ( row block.location ) + 1 ) ( col block.location )
    maybeBelowBlock = Matrix.get belowLocation blocks
  in
    case maybeBelowBlock of
      Nothing ->
        blocks

      Just belowBlock ->
        case belowBlock.blockType of
          EmptyBlock ->
            if isInGame belowLocation then
              stompColumn blocks block.location
            else
              blocks

          _ ->
            blocks

stompBlocks : List Block -> Matrix Block -> Matrix Block
stompBlocks selections blocks =
  List.foldl
    (\selection blocks -> stompBlock blocks selection )
    blocks
    -- Start at the bottom
    ( List.sortBy
        (\selection -> gameSize.height - row selection.location)
        selections )