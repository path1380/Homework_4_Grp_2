#!/usr/apps/bin/perl
#
# perl program to calculate eigenvalues of the 
# differential operator from Homework 4. Modify
# $qmax to set the largest degree Legendre poly
# used.
# run with : perl run_eig_data
#
#
# Here is the generic file
$cmdFile="./space_der.f90.Template";
$outFile="./space_der.f90";
$cmdFile2="./InputControl.Template2.f90";
$outFile2="./InputControl.f90";

$qmax = 80; #maximum legendre degree to use
$num_grdpts = 100;
$lt_endpt = "-1.0_dp*ACOS(-1.0_dp)";
$rt_endpt = "ACOS(-1.0_dp)";
@array_f = ("exp( ((grd_pts-2.0_dp)**2.0_dp))", "sin(grd_pts)", "ABS(grd_pts)");

$var_coeff = "2.0_dp/(2.0_dp + SIN(grd_pts))";
$func = "EXP(SIN(grd_pts))";
@array_num_grdpts = ("3", "5", "7");
@array_num_intervals = ("2", "4", "6");
@array_degrees = ("(/12, 12/)", "(/12,12,12,12/)", "(/12, 12, 12, 12, 12, 12/)");
@array_grdpts = ("(/0.0_dp, 0.3_dp, 1.0_dp/)", "(/0.0_dp, 0.75_dp, 1.5_dp, 2.25_dp, 3.0_dp/)", "(/-3.0_dp, -2.0_dp, -1.0_dp, 0.0_dp, 1.0_dp, 2.0_dp, 3.0_dp/)");

system("rm space_der.txt");


for( $q = 1; $q <= $qmax; $q = $q+1){
	$m = 1;
	# Open the Template file and the output file.
	open(FILE,"$cmdFile") || die "cannot open file $cmdFile!" ;
	open(OUTFILE,"> $outFile") || die "cannot open file!" ;

	# Setup the outfile based on the template
	# read one line at a time.
	while( $line = <FILE> )
	{
		# Replace the the strings by using substitution
		$line =~ s/\bDDDD\b/$q/;
		$line =~ s/\bLLLL\b/$lt_endpt/;
		$line =~ s/\bNNNN\b/$num_grdpts/;
		$line =~ s/\bRRRR\b/$rt_endpt/;
		print OUTFILE $line;
	}

	# Close the files
	close( OUTFILE );
	close( FILE );

	# Open the Template file and the output file.
	open(FILE,"$cmdFile2") || die "cannot open file $cmdFile!" ;
	open(OUTFILE,"> $outFile2") || die "cannot open file!" ;

	# Setup the outfile based on the template
	# read one line at a time.
	while( $line = <FILE> )
	{
		# Replace the the strings by using substitution
    $line =~ s/\bFFFF\b/$func/;
    $line =~ s/\bIIII\b/$array_num_intervals[$m]/;
    $line =~ s/\bDDDD\b/$array_degrees[$m]/;
    $line =~ s/\bNNNN\b/$array_num_grdpts[$m]/;
    $line =~ s/\bVVVV\b/$var_coeff/;
    $line =~ s/\bLLLL\b/$lt_endpt/;
    $line =~ s/\bRRRR\b/$rt_endpt/;
    $line =~ s/\bPPPP\b/$array_grdpts[$m]/;

		print OUTFILE $line;
	}

	# Close the files
	close( OUTFILE );
	close( FILE );


	system("gfortran -c type_defs.f90 quad_1dmod.f90 InputControl.f90 lgl.f90 leg_funs.f90 approx_funs.f90 mat_builder.f90 diff_coeff.f90 coeff.f90");
	system("gfortran space_der.f90 type_defs.o quad_1dmod.o InputControl.o lgl.o leg_funs.o approx_funs.o mat_builder.o diff_coeff.o coeff.o");
	system("./a.out >> space_der.txt");
}
system("matlab \"$@\" -nosplash -nodisplay < space_der_plot.m");
#clean up
system("rm *.mod *.o a.out");
system("rm space_der.txt");
exit
