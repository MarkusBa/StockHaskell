import           DatabaseInteractions (initDb,getItems,order)
import           Requests (getSymbols,getStocks,getHistory)
import           Database.Persist.Postgresql
import           Test (justATest)

doNothing :: IO (Int)
doNothing = return 42

--main = getSymbols "yahoo"
--main = getStocks ["YHOO.MX"]
--main = getStocks ["YHOO.MX","YHOO"]
--main = getHistory "BAS.DE" "0" "1" "2000" "0" "31" "2010" "w" 
--main = getItems $ toSqlKey 1
--main = justATest
main = order "YHOO" 2 44.52 $ toSqlKey 1
