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

eig_vec = 1:7;
colorVec = hsv(length(eig_vec));
figure(2)
for i = 1:length(eig_vec)
    str = 'eig_';
    str = strcat(str,num2str(i),'.txt');
    evals = load(str);
    plot(evals(:,1) + 1i*evals(:,2),'*','Color',colorVec(i,:),'linewidth',1.5);
    hold on
    legendInfo{i} = ['q = ' num2str(i)];
end 
axis_width = max(evals(:,2));
set(gca,'fontsize',18);
ylabel('$Im(\lambda)$','interpreter','latex')
xlabel('$Re(\lambda)$','interpreter','latex')
ylim([-axis_width,axis_width])
xlim([-1,1])
title('Eigenvalues of Differential Operator','Interpreter','latex')
legend(legendInfo)

print -depsc2 eig_plot
print -dpng eig_plot
exit