function outputImage = interpolate(inputImage)
    outputImage = inputImage;
    filter = 10;
    [numRows,numCols] = size(inputImage);
    
    for r = 1 : numRows
        for c = 1:numCols
            slide = window(r,c,inputImage,filter);
            if slide >= 20
                outputImage(r,c) = power(2,16) - 1;
            else
                outputImage(r,c) = 0;
            end
        end
    end
end

%%% HELPER FUNCTIONS %%%
function ct = window(x,y,image,window_size)
    ct = 0;
    for i = x-1:x+1
        for j = y-window_size:y+window_size
            [numRows, numCols] = size(image);

            if i < 1 || i >= numRows || j < 1 || j >= numCols
                continue;
            elseif image(i,j) >= 1
                    ct = ct + 1;
            end
        end
    end         
end