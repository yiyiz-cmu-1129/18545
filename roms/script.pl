#!/usr/bin/perl
#

$outputFile = "mem.hex";
$fileName = "68kmem.txt";
open(DATA, "<$fileName") or die;
@lines = <DATA>;
close(DATA);
open(DATAOUT, "+>>$outputFile");

foreach(@lines){
    $line = $_;
    for($i = 0; $i < 19; $i = $i+1){
        chop($line);
    }
    @spic = split(/:/, "$line");
    $line = $spic[1] . "\n";
    $line =~ s/^\s+//;
    print DATAOUT $line;
}
close(DATAOUT);
