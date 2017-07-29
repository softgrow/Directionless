use strict;
use warnings;

open(my $fh, '<', 'order.csv')
  or die "Could not open file 'sorto.csv' $!";
# Want to get three triplets with 
# the same ID
# Diferent Intersection
# TODO: Limit the time between dates
my $buffer_state = 0;
my $thisid = 0;
my $inter1;
my $date1;
my $inter2;
my $date2;
# Throw away the header
<$fh>;
while (my $row = <$fh>) {
  chomp $row;
  my ($date, $inter, $id) = split(/,/, $row);
  if ($id != $thisid) {
    # a new tracker id flush the buffer
    $thisid = $id;
    $buffer_state = 1;
    $inter1 = $inter;
    $date1 = $date;
  } 
  # Have the same tracker id as before
  elsif ($buffer_state == 1) {
    if ($inter1 != $inter) {
      $buffer_state++;
      $inter2 = $inter;
      $date2 = $date;
    }
    else
    {
      # Intersection repeated throw away last result
      $inter1 = $inter;
      $date1 = $date;
    }
  }
  elsif ($buffer_state == 2) {
    if ($inter2 != $inter) {
      # Got a triple
      # Print out result
      print sprintf("%5d", $inter1).','.sprintf("%5d", $inter2).','.sprintf("%5d", $inter);
      print ','.$date1.','.$date2.','.$date.','.$id."\n";
      # Shuffle up buffer
      $date1 = $date2;
      $inter1 = $inter2;
      $date2 = $date;
      $inter2 = $inter;
    }
    else {
      # Intersection repeated throw away last result
      $inter2 = $inter;
      $date2 = $date;
   }
  }
} 
