classdef DateTime
    % creates a date and time string from a datenum
    
    properties (Access = private)
        DateAndTimeObj;
        DateAndTimeString;
    end
    
    methods
        function obj = DateTime(time)
            obj.DateAndTimeObj = datetime(time,'ConvertFrom','datenum');
            obj.DateAndTimeString = ConvertToString(obj.DateAndTimeObj);
        end
        
        function returnString = getDateTime(obj,~)
            returnString =  obj.DateAndTimeString;
        end

        
    end
end

function returnString = ConvertToString(DateAndTimeObj)
    delimiters = [" ","-",":"];
    join_character = "_";
    DTString = sprintf("%s",DateAndTimeObj);
    DTStringSplit = split(DTString,delimiters);
    returnString = join(DTStringSplit,join_character);
            
end

