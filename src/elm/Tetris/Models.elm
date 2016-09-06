module Tetris.Models exposing (..)

import Maybe
import Matrix exposing (Location, Matrix, matrix)
import Random.Pcg exposing (Seed, step)
import Boggle.Utils exposing (randomLetter)

type BlockType
  = EmptyBlock
  | FullBlock
  | SelectedBlock

type alias Block =
  { blockType : BlockType
  , letter : Maybe String
  }

type alias Shape =
  { locations : (List Location)
  }

type alias Model =
  { blocks : Matrix Block
  , shape : Maybe Shape
  }

newShape : List Location -> Shape
newShape locations =
  { locations = locations
  }

randomBlock : Seed -> Block
randomBlock seed =
  let
    (letter, seed) = ( step randomLetter seed )
  in
    { blockType = FullBlock, letter = letter }

initialModel : Model
initialModel =
  { blocks = matrix 20 15 (\location -> { blockType = EmptyBlock, letter = Nothing} )
  , shape = Nothing
  }