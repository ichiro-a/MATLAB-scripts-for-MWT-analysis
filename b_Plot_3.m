%%Plot of elements
clearvars

folderInfo = dir();
folderInfo = folderInfo(~ismember({folderInfo.name}, {'.', '..','xlsx'}));
folderList = folderInfo([folderInfo.isdir]);
Tf = struct2table(folderList);
fNum = length(Tf.name);
if ~ismember('dat',{folderList.name})
    mkdir dat
end
varNames2 = {'rTime','time','frame','number','goodnumber','persistence','speed',...
            'speed_number','speed_std','angular','length','width',...
            'Morphwidth','midline','kink','pathlen','curve','id','bias',...
            'direction','crab','Custom'};   
P1 = get(0,'ScreenSize'); %% Screen size 
for i = 1:fNum
    cd(Tf.name{i})
    clearvars('datFile','d','DataLength','culNum')%,'size'
    datFile = dir('*.dat');
    if length(datFile) >= 1
        d = readmatrix(datFile.name,'DecimalSeparator','.');    %Specify decimal separator
        d = [round(d(:,1),0) d];                % Add round(t)
        %size = size(d);
        DataLength = size(d,1); 
        culNum = size(d,2);
        for j = 1:(DataLength -1)
            if d(j + 1, 1) == d(j, 1)           % Purging redundant rows
                d(j + 1,:) = [];
                j = j -1;
            elseif d(j + 1, 1) - d(j, 1) >= 2   % Adding empty rows where rows are missing
                addedRow = [(j +1) (j + 1) repmat(NaN,1,(culNum - 2))];
                d = [d; addedRow];
                d = sortrows(d,2);
                j = j -1;
            end
        end
        Data = array2table(d,'VariableNames',varNames2);
        pathlenPerWorm = Data.pathlen./Data.goodnumber;
        straightness = (sqrt(Data.speed.^2 - Data.crab.^2)./Data.speed);
        Data = addvars(Data,pathlenPerWorm,straightness);           % Adding two variables
        
    %%%%%Saving outputs
    curFolder = strsplit(pwd,'\');
    datFileSp = strsplit(datFile.name,'_');
    if length(datFileSp{1}) == 1
        datFile.name = strcat("0",datFile.name);
    end
    fname = strcat(curFolder{end},"_",replace(datFile.name,".dat",".csv"));
    cd ..\dat
    writetable(Data,fname);
    
    %Plot
        close all
%         figure('Position', P1,'DefaultAxesFontSize',16) %% P1 size 
%     
%     x = Data.time;
%     subplot(4,3,1);
%     plot(x,Data.goodnumber)
%     ylabel('Animal number')
% 
%     subplot(4,3,2);
%     plot(x,Data.speed)
%     ylabel('Speed (mm/sec)')
%     ylim([0 0.2])
% 
%     subplot(4,3,3);
%     plot(x,Data.bias)
%     ylabel('Bias f=1 & r=-1')
% 
%     subplot(4,3,4);
%     plot(x,Data.angular)
%     ylabel('Angular speed (deg/sec)')
%     ylim([0 20])
% 
%     subplot(4,3,5);
%     plot(x,Data.crab)
%     ylabel('Crab (mm/sec)')
% 
%     subplot(4,3,6);
%     plot(x,Data.straightness)
%     ylabel('Straightness')
% 
%     subplot(4,3,7);
%     plot(x,Data.curve)
%     ylabel('Body bending (deg)')
%     ylim([20 50])
% 
%     subplot(4,3,8);
%     plot(x,Data.length)
%     ylabel('Length (mm)')
% 
%     subplot(4,3,9);
%     plot(x,Data.width)
%     ylabel('Width (mm)')
% 
%     subplot(4,3,10);
%     plot(x,Data.kink)
%     ylabel('Kink (deg)')
% 
%     subplot(4,3,11);
%     plot(x,Data.midline)
%     ylabel('Length along midline (mm)')
% 
%     subplot(4,3,12);
%     plot(x,Data.Morphwidth)
%     ylabel('Width of central 60% (mm)')
    
%     savefig(replace(fname,".csv",".fig"));
    %print(replace(fname,".csv",".emf"),'-dmeta')
    end
    cd ..
end