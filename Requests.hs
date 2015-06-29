module Requests where
 
import Network.HTTP
import Text.Regex.PCRE

-- Perform a basic HTTP get request and return the body
get :: String -> IO String
get url = simpleHTTP (getRequest url) >>= getResponseBody


getSymbolsRaw :: String -> IO String
getSymbolsRaw sym = get $ "http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=" ++ sym ++ "&callback=YAHOO.Finance.SymbolSuggest.ssCallback"

-- Note that good regex examples can be found here: https://github.com/erantapaa/haskell-regexp-examples/blob/master/RegexExamples.hs

-- This is slightly complicated because of
-- 'No instance for (RegexContext Regex (IO String) (IO String))'
getSymbols :: String -> IO String
getSymbols sym = prefix >>= \x -> return $ justTheSecondMatch x
                  where prefix               = getSymbolsRaw sym
                        justTheSecondMatch x = extractInner x !! 0 !! 1
                        extractInner x       = x =~ "YAHOO.Finance.SymbolSuggest.ssCallback\\((.*?)\\)" :: [[String]]
