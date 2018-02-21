!=====================================================================================================================
!
!This module contains subroutines which solve the equation over a single element and over the whole domain with
  !appropriate boundary conditions.

  !Inputs :
  !element - quantity of type quad_1d which contains all domain specifications.
  !end_time - the end time of the simulation.
  !
!Initial time = 0
!
!=====================================================================================================================



module solver
  use type_defs
  use quad_1dmod
  use InputControl
  use lgl
  use leg_funs
  use approx_funs
  use mat_builder
  use diff_coeff
  use Runge_Kutta_4
  use coeff
  implicit none
contains
  subroutine solve_single_element(U, leg_degree, end_time, delta_t, num_time_steps, isConst, u_quad_init)
    real(dp), intent(in) :: end_time, delta_t
    type(quad_1d), intent(in) :: u_quad_init
    type(quad_1d) :: u_quad
    integer, intent(in) :: leg_degree, isConst
    integer, intent(in) :: num_time_steps
    real(dp), dimension(0:leg_degree,0:num_time_steps), intent(out) :: U
    real(dp), dimension(0:leg_degree) :: nodes,weights
    integer :: i,j,num_nodes
    real(dp), dimension(0:leg_degree,0:leg_degree) :: A
    real(dp) :: u_endpt_vals(2), endpt_vals(2)
    real(dp) :: lt_endpt, rt_endpt
    num_nodes=4*leg_degree+1
    
    

    U(:,0) = u_quad_init%a
    u_quad%lt_endpt = u_quad_init%lt_endpt
    u_quad%rt_endpt = u_quad_init%rt_endpt

    !evaluate coefficients and u at endpoints and mat_build
    !trace values
    endpt_vals = var_coeffs(2,(/u_quad_init%lt_endpt, u_quad_init%rt_endpt/))
    u_endpt_vals = (/u_quad_init%lt_trace, u_quad_init%rt_trace/)
    u_quad%lt_trace = u_endpt_vals(1)
    u_quad%rt_trace = u_endpt_vals(2)
    
    A = -1.0_dp*derivative_matrix(num_nodes,leg_degree,u_quad, isConst)
    do i=1,num_time_steps
       U(:,i) = RK4(leg_degree,delta_t,A,U(:,i-1),dble(i-1)*delta_t,dble(i)*delta_t)
       u_quad%a(:,u_quad%nvars) = U(:,i)
       u_endpt_vals = approx_eval(u_quad%lt_endpt,u_quad%rt_endpt,2,(/u_quad%lt_endpt, &
	    		u_quad%rt_endpt/),leg_degree,u_quad%a(:,u_quad%nvars))

       u_quad%lt_trace = endpt_vals(1)*u_endpt_vals(1)
       u_quad%rt_trace = endpt_vals(2)*u_endpt_vals(2)
       A=-1.0_dp*derivative_matrix(num_nodes,leg_degree,u_quad, isConst)
    end do
    call deallocate_quad1d(u_quad)
  end subroutine solve_single_element
  
  subroutine solve_multiple_elements(U, leg_degree, end_time, delta_t, num_time_steps, isConst, beta, domain_left_endpt, domain_right_endpt)
    real(dp), intent(in) :: end_time, delta_t, beta, domain_left_endpt, domain_right_endpt
    integer, intent(in) :: leg_degree, num_time_steps, isConst
    real(dp), dimension(0:leg_degree, 0:num_time_steps, 1:num_elements), intent(out) :: U
    integer :: i, j, num_elements
    real(dp), dimension(0:leg_degree, 0:1) :: U_temp
    real(dp), dimension(:), allocatable :: grd_pts
    type(quad_1d) :: u_quad

    u_quad%nvars = 1
   
    num_elements = NUMEL
    allocate(grd_pts(0:num_elements))
    grd_pts = GRDPTS

    U_temp = 
    do i=0,num_time_steps
       do j=1,num_elements
          u_quad = element(grd_pts(j-1), grd_pts(j), leg_degree)
          !calculate trace values
          call solve_single_element(U_temp, leg_degree, delta_t, delta_t, 1, isConst, u_quad)
          U(:,i,j) = U_temp(:,1)
          !end loops appropriately
  end subroutine solve_multiple_elements
end module solver
