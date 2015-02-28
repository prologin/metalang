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
readIOA :: IOArray Int a -> Int -> IO a
readIOA = readArray
array_init :: Int -> ( Int -> IO out ) -> IO (IOArray Int out)
array_init len f = newListArray (0, len - 1) =<< g 0
  where g i =
           if i == len
           then return []
           else fmap (:) (f i) <*> g (i + 1)

main :: IO ()
devine0 nombre tab len =
  do min0 <- readIOA tab 0
     max0 <- readIOA tab 1
     let c = len - 1
     let b i f g =
           if i <= c
           then ifM ((((<) f) <$> (readIOA tab i)) <||> (((>) g) <$> (readIOA tab i)))
                    (return False)
                    (do h <- ifM (((>) nombre) <$> (readIOA tab i))
                                 (do j <- readIOA tab i
                                     return j)
                                 (return g)
                        k <- ifM (((<) nombre) <$> (readIOA tab i))
                                 (do l <- readIOA tab i
                                     return l)
                                 (return f)
                        ifM (((&&) (len /= i + 1)) <$> (((==) nombre) <$> (readIOA tab i)))
                            (return False)
                            (b (i + 1) k h))
           else return True in
           b 2 max0 min0

main =
  do nombre <- read_int
     skip_whitespaces
     len <- read_int
     skip_whitespaces
     tab <- array_init len (\ i ->
                             do tmp <- read_int
                                skip_whitespaces
                                return tmp)
     a <- devine0 nombre tab len
     if a
     then printf "True" :: IO ()
     else printf "False" :: IO ()


