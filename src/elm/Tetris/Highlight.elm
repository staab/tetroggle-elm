module Tetris.Highlight exposing (updateHighlight)

import String
import Matrix
import Maybe
import Matrix exposing (row, col)
import Utils exposing (fromJust, last)
import Tetris.Models exposing (
  Model,
  Shape,
  Block,
  BlockType(FullBlock, SelectedBlock))
import Tetris.BlockUtils exposing (inBlocks, hasLetter)
import Tetris.ShapeUtils exposing (blockInShape)


updateHighlight : Model -> String -> Model
updateHighlight model word =
  let
    -- Unselect blocks
    blocks = Matrix.map unhighlightBlock model.blocks
    selection = blocks
      |> Matrix.flatten
      |> List.filter ( canHighlight model.shape )
      |> findWord ( String.toUpper word )
      |> List.concatMap identity
  in
    { model | blocks = Matrix.map ( highlightBlock selection ) blocks }

canHighlight : Maybe Shape -> Block -> Bool
canHighlight shape block =
  not ( blockInShape shape block ) && block.blockType == FullBlock

findWord : String -> List Block -> List (List Block)
findWord word allBlocks =
  let
    parts = String.uncons word
  in
    case parts of
      Nothing -> []
      Just (letter, tail) ->
        allBlocks
          |> List.filter ( hasLetter letter )
          |> List.map (\block -> [block])
          |> List.map ( traceWordPath tail allBlocks )
          |> List.filterMap identity

traceWordPath : String -> List Block -> List Block -> Maybe (List Block)
traceWordPath word allBlocks selection =
  let
    parts = String.uncons word
  in
    case parts of
      Nothing -> Just selection
      Just (letter, tail) ->
        let
          maybeResult = addToSelection allBlocks letter selection
        in
          case maybeResult of
            Nothing -> Nothing
            Just result ->
              if String.isEmpty tail then
                Just result
              else
                traceWordPath tail allBlocks result

addToSelection : List Block -> Char -> List Block -> Maybe (List Block)
addToSelection allBlocks letter selection =
  let
    maybeNeighbor = getNeighbors ( fromJust ( last selection ) ) allBlocks
      |> List.filter ( hasLetter letter )
      |> List.filter ( \block ->  List.member block selection |> not )
      |> List.head
  in
    case maybeNeighbor of
      Nothing -> Nothing
      Just neighbor -> Just ( selection ++ [neighbor] )


highlightBlock : List Block -> Block -> Block
highlightBlock selection block =
  if inBlocks selection block then
    { block | blockType = SelectedBlock }
  else
    block

unhighlightBlock : Block -> Block
unhighlightBlock block =
  if block.blockType == SelectedBlock then
    { block | blockType = FullBlock }
  else
    block

getNeighbors : Block -> List Block -> List Block
getNeighbors block allBlocks =
  List.filter ( isNeighbor block ) allBlocks

isNeighbor : Block -> Block -> Bool
isNeighbor block1 block2 =
  not ( block1 == block2 )
  && absDiff col block1 block2 < 2
  && absDiff row block1 block2 < 2

absDiff : (Matrix.Location -> Int) -> Block -> Block -> Int
absDiff dim block1 block2 =
  abs ( ( dim block1.location ) - ( dim block2.location ) )