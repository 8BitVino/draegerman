   10 REM Draegerman. Version 1.1 27/12/23
   20 REM Based on code elements in Gold Miner by B.Larkin, Chandler H.S. 1983 http://bbcmicro.co.uk/explore.php?id=4229
   30 REM Ported and supercharged into Draegerman by 8BitVino (c)2023
   40 REM Latest fixes: Enabled legacy mode for VDP for 1.04 compatibility. Added joystick mode for Agonlight/Console8. Added 100 moves each level
   50 REM DISCLAIMER:
   60 REM 1. This game is not associated with, endorsed by, or affiliated with any mining or safety companies and draws it's name from commonly applied term of rescue workers.
   70 REM 2. This version of Draegerman is Shareware and can be distributed freely (see github for license information)
   80 REM 2. I worked really, really hard to programme this so don't rip me of without credit
   90 REM SHOP REWARD C E G
  100 VDU23,0,&C1,3
  110 DATA 101,149,69,117,81,129
  120 REM Dragerman theme song C#3,E3,F#2,B2,F#2,A3,B2,A3,B2 C%4,E4,F#3,B4,F#3,A4,B4,A4,B4
  130 DATA 57,105,69,117,29,77,49,145,29,77,89,137,49,145,89,137
  140 REM Dragerman theme song ending b2,e2,f#2 b4,e3,f#3
  150 DATA 49,145,21,69,29,77
  160 REM Level1 end D A G A. 2,3.4,5
  170 DATA 13,109,41,137,33,129,41,137,61,157,89,185,81,177,89,185
  180 REM Level2 end F# C# B C# 2,3. 4,5
  190 DATA 29,125,57,153,49,145,57,153,77,173,105,201,97,193,105,201
  200 REM Level3 end F# C# B C#, 2,3. 3,4.
  210 DATA 77,125,57,105,49,97,57,105,125,173,105,153,97,145,105,153
  220 REM Level 4 Mission music E G B E 2,3.3,4
  230 DATA 21,69,33,81,49,97,21,69,69,117,81,129,97,145,69,117
  240 REM Bad ending. E B C# G#. 2,3.4,5
  250 DATA 21,117,13,109,17,113,9,105,69,165,61,157,65,161,57,153
  260 REM Medium ending. A E F# C#. 2,3.3,4
  270 DATA 41,89,21,69,29,77,17,65,89,137,69,117,77,125,65,113
  280 REM Good ending. D G B D G B G F#. 2,3.3,4
  290 DATA 13,61,33,81,49,97,13,61,33,81,49,97,33,81,29,77
  300 REM Good ending 2.C E G C G B D G. 2,3.3,4
  310 DATA 53,101,69,117,81,129,53,101,81,129,49,97,61,109,81,129
  320 REM REWARD Gem C E C E
  330 DATA 53,101,21,69,101,149,69,97
  340 REM REWARD Miner saved
  350 DATA 109,77,137,57,97,65,129,145
  360 REM town names
  370 DATA "Moura 1994","Northparkes 1999","Beaconsfield 2006","Antartica 2023"
  380 REM real mine depth
  390 DATA 87,170,397,417
  400 REM game mine depth
  410 DATA 20,32,46,46
  420 REM MagicObjects gems and miners to save
  430 DATA 5,7,9,1
  440 REM Granite quantities per level
  450 DATA 50,75,100,150
  460 REM RebuyCosts how much a reload from store costs
  470 DATA 20,25,25,1000
  480 REM Rescued. The actual number of miners that have been saved
  490 DATA 4,5,7,1
  500 REM TimerZ amount of moves allowed per level
  510 DATA 450,600,650,350
  520 REM MINERS. number of store rebuys allowed
  530 DATA 2,2,3,0
  540 REM number of cave fall ins that occur
  550 DATA 5,10,20,20
  560 REM Moura 350 moves, restock fee 20 , 4/5 to save
  570 REM Northparkes 500 moves, restock fee 25, 5/7 to save
  580 REM Beaconsfield 550 moves,restock fee 25, 7/9 to save
  590 REM Antartica 250,no restock, 1/1 to save
  600 MODE1
  610 ON ERROR CLS:PRINT"Unexpected Error! Seems like your request has been intercepted":PRINT"by Master Control Program. Sending Tron to debug.":GOTO8720
  620 REM INITIALIZE ONCE
  630 PROCchar
  640 PROCworlds
  650 REM END INITALIZE ONCE
  660 VDU23,1,0
  670 COLOUR15
  680 HC%=0:UP=253:DOWN=247:LEFT=223:RIGHT=127:FIRE=215
  690 SIG$="8BitVino"
  700 CLS
  710 PROCbigfont(20,10)
  720 PROCtune(120,8,2,20,5)
  730 PROCtune(140,3,1,20,10)
  740 COLOUR7:PRINTTAB(15,29);"Dare to descend and rise as a hero"
  750 PRINTTAB(47,46);"(c)2023 ";SIG$
  760 COLOUR15
  770 PRINTTAB(15,33);"(c)redits (UP joystick)"
  780 PRINTTAB(15,35);"(i)nstructions (DOWN joystick)"
  790 PRINTTAB(15,37);"(t)ips (LEFT joystick)"
  800 PRINTTAB(15,39);"(h)ardcore toggle (RIGHT joystick)"
  810 i=1
  820 REPEAT
  830   IF i=1 THEN PROCtitles
  840   i=i+1
  850   K=INKEY(1)
  860   T=GET(158)
  870   IF (T AND UP)=T THEN K=67
  880   IF (T AND DOWN)=T THEN K=73
  890   IF (T AND LEFT)=T THEN K=84
  900   IF (T AND RIGHT)=T THEN K=72
  910   T=GET(162)
  920   IF (T AND FIRE)=T THEN K=32
  930   IF i=30 THEN i=1
  940 UNTIL K>31
  950 IF K=69 OR K=101 THEN PROCeasy
  960 IF K=32 THEN GOTO1030 :REM SPACEBAR
  970 IF K=73 OR K=105 THEN PROCinstruct
  980 IF K=72 OR K=104 THEN PROChardcore
  990 IF K=84 OR K=116 THEN PROCtips
 1000 IF K=67 OR K=99 THEN PROCcredits
 1010 GOTO730
 1020 REM ***GAME starts***
 1030 FOR Y=33 TO 43 STEP 2:PRINTTAB(9,Y);STRING$(42,CHR$32):NEXT Y
 1040 PRINTTAB(20,34);"GOOD LUCK DRAEGERMAN!"
 1050 PROCtune(160,8,1,20,5)
 1060 CLS
 1070 VDU23,1,0
 1080 LVL%=1:NextLVL%=0:MSGTimer%=5:Retire%=0:Mystery=0
 1090 FOR d=1TO4:Survived%(d)=0:Deaths%(d)=0:NEXT d
 1100 PROCscreen
 1110 REM *** MAIN GAME LOOPS STARTS ***
 1120 E%=0
 1130 REPEAT
 1140   K=INKEY(1)
 1150   IF E%=30 PROCanimation:E%=0
 1160   REM JOYSTICK CODE
 1170   T=GET(158)
 1180   IF (T AND UP)=T THEN K=11
 1190   IF (T AND DOWN)=T THEN K=10
 1200   IF (T AND LEFT)=T THEN K=8
 1210   IF (T AND RIGHT)=T THEN K=21
 1220   T=GET(162)
 1230   IF (T AND FIRE)=T THEN K=32
 1240   REM END JOYSTICK CODE
 1250   IFK=32 PROCblast:PROCcavein(20):GOTO1130
 1260   IFK=10 OR K=11 THEN PROCmove :REM ensures only valid moves go to ProcMOVE
 1270   IFK=8 OR K=21 THEN PROCmove
 1280   E%=E%+1
 1290 UNTIL FALSE
 1300 REM *** MAIN GAME LOOP ENDS ***
 1310 DEFPROCanimation
 1320 F%=239+RND(4)
 1330 COLOUR3:PRINTTAB(NX%,NY%);CHR$(F%)
 1340 ENDPROC
 1350 DEFPROCbigR(x,y,r,c)
 1360 COLOURr:PRINTTAB(x,y);STRING$(3,CHR$c):PRINTTAB(x,y+1);CHR$c
 1370 PRINTTAB(x,y+2);CHR$c:PRINTTAB(x,y+3);CHR$c:PRINTTAB(x,y+4);CHR$(c)
 1380 ENDPROC
 1390 DEFPROCbigA(x,y,r,c,o)
 1400 COLOURr:PRINTTAB(x,y);SPC(1);CHR$c:PRINTTAB(x,y+1);STRING$(3,CHR$c)
 1410 PRINTTAB(x,y+2);CHR$c;SPC(1);CHR$c:PRINTTAB(x,y+3);STRING$(3,CHR$c):PRINTTAB(x,y+4);CHR$c;SPC(1);CHR$c
 1420 IF o=1 THEN PRINTTAB(x,y-2);CHR$(c);SPC(1);CHR$c:
 1430 ENDPROC
 1440 DEFPROCbigE(x,y,r,c)
 1450 COLOURr:PROCbigR(x,y,r,c):PRINTTAB(x+1,y+2);CHR$c;CHR$c:PRINTTAB(x+1,y+4);CHR$c;CHR$c
 1460 ENDPROC
 1470 DEFPROCbigG(x,y,r,c)
 1480 COLOURr:PRINTTAB(x,y);STRING$(3,CHR$c):PRINTTAB(x,y+1);CHR$c;SPC(1);CHR$c:PRINTTAB(x,y+2);CHR$c;SPC(1);CHR$c
 1490 PRINTTAB(x,y+3);CHR$c;SPC(1);CHR$c:PRINTTAB(x,y+4);STRING$(3,CHR$c):PRINTTAB(x+2,y+5);CHR$c
 1500 PRINTTAB(x+2,y+6);CHR$c:PRINTTAB(x,y+7);STRING$(3,CHR$c)
 1510 ENDPROC
 1520 DEFPROCbigD(x,y,r,c)
 1530 COLOURr:PRINTTAB(x,y);STRING$(3,CHR$c):PRINTTAB(x,y+1);STRING$(3,CHR$c):PRINTTAB(x,y+2);CHR$c;SPC(1);CHR$c
 1540 PRINTTAB(x,y+3);CHR$c;SPC(1);CHR$c:PRINTTAB(x,y+4);STRING$(3,CHR$c):PRINTTAB(x+2,y-1);CHR$c:PRINTTAB(x+2,y-2);CHR$c
 1550 PRINTTAB(x+2,y-3);CHR$c:PRINTTAB(x+2,y-4);CHR$c
 1560 ENDPROC
 1570 DEFPROCbigM(x,y,r,c)
 1580 COLOURr:PROCbigN(x,y,r,c):PROCbigN(x+2,y,r,c):PRINTTAB(x+2,y);CHR$32
 1590 ENDPROC
 1600 PRINTTAB(x,y+3);CHR$c;SPC(1);CHR$c;SPC(1);CHR$c:PRINTTAB(x,y+4);CHR$c;SPC(1);CHR$c;SPC(1);CHR$c;
 1610 ENDPROC
 1620 DEFPROCbigN(x,y,r,c)
 1630 COLOURr:PRINTTAB(x,y);CHR$c:PRINTTAB(x,y+1);STRING$(3,CHR$c):PRINTTAB(x,y+2);CHR$c;SPC(1);CHR$c;
 1640 PRINTTAB(x,y+3);CHR$c;SPC(1);CHR$c:PRINTTAB(x,y+4);CHR$c;SPC(1);CHR$c;
 1650 ENDPROC
 1660 DEFPROCinstruct
 1670 PROCborder
 1680 PROCheader
 1690 COLOUR15
 1700 PRINTTAB(22,5);"Welcome to Draegerman"
 1710 PRINTTAB(10,9);"A strategy game where you take on the role"
 1720 PRINTTAB(10,11);"of a brave draegerman, whose mission is"
 1730 PRINTTAB(10,13);"to save trapped miners deep within the"
 1740 PRINTTAB(10,15);"treacherous underground mines."
 1750 PRINTTAB(10,19);"As you descend into the depths you'll use"
 1760 PRINTTAB(10,21);"dynamite to blast through blocked paths,"
 1770 PRINTTAB(10,23);"collect valuable gold and treasures but"
 1780 PRINTTAB(10,25);"need to strategically plan your resupply"
 1790 PRINTTAB(10,27);"trips to the store."
 1800 PRINTTAB(10,31);"With each level, the challenges increase"
 1810 PRINTTAB(10,33);"and your skills as a rescuer will be put"
 1820 PRINTTAB(10,35);"to the test."
 1830 PRINTTAB(18,39);"Are you ready to embark on"
 1840 PRINTTAB(18,41);"thrilling rescue missions?"
 1850 PROCanything
 1860 PROCborder
 1870 PROCheader
 1880 COLOUR15
 1890 PRINTTAB(26,5);"Game rules"
 1900 PRINTTAB(10,13);"MOVEMENT: Use arrow keys or joystick"
 1910 PRINTTAB(10,15);"DYNAMITE: Use fire button or spacebar"
 1920 PRINTTAB(10,17);"COLLECT GOLD: Use at the store for resupply"
 1930 PRINTTAB(10,19);"COLLECT GEMS: Retire as rich Draegerman!"
 1940 PRINTTAB(10,21);"AVOID GRANITE ROCKS: They cannot be destroyed!"
 1950 PRINTTAB(10,23);"TIME LIMIT: Don't let miners run out oxygen"
 1960 PRINTTAB(10,25);"PROGRESS LEVEL: Save miners! when:  becomes:"
 1970 PRINTTAB(10,27);"HARDCORE MODE: You must save every miner to"
 1980 PRINTTAB(10,29);"proceed to next level for 50% score bonus"
 1990 PRINTTAB(10,31);"Put on your helmet, grab your dynamite..."
 2000 PRINTTAB(16,35);"Will you rise to the challenge"
 2010 PRINTTAB(21,37);"and become a hero?"
 2020 PRINTTAB(18,43);"Good luck, Draegerman!"
 2030 COLOUR9:PRINTTAB(44,25);CHR$224
 2040 COLOUR10:PRINTTAB(54,25);CHR$225
 2050 COLOUR15
 2060 PROCanything
 2070 CLS
 2080 ENDPROC
 2090 DEFPROCchar
 2100 VDU23,230,255,255,255,255,255,255,255,255   : REM defines 230 as the block character
 2110 VDU23,239,56,24,137,126,24,24,60,102   : REM defines 239 as SAVE ME MINER
 2120 VDU23,240,16,56,16,186,254,56,100,132 :REM Draegerman
 2130 VDU23,241,16,56,16,184,254,56,36,36 :REM Draeger2
 2140 VDU23,242,16,56,16,186,254,56,100,70 :REM Draeger3
 2150 VDU23,243,16,56,16,58,254,56,36,36 :REM Draeger4
 2160 VDU23,220,0,24,60,126,102,102,102,102,0,0  : REM House
 2170 VDU23,221,0,0,24,60,126,60,24,0,0,0     : REM Diamond filled
 2180 VDU23,222,0,24,36,66,129,66,36,24,0,0   : REM Diamond unfilled
 2190 VDU23,223,0,24,60,90,165,90,60,24,0,0  : REM Diamond sparkle
 2200 VDU23,224,254,195,165,153,153,165,195,254,254 :REM No exit door
 2210 VDU23,225,254,130,130,130,130,138,130,254,254 : REM exit door
 2220 VDU23,226,0,0,0,0,0,0,0,0,0 :REM EMPTY BLOCK
 2230 VDU23,231,8,60,106,94,52,24,24,24 :REM APPLE TREE
 2240 VDU23,232,0,0,4,28,34,65,62,58 :REM HOUSE
 2250 VDU23,233,0,0,0,0,16,56,16,16 : REM CROSS
 2260 VDU23,234,0,0,0,0,24,60,60,126 :REM MOUND
 2270 VDU23,235,8,8,62,8,8,127,8,8 : REM TELEPHONE POLES
 2280 VDU23,210,255,255,195,195,195,255,255,255 : REM MANSION WINDOW
 2290 VDU23,211,255,255,227,227,227,235,227,227 : REM MANSION DOOR
 2300 VDU23,212,001,003,007,015,031,063,127,255 :REM MANSION LEFT SIDING
 2310 VDU23,213,128,192,224,240,248,252,254,255: REM MANSION RIDE SIDING
 2320 VDU23,214,0,8,28,62,127,255,255,255 :REM MANSION ROOFING
 2330 VDU23,215,24,60,126,126,255,255,231,231 :REM igloo
 2340 VDU23,216,28,62,42,62,119,93,28,20 :REM pengiun
 2350 VDU23,217,60,102,110,106,110,102,60,66 :REM antdoor
 2360 VDU23,218,24,8,60,126,255,213,127,62 :REM submarine
 2370 M$=CHR$220+CHR$212+CHR$213+CHR$220  :REM MANSION TOP
 2380 N$=CHR$231+CHR$32+CHR$230+CHR$210+CHR$211+CHR$230
 2390 A$=CHR$32+CHR$239+CHR$240+CHR$232+CHR$235
 2400 T$=CHR$32+STRING$(3,CHR$231)
 2410 U$=STRING$(4,CHR$233)+CHR$211+STRING$(4,CHR$233) :REM CEMETARY
 2420 ENDPROC
 2430 DEFPROCscreen
 2440 CLS
 2450 NX%=19:NY%=2 :REM defines starting place for draeger
 2460 G%=0:CH%=20
 2470 IF LVL%=4 THEN CH%=50 :REM extra dynamite for last level!
 2480 GEM%=0:SAV%=0
 2490 DEP%=MineDepth(LVL%)
 2500 DEPP%=DEP%-1
 2510 TIMEX%=TimerZ(LVL%):nomove%=0
 2520 COLOUR2 : REM green grass
 2530 IF LVL%=4 THEN COLOUR 15
 2540 FORX=0TO39:PRINTTAB(X,2);CHR$230:NEXT
 2550 COLOUR8 : REM grey external walls
 2560 FORY=3TODEP%:PRINTTAB(39,Y);CHR$230:NEXT
 2570 FORX=39TO0 STEP-1:PRINTTAB(X,DEP%);CHR$230:NEXT
 2580 FORY=DEP%TO3 STEP-1:PRINTTAB(0,Y);CHR$230 :NEXT
 2590 COLOUR9  : REM 9 IS RED 10 IS GREEN
 2600 PRINTTAB(14,1);"NO";CHR$224
 2610 IF LVL%=4 THEN PRINTTAB(16,1);CHR$218
 2620 COLOUR15
 2630 PROCshowtown  :REM show the town gfx top screen
 2640 COLOUR8
 2650 REM TOWN LOGO
 2660 PRINTTAB(43,1);STRING$(20,CHR$230)
 2670 PRINTTAB(43,7);STRING$(20,CHR$230)
 2680 PRINTTAB(43,25);STRING$(20,CHR$230)
 2690 PRINTTAB(43,33);STRING$(20,CHR$230)
 2700 PRINTTAB(43,45);STRING$(20,CHR$230)
 2710 COLOUR 15
 2720 REM STORE PRINT TOP
 2730 IF LVL%=4 THEN GOTO2760
 2740 PRINTTAB(22,1);CHR$220;"Store"
 2750 REM STATS MENU
 2760 PRINTTAB(44,3);TownName$(LVL%)
 2770 IF LVL%=4 THEN PRINTTAB(44,4);"The Perilous Abyss":GOTO2790
 2780 PRINTTAB(44,4);"Australia"
 2790 PRINTTAB(44,5);"Mine depth ";RealDepth(LVL%)*10;" ft"
 2800 PRINTTAB(46,10);"Lost       ";MagicObjects(LVL%)
 2810 PRINTTAB(46,12);"Rescued    0"
 2820 PRINTTAB(46,14);"Resupplies ";MINERS(LVL%)
 2830 PRINTTAB(46,16);"Gold      $0"
 2840 PRINTTAB(46,18);"Gems       0"
 2850 PRINTTAB(46,20);"Oxygen     ";TIMEX%;
 2860 PRINTTAB(46,22);"Dynamite   ";CH%
 2870 IF LVL%=4 THEN GOTO2890
 2880 PRINTTAB(44,35);"Restock fee  $";RebuyCost(LVL%)
 2890 PRINTTAB(44,37);"Retirement   $";Retire%
 2900 PRINTTAB(46,39);"Draeger";SPC(4);"Miners"
 2910 PRINTTAB(46,41);"Gold";SPC(7);"Gems"
 2920 PRINTTAB(46,43);"Granite";SPC(4);"Dirt"
 2930 PRINTTAB(44,27);"Messages:" :REM STATIC
 2940 COLOUR3:PRINTTAB(44,39);CHR$240 :REM Draeger
 2950 COLOUR9:PRINTTAB(55,39);CHR$239 :REM Miners
 2960 COLOUR14:PRINTTAB(55,41);CHR$223 :REM GEMS
 2970 COLOUR8:PRINTTAB(44,43);CHR$230 : REM GRANITE
 2980 COLOUR1:PRINTTAB(55,43);CHR$230 : REM DIRT
 2990 COLOUR11:PRINTTAB(44,41);CHR$230 :REM GOLD
 3000 IF LVL%=4 THEN COLOUR15:PRINTTAB(44,41);CHR$230;SPC(1);"Ice ":PRINTTAB(55,43);STRING$(6,CHR$32):GOTO3010 :REM ICE
 3010 COLOUR3:PRINTTAB(NX%-1,NY%);" ";CHR$240;" "
 3020 FORY=3TODEPP%
 3030   FORX=1TO38
 3040     IFY=3 THEN IFX=18 OR X=19 OR X=20 THEN 3100
 3050     IFB%>0 GOTO3070
 3060     IFC%>0 GOTO3100
 3070     B%=B%-1:COLOUR11
 3080     IF LVL%=4 THEN COLOUR0 :REM ANTARTICA BLACK
 3090     PRINTTAB(X,Y);CHR$230:GOTO3130  :REM GOLD PLACEMENT
 3100     C%=C%-1:COLOUR1
 3110     IF LVL%=4 THEN COLOUR15 :REM ANTARTICA WHITE
 3120     PRINTTAB(X,Y);CHR$230:GOTO3130 :REM RED ROCKS
 3130     IF B%<1 AND C%<1 PROCdecide
 3140   NEXT
 3150 NEXT
 3160 COLOUR 8 :REM GRANITE GREY ROCK COLOUR
 3170 FOR N=1 TO Granite(LVL%)
 3180   REPEAT
 3190     U%=RND(DEPP%-1)
 3200   UNTIL U%>=5
 3210   H%=RND(37)
 3220   FOR G=1 TO RND(3)
 3230     PRINTTAB(H%,U%);CHR$230
 3240     H%=H%+1
 3250     D%=RND(3)
 3260     IF D%=1 THEN U%=U%+1
 3270     IF D%=2 THEN U%=U%-1 :REM RANDOMLY EITHER UP FOR DOWN P. NEXT PIECE
 3280   NEXT
 3290 NEXT
 3300 COLOUR 14 : REM GEM CYAN COLIUR
 3310 FOR N=1 TO MagicObjects(LVL%)
 3320   REPEAT
 3330     P%=RND(DEPP%)
 3340   UNTIL P%>=4
 3350   PRINTTAB(RND(38),P%);CHR$223 :REM GEM PLACEMENT
 3360 NEXT
 3370 COLOUR 9 : REM MINER STRONG RED COLOUR
 3380 FOR N=1 TO MagicObjects(LVL%)
 3390   REPEAT
 3400     P%=RND(DEPP%)
 3410   UNTIL P%>=10
 3420   PRINTTAB(RND(38),P%);CHR$239 :REM SAVE MINER PLACEMENT
 3430 NEXT
 3440 REM mystery object placement one per map
 3450 COLOUR5
 3460 PRINTTAB(RND(32),DEPP%);CHR$42  :REM ALWAYS PLACED MYSTERY OBJECT ON BOTTOM OF MAP (INCENTIVE.HA!HA!)
 3470 COLOUR15
 3480 ENDPROC
 3490 DEFPROCblast
 3500 IF NY%=1 GOTO3910 :REM don't allow explosives on top level
 3510 CH%=CH%-1:IF CH%=-1 THEN PROCbadpicker ELSE GOTO3530
 3520 WAIT=GET
 3530 PRINTTAB(58,22);" "
 3540 IF CH%<4 COLOUR9:PRINTTAB(57,22);CH%:COLOUR3
 3550 IF CH%>=4 PRINTTAB(57,22);CH%
 3560 IF CH%=10 OR CH%=6 THEN PROCdynwarn
 3570 IF CH%=3 OR CH%=1 THEN PROCdynwarn
 3580 SOUND1,-10,100,5
 3590 REM MARKING ALL GREY BLOCKS
 3600 RI%=0:LE%=0:UP%=0:DN%=0
 3610 HOG%=NX%*20+8 :
 3620 VEG%=(47-NY%)*21+16
 3630 IF POINT(HOG%+20,VEG%)=8 THEN RI%=1
 3640 IF POINT(HOG%-20,VEG%)=8 THEN LE%=1
 3650 IF POINT(HOG%,VEG%+21)=8 THEN UP%=1
 3660 IF POINT(HOG%,VEG%-21)=8 THEN DN%=1
 3670 REM NOW EXPLOSIONS
 3680 COLOUR 9 :REM RED
 3690 FOR TT%=0TO5
 3700   FOR DELAY=0TO500:NEXT
 3710   IFNY%<=2 GOTO3750
 3720   IFNY%>3 PRINTTAB(NX%,NY%-1);CHR$88
 3730   IFNX%>1 PRINTTAB(NX%-1,NY%);CHR$88
 3740   IFNX%<38PRINTTAB(NX%+1,NY%);CHR$88
 3750   IFNY%<DEPP%PRINTTAB(NX%,NY%+1);CHR$88
 3760   FOR DELAY=0TO500:NEXT
 3770   IFNY%<=2 GOTO3810
 3780   IFNY%>3 PRINTTAB(NX%,NY%-1);CHR$32
 3790   IFNX%>1 PRINTTAB(NX%-1,NY%);CHR$32
 3800   IFNX%<38PRINTTAB(NX%+1,NY%);CHR$32
 3810   IFNY%<DEPP%PRINTTAB(NX%,NY%+1);CHR$32
 3820   IF TT%<3 GOTO3830
 3830 NEXT
 3840 REM REPLACING ALL GREY BLOCKS DESTROYED
 3850 COLOUR8
 3860 IF RI%=1 PRINTTAB(NX%+1,NY%);CHR$230
 3870 IF LE%=1 PRINTTAB(NX%-1,NY%);CHR$230
 3880 IF UP%=1 PRINTTAB(NX%,NY%-1);CHR$230
 3890 IF DN%=1 PRINTTAB(NX%,NY%+1);CHR$230
 3900 PROCcavein(40)
 3910 ENDPROC
 3920 DEFPROCcavein(CI%)
 3930 IF NY%<=3 GOTO 4050 :REM SKIP IF WE ARE IN TOP AREA FOR PERFORMANCE BOOST
 3940 FORCC%=0TO CI%
 3950   CX%=RND(38):CY%=RND(DEPP%)+3:HOC%=CX%*20+8:VEC%=(47-CY%)*21+16:VECC%=VEC%-21   :REM VECC% MIGHT BE WRONG
 3960   IF POINT(HOC%,VEC%)=1 AND POINT(HOC%,VECC%)=0 THEN 3990
 3970   IF POINT(HOC%,VEC%)=15 AND POINT(HOC%,VECC%)=0 THEN 4000
 3980   GOTO4030
 3990   SOUND0,-10,5,2:COLOUR1:PRINTTAB(CX%,CY%+1);CHR$230:GOTO4010
 4000   IF LVL%=4 THEN SOUND0,-10,5,2:COLOUR15:PRINTTAB(CX%,CY%+1);CHR$230:GOTO4030 :REM ANTARTICA
 4010   IF HC%=1 PRINTTAB(CX%,CY%);CHR$32
 4020   REM HARDCORE MODE WILL CAUSE LANDSLIDE NOT TO BACKFILL OPEN
 4030 NEXT
 4040 COLOUR3
 4050 ENDPROC
 4060 DEFPROChardcore
 4070 COLOUR9
 4080 PRINTTAB(21,31);"HARDCORE GAME MODE"
 4090 REM set so bonus at level ends
 4100 IF HC%=1 GOTO 4180
 4110 HC%=1
 4120 FOR U=1TO4
 4130   blob=MagicObjects(U)
 4140   Rescued(U)=blob
 4150 NEXT U
 4160 GOTO 4250
 4170 REM DEFPROCnormal
 4180 HC%=0 :REM CALL BACK ON NORMAL MODE
 4190 COLOUR10
 4200 PRINTTAB(21,31);"NORMAL GAME MODE  "
 4210 RESTORE 490
 4220 FOR U=1TO4
 4230   READ MagicObjects(U)
 4240 NEXT U
 4250 ENDPROC
 4260 DEFPROCeasy
 4270 FOR U=1TO4:
 4280   Rescued(U)=1
 4290 NEXT U
 4300 COLOUR13
 4310 PRINTTAB(23,31);"EASY GAME MODE    "
 4320 ENDPROC
 4330 DEFPROCclearmsg
 4340 PRINTTAB(41,29);STRING$(23,CHR$32)
 4350 MSGTimer%=5 :REM reset and then call in 5 again
 4360 ENDPROC
 4370 DEFPROCgrasscheck
 4380 IF NX%<18 OR NX%>20 THEN nomove%=1
 4390 ENDPROC
 4400 DEFPROCgrassside
 4410 IF K=8 AND NX%=18 THEN nomove%=1
 4420 IF K=21 AND NX%=20 THEN nomove%=1
 4430 ENDPROC
 4440 DEFPROCgrassbelow
 4450 IF K=10 AND NX%=17 THEN nomove%=1
 4460 IF K=10 AND NX%=21 THEN nomove%=1
 4470 IF K=8 AND NX%=17 THEN PROClocked
 4480 ENDPROC
 4490 DEFPROCcheckfunds
 4500 IF LVL%=4 THEN GOTO 4530
 4510 IF G%-RebuyCost(LVL%)<0 THEN PROCclearmsg:COLOUR9:PRINTTAB(43,29);"Not enough gold":COLOUR15:GOTO 4530
 4520 PROCresupply
 4530 nomove%=1
 4540 NX%=21:NY%=1   :REM MOVE TO 21
 4550 COLOUR3:PRINTTAB(NX%,NY%);CHR$240
 4560 ENDPROC
 4570 DEFPROCresupply
 4580 PROCtune(100,3,1,0,2)
 4590 MINERS(LVL%)=MINERS(LVL%)-1:
 4600 IF MINERS(LVL%)=-1 THEN PROCbadpicker
 4610 COLOUR3:PRINTTAB(57,14);MINERS(LVL%)
 4620 PROCclearmsg:COLOUR10:PRINTTAB(43,29);"Resupplied dynamite":COLOUR15
 4630 CH%=20
 4640 G%=G%-RebuyCost(LVL%) :REM decrement the gold balance
 4650 COLOUR3:PRINTTAB(57,16);"   ":PRINTTAB(57,16);G%:PRINTTAB(57,22);CH%
 4660 ENDPROC
 4670 DEFPROClocked
 4680 IF NextLVL%=0 THEN PROCclearmsg:COLOUR9:PRINTTAB(43,29);"Door is locked!":COLOUR15:nomove%=1
 4690 ENDPROC
 4700 DEFPROChicheck
 4710 IF K=11 AND NY%=1 THEN nomove%=1 :REM Don't allow exit top screen
 4720 IF NY%=2 THEN PROCgrassside :REM check if we are on grass level
 4730 IF NY%=1 THEN PROCgrassbelow :REM check if we are above grass and try going down
 4740 IF K=11 AND NY%=3 THEN PROCgrasscheck :REM we check when on the row below grass
 4750 IF NX%=17 AND NY%=1 PROCbssay :REM NEXT LEVEL  bssay
 4760 ENDPROC
 4770 DEFPROCmove
 4780 PROChicheck
 4790 CAVEIN=RND(4)
 4800 IF CAVEIN=1 PROCcavein(CaveRisk(LVL%))  :REM CALLs in value of caverisk to cavin
 4810 IF NY%<=3 THEN PROChicheck :REM we do a single check for the NY position rather than all 4 conditions
 4820 IF nomove%=1 THEN GOTO5010 :REM if we hit any illegal locations then skip end
 4830 MSGTimer%=MSGTimer%-1 :REM decrement the message timer
 4840 PROCchecktimers :REM run routines for checking warning or clear warnings
 4850 OX%=NX%:OY%=NY%
 4860 IF K=10 THEN NY%=NY%+1:GOTO4910
 4870 IF K=11 THEN NY%=NY%-1:GOTO4910
 4880 IF K=8 THEN NX%=NX%-1:GOTO4910
 4890 IF K=21 THEN NX%=NX%+1
 4900 IF NX%=22 AND NY%=1 PROCcheckfunds:GOTO5010
 4910 HO%=NX%*20+8:VE%=(47-NY%)*21+16
 4920 PROCtimeupdate
 4930 IF POINT(HO%,VE%)=1 OR POINT(HO%,VE%)=8 THEN NX%=OX%:NY%=OY%:GOTO5010
 4940 IF POINT(HO%,VE%)=11 THEN PROCgoldfind:GOTO4990
 4950 IF POINT(HO%,VE%)=14 THEN PROCgemfind:GOTO4990
 4960 IF POINT(HO%,VE%)=15 THEN NX%=OX%:NY%=OY%:GOTO5010 :REM ANTARTICA
 4970 IF POINT(HO%,VE%)=9 THEN PROCsaveme:GOTO4990 :REM SAVED A MINER
 4980 IF POINT(HO%,VE%)=5 THEN PROCmystery:GOTO4990 :REM YOU FOUND A MYSTERY OBJECT
 4990 COLOUR3:PRINTTAB(NX%,NY%);CHR$240 : REM SHOW MINER
 5000 PRINTTAB(OX%,OY%);CHR$32 : REM SHOW BLANK WHERE CAME FROM
 5010 nomove%=0 :REM RESET THE NO MOVE
 5020 ENDPROC
 5030 DEFPROCtimeupdate
 5040 TIMEX%=TIMEX%-1
 5050 IF TIMEX%=99 OR TIMEX%=9 THEN PRINTTAB(58,20);"  "
 5060 IF TIMEX%>=50 THEN COLOUR3:PRINTTAB(57,20);TIMEX%:GOTO5080  :REM UPDATE THE MOVE COUNTER.
 5070 IF TIMEX%<50 THEN COLOUR9:PRINTTAB(57,20);TIMEX%:COLOUR3
 5080 ENDPROC
 5090 DEFPROCgemfind
 5100 GEM%=GEM%+1:PRINTTAB(57,18);GEM%
 5110 PROCclearmsg:COLOUR14:PRINTTAB(43,29);"Wow! what a gem!"
 5120 PROCtune(320,4,1,0,3)
 5130 ENDPROC
 5140 DEFPROCgoldfind
 5150 G%=G%+1:PRINTTAB(57,16);G%
 5160 ENDPROC
 5170 DEFPROCdynwarn
 5180 PROCclearmsg:COLOUR9:PRINTTAB(43,29);CH%;" EXPLOSIVES LEFT"
 5190 MSGTimer%=5
 5200 COLOUR15
 5210 ENDPROC
 5220 DEFPROCchecktimers  :REM this runs at start of every move change
 5230 IF MSGTimer%=0 THEN PROCclearmsg
 5240 IF TIMEX%>50 THEN GOTO5280
 5250 IF TIMEX%=50 OR TIMEX%=25 THEN PROCwarntime:GOTO 5280
 5260 IF TIMEX%=10 OR TIMEX%=5 THEN PROCwarntime:GOTO 5280
 5270 IF TIMEX%=0 THEN PROCbadpicker
 5280 ENDPROC
 5290 DEFPROCwarntime
 5300 COLOUR9:PRINTTAB(41,31);"Warning ";TIMEX%;" oxygen left"
 5310 COLOUR15
 5320 MSGTimer%=5 :REM Reset the message timer
 5330 ENDPROC
 5340 DEFPROCmystery
 5350 PROCclearmsg:COLOUR5:PRINTTAB(43,29);"Mystery object found"
 5360 COLOUR15
 5370 MSGTimer%=5
 5380 ENDPROC
 5390 DEFPROCsaveme
 5400 SAV%=SAV%+1
 5410 PROCtune(340,4,1,0,3)
 5420 PRINTTAB(57,10);(MagicObjects(LVL%)-SAV%)
 5430 PRINTTAB(57,12);SAV%
 5440 PROCclearmsg:COLOUR10:PRINTTAB(43,29);"Thank you Draegerman"
 5450 COLOUR15
 5460 MSGTimer%=5
 5470 IF SAV%>=Rescued(LVL%) THEN PROCsesame
 5480 ENDPROC
 5490 DEFPROCsesame
 5500 COLOUR10  : REM GREEN
 5510 IF LVL%<>4 PRINTTAB(14,1);"GO";CHR$225:GOTO5530
 5520 PRINTTAB(14,1);"GO";CHR$218
 5530 PRINTTAB(43,31);"Exit: Open sesame!"
 5540 COLOUR15 :REM BACK TO WHITE
 5550 MSGTimer%=5
 5560 NextLVL%=1 :REM enable next level progression
 5570 ENDPROC
 5580 DEFPROCbssay
 5590 IF NextLVL%=0 GOTO 6040
 5600 CLS
 5610 PROCcensus
 5620 LVL%=LVL%+1:NextLVL%=0
 5630 IF LVL%=5 THEN GOTO6030
 5640 COLOUR15
 5650 IF SAV%=MagicObjects(LVL%-1) THEN PRINTTAB(18,19);"Well done! All miners saved!"
 5660 IF SAV%<MagicObjects(LVL%-1) THEN PRINTTAB(11,19);"Not all miners saved. Try harder next time!"
 5670 PRINTTAB(5,40);"COMPLETED  ";STRING$(12,CHR$62);SPC(1);CHR$240;SPC(1);STRING$(12,CHR$62);SPC(3);"NEXT"
 5680 PRINTTAB(5,42);TownName$(LVL%-1)
 5690 IF LVL%<>5 THEN PRINTTAB(46,42);TownName$(LVL%)
 5700 IF LVL%=5 THEN PRINTTAB(46,42);"Retirement!"
 5710 PRINTTAB(9,44);CHR$231;CHR$232;CHR$231;CHR$232;CHR$232;CHR$220;SPC(35);CHR$231;CHR$232;CHR$231CHR$232;CHR$232;CHR$220;
 5720 COLOUR(2)
 5730 PRINTTAB(15,21);STRING$(33,CHR$230)
 5740 PRINTTAB(17,23);"C L E A R E D     M I N E   ";(LVL%-1)
 5750 PRINTTAB(15,25);STRING$(33,CHR$230)
 5760 PRINTTAB(17,27);"Oxygen remaining ";TIMEX%:PRINTTAB(38,27);"x.5 $";INT(TIMEX%/2)
 5770 PRINTTAB(17,28);"Gold";SPC(14);G%:PRINTTAB(38,28);"x1  $";G%
 5780 PRINTTAB(17,29);"Gems";SPC(14);GEM%;SPC(2);"x10 $";(GEM%*10)
 5790 PRINTTAB(17,30);"Saved miners";SPC(5);SAV%;"/";Rescued(LVL%);" x25 $";(SAV%*25)
 5800 LVLTot%=(TIMEX%/2)+G%+(GEM%*10)+(SAV%*25)
 5810 IF HC%=0 THEN GOTO 5850
 5820 Bonus%=LVLTot%/2
 5830 PRINTTAB(17,31);"Hardcore mode bonus  50% $";Bonus%
 5840 LVLTot%=LVLTot%+Bonus%
 5850 PRINTTAB(34,32);"Total   $";LVLTot%
 5860 PRINTTAB(17,34);"Previous retirement";SPC(6);"$";Retire%
 5870 Retire%=Retire%+LVLTot%
 5880 PRINTTAB(17,35);"New retirement";SPC(11);"$";Retire%
 5890 PRINTTAB(15,37);STRING$(33,CHR$230)
 5900 FOR G=26 TO 36 STEP 1
 5910   PRINTTAB(15,G);CHR$230
 5920   PRINTTAB(47,G);CHR$230
 5930 NEXT
 5940 REM PROCcensus :REM writeback SAV% and LOST%
 5950 REM END EACH LEVEL
 5960 IF LVL%=2 THEN PROCtune(160,8,2,10,5)
 5970 IF LVL%=3 THEN PROCtune(180,8,2,10,5)
 5980 IF LVL%=4 THEN PROCtune(200,8,2,10,5)
 5990 PROCanything
 6000 CLS
 6010 IF LVL%=4 THEN PROClastmission
 6020 GOTO1100
 6030 PROCtheending(2)
 6040 ENDPROC
 6050 DEFPROCfinalscore
 6060 CLS:COLOUR 14
 6070 COLOUR14:PRINTTAB(20,31);"F I N A L    S C O R E"
 6080 COLOUR15:PRINTTAB(20,29);"Thank you for playing!"
 6090 PRINTTAB(21,33);"Retirement funds: $";Retire%
 6100 PRINTTAB(21,35);"Rating: "
 6110 COLOUR15:PRINTTAB(8,39);"Draegermans widow retires to a"
 6120 IF Retire%<300 THEN GOTO6160 :REM 300
 6130 IF Retire%<600 THEN GOTO6190 :REM 500
 6140 IF Retire%<900 THEN GOTO6220 :REM 900
 6150 GOTO6250
 6160 COLOUR9:PRINTTAB(30,35);"Very poor"
 6170 COLOUR15:PRINTTAB(39,39);"hovel, leading":PRINTTAB(8,41);"a pitiful life and living of food stamps. Often":PRINTTAB(8,43);"found inebriated and lamenting about the past."
 6180 GOTO 6270
 6190 COLOUR1:PRINTTAB(30,35);"Poor"
 6200 COLOUR15:PRINTTAB(39,39);"tiny cottage, often":PRINTTAB(8,41);"scrounching for food by trapping small animals":PRINTTAB(8,43);"A final life that isn't all it could have been."
 6210 GOTO6270
 6220 COLOUR2:PRINTTAB(30,35);"Middle-class"
 6230 COLOUR15:PRINTTAB(39,39);"town terraced house.":PRINTTAB(8,41);"Filling days with local strolls, participating in":PRINTTAB(8,43);"community events, although not rich a life furfilled."
 6240 GOTO6270
 6250 COLOUR10:PRINTTAB(30,35);"Wealthy"
 6260 COLOUR15:PRINTTAB(39,39);"Grand Chateau. Indulging":PRINTTAB(8,41);"in cultural events, pursuing leisurely hobbies and":PRINTTAB(8,43);"regularly hosting gatherings for old miner friends."
 6270 IF LVL%=5 THEN PRINTTAB(6,39);"Mr & Mrs Draegerman"
 6280 PROCtune(120,8,2,20,5)
 6290 PROCtune(140,3,1,20,10)
 6300 PROCbigfont(20,10)
 6310 ENDPROC
 6320 DEFPROCdecide
 6330 IFY<15 THEN A%=RND(5) ELSE A%=RND(3)
 6340 IFA%=1 THEN B%=RND(5) ELSE C%=RND(5)
 6350 ENDPROC
 6360 DEFPROCworlds
 6370 DIM TownName$(4):DIM RealDepth(4):DIM MineDepth(4):DIM MagicObjects(4):DIM Granite(4):DIM RebuyCost(4)
 6380 DIM Rescued(4):DIM TimerZ(4):DIM MINERS(4):DIM CaveRisk(4)
 6390 DIM Survived%(4):DIM Deaths%(4)
 6400 RESTORE 370
 6410 FOR i=1TO4:READ TownName$(i):NEXT i
 6420 FOR k=1TO4:READ RealDepth(k):NEXT k
 6430 FOR j=1TO4:READ MineDepth(j):NEXT j
 6440 FOR e=1TO4:READ MagicObjects(e):NEXT e
 6450 FOR r=1TO4:READ Granite(r):NEXT r
 6460 FOR l=1TO4:READ RebuyCost(l):NEXT l
 6470 FOR z=1TO4:READ Rescued(z):NEXT z
 6480 FOR w=1TO4:READ TimerZ(w):NEXT w
 6490 FOR u=1TO4:READ MINERS(u):NEXT u
 6500 FOR r=1TO4:READ CaveRisk(r):NEXT r
 6510 ENDPROC
 6520 DEFPROCbigfont(y,r)
 6530 FOR A=1TOr STEP1
 6540   c=RND(4)+220
 6550   PROCbigD(11,y,RND(14),c):PROCbigR(15,y,RND(14),c):PROCbigA(19,y,RND(14),c,1)
 6560   PROCbigE(23,y,RND(14),c):PROCbigG(27,y,RND(14),c):PROCbigE(31,y,RND(14),c)
 6570   PROCbigR(35,y,RND(14),c):PROCbigM(39,y,RND(14),c):PROCbigA(45,y,RND(14),c,2):PROCbigN(49,y,RND(14),c)
 6580 NEXT
 6590 ENDPROC
 6600 DEFPROCborder
 6610 CLS:COLOUR1
 6620 FOR G=3 TO 45 STEP 1:PRINTTAB(6,G);CHR$230:PRINTTAB(57,G);CHR$230:NEXT
 6630 PRINTTAB(7,3);STRING$(50,CHR$230):PRINTTAB(7,7);STRING$(50,CHR$230):PRINTTAB(7,45);STRING$(50,CHR$230)
 6640 ENDPROC
 6650 DEFPROCheader
 6660 COLOUR11:PRINTTAB(8,5);STRING$(13,CHR$240):PRINTTAB(44,5);STRING$(12,CHR$239)
 6670 ENDPROC
 6680 DEFPROCshowtown
 6690 IF LVL%=4 THEN PRINTTAB(3,1);CHR$215;CHR$216;SPC(1);CHR$216;CHR$215;SPC(1);CHR$215;CHR$216;SPC(2);CHR$217:PRINTTAB(22,1);STRING$(18,CHR$234):GOTO6720
 6700 PRINTTAB(0,1);CHR$226;CHR$231;CHR$226;CHR$231;CHR$232;CHR$231;CHR$233;CHR$233;CHR$232;CHR$220;CHR$234;CHR$234;CHR$235
 6710 PRINTTAB(29,1);CHR$234;CHR$234;CHR$232;CHR$231;CHR$233;CHR$233;CHR$220;CHR$232;CHR$231;CHR$231
 6720 ENDPROC
 6730 DEFPROClastmission
 6740 PROCtune(220,8,1,0,5)
 6750 PROCborder
 6760 COLOUR15
 6770 PRINTTAB(23,5);"INCOMING TELEGRAM"
 6780 PRINTTAB(8,9);"ATTENTION: Draegerman,"
 6790 PRINTTAB(8,11);"We need your help for one last mission!"
 6800 PRINTTAB(8,13);"The world-renowned engineer, inventor and"
 6810 PRINTTAB(8,15);"industrialist Alexander Bernhard, is missing"
 6820 PRINTTAB(8,17);"in the icy expanse of the Antarctic wilderness."
 6830 PRINTTAB(8,20);"His last messages were frantic, cryptic, but had"
 6840 PRINTTAB(8,22);"unexpected optimism - he believed he was on the"
 6850 PRINTTAB(8,24);"cusp of an unprecedented discovery, a machine"
 6860 PRINTTAB(8,26);"that would save countless number of miners lives."
 6870 PRINTTAB(8,29);"Navigate the treacherous frozen artic, and find"
 6880 PRINTTAB(8,31);"Alexander and return before it's to late."
 6890 PRINTTAB(8,34);"You'll find NO gold, NO replenishment but PLENTY"
 6900 PRINTTAB(8,36);"of ice tunnels. The only good news is we have"
 6910 PRINTTAB(8,38);"been able to DOUBLE your dynamite carry!"
 6920 PRINTTAB(8,41);"Suit up, prepare your gear, and step into the"
 6930 PRINTTAB(8,43);"icy jaws of the unknown....<EOM>"
 6940 COLOUR9
 6950 PRINTTAB(8,5);STRING$(2,"URGENT!")
 6960 PRINTTAB(41,5);STRING$(2,"URGENT!")
 6970 PROCtune(220,8,3,0,5)
 6980 PROCanything
 6990 ENDPROC
 7000 DEFPROCtips
 7010 PROCborder
 7020 COLOUR15
 7030 PRINTTAB(25,5);"GAME TIPS"
 7040 PRINTTAB(8,9);"SPOILER ALERT: Only read the following if you"
 7050 PRINTTAB(8,11);"are struggling to get past the levels"
 7060 PRINTTAB(8,14);"-Focus on saving miners not acquiring wealth"
 7070 PRINTTAB(8,16);"-Always reserve dynamite for your return journey"
 7080 PRINTTAB(8,18);"-Plot your path in advance to avoid granite traps"
 7090 PRINTTAB(8,20);"-Sometimes not all miners can be saved."
 7100 PRINTTAB(8,22);"-A trip to the store or a trip to the exit?"
 7110 PRINTTAB(8,24);"-Study how landfills happen to master tunnelling"
 7120 PRINTTAB(8,26);"-Oxygen can never be replenished"
 7130 PRINTTAB(8,28);"-Only gold is used as currency for restocking"
 7140 PRINTTAB(8,30);"-Gems are only good for your retirement balance"
 7150 PRINTTAB(8,32);"-Every move counts.Don't waste time pushing walls"
 7160 PRINTTAB(8,34);"-Not all mysteries are there to be solved"
 7170 PRINTTAB(8,36);"-Use the gold seams to travel uses less dynamite"
 7180 PROCanything
 7190 CLS
 7200 ENDPROC
 7210 DEFPROCcredits
 7220 PROCborder
 7230 COLOUR15
 7240 PRINTTAB(25,5);"C R E D I T S"
 7250 PRINTTAB(8,9);"This version of Draegerman is SHAREWARE."
 7260 PRINTTAB(8,11);"https://github.com/";SIG$;"/draegerman"
 7270 PRINTTAB(8,13);"You are free to distribute unaltered."
 7280 PRINTTAB(8,16);"Want to write your own games? join #games on"
 7290 PRINTTAB(8,18);"Agon Programmers: https://discord.gg/aeKCUbWEzp"
 7300 PRINTTAB(8,20);"Code: https://github.com/8BitVino/draegerman"
 7310 PRINTTAB(8,23);"Thank you testers: oldpatientsea, SlithyMatt"
 7320 PRINTTAB(8,25);"NickP, Peter Vangsgaard, damn_pastor & LuzrBum"
 7330 PRINTTAB(8,28);"Enhanced version for AgonLight2 and Console8"
 7340 PRINTTAB(8,30);"Additional thanks to Eightbitswide and"
 7350 PRINTTAB(8,32);"Richard Turnnidge for joystick routines."
 7360 PRINTTAB(8,34);"Requirements: VDP/MOS v1.04 & BBC Basic v1.06"
 7370 PRINTTAB(8,36);
 7380 PRINTTAB(8,38);
 7390 PRINTTAB(8,40);"Draegerman v1.1"
 7400 PRINTTAB(8,43);"email : ";SIG$;"@gmail.com";SPC(5);"(c) ";SIG$;" 2023"
 7410 PROCanything
 7420 CLS
 7430 ENDPROC
 7440 DEFPROCtheending(Z)
 7450 CLS
 7460 COLOUR7:PRINTTAB(35,12);"The end"
 7470 PROCcensus
 7480 IF Z=2 THEN PROCgood
 7490 IF Z=3 THEN PROCmedium
 7500 IF Z=1 THEN PROCbad
 7510 PROClandend(Z)
 7520 PROCfinaltowns
 7530 PROCdestiny
 7540 PROCanything
 7550 PROCfinalscore
 7560 PROCanything
 7570 CLS
 7580 GOTO670
 7590 ENDPROC
 7600 DEFPROClandend(Z)
 7610 COLOURZ
 7620 FOR Y=30 TO 35 STEP1 :REM topsoil
 7630   FOR X=0 TO 63 STEP1:PRINTTAB(X,Y);CHR$230:NEXT X:NEXT Y
 7640 FOR Y=43 TO 45 STEP1  :REM bottomsoil
 7650   FOR X=0 TO 63 STEP1:PRINTTAB(X,Y);CHR$230:NEXT X:NEXT Y
 7660 FOR Y=36 TO 42 STEP1 :REM leftsoil
 7670   FOR X=0 TO 2 STEP1:PRINTTAB(X,Y);CHR$230:NEXT X:NEXT Y
 7680 FOR Y=36 TO 42 STEP1 :REM right soil
 7690   FOR X=61 TO 63 STEP1:PRINTTAB(X,Y);CHR$230:NEXT X:NEXT Y
 7700 FOR Y=36 TO 42 STEP1  :REM a third soil
 7710   FOR X=20 TO 22 STEP1:PRINTTAB(X,Y);CHR$230:NEXT X:NEXT Y
 7720 FOR Y=36 TO 42 STEP1  :REM a two thirds soil
 7730   FOR X=40 TO 42 STEP1:PRINTTAB(X,Y);CHR$230:NEXT X:NEXT Y
 7740 ENDPROC
 7750 DEFPROCgood
 7760 PROCtune(280,8,3,5,5)
 7770 PRINTTAB(4,15);"Your rescue of Alexander led him to finish a"
 7780 PRINTTAB(4,17);"groundbreaking self-contained breathing apparatus"
 7790 PRINTTAB(4,19);"which revolutionalises mine rescues. Your bravery"
 7800 PRINTTAB(4,21);"makes you a hero among the miners and their families."
 7810 PRINTTAB(4,23);CHR$34;"May you retire hapilly Draegerman, knowing it's your"
 7820 PRINTTAB(4,25);"bravery is the gold that fills our hearts with gratitude!";CHR$34
 7830 COLOUR11
 7840 PRINTTAB(46,27);SPC(12);CHR$233
 7850 PRINTTAB(29,28);M$;SPC(25);CHR$220
 7860 PRINTTAB(0,29);A$;T$;A$;T$;A$;T$;N$;CHR$32;CHR$240;CHR$239;T$;A$;T$;T$;CHR$32;U$
 7870 ENDPROC
 7880 DEFPROCmedium
 7890 PROCtune(260,8,2,5,5)
 7900 COLOUR3
 7910 IF TIMEX%<=0 THEN PRINTTAB(1,14);"You halt, collapsing, gasping for breath...."
 7920 IF CH%=-1 THEN PRINTTAB(1,14);"A surprise in bottom of the explosives bag: a spider bites you"
 7930 IF MINERS(LVL%)=-1 THEN PRINTTAB(1,14);CHR$34;"Not you again!";CHR$34;" the storekeeper yells, shooting you.."
 7940 PRINTTAB(1,16);"As life's last sigh escapes your lips, you submit to destiny."
 7950 PRINTTAB(1,18);"In the quiet, a stirring... the echo of miners you once saved"
 7960 PRINTTAB(1,20);"come, repaying the favor. Wounded deeply, you find peace, "
 7970 PRINTTAB(1,22);"a sanctuary, spending your twilight years wondering..."
 7980 PRINTTAB(16,24);CHR$34;"What more could I have done?";CHR$34
 7990 COLOUR3
 8000 PRINTTAB(29,27);CHR$212;CHR$230;CHR$230;CHR$213;SPC(22);CHR$233  :REM SANTUARY TOP
 8010 PRINTTAB(29,28);STRING$(4,CHR$210);SPC(22);CHR$220 :REM SANCTUARY MIDDLE
 8020 PRINTTAB(0,29);A$;T$;A$;T$;SPC(3);T$;SPC(2);N$;CHR$32;CHR$240;SPC(1);T$;T$;SPC(3);STRING$(4,CHR$233);U$;STRING$(3,CHR$233)
 8030 ENDPROC
 8040 DEFPROCbad
 8050 PROCtune(240,8,2,5,5)
 8060 COLOUR1
 8070 IF TIMEX%<=0 THEN PRINTTAB(1,15);"The trapped miners and you ran out of oxygen!"
 8080 IF CH%=-1 THEN PRINTTAB(1,15);"A surprise in bottom of the explosives bag:a spider bites you"
 8090 IF MINERS(LVL%)=-1 THEN PRINTTAB(1,15);CHR$34;"Not you again!";CHR$34;" the storekeeper yells, shooting you dead."
 8100 PRINTTAB(1,17);"Despite the weight of hope, your journey met a somber end."
 8110 PRINTTAB(1,19);"In tribute to your valiant efforts, the miners' families"
 8120 PRINTTAB(1,21);"place one more cross amongst the innumerable as a"
 8130 PRINTTAB(1,23);"haunting testament to your ultimate sacrifice."
 8140 COLOUR1
 8150 PRINTTAB(51,27);CHR$233
 8160 PRINTTAB(31,28);CHR$233;SPC(19);CHR$220
 8170 PRINTTAB(1,29);STRING$(27,CHR$233);CHR$32;CHR$234;CHR$32;CHR$230;CHR$32;CHR$234;CHR$32;STRING$(12,CHR$233);U$;STRING$(7,CHR$233)
 8180 ENDPROC
 8190 DEFPROCcensus
 8200 IF LVL%=5 THEN GOTO8230
 8210 Survived%(LVL%)=SAV%
 8220 Deaths%(LVL%)=MagicObjects(LVL%)-SAV%
 8230 ENDPROC
 8240 DEFPROCfinaltowns
 8250 COLOUR15
 8260 FOR X=4 TO 44 STEP 20
 8270   PRINTTAB(X,39);"Lost":PRINTTAB(X,41);"Saved"
 8280 NEXT X
 8290 PRINTTAB(4,37);TownName$(1):PRINTTAB(24,37);TownName$(2):PRINTTAB(44,37);TownName$(3)
 8300 COLOUR9
 8310 PRINTTAB(10,39);STRING$(Deaths%(1),CHR$233)
 8320 PRINTTAB(30,39);STRING$(Deaths%(2),CHR$233)
 8330 PRINTTAB(50,39);STRING$(Deaths%(3),CHR$233)
 8340 COLOUR10
 8350 PRINTTAB(10,41);STRING$(Survived%(1),CHR$239)
 8360 PRINTTAB(30,41);STRING$(Survived%(2),CHR$239)
 8370 PRINTTAB(50,41);STRING$(Survived%(3),CHR$239)
 8380 ENDPROC
 8390 DEFPROCdestiny
 8400 COLOUR15
 8410 PRINTTAB(26,31);"Draegerman"
 8420 IF Z=2 THEN PRINTTAB(28,32);"Estate"
 8430 IF Z=3 THEN PRINTTAB(27,32);"Hospice"
 8440 IF Z=1 THEN PRINTTAB(26,32);"lies here"
 8450 ENDPROC
 8460 DEFPROCbadpicker
 8470 IF LVL%>=3 PROCtheending(3)
 8480 PROCtheending(1)
 8490 ENDPROC
 8500 DEFPROCtune(m,l,r,f,d)
 8510 REM m tune to play, l=8, r=repeats, f=location in y, d= speed
 8520 FOR J=1 TO r STEP 1
 8530   RESTORE m
 8540   FOR I=1 TO l STEP 1
 8550     IF f<>0 THEN PROCbigfont(f,1)
 8560     READ pitcha:READ pitchb
 8570     SOUND 1,-2,pitcha,d:SOUND 2,-2,pitchb,d
 8580   NEXT I
 8590 NEXT J
 8600 ENDPROC
 8610 DEFPROCanything
 8620 REPEAT
 8630   K=INKEY(1)
 8640   T=GET(162)
 8650   IF (T AND FIRE)=T THEN K=32
 8660 UNTIL K=32
 8670 ENDPROC
 8680 DEFPROCtitles
 8690 PROCbigfont(20,10)
 8700 COLOUR(9+RND(5)):PRINTTAB(12,43);"Press fire button or spacebar to start"
 8710 ENDPROC
 8720 END
