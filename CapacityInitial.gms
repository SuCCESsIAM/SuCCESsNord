
*** REFI ***

* Base year output in PJ/year
Parameter data_REFI_baseyroutput(P,R)  /
REFI_OilRef             . World    189159
REFI_FCCracker          . World         1 
REFI_CrackerGasoil      . World         8
REFI_CrackerNaphta      . World        96
REFI_CrackerLPG         . World        16
REFI_CrackerEthane      . World        40
/;

* Add 12% to satisfy 2020 demand
CapacityResidual(r,p,t)$REFI_TECH(P) = 1.12 * data_REFI_baseyroutput(P,R) / data_REFI_availability(P) * max(0, 1 - (T.val-2020)/OperationalLife(r,p) );



*** ELEC ***

* Base year output in PJ/year
* Source: IEA energy balances (see excel: Electricity base year calibration)
* NOTE: currently (2021-04-23) only electricity-only plants included here 
Parameter data_ELEC_baseyroutput(P,R)/
ELEC_Coal      . World     36371
ELEC_OilL      . World      2605
ELEC_GasT      . World     23220
ELEC_BioM      . World      2087
ELEC_Wste      . World       407
ELEC_Fiss      . World     10077
****** TODO - need figures ******
ELEC_HydroRes  . World     15762
ELEC_HydroRoR  . World     0
****** TODO - need figures ******
ELEC_Wnd1      . World      5928
ELEC_SPV1      . World      3068
* Heat and steam
* TODO: Need actual values
HEAT_Coal      . World     1
HEAT_OilL      . World     1
HEAT_NGas      . World     1
HEAT_BioM      . World     1
HEAT_Wste      . World     1
HEAT_Elec      . World     0
*  
STEA_Coal      . World     1
STEA_OilL      . World     1
STEA_NGas      . World     1
STEA_BioM      . World     1
STEA_Wste      . World     1
/;

* Add some extra capacity so the system isn't on the edge
* (note: electricity needs more 'excess' capacity to cover also for the hourly variations)
CapacityResidual(r,p,t)$(ELEC_TECH(P) and data_ELEC_baseyroutput(P,R) and not ELEC_VRE(P)) = 1.2 * data_ELEC_baseyroutput(P,R) / data_ELEC_availability(P) / data_ELEC_capacityfactor(P,t) * max(0, 1 - (T.val-2020)/OperationalLife(r,p) );
CapacityResidual(r,p,t)$(ELEC_TECH(P) and data_ELEC_baseyroutput(P,R) and ELEC_VRE(P)) = 1.0 * data_ELEC_baseyroutput(P,R) / data_ELEC_availability(P) / data_ELEC_capacityfactor(P,t) * max(0, 1 - (T.val-2020)/OperationalLife(r,p) );

* Require electricity generation in 2020 to be close to the actual values:
* Note, 2024 July: current SuCCESs calibration has less electricity consumption than IEA, whereby baseyroutput can be used as upper limit.
* Note, 2025 December: Slight slack needed for the Nordic version.
OutputAnnualByProcess.UP('World',ELEC_TECH,'ElecGen','2020')$data_ELEC_baseyroutput(ELEC_TECH,'World') = 1.05 * data_ELEC_baseyroutput(ELEC_TECH,'World');

* Constrain hydro capacity s.t. it can grow only 10% over the century:
CapacityTotalMax('World','ELEC_HydroRes',t) = CapacityResidual('World','ELEC_HydroRes',t) / data_ELEC_availability('ELEC_HydroRes') / data_ELEC_capacityfactor('ELEC_HydroRes',t) * (1.01 + 0.1 * (t.val-2020)/(2100-2020));
CapacityTotalMax('World','ELEC_HydroRoR',t) = CapacityResidual('World','ELEC_HydroRoR',t) / data_ELEC_availability('ELEC_HydroRoR') / data_ELEC_capacityfactor('ELEC_HydroRoR',t) * (1.01 + 0.1 * (t.val-2020)/(2100-2020));



*** CHEM ***

* Base year output in Mt/year
* Source: Levi and Cullen (2018), represents year 2013
Parameter data_CHEM_baseyroutput(P,R)/
CHEM_ThermoPlst             .  World    222.2
CHEM_ThermoSets             .  World    107.2
CHEM_SolventsEtc            .  World    107.3
CHEM_OtherPetro             .  World    108.9 
CHEM_NitroFertil            .  World    274.7
CHEM_OtherChemDmd           .  World    286.8
*
CHEM_AmmoniaCoalExisting    .  World    48
CHEM_AmmoniaGasExisting     .  World    133
/;

* Add 5% to each capacity so the system isn't on the edge
CapacityResidual(r,p,t)$CHEM_TECH(P) = 1.05 * data_CHEM_baseyroutput(P,R) / data_CHEM_availability(P) * max(0, 1 - (T.val-2020)/OperationalLife(r,p) );



*** INDU ***

* Base year output in Mt/year
Parameter data_INDU_baseyroutput(P,R)/
INDU_BlastFurnace  .  World     1350 
INDU_Scrap_EAF     .  World      650
*INDU_Alumina     
*INDU_Aluminium   
*INDU_Cement      
*INDU_Cement_CCS  
*INDU_Copper
*INDU_Copper_recy
*INDU_Nickel
*INDU_Nickel_recy
*INDU_Alumina     
*INDU_Aluminium   
*INDU_Cement      
/;

* Add 5% to each capacity so the system isn't on the edge
CapacityResidual(r,p,t)$(INDU_TECH(P) and data_INDU_lifetime(P)) = 1.05 * data_INDU_baseyroutput(P,R) / data_INDU_availability(P) * max(0, 1 - (T.val-2020)/OperationalLife(r,p) );


*** TRAN ***

* Initial Capacity (mln. vehicles, around 2020)
* Source: EIA, IEA, Wikipedia, sustainable-bus.com
Parameter data_TRAN_initialcapacity(P,R) /
TRAN_PASS_CarGasoline     .  World         1036.765217
TRAN_PASS_CarDiesel       .  World          259.191304
TRAN_PASS_CarHEV          .  World           14.043478
TRAN_PASS_CarPHEV         .  World            3.346713
TRAN_PASS_CarBEV          .  World            6.850327
*TRAN_PASS_BusDiesel      .  World            2.400000
*TRAN_PASS_BusBEV         .  World            0.600000
                                   
*TRAN_FRGT_VanBEV         .  World            0.435000
*TRAN_FRGT_TruckBEV       .  World            0.031000
/;

CapacityResidual(r,p,t)$(TRAN_TECH(P) and data_TRAN_initialcapacity(P,R)) = data_TRAN_initialcapacity(p,R) * max(0, 1 - (T.val-2020)/OperationalLife(r,p) );

