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

  x = pos(1);
  y = pos(2);
  orientation = deg2rad(theta);
  pn = obj.pn;
  pf = obj.pf;
  zsafe = obj.zsafe;
  Npas = obj.Npas;
  zpas = obj.zpas;
  fz_dw = obj.fz_dw;
  fz_up = obj.fz_up;


  %% MACHINING PROCESS
  code = obj.code;
  code = cat(1, code, G0(obj,x, y, zsafe)); % Revisar estos G0 porque creo que son G1
  for i = 1:Npas
      z = -i*zpas;
      code = cat(1, code, G1(obj,x, y, z, fz_dw));
      code = Machine_Layer(obj,N,pos, L, orientation, z, code);
      code = cat(1, code, G1(obj,x, y, z, fz_up));
  end
  code = cat(1, code, G0(obj,x, y, zsafe));
  obj.code = code

end
