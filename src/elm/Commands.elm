module Commands exposing (getWindowSize)

import Task
import Window exposing (size)
import Messages exposing (Msg(WindowSizeFail, WindowSizeDone))


getWindowSize : Cmd Msg
getWindowSize =
    Task.perform (always WindowSizeFail) WindowSizeDone size
