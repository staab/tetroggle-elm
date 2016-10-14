module Boggle.Models exposing (Model, initialModel)

type alias Model =
  { input : String }

initialModel : Model
initialModel =
  { input = "" }