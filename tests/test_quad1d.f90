program test_quad1d
! =======================================================================
! This program is a unit test for the quad1d_mod.f90 module. We test
! the proper allocation and deallocation of a quad_1d type.
! =======================================================================
  use type_defs
  use quad_1dmod
  implicit none

  type(quad_1d)::element1(10)
  integer::i

  do i=1,10
    element1(i)%q=5
    element1(i)%nvars=1
    element1(i)%lt_endpt = -1
    element1(i)%rt_endpt = 1
    call allocate_quad1d(element1(i))
  end do

  do i=1,10
    call deallocate_quad1d(element1(i))
  end do

  write(*,*) "Quad_1d array successfully allocated and deallocated!"

end program test_quad1d
