module Tetris.Select exposing (updateSelect, removeSelected)

import String
import Matrix
import Maybe
import Matrix exposing (row, col)
import Tetris.Models
    exposing
        ( Model
        , Shape
        , Block
        , BlockType(EmptyBlock, FullBlock, SelectedBlock)
        )
import Tetris.BlockUtils exposing (inBlocks, hasLetter, stompBlocks, isBlockType)
import Tetris.ShapeUtils exposing (blockInShape)


-- Wierd type definition, see
-- https://github.com/elm-lang/elm-compiler/blob/0.17.1/hints/recursive-alias.md


type alias Selection =
    { block : Block
    , next : NextSelections
    }


type NextSelections
    = NextSelections (List Selection)


updateSelect : Model -> String -> Model
updateSelect model word =
    let
        -- Unselect blocks
        blocks =
            Matrix.map unselectBlock model.blocks

        selectedBlocks =
            blocks
                |> Matrix.flatten
                |> List.filter (canSelect model.shape)
                |> findWord (String.toUpper word)
    in
        { model | blocks = Matrix.map (selectBlock selectedBlocks) blocks }


removeSelected : Model -> Model
removeSelected model =
    let
        selections =
            List.filter
                (isBlockType SelectedBlock)
                (Matrix.flatten model.blocks)

        blocks =
            stompBlocks selections model.blocks
    in
        { model | blocks = blocks }


canSelect : Maybe Shape -> Block -> Bool
canSelect shape block =
    not (blockInShape shape block) && block.blockType == FullBlock


selectBlock : List Block -> Block -> Block
selectBlock selection block =
    if inBlocks selection block then
        { block | blockType = SelectedBlock }
    else
        block


unselectBlock : Block -> Block
unselectBlock block =
    if block.blockType == SelectedBlock then
        { block | blockType = FullBlock }
    else
        block



-- Word tracing


splitWord : String -> Maybe ( String, String )
splitWord word =
    let
        uncons w =
            let
                parts =
                    w |> String.toUpper |> String.uncons
            in
                case parts of
                    Nothing ->
                        Nothing

                    Just ( head, tail ) ->
                        Just ( String.fromChar head, tail )

        parts1 =
            uncons word
    in
        case parts1 of
            Nothing ->
                Nothing

            Just ( head1, tail1 ) ->
                if head1 == "Q" then
                    let
                        parts2 =
                            uncons tail1
                    in
                        case parts2 of
                            Nothing ->
                                Nothing

                            Just ( head2, tail2 ) ->
                                if head2 == "U" then
                                    Just ( head1 ++ head2, tail2 )
                                else
                                    Just ( head1, tail1 )
                else
                    Just ( head1, tail1 )


flattenSelection : List Block -> Selection -> List Block
flattenSelection current selection =
    let
        (NextSelections unwrappedNext) =
            selection.next

        maybeNext =
            List.head unwrappedNext

        result =
            current ++ [ selection.block ]
    in
        case maybeNext of
            Nothing ->
                result

            Just next ->
                flattenSelection result next


findWord : String -> List Block -> List Block
findWord word allBlocks =
    let
        parts =
            splitWord word
    in
        case parts of
            Nothing ->
                []

            Just ( letter, tail ) ->
                let
                    maybeselection =
                        allBlocks
                            |> List.filter (hasLetter letter)
                            |> List.map (traceWordPath tail allBlocks)
                            |> List.filterMap identity
                            |> List.head
                in
                    case maybeselection of
                        Nothing ->
                            []

                        Just selection ->
                            flattenSelection [] selection


traceWordPath : String -> List Block -> Block -> Maybe Selection
traceWordPath word selectable start =
    let
        parts =
            splitWord word

        selectable =
            List.filter (\block -> block /= start) selectable

        selection =
            { block = start, next = NextSelections [] }

        recur : String -> List Block -> Maybe Selection
        recur tail nextBlocks =
            let
                next =
                    nextBlocks
                        |> List.map
                            (\nextBlock ->
                                traceWordPath tail selectable nextBlock
                            )
                        |> List.filterMap identity
            in
                if List.isEmpty next then
                    Nothing
                else
                    Just { selection | next = NextSelections next }
    in
        case parts of
            Nothing ->
                Just selection

            Just ( letter, tail ) ->
                let
                    nextBlocks =
                        getNext selectable letter start
                in
                    if List.isEmpty nextBlocks then
                        Nothing
                    else
                        recur tail nextBlocks


getNext : List Block -> String -> Block -> List Block
getNext selectable letter around =
    getNeighbors around selectable
        |> List.filter (hasLetter letter)


getNeighbors : Block -> List Block -> List Block
getNeighbors block allBlocks =
    List.filter (isNeighbor block) allBlocks


isNeighbor : Block -> Block -> Bool
isNeighbor block1 block2 =
    not (block1 == block2)
        && absDiff col block1 block2
        < 2
        && absDiff row block1 block2
        < 2


absDiff : (Matrix.Location -> Int) -> Block -> Block -> Int
absDiff dim block1 block2 =
    abs ((dim block1.location) - (dim block2.location))
