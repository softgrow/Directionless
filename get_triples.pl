use strict;
use warnings;
use Time::Piece;

# Return the difference between two yyyymmddhhmmss dates in seconds
sub datediff {
  my ($low_date, $high_date) = @_;
  my $high_t = Time::Piece->strptime($high_date, "%Y%m%d%H%M%S");
  my $low_t = Time::Piece->strptime($low_date, "%Y%m%d%H%M%S");

  return $high_t-$low_t;
}

my $input_filename = 'order.csv';
open(my $fh, '<', $input_filename)
  or die "Could not open file '$input_filename' $!";
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
      # Intersection repeated it is a new journey, flush the buffer
      $inter1 = $inter;
      $date1 = $date;
    }
  }
  elsif ($buffer_state == 2) {
    if ($inter2 != $inter) {
      # Got a triple
      # Print out result
      print sprintf("%5d", $inter1).','.sprintf("%5d", $inter2).','.sprintf("%5d", $inter);
      print ','.$date1.','.datediff($date1, $date2).','.$id."\n";
      # Shuffle up buffer
      $date1 = $date2;
      $inter1 = $inter2;
      $date2 = $date;
      $inter2 = $inter;
    }
    else {
      # Intersection repeated it is a new journey, flush the buffer 
      $inter1 = $inter;
      $date1 = $date;
      $buffer_state = 1;
   }
  }
} 
