classdef DataLoader
    % Class to load data

    methods
        function obj = DataLoader()

        end
        
        function image = loadSingleImage(obj,path,image_file)
            image = imread(fullfile(path,image_file));
        end
    end
end