classdef Automatic_gcode_Generator < handle

    %% Properties

    properties

        % MACHINE PARAMETERS (values given by default)
        d = 3          % [mm] Diameter of the cutting tool
        pn = 1         %
        pf = 0.5       %
        zsafe = 1      % [mm] Safe plane hight
        zpas = 1       % [mm] Tool cutting lenght
        Npas = 2       % Number of passes
        fxy = 80       % [mm/min] Plane speed rate
        fz_dw = 80     % [mm/min] Descending speed rate
        fz_up = 30     % [mm/min] Ascending speed rate
        prof = 1

    end

    properties (Access = private)
        % Code
        code = {}      % Code which will be written
    end

    %% Constructor

    methods (Access = public)

        function obj = Automatic_gcode_Generator()
            welcome_message(obj)
        end

        function welcome_message(obj)
          disp('***Automatic_gcode_Generator***')
          disp('')
          disp('Current machinning configuration')
          disp(['d = ',num2str(obj.d),';          % [mm] Diameter of the cutting tool'])
          disp(['pn = ',num2str(obj.pn),';         %'])
          disp(['pf = ',num2str(obj.pf),';       %'])
          disp(['zsafe = ',num2str(obj.zsafe),';      % [mm] Safe plane hight'])
          disp(['zpas = ',num2str(obj.zpas),';       % [mm] Tool cutting lenght'])
          disp(['Npas = ',num2str(obj.Npas),';       % Number of passes'])
          disp(['fxy = ',num2str(obj.fxy),';       % [mm/min] Plane speed rate'])
          disp(['fz_dw = ',num2str(obj.fz_dw),';     % [mm/min] Descending speed rate'])
          disp(['fz_up = ',num2str(obj.fz_up),';     % [mm/min] Ascending speed rate'])
          disp(['prof = ',num2str(obj.prof),';       %'])
          disp('')
          disp('    * Configuration can be changed')
          disp('      >> obj.attribute = X')
        end

    end

    methods (Access = private)

      %% Geometry

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

      %% Machining

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

      %% Sequence of polygons

      %% function code = Sequence(shapes) 


      %% Shapes

      function code = CIRCLE(obj,pos,D)
        % To be built
      end

      function code = HEXAGON(obj,pos,L,theta)

        code = POLYGON(obj,6,pos,L,theta);

      end

      function code = PENTAGON(obj,pos,L,theta)

        code = POLYGON(obj,5,pos,L,theta);

      end

      function code = SQUARE(obj,pos,L,theta)
        % To be built
      end

      % function code = POLYGON(obj,N,pos,L,theta)

      function SaveGCode(obj,code)
        % Function to save the code given in a .txt with numbered headers and in an ASCII format
        % :vargin code: Code to be saved

        % Add column with N numbers
        code(:,2) = code(:,1);
        for i = 1:length(code)
            code{i,1} = strcat('N', num2str(10*i));
        end

        % Write to txt in an ASCII format
        writecell(code, 'code.txt', 'Delimiter','tab')

      end


    end

end
