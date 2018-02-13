#!/usr/apps/bin/perl
#
# perl program to try the approximation of various functions
# in an L2 sense.
# run with : perl legendre.p
#
#
# Here is the generic file
$cmdFile="./InputControl.Template3.f90";
$outFile="./InputControl.f90";
$cmdFile2="./main.Template3.f90";
$outFile2="./main.f90";

# Functions to test

@array_f = ("exp( ((grd_pts-2.0_dp)**2.0_dp))", "sin(grd_pts)", "ABS(grd_pts)");
@array_num_grdpts = ("3", "5", "7");
@array_num_intervals = ("2", "4", "6");
@array_degrees = ("(/12, 12/)", "(/12,12,12,12/)", "(/12, 12, 12, 12, 12, 12/)");
@array_grdpts = ("(/0.0_dp, 0.3_dp, 1.0_dp/)", "(/0.0_dp, 0.75_dp, 1.5_dp, 2.25_dp, 3.0_dp/)", "(/-3.0_dp, -2.0_dp, -1.0_dp, 0.0_dp, 1.0_dp, 2.0_dp, 3.0_dp/)");
$custom_grd_bool = 0;      # Boolean; 1 = use custom grid points, 0 = don't
@array_eqi_bnds = (["0.0", "4.0"], ["0.0", "3.0"], ["-3.0", "3.0"]);
$eqi_grd_bool = 1;   # 1 = use eqidist grid points if custom points aren't used
$noisy_eqi_grid_bool = 1;  # 1 = add noise to equidist grid points
#$noise_range = 0.05;       # Noise will be at most $noise_range * interval
$noise_range = 0;       # Noise will be at most $noise_range * interval
@array_num_subsamples = ("15", "15", "15");

for( $r = 0; $r < 30; $r = $r+1){
    $noise_range = $noise_range + $r*0.01;
    $m = 1;
    # Open the Template file and the output file.
    open(FILE,"$cmdFile") || die "cannot open file $cmdFile!" ;
    open(OUTFILE,"> $outFile") || die "cannot open file!" ;

    # Setup the outfile based on the template
    # read one line at a time.
    while( $line = <FILE> )
    {
    # Replace the the stings by using substitution
    # s
    $line =~ s/\bFFFF\b/$array_f[$m]/;
    $line =~ s/\bIIII\b/$array_num_intervals[$m]/;
    $line =~ s/\bDDDD\b/$array_degrees[$m]/;
    $line =~ s/\bNNNN\b/$array_num_grdpts[$m]/;
    if ($custom_grd_bool) {
    $line =~ s/\bPPPP\b/$array_grdpts[$m]/;
    } elsif ($eqi_grd_bool) {
        # Array characteristics
        $lower_bnd = $array_eqi_bnds[$m][0];
        $upper_bnd = $array_eqi_bnds[$m][1];
        $num_grdpts = $array_num_grdpts[$m];
        $step_size = ($upper_bnd - $lower_bnd)/($num_grdpts-1);

        # Create array of equispaced grid points with fortran formatting
        @array_eqi_grdpts = ($lower_bnd . "_dp");
        for ($j=1; $j<$num_grdpts-1; $j=$j+1) {
            if ($noisy_eqi_grid_bool){
                $noise = rand() * $noise_range;
                push @array_eqi_grdpts, $lower_bnd + $j*$step_size+$noise . "_dp";
            } else {
            push @array_eqi_grdpts, $lower_bnd + $j*$step_size . "_dp";
            }
        }
        push @array_eqi_grdpts, $upper_bnd . "_dp";

        # Flatten array into a string in fortran format
        $str_eqi_grdpts = "(/" . join(", ", @array_eqi_grdpts) . "/)";
        $line =~ s/\bPPPP\b/$str_eqi_grdpts/;
    }


    print OUTFILE $line;
        # You can always print to secreen to see what is happening.
        # print $line;
    }
    # Close the files
    close( OUTFILE );
    close( FILE );

    open(FILE,"$cmdFile2") || die "cannot open file $cmdFile!" ;
    open(OUTFILE,"> $outFile2") || die "cannot open file!" ;

    # Setup the outfile based on the template
    # read one line at a time.
    while( $line = <FILE> )
    {
    # Replace the the stings by using substitution
    # s
    $line =~ s/\bGGGG\b/$array_num_grdpts[$m]/;
    $line =~ s/\bNNNN\b/$array_num_subsamples[$m]/;

    print OUTFILE $line;
        # You can always print to secreen to see what is happening.
        # print $line;
    }
    # Close the files
    close( OUTFILE );
    close( FILE );

    # # Run the shell commands to compile and run the program
    system("make -f Makefile_main");
    # #system("./a.out > tmp.txt");

    open(FILE,"output.txt") || die "cannot open file" ;
    # # Setup the outfile based on the template
    # # read one line at a time.
     while( $line = <FILE> )
     {
    # # Replace the the stings by using substitution
    # # s
     $line =~ s/\s+/ , /g;
     $line =~ s/ , $/ /;
     $line =~ s/^ , / /;
     $line =  $line . "\n";
     print $line;
    # }
     close( FILE );
     system("make -f Makefile_main clean");

}
}
rename("output.txt", "output_rand.txt") || die ( "Error in renaming" );
system("matlab \"$@\" -nosplash -nodisplay < randPlot.m");
system("rm output_rand.txt");
exit
