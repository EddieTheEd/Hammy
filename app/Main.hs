{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Data.GI.Base
import qualified GI.Gtk as Gtk
import Control.Monad (void)

import WinShortcut
import CreatePages (addPlainPage)
import Icon (addIcon)
import Config (configSearch)

main :: IO ()
main = do
  -- Initialising main window
  void $ Gtk.init Nothing
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

  addIcon win

  config <- configSearch -- find config file
  putStrLn config
  
  _ <- on win #destroy Gtk.mainQuit
  #showAll win

  Gtk.main
