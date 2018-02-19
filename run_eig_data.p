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
$cmdFile="templates/eig_data.f90.Template";
$outFile="src/eig_data.f90";

# Remove data from previous runs
system("rm data/eig_*.txt");

#Find max eigenvalue for each value of q up to $qmax
$qmax = 8; #maximum legendre degree to use
for ($b = 0; $b <=1; $b = $b+1){

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
	    	$line =~ s/\bBBBB\b/$b/;
	    	print OUTFILE $line;
	    }

	    # Close the files
	    close( OUTFILE );
	    close( FILE );
		system("make -f Makefile_eig");
		if($b == 0){
	 		system("bin/eig_data.x >> data/eig_data.txt");
	 	} else {
	 		system("bin/eig_data.x >> data/eig.txt");
			rename("data/eig.txt", "data/eig_" . $q . ".txt" ) || die ( "Error in renaming" );
	 	}

	}
}

system("matlab \"$@\" -nosplash -nodisplay < bin/eig_data_plot.m");

exit
