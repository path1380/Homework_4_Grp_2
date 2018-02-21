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
  
  real(dp) :: end_time, delta_t,Error, stepsize
  real(dp), parameter :: lt_endpt = LLLL, rt_endpt = RRRR
  integer, parameter :: num_grdpts = 100
  integer :: leg_degree, num_time_steps, i, j, isConst
  real(dp) :: endpt_vals(2)
  real(dp), dimension(:,:), allocatable :: U_coeff,U_exact_solution,U_solution
  !real(dp), allocatable :: x(:),w(:),tmp(:)
  real(dp), allocatable :: t(:)
  real(dp) :: sample_nodes(0:num_grdpts-1)
  
  end_time = TTTT
  delta_t = DTDT
  num_time_steps = MAXVAL((/CEILING(end_time/delta_t), 0/))
  leg_degree = DDDD
  isConst = IIII
  endpt_vals(1) = lt_endpt
  endpt_vals(2) = rt_endpt

  allocate(U_coeff(0:leg_degree,0:num_time_steps))
  allocate(U_exact_solution(0:num_grdpts-1,0:num_time_steps))
  allocate(U_solution(0:num_grdpts-1,0:num_time_steps))
  allocate(t(0:num_time_steps))

  stepsize = (rt_endpt - lt_endpt)/dble(num_grdpts + 1)
  do j=0,num_grdpts - 1 
    sample_nodes(j) = lt_endpt + j*stepsize
  end do

  call solve_single_element(U_coeff, leg_degree, end_time, delta_t, num_time_steps, isConst)

  !build exact solution to compare
  do j=0,num_time_steps
     t(j)=dble(j)*delta_t
     U_exact_solution(:,j) = COS(sample_nodes - t(j))
  end do

  !evaluate approximation at each time step at each gridpoint
  do j=0,num_time_steps
    U_solution(:,j) = approx_eval(lt_endpt,rt_endpt,num_grdpts,sample_nodes,&
                                leg_degree,U_coeff(:,j))
  end do

  !write(*,*) U_solution
  ! Error = maxval(abs(U_exact_solution - U_solution))
  do j=0,num_time_steps
    do i=0,num_grdpts-1
      write(*,'((E24.16))') U_solution(i,j)
    end do
    write(*,'(A16)') 'BREAK'
  end do
  ! do i = 0,num_time_steps
  !   write(*,'((E24.16))') NORM2(U_exact_solution(:,i) - U_solution(:,i))
  ! end do
  !write(*,*) 'The maximum Error is',Error

  ! do i=0,num_time_steps
  !    ! write(*,*) 'The maximum relative error at time t = ',i*delta_t,' is',maxval(abs((U_exact_solution(:,i)-U_solution(:,i))&
  !    !                                                                             /U_exact_solution(:,i)))
  !    ! write(*,*) 'The maximum error at time t = ',i*delta_t,' is',maxval(abs((U_exact_solution(:,i)-U_solution(:,i))))
  ! end do
  deallocate(U_coeff)
  deallocate(U_solution)
  deallocate(U_exact_solution)
  deallocate(t)
end program test_solver
