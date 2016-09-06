module Tetris.Models exposing (..)

import Maybe
import Matrix exposing (Location, Matrix, matrix)
import Random.Pcg exposing (Seed, step)
import Utils exposing (fromJust)
import Boggle.Utils exposing (randomLetter)

type alias BlockId = Int

type BlockType
  = EmptyBlock
  | FullBlock
  | SelectedBlock

type alias Block =
  { id : BlockId
  , blockType : BlockType
  , letter : String
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

newBlock : BlockId -> String -> Block
newBlock id letter =
  { id = id
  , blockType = EmptyBlock
  , letter = letter
  }

randomBlock : Seed -> Block
randomBlock seed =
  let
    (letter, seed) = ( step randomLetter seed )
  in
    newBlock 1 (fromJust letter)

init : Seed -> Tetris
init seed =
  { blocks = matrix 20 15 (\location -> randomBlock seed )
  , shape = Nothing
  }