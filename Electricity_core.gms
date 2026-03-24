

*************************************************************************************************
*
*   Variables
*

Positive Variables
    ELEC_Demand(R,T,rp,hour)                            Hourly electricity demand (PJ per h)
    ELEC_Generation(T,rp,h,R,p)                         Hourly electricity generation (PJ per h)
    ELEC_STORAGE_stored(T,rp,h,R,ELEC_p_storage)        Storages' end-of-period stored energy
    ELEC_STORAGE_charge(T,rp,h,R,ELEC_p_storage)        Storages' hourly charging into storage
    ELEC_STORAGE_discharge(T,rp,h,R,ELEC_p_storage)     Storages' hourly discharging
    ELEC_Exports(t,rp,h,r,rr)                           'Exports from the first to the second region (PJ per h)'
;



*************************************************************************************************
*
*   Equations
*

Equations
    EQ_ELEC_Balance(R,T,rp,h)
    EQ_ELEC_Demand(R,T,rp,hour)
    EQ_ELEC_Max_Gen_Disp(R,T,rp,h,ELEC_p_disp)
    EQ_ELEC_Max_Gen_VRE(R,T,rp,h,ELEC_p_VRE,ELEC_VRE_type)
    EQ_ELEC_HydroGeneration(t,rp,h,r,P)

    EQ_ELEC_Storage_max_charge(T,rp,h,R,ELEC_p_storage)
    EQ_ELEC_Storage_balance(T,rp,h,R,P)
    EQ_ELEC_Storage_balance_loop(t,rp,h,R,P)
    EQ_ELEC_Storage_charge_maxrate(T,rp,h,R,P)
    EQ_ELEC_Storage_discharge_maxrate(T,rp,h,R,P)
    EQ_ELEC_Storage_cost(R,ELEC_p_storage,T)

    EQ_ELEC_Generation_Yearly(R,ELEC_p_gen,T)
;

*****************************************
* Supply-demand balance

EQ_ELEC_Balance(R,T,rp,h)..
    ELEC_Demand(R,T,rp,h)
        =E=
* Generation:
            sum(ELEC_p_gen, ELEC_Generation(T,rp,h,R,ELEC_p_gen))
* Storage charging and discharging:
            - sum(ELEC_p_storage, ELEC_STORAGE_charge(t,rp,h,r,ELEC_p_storage))
            + sum(ELEC_p_storage, ELEC_STORAGE_discharge(t,rp,h,r,ELEC_p_storage))
* Trade:
            - sum(rr, ELEC_Exports(t,rp,h,r,rr))
            + sum(rr, ELEC_Exports(t,rp,h,rr,r))
;


*****************************************
* Linking between hourly and annual levels

* Demand from the annual level: (note: as inequalty to avoid numerical problems while solving)
EQ_ELEC_Demand(R,T,rp,hour)..
        ELEC_Demand(R,T,rp,hour) =E= ELEC_DemandVariation(rp,hour,r) * InputAnnualByProcess(R,'ELEC_DistributionGrid','ELECGen',T) / 8760
;

* Generation at hourly level (elecctricity module) and annual level (SuCCESs-level) must be the same
EQ_ELEC_Generation_Yearly(R,ELEC_p_gen,T)..
    8760/card(hour) * sum((rp, h), ReprPeriodWeight(rp) * ELEC_Generation(T,rp,h,R,ELEC_p_gen) ) =E=  OutputAnnualByProcess(R,ELEC_p_gen,'ELECGen',T)
;



*****************************************
* Generation

*  Dispatchable generation max bound
EQ_ELEC_Max_Gen_Disp(R,T,rp,h,ELEC_p_disp)..
        ELEC_Generation(T,rp,h,R,ELEC_p_disp) =L= CapacityTotal(R,ELEC_p_disp,T)/8760
;

* VRE generation max bound:
* The hourly variation is from data_ELEC_VRE_CF, multiplied with the relative change in CapacityFactor since 2020.
* Note: this can lead to capacity factor being >1 for some hours, which implies that capacity is actually a bit higher than indicated by the capacity variable.
EQ_ELEC_Max_Gen_VRE(R,T,rp,h,ELEC_p_VRE, ELEC_VRE_type)$ELEC_VRE_process_type(ELEC_p_VRE,ELEC_VRE_type)..
        ELEC_Generation(T,rp,h,R,ELEC_p_VRE) =L=  CapacityTotal(R,ELEC_p_VRE,T)/8760 * CapacityToActivityUnit(r,ELEC_p_VRE)
                                            * CapacityFactor(r,ELEC_p_VRE,'ANNUAL',t) / CapacityFactor(r,ELEC_p_VRE,'ANNUAL','2020') 
                                            * data_ELEC_VRE_CF(rp,h,r,ELEC_VRE_type)
;


* Hydropower (reservoir) flexibility over time:
*scalar HydroTimeframe   / 168 /;
*EQ_ELEC_HydroGeneration(t,rp,h,r,ELEC_p_hydr)$(mod(ord(h)-1,HydroTimeframe) = 0)..
*    sum(hour$((ord(hour) >= ord(h)) and (ord(hour) < ord(h)+HydroTimeframe)),
*        ELEC_Generation(t,rp,hour,R,ELEC_p_hydr)) =L= HydroTimeframe*AvailabilityFactor(r,ELEC_p_hydr,t)*CapacityTotal(R,ELEC_p_hydr,T);
*;
EQ_ELEC_HydroGeneration(t,rp,h,r,ELEC_p_hydr)..
ELEC_Generation(t,rp,h,R,ELEC_p_hydr) =L= AvailabilityFactor(r,ELEC_p_hydr,t)*CapacityTotal(R,ELEC_p_hydr,T)/8760;
;

******************************************
* Storages
*

* Storage maximum charge:
EQ_ELEC_Storage_max_charge(T,rp,h,R,ELEC_p_storage)..
    ELEC_STORAGE_stored(t,rp,h,R,ELEC_p_storage) =L= CapacityTotal(R,ELEC_p_storage,T)
;


* Storage balance:
* TODO: add step h length to decay and charge/discharge
EQ_ELEC_Storage_balance(T,rp,h,R,ELEC_p_storage)$( ORD(h) ge 2 )..
    ELEC_STORAGE_stored(T,rp,h,R,ELEC_p_storage)
    =E= ELEC_STORAGE_decay(T,R,ELEC_p_storage) * ELEC_STORAGE_stored(T,rp,h-1,R,ELEC_p_storage)
        + ELEC_STORAGE_eff(T,R,ELEC_p_storage) * ELEC_STORAGE_charge(T,rp,h,R,ELEC_p_storage)
        - ELEC_STORAGE_discharge(T,rp,h,R,ELEC_p_storage)
;

* Storage balance (end-to-start looping):
* Note: apply only if the hourly dimension is long (more than four weeks = 672 hours).
* TODO: add step h length to decay and charge/discharge
* TODO: add scalar for h length, default = 1, command line override
EQ_ELEC_Storage_balance_loop(T,rp,hfirst,R,ELEC_p_storage)$(card(h) > 672)..
    ELEC_STORAGE_stored(T,rp,hfirst,R,ELEC_p_storage)
    =E= ELEC_STORAGE_decay(T,R,ELEC_p_storage) * sum(hlast, ELEC_STORAGE_stored(T,rp,hlast,R,ELEC_p_storage))
        + ELEC_STORAGE_eff(T,R,ELEC_p_storage) * ELEC_STORAGE_charge(T,rp,hfirst,R,ELEC_p_storage)
        - ELEC_STORAGE_discharge(T,rp,hfirst,R,ELEC_p_storage)
;

* Storage (dis)charge limits
EQ_ELEC_Storage_charge_maxrate(T,rp,h,R,ELEC_p_storage)..
    ELEC_STORAGE_charge(T,rp,h,R,ELEC_p_storage)
    =L= ELEC_STORAGE_charge_maxrate(T,R,ELEC_p_storage) * CapacityTotal(R,ELEC_p_storage,T)
;

EQ_ELEC_Storage_discharge_maxrate(T,rp,h,R,ELEC_p_storage)..
    ELEC_STORAGE_discharge(T,rp,h,R,ELEC_p_storage)
    =L= ELEC_STORAGE_discharge_maxrate(T,R,ELEC_p_storage) * CapacityTotal(R,ELEC_p_storage,T)
;

EQ_ELEC_Storage_cost(R,ELEC_p_storage,T)..
    ActivityAnnual(R,ELEC_p_storage,T) =E= 8760/card(hour) * sum((rp, h), ReprPeriodWeight(rp) * ELEC_STORAGE_discharge(T,rp,h,R,ELEC_p_storage) )
;


* Transmission max bounds (first set all to zero, then set the upper bounds for links that exist):
ELEC_Exports.UP(t,rp,h,r,rr) = 0;
ELEC_Exports.UP(t,rp,h,r,rr)$ELEC_TransmissionCapacity(r,rr) = ELEC_TransmissionCapacity(r,rr);
ELEC_Exports.UP(t,rp,h,r,rr)$ELEC_TransmissionCapacity(rr,r) = ELEC_TransmissionCapacity(rr,r);
