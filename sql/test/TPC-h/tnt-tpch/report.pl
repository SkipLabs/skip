#!/usr/bin/env perl
my %Q, @Q;
my $q = undef;
while(<>) {
  if (m[^queries/(.*).sql]) {
    $q = $1;
    unless (defined $Q{$q}) {
      push(@Q, $q);
      $Q{$q} = 'Q'.$q;
    }
  }
  if (/^real\s+(\d+)m(\S+)s/) {
    my $secs = ($1*60 + $2);
    $Q{$q} .= ';'. $secs;
  }
}

# foreach my $l (sort { $a <=> $b } keys %Q) {
foreach my $l (@Q) {
  print "$Q{$l}\n";
}
