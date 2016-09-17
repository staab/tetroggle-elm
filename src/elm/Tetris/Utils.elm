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

addLetterToBlock : Seed -> Block -> (Block, Seed)
addLetterToBlock seed block =
  let
    ( letter, seed ) = randomLetter seed
  in
    ( { block | letter = Just letter }, seed )

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

randomShapeBlocks : ShapeType -> Seed -> (List Block, Seed)
randomShapeBlocks shapeType seed =
  let
    results = List.map ( addLetterToBlock seed ) ( blockListFromShapeType shapeType )
  in
    ( List.map fst results, snd (fromJust ( last results ) ) )