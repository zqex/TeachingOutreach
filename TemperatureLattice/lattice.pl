#!/usr/bin/perl

use LammpsConf;
my $config=LammpsConf->new();

my $nx=40;
my $ny=40;
my $yw=4;
my $dim=2;

#
#    Creates two nxXnx lattices with a boundary between them, and a boundary between them.
#    The boundary has a hole allowing energy to flow between the two lattices.
#
#

$config->SetBoxX( -($nx+1)*1.1   , ($nx+1)*1.1   );
$config->SetBoxY( -($nx+1)/2*1.1 , ($nx+1)/2*1.1 );
$config->SetBoxZ( -0.1 , 0.1 );

$config->SetAtomTypes(3);
#  1 left lattice
#  2 right lattice
#  3 border.

my @vertices;

for (my $x=-$nx-1 ; $x<=$nx+1; $x++)
{
   for (my $y=-$ny/2-1 ; $y<=$ny/2+1; $y++)
     {
        my $type=3;   #boundary
        
        $type=1 if ($x<0);   #left
        $type=2 if ($x>0);   #right

        $type=1 if ($x==0 and $y>=0 and $y<=$yw);   #beads in window
        $type=2 if ($x==0 and $y<0  and $y>=-$yw);   #beads in window

        $type=3 if ($x<-$nx or $x>$nx);             #fix sides to type 3
        $type=3 if ($y<-$ny/2 or $y>$ny/2);         #fix top and bottom to type 3

        $type=3 if (rand()<0.02);                   # random vertices fixed to scatter phonons.
 
        push @vertices,[$x,$y,$type];
     }
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
$config->SaveInput("lattice$nx.input.gz");

