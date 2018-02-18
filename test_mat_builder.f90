program test_mat_builder
  use type_defs
  use quad_1dmod
  use mat_builder

  integer, parameter :: num_nodes = 6, leg_degree = 2, isConst = 0
  real(dp), parameter :: lt_endpt = -1.0_dp, rt_endpt = 1.0_dp
  type(quad_1d) :: u_quad
  real(dp) :: A(0:leg_degree, 0:leg_degree)

  !define a quad with the function u(x,t) = 1
  u_quad%nvars = 1
  u_quad%lt_endpt = lt_endpt
  u_quad%rt_endpt = rt_endpt
  u_quad%q = leg_degree

  call allocate_quad1d(u_quad)
  u_quad%a(:,1) = 0.0_dp
  u_quad%a(0,1) = 1.0_dp

  A = diff_mat(num_nodes, leg_degree, u_quad, isConst)

  call deallocate_quad1d(u_quad)

  write(*,*) A(:,:)
end program test_mat_builder
