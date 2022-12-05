function Ypred = sign_language_detect_naivebayes(image, visual)
    
    SIFT_Points_var_name = {'SP1x','SP1y','SP2x','SP2y','SP3x','SP3y','SP4x','SP4y','SP5x','SP5y'};
    SUFT_Counts_var_name = {'MFK','MFL','MFM','MFN','MFO','MFP','MFQ','MFR','MFS','MFT'};

    if nargin < 2
        visual = false;
    end
    
    % Check if input is a path to file or loaded data
    if isa(image, 'string') || isa(image, 'char')
        % assume the string is path to image file
        I_RGB = imread(image);
        I = rgb2gray(I_RGB);
    else
        % varname can be anything
        I = image;
    end
    
    % FEATURE EXTRACTION
%     SIFT_points = bound_key_region(I, visual);
    SUFT_Counts = get_best_nMatchedFeatures(I, visual);

    % EXTRACTED DATA TRANSFORMATION
%     SIFT_points_table = load_data_and_transform_to_table(SIFT_points, 'SIFT_points', SIFT_Points_var_name, true);
    SUFT_Counts_table = load_data_and_transform_to_table(SUFT_Counts, 'SUFT_Counts', SUFT_Counts_var_name, false);
%     I_extracted = [SIFT_points_table SUFT_Counts_table];
    I_extracted = SUFT_Counts_table;

    % Load model and predict
    load services\naiveBayesMdl.mat NBmdl

    Ypred = predict(NBmdl, I_extracted);
    Ypred = convertCharsToStrings(Ypred);

