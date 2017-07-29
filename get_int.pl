use strict;
use warnings;

open(my $fh, '<', 'list.txt')
  or die "Could not open file 'list.txt' $!";
# Want to get two or triplets with same first two intersections
# and at least 1000 samples
my $matchint = q{};
my $buffered_row;
while (my $row = <$fh>) {
  chomp $row;
  if (my ($count, $int_1, $int_2, $int_3) = ($row =~ /([0-9]+) *([0-9]+), *([0-9]+),[ ]*([0-9]+)/)) {
    if ($count > 6200) {
      if ($matchint eq $int_1."x".$int_2) {
        if ($buffered_row ne q{})
          {
            print "\n".$buffered_row."\n";
            $buffered_row = q{};
          }
        print $row."\n";
      }
      else {
        $matchint = $int_1."x".$int_2;
        $buffered_row = $row; 
      }
    }
  }
  else {
    print "bad line\n$row"
  }
} 
