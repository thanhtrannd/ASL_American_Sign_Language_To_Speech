function bestnMatches = get_best_nMatchedFeatures(I, visual)
    load templates.mat Xtemplates_filename Ytemplates
    if nargin  < 3
        visual = false;
    end
    
    nTemplates = length(Ytemplates);
    for f =  1:nTemplates
        T_filename = Xtemplates_filename{f}
    end
    

    function nMatchedFeatures = match_feature(I, T, visual)
        % I and T must be grayscale image data matrices
        
        
        if isa(I, "string")  % Assume value is path to image file
            I = rgb2gray(imread(I));
        end
        
        if isa(T, "string")  % Assume value is path to image file
            T = rgb2gray(imread(T));
        end
    
    %     I_orb = detectORBFeatures(I,'ScaleFactor',1.01,'NumLevels',3);
    %     T_orb = detectORBFeatures(T,'ScaleFactor',1.01,'NumLevels',3);
    
        I_orb = detectSURFFeatures(I);
        T_orb = detectFASTFeatures(T);
        
        [I_features, I_validPoint] = extractFeatures(I,I_orb);
        [T_features, T_validPoint] = extractFeatures(T,T_orb);
    
        idxPairs = matchFeatures(I_features,T_features);
        
        if visual
            I_matchedPoints = I_validPoint(idxPairs(:,1),:);
            T_matchedPoints = T_validPoint(idxPairs(:,2),:);
            
            figure;
            showMatchedFeatures(I, T, I_matchedPoints, T_matchedPoints, 'montage');
            title('Putatively Matched Points (Including Outliers)');
        end
    
        nMatchedFeatures = size(idxPairs,1);
    end

end