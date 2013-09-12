module Hogstash.Inputs.Redis where

import Database.Redis

import Hogstash.Event

import Control.Concurrent
import Control.Concurrent.BoundedChan as BC
import qualified Data.ByteString.Char8 as BSC
import Data.Map as Map

data RedisInputDataType = RedisList

data RedisInputConfig = RedisInputConfig
    { addField :: Map.Map String String
    , batchCount :: Integer
    , dataType :: RedisInputDataType
    , db :: Integer
    , debug :: Bool
    , host :: String
    , key :: String
    , password :: Maybe String
    , port :: Integer
    , tags :: [String]
    , threads :: Integer
    , timeout :: Integer
    , typeLabel :: Maybe String
    }

defaultRedisInputConfig :: RedisInputConfig
defaultRedisInputConfig = RedisInputConfig
    { addField = Map.empty
    , batchCount = 1
    , dataType = RedisList
    , db = 0
    , debug = False
    , host = "127.0.0.1"
    , key = "hogstash"
    , password = Nothing
    , port = 6379
    , tags = []
    , threads = 1
    , timeout = 5
    , typeLabel = Nothing
    }

eventFromByteString :: BSC.ByteString -> Event
eventFromByteString _ = Event

listListen key = blpop [key] 0

getConnection :: RedisInputConfig -> IO Connection
getConnection config = let connInfo = defaultConnectInfo -- TODO actually use config
                        in connect connInfo

getEvent :: Connection -> String -> BoundedChan Event -> IO ()

getEvent a b = getEvent' a (BSC.pack b)

getEvent' ci key channel = do
                                fnar <- pullEvent ci key
                                case fnar of
                                    Just e -> BC.writeChan channel e
                                    Nothing -> return ()

pullEvent :: Connection -> BSC.ByteString -> IO (Maybe Event)
pullEvent connection key = do
                                    event_data <- runRedis connection $ listListen key
                                    return (case event_data of
                                        Left a -> Nothing
                                        Right a -> extractEvent a)

extractEvent :: Maybe (a, BSC.ByteString) -> Maybe Event
extractEvent = fmap (eventFromByteString . snd)

