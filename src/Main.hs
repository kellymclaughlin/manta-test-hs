{-# LANGUAGE OverloadedStrings #-}

import           Control.Concurrent
import qualified Data.ByteString.Lazy.Char8 as L8
import           Network.Connection
import           Network.HTTP.Client
import           Network.HTTP.Client.TLS
import           Network.HTTP.Simple


main :: IO ()
main = do
    let tlsSettings = TLSSettingsSimple True False False
        managerSettings = mkManagerSettings tlsSettings Nothing
        managerSettings' = managerSettings { managerConnCount = 1
                                           , managerIdleConnectionCount = 1
                                           , managerResponseTimeout = responseTimeoutNone
                                           }
        url = "https://172.26.19.126/kelly/stor/tmp?algorithm=RSA-SHA256&expires=1503343709&keyId=%2Fkelly%2Fkeys%2F44%3A15%3A3d%3Af2%3A35%3A84%3Ab9%3A08%3Aac%3A3a%3A44%3A91%3Adc%3Ad9%3A39%3A34&signature=DUPVdZanTrbJiAQUK0mUY2EyQeNFQGwT25bDb12B6f0T88LGnyJ7yJxp59Ld6yshHVsV7YN7%2F0v3Im64sJwyPq90ouF18L40Yp5bdVcfwfqtw7ETEz9ZziybplI3yNLtUIo2%2FnRghjkVVdMlQClgsV7BAIUurVDfeo3mfrGKOhHq9SsSnbrsGMOTSqAJR0%2FlmFQs3LHhCo4KOIhLM9HQZoxfa6jPPxgree4uploz70j2Y4HjlEhAa3R1C0aezRgVVPg1DxUD4gccI9CwOSllHYmwzQ%2FyoGiGCM7%2BYCYqgva0WV%2FXrTd%2BadE3w3%2BdDvUG6DchLdfF28tXfi58ioMaCA%3D%3D"

    manager <- newManager managerSettings'
    setGlobalManager manager

    initReq <- parseRequest url
    let req = initReq { method = "PUT"
                      , requestBody = RequestBodyLBS "snarf"
                      }

    response <- httpLBS req

    putStrLn $ "The status code was: " ++
               show (getResponseStatusCode response)
    print $ getResponseHeader "Content-Type" response
    L8.putStrLn $ getResponseBody response

    threadDelay $ 200 * 1000000

    _ <- httpLBS req

    return ()
