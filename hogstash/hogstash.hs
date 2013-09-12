import Hogstash.Inputs.Redis
import Hogstash.Event
import Hogstash.Outputs.Stdout

import Control.Concurrent
import Control.Concurrent.BoundedChan
import Control.Monad

main = forever $ do
           channel <- newBoundedChan 10
           forkIO $ do
               connection <- tmpHaxx
               forever $ getEvent connection "logstash:beaver" channel
           forkIO $ forever $ stdout channel
