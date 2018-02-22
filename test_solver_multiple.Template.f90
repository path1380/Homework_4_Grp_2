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
  real(dp), parameter :: lt_endpt = LLLL, rt_endpt = RRRR, beta = BETA
  integer, parameter :: num_grdpts = 30, num_elements = NUMEL

  !-----------------------------------------------------------------!
  !DON'T FORGET TO CHANGE NUMEL IN PERL SCRIPT
  !-----------------------------------------------------------------!

  integer :: leg_degree, num_time_steps, i, j
  integer, parameter :: isConst = 0
  real(dp) :: endpt_vals(2), u_endpt_vals(2)
  real(dp), dimension(:), allocatable :: t
  real(dp) :: sample_nodes(0:num_grdpts-1)
  real(dp) :: grd_points(0:num_elements)
  real(dp), dimension(:,:), allocatable :: all_errors
  real(dp), dimension(:,:,:), allocatable :: U_coeff,U_exact_solution,U_solution
  real(dp), dimension(:), allocatable ::  err_vec

  end_time = ETET
  delta_t = DTDT
  num_time_steps = MAXVAL((/CEILING(end_time/delta_t), 0/))
  leg_degree = DDDD

  ALLOCATE(U_coeff(0:leg_degree, 0:num_time_steps, 1:num_elements))
  ALLOCATE(U_exact_solution(0:num_grdpts-1, 0:num_time_steps, 1:num_elements))
  ALLOCATE(U_solution(0:num_grdpts-1, 0:num_time_steps, 1:num_elements))
  ALLOCATE(all_errors(0:num_time_steps,num_elements))
  ALLOCATE(err_vec(0:num_time_steps))

  stepsize = (rt_endpt - lt_endpt)/dble(num_elements)
  do i = 0,num_elements
    grd_points(i) = lt_endpt + dble(i)*stepsize
  end do

  call solve_multiple_elements(U_coeff, leg_degree, end_time, delta_t, num_time_steps, isConst,&
                                     beta, lt_endpt, rt_endpt)


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

  deallocate(U_coeff)
  deallocate(U_solution)
  deallocate(U_exact_solution)
end program test_solver_multiple
