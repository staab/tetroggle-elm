module Tetris.Models exposing (..)

import Matrix exposing (Location, Matrix, matrix)

type alias BlockId = Int

type BlockType
  = EmptyBlock
  | FullBlock
  | SelectedBlock

type alias Block =
  { id : BlockId
  , blockType : BlockType
  , letter : Char
  }

type alias Shape =
  { blockIds : (List BlockId)
  }

type alias Tetris =
  { blocks : Matrix Block
  , shape : Maybe Shape
  }

newShape : List BlockId -> Shape
newShape blockIds =
  { blockIds = blockIds
  }

newBlock : BlockId -> Char -> Block
newBlock id letter =
  { id = id
  , blockType = EmptyBlock
  , letter = letter
  }

initialModel : Tetris
initialModel =
  { blocks = matrix 20 15 (\location -> (newBlock 1 'A'))
  , shape = Nothing
  }