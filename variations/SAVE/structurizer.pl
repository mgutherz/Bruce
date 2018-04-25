#
#
#
# structurizer
#
# takes a huge list of snippets and attempts to 
# put them into a structured order
#
# this module creates chromosomes that represent the
# structure.  the chromosomes will be evaluated and
# recombined until a desirable ordering comes out.
#



$sections = 5;


@TopThemes = ( 1, 17, 19, 37, 41, 383, 53, 31, 67, 97, 101, 103, 107, 113, 131, 717, 719, 737, 741, 7383, 753, 731, 767, 797, 7101, 7103, 7107, 7113, 7131, 511, 517, 911 );

# the Z theme is the "real" one, all others are variations upon it.
@GoodGenes = (
    'Z', 'Z', 'Z', 'Z', 'Z',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F',
);

@topiterations = (
    1, 1, 1, 1, 1,
    2, 2, 2, 2, 2, 2, 2, 2, 2,
    3, 3, 3, 3, 3, 3, 3,
    4, 4, 4,
    5, 5,
    6,
);

@botiterations = (
    1, 1, 
    2, 2, 2, 2, 2, 2,
    3, 3, 3, 3, 3,
    4, 4, 4,
);

@replist = (
    1, 1, 1, 1, 1, 1, 1,
    2, 2, 2, 2, 2,
    3, 3,
    4
);

sub randlog2 {
    my ($x) = @_;
    return int(rand(log($x) / log(2)));
}


sub choose_reps {
    return $replist[int(rand(@replist))];
}


srand(time | $$);

for (1..$sections) {
    for (1..($topiterations[ int(rand(@topiterations)) ])) {
	$top = $TopThemes[ int(rand(@TopThemes)) ];
	$last = "notme";
	for (1..$botiterations[ int(rand(@botiterations)) ]) {
	    do {
		$bot = $GoodGenes[ int(rand(@GoodGenes)) ];
	    } until ($bot ne $last);
	    $last = $bot;
	    $botreps = &choose_reps;
	    while ($botreps-- > 0) {
		print "OUT.$top/SCORE.$top.$bot \n" ;
	    }
	}
    }
}

