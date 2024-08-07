{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

module Todo where

import Data.GI.Base
import qualified GI.Gtk as Gtk
import qualified GI.Gdk as Gdk
import Data.Text (Text)
import qualified Data.Text as T
import Control.Monad (unless)

createTodoUI :: IO (Gtk.Box, Gtk.Entry, Gtk.ListBox)
createTodoUI = do
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
          taskRow <- createTaskRow taskText
          #add listBox taskRow
          #showAll listBox
          Gtk.entrySetText entry ""

  on entry #activate addTask

  return (todoBox, entry, listBox)

createTaskRow :: Text -> IO Gtk.ListBoxRow
createTaskRow taskText = do
  row <- new Gtk.ListBoxRow []
  label <- new Gtk.Label [#label := taskText, #xalign := 0, #margin := 5]

  #add row label

  cssProvider <- new Gtk.CssProvider []
  Gtk.cssProviderLoadFromData cssProvider "label { color: grey; text-decoration: line-through; }"

  let toggleCompletion = do
        isCompleted <- Gtk.widgetGetSensitive label
        styleContext <- Gtk.widgetGetStyleContext label
        if isCompleted
          then do
            Gtk.widgetSetSensitive label False
            Gtk.styleContextAddProvider styleContext cssProvider 600
            -- TODO: save as deleted
          else do
            Gtk.widgetSetSensitive label True
            Gtk.styleContextRemoveProvider styleContext cssProvider
            -- TODO: remove as deleted
        Gtk.widgetQueueDraw row
  on row #keyPressEvent $ \eventKey -> do
    keyval <- get eventKey #keyval
    if keyval == Gdk.KEY_Delete
      then do
        toggleCompletion
        return True
      else return False

  #setCanFocus row True

  return row
