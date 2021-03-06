import Text.Printf
import Control.Applicative
import Control.Monad
import Data.Array.MArray
import Data.Array.IO
import Data.Char
import System.IO
import Data.IORef

(<&&>) a b =
	do c <- a
	   if c then b
		 else return False
(<||>) a b =
	do c <- a
	   if c then return True
		 else b
ifM :: IO Bool -> IO a -> IO a -> IO a
ifM c i e =
  do b <- c
     if b then i else e
skip_whitespaces :: IO ()
skip_whitespaces =
  ifM isEOF
      (return ())
      (do c <- hLookAhead stdin
          if c == ' ' || c == '\n' || c == '\t' || c == '\r' then
           do getChar
              skip_whitespaces
           else return ())
read_int_a :: Int -> IO Int
read_int_a b =
  ifM isEOF
      (return b)
      (do c <- hLookAhead stdin
          if isNumber c then
           do getChar
              read_int_a (b * 10 + ord c - 48)
           else return b)

read_int :: IO Int
read_int =
   do c <- hLookAhead stdin
      sign <- if c == '-'
                 then fmap (\x -> -1::Int) $ hGetChar stdin
                 else return 1
      (* sign) <$> read_int_a 0
writeIOA :: IOArray Int a -> Int -> a -> IO ()
writeIOA = writeArray
readIOA :: IOArray Int a -> Int -> IO a
readIOA = readArray
array_init :: Int -> ( Int -> IO out ) -> IO (IOArray Int out)
array_init len f = newListArray (0, len - 1) =<< g 0
  where g i =
           if i == len
           then return []
           else fmap (:) (f i) <*> g (i + 1)

main :: IO ()
find0 len tab cache x y =
  {-
	Cette fonction est récursive
	-}
  if y == len - 1
  then join $ readIOA <$> (readIOA tab y) <*> return x
  else if x > y
       then return (- 10000)
       else ifM (((/=) 0) <$> (join $ readIOA <$> (readIOA cache y) <*> return x))
                (join $ readIOA <$> (readIOA cache y) <*> return x)
                (do out0 <- find0 len tab cache x (y + 1)
                    out1 <- find0 len tab cache (x + 1) (y + 1)
                    a <- if out0 > out1
                         then (((+) out0) <$> (join $ readIOA <$> (readIOA tab y) <*> return x))
                         else (((+) out1) <$> (join $ readIOA <$> (readIOA tab y) <*> return x))
                    join $ writeIOA <$> (readIOA cache y) <*> return x <*> return a
                    return a)

find len tab =
  do tab2 <- array_init len (\ i ->
                               array_init (i + 1) (\ j ->
                                                     return 0))
     find0 len tab tab2 0 0

main =
  do len <- read_int
     skip_whitespaces
     tab <- array_init len (\ i ->
                              array_init (i + 1) (\ j ->
                                                    do tmp <- read_int
                                                       skip_whitespaces
                                                       return tmp))
     printf "%d\n" =<< ((find len tab)::IO Int)
     let b k =
           if k <= len - 1
           then let c l =
                      if l <= k
                      then do printf "%d " =<< ((join $ readIOA <$> (readIOA tab k) <*> return l)::IO Int)
                              c (l + 1)
                      else do printf "\n" :: IO ()
                              b (k + 1) in
                      c 0
           else return () in
           b 0


