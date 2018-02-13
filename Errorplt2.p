$cmdFile="./InputControl.Template.f90";
$outFile="./InputControl.f90";
$cmdFile2="./main.Template.f90";
$outFile2="./main.f90";

$fun="SIN(grd_pts)";
@array_num_grdpts=("6","7","8","9","10","11");
@array_num_intervals=("5","6","7","8","9","10");
@array_degree=("2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20");
$num_subsamples="15";
$endpts="(/-4*ATAN(1.d0),4*ATAN(1.d0)/)";
for( $m=0; $m<6; $m=$m+1 ){
   for($j=0; $j<19; $j=$j+1){
   # Open the Template file and the output file.
    open(FILE,"$cmdFile") || die "cannot open file $cmdFile!" ;
    open(OUTFILE,"> $outFile") || die "cannot open file!" ;
   # Setup the outfile based on the template
    # read one line at a time.
    while( $line = <FILE> )
    {
#Replace the strings by using substitution
    $line =~ s/\bFFFF\b/$fun/;
    $line =~ s/\bIIII\b/$array_num_intervals[$m]/;
    $line =~ s/\bDDDD\b/$array_degree[$j]/;
    $line =~ s/\bNNNN\b/$array_num_grdpts[$m]/;
    $line =~ s/\bPPPP\b/$endpts/;

    print OUTFILE $line;
    }
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
    $line =~ s/\bNNNN\b/$num_subsamples/;

    print OUTFILE $line;
        # You can always print to secreen to see what is happening.
        # print $line;
    }
    # Close the files
    close( OUTFILE );
    close( FILE );

   system("make -f Makefile_main");
    # #system("./a.out > tmp.txt");

$outputfile="output.txt";
open(FILE,$outputfile) || die "cannot open file" ;
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
rename("output.txt", "output" . $m . ".txt") || die ( "Error in renaming" );
}
exit
