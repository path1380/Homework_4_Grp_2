program test_leg
! ================================================================
! Create 2D array which contains the value of the first 5
! Legendre polynomials between -1 and 1
! ================================================================
    use type_defs
    use leg_funs
    implicit none
    integer, parameter :: q = 5
    real(dp) :: x
    real(dp), dimension(0:q) :: leg_arr

    x = 0.5_dp
    leg_arr = leg(q, x)

    write(*,*) leg_arr

end program test_leg
