var util = require("util");

var tab = new Array(40);
for (var i = 0; i < 40; i++)
    tab[i] = i * i;
util.print((tab).length, "\n");

