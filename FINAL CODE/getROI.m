function [ROI_Coordinates] = getROI(current_time_slot, video_file, t_array, fs)

RGBstartFrame = t_array(current_time_slot)*fs; %represents the starting frame position

image = read(video_file,RGBstartFrame); %the image at the current time frame
figure;imshow(image); %displays current image at current time frame

LFH = imrect(gca, [((size(image,2)/2)-50) 30 11 11]); %left forehead ROI coordinates
MFH = imrect(gca, [(size(image,2)/2) 30 11 11]); %middle forehead ROI coordinates
RFH = imrect(gca, [((size(image,2)/2)+50) 30 11 11]); %right forehead ROI coordinates
LH = imrect(gca, [((size(image,2)/2)-50) 60 11 11]); %left hand ROI coordinates
MH = imrect(gca, [(size(image,2)/2) 60 11 11]); %middle hand ROI coordinates
RH = imrect(gca, [((size(image,2)/2)+50) 60 11 11]); %right hand ROI coordinates

dum_var = 0; %a dummy variable to be used to ask user if position is correct

while dum_var ~= 1
    usr_input = input('Are all ROI selected (Y/N)? ','s');  %ask the user if all ROI coordinates are selected
    if strcmp(usr_input,'Y') || strcmp(usr_input,'y')
        dum_var = 1; %If input is yes, it will break loop and proceed to calculated all coordinates
    end
end

locations = [getPosition(LFH);getPosition(MFH);getPosition(RFH); %creates an array of current ROI coordiantes - note the only known coordinates is the bottom left  (x,y) of the ROI square
            getPosition(LH);getPosition(MH);getPosition(RH)];

ROI_Coordinates = ROI_Coors(locations); %calculates remaining coordinates (x,y) pairs and returns a cell with all coordinates

end

% roipoly(read(readerObj,[RGBstartFrame RGBendFrame]));
% image = read(readerObj,RGBstartFrame);
% figure;imshow(image);
% h = imrect(gca, [1 1 11 11]);
% position = wait(h);
% pos = getPosition(h)

