program test_diff_coeff
  use type_defs
  use quad_1dmod
  use mat_builder
  use diff_coeff

  integer, parameter :: num_nodes = 10, leg_degree = 3
  real(dp), parameter :: lt_endpt = -1.0_dp, rt_endpt = 1.0_dp
  type(quad_1d) :: u_quad
  real(dp), dimension(0:leg_degree) :: coeffs

  !define a quad with the function u(x,t) = 1
  u_quad%nvars = 1
  u_quad%lt_endpt = lt_endpt
  u_quad%rt_endpt = rt_endpt
  u_quad%q = leg_degree

  call allocate_quad1d(u_quad)

  !set up so that u is simply the function x
  u_quad%a(:,1) = 0.0_dp
  u_quad%a(3,1) = 1.0_dp

  !setting the trace equal to 0 reduces down to constant coefficients
  u_quad%lt_trace = 0.0_dp
  u_quad%rt_trace = 0.0_dp

  coeffs = derivative_coefficients(num_nodes, leg_degree, u_quad)
  coeffs = -1.0_dp*coeffs(:)
  call deallocate_quad1d(u_quad)

  write(*,*) coeffs

end program test_diff_coeff
