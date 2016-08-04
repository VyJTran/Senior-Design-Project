current_directory = cd;
RGBFs = 60;%str2num(input('Enter the sample frequency of video: ','s')); %Hz - sample frequency; 
num_roi = 6;%str2num(input('Enter the total number of ROIs: ','s')); %user chooses the number of roi's per time slot
time_slots = 1;%str2num(input('Enter the number of time slots needed: ','s')); %user chooses the number of time slots needed
sub = str2num(input('Enter the corresponding subject ID: ','s')); %user enters which subject is being dealt with
trial_num = str2num(input('Enter the corresponding trial number: ','s')); %user enter the corresponding trial number 
vid_directory = uigetdir('','Choose Data Directory: '); %current directory of videos
[vid_filename, vid_directory] = uigetfile('*.avi','Enter pulse data file (Skin) ',vid_directory);
cd(vid_directory); %goes to video directory in order to extract video data
readerObj = VideoReader(vid_filename); %reads video file and creates object
cd(current_directory);
%     vid_duration = floor(readerObj.Duration); %total duration of video in seconds; rounds down
%     if (vid_duration/60) >= 3
%         strt_time = 30; %represents where the  start time when we will be looking at first ROI and on
%     else
%         strt_time = 10;
%     end


    
time_array = [1 30]; %round(linspace(strt_time,vid_duration,time_slots));
mat_file_name = strcat('Subject_',num2str(sub),'_trial_',num2str(trial_num),'constant_DATA.mat'); %creates mat-file name where all data will be store

%%
%STEP 1 IS TO GET ROI ARRAYS PER TIME SLOT
%want to semi-automate the 3 square roi of equal area based on chosen
%center point of foreheaad/hand
check = 'y';%input('Are ROI parramenters needed (Y/N):  ','s'); %user input to check if ROI positiones needed
type_check = 'y';%input('Are ROI coordinates being held constant (Y/N)?:  ','s'); %user input check if ROI being help constant or changing over time
if (check == 'Y') || (check == 'y')
    if (type_check == 'Y') || (type_check == 'y')
        for i = 1:1
            roi_coordinates{1,1} = getROI(i, readerObj, time_array, RGBFs); %gets ROI coordinates
        end
    else
        for i = 1:time_slots
            roi_coordinates{1,1} = getROI(i, readerObj, time_array, RGBFs); %gets ROI coordinates
        end
    end
    save(mat_file_name, 'roi_coordinates'); %saves ROI coordinates cell
    close all;
end

%%
%STEP 2 IS TO GET ROI GB WAVES
%matObj = matfile('topography.mat');
%varlist = who(matObj)

roi_gb_waves = cell(time_slots,1);
if (check == 'N') || (check == 'n')
    check = input('Is ROI Coordinates file needed to be uploaded (Y/N)?: ','s');
    if (check == 'Y') || (check == 'y')
        [ROI_file, ROI_path] = uigetfile('*.mat', 'Select ROI Cooridnates mat file: '); 
        cd(ROI_path);
        mat_file = load(ROI_file); %loads corresponding ROI file
        readerObj = mat_file.readerObj;
        roi_coordinates = mat_file.roi_coordinates;
        cd(current_directory);
        %roi_var_name = char(fieldnames(roi_coordinates)); %this represents the label name of the variable for roi cell
    end
end

for i = 1:time_slots
    if (type_check == 'Y') || (type_check == 'y')
        roi_gb_waves{i} = getGBwaves(RGBFs, time_array, roi_coordinates{1,1}, i, readerObj);
        cd(current_directory);
    else
        roi_gb_waves{i} = getGBwaves(RGBFs, time_array, roi_coordinates{1,i}, i, readerObj);
        cd(current_directory);
    end
end

save(mat_file_name,'roi_gb_waves','-append'); %to save greend bands 

%%
%STEP 3 IS GETTING THE SNR VALUES OF EACH ROI

% roi_gb_waves{i} = a 6 x total number of points - a matrix where 1 is left
%roi_gb_waves{1,1} = gets you an array of the gband of that just
%certain roi
% forehead and 6 is right palm roi
SNR_mtrx = [];
counter_one = 1;
counter_two = 7;
fft_gb_cell = cell(num_roi,2); % created to store fft signal and freq array
for i = 1:time_slots
    for j = 1 : num_roi
        if j == 1
            fft_gb_fig(i) = figure(counter_one);
        end
        freq_vect = linspace(-RGBFs/2,RGBFs/2,size(roi_gb_waves{i,1}(j,:),2));
        fft_gb_cell{j,1} = freq_vect;
        figure(counter_one);subplot(2,3,j);
        fft_gb = fftshift(abs(fft(roi_gb_waves{i,1}(j,:))));
        fft_gb_cell{j,2} = fft_gb;
        plot(freq_vect, fft_gb, 'g');
        if j == 1
            gb_fig(i) = figure(counter_two);
        end
        figure(counter_two);subplot(2,3,j);
        plot(roi_gb_waves{i,1}(j,:), 'g');
        [sig_peak_idx, wid_idx] = PeakDetect(roi_gb_waves{i,1}(j,:), freq_vect);
        SNR_mtrx(i,j) = ImSNR(RGBFs, roi_gb_waves{i,1}(j,:), wid_idx, sig_peak_idx);
    end
    counter_two = counter_two + 1;
    counter_one = counter_one + 1;
end

fig_FFT_name = strcat('Subject_',num2str(sub), '_trial_',num2str(trial_num),'_FFT-GBwaves_Figures_.fig');
fig_GB_name = strcat('Subject_',num2str(sub), '_trial_',num2str(trial_num),'_GBwaves_Figures_.fig');

save(mat_file_name, 'fft_gb_cell', '-append');

savefig(fft_gb_fig,fig_FFT_name);
savefig(gb_fig,fig_GB_name);
save(mat_file_name, 'SNR_mtrx', '-append');
save(mat_file_name, 'time_array', '-append');
close all;

%%
%STEP 4 IS TO GET ACTUAL DPTT

% file_waves = uigetfile('*.mat', 'Select GB Waves mat file: ');
% gbWaves = load(file_waves); %loads corresponding ROI file

dPPT_cell = cell(time_slots,2);

total_num_dPPT = 9; % represents the total number of cross validations to get all dPPT of all 6 ROI
num_cross_val = 3; %the cross validation against one forehead against all three 
for i = 1:time_slots
    forehead_strt = 1;
    count = 1;
    dPPT_arr = [];
    while size(dPPT_arr,2) < total_num_dPPT
        palm_strt = 4;
        for j = 1:num_cross_val
            dPPT_arr(1,count) = getPTT_Bal(roi_gb_waves{i,1}(forehead_strt,:), roi_gb_waves{i,1}(palm_strt,:))*1000;
            palm_strt = palm_strt + 1;
            count = count + 1;
        end
        forehead_strt = forehead_strt + 1;
    end
     dPPT_cell{i,1} = dPPT_arr;
     dPPT_cell{i,2} = max(dPPT_cell{i});
end

save(mat_file_name, 'dPPT_cell', '-append');
%%
%Moving files to appropiate designation
data_directory = uigetdir('','Select Data Storage Directory: ');
[s, mess, messid] = movefile(mat_file_name,data_directory);
data_fig_directory = strcat(data_directory,'\Figures');
[s2, mess2, messid2] = movefile(fig_FFT_name,data_fig_directory);
[s3, mess3, messid3] = movefile(fig_GB_name,data_fig_directory);



