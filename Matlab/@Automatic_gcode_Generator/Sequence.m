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
  if isstring(shapes)
    data = fopen(shapes);
    lines = textscan(data,'%s','Delimiter','\n');
    fclose(fid);
    for i=1:lenght(lines)
      shapes{i,:} = textscan(lines(i),'%s','Delimiter',',');
    end
  end

  %%  Initialization
  INIT(obj)
  code = obj.code;

  for i=1:length(shapes)
    %% Shape characteristics (cell)
    N   = shapes{i,1};          % Number of sides
    pos = shapes{i,2};          % Center of the shape
    L   = shapes{i,3};          % Characteristic lenght
    theta = shapes{i,4};        % Orientation of the shape
    %% Go to center and carve shape
    switch N
      case 0
        D = L;
        CIRCLE(obj,pos,D)
      case 4
        SQUARE(obj,pos,L,theta)
      case 5
        PENTAGON(obj,pos,L,theta)
      case 6
        HEXAGON(obj,pos,L,theta)
    end

  end

  FINI(obj)
  obj.code = code;

end
