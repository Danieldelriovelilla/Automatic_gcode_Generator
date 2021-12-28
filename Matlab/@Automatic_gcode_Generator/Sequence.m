function code = Sequence(obj,shapes)
% Function to concatenate GCode of several shapes
%
% vargin shapes (cell): a cell which contains shapes specified in the following format:
%
%   C{n,:} = (Sides number,Position,Side lenght, Orientation)
%
% vargin shapes (string): path to csv which contains shapes specified in the following format:
%
%   Sides number,Position,Side lenght, Orientation
%   ...
%
%   where:
%             Sides number  is the number of the sides of the shape (0 for circle)
%             Position      is the position of the center of the shape, specified as a tuple (x,y)  [mm]
%             Side lenght   is the lenght of the side (regular polygon)                             [mm]
%             Orientation   is the angle of rotation around z axis                                  [deg]
%
% vargout code: code with all movements of the tool

% Read from CSV in case
shapes = readtable(shapes);

%  Initialization
INIT(obj);
code = obj.code;

for i=1:height(shapes)
    % Shape characteristics (cell)
    N = shapes.N_LADOS(i);          % Number of sides
    pos = [shapes.CENTRO_X(i), shapes.CENTRO_Y(i)];          % Center of the shape
    L = shapes.LONGITUD_LADO(i);          % Characteristic lenght
    theta = shapes.ORIENTACION(i);        % Orientation of the shape

    % Go to center and carve shape
    switch N
        case 0
            D = L;
            CIRCLE(obj,pos,D);
        case 4
            SQUARE(obj,pos,L,theta);
        case 5
            PENTAGON(obj,pos,L,theta);
        case 6
            HEXAGON(obj,pos,L,theta);
        otherwise
            disp(['Error in shape',num2str(i)])
    end

end

% Finalization
FINI(obj);

% Save to TXT
SaveGCode(obj,obj.code);

end
