program test_RK4
  use type_defs
  !use InputControl
  !use lgl
  !use quad_1dmod
  !use leg_funs
  use Runge_Kutta_4
  implicit none
  real(dp), dimension(0:9) :: u0,u
  real(dp), dimension(0:9,0:9) :: Q
  integer :: i,j
  do i=0,9
     do j=0,9
        if (i == j) then
           Q(i,j)=-0.5
        else if (i /= j) then
           Q(i,j)=0
        end if
     end do
     u0(i)=1.d0
  end do
  
!  integer, dimension(1:2) :: x,b,c
!  a(1,1)=1
!  a(1,2)=0
!  a(2,1)=0
!  a(2,2)=1
!  x(1)=1
!  x(2)=0
!  b=MATMUL(A,x)
  !  c=b
  u=RK4(9,0.01d0,Q,u0,0.d0,1.d0)
  write(*,*)'Lets see if this works'
  do i=0,9
     write(*,*) u(i)
  end do
  do i=0,9
     write(*,*) Q(i,:)
  end do
end program test_RK4
