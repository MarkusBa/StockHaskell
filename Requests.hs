module Requests where
 
import Network.HTTP
 
-- Perform a basic HTTP get request and return the body
get :: String -> IO String
get url = simpleHTTP (getRequest url) >>= getResponseBody


getSymbols :: String -> IO String
getSymbols sym = get $ "http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=" ++ sym ++ "&callback=YAHOO.Finance.SymbolSuggest.ssCallback"
