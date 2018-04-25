#
#
# utils.pl
#
#


#
#
# random
#
# given a number between 0 and 100, returns whether a random number
# is less than or equal to the percentage.
#
#

sub random {
    local ($percent) = @_;
    if ($percent >= rand(100)) {
	1;
    } else {
	0;
    }
}





1;
