module diff_coeff
!--------------------------------------------------------------------------------------------------------------
  ! This module contains a routine to find the coefficients of the derivative of the solution u in a given
  ! interval. This assumes the numerical flux has been calculated and stored in a quad_1d that defines 
  ! the approximation to u in a given interval. If a single interval is used, the terms
  !								a(x_R)u(x_R), 	a(x_L)u(x_L)
  ! should be computed and stored in rt_trace and lt_trace respectively. Note that for taking a time derivative
  ! post multiplication by -1.0_dp is necessary.
!--------------------------------------------------------------------------------------------------------------
  use type_defs
  use quad_1dmod
  use InputControl
  use lgl
  use leg_funs
  use approx_funs
  use mat_builder
  implicit none

contains

function derivative_coefficients(num_nodes, leg_degree, u_quad)
      ! ========================================================
      ! Inputs: - num_nodes  : number of nodes used in Gauss  
      !                        quadrature
      !         - leg_degree : highest degree of Legendre poly
      !                        used   
      !         - u_quad     : quad_1d containing information
      !						   about the solution u in the
      !						   current interval
      !
      ! Output:   1D Array that represents the coefficients of
      !			  the derivative of the solution u for the 
      ! 		  transport equation.
      ! ========================================================
    integer, intent(in) :: num_nodes, leg_degree 
    type(quad_1d), intent(in) :: u_quad

    real(dp) :: S(0:leg_degree,0:leg_degree), scaling

    real(dp), dimension(0:leg_degree) :: derivative_coefficients, tmp
    integer :: k

    scaling = 2.0_dp/(u_quad%rt_endpt - u_quad%lt_endpt)

    !apply S matrix and right endpoint correction
    S = diff_mat(num_nodes, leg_degree, u_quad, 0)
    derivative_coefficients(:) = MATMUL(-1.0_dp*S,u_quad%a(:,1))
    derivative_coefficients(:) = derivative_coefficients(:) + u_quad%rt_trace

    !apply left endpt correction
    do k = 0, leg_degree
      derivative_coefficients(k) = derivative_coefficients(k) - (u_quad%lt_trace)*((-1.0_dp)**dble(k))
    end do

    !build vector defining M^-1
    do k=0, leg_degree
       tmp(k) = 0.5_dp*(2.0_dp*dble(k) + 1.0_dp)
    end do

    !Invert matrix M to find coefficients
    derivative_coefficients = scaling*tmp(:)*derivative_coefficients(:)

end function derivative_coefficients

function derivative_matrix(num_nodes, leg_degree, u_quad)
      ! ========================================================
      ! Inputs: - num_nodes  : number of nodes used in Gauss  
      !                        quadrature
      !         - leg_degree : highest degree of Legendre poly
      !                        used   
      !         - u_quad     : quad_1d containing information
      !              about the solution u in the
      !              current interval
      !
      ! Output:   1D Array that represents the coefficients of
      !       the derivative of the solution u for the 
      !       transport equation.
      ! ========================================================
    integer, intent(in) :: num_nodes, leg_degree 
    type(quad_1d), intent(in) :: u_quad

    real(dp) :: derivative_matrix(0:leg_degree,0:leg_degree), scaling

    real(dp), dimension(0:leg_degree) :: tmp
    integer :: i, j 

    scaling = 2.0_dp/(u_quad%rt_endpt - u_quad%lt_endpt)

    !apply S matrix and right endpoint correction
    derivative_matrix = diff_mat(num_nodes, leg_degree, u_quad, 0)
    derivative_matrix(:,:) = -1.0_dp*derivative_matrix(:,:) + u_quad%rt_trace

    !add left endpoint correction
    do j=0, leg_degree
      do i=0,leg_degree
        derivative_matrix(i,j) =  derivative_matrix(i,j) - u_quad%lt_trace*((-1.0_dp)**(dble(i + j)))
      end do
    end do

    do i = 0, leg_degree
      tmp(i) = 0.5_dp*(2.0_dp*dble(i) + 1.0_dp)
    end do

    do j=0,leg_degree
      derivative_matrix(:,j) = derivative_matrix(:,j)*tmp(:)
    end do

    !Invert matrix M to find coefficients
    derivative_matrix(:,:) = scaling*derivative_matrix(:,:)

end function derivative_matrix

end module diff_coeff
