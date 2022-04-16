classdef ImageAnalyzer
    
    properties (Access = private)
        resultsWriter;
    end
    
    methods
        function obj = ImageAnalyzer(resultsWriter)
            % resultsWriter is a resultsWriter object for writing results
            % to file
            obj.resultsWriter = resultsWriter;
        end
        
        function analyze_image(obj,input_image,image_name)
            % FIXME: Make these imports relative to root directory of script
            % where instantiated object is being used. FIXME comment left
            % as a reminder.
            import src.ImageAnalyzer.src.Utils
            
            fprintf("Analyzing image\n");

            %%% Analysis
            pixel_width = 1;
            [total_gaps, total_bundles] = algorithm(double(input_image),pixel_width);

           %%% transpose results for saving
           total_gaps = total_gaps';
           total_bundles = total_bundles';

           %%% save raw data to excel file
           filename_gaps = strcat(Utils.TOTAL_GAPS,Utils.UNDERSCORE,image_name,Utils.XLSX);
           file_header_gaps = ["#col","gap_thickness"];
           obj.resultsWriter.writeExcelFile([file_header_gaps;total_gaps],filename_gaps);

           filename_bundles = strcat(Utils.TOTAL_BUNDLES,Utils.UNDERSCORE,image_name,Utils.XLSX);
           file_header_bundles = ["#col","bundle_thickness"];
           obj.resultsWriter.writeExcelFile([file_header_bundles;total_gaps],filename_bundles);

           %%% Cacluate mean thickness
           mean_gaps = mean(total_gaps(:,2));
           mean_bundles = mean(total_bundles(:,2));

           %%% Save mean data to excel file
           filename = strcat(Utils.MEANS,Utils.UNDERSCORE,image_name,Utils.XLSX);
           file_header_means = ["#image_name","mean_gap_thickness","mean_bundle_thickness"];
           data_matrix = {image_name,mean_gaps,mean_bundles};
           obj.resultsWriter.writeExcelFile([file_header_means;data_matrix],filename)
           


        end
    end
end

%%% -- Function Declarations ----------------------------------------------
function [total_gaps, total_bundles] = algorithm(analysisImage,column_width)
    total_gaps = [];
    total_bundles = [];
    [rows, columns] = size(analysisImage);

    for j = 1 : column_width : columns
        %%% initialize variables
        start_gap_row = 0;
        end_gap_row = 0;
        top_of_gap_detected = false;
        bottom_of_gap_detected = false;
        start_bundle_row = 0;
        end_bundle_row = 0;
        top_of_bundle = false;
        bottom_of_bundle = false;
        
        % end_of_column is end of column being looked at
        % -1 is because matlab indexing starts at 1
        end_of_column = ceil(floor(j) + column_width - 1); 
        
        
        % if end_of_column is greater than columns,
        % exit loop
        if end_of_column > columns
            break;
        end
        
        for i = 2 : rows
           
             
            previous_pixels = analysisImage(i-1,floor(j):end_of_column);
            current_pixels = analysisImage(i,floor(j):end_of_column);

            %%% if at top of row
            if i == 2
                top_of_gap_detected = false;
                bottom_of_gap_detected = false;
                start_bundle_row = 0;
                end_bundle_row = 0;
                top_of_bundle = false;
                bottom_of_bundle = false;
                start_gap_row = 0;
                end_gap_row = 0;
            end
            
            %%% sum across column
            %%% if NaN in sum, sum will be NaN
            %%% otherwise transition from 0 to >0 is top of gap
            %%% and transition from >0 to 0 is bottom of gap
            previous_sum = sum(previous_pixels);
            current_sum = sum(current_pixels);

            %%% if current pixel is NaN, reset gap detected, go to top of loop
            if is_NaN(current_sum)
                %fprintf("NaN detected: ");
                %fprintf('(%i, %i)\n',i,j);
                top_of_gap_detected = false;
                bottom_of_gap_detected = false;
                start_gap_row = 0;
                end_gap_row = 0;
                start_bundle_row = 0;
                end_bundle_row = 0;
                top_of_bundle = false;
                bottom_of_bundle = false;
                %%% skip to top of loop
                continue;
 
            %%% else if top of gap detected or bottom of bundle
            %%% top of gap is defined as a transition from white to black
            %%% which is transition from >0 to 0
            %%% bottom of bundle is defined as top of gap
            elseif is_zero(current_sum) && is_positive(previous_sum)
                top_of_gap_detected = true;
                start_gap_row = i;
                bottom_of_bundle = true;
                end_bundle_row = i;
                %fprintf('Start of gap detected: ');
                %fprintf('(%i, %i)\n',i,j);
                %fprintf('Bottom of bundle detected: ');
                %fprintf('(%i, %i)\n',i,j)
            %%% else if bottom of gap detected or top of bundle
            %%% bottom of gap is defined as a transition from black to white
            %%% which is transition from 0 to >0
            %%% top of bundle is defined as bottom of gap
            elseif is_positive(current_sum) && is_zero(previous_sum)
                bottom_of_gap_detected = true; 
                end_gap_row = i;
                top_of_bundle = true;
                start_bundle_row = i;
                %fprintf('End of gap detected: ');
                %fprintf('(%i, %i)\n',i,j);
                %fprintf('Start of bundle detected: ');
                %fprintf('(%i, %i)\n',i,j);
            %%% else if middle of gap detected
            %%% middle of gap is degined as transition from black to black
            elseif is_zero(current_sum) && is_zero(previous_sum)
                %%% skip to top of loop
                continue; 
            %%% else if middle of bundle detected
            %%% middle of bundle is defined as transition from white to white
            elseif is_positive(current_sum) && is_positive(previous_sum)
                %%% skip to top of loop
                continue;
            elseif (is_positive(current_sum) || is_zero(current_sum)) && is_NaN(previous_sum)
                %%% reset bundle detected
                top_of_gap_detected = false;
                bottom_of_gap_detected = false;
                start_gap_row = 0;
                end_gap_row = 0;
                start_bundle_row = 0;
                end_bundle_row = 0;
                top_of_bundle = false;
                bottom_of_bundle = false;
                %%% skip to top of loop
                continue;
            end

            %%% if top of gap and bottom of gap have been detected, gap
            %%% thickness found
            if top_of_gap_detected && bottom_of_gap_detected
                %%% calculate gap thickness (height of black region, height of 0s)
                gap_thickness = end_gap_row - start_gap_row;
                %fprintf('Gap of length %i detected\n', gap_thickness);
                %%% append gap_thickness to total_gaps
                total_gaps = [total_gaps, [floor(j); gap_thickness]];

                %%% reset gap detected
                top_of_gap_detected = false;
                bottom_of_gap_detected = false;
                start_gap_row = 0;
                end_gap_row = 0;
                
            %%% else if bottom of gap is found while not the top of gap
            %%% have found a gap of unknnown thickness (edge of image or 
            %%% blood vessel)
            elseif bottom_of_gap_detected && ~top_of_gap_detected
                bottom_of_gap_detected = false;
                start_gap_row = 0;
                end_gap_row = 0;

            %%% else if top of gap is found while not the bottom of gap
            %%% have found a gap of unknown thickness (edge of image or
            %%% blood vessel)
            elseif top_of_gap_detected && ~bottom_of_gap_detected
                top_of_gap_detected = true;
            end
            
            %%% if top of bundle and bottom of bundle have been detected,
            %%% bundle thickness found
            if top_of_bundle && bottom_of_bundle
                %%% Calculate bundle thickness (height of white region,
                %%% height of 1s)
                bundle_thickness = end_bundle_row - start_bundle_row;
                %fprintf('Bundle of length %i detected\n', bundle_thickness);
                %%% append bundle_thickness to total_bundles
                total_bundles = [total_bundles, [floor(j); bundle_thickness]];
                %%% reset bundle detected
                start_bundle_row = 0;
                end_bundle_row = 0;
                top_of_bundle = false;
                bottom_of_bundle = false;
                
            %%% else if top of bundle found while bottom of bundle not
            %%% found, have found a bundle of unknown thickness (edge of
            %%% image or blood vessel)
            elseif top_of_bundle && ~bottom_of_bundle
                continue;
                
                
            %%% else if bottom of bundle found while top of bundle not
            %%% found, have found a bundle of unknown thickness (edge of
            %%% image or blood vessel)
            elseif bottom_of_bundle && ~top_of_bundle
                start_bundle_row = 0;
                end_bundle_row = 0;
                bottom_of_bundle = false;
                
            end
               




        end

    end

end


function with_threshold = apply_threshold(total_gaps, threshold)
    with_threshold = [];
    for i = 1 : length(total_gaps)
        if total_gaps(i,2) > threshold
           data = [total_gaps(i,1), total_gaps(i,2)];
           with_threshold = [with_threshold; data];
        end
    end
end



function gaps = find_elements_greater_than_value(bins,value)
gaps = [];
bin_size = size(bins);
for i = 1:bin_size(1)
    if bins(i) > value
        gaps = cat(1,gaps,bins(i));
    end
end

end

%%% -- Helper functions ---------------------------------------------------
function returnBoolean = is_black(analysisImagePixel)
% Description: returns whether analysisImagePixel is equal to 0 (black)
% Requires: analysisImagePixel to be castable to logical value
    returnBoolean = isequaln(analysisImagePixel,0);
end

function returnBoolean = is_white(analysisImagePixel)
% Description: returns whether analysisImagePixel is equal to 1 (white)
% Requires: analysisImagePixel to be castable to logical value
    returnBoolean = isequaln(analysisImagePixel,1);
end

function returnBoolean = is_NaN(analysisImagePixel)
% Description: returns whether analysisImagePixel is equal to NaN
    returnBoolean = isequaln(analysisImagePixel, NaN);
end

function returnBoolean = is_zero(analysisImageSum)
% Description: returns whether analysisImageSum is equal to 0
    returnBoolean = analysisImageSum == 0;
end

function returnBoolean = is_positive(analysisImageSum)
% Description: returns wheter analysisImageSum is greater than 0
    returnBoolean = analysisImageSum > 0;
end