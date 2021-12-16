%%
% pgon = polyshape([0 0 1 1],[1 0 0 1]);
% plot(pgon)
clc
clear 
close all

%% PENTAGON

% Input
Np = 5;
pl = 10;

% Properties
theta_p = 360/Np;
Rp = Rz( deg2rad(theta_p) );
pr = Radious(pl, theta_p);

% Vertices
v = Vertices(Np, theta_p, Rp, pl, pr);

% Code
for i = 1:Np
    G1(v(i,1), v(i,2), v(i,3), 50)
end

pgon = polyshape(v(:,1), v(:,2));
figure()
plot(pgon)
axis('equal')

%% HEXAGON

theta_h = 60;
Nh = 6;

%% FUNCTIONS
function R = Rz(theta)
R = [cos(theta), -sin(theta), 0;
     sin(theta), cos(theta), 0;
     0, 0, 1];
end

function r = Radious(l, theta)
r = (l/2)/sin(deg2rad(theta/2));
end

function v = Vertices(N, theta, Rot, l, r)
v = [-l/2, -r*cos(deg2rad(theta/2)), 0];
for i = 2:N
    v = cat( 1, v, round( (Rot*v(end,:)')', 3 ) );
end
end

function s = G1(x, y, z, f)
    s = strcat('G1',...
        ' X', num2str(x),...
        ' Y', num2str(y),...
        ' Z', num2str(z),...
        ' F', num2str(f));
end