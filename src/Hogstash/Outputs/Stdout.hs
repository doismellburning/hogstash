module Hogstash.Outputs.Stdout where


import Control.Concurrent.BoundedChan as BC
import Hogstash.Event


eventToString :: Event -> String
eventToString = show

stdout :: BoundedChan Event -> IO ()
stdout channel = do 
                     event <- readChan channel
                     putStrLn $ eventToString event
