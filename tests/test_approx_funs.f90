program test_approx_funs
! =======================================================================
! This program is a unit test for the approx_funs.f90 module and the 
! function inside of it that builds the L2 approximation of a given
! functions. We also build the L2 coefficients.
! =======================================================================
    use type_defs
    use leg_funs
    use approx_funs 
    use InputControl
    use lgl
    use quad_1dmod
    use coeff

    implicit none

    integer, parameter :: leg_degree = 12, num_grdpts = 10
    real(dp), parameter ::  rt_endpt = 0.3_dp, lt_endpt = -0.2_dp
    real(dp), dimension(num_grdpts) :: grdpts 
    real(dp), dimension(0:leg_degree) :: leg_coeffs
    real(dp), dimension(num_grdpts) :: approx, true_solution
    integer n, j
    type(quad_1d) :: element1

    !create equispaced grid between the endpoints
    do n=1, num_grdpts
    	grdpts(n) = lt_endpt + (rt_endpt - lt_endpt)*n/num_grdpts
    end do

    !Find coefficients of L2 projection
    element1 = element(lt_endpt,rt_endpt,leg_degree)

    !Build approximation from coefficients
    approx = approx_eval(lt_endpt, rt_endpt,num_grdpts,grdpts,leg_degree,element1%a(:,element1%nvars))
   
    !Here we modify InputControl.f90 and copy that function here
    true_solution = SIN(grdpts)

    !output the error in the uniform (infinity) norm of approximation
    write(*,*) MAXVAL(ABS(true_solution - approx))
end program test_approx_funs
