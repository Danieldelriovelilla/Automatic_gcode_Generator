function [code] = Machine_Layer(obj, N, pos, lf, orientation, z, code)
% Function to carve a figure in an specified layer
% N: Number of sides
% pos: x, y coordinates
% lf: final side length
% orientation: orientation respect x axis
% z: height
% code: gcode
% This function does NOT access to class atribute obj.code

fxy = obj.fxy;
pn = obj.pn;
pf = obj.pf;
x = pos(1);
y = pos(2);

% Poligon properties
theta = 2*pi/N;
Rot = Rz(obj,theta);
hf = Height(obj, lf, theta);
% Number of passes

[Npas, Nf, hf] = Passes(obj, pn, pf, hf);

% Machining process
h = obj.d/2;

% Plot tool circle
figure();
    hold on
    viscircles([x,y], obj.d/2, 'color', 'k','LineStyle', '--', 'LineWidth', 0.5);
for i = 1:Npas
    % Geometry
    h = h + pn;
    l = Height2Edge(obj,h, theta);
    r = Radious(obj,l, theta);
    % Vertices
    v = Vertices(obj, N, theta, Rot, l, r, orientation);
    v = [v(:,1)+x, v(:,2)+y];
    pgon = polyshape(v(:,1), v(:,2));
    % Plots
    plot(pgon,'FaceColor','white','FaceAlpha',0)
    axis('equal')
    % Code
    for j = 1:N+1
        if j == (N+1)
            code = cat(1, code, G1(obj,v(1,1), v(1,2), z, fxy));
        else
            code = cat(1, code, G1(obj,v(j,1), v(j,2), z, fxy));
        end
    end
end
% Last pass
for  i = 1:Nf
    % Geometry
    h = h + hf(i);
    l = Height2Edge(obj,h, theta);
    r = Radious(obj,l, theta);

    % Vertices
    v = Vertices(obj,N, theta, Rot, l, r, orientation);
    v = [v(:,1)+x, v(:,2)+y];
    pgon = polyshape(v(:,1), v(:,2));

    % Plots
    plot(pgon,'FaceColor','white','FaceAlpha',0)
    axis('equal')
    grid on
    box on

    % Code
    for j = 1:N+1
        if j == (N+1)
            code = cat(1, code, G1(obj,v(1,1), v(1,2), z, 50));
        else
            code = cat(1, code, G1(obj,v(j,1), v(j,2), z, 50));
        end
    end
end

end
