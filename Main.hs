import           DatabaseInteractions (initDb)
import           Requests (getSymbols,getStocks)
  
doNothing :: IO (Int)
doNothing = return 42

--main = getSymbols "yahoo"
main = getStocks ["YHOO.MX"]
--main = getStocks ["YHOO.MX","YHOO"]

--main = return $ getStocks ["\"YHOO.MX\""]
-- "http://query.yahooapis.com/v1/public/yql?q=select%20%2A%20from%20yahoo.finance.quotes%20where%20symbol%20in%28YHOO.MX%29&env=http%3A%2F%2Fdatatables.org%2Falltables.env&format=json"
-- Should look like this:
-- "http://query.yahooapis.com/v1/public/yql?q=select+*+from+yahoo.finance.quotes+where+symbol+in%28%22YHOO%22%29&env=http%3A%2F%2Fdatatables.org%2Falltables.env&format=json"
