module quad_1dmod
  !This the requested module. This module defines the datatype quad_1d as in the subtask statements
  use type_defs
  implicit none

  type quad_1d
     integer :: nvars, q
     real(kind=dp) :: lt_endpt, rt_endpt
     real(kind=dp), allocatable, dimension(:,:) :: a
  end type quad_1d

contains
  
  subroutine allocate_quad1d(el)
    type(quad_1d)::el
    allocate(el%a(0:el%q,el%nvars))
  end subroutine allocate_quad1d
  
  subroutine deallocate_quad1d(el)
    type(quad_1d)::el
    deallocate(el%a)
  end subroutine deallocate_quad1d

end module quad_1dmod
