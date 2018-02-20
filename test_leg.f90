program test_leg
! ================================================================
! Create 2D array which contains the value of the first 5
! Legendre polynomials between -1 and 1
! ================================================================
    use type_defs
    use leg_funs
    implicit none

    integer, parameter :: q = 4, alpha = 0, beta = 0, n = 1000
    real(dp) :: x(0:n-1), stepsize, poly(0:q), polyder(0:q), errvec(0:n), trueder(0:q)
    integer :: i
    real(dp), dimension(0:q) :: leg_arr

    trueder(0) = 0.0_dp
    !x = 0.5_dp
    stepsize = 2.0_dp/dble(n-1)

    do i = 0, n-1
    	x(i) = -1.0_dp + stepsize*i
    end do
  	
  	!Call routine to output values of derivatives of Legendre poly's
  	!and compare with true derivative values.
    do i =0, n-1
   		poly = jacobiP(q,x(i),alpha+1,beta+1)
   		polyder = gradjacobiP(q,x(i),alpha,beta,poly)

   		trueder(1) = 1
   		trueder(2) = 3.0_dp*x(i)
   		trueder(3) = 0.5_dp*(15.0_dp*(x(i)**2.0_dp) - 3.0_dp)
   		trueder(4) = 17.5_dp*x(i)**3.0_dp - 7.5_dp*x(i)

   		errvec(i) = MAXVAL(ABS(trueder - polyder))
    end do

    write(*,*) MAXVAL(errvec)


end program test_leg
