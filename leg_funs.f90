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
        !       http://calvino.polito.it/chqz/errata/pages91-92.pdf
        ! ========================================================
        real(dp), intent(in) :: x
        integer, intent(in) :: alpha, beta, k
        integer :: n, j, arg1, arg2, gamma1, gamma2
        real(dp) :: a1k, a2k, a3k
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
        do n=1, k-1
            ! Pre-calculate gamma values    TODO: Replace this with a fcn
            arg1 = 2*k+alpha+beta+3      ! Arguements for the gamma fcns
            arg2 = 2*k+alpha+beta

            gamma1 = arg1-1
            gamma2 = arg2-1
            do j = arg1-2, 1, -1      ! First gamma value
                gamma1 = gamma1 * j
            end do

            do j = arg2-2, 1, -1      ! Second gamma value
                gamma2 = gamma2 * j
            end do

            ! Coefficients for next Jacobi
            ! a1k = 2*(k+1)*(k+alpha+beta+1)*(2*k+alpha+beta)
            ! a2k = (2*k+alpha+beta+1)*(alpha**2-beta**2) + &
            !         x*gamma1 / gamma2
            ! a3k = 2*(k+alpha)*(k+beta)*(2*k+alpha+beta+2)
            a1k = 2*(n+1)*(n+alpha+beta+1)*(2*n+alpha+beta)
            a2k = (2*n+alpha+beta+1)*(alpha**2-beta**2) + &
                    x*gamma1 / gamma2
            a3k = 2*(n+alpha)*(n+beta)*(2*n+alpha+beta+2)

            ! Next Jacobi value
            jacobiP(n+1) = (a2k*jacobiP(n) - a3k*jacobiP(n-1)) / a1k
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
