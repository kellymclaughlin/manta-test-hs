{-# LANGUAGE OverloadedStrings #-}

-- import           Control.Concurrent
import qualified Data.ByteString.Lazy.Char8 as L8
import           Network.Connection
import           Network.HTTP.Client
import           Network.HTTP.Client.TLS
import           Network.HTTP.Simple
-- import           Network.HTTP.Types.Header


main :: IO ()
main = do
    let tlsSettings = TLSSettingsSimple True False False
        managerSettings = mkManagerSettings tlsSettings Nothing
        managerSettings' = managerSettings { managerConnCount = 1
                                           , managerIdleConnectionCount = 1
                                           , managerResponseTimeout = responseTimeoutNone
                                           }
        url = "https://manta.orbit.example.com/kelly/stor/tmp?algorithm=RSA-SHA256&expires=1506620038&keyId=%2Fkelly%2Fkeys%2F61%3Af5%3A4a%3A9c%3Ac9%3A6b%3Aaa%3Ae4%3Ac5%3A7d%3A8d%3Ad7%3A89%3A75%3A8a%3A60&signature=hOONstgBaqieNzEN3Qm8jtWnsjxpfg55Rz2Gbxa9GNO6gHrMc1tDHyzHk%2FD8aQkDtsxcwN4MXQOqXW1iSmrK3FNcoCs7PAfnHESuwLZhPhWFX%2BmOzrryIlbuoec5BPRxcFdrEmQflitZCEMcGPk4%2BrvO3Kpi03GZ%2BGsHwEdoyU453qhkrxEplAijmUHdzRr8rcWaZicgeEmu6n%2BJYt4%2BhWQdMmsgONxBq2Fi2kQeO5md85fDZ%2F%2BkHMdFfZ%2B3C9TCIWmv5pCZ0mHeapG2uLCd3bRmBbrIwcvqPgN7G39B7Hn%2FRTmK%2B%2FTEh0b50cZZu2UfzlpEtXwrvVB1CIlnBa2Uxw%3D%3D"
        -- url = "http://127.0.0.1:8080/test.html"

    manager <- newManager managerSettings'
    setGlobalManager manager

    initReq <- parseRequest url
    let req = initReq { method = "PUT"
                      , requestBody = RequestBodyLBS $ L8.replicate 5000000 'a'
                      -- , requestHeaders = [ -- (hConnection, "Close")
                      --                      (hExpect, "100-continue")
                      --                    ]
                      }

    response <- httpLBS req

    putStrLn $ "The status code was: " ++
               show (getResponseStatusCode response)
    print $ getResponseHeader "Content-Type" response
    L8.putStrLn $ getResponseBody response
    -- threadDelay $ 140 * 1000000

    -- _ <- httpLBS req

    return ()
