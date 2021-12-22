gen = Automatic_gcode_Generator();

code = gen.PENTAGON([0,1000],5,-60);

gen.SaveGCode(code)
