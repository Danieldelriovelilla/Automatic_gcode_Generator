%% Generate 

gen = Automatic_gcode_Generator();

C = {6,[0,0],2,30};
C = cat(1,C,{4,[100,100],5,45});

gen.CIRCLE([0,1000],5);
gen.Sequence(C);

gen.SaveGCode(gen.code)
