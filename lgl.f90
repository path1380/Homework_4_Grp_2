module lgl
  use type_defs
  implicit none
contains  
subroutine lglnodes(x,w,n)
  !
  ! 
  ! F90 translation of lglnodes.m
  !
  ! Computes the Legendre-Gauss-Lobatto nodes, weights and the LGL Vandermonde 
  ! matrix. The LGL nodes are the zeros of (1-x^2)*P'_N(x). Useful for numerical
  ! integration and spectral method 
  !
  ! Reference on LGL nodes and weights:  
  !   C. Canuto, M. Y. Hussaini, A. Quarteroni, T. A. Tang, "Spectral Methods
  !   in Fluid Dynamics," Section 2.3. Springer-Verlag 1987
  !
  ! Written by Greg von Winckel - 04/17/2004
  ! Contact: gregvw@chtm.unm.edu
  !
  ! Translated and modified not to output the Vandermonde matrix 
  ! by Daniel Appelo.  
  !
    use type_defs
    implicit none
    integer :: n,n1
    real(dp) :: w(0:n),x(0:n),xold(0:n)
    real(dp), parameter :: pi = acos(-1.d0)
    integer :: i,k
    real(dp) :: P(1:n+1,1:n+1),eps
  ! Truncation + 1
    n1=n+1
    eps = 2.2204d-16
  
  ! Use the Chebyshev-Gauss-Lobatto nodes as the first guess
    do i = 0,n
       x(i) = -cos(pi*dble(i)/dble(n))
    end do
  
  ! The Legendre Vandermonde Matrix
  !  P=zeros(N1,N1);
  
  ! Compute P_(N) using the recursion relation
  ! Compute its first and second derivatives and 
  ! update x using the Newton-Raphson method.
  
    xold = 2.d0
  
    do i = 1,100 ! Ridic!   
       xold = x
     
       P(:,1) = 1.d0
       P(:,2) = x
     
       do  k=2,n
          P(:,k+1)=( dble(2*k-1)*x*P(:,k)-dble(k-1)*P(:,k-1) )/dble(k);
       end do
       x = xold-( x*P(:,n1)-P(:,n) )/( dble(n1)*P(:,n1) )
       if (maxval(abs(x-xold)).lt. eps ) exit
    end do
  
    w=2.d0/(dble(n*n1)*P(:,n1)**2)
 
  end subroutine lglnodes
end module lgl

