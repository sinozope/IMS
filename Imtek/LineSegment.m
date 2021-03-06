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









(* Start Package *)
BeginPackage["Imtek`LineSegment`"]





(* *)
(* documentation *)
(* *)
Needs["Imtek`Maintenance`"];
imsCreateObsoleteFunctionInterface[ LineSegment2DQ, $Context ];
imsCreateObsoleteFunctionInterface[ LineSegment3DQ, $Context ];
imsCreateObsoleteFunctionInterface[ LineSegmentQ, $Context ];
imsCreateObsoleteFunctionInterface[ CollinearQ, $Context \
];imsCreateObsoleteFunctionInterface[ LineSegmentProperIntersectQ, $Context \
];
imsCreateObsoleteFunctionInterface[ LineSegmentIntersectQ, $Context \
];imsCreateObsoleteFunctionInterface[ LineSegmentIntersect, $Context ];


(* constructors *)

(* selectors *)

(* predicates *)

imsLineSegment2DQ::usage = \
"imsLineSegment2DQ[ expr ] returns True if expr is of form { coords, coords } and the coords are of 2D form.";\


imsLineSegment3DQ::usage = \
"imsLineSegment3DQ[ expr ] returns True if expr is of form { coords, coords } and the coords are of 3D form.";\


imsLineSegmentQ::usage = \
"imsLineSegmentQ[ expr ] returns True if expr is of form { coords, coords }.";\


imsCollinearQ::usage = \
"imsCollinearQ[ imsLineSegment, coords, comparision, n ] returns True if the comparison is set to Equal - which is the default - and the Point is on the Line Segment. For a comparison Greater imsCollinearQ returns True if the Point is to the left of Line Segment. You can set the precision with n. Default is $MachinePrecision.";\


imsLineSegmentProperIntersectQ::usage = \
"imsLineSegmentProperIntersectQ[ { imsLineSegment, imsLineSegment }, n ] returns True if the line segments intersect; excluding the starting and end points. You can set the precision with n. Default is $MachinePrecision.";\


imsLineSegmentIntersectQ::usage="imsLineSegmentIntersectQ[ { imsLineSegment, imsLineSegment }, n ] returns True if the line segments intersect; including the starting and end points of the segments. You can set the precision with n. Default is $MachinePrecision.";\


(* functions *)

imsLineSegmentIntersect::usage="imsLineSegmentIntersect[ { imsLineSegment, imsLineSegment }, n ] returns the Point or Line of intersection if the lines do intersect. You can set the precision with n. Default is $MachinePrecision.";\


imsLineSegmentParallelIntersect::usage = \
"imsLineSegmentParallelIntersection[ { imsLineSegment, imsLineSegment }, n ] returns a line segment which defines the overlapping part of the two given line segements. You can set the precision with n. Default is $MachinePrecision.";\


imsDropCollinear::usage="imsDropCollinear[ line ] returns a simplified line by dropping all collinear points. imsDropCollinear[ line , accuracygoal ] performs the collinearity test with the given accuracy goal. The default value is $MachinePrecision.";



(* *)
(* Error Messages *)
(* *)



Begin["`Private`"];



Needs["Imtek`Point`"];
Needs["Imtek`Polygon`"];



(* *)
(* implementation part *)
(* *)


(* constructor *)
(* List[] is constructor *)



(* selector *)



(* predicates *)

imsLineSegment2DQ[ { { _, _  }, { _, _ } } ] := True;
imsLineSegment3DQ[ { { _, _, _ }, { _, _, _ } } ] := True;
imsLineSegment2DQ[ ___ ]:= False;
imsLineSegment3DQ[ ___ ] := False;
imsLineSegmentQ[ expr_ ] := 
    imsLineSegment2DQ[ expr ] || imsLineSegment3DQ[ expr ];
imsLineSegmentQ[ ___ ] := False;

imsCollinearQ[  { a_, b_ }, c_, comparisonQ_, accugoal_:$MachinePrecision ] /; 
      comparisonQ === Less || comparisonQ === LessEqual:= 
    comparisonQ[ imsArea[ { a, b, c } ], 10^-accugoal ];

imsCollinearQ[  { a_, b_ }, c_, comparisonQ_, accugoal_:$MachinePrecision ] /; 
      comparisonQ === Greater || comparisonQ === GreaterEqual:= 
    comparisonQ[ imsArea[ { a, b, c } ], -10^-accugoal ];

imsCollinearQ[  { a_, b_ }, c_, comparisonQ_:Equal, 
        accugoal_:$MachinePrecision ] /; comparisonQ === Unequal := 
    Abs[ imsArea[ { a, b, c } ] ] >  10^-accugoal;

imsCollinearQ[  { a_, b_ }, c_, comparisonQ_:Equal, 
        accugoal_:$MachinePrecision ] /; comparisonQ === Equal := 
    Abs[ imsArea[ { a, b, c } ] ] \[LessEqual]  10^-accugoal;

imsLineSegmentProperIntersectQ[ { { a_, b_ } , { c_, d_ } }, 
    accugoal_:$MachinePrecision ] := 
  If[ 
    imsCollinearQ[  { a, b }, c, Equal, accugoal ] || 
      imsCollinearQ[ { a, b }, d, Equal, accugoal ] ||
      
      imsCollinearQ[ { c, d }, a, Equal, accugoal ] ||
      
      imsCollinearQ[ { c, d }, b, Equal, accugoal ],
    False,
    Xor[ imsCollinearQ[ { a, b }, c, Less, accugoal ], 
        imsCollinearQ[ { a, b }, d, Less, accugoal ] ] && 
      Xor[ imsCollinearQ[ { c, d }, a, Less, accugoal ], 
        imsCollinearQ[ { c, d }, b, Less, accugoal ] ]
     ]

imsLineSegmentIntersectQ[ { { a_, b_ }, { c_, d_ } }, 
      accugoal_:$MachinePrecision ] := 
    Which[
      imsLineSegmentProperIntersectQ[ { { a, b },{ c, d } }, accugoal ], 
      True,
      ( Between[ { a, b, c }, accugoal ] || 
          Between[ { a, b, d }, accugoal ] || 
          Between[ { c, d, a }, accugoal ] || 
          Between[ { c, d, b  }, accugoal ]  ),True,
      (* else *)
      True, False
      ];



(* *)
(* define your options *)
(* *)



(* private functions *)

dropCollinear[l:{{(_),(_)..}..},pte:{(_),(_)..}, 
      accugoal_:$MachinePrecision ]:=
    If[imsCollinearQ[ Take[l,-2], pte,Equal,accugoal],
      Join[Drop[l,-1],{pte}],
      Join[l,{pte}]
      ];

(* functions *)

imsLineSegmentParallelIntersect[ { { a_, b_ }, { c_, d_ } }, 
    accugoal_:$MachinePrecision ] := 
  CompoundExpression[
    If[ !imsCollinearQ[ { a, b }, c, Equal, accugoal ], Return[ List[] ] ];
    If[ imsBetweenQ[ { a, b, c }, accugoal ] && 
        imsBetweenQ[ { a, b, d }, accugoal ], Return[ { c, d } ] ],
    If[ imsBetweenQ[ { c, d, a }, accugoal ] && 
        imsBetweenQ[ { c, d, b }, accugoal ], Return[ { a, b } ] ],
    If[ imsBetweenQ[ { a, b, c }, accugoal ] && 
        imsBetweenQ[ { c, d, b }, accugoal ], Return[ { c, b } ] ],
    If[ imsBetweenQ[ { a, b, c }, accugoal ] && 
        imsBetweenQ[ { c, d, a }, accugoal ], Return[ { c, a }] ],
    If[ imsBetweenQ[ { a, b, d }, accugoal ] && 
        imsBetweenQ[ { c, d, b }, accugoal ], Return[ { d, b } ] ],
    If[ imsBetweenQ[ { a, b, d }, accugoal ] && 
        imsBetweenQ[ { c, d, a }, accugoal ], Return[ { d, a } ] ]
    ]

imsLineSegmentIntersect[ { { a_, b_ }, { c_, d_ } }, 
    accugoal_:$MachinePrecision ] := Module[
    {  x1, y1, x2, y2, x3, y3, x4, y4, denom, num, t, s },
    
    { x1, y1 } = a;
    { x2, y2 } = b;
    { x3, y3 } = c;
    { x4, y4 } = d;
    
    denom = 
      x1 * ( y4 - y3 ) + x2 * ( y3 - y4 ) + x4 * ( y2 - y1 ) + 
        x3 * ( y1 - y2 );
    
    If[ 
      Abs[ denom ] \[LessEqual] 10^-accugoal, (* !!! *)
      
      Return[ imsLineSegmentParallelIntersect[ { { a, b }, { c, d } }, 
          accugoal ] ];
      ];
    
    num = x1 * ( y4 - y3 ) + x3 * ( y1 - y4 ) + x4 * ( y3 - y1 );
    s = num / denom;
    
    num = -( x1 * ( y3 - y2 ) + x2 * ( y1 - y3 ) + x3 * ( y2 - y1 ) );
    t = num / denom;
    
    If[
       -10^-accugoal \[LessEqual] s && 
        s \[LessEqual] 1.0 + 10^-accugoal && -10^-accugoal \[LessEqual]  t && 
        t \[LessEqual]  1.0 + 10^-accugoal,
      Return[ { x1 + s * ( x2 - x1 ),y1 + s * ( y2 -y1 ) } ],
      Return[ { } ] 
      ];
    
    ];

imsDropCollinear[myLine:{{(_),(_)..}..},accugoal_:$MachinePrecision]:= 
  Fold[dropCollinear[ #1, #2, accugoal ]&,Take[myLine,2],Drop[myLine,2]]



End[] (* of Begin Private *)



Protect[] (* anything *)
EndPackage[] 
