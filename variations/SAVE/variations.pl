#!/usr/users/blj/bin/perl5
#
#
#
# variations.pl
#
# Creates music by a vaguely random process, corrected by
# a genetic algorithmic EAR, which determines what transitions
# are pleasing.
#


require "composer.pl";
require "ear.pl";
require "output.pl";
require "themes.pl";
require "utils.pl";




$DEBUG =	0;
$DEBUG2 =	0;



#
# Global Variables
# (used by all of the submodules)
# (some appear first in initialization)
#

$MaxIts =		10;
$MaxPhraselen =		8;
$NumInstruments =	8;
$ID_start =		0;
$PitchModulo =		16;


$DefaultOctave =	4;
$DefaultKey =		'C';
$DefaultMajor =		'maj';
$DefaultSpeed =		100;
$DefaultTimesig =	4;

$Pitches =		'_Pitch';
$Articulations =	'_Articulation';
$Rhythms =		'_Rhythm';
$Velocities =		'_Velocity';
$Octave =		'_Octave';
$Key =			'_Key';
$Major = 		'_Major';
$Measures =		'_Measures';
$Instrument =		'_Instrument';
$Channel =		'_Channel';
$Speed =		'_Speed';
$Timesig =		'_Timesignature';
$Modified =		'_Modified';

$Primary =		0;
$rest =			'rest';

@AllTypes =	($Pitches, $Articulations, $Rhythms, $Velocities, $Octave, $Key, $Major, $Measures, $Channel);
@NoteTypes =	($Pitches, $Articulations, $Rhythms, $Velocities);
@NotNoteTypes =	($Octave, $Key, $Major, $Measures, $Channel);
@KeyTypes =	($Octave, $Key, $Major);



#
#
# GA Stuff
#
#
$EarGene =		"Ear.Gene";




#
# probabilities & Pseudoprobabilities
#

$SpecialEvent =			45;
$ChoosePrimary =		30;
$ModificationProb =		30;
$ModifyOverOthers =		50;
$RandomOverVary =		30;


@NumPhrasesList = (
    3, 3, 3,
    4, 4, 4, 4, 4,
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
    6, 6, 6, 6, 6, 6, 6, 6,
    7, 7, 7, 7, 7,
    8, 8, 8,
    9, 9,
    10,
);




sub init_variations {
    print STDERR "init_variations \n" if $DEBUG;

    #srand(time | $$);
    srand(17);
}



#
#
# INITIALIZATION STEP
#
#

&init_composer;
&init_ear;
&init_output;
&init_themes;
&init_variations;




#
# user-defined themes
#


$u_theme{ 0 .$Pitches } =	[ 6, 5, 1, 9, 5, 1, $rest ];
$u_theme{ 0 .$Articulations } =	[ 6, 40, 40, 99, 30, 60, 100 ];
$u_theme{ 0 .$Rhythms } =	[ 6, 25, 25, 75, 25, 25, 125 ];
$u_theme{ 0 .$Velocities } =	[ 6, 100, 90, 110, 80, 90, 80 ];

$u_theme{ 1 .$Pitches } =	[ 6, 7, 8, 5, 3, 4, $rest ];
$u_theme{ 1 .$Articulations } =	[ 6, 120, 120, 200, 60, 150, 100 ];
$u_theme{ 1 .$Rhythms } =	[ 6, 25, 25, 75, 25, 25, 125 ];
$u_theme{ 1 .$Velocities } =	[ 6, 100, 90, 110, 80, 90, 80 ];

$u_theme{ 2 .$Pitches } =	[ 5, 4, 5, 5, 3, 4 ];
$u_theme{ 2 .$Articulations } =	[ 5, 99, 70, 70, 90, 50 ];
$u_theme{ 2 .$Rhythms } =	[ 5, 12.5, 25, 25, 12.5, 25 ];
$u_theme{ 2 .$Velocities } =	[ 5, 100, 100, 100, 80, 90 ];

$u_theme{ 3 .$Pitches } =	[ 5, 4, 5, 2, 4, 3 ];
$u_theme{ 3 .$Articulations } =	[ 5, 60, 70, 80, 90, 100 ];
$u_theme{ 3 .$Rhythms } =	[ 5, 12.5, 12.5, 12.5, 12.5, 50 ];
$u_theme{ 3 .$Velocities } =	[ 5, 90, 90, 90, 100, 100 ];

$u_theme{ 4 .$Pitches } =	[ 3, 5, 1, 9 ];
$u_theme{ 4 .$Articulations } =	[ 3, 80, 80, 150 ];
$u_theme{ 4 .$Rhythms } =	[ 3, 25, 25, 50 ];
$u_theme{ 4 .$Velocities } =	[ 3, 95, 80, 110 ];

$u_theme{ 5 .$Pitches } =	[ 8, $rest, 3, 4, 5, 4, 3, 2, 1 ];
$u_theme{ 5 .$Articulations } =	[ 8, 110, 110, 110, 110, 110, 110, 110, 110 ];
$u_theme{ 5 .$Rhythms } =	[ 8, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5 ];
$u_theme{ 5 .$Velocities } =	[ 8, 90, 90, 90, 90, 100, 90, 80, 70 ];

$u_theme{ 6 .$Pitches } =	[ 7, 8, 7, 8, 5, 7, 8, 5 ];
$u_theme{ 6 .$Articulations } =	[ 7, 110, 100, 100, 70, 100, 100, 70 ];
$u_theme{ 6 .$Rhythms } =	[ 7, 200, 25, 25, 50, 25, 25, 50 ];
$u_theme{ 6 .$Velocities } =	[ 7, 100, 110, 110, 100, 80, 80, 100 ];

$u_theme{ 7 .$Pitches } =	[ 7, 5, 3, 4, 2, 1, 10, 9 ];
$u_theme{ 7 .$Articulations } =	[ 7, 110, 110, 110, 110, 70, 70, 120 ];
$u_theme{ 7 .$Rhythms } =	[ 7, 100, 100, 100, 100, 25, 25, 150 ];
$u_theme{ 7 .$Velocities } =	[ 7, 90, 90, 90, 90, 110, 110, 100 ];

&set_primary_theme(\%u_theme, 0);
&set_secondary_theme(\%u_theme, 1);
&set_secondary_theme(\%u_theme, 2);
&set_secondary_theme(\%u_theme, 3);
&set_secondary_theme(\%u_theme, 4);
&set_secondary_theme(\%u_theme, 5);
&set_secondary_theme(\%u_theme, 6);
&set_secondary_theme(\%u_theme, 7);




#
#
# MAIN LOOP
#
#

srand(shift(@ARGV));

$MaxPhrases = $NumPhrasesList[ int(rand(@NumPhrasesList)) ];

&create_score;

$mode = shift(@ARGV);

if ($mode eq 'variations') {

    &feed_score_to_ear;
    while (&ear_still_listening) {
	&modify_score;
	&feed_score_to_ear;
    }
    &output_score;

} elsif ($mode eq 'noear') {

    &save_this_score(0);
    &output_score;

} elsif ($mode eq 'opinion') {

    &feed_score_to_ear;
    print shift(@ARGV), ": $BadSections Bad Sections out of $TotalTrans Total Transitions: ", (100 * $BadSections / $TotalTrans), "\n" ;

} else {

    die "ERROR: NO MODE GIVEN \n";

}

