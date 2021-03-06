classdef Automatic_gcode_Generator < handle

    %% Properties

    properties

        % MACHINE PARAMETERS (values given by default)
        d = 3          % [mm] Diameter of the cutting tool
        G58_X = 0       % [mm] Decalaje eje X
        G58_Y = 0       % [mm] Decalaje eje Y
        G58_Z = 0       % [mm] Decalaje eje Z
        pn = 1         % [mm] Nominal pass
        pf = 0.5       % [mm] Finishing pass
        zsafe = 1.      % [mm] Safe plane hight
        zpas = 1.       % [mm] Tool cutting lenght
        Npas = 1.       % Number of passes
        fxy = 80       % [mm/min] Plane speed rate
        fz_dw = 80     % [mm/min] Descending speed rate
        fz_up = 30     % [mm/min] Ascending speed rate
        prof = 1       % [mm] Pass depth
        % Code
        code = {}      % Code which will be written
        code_path = './Code.txt'    % Code path
    end

    %% Constructor

    methods (Access = public)

        function obj = Automatic_gcode_Generator()
            welcome_message(obj)
        end

    end

    methods (Access = private)

        function welcome_message(obj)
            disp('***Automatic_gcode_Generator***')
            disp('')
            disp('Current machinning configuration')
            disp(['d = ',num2str(obj.d),';          % [mm] Diameter of the cutting tool'])
            disp(['G58_X = ',num2str(obj.G58_X),';          % [mm] Decalaje eje X'])
            disp(['G58_Y = ',num2str(obj.G58_Y),';          % [mm] Decalaje eje Y'])
            disp(['G58_Z = ',num2str(obj.G58_Z),';          % [mm] Decalaje eje Z'])
            disp(['pn = ',num2str(obj.pn),';         % [mm] Nominal pass'])
            disp(['pf = ',num2str(obj.pf),';       % [mm] Finishing pass'])
            disp(['zsafe = ',num2str(obj.zsafe),';      % [mm] Safe plane hight'])
            disp(['zpas = ',num2str(obj.zpas),';       % [mm] Tool cutting lenght'])
            disp(['Npas = ',num2str(obj.Npas),';       % Number of passes'])
            disp(['fxy = ',num2str(obj.fxy),';       %  [mm/min] Plane speed rate'])
            disp(['fz_dw = ',num2str(obj.fz_dw),';     % [mm/min] Descending speed rate'])
            disp(['fz_up = ',num2str(obj.fz_up),';     % [mm/min] Ascending speed rate'])
            disp(['prof = ',num2str(obj.prof),';       % [mm] Total depth'])
            disp('')
            disp('    * Configuration can be changed')
            disp('      >> obj.attribute = X')
        end

    end

    %% Geometry

    methods (Access = private)

        function R = Rz(obj,theta)
            %{Rotation matrix arround z axis for a given angle
            % vargin theta: angle of rotation
            % varout R    : matrix of rotation
            %}

            R = [cos(theta), -sin(theta), 0;
                sin(theta), cos(theta), 0;
                0, 0, 1];
        end

        function r = Radious(obj,l, theta)
            r = (l/2)/sin(theta/2);
        end

        function h = Height(obj,l, theta)
            h = (l/2)/tan(theta/2);
        end

        function l = Height2Edge(obj,h, theta)
            l = 2*h*tan(theta/2);
        end

        function v = Vertices(obj, N, theta, Rot, l, r, orientation)
            v = [-l/2, -r*cos(theta/2), 0]*Rz(obj,orientation);
            for i = 2:N
                v = cat( 1, v, round( (Rot*v(end,:)')', 3 ) );
            end
        end

    end

    %% Machining

    methods (Access=private)

        function s = G0(obj,x, y, z)
            s = strcat('G0',...
                ' X', num2str(x),...
                ' Y', num2str(y),...
                ' Z', num2str(z));
        end

        function s = G1(obj,x, y, z, f)
            s = strcat('G1',...
                ' X', num2str(x),...
                ' Y', num2str(y),...
                ' Z', num2str(z),...
                ' F', num2str(f));
        end

        % function [code] = Machine_Layer(obj, N, lf, orientation, pn, pf, z, code)
        % function [Npas, Nf, hf] = Passes(obj, pn, pf, hf)

    end

    methods (Access = public)

        function code = INIT(obj)
            obj.code = {};
            code = obj.code;
            code = cat(1,code,'G53'); % Cancelar decalaje de origen bloque a bloque
            code = cat(1,code,'M00'); % Parada programada incondicional
            code = cat(1,code,'G71'); % Medidas en mil??metros
            code = cat(1,code,'G94'); % Avance en mm/min.
            code = cat(1,code,'G90'); % Coordenadas absolutas.
            code = cat(1,code,'G54'); % Decalaje de origen 1
            code = cat(1,code,['G58 ',...
                'X', num2str(obj.G58_X), ' ',...
                'Y', num2str(obj.G58_Y), ' ',...
                'Z', num2str(obj.G58_Z)]); % Decalaje de origen programable 1 (centro de la pieza)
            code = cat(1,code,'M3 S2000'); % Decalaje de origen 1
            code = cat(1,code,G0(obj, 0., 0., obj.zsafe)); % Decalaje de origen programable 1 (centro de la pieza)
            obj.code = code;
        end

        function code = FINI(obj)
            code = obj.code;
            % code = cat(1,code, ['G1 Z' num2str(obj.zsafe), ' F' num2str(obj.fz_up)]); % Subida hasta altura de seguridad
            code = cat(1,code, obj.G0(0, 0, 30)); % Subida hasta altura de seguridad
            code = cat(1,code,'M05');    % Husillo desactivado
            code = cat(1,code,'M17');    % Fin de subrutina
            obj.code = code;
        end

        % Sequence of polygons

        % function code = Sequence(shapes)

        % Shapes

        % function code = POLYGON(obj,N,pos,L,theta)
        % Circle shape
         function code = CIRCLE(obj,pos,D)
            % Function to carve a circle based in built function L930
            %   * See POLYGON to get more information about input variables
            %
            % This function access to class atribute obj.code and appends new commands to it
            % Center coordinates
            x = pos(1);
            y = pos(2);
            % Access obj.code
            code = obj.code;
            % Go to the center of the shape above zsafe
            code = cat(1, code, G0(obj,x, y, obj.zsafe));
            % Carve shape
            code = cat(1, code, G1(obj,x, y, -obj.prof, obj.fz_dw));
            code = cat(1, code, sprintf('R01=%.2f R02=0.0 R03=%.2f R06=02 R15=%.2f R16=%.2f R22=%.2f R23=%.2f R24=%.2f L930',...
                obj.pn, obj.prof, obj.fxy, obj.fz_dw, x, y, D/2));
            code = cat(1, code, G1(obj,x, y, obj.zsafe, obj.fz_up));
            % Write obj.code
            obj.code = code;
            % Plot final shape
            figure();
                viscircles([pos(1),pos(2)], obj.d/2, 'color', 'k','LineStyle', '--', 'LineWidth', 0.5);
                hold on
                viscircles([pos(1),pos(2)], (D-obj.d), 'color', 'k', 'LineWidth', 0.5);
                axis('equal')
                box on
        end
        % Square shape
        function code = SQUARE(obj,pos,L,theta)
            code = POLYGON(obj, 4, pos, L, theta);
        end
        % Pentagonal shape
        function code = PENTAGON(obj,pos,L,theta)
            code = POLYGON(obj, 5, pos, L, theta);
        end
        % Square shape
        function code = HEXAGON(obj,pos,L,theta)
            code = POLYGON(obj, 6, pos, L, theta);
        end

    end

    %% Save G Code
    methods (Access = public)

        function SaveGCode(obj,code)
            % Function to save the code given in a .txt with numbered headers and in an ASCII format
            % :vargin code: Code to be saved

            % Add column with N numbers
            code(:,2) = code(:,1);
            for i = 1:length(code)
                code{i,1} = strcat('N', num2str(10*i));
            end
            code = Clean_GCode(obj, code);
            % Write to txt in an ASCII format
            writecell(code, obj.code_path, 'Delimiter','tab', 'Encoding','ASCII');
        end

        function [clean_code] = Clean_GCode(obj, code)
            % Load the G lines
            clean_code = code(:,2);
            % Remove the repeated coordinates
            for i = 2:size(code, 1)
                if ( contains(code{i, 2}, 'G0') || contains(code{i, 2}, 'G1') )...
                        && ( contains(code{i-1, 2}, 'G0') || contains(code{i-1, 2}, 'G1') )
                    % FIND COORDINATES
                    % Line i-1
                    if contains(code{i-1, 2}, 'G0')
                        [x, y, z] = If_G0(obj, code{i-1,2});
                    elseif contains(code{i-1, 2}, 'G1')
                        [x, y, z] = If_G1(obj, code{i-1,2});
                    end
                    % Line i
                    if contains(code{i, 2}, 'G0')
                        [x1, y1, z1] = If_G0(obj, code{i,2});
                    elseif contains(code{i, 2}, 'G1')
                        [x1, y1, z1] = If_G1(obj, code{i,2});
                    end
                    % COMPARE COORDINATES
                    % Z
                    if z == z1
                        strz = strcat(' Z', num2str(z));
                        idx = strfind(code{i, 2}, strz);
                        clean_code{i, 1}(idx:idx+length(strz)-1) = [];
                    end
                    % Y
                    if y == y1
                        stry = strcat(' Y', num2str(y));
                        idx = strfind(code{i, 2}, stry);
                        clean_code{i, 1}(idx:idx+length(stry)-1) = [];
                    end
                    % X
                    if x == x1
                        strx = strcat(' X', num2str(x));
                        idx = strfind(code{i, 2}, strx);
                        clean_code{i, 1}(idx:idx+length(strx)-1) = [];
                    end
                else
                end

            end
            % Write the lines
            clean_code(:,2) = clean_code(:,1);
            clean_code(:,1) = code(:,1);
        end

        function [x, y, z] = If_G0(obj, code)
        % Coordinate indexes of i-1 line
        idxx = find( code == 'X' );
        idxy = find( code == 'Y' );
        idxz = find( code == 'Z' );
        % Coordinate indexes of i-1 line
        x = str2double(code(idxx+1:idxy-2));
        y = str2double(code(idxy+1:idxz-2));
        z = str2double(code(idxz+1:end));
        end

        function [x, y, z] = If_G1(obj, code)
        % Coordinate indexes of i-1 line
        idxx = find( code == 'X' );
        idxy = find( code == 'Y' );
        idxz = find( code == 'Z' );
        idxf = find( code == 'F' );
        % Coordinate indexes of i-1 line
        x = str2double(code(idxx+1:idxy-2));
        y = str2double(code(idxy+1:idxz-2));
        z = str2double(code(idxz+1:idxf-2));
        end

    end

end
