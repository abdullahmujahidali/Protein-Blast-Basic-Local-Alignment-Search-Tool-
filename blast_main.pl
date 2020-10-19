#!/urs/bin/perl   

###### get query:
open FILE3, '/3_disk/zhujd/query1.fa' or die "cannot open the file: $!\n";

my @DNA=<FILE3>;
my $seq = join('', @DNA);   $seq=~s/\R//g; $seq=~s/\n//g;
my $count=0;  my $tally=0;
my @compare;

while ($count<=(length($seq)-11)) {
    my $n=substr($seq, $count, 11);
    open FILE, "/2_disk/chenyr/libfiles1/$n" or die "cannot open the file: $!\n";

    @DNA=<FILE>;
    my $Words = join('', @DNA);
    @Words_loc=split(/\./,$Words);

    while ($tally<=$#Words_loc) {                    
        $compare[$count][$tally]=@Words_loc[$tally]; #store all positions of all words
        $tally ++;
    }
    $tally=0;
    $count ++;
}
close FILE;



$count=0; 
%grade;
while ($count<=(length($seq)-11)) {    #get every matched words's number of position
    $a = $#{$compare[$count]};         

    while ($tally<=$a) {
        @B=split(/:/,$compare[$count][$tally]); 
        $b=$B[1]-$count;               #$b refer to the beginning position

        if (exists $grade{$B[0]}{$b}) {
            $grade{$B[0]}{$b} ++;
        }
        else{
            $grade{$B[0]}{$b}=1;    #x shows chromosome No.
                                    #y shows position of every beginning of "every query"
        }                           #grade shows how many words give the same beginning
        $tally ++;
    }
    $tally=0;
    $count ++;
}



$count=1;                                   # this count refers to chromosome No.
while ($count<=25) {
    my %hash = %{$grade{$count}};           #hash initiation
    while(($key, $value) = each(%hash)) {   #$key is the certain beginning position on the chromosome
    if ($value>10) {                        #value is the "grade" above


            open FILE, "/2_disk/chenyr/hg19chr/$count" or die "cannot open the file: $!\n";
            $chr_target=<FILE>;
            my $loc_seq=substr($chr_target, $key, length($seq));    #get the sequence at the guessed location for later alignment



###### Alignment:

$count2=0;
$L=length($seq);
@Gene_One;
while($count2<$L){
$Gene_One[$count2]= substr($seq, $count2, 1);
$count2=$count2+1;
}

$count2=0;
$L=length($loc_seq);
@Gene_Two;
while($count2<$L){
$Gene_Two[$count2]= substr($loc_seq, $count2, 1);    
$count2=$count2+1;
}


@comparision;
$count2=1;
$L=length($seq);
while ($count2<=$L) {
    $comparision[$count2][0]=$Gene_One[$count2-1];
    $count2 ++;
}

$count2=1;
$L=length($loc_seq);
while ($count2<=$L) {
    $comparision[0][$count2]=$Gene_Two[$count2-1];
    $count2 ++;
}


$length_row=length($seq);
$length_line=length($loc_seq);
$length;
if ($length_row>$length_line) {
    $length=$length_row;
}
else{
    $length=$length_line;
}

$comparision[0][0]=0;

$count2_row=0;                                   
$count2_line=0;


$comparision[1][1]=0;
while ($count2_row<=$length) {
        $comparision[$count2_row+2][1]=$comparision[$count2_row+1][1]-2;
        $count2_row ++;
}

$comparision[1][1]=0;
while ($count2_line<=$length) {
        $comparision[1][$count2_line+2]=$comparision[1][$count2_line+1]-2;
        $count2_line ++;
}


$count2_row=0;                                    
$count2_line=0;

if ($comparision[1][0]=$comparision[0][1]) {
    $comparision[1][1]=1;
}

else{
    $comparision[1][1]=-1;
}

while ($count2_line<=$length+1) {
    while ($count2_row<=$length+1) {
        
        if ($comparision[$count2_row+1][0] eq $comparision[0][$count2_line+1]) {
            $N=$comparision[$count2_row][$count2_line]+2;
        }
        else{
            $N=$comparision[$count2_row][$count2_line]-3;
        }


        if ($N>=$comparision[$count2_row][$count2_line+1]-4 && $N>=$comparision[$count2_row+1][$count2_line]-4) {

            $comparision[$count2_row+1][$count2_line+1]=$N;
        }
        if ($N<$comparision[$count2_row][$count2_line+1]-4 && $comparision[$count2_row+1][$count2_line]-4<=$comparision[$count2_row][$count2_line+1]-4) {
            
            $comparision[$count2_row+1][$count2_line+1]=$comparision[$count2_row][$count2_line+1]-4;
        }
        if ($N<$comparision[$count2_row+1][$count2_line]-4 && $comparision[$count2_row+1][$count2_line]-4>$comparision[$count2_row][$count2_line+1]-4) {
            
            $comparision[$count2_row+1][$count2_line+1]=$comparision[$count2_row+1][$count2_line]-4;
        }
        $count2_row ++;
        
    }
        $count2_row=1;
        $count2_line ++;
}





@result_1;                            #the result array
@result_2;

$result_line=$length_line;
$marker1=0;


$result_row=$length_row;
$marker2=0;

$a1=0;   $a2=0;                       #local
while ($a1<$length_line) {
    while ($a2<$length_row) {
        if ($comparision[$a1][$a2+1]>$comparision[$a1][$a2]){
            $length_row=$a2+1;
            $length_line=$a1;
        }
        $a2 ++;
    }
    $a1 ++;
}



while ($result_line>=0 && $result_row>=0) {

    if ($comparision[$result_line-1][$result_row-1]>=$comparision[$result_line][$result_row-1] && 
        $comparision[$result_line-1][$result_row-1]>=$comparision[$result_line-1][$result_row]) {

        $result_1[$marker1]=$comparision[$result_line][0];
        $result_2[$marker2]=$comparision[0][$result_row];

        $result_line --;
        $result_row --;
    }

    if ($comparision[$result_line-1][$result_row-1]<$comparision[$result_line][$result_row-1] && 
        $comparision[$result_line][$result_row-1]>=$comparision[$result_line-1][$result_row]) {
        
        $result_1[$marker1]=$comparision[0][$result_row];
        $result_2[$marker2]='-';

        $result_row --;
    }

    if ($comparision[$result_line-1][$result_row-1]<$comparision[$result_line-1][$result_row] && 
        $comparision[$result_line][$result_row-1]<$comparision[$result_line-1][$result_row]) {
        
        $result_1[$marker1]='-';
        $result_2[$marker2]=$comparision[$result_line][0];

        $result_line --;
    }

    $marker1 ++;
    $marker2 ++;
}

   
    $marker1 --;
    $A=$marker1-1; $C=$A;

    $marker2 --;
 



print "Chromosome:",$count,"   ","Location:",($key+11),"   ",$value,"\n";    #$count is the chomesome No.，$value is score，$key is location

while ($marker1>0) {
    print $result_1[$marker1-1];
    $marker1 --;
}
print "\n";

$B=0;

while ($C>=0) {
    if ($result_1[$C] eq $result_2[$C]) {
        print '*';
        $B ++;
        if($result_1[$C] eq "-"){
            $B --;
            }
    }
    else{
        print $result_2[$C];
    }
    $C --;
}
print "\n";

while ($marker2>0) {
    print $result_2[$marker2-1];
    $marker2 --;
}

$P=100-0.5*(100-100*$B/$L);

print "\n";
print "The percentage of matching is ";
print $P; print "%","\n","\n";

        }
}
$count ++;
}


close FILE3;
