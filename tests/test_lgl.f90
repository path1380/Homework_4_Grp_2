program test_lgl

  use type_defs
  use lgl
  implicit none

  integer, parameter :: leg_degree = 3
  real(dp), dimension(0:leg_degree) :: x, w

  call lglnodes(x, w, leg_degree)

  write(*,*) x
  write(*,*) w
end program test_lgl
