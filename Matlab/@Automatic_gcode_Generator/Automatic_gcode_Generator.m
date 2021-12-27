classdef Automatic_gcode_Generator < handle

    %% Properties

    properties

        % MACHINE PARAMETERS (values given by default)
        d = 3          % [mm] Diameter of the cutting tool
        pn = 1         % [mm] Nominal pass
        pf = 0.5       % [mm] Finishing pass
        zsafe = 1      % [mm] Safe plane hight
        zpas = 1       % [mm] Tool cutting lenght
        Npas = 1       % Number of passes
        fxy = 80       % [mm/min] Plane speed rate
        fz_dw = 80     % [mm/min] Descending speed rate
        fz_up = 30     % [mm/min] Ascending speed rate
        prof = 1       % [mm] Pass depth
        % Code
        code = {}      % Code which will be written
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
            h = (l/2)/cos(theta/2);
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
            code = cat(1,code,'G71'); % Medidas en milímetros
            code = cat(1,code,'G94'); % Avance en mm/min.
            code = cat(1,code,'G54'); % Decalaje de origen 1
            code = cat(1,code,'G58 X25 Y25'); % Decalaje de origen programable 1 (centro de la pieza)
            obj.code = code;
        end

        function code = FINI(obj)
            code = obj.code;
            code = cat(1,code,'G0 Z40'); % Subida hasta altura de seguridad
            code = cat(1,code,'M05');    % Husillo desactivado
            code = cat(1,code,'M17');    % Fin de subrutina
            obj.code = code;
        end

        % Sequence of polygons

        % function code = Sequence(shapes)

        % Shapes

        % function code = POLYGON(obj,N,pos,L,theta)

        function code = HEXAGON(obj,pos,L,theta)

            code = POLYGON(obj,6,pos,L,theta);

        end

        function code = PENTAGON(obj,pos,L,theta)

            code = POLYGON(obj,5,pos,L,theta);

        end

        function code = SQUARE(obj,pos,L,theta)

            code = POLYGON(obj,4,pos,L,theta);

        end

        function code = CIRCLE(obj,pos,D)
            % Function to carve a circle based in built function L930
            %   * See POLYGON to get more information about input variables
            %
            % This function access to class atribute obj.code and appends new commands to it
            figure();
                viscircles([pos(1),pos(2)], obj.d/2, 'color', 'k','LineStyle', '--', 'LineWidth', 0.5);
                hold on
                viscircles([pos(1),pos(2)], D/2, 'color', 'k', 'LineWidth', 0.5);
                axis('equal')
                box on
            x = pos(1);
            y = pos(2);

            % Access obj.code
            code = obj.code;
            % Go to the center of the shape above zsafe
            code = cat(1, code, G0(obj,x, y, obj.zsafe));
            % Carve shape
            code = cat(1, code, sprintf('R01=%.2f R02=0.0 R03=%.2f R06=02 R15=%.2f R16=%.2f R22=%.2f R23=%.2f R24=%.2f L930',...
                obj.pn, obj.prof, obj.fxy, obj.fz_dw, x, y, D/2));
            % Write obj.code
            obj.code = code;
        end

        % function code = POLYGON(obj,N,pos,L,theta)

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

            % Write to txt in an ASCII format
            writecell(code, 'code.txt', 'Delimiter','tab', 'Encoding','ASCII');

        end

    end

end
