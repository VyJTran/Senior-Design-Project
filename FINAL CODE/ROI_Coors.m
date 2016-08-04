function [ roiCoordinates ] = ROI_Coors( loc_array )
%ROI_Coors Summary is shown below:
%The main purpose of this function is to calculate ROI coordinates with
%simple arictmitic 
% The location array has values of: [xmin ymin width height]
% The ROI cooridnates will be a square of 11x11
% xmin and ymin represent pixil values of the bottom left of the square
% the algo goes and calculates a new array with all four coordinate points
% it goes travels counterclockwise 
% roiCoordinates will be a cell that stores all the coordiantes per ROI
% the structure of the cell will be: LFH MFH RFH LH MH RH

roiCoordinates = cell(6,1); %a cell to store all ROI coordinates

pair_coor = []; % a temporary array to store all four coordinates for each ROI
for i = 1 : size(loc_array,1)
   pair_coor = [loc_array(i,1), loc_array(i,2); %bottom left corner of square
               loc_array(i,1), (loc_array(i,2) - loc_array(i,3)); %upper left corner of square
               (loc_array(i,1) + loc_array(i,3)), (loc_array(i,2) - loc_array(i,3)); %upper right corner of square
               (loc_array(i,1) + loc_array(i,3)), loc_array(i,2)]; %bottom right corner of square
         
   roiCoordinates{i,1} = pair_coor;
   clear pair_coor;
end

end

