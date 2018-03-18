import Text.Printf
import Control.Applicative
import Control.Monad
import Data.Array.MArray
import Data.Array.IO
import Data.Char
import System.IO
import Data.IORef
count t = do
  (a,b) <- getBounds t
  return (b - a + 1)

array_init :: Int -> ( Int -> IO out ) -> IO (IOArray Int out)
array_init len f = newListArray (0, len - 1) =<< g 0
  where g i =
           if i == len
           then return []
           else fmap (:) (f i) <*> g (i + 1)

main :: IO ()
main =
  do tab <- array_init 40 (\ i ->
                             return (i * i))
     printf "%d\n" =<< ((count (tab))::IO Int)


