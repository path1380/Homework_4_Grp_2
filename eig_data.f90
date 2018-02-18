program eig_data
  use type_defs
  use quad_1dmod
  use mat_builder
  implicit none

  integer, parameter :: leg_degree = DDDD, isConst = 2
  real(dp), parameter :: lt_endpt = -1.0_dp, rt_endpt = 1.0_dp
  type(quad_1d) :: u_quad
  integer, parameter :: num_nodes = 2*leg_degree + 1, n = leg_degree + 1
  integer :: LWORK, INFO, i, j
  real(dp) :: A(n,n), eigreal(n), eigim(n), WORK(3*n), temp(n)
  CHARACTER(1) :: lefteig = 'N', righteig = 'N'

  LWORK = 3*n

  !define a quad with the function u(x,t) = 1
  u_quad%nvars = 1
  u_quad%lt_endpt = lt_endpt
  u_quad%rt_endpt = rt_endpt
  u_quad%q = leg_degree

  call allocate_quad1d(u_quad)
  u_quad%a(:,1) = 0.0_dp
  u_quad%a(0,1) = 1.0_dp

  A = diff_mat(num_nodes, leg_degree, u_quad, isConst)
  CALL DGEEV(lefteig,righteig, n, A, n, eigreal, eigim, temp, n, temp,n, WORK, LWORK, INFO)
  write(*,*) eigreal
  write(*,*) eigim
  call deallocate_quad1d(u_quad)

end program eig_data
