#
#
# BreedNewGeneration
#
# takes a list of ancestors and creates a new generation of genes
# matching each ancestor against each other.
#
#
# given n ancestors, creates
#
#	n(n-1)
#
# offspring (each mating pair create two children).
#
#


# exit(0) unless open(EAR_GENE, "Ear.Gene.00");
# $foo = [ join(',', <EAR_GENE>) ];
# $bar = [ 1,2,3,4,5,6,7,8,9,0 ];
# print "EarGene.00 :\n";
# for (0..9) {
#     print $foo->[$_];
# }
# print "\n";
# for (0..9) {
#     print $bar->[$_];
# }
# print "\n";
# exit(0);


$Ancestors = {
	'0' => 3,
	'1' => 10,
	'2' => 2,
	'3' => 9,
	'4' => 3,
	'5' => 10,
	'6' => 6,
	'7' => 4,
	'8' => 0,
	'9' => 8,
	'A' => 8,
	'B' => 5,
	'C' => 4,
	'D' => 9,
	'E' => 11,
	'F' => 4,
};

srand(time | $$);

@nibbles = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');

for (@nibbles) {
    $filename = "Ear.Gene." . $_;
    unless (open (EAR_GENE, $filename)) {
	print "ERROR: cannot open $filename\n";
	next;
    }
    $Genes{ $_ } = join('',<EAR_GENE>) ;
    close(EAR_GENE);
}

$global_i = 0;

for ( ;; ) {
    $parent1 = $nibbles[ int(rand(@nibbles)) ];
    $parent2 = $nibbles[ int(rand(@nibbles)) ];
    next if $parent1 eq $parent2;
    $xover = int(rand(length $Genes{ $parent1 }));
    if (int(rand(200)) <= ($Ancestors->{ $parent1 } + $Ancestors->{ $parent2 })) {
	print STDERR "crossing $parent1 with $parent2 \n" ;
	&output_gene($Genes{$parent1}, $Genes{$parent2}, $xover);
    }
#    if (int(rand(100)) <= ($Ancestors->{ $parent1 } + $Ancestors->{ $parent2 })) {
#	print STDERR "crossing $parent1 with $parent2 \n" ;
#	&output_gene($Genes{$parent2}, $Genes{$parent1}, $xover);
#    }
}


sub output_gene {
    my ($p1, $p2, $xover, $bit) = @_;

    exit(0) if $global_i >= 16;

    $filename = sprintf("> Offspring.%s", $nibbles[ $global_i ]);
    unless (open (EAR_GENE, $filename)) {
	print "ERROR: cannot open $filename\n";
	return;
    }
    print EAR_GENE substr($p1, 0, $xover);
    if (substr($p2, $xover, 1) eq "\n") {
	print EAR_GENE "\n";
    } else {
	print EAR_GENE $nibbles[ int(rand(@nibbles)) ];
    }
    #print EAR_GENE substr($p2, $xover + 1, (length $Genes{ $p1 }) - $xover - 1);
    print EAR_GENE substr($p2, $xover + 1);
    close(EAR_GENE);

    exit(0) if $global_i++ >= 99;
}
