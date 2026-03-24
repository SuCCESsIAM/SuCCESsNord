
***************************************************************************************************
*
*   Input data - buildings (residential and commercial) 
*

set     PROCESS / 
BLDN_ELEC_PRC
BLDN_LIQU_PRC
BLDN_GASE_PRC
BLDN_SOLI_PRC
BLDN_HEAT_PRC
/;

set BLDN_TECH(P)/
BLDN_ELEC_PRC
BLDN_LIQU_PRC
BLDN_GASE_PRC
BLDN_SOLI_PRC
BLDN_HEAT_PRC
/;

* Investment cost ($/t output):
table data_BLDN_capcost(P,t) "Investment cost ($/t output) over the years 2020-2100"
              2020      2030      2040      2050      2060      2070      2080      2090      2100
;

* Lifetimes, source: 
Parameter data_BLDN_lifetime(P) /
BLDN_ELEC_PRC     1000
BLDN_LIQU_PRC     1000
BLDN_GASE_PRC     1000
BLDN_SOLI_PRC     1000
BLDN_HEAT_PRC     1000
/;

* Process inputs
Parameter data_BLDN_input(p,c,m)/
BLDN_ELEC_PRC . ELEC . M1     1
BLDN_LIQU_PRC . OILL . M1     1
BLDN_LIQU_PRC . OILH . M2     1
BLDN_LIQU_PRC . BIOL . M3     1
BLDN_GASE_PRC . NGAS . M1     1
BLDN_GASE_PRC . NGLS . M2     1
BLDN_GASE_PRC . BIOG . M3     1
* disabled coal input for buildings
*BLDN_SOLI_PRC . COAL . M1     1
*BLDN_SOLI_PRC . BIOM . M2     1
BLDN_SOLI_PRC . BIOM . M1     1
BLDN_HEAT_PRC . HEAT . M1     1
/;


Parameter data_BLDN_output(p,c) /
BLDN_ELEC_PRC .  BLDN_ELEC    1
BLDN_LIQU_PRC .  BLDN_LIQUID  1
BLDN_GASE_PRC .  BLDN_GASES   1
BLDN_SOLI_PRC .  BLDN_SOLID   1
BLDN_HEAT_PRC .  BLDN_HEAT    1
/;


* Availability factor
Parameter data_BLDN_availability(P)/
BLDN_ELEC_PRC     1
BLDN_LIQU_PRC     1
BLDN_GASE_PRC     1
BLDN_SOLI_PRC     1
BLDN_HEAT_PRC     1
/;

* Capacity factor
Parameter data_BLDN_capacityfactor(P)/
BLDN_ELEC_PRC     1
BLDN_LIQU_PRC     1
BLDN_GASE_PRC     1
BLDN_SOLI_PRC     1
BLDN_HEAT_PRC     1
/;



***************************************************************************************************
*
*   Traditional biomass use
*


set     PROCESS / TRAD_BIOM /;
set BLDN_TECH(P)/ TRAD_BIOM /;

parameter data_BLDN_Input(p,c,m)      / TRAD_BIOM . BIOM . m1   1 /;
parameter data_BLDN_Output(p,c)       / TRAD_BIOM . TRAD_BIOM   1 /;
Parameter data_BLDN_availability(P)   / TRAD_BIOM   1 /;
Parameter data_BLDN_capacityfactor(P) / TRAD_BIOM   1 /;
Parameter data_BLDN_lifetime(P)       / TRAD_BIOM   9999 /;




***************************************************************************************************
*
*   Assign input data to techs 
*

* Note: process inputs are defined by opreating mode:
InputActivityRatio(r,p,c,m,t)$(BLDN_TECH(P) and data_BLDN_input(p,c,m)) = data_BLDN_input(p,c,m);
OutputActivityRatio(r,p,c,mdfl,t)$(BLDN_TECH(P) and data_BLDN_output(p,c)) = data_BLDN_output(p,c);

*EmissionActivityRatio(r,p,e,mdfl,t)$BLDN_TECH(P) = data_BLDN_emissionfactor(P,E);

CapitalCost(r,p,t)$(BLDN_TECH(P) and data_BLDN_capcost(p,t)) = data_BLDN_capcost(P,t);
*VariableCost(r,p,m,t)$(BLDN_TECH(P) and data_BLDN_varcost(p)) = data_BLDN_varcost(P);

OperationalLife(r,p)$BLDN_TECH(P) = data_BLDN_lifetime(P);
AvailabilityFactor(r,p,t)$BLDN_TECH(P) = data_BLDN_availability(P);
CapacityFactor(r,p,l,t)$BLDN_TECH(P) = data_BLDN_capacityfactor(P);
CapacityToActivityUnit(r,p)$BLDN_TECH(P) = 1;

