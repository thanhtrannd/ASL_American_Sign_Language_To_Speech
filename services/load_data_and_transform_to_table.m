function Xtable = load_data_and_transform_to_table(data_or_path, varname, table_var_name, normalize)
    if nargin < 4
        normalize = false;
    end
    
    % Check if input is a path to file or loaded data
    if isa(data_or_path, 'string') || isa(data_or_path, 'char')   % assume the string is path to mat data file
        X = load(data_or_path, varname);
        X = X.(varname);
    else
        % varname can be anything
        X = data_or_path;
    end

    
    if normalize
        X = min_max_normalize(X);
    end
    
    Xtable = array2table(X, 'VariableNames', table_var_name);

end

function out = min_max_normalize(data)
    nCoordinates = size(data,2);
    nPoints = nCoordinates / 2;

    x_cols = 1:2:nCoordinates;
    y_cols = 2:2:nCoordinates;
    
    min_x = min(data(:,x_cols), [], 2);
    min_y = min(data(:,y_cols), [], 2);

    max_x = max(data(:,x_cols), [], 2);
    max_y = max(data(:,y_cols), [], 2);
    
    min_xy_rep = repmat([min_x min_y], 1, nPoints);

    max_xy_rep = repmat([max_x max_y], 1, nPoints);

    out = (data-min_xy_rep)./(max_xy_rep-min_xy_rep);
end