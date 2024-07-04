module Icon (addIcon) where

import qualified GI.Gtk as Gtk

import System.Directory (getHomeDirectory)
import System.FilePath ((</>))

addIcon :: Gtk.Window -> IO ()
addIcon win = do
  homeDir <- getHomeDirectory
  let iconPath = homeDir </> "Projects/Hammy/hammy.png"
  Gtk.windowSetIconFromFile win iconPath
