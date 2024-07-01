{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.GI.Base
import qualified GI.Gtk as Gtk

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
  
  -- Testing notebooks
  notebook <- new Gtk.Notebook []
  label1 <- new Gtk.Label [ #label := "Page 1" ]
  label2 <- new Gtk.Label [ #label := "Page 2" ]
  tabLabel1 <- new Gtk.Label [ #label := "Tab 1" ]
  tabLabel2 <- new Gtk.Label [ #label := "Tab 2" ]
  widgetLabel1 <- Gtk.toWidget label1
  widgetLabel2 <- Gtk.toWidget label2
  _ <- Gtk.notebookAppendPage notebook widgetLabel1 (Just tabLabel1)
  _ <- Gtk.notebookAppendPage notebook widgetLabel2 (Just tabLabel2)
  
  #add win notebook
  on win #destroy Gtk.mainQuit
  #showAll win
  Gtk.main
