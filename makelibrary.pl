#!/usr/bin/perl-w

use strict;

my $filename;
my $seq;
my $i;
my @lines;
my $LINE;
my $content;

opendir ( DIR, '#######' ) || die "Error in opening dir \n"; #fill with your reference dir
while(($filename = readdir(DIR))){

        open (CHR,'#######'.$filename)|| die "Error in opening CHR\n";
        @lines = <CHR>;
        
        foreach $LINE (@lines){
                $content .= $LINE;
                chomp($content);
                $content = uc($content);

                for($i=0;$i<=length($content)-11;$i++){
                        $seq= substr($content,$i,11);
                        opendir ( LIB, '#######' ) || die "Error in opening LIB \n"; #fill with your output dir
                        if (($seq != readdir(LIB))){
                                open (OUT,'>'.'#######'.'/'.$seq);
                                print OUT $filename.':'.$i.".";
                                close OUT;
                        }
                        else{
                                open (OUT,'>>'.'#######'.'/'.$seq);
                                print OUT $filename.':'.$i.".";
                                close OUT;
                        }
                closedir(LIB);
                }        
        }
        close CHR;
}
closedir(DIR);
