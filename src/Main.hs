module Main where

import Hogstash.Inputs.Redis
import Hogstash.Event
import Hogstash.Outputs.Stdout

import Control.Concurrent
import Control.Concurrent.BoundedChan
import Control.Monad

channelSize :: Int
channelSize = 10

main = do
           channel <- newBoundedChan channelSize
           forkIO $ do
               connection <- getConnection redisInputConfig
               forever $ getEvent connection redisInputConfig channel
           forkIO $ forever $ stdout channel
           forever $ threadDelay 1000 -- Block forever

redisInputConfig = defaultRedisInputConfig { key = "logstash:beaver" }
