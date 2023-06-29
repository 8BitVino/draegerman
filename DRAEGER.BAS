   10 REM Draegerman. Version 1.0b 29/6/23
   20 REM Based on code elements in Gold Miner by B.Larkin, Chandler H.S. 1983 http://bbcmicro.co.uk/explore.php?id=4229
   30 REM Ported and supercharged into Draegerman by 8BitVino (c)2023
   40 REM Latest fixes: No explosives allowed top level, removed dirt Antartica, moved mission tune earlier, added gem thankyou, fixed messages clear, middle class end bug, removed unused variable.
   50 REM DISCLAIMER:
   60 REM 1. This game is not associated with, endorsed by, or affiliated with any mining or safety companies and draws it's name from commonly applied term of rescue workers.
   70 REM 2. This version of Draegerman is Shareware and can be distributed freely (see github for license information)
   80 REM 2. I worked really, really hard to programme this so don't rip me of without credit
   90 REM SHOP REWARD C E G
  100 DATA 101,149,69,117,81,129
  110 REM Dragerman theme song C#3,E3,F#2,B2,F#2,A3,B2,A3,B2 C%4,E4,F#3,B4,F#3,A4,B4,A4,B4
  120 DATA 57,105,69,117,29,77,49,145,29,77,89,137,49,145,89,137
  130 REM Dragerman theme song ending b2,e2,f#2 b4,e3,f#3
  140 DATA 49,145,21,69,29,77
  150 REM Level1 end D A G A. 2,3.4,5
  160 DATA 13,109,41,137,33,129,41,137,61,157,89,185,81,177,89,185
  170 REM Level2 end F# C# B C# 2,3. 4,5
  180 DATA 29,125,57,153,49,145,57,153,77,173,105,201,97,193,105,201
  190 REM Level3 end F# C# B C#, 2,3. 3,4.
  200 DATA 77,125,57,105,49,97,57,105,125,173,105,153,97,145,105,153
  210 REM Level 4 Mission music E G B E 2,3.3,4
  220 DATA 21,69,33,81,49,97,21,69,69,117,81,129,97,145,69,117
  230 REM Bad ending. E B C# G#. 2,3.4,5
  240 DATA 21,117,13,109,17,113,9,105,69,165,61,157,65,161,57,153
  250 REM Medium ending. A E F# C#. 2,3.3,4
  260 DATA 41,89,21,69,29,77,17,65,89,137,69,117,77,125,65,113
  270 REM Good ending. D G B D G B G F#. 2,3.3,4
  280 DATA 13,61,33,81,49,97,13,61,33,81,49,97,33,81,29,77
  290 REM Good ending 2.C E G C G B D G. 2,3.3,4
  300 DATA 53,101,69,117,81,129,53,101,81,129,49,97,61,109,81,129
  310 REM REWARD Gem C E C E
  320 DATA 53,101,21,69,101,149,69,97
  330 REM REWARD Miner saved
  340 DATA 109,77,137,57,97,65,129,145
  350 REM town names
  360 DATA "Moura 1994","Northparkes 1999","Beaconsfield 2006","Antartica 2023"
  370 REM real mine depth
  380 DATA 87,170,397,417
  390 REM game mine depth
  400 DATA 20,32,46,46
  410 REM MagicObjects gems and miners to save
  420 DATA 5,7,9,1
  430 REM Granite quantities per level
  440 DATA 50,75,100,150
  450 REM RebuyCosts how much a reload from store costs
  460 DATA 20,25,25,1000
  470 REM Rescued. The actual number of miners that have been saved
  480 DATA 4,5,7,1
  490 REM TimerZ amount of moves allowed per level
  500 DATA 350,500,550,250
  510 REM MINERS. number of store rebuys allowed
  520 DATA 2,2,3,0
  530 REM number of cave fall ins that occur
  540 DATA 5,10,20,20
  550 REM Moura 350 moves, restock fee 20 , 4/5 to save
  560 REM Northparkes 500 moves, restock fee 25, 5/7 to save
  570 REM Beaconsfield 550 moves,restock fee 25, 7/9 to save
  580 REM Antartica 250,no restock, 1/1 to save
  590 MODE1
  600 ON ERROR CLS:PRINT"Unexpected Error! Seems like your request has been intercepted":PRINT"by Master Control Program. Sending Tron to debug.":GOTO8410
  610 REM INITIALIZE ONCE
  620 PROCchar
  630 PROCworlds
  640 REM END INITALIZE ONCE
  650 VDU23,1,0
  660 COLOUR15
  670 HC%=0
  680 SIG$="8BitVino"
  690 CLS
  700 REM play draegerman theme
  710 PROCtune(120,8,2,20,5)
  720 PROCtune(140,3,1,20,10)
  730 PROCbigfont(20,10)
  740 COLOUR7:PRINTTAB(15,29);"Dare to descend and rise as a hero"
  750 PRINTTAB(47,46);"(c)2023 ";SIG$
  760 COLOUR15
  770 PRINTTAB(24,33);"(c)redits"
  780 PRINTTAB(24,35);"(i)nstructions"
  790 PRINTTAB(24,37);"(t)ips"
  800 PRINTTAB(24,39);"(h)ardcore mode"
  810 PRINTTAB(24,41);"(n)ormal mode"
  820 COLOUR(9+RND(5)):PRINTTAB(19,43);"Press spacebar to start"
  830 K=GET
  840 IF K=69 OR K=101 THEN PROCeasy
  850 IF K=32 THEN GOTO930 :REM SPACEBAR
  860 IF K=73 OR K=105 THEN PROCinstruct
  870 IF K=72 OR K=104 THEN PROChardcore
  880 IF K=78 OR K=110 THEN PROCnormal
  890 IF K=84 OR K=116 THEN PROCtips
  900 IF K=67 OR K=99 THEN PROCcredits
  910 GOTO720
  920 REM ***GAME starts***
  930 FOR Y=33 TO 43 STEP 2:PRINTTAB(19,Y);STRING$(32,CHR$32):NEXT Y
  940 PRINTTAB(20,34);"GOOD LUCK DRAEGERMAN!"
  950 PROCtune(160,8,1,20,5)
  960 CLS
  970 VDU23,1,0
  980 LVL%=1:NextLVL%=0:MSGTimer%=5:Retire%=0:Mystery=0
  990 FOR d=1TO4:Survived%(d)=0:Deaths%(d)=0:NEXT d
 1000 PROCscreen
 1010 REM *** MAIN GAME LOOPS STARTS ***
 1020 E%=0
 1030 REPEAT
 1040   K=INKEY(1)
 1050   IF E%=30 PROCanimation:E%=0
 1060   IFK=32 PROCblast:PROCcavein(20):GOTO1030
 1070   IFK=10 OR K=11 THEN PROCmove :REM ensures only valid moves go to ProcMOVE
 1080   IFK=8 OR K=21 THEN PROCmove
 1090   E%=E%+1
 1100 UNTIL FALSE
 1110 REM *** MAIN GAME LOOP ENDS ***
 1120 DEFPROCanimation
 1130 F%=239+RND(4)
 1140 COLOUR3:PRINTTAB(NX%,NY%);CHR$(F%)
 1150 ENDPROC
 1160 DEFPROCbigR(x,y,r,c)
 1170 COLOURr:PRINTTAB(x,y);STRING$(3,CHR$c):PRINTTAB(x,y+1);CHR$c
 1180 PRINTTAB(x,y+2);CHR$c:PRINTTAB(x,y+3);CHR$c:PRINTTAB(x,y+4);CHR$(c)
 1190 ENDPROC
 1200 DEFPROCbigA(x,y,r,c,o)
 1210 COLOURr:PRINTTAB(x,y);SPC(1);CHR$c:PRINTTAB(x,y+1);STRING$(3,CHR$c)
 1220 PRINTTAB(x,y+2);CHR$c;SPC(1);CHR$c:PRINTTAB(x,y+3);STRING$(3,CHR$c):PRINTTAB(x,y+4);CHR$c;SPC(1);CHR$c
 1230 IF o=1 THEN PRINTTAB(x,y-2);CHR$(c);SPC(1);CHR$c:
 1240 ENDPROC
 1250 DEFPROCbigE(x,y,r,c)
 1260 COLOURr:PROCbigR(x,y,r,c):PRINTTAB(x+1,y+2);CHR$c;CHR$c:PRINTTAB(x+1,y+4);CHR$c;CHR$c
 1270 ENDPROC
 1280 DEFPROCbigG(x,y,r,c)
 1290 COLOURr:PRINTTAB(x,y);STRING$(3,CHR$c):PRINTTAB(x,y+1);CHR$c;SPC(1);CHR$c:PRINTTAB(x,y+2);CHR$c;SPC(1);CHR$c
 1300 PRINTTAB(x,y+3);CHR$c;SPC(1);CHR$c:PRINTTAB(x,y+4);STRING$(3,CHR$c):PRINTTAB(x+2,y+5);CHR$c
 1310 PRINTTAB(x+2,y+6);CHR$c:PRINTTAB(x,y+7);STRING$(3,CHR$c)
 1320 ENDPROC
 1330 DEFPROCbigD(x,y,r,c)
 1340 COLOURr:PRINTTAB(x,y);STRING$(3,CHR$c):PRINTTAB(x,y+1);STRING$(3,CHR$c):PRINTTAB(x,y+2);CHR$c;SPC(1);CHR$c
 1350 PRINTTAB(x,y+3);CHR$c;SPC(1);CHR$c:PRINTTAB(x,y+4);STRING$(3,CHR$c):PRINTTAB(x+2,y-1);CHR$c:PRINTTAB(x+2,y-2);CHR$c
 1360 PRINTTAB(x+2,y-3);CHR$c:PRINTTAB(x+2,y-4);CHR$c
 1370 ENDPROC
 1380 DEFPROCbigM(x,y,r,c)
 1390 COLOURr:PROCbigN(x,y,r,c):PROCbigN(x+2,y,r,c):PRINTTAB(x+2,y);CHR$32
 1400 ENDPROC
 1410 PRINTTAB(x,y+3);CHR$c;SPC(1);CHR$c;SPC(1);CHR$c:PRINTTAB(x,y+4);CHR$c;SPC(1);CHR$c;SPC(1);CHR$c;
 1420 ENDPROC
 1430 DEFPROCbigN(x,y,r,c)
 1440 COLOURr:PRINTTAB(x,y);CHR$c:PRINTTAB(x,y+1);STRING$(3,CHR$c):PRINTTAB(x,y+2);CHR$c;SPC(1);CHR$c;
 1450 PRINTTAB(x,y+3);CHR$c;SPC(1);CHR$c:PRINTTAB(x,y+4);CHR$c;SPC(1);CHR$c;
 1460 ENDPROC
 1470 DEFPROCinstruct
 1480 PROCborder
 1490 PROCheader
 1500 COLOUR15
 1510 PRINTTAB(22,5);"Welcome to Draegerman"
 1520 PRINTTAB(10,9);"A strategy game where you take on the role"
 1530 PRINTTAB(10,11);"of a brave draegerman, whose mission is"
 1540 PRINTTAB(10,13);"to save trapped miners deep within the"
 1550 PRINTTAB(10,15);"treacherous underground mines."
 1560 PRINTTAB(10,19);"As you descend into the depths you'll use"
 1570 PRINTTAB(10,21);"dynamite to blast through blocked paths,"
 1580 PRINTTAB(10,23);"collect valuable gold and treasures but"
 1590 PRINTTAB(10,25);"need to strategically plan your resupply"
 1600 PRINTTAB(10,27);"trips to the store."
 1610 PRINTTAB(10,31);"With each level, the challenges increase"
 1620 PRINTTAB(10,33);"and your skills as a rescuer will be put"
 1630 PRINTTAB(10,35);"to the test."
 1640 PRINTTAB(18,39);"Are you ready to embark on"
 1650 PRINTTAB(18,41);"thrilling rescue missions?"
 1660 temp=GET
 1670 PROCborder
 1680 PROCheader
 1690 COLOUR15
 1700 PRINTTAB(26,5);"Game rules"
 1710 PRINTTAB(10,13);"MOVEMENT: Use ARROW keys to move"
 1720 PRINTTAB(10,15);"CLEAR THE PATHS: Use SPACEBAR for dynamite"
 1730 PRINTTAB(10,17);"COLLECT GOLD: Use at the store for resupply"
 1740 PRINTTAB(10,19);"COLLECT GEMS: Retire as rich Draegerman!"
 1750 PRINTTAB(10,21);"AVOID GRANITE ROCKS: They cannot be destroyed!"
 1760 PRINTTAB(10,23);"TIME LIMIT: Don't let miners run out oxygen"
 1770 PRINTTAB(10,25);"PROGRESS LEVEL: Save miners! when:  becomes:"
 1780 PRINTTAB(10,27);"HARDCORE MODE: You must save every miner to"
 1790 PRINTTAB(10,29);"proceed to next level for 50% score bonus"
 1800 PRINTTAB(10,31);"Put on your helmet, grab your dynamite..."
 1810 PRINTTAB(16,35);"Will you rise to the challenge"
 1820 PRINTTAB(21,37);"and become a hero?"
 1830 PRINTTAB(18,43);"Good luck, Draegerman!"
 1840 COLOUR9:PRINTTAB(44,25);CHR$224
 1850 COLOUR10:PRINTTAB(54,25);CHR$225
 1860 COLOUR15
 1870 temp=GET
 1880 CLS
 1890 ENDPROC
 1900 DEFPROCchar
 1910 VDU23,230,255,255,255,255,255,255,255,255   : REM defines 230 as the block character
 1920 VDU23,239,56,24,137,126,24,24,60,102   : REM defines 239 as SAVE ME MINER
 1930 VDU23,240,16,56,16,186,254,56,100,132 :REM Draegerman
 1940 VDU23,241,16,56,16,184,254,56,36,36 :REM Draeger2
 1950 VDU23,242,16,56,16,186,254,56,100,70 :REM Draeger3
 1960 VDU23,243,16,56,16,58,254,56,36,36 :REM Draeger4
 1970 VDU23,220,0,24,60,126,102,102,102,102,0,0  : REM House
 1980 VDU23,221,0,0,24,60,126,60,24,0,0,0     : REM Diamond filled
 1990 VDU23,222,0,24,36,66,129,66,36,24,0,0   : REM Diamond unfilled
 2000 VDU23,223,0,24,60,90,165,90,60,24,0,0  : REM Diamond sparkle
 2010 VDU23,224,254,195,165,153,153,165,195,254,254 :REM No exit door
 2020 VDU23,225,254,130,130,130,130,138,130,254,254 : REM exit door
 2030 VDU23,226,0,0,0,0,0,0,0,0,0 :REM EMPTY BLOCK
 2040 VDU23,231,8,60,106,94,52,24,24,24 :REM APPLE TREE
 2050 VDU23,232,0,0,4,28,34,65,62,58 :REM HOUSE
 2060 VDU23,233,0,0,0,0,16,56,16,16 : REM CROSS
 2070 VDU23,234,0,0,0,0,24,60,60,126 :REM MOUND
 2080 VDU23,235,8,8,62,8,8,127,8,8 : REM TELEPHONE POLES
 2090 VDU23,210,255,255,195,195,195,255,255,255 : REM MANSION WINDOW
 2100 VDU23,211,255,255,227,227,227,235,227,227 : REM MANSION DOOR
 2110 VDU23,212,001,003,007,015,031,063,127,255 :REM MANSION LEFT SIDING
 2120 VDU23,213,128,192,224,240,248,252,254,255: REM MANSION RIDE SIDING
 2130 VDU23,214,0,8,28,62,127,255,255,255 :REM MANSION ROOFING
 2140 VDU23,215,24,60,126,126,255,255,231,231 :REM igloo
 2150 VDU23,216,28,62,42,62,119,93,28,20 :REM pengiun
 2160 VDU23,217,60,102,110,106,110,102,60,66 :REM antdoor
 2170 VDU23,218,24,8,60,126,255,213,127,62 :REM submarine
 2180 M$=CHR$220+CHR$212+CHR$213+CHR$220  :REM MANSION TOP
 2190 N$=CHR$231+CHR$32+CHR$230+CHR$210+CHR$211+CHR$230
 2200 A$=CHR$32+CHR$239+CHR$240+CHR$232+CHR$235
 2210 T$=CHR$32+STRING$(3,CHR$231)
 2220 U$=STRING$(4,CHR$233)+CHR$211+STRING$(4,CHR$233) :REM CEMETARY
 2230 ENDPROC
 2240 DEFPROCscreen
 2250 CLS
 2260 NX%=19:NY%=2 :REM defines starting place for draeger
 2270 G%=0:CH%=20
 2280 IF LVL%=4 THEN CH%=50 :REM extra dynamite for last level!
 2290 GEM%=0:SAV%=0
 2300 DEP%=MineDepth(LVL%)
 2310 DEPP%=DEP%-1
 2320 TIMEX%=TimerZ(LVL%):nomove%=0
 2330 COLOUR2 : REM green grass
 2340 IF LVL%=4 THEN COLOUR 15
 2350 FORX=0TO39:PRINTTAB(X,2);CHR$230:NEXT
 2360 COLOUR8 : REM grey external walls
 2370 FORY=3TODEP%:PRINTTAB(39,Y);CHR$230:NEXT
 2380 FORX=39TO0 STEP-1:PRINTTAB(X,DEP%);CHR$230:NEXT
 2390 FORY=DEP%TO3 STEP-1:PRINTTAB(0,Y);CHR$230 :NEXT
 2400 COLOUR9  : REM 9 IS RED 10 IS GREEN
 2410 PRINTTAB(14,1);"NO";CHR$224
 2420 IF LVL%=4 THEN PRINTTAB(16,1);CHR$218
 2430 COLOUR15
 2440 PROCshowtown  :REM show the town gfx top screen
 2450 COLOUR8
 2460 REM TOWN LOGO
 2470 PRINTTAB(43,1);STRING$(20,CHR$230)
 2480 PRINTTAB(43,7);STRING$(20,CHR$230)
 2490 PRINTTAB(43,25);STRING$(20,CHR$230)
 2500 PRINTTAB(43,33);STRING$(20,CHR$230)
 2510 PRINTTAB(43,45);STRING$(20,CHR$230)
 2520 COLOUR 15
 2530 REM STORE PRINT TOP
 2540 IF LVL%=4 THEN GOTO2570
 2550 PRINTTAB(22,1);CHR$220;"Store"
 2560 REM STATS MENU
 2570 PRINTTAB(44,3);TownName$(LVL%)
 2580 IF LVL%=4 THEN PRINTTAB(44,4);"The Perilous Abyss":GOTO2600
 2590 PRINTTAB(44,4);"Australia"
 2600 PRINTTAB(44,5);"Mine depth ";RealDepth(LVL%)*10;" ft"
 2610 PRINTTAB(46,10);"Lost       ";MagicObjects(LVL%)
 2620 PRINTTAB(46,12);"Rescued    0"
 2630 PRINTTAB(46,14);"Resupplies ";MINERS(LVL%)
 2640 PRINTTAB(46,16);"Gold      $0"
 2650 PRINTTAB(46,18);"Gems       0"
 2660 PRINTTAB(46,20);"Oxygen     ";TIMEX%;
 2670 PRINTTAB(46,22);"Dynamite   ";CH%
 2680 IF LVL%=4 THEN GOTO2700
 2690 PRINTTAB(44,35);"Restock fee  $";RebuyCost(LVL%)
 2700 PRINTTAB(44,37);"Retirement   $";Retire%
 2710 PRINTTAB(46,39);"Draeger";SPC(4);"Miners"
 2720 PRINTTAB(46,41);"Gold";SPC(7);"Gems"
 2730 PRINTTAB(46,43);"Granite";SPC(4);"Dirt"
 2740 PRINTTAB(44,27);"Messages:" :REM STATIC
 2750 COLOUR3:PRINTTAB(44,39);CHR$240 :REM Draeger
 2760 COLOUR9:PRINTTAB(55,39);CHR$239 :REM Miners
 2770 COLOUR14:PRINTTAB(55,41);CHR$223 :REM GEMS
 2780 COLOUR8:PRINTTAB(44,43);CHR$230 : REM GRANITE
 2790 COLOUR1:PRINTTAB(55,43);CHR$230 : REM DIRT
 2800 COLOUR11:PRINTTAB(44,41);CHR$230 :REM GOLD
 2810 IF LVL%=4 THEN COLOUR15:PRINTTAB(44,41);CHR$230;SPC(1);"Ice ":PRINTTAB(55,43);STRING$(6,CHR$32):GOTO2820 :REM ICE
 2820 COLOUR3:PRINTTAB(NX%-1,NY%);" ";CHR$240;" "
 2830 FORY=3TODEPP%
 2840   FORX=1TO38
 2850     IFY=3 THEN IFX=18 OR X=19 OR X=20 THEN 2910
 2860     IFB%>0 GOTO2880
 2870     IFC%>0 GOTO2910
 2880     B%=B%-1:COLOUR11
 2890     IF LVL%=4 THEN COLOUR0 :REM ANTARTICA BLACK
 2900     PRINTTAB(X,Y);CHR$230:GOTO2940  :REM GOLD PLACEMENT
 2910     C%=C%-1:COLOUR1
 2920     IF LVL%=4 THEN COLOUR15 :REM ANTARTICA WHITE
 2930     PRINTTAB(X,Y);CHR$230:GOTO2940 :REM RED ROCKS
 2940     IF B%<1 AND C%<1 PROCdecide
 2950   NEXT
 2960 NEXT
 2970 COLOUR 8 :REM GRANITE GREY ROCK COLOUR
 2980 FOR N=1 TO Granite(LVL%)
 2990   REPEAT
 3000     U%=RND(DEPP%-1)
 3010   UNTIL U%>=5
 3020   H%=RND(37)
 3030   FOR G=1 TO RND(3)
 3040     PRINTTAB(H%,U%);CHR$230
 3050     H%=H%+1
 3060     D%=RND(3)
 3070     IF D%=1 THEN U%=U%+1
 3080     IF D%=2 THEN U%=U%-1 :REM RANDOMLY EITHER UP FOR DOWN P. NEXT PIECE
 3090   NEXT
 3100 NEXT
 3110 COLOUR 14 : REM GEM CYAN COLIUR
 3120 FOR N=1 TO MagicObjects(LVL%)
 3130   REPEAT
 3140     P%=RND(DEPP%)
 3150   UNTIL P%>=4
 3160   PRINTTAB(RND(38),P%);CHR$223 :REM GEM PLACEMENT
 3170 NEXT
 3180 COLOUR 9 : REM MINER STRONG RED COLOUR
 3190 FOR N=1 TO MagicObjects(LVL%)
 3200   REPEAT
 3210     P%=RND(DEPP%)
 3220   UNTIL P%>=10
 3230   PRINTTAB(RND(38),P%);CHR$239 :REM SAVE MINER PLACEMENT
 3240 NEXT
 3250 REM mystery object placement one per map
 3260 COLOUR5
 3270 PRINTTAB(RND(32),DEPP%);CHR$42  :REM ALWAYS PLACED MYSTERY OBJECT ON BOTTOM OF MAP (INCENTIVE.HA!HA!)
 3280 COLOUR15
 3290 ENDPROC
 3300 DEFPROCblast
 3310 IF NY%=1 GOTO3720 :REM don't allow explosives on top level
 3320 CH%=CH%-1:IF CH%=-1 THEN PROCbadpicker ELSE GOTO3340
 3330 WAIT=GET
 3340 PRINTTAB(58,22);" "
 3350 IF CH%<4 COLOUR9:PRINTTAB(57,22);CH%:COLOUR3
 3360 IF CH%>=4 PRINTTAB(57,22);CH%
 3370 IF CH%=10 OR CH%=6 THEN PROCdynwarn
 3380 IF CH%=3 OR CH%=1 THEN PROCdynwarn
 3390 SOUND1,-10,100,5
 3400 REM MARKING ALL GREY BLOCKS
 3410 RI%=0:LE%=0:UP%=0:DN%=0
 3420 HOG%=NX%*20+8 :
 3430 VEG%=(47-NY%)*21+16
 3440 IF POINT(HOG%+20,VEG%)=8 THEN RI%=1
 3450 IF POINT(HOG%-20,VEG%)=8 THEN LE%=1
 3460 IF POINT(HOG%,VEG%+21)=8 THEN UP%=1
 3470 IF POINT(HOG%,VEG%-21)=8 THEN DN%=1
 3480 REM NOW EXPLOSIONS
 3490 COLOUR 9 :REM RED
 3500 FOR TT%=0TO5
 3510   FOR DELAY=0TO500:NEXT
 3520   IFNY%<=2 GOTO3560
 3530   IFNY%>3 PRINTTAB(NX%,NY%-1);CHR$88
 3540   IFNX%>1 PRINTTAB(NX%-1,NY%);CHR$88
 3550   IFNX%<38PRINTTAB(NX%+1,NY%);CHR$88
 3560   IFNY%<DEPP%PRINTTAB(NX%,NY%+1);CHR$88
 3570   FOR DELAY=0TO500:NEXT
 3580   IFNY%<=2 GOTO3620
 3590   IFNY%>3 PRINTTAB(NX%,NY%-1);CHR$32
 3600   IFNX%>1 PRINTTAB(NX%-1,NY%);CHR$32
 3610   IFNX%<38PRINTTAB(NX%+1,NY%);CHR$32
 3620   IFNY%<DEPP%PRINTTAB(NX%,NY%+1);CHR$32
 3630   IF TT%<3 GOTO3640
 3640 NEXT
 3650 REM REPLACING ALL GREY BLOCKS DESTROYED
 3660 COLOUR8
 3670 IF RI%=1 PRINTTAB(NX%+1,NY%);CHR$230
 3680 IF LE%=1 PRINTTAB(NX%-1,NY%);CHR$230
 3690 IF UP%=1 PRINTTAB(NX%,NY%-1);CHR$230
 3700 IF DN%=1 PRINTTAB(NX%,NY%+1);CHR$230
 3710 PROCcavein(40)
 3720 ENDPROC
 3730 DEFPROCcavein(CI%)
 3740 IF NY%<=3 GOTO 3860 :REM SKIP IF WE ARE IN TOP AREA FOR PERFORMANCE BOOST
 3750 FORCC%=0TO CI%
 3760   CX%=RND(38):CY%=RND(DEPP%)+3:HOC%=CX%*20+8:VEC%=(47-CY%)*21+16:VECC%=VEC%-21   :REM VECC% MIGHT BE WRONG
 3770   IF POINT(HOC%,VEC%)=1 AND POINT(HOC%,VECC%)=0 THEN 3800
 3780   IF POINT(HOC%,VEC%)=15 AND POINT(HOC%,VECC%)=0 THEN 3810
 3790   GOTO3840
 3800   SOUND0,-10,5,2:COLOUR1:PRINTTAB(CX%,CY%+1);CHR$230:GOTO3820
 3810   IF LVL%=4 THEN SOUND0,-10,5,2:COLOUR15:PRINTTAB(CX%,CY%+1);CHR$230:GOTO3840 :REM ANTARTICA
 3820   IF HC%=1 PRINTTAB(CX%,CY%);CHR$32
 3830   REM HARDCORE MODE WILL CAUSE LANDSLIDE NOT TO BACKFILL OPEN
 3840 NEXT
 3850 COLOUR3
 3860 ENDPROC
 3870 DEFPROChardcore
 3880 COLOUR9
 3890 PRINTTAB(21,31);"HARDCORE GAME MODE"
 3900 REM set so bonus at level ends
 3910 HC%=1
 3920 FOR U=1TO4
 3930   blob=MagicObjects(U)
 3940   Rescued(U)=blob
 3950 NEXT U
 3960 ENDPROC
 3970 DEFPROCnormal
 3980 HC%=0 :REM CALL BACK ON NORMAL MODE
 3990 COLOUR10
 4000 PRINTTAB(21,31);"NORMAL GAME MODE  "
 4010 RESTORE 480
 4020 FOR U=1TO4
 4030   READ MagicObjects(U)
 4040 NEXT U
 4050 ENDPROC
 4060 DEFPROCeasy
 4070 FOR U=1TO4:
 4080   Rescued(U)=1
 4090 NEXT U
 4100 COLOUR13
 4110 PRINTTAB(23,31);"EASY GAME MODE    "
 4120 ENDPROC
 4130 DEFPROCclearmsg
 4140 PRINTTAB(41,29);STRING$(23,CHR$32)
 4150 MSGTimer%=5 :REM reset and then call in 5 again
 4160 ENDPROC
 4170 DEFPROCgrasscheck
 4180 IF NX%<18 OR NX%>20 THEN nomove%=1
 4190 ENDPROC
 4200 DEFPROCgrassside
 4210 IF K=8 AND NX%=18 THEN nomove%=1
 4220 IF K=21 AND NX%=20 THEN nomove%=1
 4230 ENDPROC
 4240 DEFPROCgrassbelow
 4250 IF K=10 AND NX%=17 THEN nomove%=1
 4260 IF K=10 AND NX%=21 THEN nomove%=1
 4270 IF K=8 AND NX%=17 THEN PROClocked
 4280 ENDPROC
 4290 DEFPROCcheckfunds
 4300 IF LVL%=4 THEN GOTO 4330
 4310 IF G%-RebuyCost(LVL%)<0 THEN PROCclearmsg:COLOUR9:PRINTTAB(43,29);"Not enough gold":COLOUR15:GOTO 4330
 4320 PROCresupply
 4330 nomove%=1
 4340 NX%=21:NY%=1   :REM MOVE TO 21
 4350 COLOUR3:PRINTTAB(NX%,NY%);CHR$240
 4360 ENDPROC
 4370 DEFPROCresupply
 4380 PROCtune(100,3,1,0,2)
 4390 MINERS(LVL%)=MINERS(LVL%)-1:
 4400 IF MINERS(LVL%)=-1 THEN PROCbadpicker
 4410 COLOUR3:PRINTTAB(57,14);MINERS(LVL%)
 4420 PROCclearmsg:COLOUR10:PRINTTAB(43,29);"Resupplied dynamite":COLOUR15
 4430 CH%=20
 4440 G%=G%-RebuyCost(LVL%) :REM decrement the gold balance
 4450 COLOUR3:PRINTTAB(57,16);"   ":PRINTTAB(57,16);G%:PRINTTAB(57,22);CH%
 4460 ENDPROC
 4470 DEFPROClocked
 4480 IF NextLVL%=0 THEN PROCclearmsg:COLOUR9:PRINTTAB(43,29);"Door is locked!":COLOUR15:nomove%=1
 4490 ENDPROC
 4500 DEFPROChicheck
 4510 IF K=11 AND NY%=1 THEN nomove%=1 :REM Don't allow exit top screen
 4520 IF NY%=2 THEN PROCgrassside :REM check if we are on grass level
 4530 IF NY%=1 THEN PROCgrassbelow :REM check if we are above grass and try going down
 4540 IF K=11 AND NY%=3 THEN PROCgrasscheck :REM we check when on the row below grass
 4550 IF NX%=17 AND NY%=1 PROCbssay :REM NEXT LEVEL  bssay
 4560 ENDPROC
 4570 DEFPROCmove
 4580 PROChicheck
 4590 CAVEIN=RND(4)
 4600 IF CAVEIN=1 PROCcavein(CaveRisk(LVL%))  :REM CALLs in value of caverisk to cavin
 4610 IF NY%<=3 THEN PROChicheck :REM we do a single check for the NY position rather than all 4 conditions
 4620 IF nomove%=1 THEN GOTO4810 :REM if we hit any illegal locations then skip end
 4630 MSGTimer%=MSGTimer%-1 :REM decrement the message timer
 4640 PROCchecktimers :REM run routines for checking warning or clear warnings
 4650 OX%=NX%:OY%=NY%
 4660 IF K=10 THEN NY%=NY%+1:GOTO4710
 4670 IF K=11 THEN NY%=NY%-1:GOTO4710
 4680 IF K=8 THEN NX%=NX%-1:GOTO4710
 4690 IF K=21 THEN NX%=NX%+1
 4700 IF NX%=22 AND NY%=1 PROCcheckfunds:GOTO4810
 4710 HO%=NX%*20+8:VE%=(47-NY%)*21+16
 4720 PROCtimeupdate
 4730 IF POINT(HO%,VE%)=1 OR POINT(HO%,VE%)=8 THEN NX%=OX%:NY%=OY%:GOTO4810
 4740 IF POINT(HO%,VE%)=11 THEN PROCgoldfind:GOTO4790
 4750 IF POINT(HO%,VE%)=14 THEN PROCgemfind:GOTO4790
 4760 IF POINT(HO%,VE%)=15 THEN NX%=OX%:NY%=OY%:GOTO4810 :REM ANTARTICA
 4770 IF POINT(HO%,VE%)=9 THEN PROCsaveme:GOTO4790 :REM SAVED A MINER
 4780 IF POINT(HO%,VE%)=5 THEN PROCmystery:GOTO4790 :REM YOU FOUND A MYSTERY OBJECT
 4790 COLOUR3:PRINTTAB(NX%,NY%);CHR$240 : REM SHOW MINER
 4800 PRINTTAB(OX%,OY%);CHR$32 : REM SHOW BLANK WHERE CAME FROM
 4810 nomove%=0 :REM RESET THE NO MOVE
 4820 ENDPROC
 4830 DEFPROCtimeupdate
 4840 TIMEX%=TIMEX%-1
 4850 IF TIMEX%=99 OR TIMEX%=9 THEN PRINTTAB(58,20);"  "
 4860 IF TIMEX%>=50 THEN COLOUR3:PRINTTAB(57,20);TIMEX%:GOTO4880  :REM UPDATE THE MOVE COUNTER.
 4870 IF TIMEX%<50 THEN COLOUR9:PRINTTAB(57,20);TIMEX%:COLOUR3
 4880 ENDPROC
 4890 DEFPROCgemfind
 4900 GEM%=GEM%+1:PRINTTAB(57,18);GEM%
 4910 PROCclearmsg:COLOUR14:PRINTTAB(43,29);"Wow! what a gem!"
 4920 PROCtune(320,4,1,0,3)
 4930 ENDPROC
 4940 DEFPROCgoldfind
 4950 G%=G%+1:PRINTTAB(57,16);G%
 4960 ENDPROC
 4970 DEFPROCdynwarn
 4980 PROCclearmsg:COLOUR9:PRINTTAB(43,29);CH%;" EXPLOSIVES LEFT"
 4990 MSGTimer%=5
 5000 COLOUR15
 5010 ENDPROC
 5020 DEFPROCchecktimers  :REM this runs at start of every move change
 5030 IF MSGTimer%=0 THEN PROCclearmsg
 5040 IF TIMEX%>50 THEN GOTO5080
 5050 IF TIMEX%=50 OR TIMEX%=25 THEN PROCwarntime:GOTO 5080
 5060 IF TIMEX%=10 OR TIMEX%=5 THEN PROCwarntime:GOTO 5080
 5070 IF TIMEX%=0 THEN PROCbadpicker
 5080 ENDPROC
 5090 DEFPROCwarntime
 5100 COLOUR9:PRINTTAB(41,31);"Warning ";TIMEX%;" oxygen left"
 5110 COLOUR15
 5120 MSGTimer%=5 :REM Reset the message timer
 5130 ENDPROC
 5140 DEFPROCmystery
 5150 PROCclearmsg:COLOUR5:PRINTTAB(43,29);"Mystery object found"
 5160 COLOUR15
 5170 MSGTimer%=5
 5180 ENDPROC
 5190 DEFPROCsaveme
 5200 SAV%=SAV%+1
 5210 PROCtune(340,4,1,0,3)
 5220 PRINTTAB(57,10);(MagicObjects(LVL%)-SAV%)
 5230 PRINTTAB(57,12);SAV%
 5240 PROCclearmsg:COLOUR10:PRINTTAB(43,29);"Thank you Draegerman"
 5250 COLOUR15
 5260 MSGTimer%=5
 5270 IF SAV%>=Rescued(LVL%) THEN PROCsesame
 5280 ENDPROC
 5290 DEFPROCsesame
 5300 COLOUR10  : REM GREEN
 5310 IF LVL%<>4 PRINTTAB(14,1);"GO";CHR$225:GOTO5330
 5320 PRINTTAB(14,1);"GO";CHR$218
 5330 PRINTTAB(43,31);"Exit: Open sesame!"
 5340 COLOUR15 :REM BACK TO WHITE
 5350 MSGTimer%=5
 5360 NextLVL%=1 :REM enable next level progression
 5370 ENDPROC
 5380 DEFPROCbssay
 5390 IF NextLVL%=0 GOTO 5840
 5400 CLS
 5410 PROCcensus
 5420 LVL%=LVL%+1:NextLVL%=0
 5430 IF LVL%=5 THEN GOTO5830
 5440 COLOUR15
 5450 IF SAV%=MagicObjects(LVL%-1) THEN PRINTTAB(18,19);"Well done! All miners saved!"
 5460 IF SAV%<MagicObjects(LVL%-1) THEN PRINTTAB(11,19);"Not all miners saved. Try harder next time!"
 5470 PRINTTAB(5,40);"COMPLETED  ";STRING$(12,CHR$62);SPC(1);CHR$240;SPC(1);STRING$(12,CHR$62);SPC(3);"NEXT"
 5480 PRINTTAB(5,42);TownName$(LVL%-1)
 5490 IF LVL%<>5 THEN PRINTTAB(46,42);TownName$(LVL%)
 5500 IF LVL%=5 THEN PRINTTAB(46,42);"Retirement!"
 5510 PRINTTAB(9,44);CHR$231;CHR$232;CHR$231;CHR$232;CHR$232;CHR$220;SPC(35);CHR$231;CHR$232;CHR$231CHR$232;CHR$232;CHR$220;
 5520 COLOUR(2)
 5530 PRINTTAB(15,21);STRING$(33,CHR$230)
 5540 PRINTTAB(17,23);"C L E A R E D     M I N E   ";(LVL%-1)
 5550 PRINTTAB(15,25);STRING$(33,CHR$230)
 5560 PRINTTAB(17,27);"Oxygen remaining ";TIMEX%:PRINTTAB(38,27);"x.5 $";INT(TIMEX%/2)
 5570 PRINTTAB(17,28);"Gold";SPC(14);G%:PRINTTAB(38,28);"x1  $";G%
 5580 PRINTTAB(17,29);"Gems";SPC(14);GEM%;SPC(2);"x10 $";(GEM%*10)
 5590 PRINTTAB(17,30);"Saved miners";SPC(5);SAV%;"/";Rescued(LVL%);" x25 $";(SAV%*25)
 5600 LVLTot%=(TIMEX%/2)+G%+(GEM%*10)+(SAV%*25)
 5610 IF HC%=0 THEN GOTO 5650
 5620 Bonus%=LVLTot%/2
 5630 PRINTTAB(17,31);"Hardcore mode bonus  50% $";Bonus%
 5640 LVLTot%=LVLTot%+Bonus%
 5650 PRINTTAB(34,32);"Total   $";LVLTot%
 5660 PRINTTAB(17,34);"Previous retirement";SPC(6);"$";Retire%
 5670 Retire%=Retire%+LVLTot%
 5680 PRINTTAB(17,35);"New retirement";SPC(11);"$";Retire%
 5690 PRINTTAB(15,37);STRING$(33,CHR$230)
 5700 FOR G=26 TO 36 STEP 1
 5710   PRINTTAB(15,G);CHR$230
 5720   PRINTTAB(47,G);CHR$230
 5730 NEXT
 5740 REM PROCcensus :REM writeback SAV% and LOST%
 5750 REM END EACH LEVEL
 5760 IF LVL%=2 THEN PROCtune(160,8,2,10,5)
 5770 IF LVL%=3 THEN PROCtune(180,8,2,10,5)
 5780 IF LVL%=4 THEN PROCtune(200,8,2,10,5)
 5790 temp=GET
 5800 CLS
 5810 IF LVL%=4 THEN PROClastmission
 5820 GOTO1000
 5830 PROCtheending(2)
 5840 ENDPROC
 5850 DEFPROCfinalscore
 5860 CLS:COLOUR 14
 5870 COLOUR14:PRINTTAB(20,31);"F I N A L    S C O R E"
 5880 COLOUR15:PRINTTAB(20,29);"Thank you for playing!"
 5890 PRINTTAB(21,33);"Retirement funds: $";Retire%
 5900 PRINTTAB(21,35);"Rating: "
 5910 COLOUR15:PRINTTAB(8,39);"Draegermans widow retires to a"
 5920 IF Retire%<300 THEN GOTO5960 :REM 300
 5930 IF Retire%<600 THEN GOTO5990 :REM 500
 5940 IF Retire%<900 THEN GOTO6020 :REM 900
 5950 GOTO6050
 5960 COLOUR9:PRINTTAB(30,35);"Very poor"
 5970 COLOUR15:PRINTTAB(39,39);"hovel, leading":PRINTTAB(8,41);"a pitiful life and living of food stamps. Often":PRINTTAB(8,43);"found inebriated and lamenting about the past."
 5980 GOTO 6070
 5990 COLOUR1:PRINTTAB(30,35);"Poor"
 6000 COLOUR15:PRINTTAB(39,39);"tiny cottage, often":PRINTTAB(8,41);"scrounching for food by trapping small animals":PRINTTAB(8,43);"A final life that isn't all it could have been."
 6010 GOTO6070
 6020 COLOUR2:PRINTTAB(30,35);"Middle-class"
 6030 COLOUR15:PRINTTAB(39,39);"town terraced house.":PRINTTAB(8,41);"Filling days with local strolls, participating in":PRINTTAB(8,43);"community events, although not rich a life furfilled."
 6040 GOTO6070
 6050 COLOUR10:PRINTTAB(30,35);"Wealthy"
 6060 COLOUR15:PRINTTAB(39,39);"Grand Chateau. Indulging":PRINTTAB(8,41);"in cultural events, pursuing leisurely hobbies and":PRINTTAB(8,43);"regularly hosting gatherings for old miner friends."
 6070 IF LVL%=5 THEN PRINTTAB(6,39);"Mr & Mrs Draegerman"
 6080 PROCtune(120,8,2,20,5)
 6090 PROCtune(140,3,1,20,10)
 6100 PROCbigfont(20,10)
 6110 ENDPROC
 6120 DEFPROCdecide
 6130 IFY<15 THEN A%=RND(5) ELSE A%=RND(3)
 6140 IFA%=1 THEN B%=RND(5) ELSE C%=RND(5)
 6150 ENDPROC
 6160 DEFPROCworlds
 6170 DIM TownName$(4):DIM RealDepth(4):DIM MineDepth(4):DIM MagicObjects(4):DIM Granite(4):DIM RebuyCost(4)
 6180 DIM Rescued(4):DIM TimerZ(4):DIM MINERS(4):DIM CaveRisk(4)
 6190 DIM Survived%(4):DIM Deaths%(4)
 6200 RESTORE 360
 6210 FOR i=1TO4:READ TownName$(i):NEXT i
 6220 FOR k=1TO4:READ RealDepth(k):NEXT k
 6230 FOR j=1TO4:READ MineDepth(j):NEXT j
 6240 FOR e=1TO4:READ MagicObjects(e):NEXT e
 6250 FOR r=1TO4:READ Granite(r):NEXT r
 6260 FOR l=1TO4:READ RebuyCost(l):NEXT l
 6270 FOR z=1TO4:READ Rescued(z):NEXT z
 6280 FOR w=1TO4:READ TimerZ(w):NEXT w
 6290 FOR u=1TO4:READ MINERS(u):NEXT u
 6300 FOR r=1TO4:READ CaveRisk(r):NEXT r
 6310 ENDPROC
 6320 DEFPROCbigfont(y,r)
 6330 FOR A=1TOr STEP1
 6340   c=RND(4)+220
 6350   PROCbigD(11,y,RND(14),c):PROCbigR(15,y,RND(14),c):PROCbigA(19,y,RND(14),c,1)
 6360   PROCbigE(23,y,RND(14),c):PROCbigG(27,y,RND(14),c):PROCbigE(31,y,RND(14),c)
 6370   PROCbigR(35,y,RND(14),c):PROCbigM(39,y,RND(14),c):PROCbigA(45,y,RND(14),c,2):PROCbigN(49,y,RND(14),c)
 6380 NEXT
 6390 ENDPROC
 6400 DEFPROCborder
 6410 CLS:COLOUR1
 6420 FOR G=3 TO 45 STEP 1:PRINTTAB(6,G);CHR$230:PRINTTAB(57,G);CHR$230:NEXT
 6430 PRINTTAB(7,3);STRING$(50,CHR$230):PRINTTAB(7,7);STRING$(50,CHR$230):PRINTTAB(7,45);STRING$(50,CHR$230)
 6440 ENDPROC
 6450 DEFPROCheader
 6460 COLOUR11:PRINTTAB(8,5);STRING$(13,CHR$240):PRINTTAB(44,5);STRING$(12,CHR$239)
 6470 ENDPROC
 6480 DEFPROCshowtown
 6490 IF LVL%=4 THEN PRINTTAB(3,1);CHR$215;CHR$216;SPC(1);CHR$216;CHR$215;SPC(1);CHR$215;CHR$216;SPC(2);CHR$217:PRINTTAB(22,1);STRING$(18,CHR$234):GOTO6520
 6500 PRINTTAB(0,1);CHR$226;CHR$231;CHR$226;CHR$231;CHR$232;CHR$231;CHR$233;CHR$233;CHR$232;CHR$220;CHR$234;CHR$234;CHR$235
 6510 PRINTTAB(29,1);CHR$234;CHR$234;CHR$232;CHR$231;CHR$233;CHR$233;CHR$220;CHR$232;CHR$231;CHR$231
 6520 ENDPROC
 6530 DEFPROClastmission
 6540 PROCtune(220,8,1,0,5)
 6550 PROCborder
 6560 COLOUR15
 6570 PRINTTAB(23,5);"INCOMING TELEGRAM"
 6580 PRINTTAB(8,9);"ATTENTION: Draegerman,"
 6590 PRINTTAB(8,11);"We need your help for one last mission!"
 6600 PRINTTAB(8,13);"The world-renowned engineer, inventor and"
 6610 PRINTTAB(8,15);"industrialist Alexander Bernhard, is missing"
 6620 PRINTTAB(8,17);"in the icy expanse of the Antarctic wilderness."
 6630 PRINTTAB(8,20);"His last messages were frantic, cryptic, but had"
 6640 PRINTTAB(8,22);"unexpected optimism - he believed he was on the"
 6650 PRINTTAB(8,24);"cusp of an unprecedented discovery, a machine"
 6660 PRINTTAB(8,26);"that would save countless number of miners lives."
 6670 PRINTTAB(8,29);"Navigate the treacherous frozen artic, and find"
 6680 PRINTTAB(8,31);"Alexander and return before it's to late."
 6690 PRINTTAB(8,34);"You'll find NO gold, NO replenishment but PLENTY"
 6700 PRINTTAB(8,36);"of ice tunnels. The only good news is we have"
 6710 PRINTTAB(8,38);"been able to DOUBLE your dynamite carry!"
 6720 PRINTTAB(8,41);"Suit up, prepare your gear, and step into the"
 6730 PRINTTAB(8,43);"icy jaws of the unknown....<EOM>"
 6740 COLOUR9
 6750 PRINTTAB(8,5);STRING$(2,"URGENT!")
 6760 PRINTTAB(41,5);STRING$(2,"URGENT!")
 6770 PROCtune(220,8,3,0,5)
 6780 temp=GET
 6790 ENDPROC
 6800 DEFPROCtips
 6810 PROCborder
 6820 COLOUR15
 6830 PRINTTAB(25,5);"GAME TIPS"
 6840 PRINTTAB(8,9);"SPOILER ALERT: Only read the following if you"
 6850 PRINTTAB(8,11);"are struggling to get past the levels"
 6860 PRINTTAB(8,14);"-Focus on saving miners not acquiring wealth"
 6870 PRINTTAB(8,16);"-Always reserve dynamite for your return journey"
 6880 PRINTTAB(8,18);"-Plot your path in advance to avoid granite traps"
 6890 PRINTTAB(8,20);"-Sometimes not all miners can be saved."
 6900 PRINTTAB(8,22);"-A trip to the store or a trip to the exit?"
 6910 PRINTTAB(8,24);"-Study how landfills happen to master tunnelling"
 6920 PRINTTAB(8,26);"-Oxygen can never be replenished"
 6930 PRINTTAB(8,28);"-Only gold is used as currency for restocking"
 6940 PRINTTAB(8,30);"-Gems are only good for your retirement balance"
 6950 PRINTTAB(8,32);"-Every move counts.Don't waste time pushing walls"
 6960 PRINTTAB(8,34);"-Not all mysteries are there to be solved"
 6970 PRINTTAB(8,36);"-Use the gold seams to travel uses less dynamite"
 6980 temp=GET
 6990 CLS
 7000 ENDPROC
 7010 DEFPROCcredits
 7020 PROCborder
 7030 COLOUR15
 7040 PRINTTAB(25,5);"C R E D I T S"
 7050 PRINTTAB(8,9);"This version of Draegerman is SHAREWARE."
 7060 PRINTTAB(8,11);"https://github.com/";SIG$;"/draegerman"
 7070 PRINTTAB(8,13);"You are free to distribute unaltered."
 7080 PRINTTAB(8,16);"Want to write your own games? join #games on"
 7090 PRINTTAB(8,18);"Agon Programmers: https://discord.gg/aeKCUbWEzp"
 7100 PRINTTAB(8,20);"Code: https://github.com/8BitVino/draegerman"
 7110 PRINTTAB(8,23);"Thank you testers: oldpatientsea, SlithyMatt"
 7120 PRINTTAB(8,25);"NickP, Peter Vangsgaard, damn_pastor & LuzrBum"
 7130 PRINTTAB(8,28);"Want more? Like the whole game?"
 7140 PRINTTAB(8,30);"Draegerman: The Depths of Valor"
 7150 PRINTTAB(8,32);"- Missions on all 7 continents"
 7160 PRINTTAB(8,34);"- A unique endgame offworld rescue mission"
 7170 PRINTTAB(8,36);"- New game mechanics flooding and low-gravity"
 7180 PRINTTAB(8,38);"- Scoreboard, time attack and endless mode"
 7190 PRINTTAB(8,40);"- A banging soundtrack and updated sound effects"
 7200 PRINTTAB(8,43);"email : ";SIG$;"@gmail.com";SPC(5);"(c) ";SIG$;" 2023"
 7210 temp=GET
 7220 CLS
 7230 ENDPROC
 7240 DEFPROCtheending(Z)
 7250 CLS
 7260 COLOUR7:PRINTTAB(35,12);"The end"
 7270 PROCcensus
 7280 IF Z=2 THEN PROCgood
 7290 IF Z=3 THEN PROCmedium
 7300 IF Z=1 THEN PROCbad
 7310 PROClandend(Z)
 7320 PROCfinaltowns
 7330 PROCdestiny
 7340 K=GET
 7350 PROCfinalscore
 7360 K=GET
 7370 CLS
 7380 GOTO660
 7390 ENDPROC
 7400 DEFPROClandend(Z)
 7410 COLOURZ
 7420 FOR Y=30 TO 35 STEP1 :REM topsoil
 7430   FOR X=0 TO 63 STEP1:PRINTTAB(X,Y);CHR$230:NEXT X:NEXT Y
 7440 FOR Y=43 TO 45 STEP1  :REM bottomsoil
 7450   FOR X=0 TO 63 STEP1:PRINTTAB(X,Y);CHR$230:NEXT X:NEXT Y
 7460 FOR Y=36 TO 42 STEP1 :REM leftsoil
 7470   FOR X=0 TO 2 STEP1:PRINTTAB(X,Y);CHR$230:NEXT X:NEXT Y
 7480 FOR Y=36 TO 42 STEP1 :REM right soil
 7490   FOR X=61 TO 63 STEP1:PRINTTAB(X,Y);CHR$230:NEXT X:NEXT Y
 7500 FOR Y=36 TO 42 STEP1  :REM a third soil
 7510   FOR X=20 TO 22 STEP1:PRINTTAB(X,Y);CHR$230:NEXT X:NEXT Y
 7520 FOR Y=36 TO 42 STEP1  :REM a two thirds soil
 7530   FOR X=40 TO 42 STEP1:PRINTTAB(X,Y);CHR$230:NEXT X:NEXT Y
 7540 ENDPROC
 7550 DEFPROCgood
 7560 PROCtune(280,8,3,5,5)
 7570 PRINTTAB(4,15);"Your rescue of Alexander led him to finish a"
 7580 PRINTTAB(4,17);"groundbreaking self-contained breathing apparatus"
 7590 PRINTTAB(4,19);"which revolutionalises mine rescues. Your bravery"
 7600 PRINTTAB(4,21);"makes you a hero among the miners and their families."
 7610 PRINTTAB(4,23);CHR$34;"May you retire hapilly Draegerman, knowing it's your"
 7620 PRINTTAB(4,25);"bravery is the gold that fills our hearts with gratitude!";CHR$34
 7630 COLOUR11
 7640 PRINTTAB(46,27);SPC(12);CHR$233
 7650 PRINTTAB(29,28);M$;SPC(25);CHR$220
 7660 PRINTTAB(0,29);A$;T$;A$;T$;A$;T$;N$;CHR$32;CHR$240;CHR$239;T$;A$;T$;T$;CHR$32;U$
 7670 ENDPROC
 7680 DEFPROCmedium
 7690 PROCtune(260,8,2,5,5)
 7700 COLOUR3
 7710 IF TIMEX%<=0 THEN PRINTTAB(1,14);"You halt, collapsing, gasping for breath...."
 7720 IF CH%=-1 THEN PRINTTAB(1,14);"A surprise in bottom of the explosives bag: a spider bites you"
 7730 IF MINERS(LVL%)=-1 THEN PRINTTAB(1,14);CHR$34;"Not you again!";CHR$34;" the storekeeper yells, shooting you.."
 7740 PRINTTAB(1,16);"As life's last sigh escapes your lips, you submit to destiny."
 7750 PRINTTAB(1,18);"In the quiet, a stirring... the echo of miners you once saved"
 7760 PRINTTAB(1,20);"come, repaying the favor. Wounded deeply, you find peace, "
 7770 PRINTTAB(1,22);"a sanctuary, spending your twilight years wondering..."
 7780 PRINTTAB(16,24);CHR$34;"What more could I have done?";CHR$34
 7790 COLOUR3
 7800 PRINTTAB(29,27);CHR$212;CHR$230;CHR$230;CHR$213;SPC(22);CHR$233  :REM SANTUARY TOP
 7810 PRINTTAB(29,28);STRING$(4,CHR$210);SPC(22);CHR$220 :REM SANCTUARY MIDDLE
 7820 PRINTTAB(0,29);A$;T$;A$;T$;SPC(3);T$;SPC(2);N$;CHR$32;CHR$240;SPC(1);T$;T$;SPC(3);STRING$(4,CHR$233);U$;STRING$(3,CHR$233)
 7830 ENDPROC
 7840 DEFPROCbad
 7850 PROCtune(240,8,2,5,5)
 7860 COLOUR1
 7870 IF TIMEX%<=0 THEN PRINTTAB(1,15);"The trapped miners and you ran out of oxygen!"
 7880 IF CH%=-1 THEN PRINTTAB(1,15);"A surprise in bottom of the explosives bag:a spider bites you"
 7890 IF MINERS(LVL%)=-1 THEN PRINTTAB(1,15);CHR$34;"Not you again!";CHR$34;" the storekeeper yells, shooting you dead."
 7900 PRINTTAB(1,17);"Despite the weight of hope, your journey met a somber end."
 7910 PRINTTAB(1,19);"In tribute to your valiant efforts, the miners' families"
 7920 PRINTTAB(1,21);"place one more cross amongst the innumerable as a"
 7930 PRINTTAB(1,23);"haunting testament to your ultimate sacrifice."
 7940 COLOUR1
 7950 PRINTTAB(51,27);CHR$233
 7960 PRINTTAB(31,28);CHR$233;SPC(19);CHR$220
 7970 PRINTTAB(1,29);STRING$(27,CHR$233);CHR$32;CHR$234;CHR$32;CHR$230;CHR$32;CHR$234;CHR$32;STRING$(12,CHR$233);U$;STRING$(7,CHR$233)
 7980 ENDPROC
 7990 DEFPROCcensus
 8000 IF LVL%=5 THEN GOTO8030
 8010 Survived%(LVL%)=SAV%
 8020 Deaths%(LVL%)=MagicObjects(LVL%)-SAV%
 8030 ENDPROC
 8040 DEFPROCfinaltowns
 8050 COLOUR15
 8060 FOR X=4 TO 44 STEP 20
 8070   PRINTTAB(X,39);"Lost":PRINTTAB(X,41);"Saved"
 8080 NEXT X
 8090 PRINTTAB(4,37);TownName$(1):PRINTTAB(24,37);TownName$(2):PRINTTAB(44,37);TownName$(3)
 8100 COLOUR9
 8110 PRINTTAB(10,39);STRING$(Deaths%(1),CHR$233)
 8120 PRINTTAB(30,39);STRING$(Deaths%(2),CHR$233)
 8130 PRINTTAB(50,39);STRING$(Deaths%(3),CHR$233)
 8140 COLOUR10
 8150 PRINTTAB(10,41);STRING$(Survived%(1),CHR$239)
 8160 PRINTTAB(30,41);STRING$(Survived%(2),CHR$239)
 8170 PRINTTAB(50,41);STRING$(Survived%(3),CHR$239)
 8180 ENDPROC
 8190 DEFPROCdestiny
 8200 COLOUR15
 8210 PRINTTAB(26,31);"Draegerman"
 8220 IF Z=2 THEN PRINTTAB(28,32);"Estate"
 8230 IF Z=3 THEN PRINTTAB(27,32);"Hospice"
 8240 IF Z=1 THEN PRINTTAB(26,32);"lies here"
 8250 ENDPROC
 8260 DEFPROCbadpicker
 8270 IF LVL%>=3 PROCtheending(3)
 8280 PROCtheending(1)
 8290 ENDPROC
 8300 DEFPROCtune(m,l,r,f,d)
 8310 REM m tune to play, l=8, r=repeats, f=location in y, d= speed
 8320 FOR J=1 TO r STEP 1
 8330   RESTORE m
 8340   FOR I=1 TO l STEP 1
 8350     IF f<>0 THEN PROCbigfont(f,1)
 8360     READ pitcha:READ pitchb
 8370     SOUND 1,-2,pitcha,d:SOUND 2,-2,pitchb,d
 8380   NEXT I
 8390 NEXT J
 8400 ENDPROC
 8410 END
