classdef ImageCropper
    % Class to crop image

    methods
        function obj = ImageCropper()

        end

        function [outputImage,dimensions] = cropImage(obj,input_image)
            % allows user to specify crop location until satisfied
            % returns cropped image and dimensions of cropped iamge
            % dimensions.rows: number of rows in cropped image
            % dimensions.cols: number of cols in cropped image

            crop_string = '\nCrop image? 1: yes, 2: no \n(default NO, just hit enter):';
            cropyn=input(crop_string);  % cropyn is crop_yes_no
            % if cropyn = 1, crop image, ask user for crop size
            % if cropyn = 2, don't crop image (default case if user just hits enter) 

            %%% set cropyn to default case if user presses enter with no
            %%% input
            if isempty(cropyn)
                cropyn = 2;
            end

            confirmCrop = 2;
            while confirmCrop == 2

                %%% Display uncropped image
                close all
                imshow(input_image)

                %%% Manually crop photo
                [outputImage, rectout] = imcrop(input_image);

                %%% Show cropped image
                imshow(outputImage);

                %%% Confirm crop
                confirm_string = 'Confirm crop? 1: yes, 2: no: ';
                confirmCrop = input(confirm_string);
            end

            [rows, cols] = size(outputImage);
            dimensions.rows = rows;
            dimensions.cols = cols;

        end
    end

end