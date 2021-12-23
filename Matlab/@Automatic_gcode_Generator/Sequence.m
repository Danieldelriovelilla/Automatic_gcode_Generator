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

%% Read from CSV in case
if isstring(shapes) || ischar(shapes)
    shapes_cell = {};
    data = fopen(shapes);
    lines = textscan(data,'%s','Delimiter','\n');
    lines = lines{1,1};
    fclose('all');
    for i=1:length(lines)
        val = textscan(lines{i},'%s','Delimiter',',');
        val = val{1,1}';
        N = str2double(val{1,1});
        x = str2double(val{1,2});
        y = str2double(val{1,3});
        L = str2double(val{1,4});
        try
            theta = str2double(val{1,5});
            shapes_cell = cat(1,shapes_cell,{N,[x,y],L,theta});
        catch
            shapes_cell = cat(1,shapes_cell,{N,[x,y],L});
        end
    end
    shapes = shapes_cell;
end

%%  Initialization
INIT(obj);
code = obj.code;

for i=1:size(shapes,1)
    %% Shape characteristics (cell)
    N   = shapes{i,1};          % Number of sides
    pos = shapes{i,2};          % Center of the shape
    L   = shapes{i,3};          % Characteristic lenght
    try
        theta = shapes{i,4};        % Orientation of the shape
    catch
        IsACircle = 'True';
    end

    %% Go to center and carve shape
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

%% Finalization
FINI(obj);

%% Save to TXT
SaveGCode(obj,obj.code);

end
