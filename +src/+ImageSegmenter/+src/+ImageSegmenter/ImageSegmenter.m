classdef ImageSegmenter
    
    properties (Access = private)
        resultsWriter;
        hist_eq_bins = 64; % default value of histeq function
    end

    methods
        function obj = ImageSegmenter(resultsWriter)
            % resultsWriter is a resultsWriter object for writing results
            % to file
            obj.resultsWriter = resultsWriter;
        end

        function obj = updateHistEqBins(obj,n)
            obj.hist_eq_bins = n;
        end

        function segmented_image = segmentImage(obj,image,image_name)
            % FIXME: Make these imports relative to root directory of script
            % where instantiated object is being used. FIXME comment left
            % as a reminder.
            import src.ImageSegmenter.src.Utils
            import src.ImageSegmenter.src.interpolate
            import src.ImageSegmenter.src.overlay
            
            fprintf("Segmenting image\n");

            %%% Convert to grayscale
            image_gray = im2gray(image);
            image_string = strcat(Utils.IMAGE_GRAY,Utils.UNDERSCORE,image_name,Utils.PNG);
            obj.resultsWriter.writeImage(image_gray,image_string);

            %%% Equalize contrast
            image_equalized = histeq(image_gray,obj.hist_eq_bins);
            image_string = strcat(Utils.IMAGE_EQUALIZED,Utils.UNDERSCORE,image_name,Utils.PNG);
            obj.resultsWriter.writeImage(image_equalized,image_string);

            %%% Sharpen image
            image_sharpened = imsharpen(image_equalized,'Radius',2','Amount',2,'Threshold',0.9);
            image_string = strcat(Utils.IMAGE_SHARPENED,Utils.UNDERSCORE,image_name,Utils.PNG);
            obj.resultsWriter.writeImage(image_sharpened,image_string);

            %%% Apply wiener filter to 3x3 neighborhood
            image_wiener = wiener2(image_sharpened,[3,3]);
            image_string = strcat(Utils.IMAGE_WIENER,Utils.UNDERSCORE,image_name,Utils.PNG);
            obj.resultsWriter.writeImage(image_wiener,image_string);

            %%% Adjust intensity values based off stddev and mean
            n = 0.1;
            image_double = im2double(image_wiener);
            avg = mean2(image_double);
            sigma = std2(image_double);
            image_adjust = imadjust(image_wiener,[avg-n*sigma,avg+n*sigma],[]);
            image_string = strcat(Utils.IMAGE_ADJUSTED,Utils.UNDERSCORE,image_name,Utils.PNG);
            obj.resultsWriter.writeImage(image_adjust,image_string);

            %%% Gaussian filter image
            image_gauss = imgaussfilt(image_adjust,1);
            image_string = strcat(Utils.IMAGE_GAUSS,Utils.UNDERSCORE,image_name,Utils.PNG);
            obj.resultsWriter.writeImage(image_gauss,image_string);

            %%% Image close gaussian image
            [rows,cols] = size(image);
            image_closed = imclose(image_gauss,strel('line',ceil(cols/16),0));
            image_string = strcat(Utils.IMAGE_CLOSED,Utils.UNDERSCORE,image_name,Utils.PNG);
            obj.resultsWriter.writeImage(image_closed,image_string);

            %%% Binarize opened image
            image_binarized = imbinarize(image_closed,'adaptive','ForegroundPolarity','bright','Sensitivity',0.6);
            image_string = strcat(Utils.IMAGE_BINARIZED,Utils.UNDERSCORE,image_name,Utils.PNG);
            obj.resultsWriter.writeImage(image_binarized,image_string);

            %%% Interpolate binarized image
            segmented_image = interpolate(image_binarized);
            image_string = strcat(Utils.IMAGE_SEGMENTED,Utils.UNDERSCORE,image_name,Utils.PNG);
            obj.resultsWriter.writeImage(segmented_image,image_string);

            %%% Overlay segmented image
            image_overlay = overlay(segmented_image,image);
            image_string = strcat(Utils.IMAGE_OVERLAY,Utils.UNDERSCORE,image_name,Utils.PNG);
            obj.resultsWriter.writeImage(image_overlay,image_string);


        end
    end

end
