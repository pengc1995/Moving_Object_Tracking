%% Create foreground detector object
detector = vision.ForegroundDetector(...
    'NumTrainingFrames', 20, ...
    'InitialVariance', 50*50);

%% Read in video file
reader = vision.VideoFileReader('atrium.mp4', ... %atrium.mp4
    'VideoOutputDataType', 'uint8');

%% Create object for blob analysis
blob = vision.BlobAnalysis('MinimumBlobArea', 700);

%% Set up video player
player  = vision.DeployableVideoPlayer;

%% Foreground detection

%create loop to run through video
while ~isDone (reader)
    %load next frame
    frame = step(reader);
    %create foreground mask
    fgMask = step(detector, frame);
    %find bounding box
    [~,~,bbox] = step(blob, fgMask);
    %insert bounding box in frame
    J = insertShape(frame, 'rectangle', bbox);
    %update video player
    step(player, J);
end

%% Clean up
release(detector);
release(reader);
release(blob);
release(player);