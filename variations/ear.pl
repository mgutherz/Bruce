#
#
# ear.pl
#
#



@nibbles = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');


sub init_ear {
    my ($m, $n);

    print STDERR "init_ear\n" if $DEBUG;
    $Quantum = 25;
    $Badstr = 'BAD';
    $TotalSections = 0;
    $Iterations = 1;
    $BestSoFar = 1;

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

    NIBBLE:
    for (@nibbles) {
	my($genome) = $_;
	unless (open (EAR_GENE, $EarGene . '.' . $genome)) {
	    print STDERR "Error: EAR cannot open file ", $EarGene . '.' . $genome , "\n" ;
	    next NIBBLE;
	}
	push(@NIBBLES, $genome);
	$Seqnum = 0;
	while (<EAR_GENE>) {
	    chop;
	    $ValidTransitions{ $genome .'.'. $_ } = 1;
	    $ValidTransitions{ $genome .'.'. $Seqnum } = $_;
	    $Seqnum++;
	}
	#
	# transitions to & from nothing are valid
	#
	close(EAR_GENE);
    }

    print STDERR "Valid Genomes: @NIBBLES \n" if $DEBUG;

}






sub feed_score_to_ear {
    my ($x, $y, $z, $note, $dur, $i, $j, $k, $sections, $start);

    $start = 0;
    $BadSections = 0;
    $TotalTrans = 0;

    for ($i=0; $i<=$TotalSections; $i++) {
	$ToEar[ $i ] = 0;
    }

    for ($j=$ID_start; $j<$ID; $j++) {
	$start += $Phrases{ $j . $Measures } * (100 / $Quantum);
	$x = $Phrases{ $j . $Pitches };
	$y = $Phrases{ $j . $Rhythms };
	$z = $Phrases{ $j . $Articulations };
	$Phrases{ $j . $Modified } = 0;

	$sections = 0;
	for ($i=1; $i<=$x->[0]; $i++) {
	    $dur = $y->[$i] * $z->[$i];
	    #
	    # ignore grace notes (things that only last for a little bit)
	    # an ugly consequence of this is that all fast sequences are valid.
	    # oh well.  this makes sense, though, i think -- we do not want to
	    # have more than three sequential notes to have to stack up
	    #
	    $note = &convert($Phrases{ $j . $Key }, $Phrases{ $j . $Major }, $x->[$i]) ;
	    for ($k=0; $dur >= 10; $k++, $dur -= $Quantum) {
		$ToEar[ int($sections / $Quantum) + $start + $k ] |= $note ;
	    }
	    if ($TotalSections < int($sections / $Quantum) + $start + $k) {
		$TotalSections = int($sections / $Quantum) + $start + $k;
	    }
	    $sections += $y->[$i];
	    
	    $BadList{ $TotalSections } = $j;
	}
    }

    print STDERR "TotalSections: $TotalSections \n" if $DEBUG;

    $i = $ToEar[0];
    for ($j=1; $j<=$TotalSections; $j++) {
	if ($i == $ToEar[$j]) {
	    $ToEar[$j] = 0;
	} else {
	    $i = $ToEar[$j];
	}
    }

    if ($DEBUG) {
	my ($a);

	print STDERR "BEGIN NOTE LIST\n" ;
	for ($j=0; $j<$ID; $j++) {
	    for (@NoteTypes) {
		$a = $Phrases{ $j.$_ };
		&print_array($a, $a->[0], 'NOTE-LIST');
	    }
	}
	print STDERR "END NOTE LIST\n" ;

	print STDERR "BEGIN TRANSITION LIST\n" ;
	for ($j=0; $j<=$TotalSections; $j++) {
	    printf STDERR "CHORD: %08lx \n", $ToEar[$j];
	    &print_chord($j, $ToEar[$j]);
	}
	print STDERR "END TRANSITION LIST\n" ;
    }

    for ($i=0; $i<$TotalSections; &print_chord($j, $ToEar[$j])) {
	do { $x = $ToEar[$i]; }
	    until ($x || ++$i>=$TotalSections);

	$j = $i;
	$i++;

	do { $y = $ToEar[$i]; }
	    until ($y || ++$i>=$TotalSections);

	$TotalTrans++;
	return if $i >= $TotalSections;

	next unless &bad_transition($x, $y);

	$ToEar[$j] |= 0x10000000;
	$BadList{ $BadSections . $Badstr } = $BadList{ $j };
	$BadSections++;
    }

}


sub ear_still_listening {
    if ($BadSections / $TotalTrans <= $BestSoFar) {
	$BestSoFar = $BadSections / $TotalTrans;
	&save_this_score($Iterations);
    }
    if ($Iterations++ > $MaxIts) {
	print STDERR "Best: ", $BestSoFar * 100, "\n";
	return 0;
    }
    return 1;
}

sub ear_dislikes_it {
    my ($result);

    for (@NIBBLES) {
	print STDERR "GENOME $_ voted against ", $VotesAgainst{ $_ }, " transitions\n";
	if ($VotesAgainst{ $_ }) {
	    $result++;
	}
    }

    print STDERR "ear_dislikes_it: $BadSections Bad Sections out of $TotalTrans Total Transitions: ",
		(100 * $BadSections / $TotalTrans), ($result < @NIBBLES) ? " (PASS) \n" : " (FAIL) \n" if $DEBUG2;
    return $result;
}



#
#
# convert
#
# given a note value, turns it into a bit
#
#
sub convert {
    my ($key, $major, $note) = @_;

    return 0 if $note eq $rest;

    $note = (($note + 79) % 8) + 1;
    $note = ($offsets->{$key} + $halfsteps->{ $major . $note } + 60) % 12;
    return (1 << $note);
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
sub bad_transition {
    my ($from, $to) = @_;
    my ($ret, $i, $j, $vfrom, $vto, $cfrom, $cto);

    $ret = 0;

    printf (STDERR "TRANSITION: %08lx -> %08lx \n", $from, $to) if $DEBUG;
    print STDERR "TRANSITION VOTES AGAINST: [ " if $DEBUG;

    NIBBLE:
    for (@NIBBLES) {

	#
	# just in case the exact transition exists ...
	#
	next if ($ValidTransitions{ $_ .'.'. $from } && $ValidTransitions{ $_ .'.'. $to });

	for ($i=0; $i<$Seqnum; $i++) {

	    $vfrom	= hex($ValidTransitions{ $_ .'.'. $i });
	    if ($i+1 == $Seqnum) {
		$vto	= hex($ValidTransitions{ $_ .'.'. 0 });
	    } else {
		$vto	= hex($ValidTransitions{ $_ .'.'. ($i + 1) });
	    }
	    $cfrom = $from;
	    $cto = $to;
	    $j=12;
	    do {
		printf(STDERR "comparing bad_transition %08lx -> %08lx to %08lx -> %08lx \n", $cfrom, $cto, $vfrom, $vto) if $DEBUG2;

		next NIBBLE if (($vfrom & $cfrom) == $cfrom && ($vto & $cto) == $cto);

		$cfrom	<<= 1;
		$cto	<<= 1;
	    } while (--$j > 0);
	}

	print STDERR "$_ " if $DEBUG;

	$VotesAgainst{ $_ }++;
	$ret ++;
    }

    print STDERR "]\n" if $DEBUG;

    return $ret;
}





sub print_chord {
    my ($q, $chord) = @_;

    return unless $DEBUG2;

    print STDERR "m ", int($q / (100 / $Quantum)), " b ", 1 + $q % (100 / $Quantum);
    printf(STDERR ", %03lx:\t ", $chord & 0xfff) ;
    print STDERR "root "	if ($chord & 1);
    print STDERR "dim2 "	if ($chord & (1 << 1));
    print STDERR "2maj "	if ($chord & (1 << 2));
    print STDERR "3min "	if ($chord & (1 << 3));
    print STDERR "3maj "	if ($chord & (1 << 4));
    print STDERR "4th "		if ($chord & (1 << 5));
    print STDERR "trit "	if ($chord & (1 << 6));
    print STDERR "5th "		if ($chord & (1 << 7));
    print STDERR "6min "	if ($chord & (1 << 8));
    print STDERR "6maj "	if ($chord & (1 << 9));
    print STDERR "dim7 "	if ($chord & (1 << 10));
    print STDERR "7th "		if ($chord & (1 << 11));
    print STDERR "\tBAD"	if ($chord & 0x10000000);
    print STDERR "\n" ;
}





1;
