$cmdFile="./InputControl.Template2.f90";
$outFile="./InputControl.f90";
$cmdFile2="./test_solver_multiple.Template.f90";
$outFile2="./test_solver_multiple.f90";
$cmdFile3="./solver.Template.f90";
$outFile3="./solver.f90";

#Use in InputControl
$lt_endpt = "-1.0_dp*ACOS(-1.0_dp)";
$rt_endpt = "ACOS(-1.0_dp)";
$var_coeff = "1.0_dp";
$num_elements = "1";
$end_time="3";
$isConst = "0";  #modify to 1 if the problem has variable coefficient
$leg_degree = "5";
$delta_t = "0.002";

@array_num_elements = ("2","3","4","5","6","7","8","9","10","11","12","13","14","15");
@array_beta = ("0.0_dp","0.5_dp","1.0_dp");
$IC = "SIN(grd_pts)";
for($p = 0; $p < 3; $p = $p + 1){
for( $q = 0; $q < 14; $q = $q + 1){
	open(FILE,"$cmdFile") || die "cannot open file $cmdFile!" ;
      
       open(OUTFILE,"> $outFile") || die "cannot open file!" ;
       while( $line = <FILE> )
        {
        #Replace the strings by using substitution
        $line =~ s/\bIIII\b/$array_num_elements[$q]/;
        $line =~ s/\bDDDD\b/$leg_degree/;
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
        $line =~ s/\bDDDD\b/$leg_degree/;
        $line =~ s/\bLLLL\b/$lt_endpt/;
        $line =~ s/\bRRRR\b/$rt_endpt/;
        $line =~ s/\bIIII\b/$isConst/;
        $line =~ s/\bBETA\b/$array_beta[$p]/;
        $line =~ s/\bNUMEL\b/$array_num_elements[$q]/;
        $line =~ s/\bETET\b/$end_time/;

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
        $line =~ s/\bNUMEL\b/$array_num_elements[$q]/;

        print OUTFILE $line;
        }
        close( OUTFILE );
        close(FILE);
        system("make -f Makefile_test_solver");
        system("./test_solver_multiple.x > output.txt");
        $beta = $p / 2;
        $temp = $q + 2;
        if($temp <=9){
        rename("output.txt", "output_beta=" . $beta . "_num_elts=0" . $temp . ".txt" ) || die ( "Error in renaming" );
        } else{
    
        rename("output.txt", "output_beta=" . $beta . "_num_elts=" . $temp . ".txt" ) || die ( "Error in renaming" );
}

        system("make -f Makefile_test_solver clean");


	}
}
        system("matlab \"$@\" -nosplash -nodisplay < finalPlot.m");
        system("rm output_beta*");
