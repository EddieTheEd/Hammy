{-# LANGUAGE OverloadedLabels #-}

module WinShortcut
  ( handleWinShortcuts
  ) where

import Data.GI.Base
import qualified GI.Gdk as Gdk
import qualified GI.Gtk as Gtk
import Control.Monad (void)

handleWinShortcuts :: Gtk.Window -> IO ()
handleWinShortcuts win = do
  void $ on win #keyPressEvent $ \eventKey -> do
    keyval <- get eventKey #keyval
    state <- get eventKey #state
    if keyval == Gdk.KEY_w && state == [Gdk.ModifierTypeControlMask]
      then do
        Gtk.mainQuit
        return True
      else
        return False
