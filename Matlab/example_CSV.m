clc
close all
clear all

%% Create generator object

gen = Automatic_gcode_Generator();

%% Define CSV location

CSV = './shapes.csv';

%% Create GCode

gen.Sequence(CSV);

%% DONE! %%

