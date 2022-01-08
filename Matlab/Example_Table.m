clc
clear
close all

% Create generator object
gen = Automatic_gcode_Generator();
gen.G58_X = 25;
gen.G58_Y = 25;
gen.G58_Z = 12;
gen.zsafe = 0.5;
gen.code_path = './Code.txt';
disp(gen)

% Table path
table = './Shapes.xlsx';

% Generate GCode
gen.Sequence(table);

close all

% --- DONE! --- %

