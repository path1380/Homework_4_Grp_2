str = 'output_beta=';
dirname = '';
betavec = [0,0.5,1];
for i =1:3
   figure(i)
   dirname = strcat(str,num2str(betavec(i)),'*.txt');
   a = dir(dirname);
   colorVec = hsv(length(a));
   titlestr = strcat('$L_\infty$ Error in Time($\beta = ',num2str(betavec(i)),')$');
   for j = 1:length(a)
       u = load(a(j).name);
       semilogy(1:length(u),u,'linewidth',1.5,'Color',colorVec(j,:));
       hold on
   end
   xlabel('Number of Time Steps Taken')
   ylabel('$L_\infty$ Error','interpreter','latex')
   title(titlestr,'Interpreter','latex')
   set(gca,'fontsize',18);
   xlim([0,100])
   filname=strcat('finalplot_',num2str(i));
   print(filname,'-dpng')
end
exit