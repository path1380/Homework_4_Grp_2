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
    
    

    U(:,0) = u_quad_init%a(:,u_quad_init%nvars)
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
  
  subroutine solve_multiple_elements(U, leg_degree, end_time, delta_t, num_time_steps, isConst,&
                                     beta, domain_left_endpt, domain_right_endpt)
    real(dp), intent(in) :: end_time, delta_t, beta, domain_left_endpt, domain_right_endpt
    integer, intent(in) :: leg_degree, num_time_steps, isConst
    integer, parameter :: num_elements = NUMEL
    real(dp), dimension(0:leg_degree, 0:num_time_steps, 1:num_elements), intent(out) :: U
    integer :: i, j
    real(dp), dimension(0:leg_degree, 0:1) :: U_temp
    real(dp), dimension(:), allocatable :: grd_pts
    type(quad_1d), dimension(:), allocatable :: elem_array
    real(dp) :: u_endpt_vals(2), endpt_vals(0:num_elements), tmp, space_step, tmp2


    ALLOCATE(elem_array(1:num_elements))

    !u_quad%nvars = 1

    allocate(grd_pts(0:num_elements))
    !grd_pts = GRDPTS
    space_step = (domain_right_endpt - domain_left_endpt)/dble(num_elements)

    !create endpoints to be used for elements
    do i = 0,num_elements
      grd_pts(i) = domain_left_endpt + dble(i)*space_step
    end do

    endpt_vals = var_coeffs(num_elements+1,grd_pts)

    !set up elements from initial data
    do i=1,num_elements
      !add endpoint information and allocate coefficient array for each element
      elem_array(i) = element(grd_pts(i-1),grd_pts(i),leg_degree)
      
      !evaluate the function at the endpoints
      u_endpt_vals = function_eval(2,(/grd_pts(i-1), grd_pts(i)/))
      !endpt_vals = var_coeffs(2,(/elem_array%lt_endpt, elem_array%rt_endpt/))
      !store product as trace, will update later with true numerical flux
      elem_array(i)%lt_trace = endpt_vals(i-1)*u_endpt_vals(1)
      elem_array(i)%rt_trace = endpt_vals(i)*u_endpt_vals(2)
    end do

    do i=1,num_time_steps

        !store the previous trace value as we overwrite
        tmp = elem_array(1)%lt_trace
        tmp2 = elem_array(num_elements)%rt_trace
        !elem_array(1)%rt_trace =  beta*elem_array(1)%rt_trace + (1.0_dp - beta)*elem_array(2)%lt_trace
        !call solve_single_element(U(:,i-1:i,1), leg_degree, delta_t, delta_t, 1, isConst, elem_array(i))

        elem_array(1)%lt_trace = beta*tmp + (1.0_dp-beta)*tmp2
        elem_array(num_elements)%rt_trace = beta*tmp2 + (1.0_dp-beta)*tmp

        tmp = elem_array(1)%rt_trace
      !do work for middle elements
       do j=2,num_elements
          !compute numerical flux for each element
          elem_array(j)%lt_trace =  beta*elem_array(j)%lt_trace + (1.0_dp - beta)*tmp
          tmp = elem_array(j)%rt_trace
          !elem_array(j)%rt_trace =  beta*elem_array(j)%rt_trace + (1.0_dp - beta)*elem_array(j+1)%lt_trace
          !u_quad = element(grd_pts(j-1), grd_pts(j), leg_degree)
          !calculate trace values
          !call solve_single_element(U_temp, leg_degree, delta_t, delta_t, 1, isConst, u_quad)
          !U(:,i,j) = U_temp(:,1)
        end do

        !account for end element
        !elem_array(num_elements)%lt_trace = beta*elem_array(num_elements-1)%lt_trace + (1.0_dp - beta)*tmp


      do j=1,num_elements
        !do a single time step for each element
        call solve_single_element(U_temp, leg_degree, delta_t, delta_t, 1, isConst, elem_array(j))

        !store coefficient values
        U(:,i,j) = U_temp(:,1)

        !now we'll need to update the trace values, call approx_eval
        u_endpt_vals = approx_eval(grd_pts(j-1),grd_pts(j),2,(/grd_pts(j-1), &
          grd_pts(j)/),leg_degree,elem_array(j)%a(:,elem_array(j)%nvars))
        elem_array(j)%lt_trace = endpt_vals(j-1)*u_endpt_vals(1)
        elem_array(j)%rt_trace = endpt_vals(j)*u_endpt_vals(2)
      end do

    end do
  end subroutine solve_multiple_elements
end module solver
