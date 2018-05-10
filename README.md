# Bruce
<pre>
output MIDI

use warnings;
use strict;

my @dorian=('G', 'A', 'Bb', 'C', 'D', 'E', 'F');

my $samples = 16; # two bars of 16th notes
my $budget = 6; # number of interval changes
my $start = 0; # tonic
my $target = 0; # tonic
my $step = 0;
my $note;
my $ratio;
my $count=1;

printf("%s\n",$dorian[$start]);

$note = $start;
# loop
while($step < $samples){
        $ratio = ($budget+$count-1)/($samples - $step);
        if($ratio > rand(1)){
                printf("%s %d b:%d\n", $dorian[$note],$count,$budget);
                $note = int(rand(7));
                $count = 1;
                $budget--;
        }else{
                $count++;
        }
        $step++
}
printf("%s\n", $dorian[$target]);

