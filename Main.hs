import           DatabaseInteractions (initDb,getItems)
import           Requests (getSymbols,getStocks,getHistory)
import           Database.Persist.Postgresql

doNothing :: IO (Int)
doNothing = return 42

--main = getSymbols "yahoo"
--main = getStocks ["YHOO.MX"]
--main = getStocks ["YHOO.MX","YHOO"]
--main = getHistory "BAS.DE" "0" "1" "2000" "0" "31" "2010" "w" 
main = getItems $ toSqlKey 1
