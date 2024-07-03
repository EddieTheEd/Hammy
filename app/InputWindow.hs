{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

module InputWindow (createInputWindow) where

import Data.GI.Base
import qualified GI.Gtk as Gtk
import Control.Monad (void)
import qualified Data.Text as T
import Data.IORef

createInputWindow :: IO String
createInputWindow = do
  win <- new Gtk.Window [ #title := "Input Window"
                        , #defaultWidth := 300
                        , #defaultHeight := 50
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

  let submitInput = do
        input <- Gtk.entryGetText entry
        writeIORef userInput (T.unpack input)
        Gtk.widgetDestroy win 
        Gtk.mainQuit

  void $ on button #clicked submitInput

  void $ on entry #activate submitInput  -- Handle 'Enter' key press

  #showAll win
  Gtk.main
  readIORef userInput
