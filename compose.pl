use warnings;
use strict;
use Data::Dumper;

my $track = {
      'type' => 'MTrk',
      'events' => [  # 652 events.
                ['control_change', 0, 13, 7, 74],
                ['patch_change', 0, 13, 33],
        ]
};


my @dorian=('G', 'A', 'Bb', 'C', 'D', 'E', 'F');

my @gchromatic=('G','Ab','A','Bb','B','C','C#','D','Eb','E','F','F#'); # G chromatic, transpose in MIDI if needed

my @dscale=    ('1','0' ,'1','1', '0','1','0' ,'1','0' ,'1','1','0'); # semitones in Dorian scale
my @bscale=    ('1','0' ,'0','1', '0','1','1' ,'1','0' ,'0','1','0'); # semitones in Blues scale
my @pscale=    ('1','0' ,'1','0', '0','1','1' ,'1','0' ,'1','0','0'); # semitones in Pentatonic scale
my @mscale=    ('1','0' ,'0','1', '0','1','0' ,'1','0' ,'0','1','0'); # semitones in Minor Penta scale

my @theme;
my @event;

my @workingscale = @mscale;

my $samples = 32; # four bars of 8th notes
my $budget = 12; # number of interval changes
my $start = 60; # semitone
my $target = $start; # semitone
my $midioffset = -5; # for g3 midi 55
my $interval;
my $step = 0;
my $note;
my $ratio;
my $count=1;
my $chordtone = 0;
my $midtick = 600;
my $middur = $midtick/2;
my $channel = 2;

# conside g3 as center D string 5th fret MIDI 55, G4=67

$note = $start;

print Dumper($track);

printf("\nThe Theme\n\n");

# loop
while($step < $samples){
        $ratio = ($budget+$count-1)/($samples - $step);
        if($ratio > rand(1)){ # time to change
                printf("Note:%s Midi:%d Dur: %d\n", $gchromatic[$note % 12],$note + $midioffset, $count);
                push @theme, sprintf("%d %d", $note , $count);
                @event =(['note_on',$count * $middur, $channel, $note + $midioffset, 96]);
                push @{$track->{events}}, @event;
                # Need note_off?
                #
                # move a random interval in the scale
                #
                while(1){
                        $interval = int(rand(13)) - 6; # +/- half octive
                        if($workingscale[($note + $interval) % 12]){
                                $note += $interval;
                                last;
                        }
                }
                $count = 1;
                $budget--;
        }else{
                $count++;
        }
        $step++
}
# Target note
printf("Note:%s Midi:%d Dur: %d\n", $gchromatic[$target % 12],$target + $midioffset, 4);
push @theme, sprintf("%d %d", $target , 4);
@event =(['note_on', 4 * $middur, $channel, $target + $midioffset, 96]);
push @{$track->{events}}, @event;

@event =(['note_off', 4 * $middur, $channel, $target + $midioffset, 96]);
push @{$track->{events}}, @event;

#print Dumper($track);

# Fuzz it
#

printf("\nThe Fuzz\n\n");

foreach (@theme){
        #printf("%s\n", $_);
        ($note, $count) = split ' ';
        if(rand(2) < 1){ # will be fuzzed
                while(1){
                        $interval = int(rand(7)) - 3; # +/- three semi
                        if($workingscale[($note + $interval) % 12]){
                                $note += $interval;
                                last;
                        }
                }
        }
        printf("Note:%s Midi:%d Dur: %d\n", $gchromatic[$note % 12],$note + $midioffset, $count);
                @event =(['note_on',$count * $middur, $channel, $note + $midioffset, 96]);
                push @{$track->{events}}, @event;

}
@event =(['note_off', 4 * $middur, $channel, $target + $midioffset, 96]);
push @{$track->{events}}, @event;

print Dumper($track);

$ 
