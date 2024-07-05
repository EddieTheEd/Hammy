{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

module Config (configSearch) where

import System.Directory (getHomeDirectory, doesFileExist)
import System.FilePath ((</>))

configSearch :: IO String
configSearch = do
  homeDir <- getHomeDirectory
  let configFilePath = homeDir </> ".config" </> "hammyconf"
  fileExists <- doesFileExist configFilePath
  if fileExists
    then readFile configFilePath
    else return ""
