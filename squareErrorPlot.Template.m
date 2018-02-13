str = 'output_';
tmp = num2str(TTTT); %use perl to overwrite string 
num_intervals = VVVV;
colorVec = hsv(log2(num_intervals));

%loop over each file to build plots
for i = 1:log2(num_intervals)
    str = 'output_';
    str = strcat(str,tmp,'_',num2str(i),'.txt');
    x = load(str);
    intvec = 2.^(1:length(x))';

    loglog(intvec, x(:,2),'-o','Color', colorVec(i,:));
    legendInfo{i} = ['q = ' num2str(i)];
    hold on
end
set(gca,'fontsize',18);
xlabel('Number of Intervals')
ylabel('Log Error')
title('$L_2$ Error','Interpreter','latex')
ylim([eps,100])
%legend(legendInfo)

print -depsc2 YYYY
print -dpng WWWW
exit