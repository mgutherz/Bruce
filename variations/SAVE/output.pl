#
#
# output.pl
#
#

sub init_output {
    print STDERR "init_output\n" if $DEBUG;

    $PitchMnemonic =		'pitch';
    $ArticulationMnemonic =	'artic';
    $RhythmMnemonic =		'rhyth';
    $VelocityMnemonic =		'veloc';
    $KeyMnemonic =		'key';
    $MeasureMnemonic =		'measures';
    $InstrumentMnemonic =	'progr';
    $SpeedMnemonic =		'speed';
    $TimesigMnemonic =		'timesig';
}




sub output_score {
    my $i;

    $LINE = 1;
    &score_init;

    for ($i=0; $i<$OutputScore_ID; $i++) {

	print "PHRASE $i\n" if $DEBUG;

	&output_key($i);
	&output_measures($i);
	&output_instrument($i);
	&output_pitches($i);
	&output_articulations($i);
	&output_rhythms($i);
	&output_velocities($i);
    }

    &score_wrapup;
}



sub commentline {
    print "0, " ;
}

sub dataline {
    print "$LINE, " ;
    $LINE++;
}

sub score_init {
    &commentline; print	"comment Lowest BadPercentage = ", $BestSoFar * 100, " ; \n" ;
    &commentline; print	"comment Iteration Type = $IterationType ; \n";
    &dataline; print	"clear clear ; \n" ;
    &dataline; print	"$SpeedMnemonic 100 ; \n" ;
    &dataline; print	"$TimesigMnemonic 4 ; \n" ;
}


sub score_wrapup {
    &dataline; print	"finis 10;\n" ;
    &dataline; print	"start 0; \n" ;
    &dataline; print	"start 1; \n" ;
}


sub output_speed {
    my ($id) = @_;

    if ($OutputScore{ $id.$Speed }) {
	&dataline; print	$SpeedMnemonic,
				" ", $OutputScore{ $id.$Speed },
				" ; \n";
    }
}



sub output_timesig {
    my ($id) = @_;

    if ($OutputScore{ $id.$Timesig }) {
	&dataline; print	$TimesigMnemonic,
				" ", $OutputScore{ $id.$Timesig },
				" ; \n";
    }
}



sub output_key {
    my ($id) = @_;

    if ($OutputScore{ $id.$Key }) {
	&dataline; print	$KeyMnemonic,
				" ", $OutputScore{ $id.$Octave },
				" ", $OutputScore{ $id.$Key },
				" ", $OutputScore{ $id.$Major },
				" ; \n";
    }
}



sub output_measures {
    my ($id) = @_;

    &dataline; print	$MeasureMnemonic,
			" ", $OutputScore{ $id.$Measures },
			" ; \n";
}



sub output_instrument {
    my ($id) = @_;

    return unless $OutputScore{ $id.$Instrument };

    &dataline; print	$OutputScore{ $id.$Channel },
			": ", $InstrumentMnemonic,
			" ", $OutputScore{ $id.$Instrument },
			" ; \n";
}



sub output_array {
    my ($id, $type, $mnemonic) = @_;
    my ($i, $array);

    $array = $OutputScore{ $id.$type };
    &dataline; print	"$OutputScore{ $id.$Channel }:",
			" ", $mnemonic,
			" ", $array->[0] ;

    for ($i=1; $i<=$array->[0]; $i++) {
	print	" ", $array->[ $i ];
    }
    print " ; \n";
}



sub output_pitches {
    my ($id) = @_;

    &output_array($id, $Pitches, $PitchMnemonic);
}



sub output_articulations {
    my ($id) = @_;

    &output_array($id, $Articulations, $ArticulationMnemonic);
}



sub output_rhythms {
    my ($id) = @_;

    &output_array($id, $Rhythms, $RhythmMnemonic);
}



sub output_velocities {
    my ($id) = @_;

    &output_array($id, $Velocities, $VelocityMnemonic);
}




#
# makes a copy of whatever is in the current score
# so that when it is time to output our best, we can
#
sub save_this_score {
    my ($its) = @_;
    my $id;

    $IterationType = $its;

    $OutputScore_ID = $ID;
    for ($id=0; $id<$OutputScore_ID; $id++) {
	for (@NoteTypes) {
	    $OutputScore{ $id . $_ } = $Phrases{ $id . $_ };
	}
	for (@NotNoteTypes) {
	    if ($Phrases{ $id . $_ } ne "") {
		$OutputScore{ $id . $_ } = $Phrases{ $id . $_ }
	    } elsif ($_ eq $Key || $_ eq $Major) {
		$OutputScore{ $id . $_ } = $Phrases{ ($id - 1) . $_ }
	    } else {
		print STDERR "save_this_score: id $id, value of $_ not set\n" if $DEBUG;
		$OutputScore{ $id . $_ } = &{ $randomly->{ $_ } }(\%Phrases, $id);
	    }
	}
    }
    $OutputScore{ 0 . $Measures } = 0;
}



1;
