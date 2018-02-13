#!/usr/apps/bin/perl
#
# perl program to try the approximation of various functions
# in an L2 sense.
# run with : perl data_collector.p
#
#
# Here is the generic file
$cmdFile="./InputControl.Template2.f90";
$outFile="./InputControl.f90";
$cmdFile2="./main.Template2.f90";
$outFile2="./main.f90";
$matFile="maxErrorPlot.Template.m";
$outFile3="maxErrorPlot.m";
$matFile2="squareErrorPlot.Template.m";
$outFile4="squareErrorPlot.m";

$qmax = 20; #maximum legendre degree to use
$nmax = 2048; #maximum number of intervals
$sample_rate = 20; #number of samples taken in each interval after finding coefficients 
$dynamic_grdpts = "0.0_dp";

# Functions to test
$num_funx = 4;
@array_f = ("exp( ((grd_pts-2.0_dp)**2.0_dp))", "ABS(grd_pts)", "SIN(grd_pts)", "SIGN(1.0_dp,grd_pts)");
@array_lt_endpts = ("0.0_dp","-3.0_dp","-3.1415926535897932_dp", "-2.0_dp");
@array_rt_endpts = ("4.0_dp","2.0_dp","3.1415926535897932_dp", "2.0_dp");

for( $m = 0; $m < $num_funx; $m = $m+1){
    #Increase the maximal Legendre degree each run
    for( $q = 1; $q <= $qmax; $q = $q+1){
        #increase the number of intervals by a power of 2 each run
        for($n = 2; $n <= $nmax; $n = 2*$n){

            #manually build the input degree and grid point vectors
            $num_grdpts = $n +1;
            # $degrees = "(/" . $q . ",";
            # $grd_pts = "(/" . $array_lt_endpts[$m] . ",";

            # $tmp = 0;
            # $spacing = ($array_rt_endpts_num[$m] - $array_lt_endpts_num[$m])/$n;
            # #now we need to build the endpoints
            # for($i = 1; $i< $n -1; $i = $i +1 ){
            #     $tmp = $array_lt_endpts_num[$m] + $i*$spacing;

            #     #check if we have an integer
            #     if ($tmp =~ m/^[d]*$/ ) {
            #         $grd_pts = $grd_pts . $tmp . ".0_dp,";
            #     } else {
            #         $grd_pts = $grd_pts . $tmp . "_dp,";             
            #     }
            #     $degrees = $degrees . $q . ",";
            # }

            # #build last values in array to avoid extraneous commas
            # $tmp = $array_lt_endpts_num[$m] + ($n -1)*$spacing;
            # #check if we have an integer
            # if ($tmp =~ m/^[d]*$/ ) {
            #     $grd_pts = $grd_pts . $tmp . ".0_dp,";
            # } else {
            #     $grd_pts = $grd_pts . $tmp . "_dp,";             
            # }
            # $degrees = $degrees . $q . "/)";
            # #$grd_pts = $grd_pts . $tmp . "_dp," . $array_rt_endpts[$m] . "/)";
            # $grd_pts = $grd_pts . $array_rt_endpts[$m] . "/)";

            # Open the Template file and the output file.
            open(FILE,"$cmdFile") || die "cannot open file $cmdFile!" ;
            open(OUTFILE,"> $outFile") || die "cannot open file!" ;

            # Setup the outfile based on the template
            # read one line at a time.
            while( $line = <FILE> )
            {
            # Replace the the strings by using substitution
            $line =~ s/\bFFFF\b/$array_f[$m]/;
            $line =~ s/\bIIII\b/$n/;
            $line =~ s/\bDDDD\b/$q/;
            $line =~ s/\bNNNN\b/$num_grdpts/;
            $line =~ s/\bPPPP\b/$dynamic_grdpts/;
            $line =~ s/\bLLLL\b/$array_lt_endpts[$m]/;
            $line =~ s/\bRRRR\b/$array_rt_endpts[$m]/;

            print OUTFILE $line;
            }

            # Close the files
            close( OUTFILE );
            close( FILE );

            #open main file and edit
            open(FILE,"$cmdFile2") || die "cannot open file $cmdFile!" ;
            open(OUTFILE,"> $outFile2") || die "cannot open file!" ;

            # Setup the outfile based on the template
            # read one line at a time.
            while( $line = <FILE> )
            {
            # Replace the the strings by using substitution
            $line =~ s/\bGGGG\b/$num_grdpts/;
            $line =~ s/\bNNNN\b/$sample_rate/;

            print OUTFILE $line;
            }
            # Close the files
            close( OUTFILE );
            close( FILE );

            # Run the shell commands to compile and run the program
            system("make -f Makefile_main");

            #clean up between runs
            system("make -f Makefile_main clean");
        }
        #create an output file for each run
        rename("output.txt", "output" . "_" . $m . "_" . $q . ".txt") || die ( "Error in renaming" );
    }
    #open matlab file to create plots
    open(FILE,"$matFile") || die "cannot open file $cmdFile!" ;
    open(OUTFILE,"> $outFile3") || die "cannot open file!" ;

    $outFileName = "maxError" . "_" . $m;
    # Setup the outfile based on the template
    # read one line at a time.
    while( $line = <FILE> )
    {
    # Replace the the strings by using substitution
    $line =~ s/\bTTTT\b/$m/;
    $line =~ s/\bYYYY\b/$outFileName/;
    $line =~ s/\bWWWW\b/$outFileName/;
    $line =~ s/\bVVVV\b/$nmax/;


    print OUTFILE $line;
    }
    # Close the files
    close( OUTFILE );
    close( FILE );

    #now for the square errors
    open(FILE,"$matFile2") || die "cannot open file $cmdFile!" ;
    open(OUTFILE,"> $outFile4") || die "cannot open file!" ;

    $outFileName = "squareError" . "_" . $m;
    # Setup the outfile based on the template
    # read one line at a time.
    while( $line = <FILE> )
    {
    # Replace the the strings by using substitution
    $line =~ s/\bTTTT\b/$m/;
    $line =~ s/\bYYYY\b/$outFileName/;
    $line =~ s/\bWWWW\b/$outFileName/;
    $line =~ s/\bVVVV\b/$nmax/;

    print OUTFILE $line;
    }
    # Close the files
    close( OUTFILE );
    close( FILE );
    system("matlab \"$@\" -nosplash -nodisplay < maxErrorPlot.m");
    system("matlab \"$@\" -nosplash -nodisplay < squareErrorPlot.m");
}
exit
