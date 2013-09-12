module Hogstash.Outputs.Stdout where

import Control.Concurrent.BoundedChan as BC

data Event = Event

eventToString :: Event -> String
eventToString = undefined

stdout :: BoundedChan Event -> IO ()
stdout channel = do 
                     event <- readChan channel
                     putStrLn $ eventToString event
