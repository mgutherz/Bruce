Identifier "main::Primary" used only once: possible typo at variations.pl line 60.
Identifier "main::DefaultOctave" used only once: possible typo at variations.pl line 40.
Identifier "main::PitchModulo" used only once: possible typo at variations.pl line 37.
Identifier "main::MaxPhraselen" used only once: possible typo at variations.pl line 34.
Identifier "main::AllTypes" used only once: possible typo at variations.pl line 63.
Identifier "main::EarGene" used only once: possible typo at variations.pl line 75.
Identifier "main::DefaultTimesig" used only once: possible typo at variations.pl line 44.
Identifier "main::Instrument" used only once: possible typo at variations.pl line 54.
Identifier "main::NotNoteTypes" used only once: possible typo at variations.pl line 65.
Identifier "main::Timesig" used only once: possible typo at variations.pl line 57.
Identifier "main::MaxIts" used only once: possible typo at variations.pl line 33.
Identifier "main::ModifyOverOthers" used only once: possible typo at variations.pl line 88.
Identifier "main::KeyTypes" used only once: possible typo at variations.pl line 66.
Identifier "main::BadAllowed" used only once: possible typo at variations.pl line 86.
Identifier "main::Speed" used only once: possible typo at variations.pl line 56.
Identifier "main::ID_start" used only once: possible typo at variations.pl line 36.
Identifier "main::MaxPhrases" used only once: possible typo at variations.pl line 195.
Identifier "main::DefaultMajor" used only once: possible typo at variations.pl line 42.
Identifier "main::Modified" used only once: possible typo at variations.pl line 58.
Identifier "main::SpecialEvent" used only once: possible typo at variations.pl line 84.
Identifier "main::ChoosePrimary" used only once: possible typo at variations.pl line 85.
Identifier "main::ModificationProb" used only once: possible typo at variations.pl line 87.
Identifier "main::NoteTypes" used only once: possible typo at variations.pl line 64.
Identifier "main::DefaultKey" used only once: possible typo at variations.pl line 41.
Identifier "main::DefaultSpeed" used only once: possible typo at variations.pl line 43.
Identifier "main::DEBUG2" used only once: possible typo at variations.pl line 23.
Identifier "main::NumInstruments" used only once: possible typo at variations.pl line 35.
Identifier "main::RandomOverVary" used only once: possible typo at variations.pl line 89.
init_composer
init_ear
init_output
init_themes
init_variations 
copy_theme _Pitch : 5 1 9 5 1 rest 
copy_theme _Articulation : 40 40 99 30 60 50 
copy_theme _Rhythm : 25 25 75 25 25 125 
copy_theme _Velocity : 100 90 110 80 90 80 
random_measures 
copy_theme _Pitch : 7 8 5 3 4 rest 
copy_theme _Articulation : 120 120 200 60 150 50 
copy_theme _Rhythm : 25 25 75 25 25 125 
copy_theme _Velocity : 100 90 110 80 90 80 
random_measures 
copy_theme _Pitch : 4 5 5 3 4 
copy_theme _Articulation : 99 70 70 90 50 
copy_theme _Rhythm : 12.5 25 25 12.5 25 
copy_theme _Velocity : 100 100 100 80 90 
random_measures 
copy_theme _Pitch : 4 5 2 4 3 
copy_theme _Articulation : 60 70 80 90 100 
copy_theme _Rhythm : 12.5 12.5 12.5 12.5 50 
copy_theme _Velocity : 90 90 90 100 100 
random_measures 
copy_theme _Pitch : 5 1 9 
copy_theme _Articulation : 80 80 150 
copy_theme _Rhythm : 25 25 50 
copy_theme _Velocity : 95 80 110 
random_measures 
copy_theme _Pitch : rest 3 4 5 4 3 2 1 
copy_theme _Articulation : 110 110 110 110 110 110 110 110 
copy_theme _Rhythm : 12.5 12.5 12.5 12.5 12.5 12.5 12.5 12.5 
copy_theme _Velocity : 90 90 90 90 100 90 80 70 
random_measures 
copy_theme _Pitch : 8 7 8 5 7 8 5 
copy_theme _Articulation : 110 100 100 70 100 100 70 
copy_theme _Rhythm : 200 25 25 50 25 25 50 
copy_theme _Velocity : 100 110 110 100 80 80 100 
random_measures 
copy_theme _Pitch : 5 3 4 2 1 10 9 
copy_theme _Articulation : 110 110 110 110 70 70 120 
copy_theme _Rhythm : 100 100 100 100 25 25 150 
copy_theme _Velocity : 90 90 90 90 110 110 100 
random_measures 
create_score
PHRASE 0
compose_phrase
random_channel 
random_measures 
vary_key 
vary_pitches 
print_array from vary_pitches: take 8 from 6, 5 1 9 5 1 rest
Unquoted string "rest" may clash with future reserved word at (eval 1) line 1.
print_array from vary_artic: take 8 from 6, 40 40 99 30 60 50
vary_rhythms 
print_array from vary_rhythms: take 8 from 6, 25 25 75 25 25 125
vary_velocities 
print_array from vary_velocities: take 8 from 6, 100 90 110 80 90 80
PHRASE 1
compose_phrase
random_channel 
random_measures 
vary_octave 
vary_pitches 
print_array from vary_pitches: take 4 from 7, 5 3 4 2 1 10 9
print_array from vary_artic: take 4 from 7, 110 110 110 110 70 70 120
vary_rhythms 
print_array from vary_rhythms: take 4 from 7, 100 100 100 100 25 25 150
vary_velocities 
print_array from vary_velocities: take 4 from 7, 90 90 90 90 110 110 100
PHRASE 2
compose_phrase
random_channel 
random_measures 
vary_major 
vary_pitches 
print_array from vary_pitches: take 2 from 6, 5 1 9 5 1 rest
Unquoted string "rest" may clash with future reserved word at (eval 9) line 1.
print_array from vary_artic: take 2 from 6, 40 40 99 30 60 50
vary_rhythms 
print_array from vary_rhythms: take 2 from 6, 25 25 75 25 25 125
vary_velocities 
print_array from vary_velocities: take 2 from 6, 100 90 110 80 90 80
PHRASE 3
compose_phrase
random_channel 
random_measures 
vary_octave 
vary_key 
vary_major 
vary_pitches 
print_array from vary_pitches: take 5 from 6, 5 1 9 5 1 rest
Unquoted string "rest" may clash with future reserved word at (eval 13) line 1.
print_array from vary_artic: take 5 from 6, 40 40 99 30 60 50
vary_rhythms 
print_array from vary_rhythms: take 5 from 6, 25 25 75 25 25 125
vary_velocities 
print_array from vary_velocities: take 5 from 6, 100 90 110 80 90 80
PHRASE 4
compose_phrase
random_channel 
random_measures 
vary_octave 
vary_major 
vary_pitches 
print_array from vary_pitches: take 5 from 3, 5 1 9
print_array from vary_artic: take 5 from 3, 80 80 150
vary_rhythms 
print_array from vary_rhythms: take 5 from 3, 25 25 50
vary_velocities 
print_array from vary_velocities: take 5 from 3, 95 80 110
PHRASE 5
compose_phrase
random_channel 
random_measures 
vary_octave 
vary_major 
vary_pitches 
print_array from vary_pitches: take 7 from 6, 7 8 5 3 4 rest
Unquoted string "rest" may clash with future reserved word at (eval 21) line 1.
Unquoted string "rest" may clash with future reserved word at (eval 21) line 1.
print_array from vary_artic: take 7 from 6, 120 120 200 60 150 50
vary_rhythms 
print_array from vary_rhythms: take 7 from 6, 25 25 75 25 25 125
vary_velocities 
print_array from vary_velocities: take 7 from 6, 100 90 110 80 90 80
PHRASE 6
PHRASE 0
PHRASE 1
PHRASE 2
PHRASE 3
PHRASE 4
PHRASE 5
vary_articulations 
vary_articulations 
vary_articulations 
vary_articulations 
vary_articulations 
vary_articulations 
0, comment Lowest BadPercentage = 100 ; 
0, comment Iteration Type = 0 ; 
1, clear clear ; 
2, speed 100 ; 
3, timesig 4 ; 
4, key 4 A# maj ; 
5, measures 0 ; 
6, 6: pitch 8 31 7 3 31 rest 3 31 7 ; 
7, 6: artic 8 44 111 33 67 56 44 44 111 ; 
8, 6: rhyth 8 150 50 50 250 50 50 150 50 ; 
9, 6: veloc 8 12 101 114 101 127 114 12 101 ; 
10, key 8 A# maj ; 
11, measures 0 ; 
12, 6: pitch 4 1 0 9 8 ; 
13, 6: artic 4 120 76 76 131 ; 
14, 6: rhyth 4 150 150 37.5 37.5 ; 
15, 6: veloc 4 91 91 91 91 ; 
16, key 8 A# min ; 
17, measures 3 ; 
18, 2: pitch 2 30 rest ; 
19, 2: artic 2 34 69 ; 
20, 2: rhyth 2 16.66666665 16.66666665 ; 
21, 2: veloc 2 107 77 ; 
22, key 2 Eb min ; 
23, measures 1 ; 
24, 7: pitch 5 6 14 10 6 rest ; 
25, 7: artic 5 55 46 37 37 91 ; 
26, 7: rhyth 5 50 250 50 50 150 ; 
27, 7: veloc 5 77 69 86 77 95 ; 
28, key 5 Eb min ; 
29, measures 0 ; 
30, 8: pitch 5 7 3 11 7 3 ; 
31, 8: artic 5 84 157 84 84 157 ; 
32, 8: rhyth 5 25 12.5 12.5 25 12.5 ; 
33, 8: veloc 5 63 53 74 63 53 ; 
34, key 8 Eb min ; 
35, measures 1 ; 
36, 4: pitch 7 rest 8 9 6 4 5 rest ; 
37, 4: artic 7 287 86 215 71 172 172 287 ; 
38, 4: rhyth 7 75 225 75 75 375 75 75 ; 
39, 4: veloc 7 80 90 80 100 90 110 80 ; 
40, finis 10;
41, start 0; 
42, start 1; 
