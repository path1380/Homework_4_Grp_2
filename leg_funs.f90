module leg_funs
! ================================================================
! Contains functions for evaluating Legendre polynomials
! Ref: http://www2.me.rochester.edu/courses/ME201/webexamp/legendre.pdf
! Ref: https://people.sc.fsu.edu/~jburkardt/f_src/legendre_polynomial/legendre_polynomial.html
! Ref: https://stackoverflow.com/questions/3828094/function-returning-an-array-in-fortran
! ================================================================
use type_defs
implicit none

contains

    function leg(k,x)
        ! ========================================================
        ! Inputs: k (highest degree of polynomial), x (coordinate)
        ! Output: 1D Array of Leg. Polynomials degree 0-> k at
        !           location x
        ! ========================================================
        real(dp), intent(in) :: x
        integer, intent(in) :: k
        integer :: n
        real(dp), dimension(0:k) :: leg

        IF(k < 0) THEN
            write(*,*) "Invalid value for degree of polynomial!"
            GO TO 777
        ELSE IF (k ==0 ) THEN
            leg(0) = 1
            GO TO 777
        ! TODO: Should there be a k == 1 case here?
        END IF

        leg(0) = 1
        leg(1) = x
        do n = 1, k-1
            ! Recursive relation for Legendre polynomials of degree > 1 (Wiki)
            leg(n+1) = (dble((2*n+1))*x*leg(n) - dble(n)*leg(n-1))/dble((n+1))
        end do
        777 CONTINUE
    end function leg



    function jacobiP(k,x,alpha,beta)
        ! ========================================================
        ! Inputs:  k (highest degree of polynomial)
        !          x (coordinate), alpha & beta (parameters, assume integers)
        ! Output: 1D Array of 1st Derivative of Leg. Polynomials degree 0-> k
        !           at location x
        ! Refs: JacobiP.m
        !       https://en.wikipedia.org/wiki/Jacobi_polynomials
        ! ========================================================
        real(dp), intent(in) :: x
        integer, intent(in) :: alpha, beta, k
        integer :: n
        real(dp) :: a1n, a2n, a3n
        real(dp), dimension(0:k) :: jacobiP

        ! Special cases for low polynomial degrees
        if(k<0) then
            write(*,*) "Invalid value for degree of polynomial!"
            go to 777
        else if (k==0) then
            jacobiP(0) = 1
            go to 777
        else if (k==1) then
            jacobiP(0) = 1
            jacobiP(1) = 0.5*((alpha-beta) + (alpha+beta+2)*x)
            go to 777
        end if

        ! Use recursion for higher polynomial degrees
        jacobiP(0) = 1
        jacobiP(1) = 0.5*((alpha-beta) + (alpha+beta+2)*x)
        do n=2, k

            ! Coefficients for next Jacobi
            a1n = 2*n*(n+alpha+beta)*(2*n+alpha+beta-2)
            a2n = (2*n+alpha+beta-1)*&
                    ((2*n+alpha+beta)*(2*n+alpha+beta-2)*x + alpha**2 - beta**2)
            a3n = 2*(n+alpha-1)*(n+beta-1)*(2*n+alpha+beta)

            ! Next Jacobi value
            jacobiP(n) = (a2n*jacobiP(n-1) - a3n*jacobiP(n-2)) / a1n
        end do

        777 continue
    end function jacobiP

end module

! module helper_funs
! ! ================================================================
! ! Contains functions to help evaluate Legendre polynomials
! ! ================================================================
! use type_defs
! implicit none
!
! contains
!
!
! end module
!
! ! ---------------------------------------------------------------
