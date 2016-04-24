(*******************************************************************
This file was generated automatically by the Mathematica front end.
It contains Initialization cells from a Notebook file, which
typically will have the same name as this file except ending in
".nb" instead of ".m".

This file is intended to be loaded into the Mathematica kernel using
the package loading commands Get or Needs.  Doing so is equivalent
to using the Evaluate Initialization Cells menu command in the front
end.

DO NOT EDIT THIS FILE.  This entire file is regenerated
automatically each time the parent Notebook file is saved in the
Mathematica front end.  Any changes you make to this file will be
overwritten.
***********************************************************************)











Off[General::"spell",General::"spell1",ParametricPlot3D::"ppcom"]

thePath[t_]:={4Sin[t],4Cos[t],.5t};
pendulumFrame[\[Theta]_]:=Graphics[{RGBColor[0,0,1],
        imsPolygon[{{0,1},{.1,1.2},{-.1,1.2},{0,1}}],RGBColor[0,0,0],
        Line[{{0,1},{Sin[\[Theta]],1-Cos[\[Theta]]}}],
        RGBColor[1,0,0],
        Disk[{Sin[\[Theta]],1-Cos[\[Theta]]},.05]}
      ];

tangentPic[\[CapitalDelta]t_]:=Module[{vecs,spiral,r,rr,dr,v},
      spiral=Line[Table[thePath[t]+{6,6,0},{t,0,20,.1}]];
      r=thePath[10]+{6,6,0};
      rr=thePath[10+\[CapitalDelta]t]+{6,6,0};
      dr=rr-r;
      v=dr/\[CapitalDelta]t;
      vecs=Line[{{0,0,0},r,rr,{0,0,0}}];
      vel=Line[{r,r+v}];
      Graphics3D[{spiral,RGBColor[1,0,0],vecs,RGBColor[0,0,1],vel}]
      ];



