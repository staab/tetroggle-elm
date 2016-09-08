module Tetris.Models exposing (..)

import Maybe
import Matrix exposing (Location, Matrix, matrix)

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
  }

type alias Shape =
  { shapeType : ShapeType
  }

type alias Model =
  { blocks : Matrix Block
  , shape : Maybe Shape
  }

initialModel : Model
initialModel =
  { blocks = matrix 20 15 (\location -> { blockType = EmptyBlock, letter = Nothing} )
  , shape = Nothing
  }

newShape : ShapeType -> Maybe Shape
newShape shapeType =
  Just { shapeType = shapeType }