$cmdFile="./InputControl.Template2.f90";
$outFile="./InputControl.f90";
$cmdFile2="./test_solver.Template.f90";
$outFile2="./test_solver.f90";
$cmdFile3="./solver.Template.f90";
$outFile3="./solver.f90";
$cmdFile4="./output.txt";
$outFile4="./output_temp.txt";

# $lt_endpt = "-1.d0";
# $rt_endpt = "1.d0";
$lt_endpt = "-1.0_dp*ACOS(-1.0_dp)";
$rt_endpt = "ACOS(-1.0_dp)";
$var_coeff = "1.0_dp";
$num_intervals = "1";
$degree = "20";
$delta_t="0.02";
$end_time="3";
$isConst = "0";  #modify to 1 if the problem has variable coefficient

$IC = "COS(grd_pts)";

open(FILE,"$cmdFile") || die "cannot open file $cmdFile!" ;
      
open(OUTFILE,"> $outFile") || die "cannot open file!" ;
while( $line = <FILE> )
 {
 #Replace the strings by using substitution
 $line =~ s/\bIIII\b/$num_intervals/;
 $line =~ s/\bDDDD\b/$degree/;
 $line =~ s/\bFFFF\b/$IC/;
 $line =~ s/\bVVVV\b/$var_coeff/;

 print OUTFILE $line;
 }
 close( OUTFILE );
 close(FILE);

open(FILE,"$cmdFile2") || die "cannot open file $cmdFile2!" ;
open(OUTFILE,"> $outFile2") || die "cannot open file!" ;
while( $line = <FILE> )
{
$line =~ s/\bTTTT\b/$end_time/;
$line =~ s/\bDTDT\b/$delta_t/;
$line =~ s/\bDDDD\b/$degree/;
$line =~ s/\bLLLL\b/$lt_endpt/;
$line =~ s/\bRRRR\b/$rt_endpt/;
$line =~ s/\bIIII\b/$isConst/;

print OUTFILE $line;
}
close( OUTFILE );
close(FILE);
open(FILE,"$cmdFile3") || die "cannot open file $cmdFile3!" ;
open(OUTFILE,"> $outFile3") || die "cannot open file!" ;
while($line = <FILE> )
{
$line =~ s/\bLLLL\b/$lt_endpt/;
$line =~ s/\bRRRR\b/$rt_endpt/;

print OUTFILE $line;
}
close( OUTFILE );
close(FILE);

system("make -f Makefile_test_solver");
system("./test_solver.x > output.txt");

#open huge text file and split into different text files
open(FILE,"$cmdFile4") || die "cannot open file $cmdFile3!" ;
open(OUTFILE,"> $outFile4") || die "cannot open file!" ;
$counter = 0;
while($line = <FILE> )
{
    if($line =~ /BREAK/){
        close( OUTFILE );
        if($counter < 10){
            rename("output_temp.txt", "sol_00" . $counter . ".txt" ) || die ( "Error in renaming" );
            open(OUTFILE,"> $outFile4") || die "cannot open file!" ;
        } elsif (10<= $counter & $counter <= 99){
            rename("output_temp.txt", "sol_0" . $counter . ".txt" ) || die ( "Error in renaming" );
            open(OUTFILE,"> $outFile4") || die "cannot open file!" ;
        } else{
            rename("output_temp.txt", "sol_" . $counter . ".txt" ) || die ( "Error in renaming" );
            open(OUTFILE,"> $outFile4") || die "cannot open file!" ;
        }
        $counter = $counter + 1;
    } else{
    print OUTFILE $line;
    }
}
close( OUTFILE );
close(FILE);

system("mv sol*.txt ... MovieData/");

system("make -f Makefile_test_solver clean");

exit
