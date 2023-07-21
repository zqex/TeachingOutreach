#!/usr/bin/perl

use LammpsConf;
my $config=LammpsConf->new();

my $box=40;

my $dim=3;
my $b2=1;
my $kT=1;
my $nlen=31;   # beads
my $npoly=100;

#spring constant
my $k = $dim*$kT/$b2;

#filename
my $filename="pull_polymers_${npoly}chains_".($nlen-1)."bonds.input";

print "kspring = $k\n";

#standard deviation of Gaussian distributed bond x,y,z components.
my $sigma= sqrt($b2/$dim);

$config->SetBoxX(-10,40);
$config->SetBoxY(-20,20);
$config->SetBoxZ(-20,20);
$config->SetAtomTypes(3);

for (my $n=0; $n<$npoly; $n++)
  {
      my $m=$config->AddMolecule();
      my ($x,$y,$z)=(0,0,0);
      my $aold=undef;

      for (my $i=0; $i<$nlen; $i++)
          {
              my $typ=2;
              $typ=1 if ($i==0);
              $typ=3 if ($i==$nlen-1);
              
              my $a=$config->AddMoleculeAtomType($m,$x,$y,$z, $typ);
              $config->AddBond($a,$aold,1) if (defined $aold);

              my ($dx,$dy)=@{ gaussian_rand($sigma) }; 
              $x+=$dx;  $y+=$dy;
              my ($dz,$dw)=@{ gaussian_rand($sigma) };
              $z+=$dz;

              $aold=$a;
          }
  }

print "Generating $filename\n";
$config->SetTimeStep(0);
$config->SaveInput($filename);

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

