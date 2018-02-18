module mat_builder
!--------------------------------------------------------------------------------------------------------------
  ! This module builds the A matrix for Homework 4. The matrix is constructed by first creating the 
  ! Gram matrix of L2 inner products between Legendre polynomials and their derivatives. For the variable
  ! coefficient problem, rank one updates are done to the Gram matrix. Finally, multiplication by a 
  ! diagonal matrix yields the final A matrix.
!--------------------------------------------------------------------------------------------------------------
  use type_defs
  use quad_1dmod
  use InputControl
  use lgl
  use leg_funs
  use approx_funs
  implicit none

contains
	
	function diff_mat(num_nodes, leg_degree, u_quad, mat_flag)
      ! ========================================================
      ! Inputs: - num_nodes  : number of nodes used in Gauss  
      !                        quadrature
      !         - leg_degree : highest degree of Legendre poly
      !                        used   
      !         - u_quad     : quad_1d containing information
      !						   about the solution u in the
      !						   current interval
      !			- mat_flag	 : flag variable. 0 to output S
      !						   matrix, 1 for constant coeff,
      ! 					   2 for periodic
      !
      ! Output:   2D Array (matrix) A that represents the 
      !			  spatial differentiation operator for the 
      ! 		  transport equation.
      ! ========================================================
    	integer, intent(in) :: num_nodes, leg_degree, mat_flag
      	type(quad_1d), intent(in) :: u_quad

    	real(dp) :: diff_mat(0:leg_degree,0:leg_degree)

    	real(dp), dimension(0:leg_degree) :: leg_poly, leg_der, tmp
      	real(dp), dimension(0:num_nodes-1) :: leg_nodes, leg_weights, coeff_eval
      	real(dp) :: endpt_vals(2), u_endpt_vals(2), scaling, shift
      	integer :: k, j
      	integer, parameter :: alpha = 0, beta = 0

      	!Initialize matrix to all zeros and define map to desired interval
      	diff_mat(:,:) = 0.0_dp
      	scaling = 0.5_dp*(u_quad%rt_endpt - u_quad%lt_endpt)
      	shift = 0.5_dp*(u_quad%lt_endpt + u_quad%rt_endpt)

	    !Generate quadrature weights and nodes
	    call lglnodes(leg_nodes,leg_weights,num_nodes-1)

	    !evaluate variable coefficients at legendre nodes (here
	    !we use the affine map)
	   	coeff_eval = var_coeffs(num_nodes, scaling*leg_nodes + shift)

	    !Loop over every quadrature node to build S matrix
	    do k = 0, num_nodes-1
	    	
	    	!evaluate all legendre poly's and their derivatives at
	    	!current node
	    	leg_poly = leg(leg_degree, leg_nodes(k))
	   		tmp = jacobiP(leg_degree,leg_nodes(k),alpha+1,beta+1)
	   		leg_der = gradjacobiP(leg_degree,leg_nodes(k),alpha,beta,tmp)

	   		!multiply by current weight
	   		leg_poly = leg_poly(0:leg_degree)*leg_weights(k)*coeff_eval(k)

	   		!loop over each column and add contribution
	   		!from current node (skip first column of 0's to save work)
	   		do j = 1, leg_degree
	   			diff_mat(0:leg_degree,j) = diff_mat(0:leg_degree,j) + leg_der(j)*leg_poly(0:leg_degree)
	   		end do

	    end do

	    IF (mat_flag == 0) THEN
	    	GO TO 777
	    END IF

	    !build vector defining inverse of mass matrix M
	    do k=0, leg_degree
	    	tmp(k) = 0.5_dp*(2.0_dp*dble(k) + 1.0_dp)
	    end do


	    !Do appropriate work depending on variable/const coefficient
	    IF (mat_flag == 1) THEN
	    	!constant coefficient case
	    	endpt_vals = var_coeffs(2,(/u_quad%lt_endpt, u_quad%lt_endpt/))
	    	diff_mat(:,:) = endpt_vals(1)*diff_mat(:,:)

	    ELSE IF (mat_flag == 2) THEN
	    	!periodic case
	    	!evaluate variable coefficient at endpoints
	    	endpt_vals = var_coeffs(2,(/u_quad%lt_endpt, u_quad%lt_endpt/))

	    	!evaluate current solution u at the endpoints
	    	u_endpt_vals = approx_eval(u_quad%lt_endpt,u_quad%rt_endpt,2,(/u_quad%lt_endpt, &
	    		u_quad%rt_endpt/),leg_degree,u_quad%a(:,u_quad%nvars))

	    	!add correction for right endpoint
	    	diff_mat(:,:) = -diff_mat(:,:) + endpt_vals(2)*u_endpt_vals(2)
	    	!add correction based on left endpoint
	    	do j = 0, leg_degree
	    		do k = 0, leg_degree
	    			diff_mat(k,j) = diff_mat(k,j) - endpt_vals(1)*u_endpt_vals(1)*((-1.0_dp)**(dble(k) + dble(j)))
	    		end do 
	    	end do
	    end IF

	    !backsolve to get A matrix
	    do j = 0,leg_degree
	   			diff_mat(:,j) = tmp(:)*diff_mat(:,j)
	    end do

	    777 CONTINUE
	end function diff_mat

end module mat_builder
