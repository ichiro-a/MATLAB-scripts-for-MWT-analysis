%This script outputs mean values of multiple recordings for one strain and plots mean and individual values.
%Names of strains have to be manually specified.
%Use sequentially 'Chore_rev_concat.m' (-> 'Plot_3.m') -> 'PlotAveIdv2.m' -> 'PlotStrains3.m '

clearvars
close all
strains = {'wt','flp1'};%,'flp1','egl3','egl21'

stNum = length(strains);
cd dat
folderInfo = dir('*.csv');
fileNames = {folderInfo.name}.';
A(:,1) = {'strains','n','fileList','Sum','SEM','Mean'};
A(1,2:stNum+1) = strains;
for i = 1:stNum
    A(3,i+1) = {fileNames(contains(fileNames,strains(i),'IgnoreCase',true))}; %file list
    A(2,i+1) = {size(A{3,i+1},1)};                               % Sample number of each strain
end
t = readtable(char(A{3,2}(1)));
varNames = t.Properties.VariableNames;
max = max(cell2mat(A(2,2:stNum+1)));
%Cube(1,stNum) = 0
for i = 1:stNum
    Cube{1,i} = zeros([size(table2array(t)) A{2,i+1}]);
    Any{1,i} = zeros([size(table2array(t)) A{2,i+1}]);
    for j = 1:A{2,i+1}                                      % Sample number of each strain
        A{j+6,i+1}= readmatrix(A{3,i+1}{j});                % Read each measurement
        Cube{1,i,j} = A{j+6,i+1};
        A{j+6,i+1} = array2table(A{j+6,i+1},'VariableNames',varNames);
    end
    C = cell2mat(Cube(1,i,:));
    A{4,i+1} = sum(C,3);     %Sum
    A{6,i+1} = array2table(mean(C,3,'omitnan'),'VariableNames',varNames); %Mean
    A{5,i+1} = array2table(std(C,0,3)./sqrt(sum(~isnan(C),3)),'VariableNames',varNames); %SEM
    cd ..
    fname = strcat("mean_",strains(i),".csv");
    fname2 = strcat("SEM_",strains(i),".csv");
    writetable(A{6,i+1},fname);
    writetable(A{5,i+1},fname2);
    cd dat
end
close all
P1 = get(0,'ScreenSize'); %% Screen size

for i = 1:stNum
    figure('Position', P1,'DefaultAxesFontSize',16) %% window with P1 size
    for k = 1:12
        set(subplot(4,3,k),'NextPlot','add')
        set(subplot(4,3,k),'XTick',[0:300:2400])
    end
    
    for j = 1:A{2,i+1}+1
        x = A{5+j,i+1}.time;
subplot(4,3,1);
plot(x,A{5+j,i+1}.goodnumber)
ylabel('Animal number')

subplot(4,3,2);
plot(x,A{5+j,i+1}.speed)
ylabel('Speed (mm/sec)')
ylim([0 0.2])

subplot(4,3,3);
plot(x,A{5+j,i+1}.bias)
ylabel('Bias f=1 & r=-1')

subplot(4,3,4);
plot(x,A{5+j,i+1}.angular)
ylabel('Angular speed (deg/sec)')

subplot(4,3,5);
plot(x,A{5+j,i+1}.crab)
ylabel('Crab (mm/sec)')

subplot(4,3,6);
plot(x,A{5+j,i+1}.straightness)
ylabel('straightness')
ylim([0.95 1])

subplot(4,3,7);
plot(x,A{5+j,i+1}.curve)
ylabel('Curve (deg)')
ylim([20 50])

subplot(4,3,8);
plot(x,A{5+j,i+1}.length)
ylabel('Length (mm)')

subplot(4,3,9);
plot(x,A{5+j,i+1}.width)
ylabel('Width (mm)')

subplot(4,3,10);
plot(x,A{5+j,i+1}.kink)
ylabel('Kink (deg)')

subplot(4,3,11);
plot(x,A{5+j,i+1}.midline)
ylabel('Length along midline (mm)')

subplot(4,3,12);
plot(x,A{5+j,i+1}.Morphwidth)
ylabel('Width of central 60% (mm)')
end
l = strcat(strains{i}," ave");
legend(l,'1', '2','3','4','Interpreter','none');
fname3 = strcat(strains{i},".fig");
savefig(fname3)
% print(fname3,'-dmeta')
end
cd ..