module Tetris.Update exposing (update)

import Random.Pcg exposing (Seed)
import Tetris.Messages exposing (Msg(Tick, KeyPress, WindowHeightFail, WindowHeightDone))
import Tetris.Models exposing (Model, Block, BlockType(SelectedBlock, FullBlock))
import Tetris.ShapeUtils
    exposing
        ( addShape
        , moveShape
        , rotateShape
        , stompShape
        , modifyModelShape
        , isAboveGame
        , blockInShape
        , handleLeftArrow
        , handleRightArrow
        )


update : Msg -> Model -> Seed -> ( Model, Seed, Cmd Msg )
update message model seed =
    case model.gameOver of
        True ->
            ( model, seed, Cmd.none )

        False ->
            case message of
                WindowHeightFail ->
                    ( model, seed, Cmd.none )

                WindowHeightDone height ->
                    ( { model | windowHeight = height }, seed, Cmd.none )

                Tick time ->
                    case model.shape of
                        Nothing ->
                            let
                                ( newModel, newSeed ) =
                                    addShape model seed
                            in
                                ( newModel, newSeed, Cmd.none )

                        Just _ ->
                            let
                                ( shape, collision ) =
                                    moveShape model 1 0

                                newModel =
                                    -- Check against old shape pre-move
                                    if collision && isAboveGame model.shape then
                                        { model | gameOver = True }
                                    else if collision then
                                        { model | shape = Nothing }
                                    else
                                        modifyModelShape model (Just shape)
                            in
                                ( newModel, seed, Cmd.none )

                KeyPress code ->
                    case model.shape of
                        Nothing ->
                            ( model, seed, Cmd.none )

                        Just _ ->
                            case code of
                                37 ->
                                    ( handleLeftArrow model, seed, Cmd.none )

                                38 ->
                                    ( rotateShape model, seed, Cmd.none )

                                39 ->
                                    ( handleRightArrow model, seed, Cmd.none )

                                40 ->
                                    ( stompShape model, seed, Cmd.none )

                                _ ->
                                    ( model, seed, Cmd.none )
