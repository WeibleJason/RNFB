classdef ProgramSelector
    % Class to allow user to specify which option to run

    properties
        
    end

    properties (Access = private)
        promptMap;
        functionMap;
    end

    methods 
        function obj = ProgramSelector()
            obj.promptMap = containers.Map;
            obj.functionMap = containers.Map;
        end

        function obj = AddOption(obj,inputKey,prompt)
            % Adds inputKey and prompt to obj.promptMap
            % Does not check if key already exists
            newMap = containers.Map({inputKey},{prompt});
            obj.promptMap = [obj.promptMap; newMap];
        end




        function returnBoolean = HasKey(obj,inputKey)
            % returns true iff promptMap contains inputKey
            returnBoolean = false;
            keySet = keys(obj.promptMap);
            if ~any(strcmp(keySet,inputKey))
                returnBoolean = false;
            else
                returnBoolean = true;
            end
        end

        function value = getValue(obj,inputKey)
            % Returns a cell containing the value of the key
            value = values(obj.promptMap,{inputKey});
        end

        function keySet = getKeys(obj)
            keySet = keys(obj.promptMap);
        end

        function displayOptions(obj)
            keySet = obj.getKeys();
            for key = keySet
                prompt = obj.getValue(char(key));
                fprintf('%s\n',char(prompt))
            end
        end

        function result = Input(obj,prompt)
            result = input(prompt);
        end
        
        function obj = AddFunction(obj,inputKey,func)
            newMap = containers.Map({inputKey},{func});
            obj.functionMap = [obj.functionMap; newMap];
        end

        function func = getFunction(obj,inputKey)
            func = values(obj.functionMap,{inputKey});
        end
    end
end
