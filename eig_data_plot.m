x = load('eig_data.txt');
plot(x(:,1),x(:,2),'*-', 'linewidth',2);
hold on
plot(x(:,1),0.5*x(:,1).*(x(:,1)+1),'r-', 'linewidth',1.5)
set(gca,'fontsize',18);
xlabel('Maximal Legendre Polynomial Degree')
ylabel('$|\lambda_{max}|$','interpreter','latex')
title('Eigenvalues of Derivative Operator','Interpreter','latex')
legend('|\lambda_{max}|', '0.5q(q+1)','Location','NorthWest')

print -depsc2 eig_data
print -dpng eig_data
exit