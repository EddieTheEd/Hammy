{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

module CreatePages (addNotebookPage, addPlainPage) where

import Data.GI.Base
import qualified GI.Gtk as Gtk
import Control.Monad (void)
import Data.Text (Text)
import qualified Data.Text as T
import Data.IORef

import Todo

addNotebookPage :: Gtk.Notebook -> String -> IO (Gtk.Box, Gtk.Entry, Gtk.ListBox)
addNotebookPage notebook userInput = do
  (todoBox, entry, listBox) <- createTodoUI
  tabLabel1 <- new Gtk.Label [#label := T.pack userInput]
  
  pageNum <- Gtk.notebookAppendPage notebook todoBox (Just tabLabel1)
  Gtk.notebookSetCurrentPage notebook pageNum
  
  Gtk.widgetShowAll todoBox
  
  return (todoBox, entry, listBox)

addPlainPage :: Gtk.Notebook -> Text -> Text -> IO ()
addPlainPage notebook labelText windowText = do
  page <- new Gtk.Box [ #orientation := Gtk.OrientationVertical ]
  label <- new Gtk.Label [ #label := labelText ]
  Gtk.boxPackStart page label True True 0

  -- Center the label
  Gtk.widgetSetHalign label Gtk.AlignCenter
  Gtk.widgetSetValign label Gtk.AlignCenter

  tabLabel <- new Gtk.Label [ #label := windowText ]
  void $ Gtk.notebookAppendPage notebook page (Just tabLabel)
