$cmdFile="./InputControl.Template2.f90";
$outFile="./InputControl.f90";
$cmdFile2="./test_solver.Template.f90";
$outFile2="./test_solver.f90";
$cmdFile3="./solver.Template.f90";
$outFile3="./solver.f90";

# $lt_endpt = "-1.d0";
# $rt_endpt = "1.d0";
$lt_endpt = "-1.0_dp*ACOS(-1.0_dp)";
$rt_endpt = "ACOS(-1.0_dp)";
$var_coeff = "1.0_dp";
$num_intervals = "1";
#$degree = "15";
#$delta_t="0.1";
$end_time="3";
$isConst = "0";  #modify to 1 if the problem has variable coefficient

@array_qvec = ("10","15","20");
@array_step_vec = ("0.00002","0.0002","0.002");
#$IC = "EXP(-((grd_pts/0.3)**2))";
$IC = "COS(grd_pts)";
#$IC = "1.0_dp";

for( $q = 0; $q < 3; $q = $q + 1){
    $degree = $array_qvec[$q];
    for( $t = 0; $t < 3; $t = $t + 1){
        $delta_t = $array_step_vec[$t];
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
        rename("output.txt", "l2_err_" . $q . "_" . $t . ".txt" ) || die ( "Error in renaming" );

        system("make -f Makefile_test_solver clean");
    }
}
exit
