function [dataOut, Info] = image_add_noise_pipeline(dataIn, Info)  
    dataOut = cell([size(dataIn,1),2]);
    threshold = 0.7;

    for i=1:size(dataIn,1)
        
        temp = dataIn{i};

        % Translate
        add_translation = rand() < threshold;
        if add_translation
            pixelRange = [-randi([1,15],1,1) randi([1,15],1,1)];
            temp = imtranslate(temp,pixelRange);
        end

        % Add randomized motion blur
        add_blur = rand() < threshold;
        if add_blur
            h = fspecial('motion', randi([1,10],1,1), randi([1,10],1,1));
            temp = imfilter(temp,h);
        end
        
        % Add gaussian noise
        add_noise = rand() < threshold;
        if add_noise
            temp = imnoise(temp,"gaussian");
        end

        % Resize
        temp = imresize(temp, [224 224]);
        dataOut(i,:) = {temp, Info.Label(i)};
    end

end