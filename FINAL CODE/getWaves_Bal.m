function [waves] = getWaves_Bal(filename, roiCoords, roiNames,Frames)
%filename: obvious
%roiCoords: a CELL array of roi's {roiPalm1 roiPalm2 roiForehead}
%roiNames: a CELL array of roi's {"palm1" "palm2" "forehead"}

% the interpolated frequency (at the bottom) must be used in the getPTT
% function after the waves are saved.

RGBstartFrame = Frames.RGBstartFrame;
RGBendFrame = Frames.RGBendFrame;
TotalFrames = RGBendFrame-RGBstartFrame+1;

readerObj = VideoReader(filename);
waveCnt = length(roiCoords);

if (waveCnt ~= length(roiCoords)),
    str = sprintf('#coords: %d  and #names: %d (they need to match)', waveCnt, length(roiCoords));
    disp(str);
    waves = NaN;
else
    BWs = cell(waveCnt);
    for i = 1:waveCnt,
        col = roiCoords{i}(:,1);
        row = roiCoords{i}(:,2);
        Img = read(readerObj,5);
        BW = roipoly(Img, col, row);
        
        BWs{i} = BW;
    end

    % video information
    numFrames = TotalFrames;
    frameRate = readerObj.frameRate;
    duration = TotalFrames/frameRate;
    str = sprintf('framerate(Hz): %d    duration(sec): %d', frameRate, duration);
    disp(str);

    % preallocate memory to save processing time
    greens = zeros(waveCnt,numFrames);
    reverseStr = '';

    % record each frame's total green intensity at each ROI
    cnt = 1;
    for i=RGBstartFrame:RGBendFrame,
        img = read(readerObj, i);
        for j=1:waveCnt,
            greens(j,cnt) = sum(sum( img(:,:,2).*uint8(BWs{j}) ));
        end
        
        % write progress to command window (all on one line):
        msg = sprintf('Processed %d/%d frames', cnt, numFrames);
        fprintf([reverseStr, msg]);
        reverseStr = repmat(sprintf('\b'), 1, length(msg));
        cnt = cnt+1;
   end
    fprintf('\n');
    reverseStr = '';
    
    % a function to put the wave between -1 and 1, around the x-axis
    normalize = @(vec) ((vec-min(vec))./(max(vec)-min(vec)) - 0.5 ) * 2;

    % interpolate to ~0.1ms (10000 / frameRate = interpolation factor)
    interpFactor = round(10000/frameRate);
    waves = zeros(waveCnt,numFrames * interpFactor);
    for i=1:waveCnt,
        norm = normalize(greens(i,:));  % normalize to around x-axis
 filtered = filter(myBand,norm); % filter to [0.3Hz 8Hz]
%  gband = filtered;
        %filtered = filter(newBand,norm); % filter to [0.6Hz 5Hz]
        waves(i,:) = interp(filtered, interpFactor);
        
        msg = sprintf('Finished processing wave %d of %d', i, waveCnt);
        fprintf([reverseStr, msg]);
        reverseStr = repmat(sprintf('\b'), 1, length(msg));
    end
    fprintf('\n');
end
% EOF