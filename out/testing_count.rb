require "scanf.rb"

tab = [*0..40-1].map { |i|
  
  next i * i
  }
printf "%d\n", tab.count
