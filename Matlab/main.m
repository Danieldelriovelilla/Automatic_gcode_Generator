% https://ncviewer.com
clc
clear 
close all

%% VARIABLES INIZIALITATION
code = {};

%% MACHINE PARAMETERS
d = 3;
pn = 1;
pf = 0.5;
zsafe = 1;
zpas = 1;
Npas = 2;
fxy = 100;
fz = 10;
prof = 1;


%% PENTAGON
%{
Np = 5;
lf = 10;
orientation = deg2rad(30);

%% MACHINING PROCESS
code = cat(1, code, G0(0, 0, zsafe));
for i = 1:Npas
    z = -i*zpas;
    code = cat(1, code, G1(0, 0, z, fz));
    code = Machine_Layer(Np, lf, orientation, pn, pf, z, code);
    code = cat(1, code, G1(0, 0, z, fz));
end
code = cat(1, code, G0(0, 0, zsafe));
%}

%% HEXAGON
%%{
% Input
Nh = 6;
lf = 10;
orientation = deg2rad(0);
    
%% MACHINING PROCESS
code = cat(1, code, G0(0, 0, zsafe));
for i = 1:Npas
    z = -i*zpas;
    code = cat(1, code, G1(0, 0, z, fz));
    code = Machine_Layer(Nh, lf, orientation, pn, pf, z, code);
    code = cat(1, code, G1(0, 0, z, fz));
end
code = cat(1, code, G0(0, 0, zsafe));
%%}

%% WRITE FILE
code(:,2) = code(:,1);
for i = 1:length(code)
    code{i,1} = strcat('N', num2str(10*i));
end

writecell(code, 'code.txt', 'Delimiter','tab')


%% FUNCTIONS

% Poligon
function R = Rz(theta)
R = [cos(theta), -sin(theta), 0;
     sin(theta), cos(theta), 0;
     0, 0, 1];
end

function r = Radious(l, theta)
r = (l/2)/sin(theta/2);
end

function h = Height(l, theta)
h = (l/2)/cos(theta/2);
end

function l = Height2Edge(h, theta)
l = 2*h*tan(theta/2);
end

function v = Vertices(N, theta, Rot, l, r, orientation)
v = [-l/2, -r*cos(theta/2), 0]*Rz(orientation);
for i = 2:N
    v = cat( 1, v, round( (Rot*v(end,:)')', 3 ) );
end
end

% Machining
function [Npas, Nf, hf] = Passes(pn, pf, hf)
hf = hf - 1.5;
Npas = round(hf/pn);
hf = hf - round( hf/pn );
if hf >= pf
    Nf = 2;
    hf = [pf, hf-pf];
elseif hf == pf
    Nf = 1;
else
    Nf = 1;
end
end

function s = G0(x, y, z)
    s = strcat('G0',...
        ' X', num2str(x),...
        ' Y', num2str(y),...
        ' Z', num2str(z));
end

function s = G1(x, y, z, f)
    s = strcat('G1',...
        ' X', num2str(x),...
        ' Y', num2str(y),...
        ' Z', num2str(z),...
        ' F', num2str(f));
end

function [code] = Machine_Layer(N, lf, orientation, pn, pf, z, code)
% Poligon properties
theta = 2*pi/N;
Rot = Rz(theta);
hf = Height(lf, theta);

% Number of passes
[Npas, Nf, hf] = Passes(pn, pf, hf);

% Machining process
h = 1.5;
figure();
    hold on
    viscircles([0,0],1.5, 'color', 'k','LineStyle', '--', 'LineWidth', 0.5)
for i = 1:Npas
    % Geometry
    h = h + pn;
    l = Height2Edge(h, theta);
    r = Radious(l, theta);
    
    % Vertices
    v = Vertices(N, theta, Rot, l, r, orientation);
    pgon = polyshape(v(:,1), v(:,2));
    
    % Plots
    plot(pgon,'FaceColor','white','FaceAlpha',0)
    axis('equal')
    
    % Code
    for j = 1:N+1
        if j == (N+1)
            code = cat(1, code, G1(v(1,1), v(1,2), z, 50));
        else
            code = cat(1, code, G1(v(j,1), v(j,2), z, 50));
        end
    end
end
% Last pass
for  i = 1:Nf
    % Geometry
    h = h + hf(i);
    l = Height2Edge(h, theta);
    r = Radious(l, theta);
    
    % Vertices
    v = Vertices(N, theta, Rot, l, r, orientation);
    pgon = polyshape(v(:,1), v(:,2));
    
    % Plots
    plot(pgon,'FaceColor','white','FaceAlpha',0)
    axis('equal')
    grid on
    box on
    
    % Code
    for j = 1:N+1
        if j == (N+1)
            code = cat(1, code, G1(v(1,1), v(1,2), z, 50));
        else
            code = cat(1, code, G1(v(j,1), v(j,2), z, 50));
        end
    end
end

end