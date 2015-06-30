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

--Get the stock info for the list of symbols supplied.

{-
 The previous version with urlEncodeVars did not work properly:
 return $ getStocks ["\"YHOO.MX\""]
 "http://query.yahooapis.com/v1/public/yql?q=select%20%2A%20from%20yahoo.finance.quotes%20where%20symbol%20in%28YHOO.MX%29&env=http%3A%2F%2Fdatatables.org%2Falltables.env&format=json"
 It should look like this:
 "http://query.yahooapis.com/v1/public/yql?q=select+*+from+yahoo.finance.quotes+where+symbol+in%28%22YHOO%22%29&env=http%3A%2F%2Fdatatables.org%2Falltables.env&format=json"
-}

getStocks :: [String] -> IO String
getStocks symbols = get $ "http://query.yahooapis.com/v1/public/yql?" ++ getparams
                   where envparam = ("env", "http://datatables.org/alltables.env")
                         formatparam = ("format","json")
                         joinedSymbols = intercalate "%22,%22" symbols
                         qparam = ("q", "select+*+from+yahoo.finance.quotes+where+symbol+in%28%22" ++ joinedSymbols ++ "%22%29") 
                         getparams = "q=" ++ snd qparam ++ "&env=" ++ snd envparam ++ "&format=json"

-- Yeah, I know. Too many params...
-- getHistory "BAS.DE" "0" "1" "2000" "0" "31" "2010" "w"                         
getHistory :: String -> String -> String -> String -> String -> String -> String -> String -> IO String
getHistory symbol monthFrom dayFrom yearFrom monthTo dayTo yearTo stepSize = get $ "http://ichart.yahoo.com/table.csv?" ++ getparams
                                                                             where getparams = urlEncodeVars vars
                                                                                   vars = [("s", symbol),("a",monthFrom),("b",dayFrom),("c",yearFrom),("d",monthTo),("e",dayTo), ("f", yearTo),("g", stepSize)]
