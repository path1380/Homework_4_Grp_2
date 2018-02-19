% Note: This script is executed from the parent directory by run_eig_data.p

x = load('data/eig_data.txt');

figure(1)
plot(x(:,1),x(:,2),'*-', 'linewidth',2);
hold on
plot(x(:,1),0.5*x(:,1).*(x(:,1)+1),'r-', 'linewidth',1.5)
set(gca,'fontsize',18);
xlabel('Maximal Legendre Polynomial Degree')
ylabel('$|\lambda_{max}|$','interpreter','latex')
title('Eigenvalues of Derivative Operator','Interpreter','latex')
legend('|\lambda_{max}|', '0.5q(q+1)','Location','NorthWest')

saveas(figure(1), fullfile(pwd, 'media','eig_data'), 'png')
saveas(figure(1), fullfile(pwd, 'media','eig_data'), 'epsc')

eig_vec = 1:7;
colorVec = hsv(length(eig_vec));
figure(2)
for i = 1:length(eig_vec)
    str = 'data/eig_';
    str = strcat(str,num2str(i),'.txt');
    evals = load(str);
    plot(evals(:,1) + 1i*evals(:,2),'*','Color',colorVec(i,:),'linewidth',1.5);
    hold on
    legendInfo{i} = ['q = ' num2str(i)];
end
axis_width = max(evals(:,2));
set(gca,'fontsize',18);
xlabel('Maximal Legendre Polynomial Degree')
ylabel('$\lambda$','interpreter','latex')
ylim([-axis_width,axis_width])
xlim([-1,1])
title('Eigenvalues of Differential Operator','Interpreter','latex')
legend(legendInfo)

saveas(figure(2), fullfile(pwd, 'media','eig_plot'), 'png')
saveas(figure(2), fullfile(pwd, 'media','eig_plot'), 'epsc')
exit
