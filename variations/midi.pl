#
#
# midi.pl
#
# this takes the files output by VARIATIONS and converts
# them into MIDI files
#
#

$halfsteps = {
    "maj" . 0 => 0,
    "maj" . 1 => 0,
    "maj" . 2 => 2,
    "maj" . 3 => 4,
    "maj" . 4 => 5,
    "maj" . 5 => 7,
    "maj" . 6 => 9,
    "maj" . 7 => 11,
    "maj" . 8 => 12,
    "maj" . 9 => 14,
    "maj" . 10 => 16,
    "maj" . 11 => 17,
    "maj" . 12 => 19,
    "maj" . 13 => 21,
    "maj" . 14 => 23,
    "maj" . 15 => 24,
    "maj" . 16 => 26,
    "maj" . 17 => 28,
    "maj" . 18 => 29,
    "maj" . 19 => 31,
    "maj" . 20 => 33,
    "maj" . 21 => 35,
    "maj" . 22 => 36,

    "min" . 0 => 0,
    "min" . 1 => 0,
    "min" . 2 => 2,
    "min" . 3 => 3,
    "min" . 4 => 5,
    "min" . 5 => 7,
    "min" . 6 => 8,
    "min" . 7 => 10,
    "min" . 8 => 12,
    "min" . 9 => 14,
    "min" . 10 => 15,
    "min" . 11 => 17,
    "min" . 12 => 19,
    "min" . 13 => 20,
    "min" . 14 => 22,
    "min" . 15 => 24,
    "min" . 16 => 26,
    "min" . 17 => 27,
    "min" . 18 => 29,
    "min" . 19 => 31,
    "min" . 20 => 32,
    "min" . 21 => 34,
    "min" . 22 => 36,
};

$offsets = {
    'C' => 0,	'C#' => 1,	'Db' => 1,
    'D' => 2,	'D#' => 3,	'Eb' => 3,
    'E' => 4,	'E#' => 5,	'Fb' => 4,
    'F' => 5,	'F#' => 6,	'Gb' => 6,
    'G' => 7,	'G#' => 8,	'Ab' => 8,
    'A' => 9,	'A#' => 10,	'Bb' => 10,
    'B' => 11,	'B#' => 12,	'Cb' => 11,
};

$START = 0;

for (1..32) {
    $lookup{ $_ . ':' } = $_;
}

while (<>) {
    chop;
    my ($a0, $a1, $a2, $a3, @notelist) = split;
    next if $a1 eq "comment";
    next if $a1 eq "clear";
    next if $a1 eq "finis";
    next if $a1 eq "start";
    next if $a1 eq "timesig";
    next if $a1 eq "speed";

    if ($a1 eq "key") {
	$OFFSET = ($a2 * 12) + $offsets->{ $a3 };
	$KEY = $notelist[0];
    } elsif ($a1 eq "measures") {
	$START += ($a2 * 1000);
    } elsif ($lookup{ $a1 }) {
	$CHANNEL = $lookup{ $a1 };
	for ($i=0; $i<$a3; $i++) {
	    $EVENT{ $i .'.'. $a2 } = $notelist[ $i ];
	}
	if ($a2 eq "veloc") {
	    &do_event($a3);
	}
    } else {
	print STDERR "problem: cannot parse this: $_ \n";
    }
}

#
# we count on the fact that the velocity values are
# sent out last.  this signals the end of the phrase,
# time to spit the thing out.
#
sub do_event {
    my ($len) = @_;
    my ($i, $offset, $note, $rhyth, $artic, $pitch, $veloc);

    $offset = 0;

    for ($i=0; $i<$len; $i++) {
	$pitch = $EVENT{ $i .'.'. "pitch" };
	$rhyth = $EVENT{ $i .'.'. "rhyth" };
	$artic = $EVENT{ $i .'.'. "artic" };
	$veloc = $EVENT{ $i .'.'. "veloc" };

	$timeon = sprintf("%08ld", $START + 10 * $offset);
	$timeoff = sprintf("%08ld", $START + 10 * ($offset + ($rhyth * $artic / 100)));
	$offset = $rhyth;

	if ($pitch eq "rest") {
	    $note = $pitch;
	} else {
	    $note = $OFFSET;
	    until ($halfsteps->{ $KEY . $pitch } ne "") {
		$note += 36;
		$pitch -= 21;
	    }
	    $note += $halfsteps->{ $KEY . $pitch };
	}

	print "$timeon 9",  $CHANNEL-1, " $note $veloc \n";
	print "$timeoff 8", $CHANNEL-1, " $note $veloc \n";
    }
}
