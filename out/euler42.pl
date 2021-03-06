#!/usr/bin/perl
sub nextchar{ sysread STDIN, $currentchar, 1; }
sub readchar{
  nextchar() if (!defined $currentchar);
  my $o = $currentchar;
  nextchar;
  return $o;
}
sub readint {
  nextchar() if (!defined $currentchar);
  my $o = 0, $sign = 1;
  if ($currentchar eq '-') {
    $sign = -1;
    nextchar;
  }
  while ($currentchar =~ /\d/){
    $o = $o * 10 + $currentchar;
    nextchar;
  }
  return $o * $sign;
}
sub readspaces {
  while ($currentchar eq ' ' || $currentchar eq "\r" || $currentchar eq "\n"){ nextchar(); }
}

sub is_triangular{
  my($n) = @_;
  #
  #   n = k * (k + 1) / 2
  #	  n * 2 = k * (k + 1)
  #   
  
  my $a = int(sqrt($n * 2));
  return $a * ($a + 1) eq $n * 2;
}

sub score{
  readspaces();
  my $len = readint();
  readspaces();
  my $sum = 0;
  foreach my $i (1 .. $len)
  {
      my $c = readchar();
      $sum = $sum + ord($c) - ord("A") + 1;
      #		print c print " " print sum print " " 
      
  }
  if (is_triangular($sum))
  {
      return 1;
  }
  else
  {
      return 0;
  }
}
foreach my $i (1 .. 55)
{
    if (is_triangular($i))
    {
        print($i, " ");
    }
}
print "\n";
my $sum = 0;
my $n = readint();
foreach my $i (1 .. $n)
{
    $sum = $sum + score();
}
print($sum, "\n");


