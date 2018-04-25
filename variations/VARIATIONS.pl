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


$u_theme{ 0 .$Pitches } =	[ 7, 1, 3, 5, -1, 1, 2, 1 ];
$u_theme{ 0 .$Articulations } =	[ 7, 100, 100, 100, 100, 100, 100, 100 ];
$u_theme{ 0 .$Rhythms } =	[ 7, 100, 50, 50, 75, 12.5, 12.5, 100 ];
$u_theme{ 0 .$Velocities } =	[ 7, 90, 90, 90, 90, 90, 90, 90 ];

&set_primary_theme(\%u_theme, 0);




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

    while ($ID < 100) {
	&modify_score;
    }
    &save_this_score(0);
    &output_score;

} elsif ($mode eq 'opinion') {

    &feed_score_to_ear;
    if (&ear_dislikes_it) {
	print "$BadSections Bad Sections out of ",$TotalTrans-1," Total Transitions: ",
		int(100 * $BadSections / $TotalTrans-1), "\t ear says FAIL\n";
    } else {
	print "$BadSections Bad Sections out of ",$TotalTrans-1," Total Transitions: ",
		int(100 * $BadSections / $TotalTrans-1), "\t ear says PASS\n";
    }

} else {

    die "ERROR: NO MODE GIVEN \n";

}

