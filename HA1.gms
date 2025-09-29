* Sets

Set i        "Power plants/reservoirs" / AHLEN, FJAELLET, FOSEN, KARRET /;
Set t        "Time periods (hours)"      / 1*10 /;
Alias (i,j); 
Alias (t,tt);

Table UpstreamMap(i,j)
          AHLEN  FJAELLET  FOSEN  KARRET
AHLEN       0       0        1      0
FJAELLET    0       0        1      0
FOSEN       0       0        0      1
KARRET      0       0        0      0
;


Parameter 
   startLevel(i)   "Start reservoir level (Mm^3)"
   minLevel(i)     "Minimum reservoir level (Mm^3)"
   maxLevel(i)     "Maximum reservoir level (Mm^3)"
   dischargeCap(i) "Max turbine discharge (m^3/s)"
   spillCap(i)     "Max spill (m^3/s)"
   inflow(i)       "Local inflow (m^3/s)"
   powerConv(i)    "Power conversion (MW per (m^3/s))"
   delta(i)        "Time delay from reservoir i to next (hours)"
;


startLevel("AHLEN")   = 5800;
startLevel("FJAELLET")= 1000;
startLevel("FOSEN")   =  20;
startLevel("KARRET")  =  13;

minLevel("AHLEN")   = 5800;
minLevel("FJAELLET")= 1000;
minLevel("FOSEN")   =   10;
minLevel("KARRET")  =    6;

maxLevel("AHLEN")   = 7160;
maxLevel("FJAELLET")= 1675;
maxLevel("FOSEN")   =   27;
maxLevel("KARRET")  =   13;

dischargeCap("AHLEN")   = 540;
dischargeCap("FJAELLET")= 135;
dischargeCap("FOSEN")   = 975;
dischargeCap("KARRET")  = 680;

spillCap("AHLEN")   = 820;
spillCap("FJAELLET")= 930;
spillCap("FOSEN")   = 360;
spillCap("KARRET")  = 400;

inflow("AHLEN")   = 177;
inflow("FJAELLET")=  28;
inflow("FOSEN")   =   8;
inflow("KARRET")  =  29;

powerConv("AHLEN")   = 0.52;
powerConv("FJAELLET")= 1.17;
powerConv("FOSEN")   = 0.29;
powerConv("KARRET")  = 0.05;

* Hourly prices
Parameter price(t) / 1 45, 2 55, 3 95, 4 80, 5 140, 6 150, 7 80, 8 70, 9 130 /;



* Time delays in hours (sample)
delta("AHLEN")    = 2;    
delta("FJAELLET") = 1;   
delta("FOSEN")    = 1;   
delta("KARRET")   = 0;   

* ----------------------------------------------------------
* Variables
* ----------------------------------------------------------
Variable 
   R(i,t)  "Reservoir level in i at time t (Mm^3)"
   V(i,t)  "Turbine discharge in i at time t (m^3/s)"
   S(i,t)  "Spillage in i at time t (m^3/s)"
   obj     "Objective function value (EUR)";

Positive Variable R, V, S; 

* ----------------------------------------------------------
* Equations
* ----------------------------------------------------------
Equations
   waterBalance(i,t) "Reservoir water-balance constraint"
   minReserv(i,t)    "Minimum reservoir level"
   maxReserv(i,t)    "Maximum reservoir level"
   maxDisch(i,t)     "Discharge capacity constraint"
   maxSpill(i,t)     "Spillage capacity constraint"
   definitionObj     "Define objective function"
;

* Objective function:
definitionObj.. obj =e= sum((i,t), 3600 * price(t) * powerConv(i) * V(i,t));

* Reservoir balance:

waterBalance(i,t)$ (ord(t) < card(t))..
   R(i,t+1) =e= R(i,t)+ 3600*1e-6* ( inflow(i)- V(i,t)- S(i,t)   + SUM( j $ ( UpstreamMap(j,i) AND t.val - delta(j) GE 1 ),
           V(j, t - delta(j)) + S(j, t - delta(j)))
         );
         
Equation terminalRes(i);
terminalRes(i)..
   R(i,'10') =l= maxLevel(i);
* To handle t+1 on the left side, 
* we must be careful with the boundary t=last period.


* Bounds on reservoir volumes
minReserv(i,t).. R(i,t) =g= minLevel(i);
maxReserv(i,t).. R(i,t) =l= maxLevel(i);

* Bounds on discharges
maxDisch(i,t)..  V(i,t) =l= dischargeCap(i);
maxSpill(i,t)..  S(i,t) =l= spillCap(i);



* Initial Conditions

Equation initRes(i) "Fix reservoir i at time=1 to startLevel";
initRes(i)..  R(i, '1') =e= startLevel(i);


* Model declaration and solve

Model hydroLP / 
      definitionObj
      waterBalance
      terminalRes
      minReserv
      maxReserv
      maxDisch
      maxSpill
      initRes
/;

Solve hydroLP using LP maximizing obj;
Display obj.L, R.L, V.L, S.L;
Display price, powerConv;