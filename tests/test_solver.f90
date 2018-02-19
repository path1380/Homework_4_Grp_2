program test_solver
  use type_defs
  use quad_1dmod
  use InputControl
  use lgl
  use leg_funs
  use approx_funs
  use mat_builder
  use diff_coeff
  use Runge_Kutta_4
  use solver
  implicit none
  
  real(dp) :: end_time, delta_t,Error
  integer :: leg_degree, num_time_steps, i, j
  real(dp), dimension(:,:), allocatable :: U,U_exact
  real(dp), allocatable :: x(:),w(:)
  real(dp), allocatable :: t(:)
  
  end_time = 0.1
  delta_t = 0.0002
  num_time_steps = CEILING(end_time/delta_t)
  leg_degree = 5

  allocate(U(0:num_time_steps,0:leg_degree))
  allocate(t(0:num_time_steps))
  allocate(x(0:leg_degree))
  allocate(w(0:leg_degree))
  allocate(U_exact(0:num_time_steps,0:leg_degree))
  call lglnodes(x,w,leg_degree)
  
  call solve_single_element(U, leg_degree, end_time, delta_t, num_time_steps)
  do i=0,num_time_steps
     t(i)=i*delta_t
     do j=0,leg_degree
        U_exact(i,j) = EXP( - ((x(j)-t(i))/0.3d0)**2 )
     end do
  end do
  Error = maxval(abs(U_exact - U))
  write(*,*) 'The maximum Error is',Error
  do i=0,num_time_steps
     write(*,*) 'The exact solution at time t = ',i*delta_t,' is equal to',U_exact(i,:)
     write(*,*) 'The calculated solution at this time is equal to',U(i,:)
     write(*,*) 'The Error at this time is equal to',U_exact(i,:) - U(i,:)
  end do
  do i=0,num_time_steps
     write(*,*) 'The maximum relative error at time t = ',i*delta_t,' is',maxval(abs((U_exact(i,:)-U(i,:))/U_exact(i,:)))
  end do
  deallocate(U)
  deallocate(U_exact)
  deallocate(x)
  deallocate(w)
  deallocate(t)
end program test_solver
