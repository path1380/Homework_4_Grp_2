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
  real(dp) :: endpt_vals(2)
  real(dp), dimension(:,:), allocatable :: U_coeff,U_exact_solution,U_solution
  real(dp), allocatable :: x(:),w(:),x1(:),tmp(:)
  real(dp), allocatable :: t(:)
  
  end_time = TTTT
  delta_t = DTDT
  num_time_steps = CEILING(end_time/delta_t)
  leg_degree = DDDD

  endpt_vals(1) = LLLL
  endpt_vals(2) = RRRR

  allocate(U_coeff(0:num_time_steps,0:leg_degree))
  allocate(U_exact_solution(0:num_time_steps,0:leg_degree))
  allocate(U_solution(0:num_time_steps,0:leg_degree))
  allocate(t(0:num_time_steps))
  allocate(x(0:leg_degree))
  allocate(x1(1:leg_degree+1))
  allocate(w(0:leg_degree))
  allocate(tmp(1:leg_degree+1))
  call lglnodes(x,w,leg_degree)

  do i=0,leg_degree
     x1(i+1) = x(i)
  end do
  
  call solve_single_element(U_coeff, leg_degree, end_time, delta_t, num_time_steps)
  do i=0,num_time_steps
     t(i)=i*delta_t
     do j=0,leg_degree
        U_exact_solution(i,j) = EXP( - ((x(j)-t(i))/0.3d0)**2 )
     end do
  end do

  do i=0,num_time_steps
     do j=0,leg_degree
        w = U_coeff(i,:)
        tmp = approx_eval(endpt_vals(1),endpt_vals(2),leg_degree+1,x1,leg_degree,w)
        U_solution(i,j) = tmp(j+1)
     end do
  end do

  Error = maxval(abs(U_exact_solution - U_solution))
  write(*,*) 'The maximum Error is',Error
  !do i=0,num_time_steps
  !   write(*,*) 'The exact solution at time t = ',i*delta_t,' is equal to',U_exact(i,:)
  !   write(*,*) 'The calculated solution at this time is equal to',U(i,:)
  !   write(*,*) 'The Error at this time is equal to',U_exact(i,:) - U(i,:)
  !end do
  do i=0,num_time_steps
     write(*,*) 'The maximum relative error at time t = ',i*delta_t,' is',maxval(abs((U_exact_solution(i,:)-U_solution(i,:))&
                                                                                 /U_exact_solution(i,:)))
  end do
  deallocate(U_coeff)
  deallocate(U_solution)
  deallocate(U_exact_solution)
  deallocate(x)
  deallocate(x1)
  deallocate(w)
  deallocate(t)
end program test_solver
