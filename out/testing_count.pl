#!/usr/bin/perl

my $tab = [];
foreach my $i (0 .. 39)
{
    $tab->[$i] = $i * $i;
}
print(0+@$tab, "\n");


