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

$Top_themes = 10;
$Mid_themes = 20;
$Bot_themes = 40;

$movements = 4;

@replist = (
    1, 1, 1, 1,
    2, 2, 2,
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



for (1..$movements) {
    print "Movement $_ \n";

    for (1..(&randlog2($Top_themes) + 1)) {
	$top = int(rand($Top_themes));
	$topreps = &choose_reps;
	for (1..(&randlog2($Mid_themes) + 1)) {
	    $mid = int(rand($Mid_themes));
	    $midreps = &choose_reps;
	    for (1..(&randlog2($Bot_themes) + 1)) {
		$bot = int(rand($Bot_themes));
		$botreps = &choose_reps;
		while ($botreps-- > 0) {
		    printf("%02ld.%02ld.%02ld\n", $top, $mid, $bot);
		}
	    }
	}
    }
}

