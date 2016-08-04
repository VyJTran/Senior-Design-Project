% this function is used to compute the PTT between the two signals

currDir = uigetdir('','Choose Data Dir..');
cd(currDir)
[filename, currDir] = uigetfile('*.avi','Enter pulse data file (Skin) ',currDir);
% filename = 'Sub01_072514.avi';

RGBFs = 59.5; %Hz; 420x300

[a] = findstr(currDir,'_');
sub = str2num(currDir(a+1:a+2));
% sub = str2num(input('enter subject: ','s')); %#ok<*ST2NM>
% TestCase = str2num(input('enter case (1,2,4,6): ','s'));

for TestCase = 1: 12
    if sub == 1 || sub == 2
        % sub1 and sub2
        startTime = [20	30	40	85	95	105	205	215	225	325	335	345]; % each situation after first 20 sec
        endTime = [40	50	60	105	115	125	225	235	245	345	355	365]; % 10 sec
    else
        % %sub3 to sub15
        startTime = [59	69	79	89	167	177	187	197	383	393	403	413	599	609	619	629]; % each situation after first 30 sec
        endTime = [79	89	99	109	187	197	207	217	403	413	423	433	619	629	639	649]; %10 seconds
    end
    
    %ROI file
    [PATHSTR,NAME,EXT] = fileparts(filename);
    saveFileName = sprintf('%s_Case%d.mat',NAME,TestCase);
    currStr = sprintf('load(''%s'')',saveFileName);
    eval(currStr)
    
    td1=(getPTT_Bal(foreL,palmL));
    td2=(getPTT_Bal(foreL,palmM));
    td3=(getPTT_Bal(foreL,palmR));
    td4=(getPTT_Bal(foreM,palmL));
    td5=(getPTT_Bal(foreM,palmM));
    td6=(getPTT_Bal(foreM,palmR));
    td7=(getPTT_Bal(foreR,palmR));
    td8=(getPTT_Bal(foreR,palmM));
    td9=(getPTT_Bal(foreR,palmL));
    
    % remove extra large PTT which is due to the shadow or motion
    PTTs = [td1 td2 td3 td4 td5 td6 td7 td8 td9]*1000;
    
    [x y] = max(PTTs);
    
    % tdSet = {'td1', 'td2', 'td3', 'td4', 'td5', 'td6', 'td7', 'td8', 'td9'};
    tdSet = {'FL_PL', 'FL_PM', 'FL_PR',...
        'FM_PL', 'FM_PM', 'FM_PR',...
        'FR_PL', 'FR_PM', 'FR_PR'};
    
    PTTLocs = tdSet{y};
    PTT(TestCase) = x; % in m secs
    %     keyboard
    % tdavg=(td1+td2+td3+td4+td5+td6+td7+td8+td9)/9;
    % tdavg=(td1+td3+td4+td6+td7+td9)/6;
end

