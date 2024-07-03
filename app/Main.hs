{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.GI.Base
import qualified GI.Gtk as Gtk
import Control.Monad (void)
import Data.Text (Text)
import qualified Data.Text as T
import Data.IORef

import InputWindow
import WinShortcut
import CreatePages(addNotebookPage, addPlainPage)

main :: IO ()
main = do
 -- Initialising main window
  Gtk.init Nothing

  win <- new Gtk.Window [ #title := "Hammy"
                        , #defaultWidth := 750
                        , #defaultHeight := 225
                        , #windowPosition := Gtk.WindowPositionCenter
                        , #decorated := True
                        , #resizable := True
                        ]

  Gtk.setContainerBorderWidth win 10
  
  notebook <- new Gtk.Notebook [] -- Main window's notebook
  Gtk.containerAdd win notebook
  
  addPlainPage notebook "Welcome to Hammy :)" "Welcome!"

  handleWinShortcuts win notebook
  
  on win #destroy Gtk.mainQuit
  #showAll win

  Gtk.main
