function [Npas, Nf, hf] = Passes(obj,pn, pf, hf)
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
