#!/usr/bin/perl

sub abs_{
  my($n) = @_;
  if ($n > 0)
  {
      return $n;
  }
  else
  {
      return -$n;
  }
}
print(abs_(5 + 2) * 3, 3 * abs_(5 + 2));


