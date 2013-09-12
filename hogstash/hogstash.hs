import Hogstash.Inputs.Redis
import Hogstash.Event
import Hogstash.Outputs.Stdout

import Control.Concurrent
import Control.Concurrent.BoundedChan
import Control.Monad

main = forever $ do
           channel <- newBoundedChan 10
           forkIO $ forever $ getEvent tmpHaxx "logstash:beaver" channel
           forkIO $ forever $ stdout channel
