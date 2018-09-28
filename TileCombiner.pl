#!/usr/bin/perl
use strict;
use warnings;
use Image::Magick;

my $col = 16;
my $count = 0;
 
my @all_files = glob "./tiles/*";
my @png_files;

my $max_num = 0;
foreach(@all_files) {
    if(/tiles_(\d+).png$/) {
        push(@png_files, $_);
        if($max_num < $1){
            $max_num = $1;
        }
    }
}
print $max_num;
 
my $image = Image::Magick->new;
for($count = 0; $count <= $max_num; $count++) {
    my $file = "./tiles/tiles_".$count.".png";
    if(-f $file){
        $image->Read($file);
    }else{
        $image->Read("blank.png");
    }
}

my $rows = ceil($max_num / $col);

my $now = time;
my $outFilePath = sprintf("./out/"."%d"."_"."%03d".".png", $now, $count);

my $tile = "16x$rows";
my $append = $image->Montage(geometry=>'32x32', tile=>$tile);
$append->Write($outFilePath);

$image = undef;
$image = Image::Magick->new;
 
exit 0;

sub ceil {
  my $col = shift;
  my $val = 0;
 
  $val = 1 if($col > 0 and $col != int($col));
  return int($col + $val);
}
