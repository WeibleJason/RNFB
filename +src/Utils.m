classdef Utils
    % Utility class for RNFB_Project main.m
    
    properties (Constant)
        %%% Magic numbers
        new_image_name = 10;

        %%% Symbols
        file_delimeter = '\';
        underscore = '_';

        %%% User prompts
        input_selection = 'Which option would you like to run: ';

        %%% Messages
        readme = 'Results from running: ';

        %%% File Extensions
        dot = '.';
        star_dot = '*.';
        tif = 'tif';
        png = 'png';
        xlsx = 'xlsx';

        %%% File Paths
        results = 'results';
        images = "images";
        excel = "excel";

        %%% Image Names
        image_rotated = 'image_rotated';
        image_cropped = 'image_cropped';

        %%% ImageRotator
        arg1_key = '1';
        arg1_prompt = 'Enter "1" to run ImageRotator on a single file';

        arg2_key = '2';
        arg2_prompt = 'Enter "2" to run ImageRotator on a batch of files'

        %%% ImageCropper
        arg3_key = '3';
        arg3_prompt = 'Enter "3" to run ImageCropper on a single file';

        arg4_key = '4';
        arg4_prompt = 'Enter "4" to run ImageCropper on a batch of files';

        %%% Image Segmenter
        arg5_key = '5';
        arg5_prompt = 'Enter "5" to run ImageSegmenter on a single file';

        arg6_key = '6';
        arg6_prompt = 'Enter "6" to run ImageSegmenter on a batch of files';

        %%% ImageAnalyzer
        arg7_key = '7';
        arg7_prompt = 'Enter "7" to run ImageAnalyzer on a single file';

        arg8_key = '8';
        arg8_prompt = 'Enter "8" to run ImageAnalyzer on a batch of files';
    end
    
    
end

