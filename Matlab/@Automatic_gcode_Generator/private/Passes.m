function [Npas, Nf, hfinal] = Passes(obj, pn, pf, hf)
% Function to calculate the number of passes to machine a poligonal shape
% pn: normal pass
% pf: fine pass
% lf: final side length
% hf: final poligon height
% z: height
% code: gcode
% This function does NOT access to class atribute obj.code

% Remove the tool radious to the total poligon height
hh = hf - obj.d/2;

% Remove the penetration hole
hm = hh - obj.d/2;

% Calculate the number of normal pases
Npas = round(hm/pn);

% Calculate the final height after the normal pases
hfinal = round(hm - round( hm/pn ),3);
if hfinal <= pn && hfinal < pf
    Npas = Npas - 1;
    Nf = 2;
    hfinal = [pf-hfinal, pf];
else
    Nf = 1;
end
disp(['Passes: ', num2str(Npas)])
end
