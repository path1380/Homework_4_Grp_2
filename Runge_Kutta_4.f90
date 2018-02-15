  !================================================================================================================
  !
  !Runge_Kutta_4.f90 : This module is used for solving a system of ODEs u'(t)=Q*u(t), where u(t) is a vector-valued
  !function and Q is a Matrix. Dimension of u is (q+1*1) and dimension of Q is (q+1*q+1), where q is the
  !highest degree of Legendre polynomials for this particular element. Delta_t is the time-step used, ti is the
  !initial time, tf is the final time, u0 is the initial condition of u.
  !
  !===============================================================================================================
module Runge_Kutta_4
  use type_defs
  !use InputControl.Template
  use lgl
  !use quad_1dmod
  use leg_funs
  implicit none
contains
  function RK4(leg_degree,Delta_t,Q,u0,ti,tf)
    ! Declaring all input, output and auxiliary variables
    integer, intent(in) :: leg_degree
    real(dp), intent(in) :: Delta_t,ti,tf
    real(dp), dimension(0:leg_degree,0:leg_degree), intent(in) :: Q
    real(dp), dimension(0:leg_degree), intent(in) :: u0
    real(dp), dimension(0:leg_degree) :: RK4
    
    ! u is the solution. k1, k2, k3, k4 are the auxiliary quantities for RK4. N is the number of time-steps. i is a loop variable (iteration number)
    real(dp), dimension(0:leg_degree) :: u,k1,k2,k3,k4
    integer :: i,N

    ! CEILING is the Least Integer function. So we don't need to worry about giving tf-ti as an exact integer multiple of Delta_t.
    N=CEILING((tf-ti)/Delta_t)
    u=u0
    do i=1,N
       k1=MATMUL(Q,u)
       k2=MATMUL(Q,u+(Delta_t*k1/2))
       k3=MATMUL(Q,u+(Delta_t*k2/2))
       k4=MATMUL(Q,u+(Delta_t*k3))
       u=u+(Delta_t*(k1+(2*k2)+(2*k3)+k4)/6)
    end do
    RK4=u
  end function RK4
end module Runge_Kutta_4

    
    
    
    
    
