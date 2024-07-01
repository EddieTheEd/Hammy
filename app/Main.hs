{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.GI.Base
import qualified GI.Gtk as Gtk
import Data.Text (Text)
import qualified Data.Text as T
import Control.Monad (unless, void)

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
  todoBox <- new Gtk.Box [#orientation := Gtk.OrientationVertical, #spacing := 6]
  entry <- new Gtk.Entry [#placeholderText := "Enter a new task and press Enter"]
  listBox <- new Gtk.ListBox []
  scrolledWindow <- new Gtk.ScrolledWindow []
  #add scrolledWindow listBox
  
  #packStart todoBox entry False False 0
  #packStart todoBox scrolledWindow True True 0
  
  let addTask = do
        taskText <- Gtk.entryGetText entry
        unless (T.null taskText) $ do
          taskLabel <- new Gtk.Label [#label := taskText]
          #add listBox taskLabel
          #showAll listBox
          Gtk.entrySetText entry ""
  
  on entry #activate addTask
  
  tabLabel1 <- new Gtk.Label [#label := "Todo List"]
  
  void $ Gtk.notebookAppendPage notebook todoBox (Just tabLabel1)
  
  #add win notebook
  
  void $ on win #map $ do
    Gtk.widgetGrabFocus entry
  
  on win #destroy Gtk.mainQuit
  #showAll win
  Gtk.main
