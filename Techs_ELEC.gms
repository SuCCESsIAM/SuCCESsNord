

***************************************************************************************************
*
*   Input data - electricity distribution (to account for distribution losses)
*

* Global distribution losses approx 8%
* Source: https://data.worldbank.org/indicator/EG.ELC.LOSS.ZS
set     PROCESS / ELEC_DistributionGrid /;
set ELEC_TECH(P)/ ELEC_DistributionGrid /;

Parameter data_ELEC_lifetime(P)         /  ELEC_DistributionGrid     1000            /;
Parameter data_ELEC_input(p,c)          /  ELEC_DistributionGrid  .  ELECGen   1.08  /;
Parameter data_ELEC_output(p,c)         /  ELEC_DistributionGrid  .  ELEC      1     /;
Parameter data_ELEC_availability(P)     /  ELEC_DistributionGrid               1     /;
Parameter data_ELEC_varcost(P)          /  ELEC_DistributionGrid               0.001 /;
Parameter data_ELEC_capacityfactor(P,T);
data_ELEC_capacityfactor('ELEC_DistributionGrid',T) = 1;



***************************************************************************************************
*
*   Input data - electricity generation
*

set     PROCESS / 
ELEC_Coal
ELEC_OilL
ELEC_GasT
ELEC_BioM
ELEC_Wste
ELEC_Fiss
ELEC_HydroRes
ELEC_HydroRoR
ELEC_Wnd1
ELEC_SPV1
ELEC_BCCS
ELEC_CCCS
ELEC_GCCS
/;

set ELEC_TECH(P)/
ELEC_Coal
ELEC_OilL
ELEC_GasT
ELEC_BioM
ELEC_Wste
ELEC_Fiss
ELEC_HydroRes
ELEC_HydroRoR
ELEC_Wnd1
ELEC_SPV1
ELEC_BCCS
ELEC_CCCS
ELEC_GCCS
/;

set ELEC_VRE(P)/
ELEC_Wnd1
ELEC_SPV1
/;


* Lifetimes, source: IEA PCGE 2020, page 36
Parameter data_ELEC_lifetime(P) /
ELEC_Coal   40
ELEC_OilL   30
ELEC_GasT   30
ELEC_BioM   40
ELEC_Wste   40
ELEC_Fiss   60
ELEC_HydroRes   80
ELEC_HydroRoR   80
ELEC_Wnd1   25
ELEC_SPV1   25
ELEC_BCCS   40
ELEC_CCCS   40
ELEC_GCCS   40
/;


* Capital costs ($/(GJ/year))
* Source:
* - Conventional generation: IEA PCGE 2020, table 3.1, mean; coal from Krey et al., "Looking under the hood", 2019
* - VRE: IEA WEO 2021
* - CCS: Lehtveer & Emanuelsson, 2021
* Notes: Oil according to gas (CCGT), waste according to biomass
table data_ELEC_capcost(P,t) "Capital costs ($/(GJ/year))"
              2020      2030     2040     2050     2060     2070     2080     2090     2100
ELEC_Coal      46.0     46.0     46.0     46.0     46.0     46.0     46.0     46.0     46.0      
ELEC_OilL      30.3     30.3     30.3     30.3     30.3     30.3     30.3     30.3     30.3      
ELEC_GasT      30.3     30.3     30.3     30.3     30.3     30.3     30.3     30.3     30.3      
ELEC_BioM      79.3     79.3     79.3     79.3     79.3     79.3     79.3     79.3     79.3      
ELEC_Wste      79.3     79.3     79.3     79.3     79.3     79.3     79.3     79.3     79.3      
ELEC_Fiss     114.3    114.3    114.3    114.3    114.3    114.3    114.3    114.3    114.3
ELEC_HydroRes 105.2    105.2    105.2    105.2    105.2    105.2    105.2    105.2    105.2
ELEC_HydroRoR 105.2    105.2    105.2    105.2    105.2    105.2    105.2    105.2    105.2
* Wind and PV capex from Ghadim et al. 2026 (https://www.sciencedirect.com/science/article/pii/S0306261925005860)
ELEC_Wnd1      47.4     40.3     37.2     33.6     33.6     33.6     33.6     33.6     33.6
ELEC_SPV1      31.2     19.5     16.1     13.5     13.5     13.5     13.5     13.5     13.5
*
ELEC_BCCS     105.0    105.0    105.0    105.0    105.0    105.0    105.0    105.0    105.0    
ELEC_CCCS      98.3     98.3     98.3     98.3     98.3     98.3     98.3     98.3     98.3    
ELEC_GCCS      51.4     51.4     51.4     51.4     51.4     51.4     51.4     51.4     51.4    
;


* Generation efficiency, source: Krey et al., "Looking under the hood", 2019 (Appendix C, MESSAGE input data)
* 2020 efficiency matched with statistics, 2030 interpolated
Table data_ELEC_efficiency_t(P,c,t)
                    2020      2030     2040     2050     2060     2070     2080     2090     2100
ELEC_Coal  . Coal   0.33      0.35     0.38     0.38     0.38     0.38     0.38     0.38     0.38
ELEC_OilL  . OilL   0.35      0.38     0.38     0.38     0.38     0.38     0.38     0.38     0.38
ELEC_GasT  . NGas   0.42      0.45     0.50     0.55     0.55     0.55     0.55     0.55     0.55
ELEC_BioM  . BioM   0.33      0.35     0.37     0.37     0.37     0.37     0.37     0.37     0.37
ELEC_Wste  . Wste   0.25      0.25     0.25     0.25     0.25     0.25     0.25     0.25     0.25
ELEC_Fiss  . URAN   0.33      0.33     0.33     0.33     0.33     0.33     0.33     0.33     0.33
ELEC_BCCS  . BioM   0.3       0.3      0.3      0.3      0.3      0.3      0.3      0.3      0.3 
ELEC_CCCS  . Coal   0.34      0.34     0.34     0.34     0.34     0.34     0.34     0.34     0.34
ELEC_GCCS  . NGas   0.40      0.42     0.45     0.45     0.45     0.45     0.45     0.45     0.45
;

*
* Capacity factor
* NOTE: This table can be used to account for the long-term change in capacity factors.
*       Hourly variability of capacity factors for VRE are done in the Electricity module.
table data_ELEC_capacityfactor(P,t) "Change of capacity factor (annual average)"
              2020      2030      2040      2050      2060      2070      2080      2090      2100
ELEC_Wnd1      0.4       0.4       0.4       0.4       0.4       0.4       0.4       0.4       0.4
ELEC_SPV1      0.3       0.3       0.3       0.3       0.3       0.3       0.3       0.3       0.3
ELEC_Coal        1         1         1         1         1         1         1         1         1
ELEC_OilL        1         1         1         1         1         1         1         1         1
ELEC_GasT        1         1         1         1         1         1         1         1         1
ELEC_BioM        1         1         1         1         1         1         1         1         1
ELEC_Wste        1         1         1         1         1         1         1         1         1
ELEC_Fiss        1         1         1         1         1         1         1         1         1
ELEC_HydroRes    1         1         1         1         1         1         1         1         1
ELEC_HydroRoR    1         1         1         1         1         1         1         1         1
ELEC_BCCS        1         1         1         1         1         1         1         1         1   
ELEC_CCCS        1         1         1         1         1         1         1         1         1   
ELEC_GCCS        1         1         1         1         1         1         1         1         1   
;


* Processes produce ELECgen (generated electricity), distribution grids convert it into ELEC (accountif for distribution losses).
Parameter data_ELEC_output(p,c) /
ELEC_Coal  .  ELECGen   1
ELEC_OilL  .  ELECGen   1
ELEC_GasT  .  ELECGen   1
ELEC_BioM  .  ELECGen   1
ELEC_Wste  .  ELECGen   1
ELEC_Fiss  .  ELECGen   1
ELEC_HydroRes  .  ELECGen   1
ELEC_HydroRoR  .  ELECGen   1
ELEC_Wnd1  .  ELECGen   1
ELEC_SPV1  .  ELECGen   1
ELEC_BCCS  .  ELECGen   1
ELEC_CCCS  .  ELECGen   1
ELEC_GCCS  .  ELECGen   1
/;


* Availability factor Hydro AF currently replaced with a 0,6 as a guideline idea
Parameter data_ELEC_availability(P)/
ELEC_Coal   0.8
ELEC_OilL   0.8
ELEC_GasT   0.8
ELEC_BioM   0.8
ELEC_Wste   0.8
ELEC_Fiss   0.9
ELEC_HydroRes   0.45
ELEC_HydroRoR   0.45
ELEC_Wnd1   1
ELEC_SPV1   1
ELEC_BCCS   0.8
ELEC_CCCS   0.8
ELEC_GCCS   0.8
/;


* Emission factors for CH4 and N2O (tCH4/GJ and tN2O/GJ)
* Source: IPCC guidelines for GHG inventories (2006), Table 2.2
* Unit: t/GJ (or Mt/PJ)
Table data_ELEC_emissionfactors(P,E)
            CH4           N2O
ELEC_Coal   0.0000010     0.0000015
ELEC_OilL   0.0000030     0.0000006 
ELEC_GasT   0.0000010     0.0000001 
ELEC_BioM   0.0000300     0.0000040  
ELEC_Wste   0.0000300     0.0000040
*
ELEC_BCCS   0.0000300     0.0000040  
ELEC_CCCS   0.0000010     0.0000015
ELEC_GCCS   0.0000010     0.0000001 
;


Parameter data_ELEC_startyear(P) /
ELEC_BCCS        2040
ELEC_CCCS        2040
ELEC_GCCS        2040
/;


***************************************************************************************************
*
*   Input data - heat (district heating) and steam (industrial process heat/steam) generation
*

set     PROCESS / 
HEAT_Coal
HEAT_OilL
HEAT_NGas
HEAT_BioM
HEAT_Wste
HEAT_Elec
*
STEA_Coal
STEA_OilL
STEA_NGas
STEA_BioM
STEA_Wste
/;

set ELEC_TECH(P)/
HEAT_Coal
HEAT_OilL
HEAT_NGas
HEAT_BioM
HEAT_Wste
HEAT_Elec
*
STEA_Coal
STEA_OilL
STEA_NGas
STEA_BioM
STEA_Wste
/;


* Lifetimes
Parameter data_ELEC_lifetime(P) /
HEAT_Coal   30
HEAT_OilL   30
HEAT_NGas   30
HEAT_BioM   30
HEAT_Wste   30
HEAT_Elec   30
*
STEA_Coal   30
STEA_OilL   30
STEA_NGas   30
STEA_BioM   30
STEA_Wste   30
/;


* Capital costs ($/GJ) or (M$/PJ)
table data_ELEC_capcost(P,t) "Capital costs ($/(GJ/year))"
              2020      2030      2040      2050      2060      2070      2080      2090      2100
HEAT_Coal     15        15        15        15        15        15        15        15        15
HEAT_OilL     15        15        15        15        15        15        15        15        15
HEAT_NGas      3         3         3         3         3         3         3         3         3
HEAT_BioM     15        15        15        15        15        15        15        15        15
HEAT_Wste     15        15        15        15        15        15        15        15        15
HEAT_Elec      0.5       0.5       0.5       0.5       0.5       0.5       0.5       0.5       0.5
*                                                                                               
STEA_Coal     15        15        15        15        15        15        15        15        15
STEA_OilL     15        15        15        15        15        15        15        15        15
STEA_NGas      3         3         3         3         3         3         3         3         3
STEA_BioM     15        15        15        15        15        15        15        15        15
STEA_Wste     15        15        15        15        15        15        15        15        15
;

* Generation efficiency, source: IEA balances (see excel: electricity base year calibration)
Parameter data_ELEC_efficiency(P,c)/
HEAT_Coal  .  Coal   0.9
HEAT_OilL  .  OilL   0.9
HEAT_NGas  .  NGas   0.9
HEAT_BioM  .  BioM   0.9
HEAT_Wste  .  Wste   0.9
HEAT_Elec  .  Elec   0.99
*
STEA_Coal  .  Coal   0.9
STEA_OilL  .  OilL   0.9
STEA_NGas  .  NGas   0.9
STEA_BioM  .  BioM   0.9
STEA_Wste  .  Wste   0.9
/;

Parameter data_ELEC_output(p,c) /
HEAT_Coal .  HEAT    1
HEAT_OilL .  HEAT    1
HEAT_NGas .  HEAT    1
HEAT_BioM .  HEAT    1
HEAT_Wste .  HEAT    1
HEAT_Elec .  HEAT    1
*
STEA_Coal .  STEA    1
STEA_OilL .  STEA    1
STEA_NGas .  STEA    1
STEA_BioM .  STEA    1
STEA_Wste .  STEA    1
/;


* Availability factor
Parameter data_ELEC_availability(P)/
HEAT_Coal   0.9
HEAT_OilL   0.9
HEAT_NGas   0.9
HEAT_BioM   0.9
HEAT_Wste   0.9
HEAT_Elec   0.9
*
STEA_Coal   0.9
STEA_OilL   0.9
STEA_NGas   0.9
STEA_BioM   0.9
STEA_Wste   0.9
/;


* Capacity factor
table data_ELEC_capacityfactor(P,t) "Change of input_tech_capacityfactor(P,t) over the years 2020-2100"
              2020      2030      2040      2050      2060      2070      2080      2090      2100
HEAT_Coal        1         1         1         1         1         1         1         1         1
HEAT_OilL        1         1         1         1         1         1         1         1         1
HEAT_NGas        1         1         1         1         1         1         1         1         1
HEAT_BioM        1         1         1         1         1         1         1         1         1
HEAT_Wste        1         1         1         1         1         1         1         1         1
HEAT_Elec        1         1         1         1         1         1         1         1         1
*
STEA_Coal        1         1         1         1         1         1         1         1         1
STEA_OilL        1         1         1         1         1         1         1         1         1
STEA_NGas        1         1         1         1         1         1         1         1         1
STEA_BioM        1         1         1         1         1         1         1         1         1
STEA_Wste        1         1         1         1         1         1         1         1         1
;


* Emission factors for CH4 and N2O (tCH4/GJ and tN2O/GJ)
* Source: IPCC guidelines for GHG inventories (2006)
* Unit: t/GJ  or   Mt/PJ
Table data_ELEC_emissionfactors(P,E)
            CH4           N2O
HEAT_Coal   0.0000010     0.0000015 
HEAT_OilL   0.0000030     0.0000006 
HEAT_NGas   0.0000010     0.0000001 
HEAT_BioM   0.0000300     0.0000040 
HEAT_Wste   0.0000300     0.0000040 
*       
STEA_Coal   0.0000010     0.0000015 
STEA_OilL   0.0000030     0.0000006 
STEA_NGas   0.0000010     0.0000001 
STEA_BioM   0.0000300     0.0000040 
STEA_Wste   0.0000300     0.0000040 
;


Parameter data_ELEC_efficiency(P,c)//;


***************************************************************************************************
*
*   Input data - storage
*

* Battery
set     PROCESS / ELEC_Battery /;
set ELEC_TECH(P)/ ELEC_Battery /;

Parameter data_ELEC_lifetime(P)         /  ELEC_Battery              20   /;
Parameter data_ELEC_availability(P)     /  ELEC_Battery               1   /;

*data_ELEC_capacityfactor('ELEC_Battery',T) = 1;
*data_ELEC_capcost('ELEC_Battery',t) = 100000;

* Battery cost ($/GJ), from  Ghadim et al. 2026 (https://www.sciencedirect.com/science/article/pii/S0306261925005860)
Table data_ELEC_capcost(p,t)
                2020    2030    2040    2050    2060    2070    2080    2090    2100
ELEC_Battery    44400   37600   31600   26400   26400   26400   26400   26400   26400
;



***************************************************************************************************
*
*   Assign input data to techs 
*


* Assigning input commodities to processes (and how much of the commodities are being consumed by the process to generate 1 unit of output)
InputActivityRatio(r,p,c,mdfl,t)$(ELEC_TECH(P) and data_ELEC_efficiency(p,c))     = 1 / data_ELEC_efficiency(p,c);
InputActivityRatio(r,p,c,mdfl,t)$(ELEC_TECH(P) and data_ELEC_efficiency_t(p,c,t)) = 1 / data_ELEC_efficiency_t(p,c,t);

* Emission factor of a technology per unit of activity, per mode of operation.
EmissionActivityRatio(r,p,e,mdfl,t)$(ELEC_TECH(P) and data_ELEC_emissionfactors(P,E)) = data_ELEC_emissionfactors(P,E);

* Inputs to processes that are not defined thought efficiency, but input ratio:
InputActivityRatio(r,p,c,mdfl,t)$(ELEC_TECH(P) and data_ELEC_input(p,c)) = data_ELEC_input(p,c);
OutputActivityRatio(r,p,c,mdfl,t)$(ELEC_TECH(P) and data_ELEC_output(p,c)) = data_ELEC_output(p,c);

CapitalCost(r,p,t)$ELEC_TECH(P) = data_ELEC_capcost(P,t);

OperationalLife(r,p)$ELEC_TECH(P) = data_ELEC_lifetime(P);
AvailabilityFactor(r,p,t)$ELEC_TECH(P) = data_ELEC_availability(P);
CapacityFactor(r,p,l,t)$ELEC_TECH(P) = data_ELEC_capacityfactor(P,t);
CapacityToActivityUnit(r,p)$ELEC_TECH(P) = 1;

ProcessStartYear(R,P)$(ELEC_TECH(P) and data_ELEC_startyear(P)) = data_ELEC_startyear(P);



***************************************************************************************************
*
*   Additional constraints:
*

* Don't allow investments in the first period:
CapacityNewMax(R,'ELEC_Coal',tfirst) = 0;
CapacityNewMax(R,'ELEC_OilL',tfirst) = 0;
CapacityNewMax(R,'ELEC_GasT',tfirst) = 0;
CapacityNewMax(R,'ELEC_BioM',tfirst) = 0;
CapacityNewMax(R,'ELEC_Wste',tfirst) = 0;
CapacityNewMax(R,'ELEC_Fiss',tfirst) = 0;
CapacityNewMax(R,'ELEC_HydroRes',tfirst) = 0;
CapacityNewMax(R,'ELEC_HydroRoR',tfirst) = 0;
CapacityNewMax(R,'ELEC_Wnd1',tfirst) = 0;
CapacityNewMax(R,'ELEC_SPV1',tfirst) = 0;

