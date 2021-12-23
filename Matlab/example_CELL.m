clc
close all
clear all

%% Create generator object

gen = Automatic_gcode_Generator();

%% Define a shape sequence

C = {6,[0,0],2,30};
C = cat(1,C,{4,[100,100],5,45});

%% Create GCode

gen.Sequence(C);

%% DONE! %%

