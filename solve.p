$cmdFile="./InputControl.Template2.f90";
$outFile="./InputControl.f90";
$cmdFile2="./test_solver.Template.f90";
$outFile2="./test_solver.f90";
$cmdFile3="./solver.Template.f90";
$outFile3="./solver.f90";

$lt_endpt = "-1.d0";
$rt_endpt = "1.d0";
$var_coeff = "1";
$num_intervals = "1";
$degree = "5";
$delta_t="0.0002";
$end_time="0.1";

$IC = "EXP(-((grd_pts/0.3)**2))";
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
system("make -f Makefile_test_solver clean");
exit
