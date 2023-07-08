#!/usr/bin/perl

use LammpsConf;
my $config=LammpsConf->new();

my $nlattice=40;

my $dim=2;



$config->SetBoxX( -($nlattice+1)*1.1   , ($nlattice+1)*1.1   );
$config->SetBoxY( -($nlattice+1)/2*1.1 , ($nlattice+1)/2*1.1 );
$config->SetBoxZ( -0.1 , 0.1 );

$config->SetAtomTypes(3);
#  1 left lattice
#  2 right lattice
#  3 border.

my @vertices;

# type 1
for (my $x= -$nlattice-0.5 ; $x<=-0.5 ; $x++)
{
  for (my $y= -$nlattice/2 ; $y<=$nlattice/2 ; $y++)
    {
       push @vertices,[$x,$y,1];
    }
}

# type 2
for (my $x= 0.5 ; $x<=$nlattice+0.5 ;  $x++)
{
  for (my $y= -$nlattice/2 ; $y<=$nlattice/2 ; $y++)
    {
       push @vertices,[$x,$y,2];
    }
}

# type 3
for (my $x= -$nlattice-0.5-1 ; $x<=$nlattice+0.5+1;  $x++)
{
  push @vertices,[$x,-$nlattice/2-1,3];
  push @vertices,[$x, $nlattice/2+1,3];
}

  for (my $y= -$nlattice/2 ; $y<=$nlattice/2 ; $y++)
{
  push @vertices,[-$nlattice-0.5-1, $y,3];
  push @vertices,[+$nlattice+0.5+1, $y,3];
}

print "Number of vertices created: ".(scalar(@vertices))."\n";
my $m=$config->AddMolecule();

my @atommap;
for (my $i=0 ; $i<scalar(@vertices); $i++)
{
   my ($x,$y,$type)=@{$vertices[$i]} ;  
   $atommap[$i]=$config->AddMoleculeAtomType($m,$x,$y,0, $type);
}

for (my $i=0 ; $i<scalar(@vertices); $i++)
{
   for (my $j=$i+1 ; $j<scalar(@vertices); $j++)
     {
        my ($x1,$y1,$type1)=@{$vertices[$i]};
        my ($x2,$y2,$type2)=@{$vertices[$j]};

        $config->AddBond($atommap[$i],$atommap[$j],1) 
           if ( abs( sqrt( ($x2-$x1)**2+($y2-$y1)**2 ) -1 )<1e-3);
     }
}

$config->SetTimeStep(0);
$config->SaveInput("lattice$nlattice.input.gz");

