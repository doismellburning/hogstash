module Main where

import Hogstash.Inputs.Redis
import Hogstash.Outputs.Stdout

import Control.Concurrent
import Control.Concurrent.BoundedChan
import Control.Monad

channelSize :: Int
channelSize = 10

main = do
           channel <- newBoundedChan channelSize
           _ <- forkIO $ do
               connection <- getConnection redisInputConfig
               forever $ getEvent connection redisInputConfig channel
           _ <- forkIO $ forever $ stdout channel
           forever $ threadDelay 1000 -- Block forever

redisInputConfig = defaultRedisInputConfig { key = "logstash:beaver" }
