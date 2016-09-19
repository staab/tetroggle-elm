module Tetris.Utils exposing (randomShapeType, randomShapeBlocks)

import Array
import Matrix exposing (loc, Location)
import Random.Pcg exposing (int, map, step, Seed, Generator)
import Boggle.Utils exposing (randomLetter)
import Tetris.Models exposing (ShapeType(..), BlockType(..), Block)
import Utils exposing (fromJust, last)

shapeTypes : Array.Array ShapeType
shapeTypes =
  Array.fromList
    [ SquareShape
    , PipeShape
    , PyramidShape
    , LongShape
    , SnakeShape
    ]

shapeTypeGenerator : Generator ( Maybe ShapeType )
shapeTypeGenerator =
  map (\n -> Array.get n shapeTypes) ( int 0 ( ( Array.length shapeTypes ) - 1 ) )

randomShapeType : Seed -> (ShapeType, Seed)
randomShapeType seed =
  let
    ( shapeType, seed ) = step shapeTypeGenerator seed
  in
    ( fromJust shapeType, seed )

locationToFullBlock : Location -> Block
locationToFullBlock location =
  { blockType = FullBlock
  , location = location
  , letter = Nothing
  }

blockListFromShapeType : ShapeType -> (List Block)
blockListFromShapeType shapeType =
  case shapeType of
    SquareShape ->
      List.map locationToFullBlock
        [ loc 0 0, loc 1 0, loc 0 1, loc 1 1 ]
    PipeShape ->
      List.map locationToFullBlock
        [ loc 0 0, loc 1 0, loc 2 0, loc 2 1 ]
    PyramidShape ->
      List.map locationToFullBlock
        [ loc 1 0, loc 0 1, loc 1 1, loc 2 1 ]
    LongShape ->
      List.map locationToFullBlock
        [ loc 0 0, loc 1 0, loc 2 0, loc 3 0 ]
    SnakeShape->
      List.map locationToFullBlock
        [ loc 0 0, loc 1 0, loc 1 1, loc 2 1 ]

addLetterToBlock : Block -> Seed -> (Block, Seed)
addLetterToBlock block seed =
  let
    ( letter, newSeed ) = randomLetter seed
  in
    ( { block | letter = Just letter }, newSeed )

randomShapeBlocksReducer : Block -> (List Block, Seed) -> (List Block, Seed)
randomShapeBlocksReducer block (blocks, seed) =
  let
    (newBlock, newSeed) = addLetterToBlock block seed
  in
    (newBlock :: blocks, newSeed)

randomShapeBlocks : ShapeType -> Seed -> (List Block, Seed)
randomShapeBlocks shapeType seed =
  List.foldr randomShapeBlocksReducer ( [], seed ) ( blockListFromShapeType shapeType )