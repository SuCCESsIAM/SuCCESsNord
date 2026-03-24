$offlisting

* Give timeframe for the mode to run, but ensure that the relevant data exists:
* - datetimes
* - demand
* - VRE capacity factors
* In the initial commit, data exists for 2010-2019


*************************************************************************************************
*
*   Set definitions
*

* Set timeframe from the command line with '--timeframe = x'.
* Data needs to correspond to
* currently ten_years is the "old" version and ten_automated contains also baltics and ceurope
$if not set timeframe $setglobal timeframe multi-all


* representative periods relevant for clustered version
set ReprPeriod /
$include ElectricityData/%timeframe%/REPRESENTATIVE_PERIODS.txt
/;

set hour /
$include ElectricityData/%timeframe%/HOURS.txt
/;


alias(hour,h);
alias(ReprPeriod,rp);

set hfirst(h);
set hlast(h);
hfirst(h) = yes$(ord(h) eq 1);
hlast(h)  = yes$(ord(h) eq card(h));



* technologies defined here
*set p                   / PV, Wind, HydroRoR, HydroRes, Nuclear, Biomass, Coal, Peat, Waste, Oil, GasCCGT, GasTurb, Battery, LtStorage /;
set ELEC_p_gen(p)       / ELEC_Coal, ELEC_OilL, ELEC_GasT, ELEC_BioM, ELEC_Wste, ELEC_Fiss, ELEC_HydroRes, ELEC_HydroRoR, ELEC_Wnd1, ELEC_SPV1, ELEC_BCCS, ELEC_CCCS, ELEC_GCCS /;
set ELEC_p_disp(p)      / ELEC_Coal, ELEC_OilL, ELEC_GasT, ELEC_BioM, ELEC_Wste, ELEC_Fiss, ELEC_HydroRes, ELEC_HydroRoR, ELEC_BCCS, ELEC_CCCS, ELEC_GCCS /;
set ELEC_p_hydr(p)      / ELEC_HydroRoR /;
set ELEC_p_VRE(p)       / ELEC_Wnd1, ELEC_SPV1 /;
set ELEC_p_storage(p)   / ELEC_Battery /
*set ELEC_p_storage(p)   /  /

set ELEC_VRE_type   / wind, PV /

set ELEC_VRE_process_type(ELEC_p_VRE, ELEC_VRE_type)/
ELEC_Wnd1 . wind
ELEC_SPV1 . PV
/;




*************************************************************************************************
*
*   Variability data
*


Parameter ReprPeriodWeight(ReprPeriod) /
$include ElectricityData/%timeframe%/REPRESENTATIVE_PERIODS_WEIGHTS.txt
/;

table data_ELEC_VRE_CF(rp,h,r,ELEC_VRE_type)
$include ElectricityData/%timeframe%/VRE_CAPACITY_FACTORS.txt
;

table ELEC_DemandVariation(rp,h,r)
$include ElectricityData/%timeframe%/DEMAND.txt
;


*Assing the regional average annual capacity factors to the annual level parameter:
CapacityFactor(r,ELEC_p_VRE,'ANNUAL',t) =
    sum((rp, h,ELEC_VRE_type)$(ELEC_VRE_process_type(ELEC_p_VRE,ELEC_VRE_type)), ReprPeriodWeight(rp) * data_ELEC_VRE_CF(rp,h,r,ELEC_VRE_type)) / card(hour)
* index series of CapacityFactor changes over t
    * CapacityFactor(r,ELEC_p_VRE,'ANNUAL',t) / CapacityFactor(r,ELEC_p_VRE,'ANNUAL','2020')
;



*************************************************************************************************
*
*   Storages
*

Parameters
    ELEC_STORAGE_decay(T,R,ELEC_p_storage)
    ELEC_STORAGE_eff(T,R,ELEC_p_storage)
*    ELEC_STORAGE_cost(T,R,ELEC_p_storage)
    ELEC_STORAGE_discharge_maxrate(T,R,ELEC_p_storage)
    ELEC_STORAGE_charge_maxrate(T,R,ELEC_p_storage)
;

* Battery storage: 96% round-trip efficiency, 30 day self-discharge time
ELEC_STORAGE_decay(T,R,'ELEC_Battery') = 0.9986;
ELEC_STORAGE_eff(T,R,'ELEC_Battery')   = 0.96;

* Small cost to avoid same-period charge-discharge cycles:
*ELEC_STORAGE_cost(T,R,'ELEC_Battery')   = 0.001;
*** THIS SHOULD BE PUT TO Techs_ELEC ***
*VariableCost(r,'ELEC_Battery',mdfl,t) = 0.001;
*** THIS SHOULD BE PUT TO Techs_ELEC ***

* Storage change and discharge limits (assume four hour system -> 25%)
ELEC_STORAGE_discharge_maxrate(T,R,'ELEC_Battery') = 0.25;
ELEC_STORAGE_charge_maxrate(T,R,'ELEC_Battery') = 0.25;


*Table CapacityStorage(ELEC_p_storage,r) 'Capacity in MWh'
**           DNK        FIN       NOR          SWE
*ELEC_Battery      0      0      0         0
**ELEC_Battery   10000      10000     10000        10000
**$include inputdata/%timeframe%/STORAGE_CAPACITY.txt
*;
*
*CapacityTotal(r,ELEC_p_storage,t) = CapacityStorage(ELEC_p_storage,r);



*************************************************************************************************
*
*   Transmission capacity
*

* Transmission Capacity (PJ/a)
* Mostly from https://zenodo.org/records/10870602 (FIN-NOR added)
Parameters ELEC_TransmissionCapacity(r,rr) 'Transmission capacity in PJ/a scaled to hourly later'/
DNK.SWE     77.26 
DNK.NOR     51.72 
DNK.FIN     0.00  
DNK.BLT     0.00  
DNK.World   78.84 
SWE.NOR     116.53
SWE.FIN     75.69 
SWE.BLT     22.08 
SWE.World   19.39 
NOR.FIN     3.15  
NOR.BLT     0.00  
NOR.World   45.54 
FIN.BLT     32.04 
FIN.World   0.00  
BLT.World   15.77 
*$include inputdata/%timeframe%/TRANSMISSION_CAPACITY.txt
/;
ELEC_TransmissionCapacity(r,rr) = ELEC_TransmissionCapacity(r,rr) / 8760;


*************************************************************************************************
*
*   Electricity model core
*

$include Electricity_core.gms



*************************************************************************************************
*
*   Transmission flows and costs
*

* Add small cost to avoid unnecessary transmission:
set     PROCESS / ELEC_Exports, ELEC_Imports /;
set ELEC_TECH(P)/ ELEC_Exports, ELEC_Imports /;

Parameter data_ELEC_lifetime(P)         /  ELEC_Exports      1000           /;
Parameter data_ELEC_lifetime(P)         /  ELEC_Imports      1000           /;
Parameter data_ELEC_varcost(P)          /  ELEC_Exports     0.0001          /;
Parameter data_ELEC_varcost(P)          /  ELEC_Imports     0.0001          /;
Parameter data_ELEC_availability(P)     /  ELEC_Exports       1             /;
Parameter data_ELEC_availability(P)     /  ELEC_Imports       1             /;
Parameter data_ELEC_capacityfactor_p(P) /  ELEC_Exports       1             /;
Parameter data_ELEC_capacityfactor_p(P) /  ELEC_Imports       1             /;

Parameter data_ELEC_input(p,c)          /  ELEC_Exports  .  ELECGen   1     /;
Parameter data_ELEC_output(p,c)         /  ELEC_Imports  .  ELECGen   1     /;


* Assign data to OSEMOSYS parameters:
InputActivityRatio(r,p,c,mdfl,t)$data_ELEC_input(p,c) = data_ELEC_input(p,c);
OutputActivityRatio(r,p,c,mdfl,t)$data_ELEC_output(p,c) = data_ELEC_output(p,c);

VariableCost(r,ELEC_TECH,mdfl,t)$data_ELEC_varcost(ELEC_TECH) = data_ELEC_varcost(ELEC_TECH);

OperationalLife(r,ELEC_TECH) = data_ELEC_lifetime(ELEC_TECH);
AvailabilityFactor(r,ELEC_TECH,t) = data_ELEC_availability(ELEC_TECH);
CapacityFactor(r,ELEC_TECH,l,t)$data_ELEC_capacityfactor_p(ELEC_TECH) = data_ELEC_capacityfactor_p(ELEC_TECH);
CapacityToActivityUnit(r,ELEC_TECH) = 1;

Equations
    EQ_ELEC_ExportsAnnual(r,t)
    EQ_ELEC_ImportsAnnual(r,t)
;

* Annual-level exports from and imports to a region are summed from the hourly exports and imports per region:
EQ_ELEC_ExportsAnnual(r,t)..  ActivityAnnual(r,'ELEC_Exports',t) =E= 8760/card(hour) * sum((rp, h, rr), ReprPeriodWeight(rp) * ELEC_Exports(t,rp,h,r,rr)) ;
EQ_ELEC_ImportsAnnual(r,t)..  ActivityAnnual(r,'ELEC_Imports',t) =E= 8760/card(hour) * sum((rp, h, rr), ReprPeriodWeight(rp) * ELEC_Exports(t,rp,h,rr,r)) ;

