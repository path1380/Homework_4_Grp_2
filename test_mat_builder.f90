program test_mat_builder
  use type_defs
  use mat_builder

  integer, parameter :: num_nodes = 6, leg_degree = 3, isConst = 0
  real(dp), parameter :: lt_endpt = -1.0_dp, rt_endpt = 1.0_dp
  real(dp) :: A(0:leg_degree, 0:leg_degree)

  A = diff_mat(num_nodes, leg_degree, lt_endpt, rt_endpt, isConst)

  write(*,*) A(:,:)
end program test_mat_builder
