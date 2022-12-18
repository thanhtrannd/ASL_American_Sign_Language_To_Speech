function [dataOut, Info] = image_resize_pipeline(dataIn, Info)  
    dataOut = cell([size(dataIn,1),2]);
    for i=1:size(dataIn,1)
        
        temp = dataIn{i};
        
        % Resize
        temp = imresize(temp, [224 224]);
        dataOut(i,:) = {temp, Info.Label(i)};
    end

end