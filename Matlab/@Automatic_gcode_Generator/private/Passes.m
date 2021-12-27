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
hm = hf - obj.d/2;

% Calculate the number of normal pases
Npas = round(hm/pn);

% Calculate pasess
if Npas <= 1
    Npas = 0;
    % Calculate the final height after the normal pases   
    Nf = 2;
    hfinal = [hm-pf, pf];
else
    hend = round(hm - Npas*pn, 3);
    if hend == pf
        Nf = 1;
    else
        Nf = 2;
        hfinal = [hend-pf, pf];
    end
end

end
