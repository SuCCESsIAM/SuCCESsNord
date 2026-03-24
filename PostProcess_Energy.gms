
Set sector / BLDN, CHEM, ELEC, INDU, REFI, TRAN, XTRC, LAND, EXOG /;

set CommodityEnergy(c) /
COAL
NGAS
NGLs
Ethane
CRUD
LPGs
GSLN
OILL
OILH
URAN
BIOM
BIOG
BGSL
BIOL
WSTE
HYDR
ELECGen
ELEC
HEAT
STEA
/;


* Aggregated outputs from the energy module:
Parameters
    EnergyBySector(r,CommodityEnergy,sector,t)
    EnergyFinal(r,CommodityEnergy,t)
    EnergyFinalTotal(r,t)
    EnergyPrimaryTotal(r,t);
;

* Final energy consumption by sector and commodity:
EnergyBySector(r,CommodityEnergy,'BLDN',t) = sum(p$BLDN_TECH(p), InputAnnualByProcess.L(r,p,CommodityEnergy,t));
EnergyBySector(r,CommodityEnergy,'CHEM',t) = sum(p$CHEM_TECH(p), InputAnnualByProcess.L(r,p,CommodityEnergy,t));
EnergyBySector(r,CommodityEnergy,'ELEC',t) = sum(p$ELEC_TECH(p), InputAnnualByProcess.L(r,p,CommodityEnergy,t));
EnergyBySector(r,CommodityEnergy,'INDU',t) = sum(p$INDU_TECH(p), InputAnnualByProcess.L(r,p,CommodityEnergy,t));
EnergyBySector(r,CommodityEnergy,'REFI',t) = sum(p$REFI_TECH(p), InputAnnualByProcess.L(r,p,CommodityEnergy,t));
EnergyBySector(r,CommodityEnergy,'TRAN',t) = sum(p$TRAN_TECH(p), InputAnnualByProcess.L(r,p,CommodityEnergy,t));
EnergyBySector(r,CommodityEnergy,'XTRC',t) = sum(p$XTRC_TECH(p), InputAnnualByProcess.L(r,p,CommodityEnergy,t));
EnergyBySector(r,CommodityEnergy,'LAND',t) = sum(p$LUSE_TECH(p), InputAnnualByProcess.L(r,p,CommodityEnergy,t));
*EmissionBySector(r,e,'EXOG',t) = sum(EXOG_TECH, EmissionAnnualByProcess.L(r,e,EXOG_TECH,t);

* Final energy by commodity:
EnergyFinal(r,CommodityEnergy,t) = 
    EnergyBySector(r,CommodityEnergy,'BLDN',t) +
    EnergyBySector(r,CommodityEnergy,'CHEM',t) +
    EnergyBySector(r,CommodityEnergy,'INDU',t) +
    EnergyBySector(r,CommodityEnergy,'TRAN',t) +
    EnergyBySector(r,CommodityEnergy,'LAND',t);

* Final energy total:
EnergyFinalTotal(r,t) = sum(CommodityEnergy, EnergyFinal(r,CommodityEnergy,t));

EnergyPrimaryTotal(r,t) =  OutputAnnual.L(R,'COAL',t) +
                    OutputAnnual.L(R,'NGAS',t) +
                    OutputAnnual.L(R,'NGLs',t) +
                    OutputAnnual.L(R,'CRUD',t) +
                    OutputAnnual.L(R,'URAN',t) +
                    OutputAnnual.L(R,'BIOM',t) +
                    OutputAnnualByProcess.L(R,'ELEC_HydroRes','ELECGen',t) +
                    OutputAnnualByProcess.L(R,'ELEC_HydroRoR','ELECGen',t) +
                    OutputAnnualByProcess.L(R,'ELEC_Wnd1','ELECGen',t) +
                    OutputAnnualByProcess.L(R,'ELEC_SPV1','ELECGen',t)
;
