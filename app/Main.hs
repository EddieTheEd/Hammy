{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.GI.Base
import qualified GI.Gtk as Gtk
import Control.Monad (void)
import Data.Text (Text)
import qualified Data.Text as T
import Data.IORef

import Todo
import WinShortcut

main :: IO ()
main = do
  Gtk.init Nothing

  userInput <- createInputWindow 

  putStrLn $ "User input: " ++ userInput

  win <- new Gtk.Window [ #title := "Hammy"
                        , #defaultWidth := 750
                        , #defaultHeight := 225
                        , #windowPosition := Gtk.WindowPositionCenter
                        , #decorated := True
                        , #resizable := True
                        ]
  Gtk.setContainerBorderWidth win 10
  
  notebook <- new Gtk.Notebook []
  (todoBox, entry, listBox) <- createTodoUI
  tabLabel1 <- new Gtk.Label [#label := "Todo List"]
  
  Gtk.notebookAppendPage notebook todoBox (Just tabLabel1)
  Gtk.containerAdd win notebook
  
  handleWinShortcuts win
  
  void $ on win #map $ do
    Gtk.widgetGrabFocus entry
  
  on win #destroy Gtk.mainQuit
  #showAll win

  Gtk.main

createInputWindow :: IO String
createInputWindow = do
  win <- new Gtk.Window [ #title := "Input Window"
                        , #defaultWidth := 300
                        , #defaultHeight := 150
                        , #windowPosition := Gtk.WindowPositionCenter
                        , #decorated := True
                        , #resizable := True
                        ]

  entry <- new Gtk.Entry [#placeholderText := "Enter your input here"]

  button <- new Gtk.Button [#label := "Submit"]

  box <- new Gtk.Box [#orientation := Gtk.OrientationVertical, #spacing := 10]
  Gtk.containerAdd box entry
  Gtk.containerAdd box button
  Gtk.containerAdd win box

  userInput <- newIORef ""

  void $ on button #clicked $ do
    input <- Gtk.entryGetText entry
    writeIORef userInput (T.unpack input)
    Gtk.widgetDestroy win 
    Gtk.mainQuit

  #showAll win
  Gtk.main
  readIORef userInput
  -- can now be used by main!
