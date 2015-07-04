module Test where

data MarkusTest = MarkusTest {
  markusName :: String
  }

justATest :: IO String
justATest = return $ markusName $ MarkusTest {markusName = "Test"}     
