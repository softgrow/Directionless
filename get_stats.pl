use strict;
use warnings;
use IO::Uncompress::Gunzip qw/$GunzipError/;

# Read in triple_sorted.gz
# Get a hour and minimum count specified on the command line
my ($period_wanted, $minimum_count) = @ARGV;

# Get the labels for the intersections
my %int_names;
open(my $NAMES_FIL, '<', 'BTSites.csv')
  or die "Could not open file 'BTSites.csv' $!";
# skip_header
<$NAMES_FIL>;
while (my $record = <$NAMES_FIL>) {
  my ($int_no, $int_label) = split(/,/, $record);
  $int_names{$int_no}=$int_label;
}

my $num_times=0;
my $sum_times=0;
# Keep a hash of n for each direction
my %count_direction;
my %sum_direction;
# print the header line
print "Ifrom,Intersection From,Ito,Intersection To,Time Filter,N,Average";
foreach my $int_no (1..4) {
  print ",N$int_no,Diff$int_no,Int$int_no,Intersection $int_no";
}
print "\n";

sub flush_data {
  my ($int_from, $int_to) = @_;
  if ($num_times >= $minimum_count) {
    my $int_average=$sum_times/$num_times;
    print $int_from.','.$int_names{$int_from}.','
          .$int_to.','.$int_names{$int_to}.','.$period_wanted.','.$num_times.','
     .sprintf("%.2f", $int_average);
    foreach my $this_dir (sort { $count_direction{$b} <=> $count_direction{$a} } keys %count_direction) {
      print ','.$count_direction{$this_dir}.','
            .sprintf("%.2f", $sum_direction{$this_dir}/$count_direction{$this_dir} - $int_average);
      print ','.$this_dir.',';
      print $int_names{$this_dir};
    }
    print "\n"; 
  }
  $num_times=0;
  $sum_times=0;
  %count_direction=();
  %sum_direction=();
}

my $fh = new IO::Uncompress::Gunzip 'triple_sorted.gz'
    or die "gunzip failed: $GunzipError\n";

# Want to get two or triplets with same first two intersections
# and at least 1000 samples
my $last_from = 0;
my $last_to = 0;
my $int_from;
my $int_to;
# Keep a hash of sum for each direction
while (my $row = <$fh>) {
  chomp $row;
  ($int_from, $int_to,my  $int_dir,my  $time_date,my  $duration,my  $bt_id) = split (/,/, $row);
  $int_from+=0;
  $int_to+=0;
  $int_dir+=0;
  if ($last_from != $int_from || $last_to != $int_to) {
    flush_data($last_from, $last_to);
    $last_from = $int_from;
    $last_to = $int_to;
  }
  if (0 == index $time_date, $period_wanted) {
    # have a line we want
    $num_times++;
    $sum_times+=$duration;
    $count_direction{$int_dir}++;
    $sum_direction{$int_dir}+=$duration;
  }
}
flush_data($int_from, $int_to);
close $fh;
