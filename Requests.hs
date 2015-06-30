module Requests where
 
import Network.HTTP
import Text.Regex.PCRE
import Data.List (intercalate)

-- Perform a basic HTTP get request and return the body
get :: String -> IO String
get url = simpleHTTP (getRequest url) >>= getResponseBody


getSymbolsRaw :: String -> IO String
getSymbolsRaw sym = get $ "http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=" ++ sym ++ "&callback=YAHOO.Finance.SymbolSuggest.ssCallback"

-- Note that good regex examples can be found here: https://github.com/erantapaa/haskell-regexp-examples/blob/master/RegexExamples.hs

-- This is slightly complicated because of
-- 'No instance for (RegexContext Regex (IO String) (IO String))'
-- The accessors !! should never fail, otherwise the application should be reevaluated as a whole.
getSymbols :: String -> IO String
getSymbols sym = prefix >>= \x -> return $ justTheSecondMatch x
                  where prefix               = getSymbolsRaw sym
                        justTheSecondMatch x = extractInner x !! 0 !! 1
                        extractInner x       = x =~ "YAHOO.Finance.SymbolSuggest.ssCallback\\((.*?)\\)" :: [[String]]

--urlEncodeVars
--Get the stock info for the list of symbols supplied.                        
getStocks :: [String] -> IO String
getStocks symbols = get $ "http://query.yahooapis.com/v1/public/yql?" ++ getparams
                   where envparam = ("env", "http://datatables.org/alltables.env")
                         formatparam = ("format","json")
                         joinedSymbols = intercalate "%22,%22" symbols
                         qparam2 = ("q", "select * from yahoo.finance.quotes where symbol in(" ++ joinedSymbols ++ ")" )
                         qparam = ("q", "select+*+from+yahoo.finance.quotes+where+symbol+in%28%22" ++ joinedSymbols ++ "%22%29") 
                         getparams2 = urlEncodeVars [qparam, envparam, formatparam]
                         getparams = "q=" ++ snd qparam ++ "&env=" ++ snd envparam ++ "&format=json"
