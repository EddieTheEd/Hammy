{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.GI.Base
import qualified GI.Gtk as Gtk
import Control.Monad (void)

import Todo
import WinShortcut

main :: IO ()
main = do
  Gtk.init Nothing

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
  
  #appendPage notebook todoBox (Just tabLabel1)
  #add win notebook
  
  handleWinShortcuts win
  
  void $ on win #map $ do
    Gtk.widgetGrabFocus entry
  
  on win #destroy Gtk.mainQuit
  #showAll win
  Gtk.main
