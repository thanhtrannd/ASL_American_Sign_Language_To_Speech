function [SIFT_points, Icropped] = bound_key_region(I, visual)
    if length(size(I)) > 2
        I = rgb2gray(I);
    end
    if nargin < 2
        visual = false;
    end
    
    nSIFTPoints = 5;

    % Performing edge detection using canny
    bw = edge(I,'canny');

    regions = regionprops(bw);
    nRegions = length(regions);
    % Extracting ORB Features
    ORB_points = detectORBFeatures(I,'ScaleFactor',1.01,'NumLevels',3);

    nPoints = length(ORB_points);
    % Selecting bounding box
    rank = zeros(1, nRegions);
    BB_S = [];
    for i = 1:nRegions
        BB = regions(i).BoundingBox;
        S = BB(3) * BB(4);
        BB_S = [BB_S S];

        inside_points = zeros(1, nPoints);
        for p = 1:nPoints
            is_inside = is_inside_rectangle(ORB_points(p).Location, BB(1), BB(2), BB(3), BB(4));
            inside_points(p) = is_inside;
        end

        nPointsInside = sum(inside_points);
        rank(i) = nPointsInside;
    end
    rank
    rate = 0.9;
    all_points_BB = [];
    min_rate = 0.7;
    while isempty(all_points_BB)
        all_points_BB = find(rank >= rate * nPoints);
        if (length(all_points_BB) < 2) && (rate > min_rate)
            all_points_BB = [];
        end
        rate = rate - 0.05;
    end
    [~,selected_BB] = min(BB_S(all_points_BB));
    selected_BB = all_points_BB(selected_BB);
    
    % crop images
    Icropped = imcrop(I, [regions(selected_BB).BoundingBox(1),regions(selected_BB).BoundingBox(2),regions(selected_BB).BoundingBox(3),regions(selected_BB).BoundingBox(4)]);
    
    % SIFT feature detection from cropped image
    SIFT_points_cropped = detectSIFTFeatures(Icropped);
    strongestSIFT_points_cropped = SIFT_points_cropped.selectStrongest(nSIFTPoints);
    
    strongestSIFT_points_cropped_locations = strongestSIFT_points_cropped.Location;
    SIFT_points = reshape(strongestSIFT_points_cropped_locations, [1 size(strongestSIFT_points_cropped_locations,1)*2]);

    % Visualization
    if visual
        figure;
        subplot(1,3,1);
        % Plotting the boundingbox

        imshow(I); hold on;
        for k = 1:nRegions
            thisBB = regions(k).BoundingBox;
            rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
            'EdgeColor','r','LineWidth',2 );
        end
        title("All bounding boxes")
        hold off;
        
        % Plotting selected boundingbox
        subplot(1,3,2);
        imshow(I); hold on;
        plot(ORB_points);
        rectangle('Position', [regions(selected_BB).BoundingBox(1),regions(selected_BB).BoundingBox(2),regions(selected_BB).BoundingBox(3),regions(selected_BB).BoundingBox(4)],...
        'EdgeColor','r','LineWidth',2);
        title("Hand segmentation");
        hold off;

        % Plotting crop image based on selected boundingbox
        subplot(1,3,3);
        imshow(Icropped); hold on;
        plot(strongestSIFT_points_cropped);
        title('Cropped Image');
        hold off;
    end
    
end

function inside = is_inside_rectangle(point, SW_x, SW_y, x_side, y_side)
    inside = 0;

    point_x = point(1);
    point_y = point(2);
    if (point_x >= SW_x) && (point_x <= SW_x + x_side) && (point_y >= SW_y) && (point_y <= SW_y + y_side)
        inside = 1;
    end
end