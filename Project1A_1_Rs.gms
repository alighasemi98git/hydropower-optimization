$Title Hydroelectric Power Optimization with reservoir levels

* Define sets
Set
    i power plant /Ahlen, Fjallet, Forsen, Karret/
    t hour /1,2,3,4,5,6,7,8,9/;
    
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
    P(t) price  /1 45, 2 55, 3 120, 4 90, 5 140, 6 105, 7 80, 8 90, 9 120/
    delta(i) time delay from i to next /Ahlen 2, Fjallet 1, Forsen 1, Karret 0/
    deltaBool(i, j) boolean to determine if upstream (i to j) / Ahlen.Forsen 1, Fjallet.Forsen 1, Forsen.Karret 1 /;
    
*  /1 45, 2 55, 3 95, 4 80, 5 140, 6 150, 7 80, 8 70, 9 130/

* Define variables
Variable
    R(i,t) reservoir level
    V(i,t) discharge level
    S(i,t) spillage level
    Z total profit;

Positive Variable
    V discharge level
    S spillage level;

* Declare equations
Equation
    water_balance(i,t)
    water_balance_start(i)
    water_balance_terminal_max(i)
    water_balance_terminal_min(i)  
    dis_max(i,t)
    spill_max(i,t)
    obj
    res_max(i,t)
    res_min(i,t);
    
* Define equations
dis_max(i,t).. V(i,t) =l= Vmax(i);

spill_max(i,t).. S(i,t) =l= Spillmax(i);

obj.. Z =e= sum((i,t), 3600*P(t)*eta(i)*V(i,t));

water_balance(i,t).. Rstart(i) + 3600*(10**(-6))*sum((tt)$(ord(tt) le ord(t)-1),
                Q(i) - V(i,tt) - S(i,tt) + sum((j)$(deltaBool(j,i) and ord(tt)-delta(j) ge 1),
                V(j,tt-delta(j)) + S(j,tt-delta(j)))) =e= R(i,t);
                
water_balance_start(i).. R(i,'1') =e= Rstart(i);

water_balance_terminal_max(i).. Rstart(i) + 3600*(10**(-6))*sum((tt)$(ord(tt) le 9),
                Q(i) - V(i,tt) - S(i,tt) + sum((j)$(deltaBool(j,i) and ord(tt)-delta(j) ge 1),
                V(j,tt-delta(j)) + S(j,tt-delta(j)))) =l= Rmax(i);
                
water_balance_terminal_min(i).. Rstart(i) + 3600*(10**(-6))*sum((tt)$(ord(tt) le 9),
                Q(i) - V(i,tt) - S(i,tt) + sum((j)$(deltaBool(j,i) and ord(tt)-delta(j) ge 1),
                V(j,tt-delta(j)) + S(j,tt-delta(j)))) =g= Rmin(i);

res_max(i,t).. R(i,t) =l= Rmax(i);

res_min(i,t).. R(i,t) =g= Rmin(i);

Model Project1A_1 /all/;

Solve Project1A_1 using LP maximizing Z;

Display R.L, V.L, S.L, Z.L;



    


