%This script extracts mean basal speed, arousal, bending angle and increase
%in bending angle.
clearvars
close all
%%Specify values below%%
strains = {'wt','flp1'};%'wt_ctrl','wt_egl3','wt_flp1',
colors = [[0 0.4470 0.7410];[0.8500 0.3250 0.0980];[0.9290 0.6940 0.1250];[0.4940 0.1840 0.5560];...
    [0.4660 0.6740 0.1880];[0.3010 0.7450 0.9330];[0.6350 0.0780 0.1840];[1 0 1];[0.2 0.2 0.2]];
colors2 = {[0,0.6705,1],[1,0.4875,0.1470],[1,1,0.1875],[0.7410,0.2760,0.8340],...
    [0.6990,1,0.2820],[0.4515,1,1],[0.9525,0.1170,0.2760],[1,0.9,1],[0.8,0.8,0.8]};
fName = 'Fig2A';
t = 900; % time of stimulus
% fileNameExtParam = 'Boxplots_200715-16.fig';
% fileNameStat = 'Stat_200715-16.xlsx';
%%
figure('Position', [1,1,800,360],'DefaultAxesFontSize',12)
stNum = length(strains);
cd dat
folderInfo = dir('*.csv');
cd ..
fileNames = {folderInfo.name}.';

B(:,1) = {'strain','speed','bend','v0','dv1','b0','db1'};
    %'v00','dv2',...    'b00','db2',};
B(1,2:stNum+1) = strains;
varNames = B(4:end,1);

for i = 1:stNum
    clearvars fileList fNum
    fileList = fileNames(contains(fileNames,strains(i)));
    fNum = length(fileList);
    cd dat
    for j = 1:fNum
        data = readtable(fileList{j});
        B{2,i+1} = [B{2,i+1} data.speed];
        B{3,i+1} = [B{3,i+1} data.curve];
        B{4,i+1} = [B{4,i+1}; mean(B{2,i+1}(t-120:t-1,j),'omitmissing')];                %v0
        B{5,i+1} = [B{5,i+1}; mean(B{2,i+1}(t:t+120,j),'omitmissing') - B{4,i+1}(j)];  %dv1
        B{6,i+1} = [B{6,i+1}; mean(B{3,i+1}(t-120:t-1,j),'omitmissing')];                %b0
        B{7,i+1} = [B{7,i+1}; mean(B{3,i+1}(t:t+120,j),'omitmissing') - B{6,i+1}(j)];  %db1

    
    end
%     B{6,i+1} = B{5,i+1} - B{4,i+1};                                         %dv2
%     B{10,i+1} = B{9,i+1} - B{8,i+1};                                        %db2
    
    set(subplot(2,stNum,i),'NextPlot','add')
    set(subplot(2,stNum,i+stNum),'NextPlot','add')
    % Plot of raw speed
    subplot(2,stNum,i)
    hold on
    for l = 1:fNum
        plot(B{2,i+1}(:,l),':')
    end
    ylim([0 0.2])
    xticks(0:300:1200)
    title(strains(i),'Interpreter','none')
    
    % Plot of raw bending angle
    subplot(2,stNum,i+stNum)
    for m = 1:fNum
      plot(B{3,i+1}(:,m),':')
    end
    ylim([20 50])
    xticks(0:300:1200)
    hold off
    cd ..

    % Save table of average speed and bending angle
    T = [B{4,i+1} B{5,i+1} B{6,i+1} B{7,i+1}];% B{8,i+1} B{9,i+1} B{10,i+1} B{11,i+1}];
    T = array2table(T,'VariableNames',varNames);
    %fname0 = ;
    writetable(T, strcat("arousal3_", strains(i), ".csv"))
end
savefig(strcat("rawSpeed_", fName, ".fig"))

%% Boxlot
vNum = length(varNames);
BB(stNum+1).name = 'concat';
for i=1:stNum
    BB(i).name = strains(i);
    BB(i).table = readtable(strcat("arousal3_",strains(i),".csv"));
    BB(i).length = length(BB(i).table.v0);
    BB(i).g = repmat(strains(i),BB(i).length,1);                    %group
    BB(stNum+1).table = vertcat(BB(stNum+1).table, BB(i).table);    %concatenation
    BB(stNum+1).g = vertcat(BB(stNum+1).g, BB(i).g);                %concatenation
end

TT = horzcat(BB(stNum+1).g, BB(stNum+1).table);
TT.Properties.VariableNames(1) = {'group'};
writetable(TT, 'Arousal3.csv')
%% Boxlot
figure('Position', [1,1,360,200],'DefaultAxesFontSize',6)
for n=1:vNum
set(subplot(2,2,n),'NextPlot','add')
set(subplot(2,2,n),'xlim',[0 3])
end

subplot(2,2,1)
h1 = boxplot(TT.v0,TT.group,'OutlierSize',4,'Colors',colors,'BoxStyle','outline');
outliers = findobj(h1, 'Tag', 'Outliers');
set(outliers, 'MarkerEdgeColor', 'k');
title("Basal speed",'FontSize',6)
for i=1:stNum
scatter(ones(size(BB(i).table.v0))*i + (rand(size(BB(i).table.v0))-0.5)./10, BB(i).table.v0, 4,colors(i,:),'filled')
% scatter(ones(size(BB(i).table.v0))*i + (rand(size(BB(i).table.v0))-0.5)./10, BB(i).table.v0, 4,colors(i,:),'filled')
end
ylabel('mm / sec')
set(gca,'xtick',[])
ylim([0 0.1])
set(gca, 'box', 'off');

subplot(2,2,3)
h3 = boxplot(TT.dv1,TT.group,'OutlierSize',4,'Colors',colors,'BoxStyle','outline');
outliers = findobj(h3, 'Tag', 'Outliers');
set(outliers, 'MarkerEdgeColor', 'k');

title("Acceleration",'FontSize',6)
for i=1:stNum
scatter(ones(size(BB(i).table.dv1))*i + (rand(size(BB(i).table.dv1))-0.5)./10, BB(i).table.dv1,4,colors(i,:),'filled')
end
ylabel('mm / sec')
set(gca,'xtick',[])
ylim([-0.02 0.1])
yline(0,'--')
set(gca, 'box', 'off');

subplot(2,2,2)
h2 = boxplot(TT.b0,TT.group,'OutlierSize',4,'Colors',colors,'BoxStyle','outline');
outliers = findobj(h2, 'Tag', 'Outliers');
set(outliers, 'MarkerEdgeColor', 'k');

title("Basal body bending",'FontSize',6)
for i=1:stNum
scatter(ones(size(BB(i).table.b0))*i + (rand(size(BB(i).table.b0))-0.5)./10, BB(i).table.b0,4,colors(i,:),'filled')
end
ylabel('degree')
set(gca,'xtick',[])
ylim([20 50])
set(gca, 'box', 'off');

subplot(2,2,4)
h4 = boxplot(TT.db1,TT.group,'OutlierSize',4,'Colors',colors,'BoxStyle','outline');
outliers = findobj(h4, 'Tag', 'Outliers');
set(outliers, 'MarkerEdgeColor', 'k');

title("Change in body bending",'FontSize',6)
for i=1:stNum
scatter(ones(size(BB(i).table.db1))*i + (rand(size(BB(i).table.db1))-0.5)./10, BB(i).table.db1,4,colors(i,:),'filled')
end
ylabel('degree')
% ylim([25 50])
set(gca,'xtick',[])
yline(0,'--')
set(gca, 'box', 'off');

% savefig(strcat("boxPlot_", fName, ".fig"))

%% Statistics
P = [];
Param = [];
for n=1:vNum
%     if stNum = 2
        x = TT{contains(TT.group, strains{1}),varNames{n}};
        y = TT{contains(TT.group, strains{2}),varNames{n}};
        [h,p] = ttest2(x,y,'Vartype','unequal');
        P = [P; p];
%     else
        % [p,tb1,stats] = anova1(TT.(varNames{n}),TT.group,'off');
        % [c,m] = multcompare(stats,'Alpha',0.05,'CType','hsd','Display','off');
        % P = [P; c];
%     end
    Param = [Param; repmat(varNames(n),nchoosek(stNum,2),1)];
end
% PP = array2table(P,'VariableNames',{'Strain1','Strain2','LowConf','Est','UpConf','p'});
PP = array2table(P,'VariableNames',{'p'});
len = length(P(:,1));
star = strings(len,1);
for i=1:len
if(P(i,1) < 0.001)
    star(i) = "***";
elseif(P(i,1) < 0.01)
    star(i) = "**";
elseif(P(i,1) < 0.05)
    star(i) = "*";
else
    star(i) = "";
end
end
PP = addvars(PP, star,Param);
writetable(PP, strcat("stat_", fName, ".xlsx"))