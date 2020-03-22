module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--


import Browser
import Html exposing (Html, h2, span, div, text)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick, onMouseOut, onMouseOver)
import Maybe exposing (withDefault)


-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL

type alias Cell =
  { hover: Bool
  , key: Int
  , played: Bool
  , text: String
  , win: Bool
  }

type alias Model = 
  { cells: List Cell
  , header: String
  , turn: String
  , playing: Bool
  }

init : Model
init =
  { cells =
     [ { hover = False, key = 0, played = False, text = "", win = False } 
     , { hover = False, key = 1, played = False, text = "", win = False } 
     , { hover = False, key = 2, played = False, text = "", win = False } 
     , { hover = False, key = 3, played = False, text = "", win = False } 
     , { hover = False, key = 4, played = False, text = "", win = False } 
     , { hover = False, key = 5, played = False, text = "", win = False } 
     , { hover = False, key = 6, played = False, text = "", win = False } 
     , { hover = False, key = 7, played = False, text = "", win = False } 
     , { hover = False, key = 8, played = False, text = "", win = False } 
     ]
  , header = "x turn"
  , turn = "x"
  , playing = True
  }



-- UPDATE
isPlayed cell =
    cell.played

isDraw : List Cell -> Bool
isDraw cells =
  List.length (List.filter ((==) True) (List.map (\c -> c.played) cells)) == 9

isWin : List Cell -> List Int
isWin cells = 
  let
    combinations = 
      [ [ 0, 1, 2 ] -- horizontal
      , [ 3, 4, 5 ]
      , [ 6, 7, 8 ]
      , [ 0, 3, 6 ] -- vertical
      , [ 1, 4, 7 ]
      , [ 2, 5, 8 ]
      , [ 0, 4, 8 ] -- diagonal
      , [ 2, 4, 6 ]
      ]

    -- List.map ... combinations

    winningCells = []


    {-
    combinations.forEach(combination => {
        if (win) {
            return
        }

        const cells = [...document.querySelectorAll('.cell')]

        const combinationCells = cells.filter((cell, index) => combination.includes(index))

        win = combinationCells.every(cell => {
            return cell.innerHTML === turn
        })

        if (win) {
           combinationCells.forEach(cell => cell.classList.add('win'))
        }
    })

    return win
    -}


  in
  winningCells
  








type alias Identifyable a = { a | key : Int }

updateByKey : Identifyable a -> Identifyable a -> Identifyable a
updateByKey cell c =
  if c.key == cell.key then
    cell
  else
    c

type Msg
  = MouseOut Cell
  | MouseOver Cell
  | Play Cell


update : Msg -> Model -> Model
update msg model =
  case msg of
    MouseOut cell ->
      let
        c : Cell
        c = { cell | hover = False }

        cells: List Cell
        cells = List.map (updateByKey c) model.cells
      in
      { model | cells = cells}

    MouseOver cell ->
      let
        c : Cell
        c = { cell | hover = True }

        cells: List Cell
        cells = List.map (updateByKey c) model.cells
      in
      { model | cells = cells}

    Play cell ->
      let
        c = { cell
               | played = True
               , text = if cell.played then cell.text else model.turn
            }

        cells = List.map (updateByKey c) model.cells

        t = 
          if cell.played then
            model.turn
          else 
            if model.turn == "x" then
              "o"
            else
              "x"
        
        h = 
          let
            winningCells : List Int
            winningCells = isWin cells
          in
            if (List.length winningCells) > 0 then
              -- TODO: update the winning cells
              -- List.map (\i -> if List.member i.key winningCells then { i | win = True } else { i | win = False } )  cells

              t ++ " wins!"
            else
              if isDraw cells then
                  "draw..."
              else
                  t ++ " turn"

        -- TODO: isDraw
        -- TODO: isWin
      in
      { model 
         | cells = cells
         , header = h
         , turn = t
      }


-- VIEW HELPERS

viewCell : Cell -> Html Msg
viewCell cell =
    div [ classList
          [ ("cell", True)
          , ("hover", cell.hover) 
          , ("played", cell.played) 
          , ("win", cell.win) 
          ]
        , onClick (Play cell)
        , onMouseOut (MouseOut cell)
        , onMouseOver (MouseOver cell)
        ]
        [ text cell.text ]
        
-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text model.header ]
    , div [ class "container"] (List.map viewCell <| model.cells)
    ]