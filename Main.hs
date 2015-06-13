{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
import           Control.Monad.IO.Class  (liftIO)
import           Control.Monad.Logger    (runStderrLoggingT)
import           Database.Persist
import           Database.Persist.Postgresql
import           Database.Persist.TH
import           Data.Time (UTCTime, getCurrentTime)

--see also https://github.com/yesodweb/yesodweb.com-content/issues/107 for issue with UTCTime

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Player
    name String
    email String
    deriving Show
Item
    symbol String
    amount Int
    price Double
    idPlayer PlayerId
    ts UTCTime 
    deriving Show
|]

connStr = "host=localhost dbname=stockHaskell user=markus password=1234 port=5432"

initMe :: IO (Key Item)
initMe = runStderrLoggingT $ withPostgresqlPool connStr 10 $ \pool ->
  liftIO $ do
    flip runSqlPersistMPool pool $ do
      runMigration migrateAll

      idPlayer <- insert $ Player "Test" "test@test.com"
      time <- liftIO getCurrentTime
      idItem1 <- insert $ Item "CASH" 10000 1.0 idPlayer time
      insert $ Item "PAH3.DE" 0 0 idPlayer time
      
      
main = initMe
