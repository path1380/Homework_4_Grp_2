x = load('space_der.txt');
num_runs = length(x);
semilogy(1:num_runs, x,'linewidth',1.5);
set(gca,'fontsize',18);
xlabel('Maximal Legendre Polynomial Degree')
ylabel('Maximum Error')
title('Error of $(au)_x$ with Increasing Legendre Degree','Interpreter','latex')

print -depsc2 derivative_plot
print -dpng derivative_plot
exit