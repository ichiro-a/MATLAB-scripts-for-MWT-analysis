clearvars

folderInfo = dir();
folderInfo = folderInfo(~ismember({folderInfo.name}, {'.', '..'}));
folderList = folderInfo([folderInfo.isdir]);
Tf = struct2table(folderList);
fNum = length(Tf.name);
if ~ismember('rev',{folderList.name})
    mkdir rev
end

%%Choreography
for i = 1:fNum
    cd(Tf.name{i})
    clearvars('blobsFile','command');
    blobsFile = dir('*.blobs');
    if length(blobsFile) >= 1
        command = strcat("java -Xmx9G -jar C:\Users\ichir\OneDrive\Software\MWT_Tools\MWT\Chore\chore.jar --header -p 0.017 -s 1 -T 1 --shadowless -S --plugin Reoutline::exp --plugin Respine -o tfnNpss#s*SlwMmkPcDbdrC --plugin MeasureReversal::all --plugin SpinesForward --plugin Eigenspine::graphic::data ",pwd);
        system(command)
    end
    cd ..
end

%%Concatenation of .rev files
for i = 1:fNum
    clearvars('revFiles','numFiles','M','T');
    cd(Tf.name{i})
    revFiles = dir('*.rev'); 
    numfiles = length(revFiles);
    if numfiles >=1
        A = [];
        for k = 1:numfiles 
            filename = revFiles(k).name; 
            opts = delimitedTextImportOptions('Delimiter',' ',...
                                    'ConsecutiveDelimitersRule','join',...
                                    'VariableTypes','double',...
                                    'DataLines',1);
                                M = readmatrix(filename,opts);
                                A = [A; M];
        end
        varNames = {'object_id','t_rev','rev_dist','rev_duration'};
        T = array2table(A,'VariableNames',varNames);
        T(1,:) = [];
    
    %%Plotting rev_dist and rev_duration against t_rev
%     close all
%     plot(T.t_rev,T.rev_dist,'LineStyle','none','Marker','.')
%     ylim([0 2])
%     hold on
%     yyaxis right
%     plot(T.t_rev,T.rev_duration,'LineStyle','none','Marker','.')
%     ylim([0 16])
%     hold off
%     legend('rev dist','rev duration')

% Uncomment to delete *.rev files after concatenation
    delete *.rev

    %%Saving outputs
    curFolder = strsplit(pwd,'\');
    revFileSp = strsplit(revFiles(1).name,'_');
    if length(revFileSp{1}) == 1
        revFiles(1).name = strcat("0",revFiles(1).name);
    end
    revFileSp2 = strsplit(revFiles(1).name,'.');
    fname = strcat(curFolder{end},"_",revFileSp2{1},"_rev.csv");
    cd ..\rev
    writetable(T,fname);
    savefig(replace(fname,".csv",".fig"));
%     print(replace(fname,".csv",".emf"),'-dmeta')
    end
    cd ..
end

run('b_Plot_3.m');