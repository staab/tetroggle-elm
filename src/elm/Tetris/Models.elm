module Tetris.Models exposing (BlockId, Block, Shape, Tetris, newShape, newBlock)

import Matrix exposing (Location)

type alias BlockId = Int

type alias Block =
  { id : BlockId
  , location : Location
  , selected : Bool
  }

type alias Shape =
  { id : ShapeId
  , blockIds : (List BlockId)
  }

type alias Tetris =
  { blocks : List Block
  , shape : Shape
  }

newShape : Shape
newShape blockIds =
  { blockIds = blockIds
  }

newBlock : Block
newBlock id location =
  { id = id
  , location = location
  }