%%
% pgon = polyshape([0 0 1 1],[1 0 0 1]);
% plot(pgon)
clc
clear 
close all


%% MACHINE PARAMETERS
d = 3;
pn = 1;
pf = 0.5;

%% FINAL PENTAGON

% Input
Np = 5;
lf = 10;

% Properties
theta_p = 2*pi/Np;
Rp = Rz(theta_p);
rf = Radious(lf, theta_p);
hf = Height(lf, theta_p);

% Vertices
vf = Vertices(Np, theta_p, Rp, lf, rf);
figure()
    hold on
    scatter(vf(:,1), vf(:,2), 'fill')
    pgonf = polyshape(vf(:,1), vf(:,2));
    plot(pgonf)
    axis equal
    
%% MACHINING PROCESS

% Origin
po = [0, 0, 0];
% Bajar de altura de seguridad a altura de mecanizado

% Number of passes
[Npas, Nf, hf] = Passes(pn, pf, hf);

h = 1.5;
fig = figure();
    hold on
for i = 1:Npas
    
    % Geometry
    h = h + pn;
    l = Height2Edge(h, theta_p);
    r = Radious(l, theta_p);
    
    % Vertices
    v = Vertices(Np, theta_p, Rp, l, r);
    pgon = polyshape(v(:,1), v(:,2));
    
    % Plots
    plot(pgon,'FaceColor','white','FaceAlpha',0)
    axis('equal')
    
    % Code
    for j = 1:Np
        G1(v(j,1), v(j,2), v(j,3), 50)
    end
end
for  i = 1:Nf
    % Geometry
    h = h + hf(i);
    l = Height2Edge(h, theta_p);
    r = Radious(l, theta_p);
    
    % Vertices
    v = Vertices(Np, theta_p, Rp, l, r);
    pgon = polyshape(v(:,1), v(:,2));
    
    % Plots
    plot(pgon,'FaceColor','white','FaceAlpha',0)
    axis('equal')
    
    % Code
    for j = 1:Np
        G1(v(j,1), v(j,2), v(j,3), 50)
    end
end
    


%% HEXAGON

theta_h = 60;
Nh = 6;

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

function v = Vertices(N, theta, Rot, l, r)
v = [-l/2, -r*cos(theta/2), 0];
for i = 2:N
    v = cat( 1, v, round( (Rot*v(end,:)')', 3 ) );
end
end


% Machining
function [Npas, Nf, hf] = Passes(pn, pf, hf)
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

function s = G1(x, y, z, f)
    s = strcat('G1',...
        ' X', num2str(x),...
        ' Y', num2str(y),...
        ' Z', num2str(z),...
        ' F', num2str(f));
end