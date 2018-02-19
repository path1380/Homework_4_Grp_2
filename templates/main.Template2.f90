program main
! =======================================================================
! This program is the main program for Homework 3. Here we call
! InputControl.f90 to get the desired grid and maximal Legendre polynomial
! degree in each interval. We loop over each interval and project the given
! function (defined in InputControl.f90) onto the space of Legendre
! polynomials in L2. We then evaluate the approximation on an
! equispaced grid on each interval.
! =======================================================================
  use type_defs
  use quad_1dmod
  use leg_funs
  use approx_funs
  use InputControl
  use lgl
  use coeff

  implicit none

  integer, parameter :: num_grdpts = GGGG, num_nodes = NNNN
  integer :: degree_vec(num_grdpts - 1)
  real(dp) :: grdpts(num_grdpts), sample_nodes(num_nodes), function_vals(num_nodes)
  real(dp) :: lt_endpt, rt_endpt, stepsize
  real(dp), dimension(num_grdpts -1) :: unif_err, L2_err
  type(quad_1d), dimension(1:num_grdpts-1) :: interval_info, approximation
  integer :: i, j

  !Grab grid information from InputControl
  call domain_equispaced(grdpts)
  call legendre_degrees(degree_vec)

  !Compute coefficients and approximation on each interval
  do i = 1,num_grdpts-1
    lt_endpt = grdpts(i)
    rt_endpt = grdpts(i+1)

    !get coefficients in the current interval
    interval_info(i)%lt_endpt = lt_endpt
    interval_info(i)%rt_endpt = rt_endpt
    interval_info(i)%q = degree_vec(i)
    interval_info(i)%nvars = 1
    call allocate_quad1d(interval_info(i))
    interval_info(i) = element(lt_endpt,rt_endpt,degree_vec(i))

    !build approximation
    approximation(i)%lt_endpt = lt_endpt
    approximation(i)%rt_endpt = rt_endpt
    approximation(i)%q = num_nodes - 1
    approximation(i)%nvars = 1
    call allocate_quad1d(approximation(i))

    stepsize = (rt_endpt - lt_endpt)/dble(num_nodes + 1)
    do j=1,num_nodes
      sample_nodes(j) = lt_endpt + j*stepsize
    end do

    !create array of function values at each sample node (for error calculations)
    function_vals = function_eval(num_nodes, sample_nodes)


    !evaluate at a new set of gridpoints
     approximation(i)%a(:,1) = approx_eval(lt_endpt,rt_endpt,num_nodes,sample_nodes,degree_vec(i),interval_info(i)%a(:,1))
     unif_err(i) = MAXVAL(ABS(approximation(i)%a(:,1) - function_vals))
     L2_err(i) = NORM2(approximation(i)%a(:,1) - function_vals)
  end do

  !print errors out to terminal
  write(*,'(2(E24.16))') maxval(unif_err), maxval(L2_err)

  !Deallocate all used memory
  call delete_quad(num_grdpts-1, interval_info)
  call delete_quad(num_grdpts-1, approximation)

end program main
