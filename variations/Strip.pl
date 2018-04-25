#/bin/perl
while (<>) {
    ($a0, $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9, $aA, $aB, $aC) = split;
    next if $a1 eq "comment";
    next if $a1 eq "clear";
    next if $a1 eq "finis";
    next if $a1 eq "start";

    print "$a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $aA $aB $aC \n";
}


