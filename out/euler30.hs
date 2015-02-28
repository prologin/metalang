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
readIOA :: IOArray Int a -> Int -> IO a
readIOA = readArray
array_init :: Int -> ( Int -> IO out ) -> IO (IOArray Int out)
array_init len f = newListArray (0, len - 1) =<< g 0
  where g i =
           if i == len
           then return []
           else fmap (:) (f i) <*> g (i + 1)

main :: IO ()
main =
  {-
a + b * 10 + c * 100 + d * 1000 + e * 10 000 =
  a ^ 5 +
  b ^ 5 +
  c ^ 5 +
  d ^ 5 +
  e ^ 5
-}
  do p <- array_init 10 (\ i ->
                          return (i * i * i * i * i))
     let sum = 0
     let j a q =
           if a <= 9
           then let k b t =
                      if b <= 9
                      then let l c u =
                                 if c <= 9
                                 then let m d v =
                                            if d <= 9
                                            then let n e w =
                                                       if e <= 9
                                                       then let o f x =
                                                                  if f <= 9
                                                                  then do s <- ((+) <$> ((+) <$> ((+) <$> ((+) <$> ((+) <$> (readIOA p a) <*> (readIOA p b)) <*> (readIOA p c)) <*> (readIOA p d)) <*> (readIOA p e)) <*> (readIOA p f))
                                                                          let r = a + b * 10 + c * 100 + d * 1000 + e * 10000 + f * 100000
                                                                          if s == r && r /= 1
                                                                          then do printf "%d" (f :: Int) :: IO ()
                                                                                  printf "%d" (e :: Int) :: IO ()
                                                                                  printf "%d" (d :: Int) :: IO ()
                                                                                  printf "%d" (c :: Int) :: IO ()
                                                                                  printf "%d" (b :: Int) :: IO ()
                                                                                  printf "%d" (a :: Int) :: IO ()
                                                                                  printf " " :: IO ()
                                                                                  printf "%d" (r :: Int) :: IO ()
                                                                                  printf "\n" :: IO ()
                                                                                  let y = x + r
                                                                                  o (f + 1) y
                                                                          else o (f + 1) x
                                                                  else n (e + 1) x in
                                                                  o 0 w
                                                       else m (d + 1) w in
                                                       n 0 v
                                            else l (c + 1) v in
                                            m 0 u
                                 else k (b + 1) u in
                                 l 0 t
                      else j (a + 1) t in
                      k 0 q
           else printf "%d" (q :: Int) :: IO () in
           j 0 sum


