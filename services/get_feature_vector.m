function sample = get_feature_vector(I_RGB)

% INPUT: RGB IMAGE
% OUTPUT: FEATURE VECTOR



% Read the Image
%I_RGB = imread('A1.jpg');

%% Sample array contains the features

sample = zeros(1,18);

%% Feature No.1, No.2, No.3 => Mean of RGB Channels
% 
% mean_rgb = avgpict(I_RGB);
% 
% sample(1)=mean_rgb(1);
% sample(2)=mean_rgb(2);
% sample(3)=mean_rgb(3);

%% Feature No.4 Number of edge pixels Using "Canny Edge Detector"

I = rgb2gray(I_RGB);
% Performing edge detection using canny

bw = edge(I,'canny');

region = regionprops(bw);  %test
% Plotting the boundingbox
figure;
imshow(bw); hold on;
for k = 1 : length(region)
  thisBB = region(k).BoundingBox;
  rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
  'EdgeColor','r','LineWidth',2 );
end
legend
hold off;


% visualization
figure;
imshow(bw)
title('Canny Filter')
%%%%%%
numberOfBins = 256;
[r, cl, x] = size(bw);
[pixelCount, grayLevels] = imhist(bw);
count_edge_pixels = pixelCount(2)
sample(4)=count_edge_pixels;

%% Feature No.5 Contrast of Image

image_contrast = max(I(:)) - min(I(:));
sample(5)=image_contrast;

%% Feature No.6, 7 Skewness, Kurtosis

[pixelCounts GLs] = imhist(I);

[skew , kurtosis] = GetSkewAndKurtosis(GLs, pixelCounts)

sample(6)=skew;
sample(7)=kurtosis;

% Binarizing the image by using graythresh

figure;
imhist(I);
level = graythresh(I);
BW = imbinarize(I,level);
% Inverting the image

BW = ~BW;

CC = bwconncomp(BW);
disp(CC)

figure;
imshowpair(I,BW,'montage');

%stats = regionprops(CC)


%% Feature No.8, 9, 10 => Area, Centroid, BoundingBox


measurements = regionprops(CC);

sample(8)=measurements(1).Area;
sample(9)=measurements(1).Centroid(1);
sample(10)=measurements(1).Centroid(2);
sample(11)=measurements(1).BoundingBox(1);
sample(12)=measurements(1).BoundingBox(2);
sample(13)=measurements(1).BoundingBox(3);
sample(14)=measurements(1).BoundingBox(4);

% Plotting the boundingbox
for k = 1 : length(measurements)
  thisBB = measurements(k).BoundingBox;
  rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
  'EdgeColor','r','LineWidth',2 );
end


%% Feature No. 11 Extracting SIFT Features

SIFT_points = detectSIFTFeatures(I)

sample(10)==SIFT_points.Scale;
figure
imshow(I);
hold on;
plot(SIFT_points.selectStrongest(10))

%%  Feature No. 12 Extracting ORB Features

ORB_points = detectORBFeatures(I,'ScaleFactor',1.01,'NumLevels',3);

figure;
imshow(I)
hold on
plot(ORB_points)
hold off

%% Feature No. 13 Extracting SURF Features

SURF_points = detectSURFFeatures(I);
figure;
imshow(I); hold on;
plot(SURF_points.selectStrongest(10));


%% Function to get average of all the channels
function avgrgb=avgpict(img)

    pict=double(img);% convert it to double for calculations
    dim=size(pict); %determine the dimension of the pict
    count=0;meanR=0;meanG=0;meanB=0;%preallocations
    for i=1:dim(1)
        for j=1:dim(2)
            meanR=meanR+pict(i,j,1);
            meanG=meanG+pict(i,j,2);
            meanB=meanB+pict(i,j,3);
            count=count+1;
        end
        meanR1=meanR/count;
        meanG1=meanG/count;
        meanB1=meanB/count;
    end
    avgrgb=[meanR1,meanG1,meanB1] %prints the rgb average value
end

%% Function to get Skewness Kurtosis
function [skew , kurtosis] = GetSkewAndKurtosis(GLs, pixelCounts)
  try
    % Get the number of pixels in the histogram.
    numberOfPixels = sum(pixelCounts);
    % Get the mean gray lavel.
    meanGL = sum(GLs .* pixelCounts) / numberOfPixels;
    % Get the variance, which is the second central moment.
    varianceGL = sum((GLs - meanGL) .^ 2 .* pixelCounts) / (numberOfPixels-1);
    % Get the standard deviation.
    sd = sqrt(varianceGL);
    % Get the skew.
    skew = sum((GLs - meanGL) .^ 3 .* pixelCounts) / ((numberOfPixels - 1) * sd^3);
    % Get the kurtosis.
    kurtosis = sum((GLs - meanGL) .^ 4 .* pixelCounts) / ((numberOfPixels - 1) * sd^4);
  catch ME
    errorMessage = sprintf('Error in GetSkewAndKurtosis().\nThe error reported by MATLAB is:\n\n%s', ME.message);
    uiwait(warndlg(errorMessage));
    set(handles.txtInfo, 'String', errorMessage);
  end
  return; % from GetSkewAndKurtosis
end

end