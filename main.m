% Author: Jason Weible
% Date: 2_20_22
% Description: Driver script for RNFB Project

clear % clear the workspace
clc % clear the command window

% Import Statements
import +src.*


% Begin program
programSelector = src.ProgramSelector.ProgramSelector();

%%% ImageRotatorSingle
programSelector = programSelector.AddOption(src.Utils.arg1_key,src.Utils.arg1_prompt);
programSelector = programSelector.AddFunction(src.Utils.arg1_key,@ImageRotatorSingle);

%%% ImageRotatorBatch
programSelector = programSelector.AddOption(src.Utils.arg2_key,src.Utils.arg2_prompt);
programSelector = programSelector.AddFunction(src.Utils.arg2_key,@ImageRotatorBatch);

%%% ImageCropperSingle
programSelector = programSelector.AddOption(src.Utils.arg3_key,src.Utils.arg3_prompt);
programSelector = programSelector.AddFunction(src.Utils.arg3_key,@ImageCropperSingle);

%%% ImageCropperBatch
programSelector = programSelector.AddOption(src.Utils.arg4_key,src.Utils.arg4_prompt);
programSelector = programSelector.AddFunction(src.Utils.arg4_key,@ImageCropperBatch);

%%% ImageSegmenterSingle
programSelector = programSelector.AddOption(src.Utils.arg5_key,src.Utils.arg5_prompt);
programSelector = programSelector.AddFunction(src.Utils.arg5_key,@ImageSegmenterSingle);

%%% ImageSegmenterBatch
programSelector = programSelector.AddOption(src.Utils.arg6_key,src.Utils.arg6_prompt);
programSelector = programSelector.AddFunction(src.Utils.arg6_key,@ImageSegmenterBatch);

%%% ImageAnalyzerSingle
programSelector = programSelector.AddOption(src.Utils.arg7_key,src.Utils.arg7_prompt);
programSelector = programSelector.AddFunction(src.Utils.arg7_key,@ImageAnalyzerSingle);

%%% ImageAnalyzerBatch
programSelector = programSelector.AddOption(src.Utils.arg8_key,src.Utils.arg8_prompt);
programSelector = programSelector.AddFunction(src.Utils.arg8_key,@ImageAnalyzerBatch);

% Prompt user for input
programSelector.displayOptions();
user_input = programSelector.Input(src.Utils.input_selection);

% Get user selected function
func = programSelector.getFunction(string(user_input));

% Run user selected function
func{:}()

% End program
fprintf("Program done\n");

%%% Function Declarations
function ImageRotatorSingle()
    fprintf('Running ImageRotatorSingle\n');

    % Create DataLoader object
    dataLoader = src.DataLoader.src.DataLoader.DataLoader();

    % Create ResultsWriter object
    resultsWriter = src.ResultsWriter.src.ResultsWriter.ResultsWriter(src.Utils.results);

    % Ask user to select input image
    [image_file,path] = uigetfile(strcat(src.Utils.star_dot,src.Utils.tif));

    % Load image
    image_initial = dataLoader.loadSingleImage(path,image_file);

    % Create new image name
    path = split(path,src.Utils.file_delimeter);
    image_name_new = strjoin(path(src.Utils.new_image_name:end-1),src.Utils.underscore);

    % Create results folder for input image based off image name
    resultsWriter = resultsWriter.addDirToPath(image_name_new);

    % Get name of function
    st = dbstack;
    functionName = st.name;

    % write README to results folder
    resultsWriter.writeReadme(src.Utils.readme,functionName)

    % Create directory for excel files
    resultsWriter = resultsWriter.setExcelFilepath(src.Utils.excel);

    % Create directory for images
    resultsWriter = resultsWriter.setImagesFilepath(src.Utils.images);

    % Create imageRotator object
    imageRotatorSingle = src.ImageRotator.src.ImageRotator.ImageRotator();

    % Rotate image
    [rotated_image, rotation_angle] = imageRotatorSingle.rotate_image(image_initial);

    % Save initial image
    filename = strcat(image_name_new,src.Utils.dot,src.Utils.png);
    resultsWriter.writeImage(image_initial,filename);

    % Save rotated image
    filename = strcat(src.Utils.image_rotated,src.Utils.dot,src.Utils.png);
    resultsWriter.writeImage(rotated_image,filename);

    % save rotation angle to excel file
    filename = strcat(image_name_new,src.Utils.dot,src.Utils.xlsx);
    resultsWriter.writeExcelFile(["#rotation_angle";rotation_angle],filename);


end

function ImageRotatorBatch()
    fprintf('Running ImageRotatorBatch\n');
end

function ImageCropperSingle()
    fprintf('Running ImageCropperSingle\n');

    % Create DataLoader object
    dataLoader = src.DataLoader.src.DataLoader.DataLoader();

    % Create ResultsWriter object
    resultsWriter = src.ResultsWriter.src.ResultsWriter.ResultsWriter(src.Utils.results);

    % Ask user to select input image
    [image_file,path] = uigetfile(strcat(src.Utils.star_dot,src.Utils.png));

    % Load image
    image_initial = dataLoader.loadSingleImage(path,image_file);

    % Create new image name
    path = split(path,src.Utils.file_delimeter);
    image_name_new = strjoin(path(src.Utils.new_image_name:end-1),src.Utils.underscore);

    % Create results folder for input image based off image name
    resultsWriter = resultsWriter.addDirToPath(image_name_new);

    % Get name of function
    st = dbstack;
    functionName = st.name;

    % write README to results folder
    resultsWriter.writeReadme(src.Utils.readme,functionName)

    % Create directory for excel files
    resultsWriter = resultsWriter.setExcelFilepath(src.Utils.excel);

    % Create directory for images
    resultsWriter = resultsWriter.setImagesFilepath(src.Utils.images);

    % create imageCropper object
    imageCropperSingle = src.ImageCropper.src.ImageCropper.ImageCropper();

    % Crop image
    [image_cropped,dimensions] = imageCropperSingle.cropImage(image_initial);

    % Calculate area of cropped iamge
    cropped_area = dimensions.rows * dimensions.cols;

    %%% Write cropped image dimensions to excel file
    filename = strcat(image_name_new,src.Utils.dot,src.Utils.xlsx);
    file_header = ["#rows","cols","area"];
    data_row = [dimensions.rows,dimensions.cols,cropped_area];
    resultsWriter.writeExcelFile([file_header;data_row],filename)

    %%% Write cropped_image to file
    filename = strcat(src.Utils.image_cropped,src.Utils.dot,src.Utils.png);
    resultsWriter.writeImage(image_cropped,filename);

end

function ImageCropperBatch()
    fprintf('Running ImageCropperBatch\n');
end

function ImageSegmenterSingle()
    fprintf('Running ImageSegmenterSingle\n');

    % Create DataLoader object
    dataLoader = src.DataLoader.src.DataLoader.DataLoader();

    % Create ResultsWriter object
    resultsWriter = src.ResultsWriter.src.ResultsWriter.ResultsWriter(src.Utils.results);

    % Ask user to select input image
    [image_file,path] = uigetfile(strcat(src.Utils.star_dot,src.Utils.png));

    % Load image
    image_initial = dataLoader.loadSingleImage(path,image_file);

    % Create new image name
    path = split(path,src.Utils.file_delimeter);
    image_name_new = strjoin(path(src.Utils.new_image_name:end-1),src.Utils.underscore);

    % Create results folder for input image based off image name
    resultsWriter = resultsWriter.addDirToPath(image_name_new);

    % Get name of function
    st = dbstack;
    functionName = st.name;

    % write README to results folder
    resultsWriter.writeReadme(src.Utils.readme,functionName)

    % Create directory for excel files
    resultsWriter = resultsWriter.setExcelFilepath(src.Utils.excel);

    % Create directory for images
    resultsWriter = resultsWriter.setImagesFilepath(src.Utils.images);

    % Create ImageSegmener object
    imageSegmenterSingle = src.ImageSegmenter.src.ImageSegmenter.ImageSegmenter(resultsWriter);

    % Segment Image - writes all results to file
    imageSegmenterSingle.segmentImage(image_initial,image_name_new);

end

function ImageSegmenterBatch()
    fprintf('Running ImageSegmenterBatch\n');
end

function ImageAnalyzerSingle()
    fprintf('Running ImageAnalyzerSingle\n');

    % Create DataLoader object
    dataLoader = src.DataLoader.src.DataLoader.DataLoader();

    % Create ResultsWriter object
    resultsWriter = src.ResultsWriter.src.ResultsWriter.ResultsWriter(src.Utils.results);

    % Ask user to select input image
    [image_file,path] = uigetfile(strcat(src.Utils.star_dot,src.Utils.png));

    % Load image
    image_initial = dataLoader.loadSingleImage(path,image_file);

    % Create new image name
    path = split(path,src.Utils.file_delimeter);
    image_name_new = strjoin(path(src.Utils.new_image_name:end-1),src.Utils.underscore);

    % Create results folder for input image based off image name
    resultsWriter = resultsWriter.addDirToPath(image_name_new);

    % Get name of function
    st = dbstack;
    functionName = st.name;

    % write README to results folder
    resultsWriter.writeReadme(src.Utils.readme,functionName)

    % Create directory for excel files
    resultsWriter = resultsWriter.setExcelFilepath(src.Utils.excel);

    % Create directory for images
    resultsWriter = resultsWriter.setImagesFilepath(src.Utils.images);

    % Create Image Analyzer object
    imageAnalyzerSingle = src.ImageAnalyzer.src.ImageAnalyzer.ImageAnalyzer(resultsWriter);

    % Analyzer image - saves results to file
    imageAnalyzerSingle.analyze_image(image_initial,image_name_new);
end

function ImageAnalyzerBatch()
    fprintf('Running ImageAnalyzerBatch\n');
end


