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
  %             Sides number  is the number of the sides of the shape
  %             Position      is the position of the center of the shape, specified as a tuple (x,y)  [mm]
  %             Side lenght   is the lenght of the side (regular polygon)                             [mm]
  %             Orientation   is the angle of rotation around z axis                                  [deg]
  %
  % vargout code: code with all movements of the tool


  if iscell(shapes):
    % Something
  end

  if isstring(shapes):
    % Something
  end

end
