use strict;
use warnings;

open(my $fh, '<', 'list.txt')
  or die "Could not open file 'list.txt' $!";
# output for fgrep
open(my $fgrep, '>', 'fgrep.txt');
# Want to get two or triplets with same first two intersections
# and at least 1000 samples
my $matchint = q{};
my $buffered_row;
my $fgrep_got = q{};
while (my $row = <$fh>) {
  chomp $row;
  if (my ($count, $int_1, $int_2, $int_3) = ($row =~ /([0-9]+) *([0-9]+), *([0-9]+),[ ]*([0-9]+)/)) {
    if ($count > 6200) {
      if ($matchint eq $int_1."x".$int_2) {
        if ($buffered_row ne q{})
          {
            print "\n".$buffered_row."\n";
            $buffered_row = q{};
            if ($matchint ne $fgrep_got) {
              print $fgrep "^".sprintf("%5d", $int_1).','.sprintf("%5d", $int_2)."\n";
              $fgrep_got=$matchint;
            }
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
close $fgrep;
