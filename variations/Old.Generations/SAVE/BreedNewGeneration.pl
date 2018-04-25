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


@Ancestors = ('00', '01', '02', '03', '04', '05', '06', '07', '08', '09');

for (@Ancestors) {
    $filename = "Ear.Gene." . $_;
    unless (open (EAR_GENE, $filename)) {
	print "ERROR: cannot open $filename\n";
	next;
    }
    $Genes{ $_ } = join('',<EAR_GENE>) ;
    close(EAR_GENE);
}

$global_i = 0;

#while () {
  for (@Ancestors) {
    $parent1 = $_;
    for (@Ancestors) {
	$parent2 = $_;
	next if $parent1 eq $parent2;
	$xover = int(rand(length $Genes{ $parent1 }));
	&output_gene($Genes{$parent1}, $Genes{$parent2}, $xover);
    }
  }
#}


sub output_gene {
    my ($p1, $p2, $xover) = @_;

    exit(0) if $global_i >= 100;

    $filename = sprintf("> Offspring.%.2d", $global_i);
    unless (open (EAR_GENE, $filename)) {
	print "ERROR: cannot open $filename\n";
	return;
    }
    print EAR_GENE substr($p1, 0, $xover), substr($p2, $xover, (length $Genes{ $p1 }) - $xover);
    close(EAR_GENE);

    exit(0) if $global_i++ >= 99;
}
