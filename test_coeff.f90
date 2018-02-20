program test_coeff
! =======================================================================
! This program is a unit test for the coeff.f90 module and the 
! function inside of it that computes the coefficients of the L2 projection
! of the function onto the space of Legendre polynomials.
! =======================================================================
  use type_defs
  use InputControl
  use lgl
  use quad_1dmod
  use leg_funs
  use coeff
  use approx_funs
  implicit none

  integer :: leg_degree, num_grdpts, i
  real(dp) :: lt_endpt, rt_endpt, grdpts(11), coeffs(31), funvals(11)
  type(quad_1d) :: element1

	leg_degree = 30
	lt_endpt = -0.2_dp
	rt_endpt = 0.3_dp 
        num_grdpts = 11
        do i=1,11
           grdpts(i) = lt_endpt + (dble(i)*(rt_endpt-lt_endpt)/dble(num_grdpts))
        end do

	element1 = element(lt_endpt,rt_endpt,leg_degree)
        coeffs = element1%a(:,element1%nvars)
        funvals = approx_eval(lt_endpt, rt_endpt, num_grdpts, grdpts, leg_degree, coeffs)
	write(*,*) funvals

end program test_coeff
