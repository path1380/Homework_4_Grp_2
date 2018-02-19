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
  implicit none

  integer :: leg_degree
  real(dp) :: lt_endpt, rt_endpt
  type(quad_1d) :: element1

	leg_degree = 4
	lt_endpt = -0.2_dp
	rt_endpt = 0.3_dp 

	element1 = element(lt_endpt,rt_endpt,leg_degree)
	write(*,*) element1%a(:,element1%nvars)

end program test_coeff
