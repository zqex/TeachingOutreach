#!/usr/bin/perl

use LammpsConf;
my $config=LammpsConf->new();

my $box=40;

my $dim=2;
my $b2=1;
my $kT=1;
my $nlen=11;   # beads
my $npoly=100;

my $k = $dim*$kT/$b2;

print "kspring = $k\n";

my $sigma= sqrt($b2/$dim);

$config->SetBox($box);
$config->SetAtomTypes(3);

for (my $n=0; $n<$npoly; $n++)
  {
      my $m=$config->AddMolecule();
      my ($x,$y,$z)=@{ $config->RandomPos() }; $z=0;
      my $aold=undef;

      for (my $i=0; $i<$nlen; $i++)
          {
              my $typ=1;
              my $a=$config->AddMoleculeAtomType($m,$x,$y,0, $typ);

              $config->AddBond($a,$aold,1) if (defined $aold);

              my ($dx,$dy)=@{ gaussian_rand($sigma) }; 
              $x+=$dx;  $y+=$dy;

              $aold=$a;
          }
  }

$config->SetTimeStep(0);
$config->SaveInput("rouse_polymers_${npoly}chains_".($nlen-1)."bonds.input");

sub gaussian_rand {
    my $sigma=shift;
    
    my ($u1, $u2);  # uniformly distributed random numbers
    my $w;          # variance, then a weight
    my ($g1, $g2);  # gaussian-distributed numbers

    do {
        $u1 = 2 * rand() - 1;
        $u2 = 2 * rand() - 1;
        $w = $u1*$u1 + $u2*$u2;
    } while ( $w >= 1 );

    $w = sqrt( (-2 * log($w))  / $w );
    $g1 = $u2 * $w*$sigma;
    $g2 = $u1 * $w*$sigma;

    return [$g1,$g2];
}

