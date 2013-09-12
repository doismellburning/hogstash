module Hogstash.Inputs.Redis where

import Database.Redis

import Hogstash.Event

import Control.Concurrent
import Control.Concurrent.BoundedChan as BC
import qualified Data.ByteString.Char8 as BSC


eventFromByteString :: BSC.ByteString -> Event
eventFromByteString = undefined

listListen key = blpop [key] 0

tmpHaxx = defaultConnectInfo -- FIXME Remove this

getEvent :: ConnectInfo -> String -> BoundedChan Event -> IO ()

getEvent a b = getEvent' a (BSC.pack b)

getEvent' ci key channel = do
								fnar <- pullEvent ci key
								case fnar of
									Just e -> BC.writeChan channel e
									Nothing -> return ()

pullEvent :: ConnectInfo -> BSC.ByteString -> IO (Maybe Event)
pullEvent connect_info key = do
									conn <- connect defaultConnectInfo
									event_data <- runRedis conn $ listListen key
									return (case event_data of
										Left a -> Nothing
										Right a -> extractEvent a)

extractEvent :: Maybe (a, BSC.ByteString) -> Maybe Event
extractEvent = fmap (eventFromByteString . snd)

