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
  implicit none
contains
  subroutine solve_single_element(U, leg_degree, end_time, delta_t, num_time_steps)
    real(dp), intent(in) :: end_time, delta_t
    type(quad_1d) :: u_quad
    integer, intent(in) :: leg_degree
    integer, intent(in) :: num_time_steps
    real(dp), dimension(0:num_time_steps,0:leg_degree), intent(out) :: U
    real(dp), dimension(0:leg_degree) :: nodes,weights
    integer :: i,j,num_nodes
    real(dp), dimension(0:leg_degree,0:leg_degree) :: A
    num_nodes=leg_degree+1
    
    call lglnodes(nodes,weights,leg_degree)
    U(0,:) = Initial_condition(num_nodes,nodes)
    
    u_quad%nvars = 1
    u_quad%q = leg_degree
    u_quad%lt_endpt = LLLL
    u_quad%rt_endpt = RRRR
    call allocate_quad1d(u_quad)
    u_quad%lt_trace = U(0,0)
    u_quad%rt_trace = U(0,leg_degree)
    
    A = -diff_mat(num_nodes,leg_degree,u_quad,2)
    
    do i=1,num_time_steps
       U(i,:) = RK4(leg_degree,delta_t,A,U(i-1,:),(i-1)*delta_t,i*delta_t)
       u_quad%lt_endpt = LLLL
       u_quad%lt_trace = U(i,0)
       u_quad%rt_endpt = RRRR
       u_quad%rt_trace = U(i,leg_degree)
       u_quad%a(:,u_quad%nvars) = U(i,:)
       A=-diff_mat(num_nodes,leg_degree,u_quad,2)
    end do
    call deallocate_quad1d(u_quad)
  end subroutine solve_single_element
  
end module solver
