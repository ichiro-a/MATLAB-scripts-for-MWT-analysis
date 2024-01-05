clearvars 
fname = "sb";
strains = {'wt','flp1'};%'wt_ctrl','wt_egl3','wt_flp1',
colors = {'#0072BD','#D95319','#EDB120','#7E2F8E',...
    '#77AC30','#4DBEEE','#A2142F','#FF00FF'};
colors2 = {[0,0.6705,1],[1,0.4875,0.1470],[1,1,0.1875],[0.7410,0.2760,0.8340],[0.6990,1,0.2820],[0.4515,1,1],[0.9525,0.1170,0.2760],[1,0,1]};
stNum = length(strains);
AA = cell(1,stNum);
SEM = cell(1,stNum);
for i=1:stNum
AA{1,i} = readtable(strcat("mean_",strains{i},".csv"));
SEM{1,i} = readtable(strcat("SEM_",strains{i},".csv"));
end

close all
P1 = get(0,'ScreenSize'); %% Screen size
figure('Position', [1 1 360 100],'DefaultAxesFontSize',6) %% window with P1 size
for k = 1:2
    set(subplot(1,2,k),'NextPlot','add')
    set(subplot(1,2,k),'XTick',0:300:1500)
    xlim([600 1200]);
end
for i =1:stNum
x = AA{1,i}.time;
subplot(1,2,1);
errorbar(x,AA{1,i}.speed,SEM{1,i}.speed,'LineStyle','none','CapSize',0,'Color',colors2{i})
rectangle('position',[900 0 120 0.01], 'FaceColor', 'red', 'EdgeColor','red');

subplot(1,2,2);
errorbar(x,AA{1,i}.curve,SEM{1,i}.curve,'LineStyle','none','CapSize',0,'Color',colors2{i})
rectangle('position',[900 20 100 2], 'FaceColor', 'red', 'EdgeColor','red');
end
for i =1:stNum
x = AA{1,i}.time;
subplot(1,2,1);
plot(x,AA{1,i}.speed,'Color',colors{i})
ylabel('Speed (mm/sec)')
ylim([0 0.2])

subplot(1,2,2);
plot(x,AA{1,i}.curve,'Color',colors{i})
ylabel('Body bending (deg)')
ylim([20 50])
end

% legend(strains,'location','southwest','Interpreter','none')
% print('on_off.emf','-dmeta')
savefig(strcat(fname,".fig"))