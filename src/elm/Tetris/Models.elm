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


type alias BBox =
    { minX : Int
    , maxX : Int
    , minY : Int
    , maxY : Int
    }


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
    { blocks : Matrix Block
    , shape : Maybe Shape
    , windowHeight : Int
    , gameStarted : Bool
    , gameOver : Bool
    }


gameSize : { width : Int, height : Int }
gameSize =
    { width = 10, height = 15 }


initialModel : Model
initialModel =
    { blocks = matrix gameSize.height gameSize.width (\location -> emptyBlock location)
    , shape = Nothing
    , windowHeight = 0
    , gameStarted = False
    , gameOver = False
    }


emptyBlock : Location -> Block
emptyBlock location =
    { blockType = EmptyBlock, letter = Nothing, location = location }


newShape : ShapeType -> List Block -> Maybe Shape
newShape shapeType blocks =
    Just { shapeType = shapeType, blocks = blocks }
