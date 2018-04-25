#
#
#
# themes.pl
#
# submodule that implements the handling of themes, such as extracting
# portions and modifying them, etc.
#



#
#
# init_themes
#
# called at program start-up
#
#
sub init_themes {

    print STDERR "init_themes\n" if $DEBUG;

    $ID = $ID_start;
    $Secondary = 0;

    $Phrases{ $ID . $Speed } =	$DefaultSpeed;
    $Phrases{ $ID . $Timesig } = $DefaultTimesig;

    $Phrases{ $ID . $Key } =	$DefaultKey;
    $Phrases{ $ID . $Octave } =	$DefaultOctave;
    $Phrases{ $ID . $Major } =	$DefaultMajor;
    $Phrases{ ($ID-1) . $Key } =	$DefaultKey;
    $Phrases{ ($ID-1) . $Octave } =	$DefaultOctave;
    $Phrases{ ($ID-1) . $Major } =	$DefaultMajor;
    $Phrases{ $ID . $Measures } =	0;

    $vary = { 
	$Pitches	=> \&vary_pitches,
	$Articulations	=> \&vary_articulations,
	$Rhythms	=> \&vary_rhythms,
	$Velocities	=> \&vary_velocities,

	$Key		=> \&vary_key,
	$Octave		=> \&vary_octave,
	$Major		=> \&vary_major,
	$Channel	=> \&random_channel,
	$Instrument	=> \&map_instrument,
	$Measures	=> \&random_measures,
    };

    $modify = { 
	$Pitches	=> \&modify_pitches,
	$Rhythms	=> \&modify_rhythms,
	$Measures	=> \&random_measures,

	$Articulations	=> \&modify_nothing,
	$Velocities	=> \&modify_nothing,
	$Key		=> \&modify_nothing,
	$Octave		=> \&modify_nothing,
	$Major		=> \&modify_nothing,
	$Channel	=> \&modify_nothing,
	$Instrument	=> \&modify_nothing,
    };

    $randomly = { 
	$Pitches	=> \&random_pitches,
	$Articulations	=> \&random_articulations,
	$Rhythms	=> \&random_rhythms,
	$Velocities	=> \&random_velocities,

	$Key		=> \&random_key,
	$Octave		=> \&random_octave,
	$Major		=> \&random_major,
	$Channel	=> \&random_channel,
	$Instrument	=> \&map_instrument,
	$Measures	=> \&random_measures,
    };

    @Keys = (
	"A", "A#", "Ab", 
	"A", "A", "A",
	"B", "B#", "Bb", 
	"B", "B", "B",
	"C", "C#", "Cb", 
	"C", "C", "C",
	"D", "D#", "Db", 
	"D", "D", "D",
	"E", "E#", "Eb", 
	"E", "E", "E",
	"F", "F#", "Fb", 
	"F", "F", "F",
	"G", "G#", "Gb", 
	"G", "G", "G",
    );

    @rhythmlist = (
	0.25,
	0.5, 0.5,
	0.666666666,
	1.0, 1.0, 1.0, 1.0,
	1.5, 1.5,
	2.0, 2.0, 2.0, 2.0,
	3.0, 3.0,
	4.0,
    );

    @octavelist = (
	1,
	2, 2, 2, 2,
	3, 3, 3, 3, 3, 3, 3, 3, 3,
	4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
	5, 5, 5, 5, 5, 5, 5, 5, 5,
	6, 6, 6,
	7,
    );

    @MaxMeasures = (
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1,
	2, 2, 2, 2,
	3, 3,
	4,
    );

    @Phraselengths = (
	2,
	3, 3, 3,
	4, 4, 4, 4,
	5, 5, 5, 5, 5, 5,
	6, 6, 6, 6, 6, 6, 6,
	7, 7, 7, 7, 7, 7,
	8, 8, 8, 8,
    );

}


#
#
# variations
#
# for the initial cut, they're fairly random
#
#

sub vary_pitches {
    my ($themep, $idx, $len) = @_;
    my ($i, $j, $a, $b, $t);

    print STDERR "vary_pitches \n" if $DEBUG;

    $a = $themep->{ $idx . $Pitches };
    if (!$a) {
	print "vary_pitches: idx $idx; We have problems.\n" ;
    }
    &print_array($a, $len, 'vary_pitches');

    $b[0] = $len;
    $t = - 7 + int(rand(15));
    for ($i=1, $j=rand($a->[0]); $i<=$len; $i++, $j++) {
	if ($a->[($j % $a->[0])+1] eq $rest) {
	    $b[$i] = $rest;
	} else {
	    $b[$i] = $a->[($j % $a->[0])+1] + $t;
	    if ($b[$i] < 0) {
		$b[$i] = $PitchModulo + ($b[$i] % $PitchModulo);
	    } else {
		$b[$i] = $b[$i] % $PitchModulo;
	    }
	}
    }

    return [ eval join(',', @b[0 .. $#b]) ];
}



sub vary_articulations {
    my ($themep, $idx, $len) = @_;
    my ($i, $j, $a, $b, $t);

    print STDERR "vary_articulations \n" if $DEBUG;

    $a = $themep->{ $idx . $Articulations };
    if (!$a) {
	print "vary_articulations: idx $idx; We have problems.\n" ;
    }
    &print_array($a, $len, 'vary_artic');

    $b[0] = $len;
    $t = 0.5 + rand(1);
    for ($i=1, $j=rand($a->[0]); $i<=$len; $i++, $j++) {
	$b[$i] = int($a->[($j % $a->[0])+1] * $t);
    }

    return [ eval join(',', @b[0 .. $#b]) ];
}



sub vary_rhythms {
    my ($themep, $idx, $len) = @_;
    my ($i, $j, $a, $b, $t);

    print STDERR "vary_rhythms \n" if $DEBUG;

    $a = $themep->{ $idx . $Rhythms };
    if (!$a) {
	print "vary_rhythms: idx $idx; We have problems.\n" ;
    }
    &print_array($a, $len, 'vary_rhythms');

    $b[0] = $len;
    $t = $rhythmlist[int(rand(@rhythmlist))];
    print "HOW DID THIS HAPPEN?\n" unless $t;
    for ($i=1, $j=rand($a->[0]); $i<=$len; $i++, $j++) {
	$b[$i] = $a->[($j % $a->[0])+1] * $t;
    }

    return [ eval join(',', @b[0 .. $#b]) ];
}



sub vary_velocities {
    my ($themep, $idx, $len) = @_;
    my ($i, $j, $a, $b, $t);

    print STDERR "vary_velocities \n" if $DEBUG;

    $a = $themep->{ $idx . $Velocities };
    if (!$a) {
	print "vary_velocities: idx $idx; We have problems.\n" ;
    }
    &print_array($a, $len, 'vary_velocities');

    $b[0] = $len;
    $t = 0.5 + rand(1);
    for ($i=1, $j=rand($a->[0]); $i<=$len; $i++, $j++) {
	$b[$i] = int($a->[($j % $a->[0])+1] * $t) % 128;
    }

    return [ eval join(',', @b[0 .. $#b]) ];
}



sub vary_key {
    my ($themep, $id) = @_;

    print STDERR "vary_key \n" if $DEBUG;

    return $Keys[int(rand(@Keys))];
}

sub vary_octave {
    my ($themep, $id) = @_;

    print STDERR "vary_octave \n" if $DEBUG;

    return int(rand(10));
}

sub vary_major {
    my ($themep, $id) = @_;

    print STDERR "vary_major \n" if $DEBUG;

    if (&random(50)) {
	return "maj";
    } else {
	return "min";
    }
}







sub print_array {
    my ($x, $len, $from) = @_;
    my $i;

    return unless $DEBUG;

    print STDERR "print_array from $from: " ;
    return unless $x;

    print STDERR "take $len from ", $x->[0], "," ;
    for ($i=1; $i<=$x->[0]; $i++) {
	print STDERR " ", $x->[$i] ;
    }
    print STDERR "\n";
}



#
#
# choose_theme
#
# we figure that we'll usually choose the primary theme, but
# occasionally we'll take from one of the secondary themes, and
# all of them are equally likely
#
#

sub choose_theme {
    if (&random($ChoosePrimary)) {
	return $Primary;
    } else {
	# still possible to get the primary, but what the hell
	return int(rand($Secondary));
    }
}





#
#
# set_theme
#
# called to add to the list of themes -- we can either set the
# primary theme or add to the list of secondary themes.  when
# the one to add is not the primary theme, increment $Secondary.
# (this is not generally called directly, but by set_primary and
# set_secondary)
#
#
sub set_theme {
    my ($which, $themep) = @_;
    my $i;

    if ($DEBUG) {
	print STDERR "set_theme:\n" ;
	for (@NoteTypes) {
	    print STDERR "    $_ : " ;
	    $array = $themep->{$_};
	    for ($i=1; $i<=$array->[0]; $i++) {
		print STDERR "$array->[$i] " ;
	    }
	    print STDERR "\n";
	}
    }

    for (@NoteTypes) {
	$Themes{ $which.$_ } = $themep->{$_};
    }
    for (@NotNoteTypes) {
	$Themes{ $which.$_ } = &{ $randomly->{ $_ }}( $themep, 0 );
    }
}


#
#
# set_primary_theme
# 
#
sub set_primary_theme {
    my ($themep, $idx) = @_;

    if ($themep == \%Themes) {
	$Primary = $idx;
    } else {
	$Primary = $Secondary;
	&set_secondary_theme($themep, $idx);
    }
    return;

    if ($Themes{$Primary.$Pitches}) {
	&set_secondary_theme(\%Themes, $Primary);
    }
    &copy_theme($themep, $idx, \%Themes, $Primary, @AllTypes);
}


#
#
# set_secondary_theme
#
# This is the ONLY place where we should be incrementing $Secondary
#
#
sub set_secondary_theme {
    my ($themep, $idx) = @_;

    &copy_theme($themep, $idx, \%Themes, $Secondary, @AllTypes);
    $Secondary++;
}


#
#
# copy_theme
#
# generic copy routine to copy all attributes from one place to another
# syntax:
#	from is a pointer to an associative array
#	f_idx is the index into the FROM array
#	to is a pointer to an associative array
#	t_idx is the index into the TO array
#	@attrs is the list of which attributes to copy
#
#
sub copy_theme {
    my ($fromp, $f_idx, $top, $t_idx, @attrs) = @_;
    my ($i, $type);

    for (@attrs) {

	if ($DEBUG) {
	    $array = $fromp->{$f_idx . $_};
	    if ($array) {
		print STDERR "copy_theme $_ : " ;
		for ($i=1; $i<=$array->[0]; $i++) {
		    print STDERR "$array->[$i] " ;
		}
		print STDERR "\n";
	    }
	}

	if ($fromp->{ $f_idx . $_ }) {
	    $top->{ $t_idx . $_ } = $fromp->{ $f_idx . $_ };
	} elsif ($_ eq $Measures) {
	    $top->{ $t_idx . $_ } = &random_measures;
	}

    }
}




sub create_theme {
    my ($top, $t_idx) = @_;
    my ($i, $len) = (&choose_theme, &random_phraselen);

    print STDERR "create_theme \n" if $DEBUG;

    for (@NoteTypes) {
	$top->{ $t_idx.$_ } =	&{ $randomly->{ $_ } } (\%Themes, $i, $len);
    }

    for (@KeyTypes) {
	$top->{ $t_idx.$_ } =	&{ $vary->{ $_ } } ($top, $t_idx);
    }

    $top->{ $t_idx.$Channel } =		&random_channel;
    $top->{ $t_idx.$Instrument } =	$InstrMapping[ $top->{ $t_idx.$Channel } ];
    $top->{ $t_idx.$Measures } =	int(rand(8));
}



sub modify_theme {
    my ($fromp, $f_idx, $top, $t_idx) = @_;

    if ($DEBUG) {
	print STDERR "modify_theme: " ;
	($fromp == \%Phrases) ? print STDERR "Phrases " : print STDERR "Themes " ;
	print STDERR "index $f_idx, to ";
	($top == \%Phrases) ? print STDERR "Phrases " : print STDERR "Themes " ;
	print STDERR "index $t_idx \n";

	&print_array($fromp->{ $f_idx.$Pitches }, 0, "modify_theme");
    }

    for (@NoteTypes) {
	$top->{ $t_idx.$_ } =	&{ $vary->{ $_ } } ($fromp, $f_idx, $fromp->{ $f_idx.$_ }->[0]);
    }

    for (@NotNoteTypes) {
	if ($fromp->{ $f_idx.$_ }) {
	    $top->{ $t_idx.$_ } =	$fromp->{ $f_idx.$_ };
	} else {
	    $top->{ $t_idx.$_ } =	&{ $randomly->{ $_ } }($top, $t_idx);
	}
    }
}




#
#
# modifications
#
# used in modify_score, when the ear has rejected the score and we go back to fix it.
# the difference here is that we directly change the array, and return nothing.
# modifications can be anything
#
#

@PitchModifications = (
    \&multiply_pitches,
    \&transpose_pitches,
    \&transpose_pitches,
);

sub modify_pitches {
    my ($themep, $idx) = @_;

    print STDERR "modify_pitches \n" if $DEBUG;

    &{ $PitchModifications[ int(rand(@PitchModifications)) ] }($themep, $idx);
}

sub transpose_pitches {
    my ($themep, $idx) = @_;
    my ($i, $a, $t);

    print STDERR "transpose_pitches \n" if $DEBUG;

    $a = $themep->{ $idx . $Pitches };
    &print_array($a, $a->[0], 'transpose_pitches');

    $t = - 7 + int(rand(15));
    for ($i=1; $i<=$a->[0]; $i++) {
	next if $a->[$i] eq $rest;
	
	$a->[$i] += $t;

	if ($a->[$i] < 0) {
	    $a->[$i] = $PitchModulo + ($a->[$i] % $PitchModulo);
	} else {
	    $a->[$i] = $a->[$i] % $PitchModulo;
	}
    }
}

sub multiply_pitches {
    my ($themep, $idx) = @_;
    my ($i, $a, $t);

    print STDERR "multiply_pitches \n" if $DEBUG;

    $a = $themep->{ $idx . $Pitches };
    &print_array($a, $a->[0], 'multiply_pitches');

    $t = rand(2) + 0.5;
    for ($i=1; $i<=$a->[0]; $i++) {
	next if $a->[$i] eq $rest;
	
	$a->[$i] = int($a->[$i] * $t);

	if ($a->[$i] < 0) {
	    $a->[$i] = $PitchModulo + ($a->[$i] % $PitchModulo);
	} else {
	    $a->[$i] = $a->[$i] % $PitchModulo;
	}
    }
}

sub modify_rhythms {
    my ($themep, $idx) = @_;
    my ($i, $a, $t);

    print STDERR "modify_rhythms \n" if $DEBUG;

    $a = $themep->{ $idx . $Rhythms };
    &print_array($a, $a->[0], 'modify_rhythms');

    $t =  $rhythmlist[int(rand(@rhythmlist))];
    for ($i=1; $i<=$a->[0]; $i++) {
	$a->[$i] = $a->[$i] * $t;
    }
}

sub modify_measures {
    my ($themep, $idx) = @_;

    print STDERR "modify_measures \n" if $DEBUG;

    $themep->{ $idx . $Measures } = &random_measures($themep, $idx);
}

sub modify_nothing {
    print STDERR "modify_nothing \n" if $DEBUG;
}



#
#
# randomness
#
# for now, they're close to the VARY functions, but soon
# the VARY functions will become less random (initial easy cut)
#
#

sub random_phraselen {
    return $Phraselengths[ int(rand(@Phraselengths)) ];
}


sub random_pitches {
    my ($themep, $idx, $len) = @_;
    my ($i, $a, $b);

    print STDERR "random_pitches \n" if $DEBUG;

    $a = $themep->{ $idx . $Pitches };
    if (!$a) {
	print "random_pitches: idx $idx; We have problems.\n" ;
    }
    &print_array($a, $len, 'random_pitches');
    for ($i=1; $i<=$len; $i++) {
	$b[$i] = $a->[int(rand($a->[0])) + 1] - 7 + int(rand(15));
	if ($b[$i] < 0) {
	    $b[$i] = $PitchModulo + ($b[$i] % $PitchModulo);
	} else {
	    $b[$i] = $b[$i] % $PitchModulo;
	}
    }
    $b[0] = $len;

    return [ eval join(',', @b[0 .. $#b]) ];
}



sub random_articulations {
    my ($themep, $idx, $len) = @_;
    my ($i, $a, $b);

    print STDERR "random_articulations \n" if $DEBUG;

    $a = $themep->{ $idx . $Articulations };
    if (!$a) {
	print "random_articulations: idx $idx; We have problems.\n" ;
    }
    &print_array($a, $len, 'random_artic');
    for ($i=1; $i<=$len; $i++) {
	$b[$i] = int($a->[int(rand($a->[0])) + 1] * (0.5 + rand(1)));
    }
    $b[0] = $len;

    return [ eval join(',', @b[0 .. $#b]) ];
}



sub random_rhythms {
    my ($themep, $idx, $len) = @_;
    my ($i, $a, $b);

    print STDERR "random_rhythms \n" if $DEBUG;

    $a = $themep->{ $idx . $Rhythms };
    if (!$a) {
	print "random_rhythms: idx $idx; We have problems.\n" ;
    }
    &print_array($a, $len, 'random_rhythms');
    for ($i=1; $i<=$len; $i++) {
	$b[$i] = $a->[int(rand($a->[0])) + 1] * $rhythmlist[int(rand(@rhythmlist))];
    }
    $b[0] = $len;

    return [ eval join(',', @b[0 .. $#b]) ];
}



sub random_velocities {
    my ($themep, $idx, $len) = @_;
    my ($i, $a, $b);

    print STDERR "random_velocities \n" if $DEBUG ;

    $a = $themep->{ $idx . $Velocities };
    if (!$a) {
	print "random_velocities: idx $idx; We have problems.\n" ;
    }
    &print_array($a, $len, 'random_velocities');
    for ($i=1; $i<=$len; $i++) {
	$b[$i] = int($a->[int(rand($a->[0])) + 1] * (0.5 + rand(1))) % 128;
    }
    $b[0] = $len;

    return [ eval join(',', @b[0 .. $#b]) ];
}



sub random_key {
    my ($themep, $id) = @_;

    print STDERR "random_key \n" if $DEBUG;

    return $Keys[int(rand(@Keys))];
}

sub random_octave {
    my ($themep, $id) = @_;

    print STDERR "random_octave \n" if $DEBUG;

    return $octavelist[int(rand(@octavelist))];
}

sub random_major {
    my ($themep, $id) = @_;

    print STDERR "random_major \n" if $DEBUG;

    if (&random(50)) {
	return "maj";
    } else {
	return "min";
    }
}



sub random_channel {
    my ($themep, $id) = @_;

    print STDERR "random_channel \n" if $DEBUG;

    return int(rand($NumInstruments)) + 1;
}

sub map_instrument {
    my ($themep, $id) = @_;

    print STDERR "map_instrument \n" if $DEBUG;

    return $InstrMapping[ $themep->{$id.$Channel} ];
}

sub random_measures {
    my ($themep, $id) = @_;
    my ($i,$j) = (0,0);

    print STDERR "random_measures \n" if $DEBUG;

    return $MaxMeasures[ int(rand(@MaxMeasures)) ];
}





1;
