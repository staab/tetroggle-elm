module Tetris.Commands exposing (getWindowHeight)

import Task
import Window exposing (height)
import Tetris.Messages exposing (Msg(WindowHeightFail, WindowHeightDone))

getWindowHeight : Cmd Msg
getWindowHeight =
  Task.perform
    ( always WindowHeightFail )
    (\height -> WindowHeightDone height )
    height