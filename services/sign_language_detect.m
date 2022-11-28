function Ypred = sign_language_detect(image, visual)
    
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
    SIFT_points = bound_key_region(I, visual);
    SUFT_Counts = get_best_nMatchedFeatures(I, visual);

    % EXTRACTED DATA TRANSFORMATION
    SIFT_points_table = load_data_and_transform_to_table(SIFT_points, 'SIFT_points', SIFT_Points_var_name, true);
    SUFT_Counts_table = load_data_and_transform_to_table(SUFT_Counts, 'SUFT_Counts', SUFT_Counts_var_name, false);
    I_extracted = [SIFT_points_table SUFT_Counts_table];
    
    % Discretization
    load services\engine.mat

    I_arr = table2array(I_extracted);
    I_arr(:,end+1) = 0;   % initialize
    nCol = size(I_arr,2);
    I_arr_descrt = zeros(size(I_arr));
    
    for i = 1:length(I_arr(1,1:end-1))
        idxSeg = find(I_arr(i) < seg_mat(:,i),1);
        if isempty(idxSeg)
            idxSeg = nseg;
        end
        I_arr_descrt(i) = idxSeg-1;
    end

    % BAYESIAN NETWORK PREDICTION
    
    
    evidence     = [];
    evidence     = cell(1,nCol);
    
    for i = 1:nCol-1
       evidence{variable(i).node} = I_arr_descrt(i);
    end
    [engine, logLikelihood] = enter_evidence(engine, evidence);
    marginal       = marginal_nodes(engine, variable(end).node);
    totProb        = sum(marginal.T(:));
    pre.M = marginal.T ./ totProb;
    [~, Ypred] = max(pre.M);
    
    % Get class
    class_list = ["K", "L", "M", "N", "O", "P", "Q", "R", "S", "T"];
    Ypred = class_list(Ypred);