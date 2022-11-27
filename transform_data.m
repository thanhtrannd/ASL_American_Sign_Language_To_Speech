load Xtrain_SIFTPoints.mat

nXtrain = size(Xtrain_SIFTPoints, 1);

Xtrain_SIFTPoints_norm = min_max_normalize(Xtrain_SIFTPoints);
Xtrain_SIFTPoints_var_name = {'SP1x','SP1y','SP2x','SP2y','SP3x','SP3y','SP4x','SP4y','SP5x','SP5y'};

Xtrain_SIFTPoints_table = array2table(Xtrain_SIFTPoints_norm,'VariableNames',Xtrain_SIFTPoints_var_name);

save dataXtrain_SIFTPoints_table.mat Xtrain_SIFTPoints_table

% To be done when the second extracted dataset ready
% Xtrain_nMatchedFeatures = zeros(nXtrain,10);
% Xtrain_nMatchedFeatures_var_name = {'MFK','MFL','MFM','MFN','MFO','MFP','MFQ','MFR','MFS','MFT'};
% Xtrain_nMatchedFeatures = array2table(Xtrain_nMatchedFeatures,'VariableNames',fullvarname);
% 
% Xtrain_features = [Xtrain_SIFTPoints_table Xtrain_nMatchedFeatures];


function out = min_max_normalize(data)
    nCoordinates = size(data,2);
    nPoints = nCoordinates / 2;
    x_cols = 1:2:nCoordinates;
    y_cols = 2:2:nCoordinates;
    
    min_x = min(data(:,x_cols), [], 2);
    min_y = min(data(:,y_cols), [], 2);

    max_x = max(data(:,x_cols), [], 2);
    max_y = max(data(:,y_cols), [], 2);
    

    size(min_x)
    size(min_y)



    min_xy_rep = repmat([min_x min_y], 1, nPoints);
    size(min_xy_rep)

    max_xy_rep = repmat([max_x max_y], 1, nPoints);
    size(max_xy_rep)


    out = (data-min_xy_rep)./(max_xy_rep-min_xy_rep);
end