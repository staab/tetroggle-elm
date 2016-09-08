module Tetris.Utils exposing (randomShapeType)

import Array
import Random.Pcg exposing (int, map, step, Seed, Generator)
import Tetris.Models exposing (ShapeType(..))
import Utils exposing (fromJust)

shapeTypes : Array.Array ShapeType
shapeTypes = Array.fromList [SquareShape, PipeShape, PyramidShape, LongShape, SnakeShape]

shapeTypeGenerator : Generator ( Maybe ShapeType )
shapeTypeGenerator =
  map (\n -> Array.get n shapeTypes) ( int 0 ( Array.length shapeTypes ) )

randomShapeType : Seed -> (ShapeType, Seed)
randomShapeType seed =
  let
    ( shapeType, seed ) = step shapeTypeGenerator seed
  in
    ( fromJust shapeType, seed )