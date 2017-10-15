import Text.Printf
import Control.Applicative
import Control.Monad
import Data.Array.MArray
import Data.Array.IO
import Data.Char
import System.IO
import Data.IORef

main :: IO ()
main =
  printf "%d%d" (((abs (5 + 2)) * 3)::Int) ((3 * (abs (5 + 2)))::Int) :: IO()


