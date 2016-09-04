module Tetris.Update exposing (update)

import Tetris.Messages exposing (Msg(..))
import Tetris.Models exposing (BlockId, Block, ShapeId, Shape, Tetris, newShape, newBlock)

update : Msg -> Tetris -> ( Tetris, Cmd Msg )
update message tetris =
  case message of
    CreateShape matrix ->
      ( tetris | shape = createShape matrix tetris, Cmd.none )

    RotateShape matrix ->
      ( tetris | shape = rotateShape tetris.shape matrix, Cmd.none )

    TranslateShape matrix ->
      ( tetris | shape = translateShape tetris.shape matrix, Cmd.none )

    SelectBlock blockId ->
      ( tetris | blocks = selectBlock tetris.blocks blockId, Cmd.none )

    UnselectBlock blockId ->
      ( tetris | blocks = unselectBlock tetris.blocks blockId, Cmd.none )

    TranslateBlock block matrix ->
      ( tetris | blocks = translateBlock tetris.blocks blockId, Cmd.none )