classdef ImageRotator
    % Class to rotate images

    methods
        function obj = ImageRotator()

        end

        function [rotated_image,rotation_angle] = rotate_image(obj,input_image)
            % allows user to specify rotation angle until satistfied
            % returns rotated image and rotation angle
            input_string = 'Rotate image? 1: yes, 2: no\n(default NO, just hit enter): ';
            rotateyn = input(input_string); % rotateyn is rotate_yes_no

            %%% set rotateyn to default case if user presses enter with no
            %%% input
            if isempty(rotateyn)
                rotateyn = 2;
            end
            % if rotateyn == 1, rotate image, ask user for rotation angle
            % if rotaeyn == 2, don't rotate image (default case if user
            % just hits enter)

            rotation_angle = 0;  % set rotation angle to default of 0
            % if rotateyn == 1, rotate image, ask user for rotation angle
            if rotateyn == 1
                confirmRotate = 2;
                while confirmRotate == 2

                    %%% Display unrotated image
                    close all
                    imshow(input_image)

                    %%% Ask user for rotation angle
                    input_string = 'rotation angle: ';
                    rotation_angle = input(input_string);

                    %%% Rotate image
                    rotated_image = imrotate(input_image, rotation_angle);

                    %%% Show rotated image
                    imshow(rotated_image);

                    %%% Confirm rotation
                    confirmString = 'Confirm rotation? 1: yes, 2:no: ';
                    confirmRotate = input(confirmString);

                end

                % if rotateyn == 2, don't rotate image (default case if
                % user just hits enter)
            elseif rotateyn == 2
                rotated_image = input_image;
            else
                error('Wrong input for rotating image!');
            end
        end 


    end

end