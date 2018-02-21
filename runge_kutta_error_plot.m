a = dir('l2*.txt');
stepvec =[0.00002,0.0002,0.002];

for i=1:length(a)/3
    
    x = load(a(i).name);
    y = load(a(i+3).name);
    z = load(a(i+6).name);
    figure(i)
    semilogy(1:length(x),x,'linewidth',1.5);
    hold on
    semilogy(1:length(y),y,'linewidth',1.5);
    semilogy(1:length(z),z,'linewidth',1.5);
    set(gca,'fontsize',18);
    xlabel('Number of Time Steps Taken')
    ylabel('$L_2$ Error','interpreter','latex')
    titlestr = strcat('$L_2$ Error in Time ($\Delta t =', num2str(stepvec(i)),'$)'); 
    title(titlestr,'Interpreter','latex')
    xlim([0,length(x)])
    legend('q = 10','q = 15', 'q=20');
    print(strcat('l2_time_',num2str(i)),'-depsc2');
    print(strcat('l2_time_',num2str(i)),'-dpng')

    strname = strcat('l2_time_',num2str(i));
end
exit