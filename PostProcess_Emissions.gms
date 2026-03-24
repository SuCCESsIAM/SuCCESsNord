

Parameters
    EmissionBySector(r,e,sector,t)
;

EmissionBySector(r,e,'BLDN',t) = sum(p$BLDN_TECH(p), EmissionAnnualByProcess.L(r,p,e,t));
EmissionBySector(r,e,'CHEM',t) = sum(p$CHEM_TECH(p), EmissionAnnualByProcess.L(r,p,e,t));
EmissionBySector(r,e,'ELEC',t) = sum(p$ELEC_TECH(p), EmissionAnnualByProcess.L(r,p,e,t));
EmissionBySector(r,e,'INDU',t) = sum(p$INDU_TECH(p), EmissionAnnualByProcess.L(r,p,e,t));
EmissionBySector(r,e,'REFI',t) = sum(p$REFI_TECH(p), EmissionAnnualByProcess.L(r,p,e,t));
EmissionBySector(r,e,'TRAN',t) = sum(p$TRAN_TECH(p), EmissionAnnualByProcess.L(r,p,e,t));
EmissionBySector(r,e,'BLDN',t) = sum(p$BLDN_TECH(p), EmissionAnnualByProcess.L(r,p,e,t));
EmissionBySector(r,e,'XTRC',t) = sum(p$XTRC_TECH(p), EmissionAnnualByProcess.L(r,p,e,t));
EmissionBySector(r,e,'LAND',t) = sum(p$LUSE_TECH(p), EmissionAnnualByProcess.L(r,p,e,t));
*EmissionBySector(r,e,'EXOG',t) = sum(EXOG_TECH, EmissionAnnualByProcess.L(r,e,EXOG_TECH,t);




