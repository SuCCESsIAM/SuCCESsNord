***************************************************************************************************
*
*   Initial Capacity - Nord
*

*** TODO: ***

*** HEAT ***
*** CHEM ***
*** TRAN - other than passenger cars ***


Table data_CapacityInitial(P,R)
                    DNK     FIN     NOR     SWE     BLT   
* Electricity capacity (PJ/year)
ELEC_Coal           115.30  104.01  0.00    0.00    62.13 
ELEC_OilL           31.82   41.00   0.00    0.00    0.25  
ELEC_GasT           54.84   58.31   20.25   0.00    94.86 
ELEC_BioM           59.04   58.66   0.00    185.58  12.61 
ELEC_Wste           12.11   5.14    0.00    92.79   1.29  
ELEC_Fiss           0.00    88.11   0.00    243.14  0.00  
ELEC_HydroRes       0.00    33.06   836.74  171.36  0.00 
ELEC_HydroRoR       0.22    66.22   197.04  343.24  54.05
ELEC_Wnd1           192.43  67.64   121.92  304.26  29.55 
ELEC_SPV1           31.95   0.22    0.00    0.00    7.41  
*
*ELEC_Battery       0.00    0.00    0.00    0.00    0.00 
*ELEC_PumpHydro     0.00    0.00    32.51   0.00    28.38
*
* Heat
*                   DNK     FIN     NOR     SWE     BLT   
HEAT_Coal           3.854   10.548  42.098  0.285   7.439
HEAT_OilL           1.359   1.456   9.072   0.579   2.571
HEAT_NGas           22.450  14.738  18.303  0.431   2.932
HEAT_BioM           52.567  65.602  78.509  7.005   106.154
HEAT_Wste           0       28.562  13.646  10.854  49.409
*
STEA_BioM           0       137.05  20.94   126.75  0      
* Oil refining:
*                   DNK     FIN     NOR     SWE     BLT   
REFI_OilRef         368.01  431.46  930.6   435.69  401.85
*REFI_FCCracker     
*REFI_CrackerGasoil 
*REFI_CrackerNaphta 
*REFI_CrackerLPG    
*REFI_CrackerEthane 
*
*Industry:
*                   DNK     FIN     NOR     SWE     BLT   
INDU_BlastFurnace   0       2.976   0.085   3.172   0
INDU_Scrap_EAF      0       1.346   0.619   1.549   0
INDU_Cement_coal    2.48    1.4750  1.4925  2.8000  2.7998
;

Table data_CapacityInitial(P,R)
                        DNK         FIN         NOR         SWE         BLT   
TRAN_PASS_CarGasoline   1.834366    2.521533    0.999263    2.836357    1.1879
TRAN_PASS_CarDiesel     0.827405    0.943224    1.315081    1.755156    1.85395
TRAN_PASS_CarBioliq     0           0.00463     0.000005    0.000117    0
TRAN_PASS_CarHEV        0           0.076391    0.15572     0.160787    0.042102
TRAN_PASS_CarPHEV       0.029701    0.046538    0.120662    0.122189    0
TRAN_PASS_CarBEV        0.031886    0.009959    0.343707    0.05579 0.005453
;

Table data_CapacityNew2025(P,R)
                        DNK         FIN         NOR         SWE         BLT   
TRAN_PASS_CarGasoline   0.138421    0.075765    0.052595    0.194265    0.054449
TRAN_PASS_CarDiesel     0.046295    0.014567    0.019709    0.067981    0.017035
TRAN_PASS_CarBioliq     0.014263    0.006086    0.082239    0.031525    0.002414
TRAN_PASS_CarHEV        0.010513    0.018727    0.015058    0.047742    0.010923
TRAN_PASS_CarPHEV       0.018235    0.013231    0.028162    0.065924    0
TRAN_PASS_CarBEV        0.014218    0.004245    0.082212    0.027981    0.001175
;


* Assign existing capacity:
CapacityResidual(r,p,t)$(not ELEC_TECH(P) and data_CapacityInitial(P,R)) = 1.05 * data_CapacityInitial(P,R) * max(0, 1 - (T.val-2020)/OperationalLife(r,p) );
CapacityResidual(r,p,t)$(ELEC_TECH(P) and data_CapacityInitial(P,R) and not ELEC_VRE(P)) = 1.05 * data_CapacityInitial(P,R) * max(0, 1 - (T.val-2020)/OperationalLife(r,p) );
CapacityResidual(r,p,t)$(ELEC_TECH(P) and data_CapacityInitial(P,R) and ELEC_VRE(P)) = 1.0 * data_CapacityInitial(P,R) * max(0, 1 - (T.val-2020)/OperationalLife(r,p) );

* Require new capacity in 2030 to include at least the capacity additions by 2025:
CapacityNew.LO(r,p,'2030')$data_CapacityNew2025(P,R) = 5 * data_CapacityNew2025(P,R);



***************************************************************************************************
*
*   Additional constraints:
*

* Dont allow further investments in hydro or nuclear:
CapacityTotalMax(Region_Nord,'ELEC_HydroRes',T) = CapacityResidual(Region_Nord,'ELEC_HydroRes','2020');
CapacityTotalMax(Region_Nord,'ELEC_HydroRoR',T) = CapacityResidual(Region_Nord,'ELEC_HydroRoR','2020');

CapacityTotalMax(Region_Nord,'ELEC_Fiss',T) = CapacityResidual(Region_Nord,'ELEC_Fiss','2020');

