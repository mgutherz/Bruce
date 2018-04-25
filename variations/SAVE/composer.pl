#
#
# composer.pl
#
#



#
#
# init_composer
#
# called at startup time
#
#

sub init_composer {
    print STDERR "init_composer\n" if $DEBUG;


    #
    # first set up the special events table:
    #
    @Event_Table = (
	\&create_new_primary,
	\&create_mod_primary,
	\&promote_secondary_theme,
	\&create_mod_secondary,
	\&create_new_secondary,
	\&change_instr_mappings,	\&change_instr_mappings, \&change_instr_mappings,
	\&repeat_section_literal,	\&repeat_section_literal, \&repeat_section_literal, \&repeat_section_literal,
					\&repeat_section_literal,
	\&repeat_section_modified,	\&repeat_section_modified, \&repeat_section_modified, \&repeat_section_modified,
					\&repeat_section_modified,
	\&repeat_recent_literal,	\&repeat_recent_literal, \&repeat_recent_literal, \&repeat_recent_literal,
					\&repeat_recent_literal, \&repeat_recent_literal, \&repeat_recent_literal,
	\&repeat_recent_modified,	\&repeat_recent_modified, \&repeat_recent_modified, \&repeat_recent_modified,
					\&repeat_recent_modified, \&repeat_recent_modified, \&repeat_recent_modified,
	\&harmonize_last_phrase,	\&harmonize_last_phrase, \&harmonize_last_phrase, \&harmonize_last_phrase,
					\&harmonize_last_phrase, \&harmonize_last_phrase, \&harmonize_last_phrase,
					\&harmonize_last_phrase, \&harmonize_last_phrase, \&harmonize_last_phrase,
					\&harmonize_last_phrase, \&harmonize_last_phrase, \&harmonize_last_phrase,
    );

    #
    # now set up the instrument mappings
    # perhaps this should change to have pseudoprobabilities like events?
    #
    @InstrumentChoices = (
	"cello",
	"violin",
	"viola",
	"strings",
	"harp",
	"pizzicato",
	"fender",
	"rock",
	"oboe",
	"clarinet",
	"flute",
	"sax",
	"brass",
	"frenchhorn",
	"trumpet",
	"muted",
	"trombone",
	"bassoon",
	"piano",
	"orchestra",
	"bells",
	"drums",
	"glass",
	"bottles",
	"mallet",
	"choir",
	"voices",
	"malechoir",
	"femalechoir",
	"synth1",
	"synth2",
	"synth3",
	"synth4",
	"synth5",
	"synth6",
    );

    $KeyChange = {
	$Octave =>	60,
	$Key =>		30,
	$Major =>	40,
    };

}





sub promote_secondary_theme {
    print STDERR "promote_secondary_theme\n" if $DEBUG;

    &set_primary_theme(\%Themes, int(rand($Secondary)));
}


sub create_new_primary {
    my (%theme);

    print STDERR "create_new_primary\n" if $DEBUG;

    create_theme(\%theme, 0);
    set_primary_theme(\%theme, 0);
}

sub create_mod_primary {
    my (%theme);

    print STDERR "create_mod_primary\n" if $DEBUG;

    modify_theme(\%Themes, &choose_theme, \%theme, 0);
    set_primary_theme(\%theme, 0);
}


sub create_new_secondary {
    my (%theme);

    print STDERR "create_new_secondary\n" if $DEBUG;

    create_theme(\%theme, 0);
    set_secondary_theme(\%theme, 0);
}

sub create_mod_secondary {
    my (%theme);

    print STDERR "create_mod_secondary\n" if $DEBUG;

    modify_theme(\%Themes, &choose_theme, \%theme, 0);
    set_secondary_theme(\%theme, 0);
}


sub change_instr_mappings {
    my($i, $choice, $badlist, $key, $val);

    print STDERR "change_instr_mappings\n" if $DEBUG;
    while (($key,$val) = each %badlist) {
	$badlist{ $key } = 0;
    }

    for ($i=1; $i<=$NumInstruments; $i++) {
	do {
	    $choice = $InstrumentChoices[ int(rand(@InstrumentChoices)) ];
	} while ($badlist{ $choice });
	$InstrMapping[ $i ] = $choice;
	$badlist{ $choice } = $i;
    }
}


sub repeat_section_literal {
    my($i, $from, $to, $incr);

    print STDERR "repeat_section_literal\n" if $DEBUG;

    $from = int(rand($ID));
    $to = int(rand($ID));
    $incr = ($from < $to) ? 1 : -1 ;

    for ($i=$from; $i != $to; $i+=$incr) {
	&copy_theme(\%Phrases, $i, \%Phrases, $ID, @AllTypes);
	$ID++;

	print STDERR "PHRASE $ID\n" if $DEBUG;
    }
}



sub repeat_section_modified {
    my($i, $from, $to, $incr);

    print STDERR "repeat_section_modified\n" if $DEBUG;

    $from = int(rand($ID));
    $to = int(rand($ID));
    $incr = ($from < $to) ? 1 : -1 ;

    for ($i=$from; $i != $to; $i+=$incr) {
	&modify_theme(\%Phrases, $i, \%Phrases, $ID);
	$ID++;

	print STDERR "PHRASE $ID\n" if $DEBUG;
    }
}



sub repeat_recent_literal {
    my($i, $from);

    print STDERR "repeat_recent_literal\n" if $DEBUG;

    if ($ID > 40) {
	$from = int(rand(log($ID+1) / log(2))) + 2;
    } else {
	$from = int(rand($ID));
    }

    for ($i=0; $i < $from; $i++) {
	print STDERR "PHRASE ", $ID + $i, "\n" if $DEBUG;

	&copy_theme(\%Phrases, $ID - $from + $i, \%Phrases, $ID + $i, @AllTypes);
    }
    $ID += $from;

    print STDERR "PHRASE $ID\n" if $DEBUG;
}


sub repeat_recent_modified {
    my($i, $from);

    print STDERR "repeat_recent_modified\n" if $DEBUG;

    if ($ID > 40) {
	$from = int(rand(log($ID+1) / log(2))) + 2;
    } else {
	$from = int(rand($ID));
    }

    for ($i=0; $i < $from; $i++) {
	print STDERR "PHRASE ", $ID + $i, "\n" if $DEBUG;

	&modify_theme(\%Phrases, $ID - $from + $i, \%Phrases, $ID + $i);
    }
    $ID += $from;

    print STDERR "PHRASE $ID\n" if $DEBUG;
}


sub harmonize_last_phrase {
    print STDERR "harmonize_last_phrase\n" if $DEBUG;

    &copy_theme(\%Phrases, $ID - 1, \%Phrases, $ID, @AllTypes);
    &modify_pitches(\%Phrases, $ID);
    $Phrases{ $ID . $Measures } = 0;
    $Phrases{ $ID . $Channel } = ($Phrases{ $ID . $Channel } % $NumInstruments) + 1;
    $ID++;
}



#
#
# do_special_event
#
# chooses among several options for things to do, like change keys, change instrument
# mappings, repeat sections, repeat the last phrase, repeat sections with modifications
#
# Note: right now, all of the possible special events are equally likely
#

sub do_special_event {
    print STDERR "do_special_event\n" if $DEBUG;

    &{ $Event_Table[ int(rand(@Event_Table)) ] } ;
}






#
#
# compose_phrase
#
# makes a phrase and sticks it into the Phrase array.
#
#

sub compose_phrase {
    my ($len, $i);

    print STDERR "compose_phrase\n" if $DEBUG;

    $i = &random_channel;
    $Phrases{ $ID.$Channel }	= $i;
    $Phrases{ $ID.$Instrument }	= $InstrMapping[ $i ];
    $Phrases{ $ID.$Measures }	= &random_measures;
    for (@KeyTypes) {
	if (&random($KeyChange->{ $_ })) {
	    $Phrases{ $ID.$_ } =	&{ $vary->{ $_ } } (\%Phrases, $ID);
	} else {
	    $Phrases{ $ID.$_ } =	$Phrases{ ($ID - 1).$_ };
	}
    }

    $len = &random_phraselen;
    $i = &choose_theme;

    for (@NoteTypes) {
	$Phrases{ $ID.$_ } =	&{ $vary->{ $_ } } (\%Themes, $i, $len);
    }

    $ID++;

    print STDERR "PHRASE $ID\n" if $DEBUG;
}



sub create_score {
    print STDERR "create_score\n" if $DEBUG;

    print STDERR "PHRASE $ID\n" if $DEBUG;
    while ($ID <= $MaxPhrases) {
	if ($ID && &random($SpecialEvent)) {
	    &do_special_event;
	} else {
	    &compose_phrase;
	}
    }

}







sub modify_score {
    my ($i, $id);

    print STDERR "modify_score\n" if $DEBUG;

    &create_new_primary;

    for ($i=0; $i<$BadSections; $i++) {
	$id = $BadList{ $i . $Badstr };

	#
	# id is now the highest ID that was involved in the BAD section.
	# as long as the Measures value is zero, it makes sense to modify
	# each Phrase and the one before it.
	#

#	do {
#	    next if $Phrases{ $id.$Modified };
#	    print STDERR "MODIFY_SCORE $i:$id\n" if $DEBUG2;

	    for ( $Pitches, $Rhythms, $Measures ) {
		if (&random($ModificationProb)) {
		    if (&random($ModifyOverOthers)) {
			&{ $modify->{ $_ } } (\%Phrases, $id);
		    } elsif (&random($RandomOverVary)) {
			$Phrases{ $id.$_ } =	&{ $randomly->{ $_ } } (\%Phrases, $id, $Phrases{ $id.$_ }->[0]);
		    } else {
			$Phrases{ $id.$_ } =	&{ $vary->{ $_ } } (\%Phrases, $id, $Phrases{ $id.$_ }->[0]);
		    }
		}
	    }
#	    $Phrases{ $id.$Modified } = 1;
#	} while ($Phrases{ $id . $Measures } == 0 && $id-- > 0);
    }

    $Phrases{ $ID_start . $Measures } = 0;
}






1;
