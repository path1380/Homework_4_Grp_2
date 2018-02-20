a = dir('l2*.txt');
for i=1:length(a)
    
    x = load(a(i).name);
    figure(i)
    semilogy(1:length(x),x,'linewidth',1.5);
    set(gca,'fontsize',18);
    xlabel('Number of Time Steps Taken')
    ylabel('$L_2$ Error','interpreter','latex')
    title('$L_2$ Error in Time ($q=15$)','Interpreter','latex')
    xlim([0,length(x)])
end
print -depsc2 l2_time
print -dpng l2_time
exit