module Requests where
 
import Network.HTTP
import Text.Regex.PCRE

-- Perform a basic HTTP get request and return the body
get :: String -> IO String
get url = simpleHTTP (getRequest url) >>= getResponseBody


getSymbolsRaw :: String -> IO String
getSymbolsRaw sym = get $ "http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=" ++ sym ++ "&callback=YAHOO.Finance.SymbolSuggest.ssCallback"

getSymbols :: String -> IO String
getSymbols sym = prefix >>= \x -> return $ x =~ "YAHOO.Finance.SymbolSuggest.ssCallback\\((.*?)\\)"
                  where prefix = getSymbolsRaw sym
