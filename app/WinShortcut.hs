{-# LANGUAGE OverloadedLabels #-}

module WinShortcut
  ( handleWinShortcuts
  ) where

import Data.GI.Base
import qualified GI.Gdk as Gdk
import qualified GI.Gtk as Gtk
import Control.Monad (void, when)
import Data.Text (Text)
import qualified Data.Text as T
import Data.IORef

import InputWindow
import CreatePages (addNotebookPage)

handleWinShortcuts :: Gtk.Window -> Gtk.Notebook -> IO ()
handleWinShortcuts win notebook = do
  void $ on win #keyPressEvent $ \eventKey -> do
    keyval <- get eventKey #keyval
    state <- get eventKey #state
    if keyval == Gdk.KEY_w && state == [Gdk.ModifierTypeControlMask]
      then do
        Gtk.mainQuit
        return True
      else if keyval == Gdk.KEY_n && state == [Gdk.ModifierTypeControlMask]
        then do
          userInput <- createInputWindow
          (todoBox, entry, listBox) <- addNotebookPage notebook userInput
          pageNum <- Gtk.notebookGetNPages notebook
          Gtk.notebookSetCurrentPage notebook (pageNum - 1)
          Gtk.widgetShowAll notebook
          return True
        else
          return False
