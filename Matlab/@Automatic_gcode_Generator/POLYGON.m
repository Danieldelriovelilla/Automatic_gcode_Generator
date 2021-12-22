function code = POLYGON(obj,N,pos,L,theta)
  % Function to draw any polygonal regular shape with a side lenght and orientation given
  % in a specified position
  %
  % :vargin obj:              class object, provides pn and pf values
  % :vargin N:                number of sides
  % vargin (x,y): ([mm],[mm]) x and y position of the center
  % vargin L    : [mm]        side lenght
  % vargin theta: [deg]       orientation angle
  %
  % vargout code: GCode of tool to draw the polygon
  %
  % This function access to class atribute obj.code and appends new commands to it

  % Input variables
  x = pos(1);
  y = pos(2);
  orientation = deg2rad(theta);

  % From class atributes
  pn = obj.pn;
  pf = obj.pf;
  zsafe = obj.zsafe;
  Npas = obj.Npas;
  zpas = obj.zpas;
  fz_dw = obj.fz_dw;
  fz_up = obj.fz_up;


  %% MACHINING PROCESS
  code = obj.code;
  % Go to the center of the shape above zsafe
  code = cat(1, code, G0(obj,x, y, zsafe));
  % Carve shape in different levels
  for i = 1:Npas
      % Tool down
      z = -i*zpas;
      code = cat(1, code, G1(obj,x, y, z, fz_dw));
      % Carving
      code = Machine_Layer(obj,N,pos, L, orientation, z, code);
  end
  % Tool up to zsafe
  code = cat(1, code, G1(obj,x, y, zsafe, fz_up));
  % Update code
  obj.code = code;

end
