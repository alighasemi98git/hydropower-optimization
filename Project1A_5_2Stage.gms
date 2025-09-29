$Title Hydroelectric Power Optimization EV

* Define sets
Set
    i power plant /Ahlen, Fjallet, Forsen, Karret/
    t hour /1,2,3,4,5,6,7,8,9/
    sc scenarios /1,2,3/;
    
Alias(t, tt);
Alias(i, j)
    
* Define parameters
Parameter
    Rmin(i) minimum allowed reservoir level /Ahlen 5800, Fjallet 1000, Forsen 10, Karret 6/
    Rmax(i) maximum allowed reservoir level /Ahlen 7160, Fjallet 1675, Forsen 27, Karret 13/
    Rstart(i) starting reservoir level /Ahlen 5800, Fjallet 1000, Forsen 20, Karret 13/
    Vmax(i) discharge capacity /Ahlen 540, Fjallet 135, Forsen 975, Karret 680/
    Spillmax(i) spillage capacity /Ahlen 820, Fjallet 930, Forsen 360, Karret 400/
    Q(i) local inflow /Ahlen 177, Fjallet 28, Forsen 8, Karret 29/
    eta(i) power conversion factor /Ahlen 0.52, Fjallet 1.17, Forsen 0.29, Karret 0.05/
    delta(i) time delay from i to next /Ahlen 2, Fjallet 1, Forsen 1, Karret 0/
    deltaBool(i, j) boolean to determine if upstream (i to j) / Ahlen.Forsen 1, Fjallet.Forsen 1, Forsen.Karret 1 /;    

Table P(t, sc) price per scenario over time
    1       2       3
1   45      45      45
2   55      55      55 
3   80      95      120
4   80      80      90
5   110     80      140
6   110     130     105
7   80      130     80
8   30      60      90
9   70      95      120;

* Define variables
Variable
    R(i,t,sc) reservoir level
    V(i,t,sc) discharge level
    S(i,t,sc) spillage level
    Z total profit;

Positive Variable
    R
    V
    S;

* Declare equations
Equation
    water_balance_1(i,t,sc)
    water_balance_2(i,t,sc)
    water_balance_terminal_max(i,sc)
    water_balance_terminal_min(i,sc)
    res_max(i,t,sc)
    res_min(i,t,sc)
    dis_max(i,t,sc)
    spill_max(i,t,sc)
    scen_match_dis_12(i,t)
    scen_match_dis_23(i,t)
    scen_match_spill_12(i,t)
    scen_match_spill_23(i,t)
    obj;
    
* Define equations
water_balance_1(i,t,sc)$(ord(t) = 1).. Rstart(i) =e= R(i,t,sc);

water_balance_2(i,t,sc)$(ord(t) ge 2).. Rstart(i) + 3600*(10**(-6))*sum((tt)$(ord(tt) le ord(t)-1),
                Q(i) - V(i,tt,sc) - S(i,tt,sc) + sum((j)$(deltaBool(j,i) and ord(tt)-delta(j) ge 1),
                V(j,tt-delta(j),sc) + S(j,tt-delta(j),sc))) =e= R(i,t,sc);
                
water_balance_terminal_max(i,sc).. Rstart(i) + 3600*(10**(-6))*sum((tt)$(ord(tt) le 9),
                Q(i) - V(i,tt,sc) - S(i,tt,sc) + sum((j)$(deltaBool(j,i) and ord(tt)-delta(j) ge 1),
                V(j,tt-delta(j),sc) + S(j,tt-delta(j),sc))) =l= Rmax(i);
                
water_balance_terminal_min(i,sc).. Rstart(i) + 3600*(10**(-6))*sum((tt)$(ord(tt) le 9),
                Q(i) - V(i,tt,sc) - S(i,tt,sc) + sum((j)$(deltaBool(j,i) and ord(tt)-delta(j) ge 1),
                V(j,tt-delta(j),sc) + S(j,tt-delta(j),sc))) =g= Rmin(i);
                
res_max(i,t,sc).. R(i,t,sc) =l= Rmax(i);

res_min(i,t,sc).. R(i,t,sc) =g= Rmin(i);

dis_max(i,t,sc).. V(i,t,sc) =l= Vmax(i);

spill_max(i,t,sc).. S(i,t,sc) =l= Spillmax(i);

scen_match_dis_12(i,t)$(ord(t) le 2).. V(i,t,'1') =e= V(i,t,'2');

scen_match_dis_23(i,t)$(ord(t) le 2).. V(i,t,'2') =e= V(i,t,'3');

scen_match_spill_12(i,t)$(ord(t) le 2).. S(i,t,'1') =e= S(i,t,'2');

scen_match_spill_23(i,t)$(ord(t) le 2).. S(i,t,'2') =e= S(i,t,'3');  

obj.. Z =e= sum((i,t)$(ord(t) le 2), 3600*P(t,'1')*eta(i)*V(i,t,'1')) + (1/3)*sum((i,t,sc)$(ord(t) ge 3 ), 3600*P(t,sc)*eta(i)*V(i,t,sc));

Model Project1A_1 /all/;

Solve Project1A_1 using LP maximizing Z;

Display R.L, V.L, S.L, Z.L;



    


