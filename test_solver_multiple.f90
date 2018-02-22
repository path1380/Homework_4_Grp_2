program test_solver_multiple
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
  

  real(dp) :: end_time, delta_t, stepsize
  type(quad_1d) :: u_quad
  real(dp), parameter :: lt_endpt = -1.0_dp*ACOS(-1.0_dp), rt_endpt = ACOS(-1.0_dp), beta = 1_dp
  integer, parameter :: num_grdpts = 30, num_elements = 5
  integer :: leg_degree, num_time_steps, i, j
  integer, parameter :: isConst = 0
  real(dp) :: endpt_vals(2), u_endpt_vals(2)
  real(dp), dimension(:), allocatable :: t
  real(dp) :: sample_nodes(0:num_grdpts-1)
  real(dp) :: grd_points(0:num_elements)
  real(dp), dimension(:,:), allocatable :: all_errors
  real(dp), dimension(:,:,:), allocatable :: U_coeff,U_exact_solution,U_solution
  real(dp), dimension(:), allocatable ::  err_vec
  ! real(dp), dimension(0:leg_degree, 0:num_time_steps, 1:num_elements), intent(out) :: U


  !end_time = 2.0_dp
  end_time = 0.006_dp
  delta_t = 0.002_dp
  num_time_steps = MAXVAL((/CEILING(end_time/delta_t), 0/))
  leg_degree = 5

  ALLOCATE(U_coeff(0:leg_degree, 0:num_time_steps, 1:num_elements))
  ALLOCATE(U_exact_solution(0:num_grdpts-1, 0:num_time_steps, 1:num_elements))
  ALLOCATE(U_solution(0:num_grdpts-1, 0:num_time_steps, 1:num_elements))
  ALLOCATE(all_errors(0:num_time_steps,num_elements))
  ALLOCATE(err_vec(0:num_time_steps))
  ! allocate(t(0:num_time_steps))

  stepsize = (rt_endpt - lt_endpt)/dble(num_elements)
  do i = 0,num_elements
    grd_points(i) = lt_endpt + dble(i)*stepsize
  end do


  ! stepsize = (rt_endpt - lt_endpt)/dble(num + 1)
  ! do j=0,num_grdpts - 1 
  !   sample_nodes(j) = lt_endpt + j*stepsize
  ! end do



  call solve_multiple_elements(U_coeff, leg_degree, end_time, delta_t, num_time_steps, isConst,&
                                     beta, lt_endpt, rt_endpt)



  ! do i=1,num_elements

  !   stepsize = (grd_points(i) - grd_points(i-1))/dble(num_grdpts + 1)
  !   do j=0,num_grdpts - 1 
  !     sample_nodes(j) = grd_points(i-1) + j*stepsize
  !   end do
    
  !   U_solution(:,2,i) = approx_eval(grd_points(i-1),grd_points(i),num_grdpts,sample_nodes,&
  !                                 leg_degree,U_coeff(:,1,i))

  !   U_exact_solution(:,2,i) = SIN(sample_nodes(:) - 2.0_dp*delta_t)
  !   err_vec(i) = MAXVAL(ABS(U_solution(:,2,i) - U_exact_solution(:,2,i)))
  !   ! write(*,*) U_solution(:,1,i) 
  !   ! write(*,*) MAXVAL(ABS(U_solution(:,1,i) - U_exact_solution(:,1,i)))
  !   ! stop 145
  ! end do
  ! write(*,*) MAXVAL(err_vec)

  do i=1,num_elements
    
    !build evaluation points for each element
    stepsize = (grd_points(i) - grd_points(i-1))/dble(num_grdpts + 1)
    do j=0,num_grdpts - 1 
      sample_nodes(j) = grd_points(i-1) + dble(j)*stepsize
    end do

    do j = 0, num_time_steps
      U_solution(:,j,i) = approx_eval(grd_points(i-1),grd_points(i),num_grdpts,sample_nodes,&
                                  leg_degree,U_coeff(:,j,i))
      U_exact_solution(:,j,i) = SIN(sample_nodes(:) - dble(j)*delta_t)
      all_errors(j,i) = MAXVAL(ABS(U_solution(:,j,i) - U_exact_solution(:,j,i)))
    end do 
  end do

  do i = 0,num_time_steps
    err_vec(i) = MAXVAL(all_errors(i,:))
  end do

  write(*,*) err_vec



  !build exact solution to compare
  ! do j=0,num_time_steps
  !    t(j)=dble(j)*delta_t
  !    U_exact_solution(:,j) = COS(sample_nodes - t(j))
  ! end do

  ! !evaluate approximation at each time step at each gridpoint
  ! do j=0,num_time_steps
  !   U_solution(:,j) = approx_eval(lt_endpt,rt_endpt,num_grdpts,sample_nodes,&
  !                               leg_degree,U_coeff(:,j))
  ! end do

  ! !write(*,*) U_solution
  ! ! Error = maxval(abs(U_exact_solution - U_solution))
  ! do j=0,num_time_steps
  !   do i=0,num_grdpts-1
  !     write(*,'((E24.16))') U_solution(i,j)
  !   end do
  !   write(*,'(A16)') 'BREAK'
  ! end do
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
  ! deallocate(t)
end program test_solver_multiple
