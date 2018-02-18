#!/usr/apps/bin/perl
#
# perl program to try the approximation of various functions
# in an L2 sense.
# run with : perl data_collector.p
#
#
# Here is the generic file
$cmdFile="./eig_data.f90.Template";
$outFile="./eig_data.f90";

$qmax = 30; #maximum legendre degree to use
system("rm eig_data.txt");

#Find max eigenvalue for each value of q up to $qmax
for( $q = 1; $q <= $qmax; $q = $q+1){
    # Open the Template file and the output file.
    open(FILE,"$cmdFile") || die "cannot open file $cmdFile!" ;
    open(OUTFILE,"> $outFile") || die "cannot open file!" ;

    # Setup the outfile based on the template
    # read one line at a time.
    while( $line = <FILE> )
    {
   		# Replace the the strings by using substitution
    	$line =~ s/\bDDDD\b/$q/;
    	print OUTFILE $line;
    }

    # Close the files
    close( OUTFILE );
    close( FILE );
 	system("gfortran -c type_defs.f90 quad_1dmod.f90 InputControl.f90 lgl.f90 leg_funs.f90 approx_funs.f90 mat_builder.f90");
 	system("gfortran eig_data.f90 type_defs.o quad_1dmod.o InputControl.o lgl.o leg_funs.o approx_funs.o mat_builder.o -llapack");
 	system("./a.out >> eig_data.txt");

}
system("matlab \"$@\" -nosplash -nodisplay < eig_data_plot.m");

exit
