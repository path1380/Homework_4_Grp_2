program lapack_test
	use type_defs
	implicit none 

	integer, parameter :: n = 10
	integer :: LWORK, INFO, i, j
	real(dp) :: A(n,n), eigreal(n), eigim(n), WORK(3*n), temp(n)
	CHARACTER(1) :: lefteig = 'N', righteig = 'N'

	LWORK = 3*n

	do i =1,n
		do j=1,n
			IF (i .le. j) THEN
				A(i,j) = i + j
			ELSE
				A(i,j) = 0
			end if
		end do
	end do

	CALL DGEEV(lefteig,righteig, n, A, n, eigreal, eigim, temp, n, temp,n, WORK, LWORK, INFO)
	write(*,*) eigreal

end program lapack_test
