clc
clear
close all

% Create generator object
gen = Automatic_gcode_Generator();

% Table path
table = './Shapes.xlsx';

% Generate GCode
gen.Sequence(table);

% --- DONE! --- %

