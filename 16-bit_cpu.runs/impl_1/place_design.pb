
?
Command: %s
53*	vivadotcl2
place_designZ4-113h px� 

@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
Implementation2	
xc7a35tZ17-347h px� 
o
0Got license for feature '%s' and/or device '%s'
310*common2
Implementation2	
xc7a35tZ17-349h px� 
H
Releasing license: %s
83*common2
ImplementationZ17-83h px� 
>
Running DRC with %s threads
24*drc2
2Z23-27h px� 
D
DRC finished with %s
79*	vivadotcl2

0 ErrorsZ4-198h px� 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px� 
^
,Running DRC as a precondition to command %s
22*	vivadotcl2
place_designZ4-22h px� 
>
Running DRC with %s threads
24*drc2
2Z23-27h px� 
D
DRC finished with %s
79*	vivadotcl2

0 ErrorsZ4-198h px� 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px� 
k
BMultithreading enabled for place_design using a maximum of %s CPUs12*	placeflow2
2Z30-611h px� 
C

Starting %s Task
103*constraints2
PlacerZ18-103h px� 
R

Phase %s%s
101*constraints2
1 2
Placer InitializationZ18-101h px� 
d

Phase %s%s
101*constraints2
1.1 2'
%Placer Initialization Netlist SortingZ18-101h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002

00:00:002

1607.0352
0.000Z17-268h px� 
a
%s*common2H
FPhase 1.1 Placer Initialization Netlist Sorting | Checksum: 24a0b982c
h px� 
�

%s
*constraints2a
_Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.007 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002
00:00:00.0012

1607.0352
0.000Z17-268h px� 
q

Phase %s%s
101*constraints2
1.2 24
2IO Placement/ Clock Placement/ Build Placer DeviceZ18-101h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
�
9Poor placement for routing between an IO pin and BUFG. %s528*place2�
�This is normally an ERROR but the CLOCK_DEDICATED_ROUTE constraint is set to FALSE allowing your design to continue. The use of this override is highly discouraged as it may lead to very poor timing results. It is recommended that this error condition be corrected in the design.

	<MSGMETA::BEGIN::BLOCK>clock_IBUF_inst<MSGMETA::END> (IBUF.O) is locked to IOB_X0Y13
	<MSGMETA::BEGIN::BLOCK>clock_IBUF_BUFG_inst<MSGMETA::END> (BUFG.I) is provisionally placed by clockplacer on BUFGCTRL_X0Y0
"�
clock_IBUF_inst2�This is normally an ERROR but the CLOCK_DEDICATED_ROUTE constraint is set to FALSE allowing your design to continue. The use of this override is highly discouraged as it may lead to very poor timing results. It is recommended that this error condition be corrected in the design.

	:" (IBUF.O) is locked to IOB_X0Y13
	"^
clock_IBUF_BUFG_inst2 :B (BUFG.I) is provisionally placed by clockplacer on BUFGCTRL_X0Y0
8Z30-574h px� 
n
%s*common2U
SPhase 1.2 IO Placement/ Clock Placement/ Build Placer Device | Checksum: 19121b665
h px� 
�

%s
*constraints2a
_Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.364 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
Y

Phase %s%s
101*constraints2
1.3 2
Build Placer Netlist ModelZ18-101h px� 
V
%s*common2=
;Phase 1.3 Build Placer Netlist Model | Checksum: 25dc98285
h px� 
�

%s
*constraints2a
_Time (s): cpu = 00:00:01 ; elapsed = 00:00:00.495 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
V

Phase %s%s
101*constraints2
1.4 2
Constrain Clocks/MacrosZ18-101h px� 
S
%s*common2:
8Phase 1.4 Constrain Clocks/Macros | Checksum: 25dc98285
h px� 
�

%s
*constraints2a
_Time (s): cpu = 00:00:01 ; elapsed = 00:00:00.504 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
O
%s*common26
4Phase 1 Placer Initialization | Checksum: 25dc98285
h px� 
�

%s
*constraints2a
_Time (s): cpu = 00:00:01 ; elapsed = 00:00:00.519 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
M

Phase %s%s
101*constraints2
2 2
Global PlacementZ18-101h px� 
L

Phase %s%s
101*constraints2
2.1 2
FloorplanningZ18-101h px� 
I
%s*common20
.Phase 2.1 Floorplanning | Checksum: 25dc98285
h px� 
�

%s
*constraints2a
_Time (s): cpu = 00:00:01 ; elapsed = 00:00:00.538 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
`

Phase %s%s
101*constraints2
2.2 2#
!Update Timing before SLR Path OptZ18-101h px� 
]
%s*common2D
BPhase 2.2 Update Timing before SLR Path Opt | Checksum: 25dc98285
h px� 
�

%s
*constraints2a
_Time (s): cpu = 00:00:01 ; elapsed = 00:00:00.541 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
_

Phase %s%s
101*constraints2
2.3 2"
 Post-Processing in FloorplanningZ18-101h px� 
\
%s*common2C
APhase 2.3 Post-Processing in Floorplanning | Checksum: 25dc98285
h px� 
�

%s
*constraints2a
_Time (s): cpu = 00:00:01 ; elapsed = 00:00:00.544 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
R

Phase %s%s
101*constraints2
2.4 2
Global Place Phase1Z18-101h px� 
O
%s*common26
4Phase 2.4 Global Place Phase1 | Checksum: 2354f3344
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
R

Phase %s%s
101*constraints2
2.5 2
Global Place Phase2Z18-101h px� 
�
dTiming had been disabled during Placer and, therefore, physical synthesis in Placer will be skipped.29*	placeflowZ46-29h px� 
O
%s*common26
4Phase 2.5 Global Place Phase2 | Checksum: 191892af0
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
J
%s*common21
/Phase 2 Global Placement | Checksum: 191892af0
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
M

Phase %s%s
101*constraints2
3 2
Detail PlacementZ18-101h px� 
Y

Phase %s%s
101*constraints2
3.1 2
Commit Multi Column MacrosZ18-101h px� 
V
%s*common2=
;Phase 3.1 Commit Multi Column Macros | Checksum: 191892af0
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
[

Phase %s%s
101*constraints2
3.2 2
Commit Most Macros & LUTRAMsZ18-101h px� 
X
%s*common2?
=Phase 3.2 Commit Most Macros & LUTRAMs | Checksum: 1b7d89937
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
U

Phase %s%s
101*constraints2
3.3 2
Area Swap OptimizationZ18-101h px� 
R
%s*common29
7Phase 3.3 Area Swap Optimization | Checksum: 16c8a9725
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
]

Phase %s%s
101*constraints2
3.4 2 
Pipeline Register OptimizationZ18-101h px� 
Z
%s*common2A
?Phase 3.4 Pipeline Register Optimization | Checksum: 16c8a9725
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
[

Phase %s%s
101*constraints2
3.5 2
Small Shape Detail PlacementZ18-101h px� 
X
%s*common2?
=Phase 3.5 Small Shape Detail Placement | Checksum: 14fffa44c
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
Q

Phase %s%s
101*constraints2
3.6 2
Re-assign LUT pinsZ18-101h px� 
N
%s*common25
3Phase 3.6 Re-assign LUT pins | Checksum: 14fffa44c
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
]

Phase %s%s
101*constraints2
3.7 2 
Pipeline Register OptimizationZ18-101h px� 
Z
%s*common2A
?Phase 3.7 Pipeline Register Optimization | Checksum: 14fffa44c
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
J
%s*common21
/Phase 3 Detail Placement | Checksum: 14fffa44c
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
e

Phase %s%s
101*constraints2
4 2*
(Post Placement Optimization and Clean-UpZ18-101h px� 
W

Phase %s%s
101*constraints2
4.1 2
Post Commit OptimizationZ18-101h px� 
T
%s*common2;
9Phase 4.1 Post Commit Optimization | Checksum: 14fffa44c
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
U

Phase %s%s
101*constraints2
4.2 2
Post Placement CleanupZ18-101h px� 
R
%s*common29
7Phase 4.2 Post Placement Cleanup | Checksum: 14fffa44c
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
O

Phase %s%s
101*constraints2
4.3 2
Placer ReportingZ18-101h px� 
[

Phase %s%s
101*constraints2
4.3.1 2
Print Estimated CongestionZ18-101h px� 
�
'Post-Placement Estimated Congestion %s
38*	placeflow2�
�
 ____________________________________________________
|           | Global Congestion | Short Congestion  |
| Direction | Region Size       | Region Size       |
|___________|___________________|___________________|
|      North|                1x1|                2x2|
|___________|___________________|___________________|
|      South|                1x1|                1x1|
|___________|___________________|___________________|
|       East|                1x1|                1x1|
|___________|___________________|___________________|
|       West|                1x1|                1x1|
|___________|___________________|___________________|
Z30-612h px� 
X
%s*common2?
=Phase 4.3.1 Print Estimated Congestion | Checksum: 14fffa44c
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
L
%s*common23
1Phase 4.3 Placer Reporting | Checksum: 14fffa44c
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
V

Phase %s%s
101*constraints2
4.4 2
Final Placement CleanupZ18-101h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002
00:00:00.0012

1607.0352
0.000Z17-268h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
b
%s*common2I
GPhase 4 Post Placement Optimization and Clean-Up | Checksum: 1b49affbc
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
D
%s*common2+
)Ending Placer Task | Checksum: 1a8444f43
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 1607.035 ; gain = 0.000h px� 
~
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
462
22
02
0Z4-41h px� 
L
%s completed successfully
29*	vivadotcl2
place_designZ4-42h px� 
�
)Running report commands "%s" in parallel.56334*	planAhead24
2report_control_sets, report_io, report_utilizationZ12-24838h px� 
Y
+Running report generation with %s threads.
56333*	planAhead2
2Z12-24831h px� 
�
Executing command : %s
56330*	planAhead2S
Qreport_utilization -file cpu_utilization_placed.rpt -pb cpu_utilization_placed.pbZ12-24828h px� 
e
Executing command : %s
56330*	planAhead2#
!report_io -file cpu_io_placed.rptZ12-24828h px� 
�
kreport_io: Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.080 . Memory (MB): peak = 1607.035 ; gain = 0.000
*commonh px� 
�
Executing command : %s
56330*	planAhead2@
>report_control_sets -verbose -file cpu_control_sets_placed.rptZ12-24828h px� 
�
ureport_control_sets: Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.009 . Memory (MB): peak = 1607.035 ; gain = 0.000
*commonh px� 
H
&Writing timing data to binary archive.266*timingZ38-480h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Write ShapeDB Complete: 2

00:00:002
00:00:00.0112

1607.0352
0.000Z17-268h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Wrote PlaceDB: 2

00:00:012
00:00:00.1652

1607.0352
0.000Z17-268h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Wrote PulsedLatchDB: 2

00:00:002

00:00:002

1607.0352
0.000Z17-268h px� 
=
Writing XDEF routing.
211*designutilsZ20-211h px� 
J
#Writing XDEF routing logical nets.
209*designutilsZ20-209h px� 
J
#Writing XDEF routing special nets.
210*designutilsZ20-210h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Wrote RouteStorage: 2

00:00:002
00:00:00.0232

1607.0352
0.000Z17-268h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Wrote Netlist Cache: 2

00:00:002
00:00:00.0062

1607.0352
0.000Z17-268h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Wrote Device Cache: 2

00:00:002
00:00:00.0102

1607.0352
0.000Z17-268h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Write Physdb Complete: 2

00:00:012
00:00:00.2172

1607.0352
0.000Z17-268h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2Q
OC:/Users/osmon/Vivado Projects/16-bit_cpu/16-bit_cpu.runs/impl_1/cpu_placed.dcpZ17-1381h px� 


End Record