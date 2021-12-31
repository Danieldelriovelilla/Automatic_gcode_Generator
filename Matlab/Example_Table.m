clc
clear
close all

% Create generator object
gen = Automatic_gcode_Generator();
gen.G58_X = 0;
gen.G58_Y = 0;
gen.G58_Z = 0;
gen.code_path = '.\Code.txt';
disp(gen)

% Table path
table = '.\Shapes.xlsx';

% Generate GCode
gen.Sequence(table);

% --- DONE! --- %

