


sub init_ear {
    my ($m, $n);

    print "init_ear\n" ;
    $Quantum = 50;

    $halfsteps = {
	"maj" . 0 => 0,
	"maj" . 1 => 0,
	"maj" . 2 => 2,
	"maj" . 3 => 4,
	"maj" . 4 => 5,
	"maj" . 5 => 7,
	"maj" . 6 => 9,
	"maj" . 7 => 11,
	"min" . 0 => 0,
	"min" . 1 => 0,
	"min" . 2 => 2,
	"min" . 3 => 3,
	"min" . 4 => 5,
	"min" . 5 => 7,
	"min" . 6 => 8,
	"min" . 7 => 10,
    };

    #
    # put everything into G#/Ab
    #
    $offsets = {
	'G#' => 0,	'G' => -1,	'Gb' => -2,
	'F#' => -2,	'F' => -3,	'Fb' => -4,
	'E#' => -3,	'E' => -4,	'Eb' => -5,
	'D#' => -5,	'D' => -6,	'Db' => -7,
	'C#' => -7,	'C' => -8,	'Cb' => -9,
	'B#' => -8,	'B' => -9,	'Bb' => -10,
	'A#' => -10,	'A' => -11,	'Ab' => 0,
    };

    unless (open (EAR_GENE, "Ear.Gene")) {
	print "Error: EAR cannot open file Ear.Gene\n" ;
	return;
    }
    while (<EAR_GENE>) {
	chop;
	$ValidTransitions{ $_ } = $_;
    }
    #
    # transitions to & from nothing are valid
    #
    $ValidTransitions{ 0 } = 0;
    close(EAR_GENE);
}

srand(time | $$);
&init_ear;
$i=10000;
while ($i-- > 0) {
    $x = int(rand(hex("1000")));
    $y = int(rand(hex("1000")));
    printf("%04lx %04lx %d\n", $x, $y, &good_transition($x | ($y << 16)));
}





#
#
# good_transition
#
# given a transition (from == lower 2 bytes, to = upper 2 bytes)
# it weeps through the list of okay transitions, to see if it
# is a match or not.  returns boolean.
#
#
sub good_transition {
    my ($trans) = @_;
    my ($key, $val);

    #
    # just in case the exact transition exists ...
    #
    if ($ValidTransitions{ sprintf("08lx", $trans) }) {
	print "$trans is in the Assoc Array\n" ;
	return 1;
    }

    while (($key,$val) = each %ValidTransitions) {
	if ((hex($val) & $trans) == $trans) {
	    print sprintf("08lx", $trans), "  matches $val\n" ;
	    return 1;
	}
    }

    #
    # turn this back on when it's working
    #return 0;
    return 1;
}





sub print_chord {
    my ($q, $chord) = @_;

    print "m ", int($q / (100 / $Quantum)), " b ", 1 + $q % (100 / $Quantum);
    printf(", %03lx:\t ", $chord) ;
    print "root "	if ($chord & 1);
    print "dim2 "	if ($chord & (1 << 1));
    print "2maj "	if ($chord & (1 << 2));
    print "3min "	if ($chord & (1 << 3));
    print "3maj "	if ($chord & (1 << 4));
    print "4th "	if ($chord & (1 << 5));
    print "trit "	if ($chord & (1 << 6));
    print "5th "	if ($chord & (1 << 7));
    print "6min "	if ($chord & (1 << 8));
    print "6maj "	if ($chord & (1 << 9));
    print "7min "	if ($chord & (1 << 10));
    print "7maj "	if ($chord & (1 << 11));
    print "\tBAD"	if ($chord & 0x10000000);
    print "\n" ;
}





