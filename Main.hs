import           DatabaseInteractions (initDb)
import           Requests (getSymbols,getStocks)
  
doNothing :: IO (Int)
doNothing = return 42

--main = getSymbols "yahoo"
main = getStocks ["YHOO.MX"]
--main = getStocks ["YHOO.MX","YHOO"]

