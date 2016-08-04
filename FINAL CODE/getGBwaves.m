function [waves] = getGBwaves(fs, t_array, ROIcoords, crrnt_t_slot, video_file)
%getGBwaves Summary of this function goes here
%   fs = sample frequency, ROIcoords = the ROI coordinates, 
%   crrnt_t_slot = represents current time slot idx, video_filename = vid file
%   name
%   t_ array = time array 

% if crrnt_t_slot == 6
%     RGBstartFrame = (t_array(crrnt_t_slot - 1) + 2)*fs; %start time
%     RGBendFrame = t_array(crrnt_t_slot)*fs; %to account for not having same start/end time
% else
%     RGBstartFrame = t_array(crrnt_t_slot)*fs; %start time
%     RGBendFrame = (t_array(crrnt_t_slot + 1)-2)*fs; %to account for not having same start/end time
% end

RGBstartFrame =  t_array(crrnt_t_slot)*fs; %start time
RGBendFrame =  t_array(crrnt_t_slot + 1)*fs; %end time

Frames.RGBstartFrame = RGBstartFrame; %start time put in struct frames
Frames.RGBendFrame = RGBendFrame; %end time put in struct frames

ROInames = {'foreL','foreM','foreR','palmL','palmM', 'palmR'}; % a cell of corresponding ROI names 

waveCnt = length(ROIcoords); %get the total number of ROI's within ROI cell
if (waveCnt ~= length(ROInames)),
    str = sprintf('#coords: %d  and #names: %d (they need to match)', waveCnt, length(ROInames));
    disp(str);
else
    % Get the filtered and interpolated pulse waves
    waves = CR_getWaves_Bal(video_file, ROIcoords, ROInames,Frames);
end
    

end