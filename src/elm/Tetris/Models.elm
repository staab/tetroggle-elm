module Tetris.Models exposing (..)

import Maybe
import Matrix exposing (Location, Matrix, matrix, flatten)

type BlockType
  = EmptyBlock
  | FullBlock
  | SelectedBlock

type ShapeType
  = SquareShape
  | PipeShape
  | PyramidShape
  | LongShape
  | SnakeShape

type alias Block =
  { blockType : BlockType
  , letter : Maybe String
  , location : Location
  }

type alias Shape =
  { shapeType : ShapeType
  , blocks : List Block
  }

type alias Model =
  { blocks : List Block
  , shape : Maybe Shape
  }

initialModel : Model
initialModel =
  { blocks = flatten ( matrix 20 15 (\location -> newBlock EmptyBlock Nothing location ) )
  , shape = Nothing
  }

newBlock : BlockType -> Maybe String -> Location -> Block
newBlock blockType letter location =
  { blockType = EmptyBlock, letter = Nothing, location = location }

newShape : ShapeType -> List Block -> Maybe Shape
newShape shapeType blocks =
  Just { shapeType = shapeType, blocks = blocks }
