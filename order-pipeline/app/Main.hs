module Main (main) where

import Messages (customerMessages, showMoney)
import Pipeline
import Types

demoOrders :: [(String, RawOrder)]
demoOrders =
  [ ("Good order", RawOrder "Test Customer" "test@example.com"
        [RawLine "BOLT-10" "2", RawLine "NUT-10" "4"] "tok_ok123")
  , ("Many mistakes at once", RawOrder "  " "not-an-email"
        [RawLine "bad sku" "abc"] "1234")
  , ("Out of stock", RawOrder "Test Customer" "test@example.com"
        [RawLine "DRILL-1" "3"] "tok_ok123")
  , ("Card declined", RawOrder "Test Customer" "test@example.com"
        [RawLine "BOLT-10" "1"] "tok_declined")
  , ("Payment outage", RawOrder "Test Customer" "test@example.com"
        [RawLine "BOLT-10" "1"] "tok_outage")
  ]

main :: IO ()
main = mapM_ run demoOrders
  where
    run (label, order) = do
      putStrLn ("== " ++ label)
      case processOrder sampleCatalogue mockGateway order of
        Right c -> do
          let Receipt r = confReceipt c
          putStrLn ("   OK. Total " ++ showMoney (confTotal c) ++ ", receipt " ++ r)
        Left err -> mapM_ (putStrLn . ("   - " ++)) (customerMessages err)
