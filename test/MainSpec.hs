module MainSpec where

import Test.Hspec

spec :: Spec
spec = do
    describe "successes" $ do
        it "should have a basic notion of equality sufficient to demonstrate hspec" $
            2 == 2
