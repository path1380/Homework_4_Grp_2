!------------------------------------------------------------------------------------------------------------------------------------------------
!This is a template for the module InputControl. Here we use a perl script to modify specific strings to input different sets of
!nodes, Legendre degrees, or functions we wish to approximate. 
!------------------------------------------------------------------------------------------------------------------------------------------------
module InputControl
  use type_defs
  use quad_1dmod
  implicit none

contains

  function function_eval(num_pts, grd_pts)
    integer, intent(in) :: num_pts
    real(dp), intent(in) :: grd_pts(0:num_pts-1)
    real(dp) :: function_eval(0:num_pts-1)

    !Here replace the string sin(grd_pts) with the desired function
    !via a perl script
    function_eval = sin(grd_pts)
  end function function_eval


  function var_coeffs(num_pts, grd_pts)
    ! ========================================================
    ! This function contains the function defining the variable
    ! coefficient in the transport equation.
    ! Inputs:  
    !         - num_pts     : number of evaluation points
    !         - grd_pts     : points we wish to evaluate the
    !                         variable coefficient
    ! Output: 1D Array of function evaluations of the 
    !         variable coefficient.
    ! ========================================================
    integer, intent(in) :: num_pts
    real(dp), intent(in) :: grd_pts(0:num_pts-1)
    real(dp) :: var_coeffs(0:num_pts-1) 
    
    !Here replace the string grd_pts with the desired function
    !via a perl script

    var_coeffs = grd_pts   
  end function var_coeffs

  subroutine legendre_degrees(degree_vec)
    integer, parameter :: num_intervals = 4
    integer, intent(out) :: degree_vec(num_intervals)

    degree_vec(1:num_intervals) = (/12,12,12,12/)
  end subroutine legendre_degrees

  subroutine domain(grd_pts)
    integer, parameter :: num_grdpts = 5
    real(dp), intent(out) :: grd_pts(num_grdpts)

    grd_pts(1:num_grdpts) = (/0.0_dp, 4.68842519045324_dp, 5.82080955031203_dp, 3.52375392981555_dp, 3.0_dp/)
  end subroutine domain

  subroutine domain_equispaced(grd_pts)
    integer, parameter :: num_grdpts = 5
    real(dp), parameter :: lt_endpt = -1.0_dp, rt_endpt = 1.0_dp
    real(dp), intent(out) :: grd_pts(num_grdpts)
    integer :: i

    grd_pts(1) = lt_endpt

    do i=2,num_grdpts
      grd_pts(i) = lt_endpt + (i-1)*(rt_endpt - lt_endpt)/(num_grdpts - 1)
    end do

  end subroutine domain_equispaced

  subroutine delete_quad(num_quads, quad_array)
    integer, intent(in) :: num_quads
    type(quad_1d) :: quad_array(num_quads)
    integer :: i 

    do i=1,num_quads
      call deallocate_quad1d(quad_array(i))
    end do
  end subroutine delete_quad
  
end module InputControl
