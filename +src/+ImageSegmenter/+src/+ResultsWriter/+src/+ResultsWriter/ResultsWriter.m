classdef ResultsWriter
    % Class to write results to file

    properties (Access = private)
        file_separator = '/';
        datetime_string;
        root = "";
        root_filepath = "";
        images_filepath = "";
        excel_filepath = "";

    end

    methods
        function obj = ResultsWriter(root_filepath)
            obj.datetime_string = src.ResultsWriter.src.DateTime.DateTime(now).getDateTime;
            obj.root_filepath = fullfile(root_filepath,obj.datetime_string);
            obj.root = obj.root_filepath;
        end

        function obj = setExcelFilepath(obj,excel_filepath)
            % sets obj.excel_filepath
            % Make dir for obj.excel_filepath
            obj.excel_filepath = fullfile(obj.root_filepath,excel_filepath);
            makeDir(obj.excel_filepath);
        end

        function obj = setImagesFilepath(obj,images_filepath)
            % sets obj.images_filepath
            % Makes dir for obj.images_filepath
            obj.images_filepath = fullfile(obj.root_filepath,images_filepath);
            makeDir(obj.images_filepath);
        end

         function returnString = getDateTime(obj,~)
            returnString = obj.datetime_string;
        end

        function returnString = getRootFilePath(obj,~)
            returnString = obj.root_filepath;
        end

        function returnString = getExcelFilePath(obj,~)
            returnString = obj.excel_filepath;
        end

        function returnString = getImagesFilePath(obj,~)
            returnString = obj.images_filepath;
        end

        function writeExcelFile(obj,matrix,file_name)
            excel_fullfile = fullfile(obj.excel_filepath,file_name);
            writematrix(matrix,excel_fullfile,'WriteMode','append');
        end


        function writeImage(obj,image,image_name)
            image_fullfile = fullfile(obj.images_filepath,image_name);
            imwrite(image,image_fullfile);
        end

        function obj = addDirToPath(obj,new_dir)
            new_fullfile = fullfile(obj.root_filepath,new_dir);
            makeDir(new_fullfile);
            obj.root_filepath = new_fullfile;
        end

        function [obj,dirRemoved] = removeDirFromPath(obj)
            % Clears obj.images_filepath
            dirRemoved = "";
            if strcmp(obj.root,obj.root_filepath)
                fprintf("Unable to remove from path: at root.");
                return
            end

            fullfill_string_array = strsplit(obj.root_filepath,obj.file_separator);
            obj.root_filepath = strjoin(fullfill_string_array(1:end-1),obj.file_separator);
            dirRemoved = fullfill_string_array(end);

            obj.images_filepath = '';

        end

        function writeReadme(obj,varargin)
              readme_fullfile = fullfile(obj.root,'README');
              matrix = cell2mat(varargin);
              writematrix(matrix,readme_fullfile,'WriteMode','append');
        end
    end

end

function makeDir(dir)
    if ~exist(dir, 'dir')
        mkdir(dir);
    end
end
