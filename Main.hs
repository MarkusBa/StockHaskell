import           DatabaseInteractions (initDb)
import           Requests (getSymbols)
  
doNothing :: IO (Int)
doNothing = return 42

main = getSymbols "yahoo"
