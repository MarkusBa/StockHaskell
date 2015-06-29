import           DatabaseInteractions (initDb)
      
doNothing :: IO (Int)
doNothing = return 42

main = doNothing
