require "scanf.rb"
def abs_( n )
  if n > 0 then
      return n
  else 
      return -n
  end
end
printf "%d%d", abs_(5 + 2) * 3, 3 * abs_(5 + 2)
