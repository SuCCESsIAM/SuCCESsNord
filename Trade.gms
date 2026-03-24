
* Traded commodities (subset of C -> note: order needs to be the same as with C)
set COMMODITY_Traded(C) 'Set of traded commodities' /
* energy carriers:
*                    COAL, NGAS, NGLs, Ethane, CRUD, LPGs, GSLN, OILL, OILH, URAN, BIOM, BIOG, BGSL, BIOL, WSTE, HYDR, ELECGen, ELEC, HEAT, STEA,
                    COAL, NGAS, CRUD, GSLN, URAN, BIOM, 
* captured CO2:
*                    CO2_CCS,
* intermediate materials and chemical commodities:
                    PulpWood,
*                    Pulp_mech, Pulp_chem, Pulp_recy, 
*                    Alumina, 
*                    ETHYLENE, PROPYLENE, C4OLEFINS, BTX, AMMONIA, METHANOL, OTHERCHEM,
*                    BiomassCrop, BiomassAgriResid, BiomassForResid,
* Recycled material scrap commodities:
*                    ScrapSteel, ScrapAluminium, ScrapCopper, ScrapNickel,
                    ScrapPaper,
** Industrial production demand commodities:
*                  Steel, Cement, Aluminium, Copper, Nickel,
*                  Paper, Board, Tissue,
                  WoodLogs,
** Chemical industry demand commodities:
*                  ThermoPlst, ThermoSets, SolventsEtc, OtherPetro, NitroFertil, OthChemDmd,
** Other industry energy demand:
*                  OtherIndOil, OtherIndGas, OtherIndSolid, OtherIndElec, OtherIndStea,
** Transportation demand commodities:                    
*                  PassengerCarsPkm, PassengerBusPkm, PassengerRailPkm, PassengerDomAviPkm, PassengerIntAviPkm,
*                  FreightRoadTkm, FreightRailTkm, FreightWaterTkm
*,
* Buildings demand commodities:
*                  BLDN_ELEC, BLDN_LIQUID, BLDN_GASES, BLDN_SOLID, BLDN_HEAT, TRAD_BIOM,
* Food demand commodities:
                 FoodCrops, FoodBeef, FoodShoat, FoodPork, FoodPoultry, FoodMilk, FoodEggs
/;


TradeRoute('World',r,COMMODITY_Traded,t) = YES;
TradeRoute(r,'World',COMMODITY_Traded,t) = YES;

TradeRoute('NOR',r,'CRUD',t) = YES;
TradeRoute('NOR',r,'NGAS',t) = YES;
TradeRoute('NOR',r,'GSLN',t) = YES;


*******************************************************************************************
*
* Trade costs (both as a transaction costs and to enforce regional cost differences)
*

Parameter data_TRDE_ImportCost(r, COMMODITY_Traded);

data_TRDE_ImportCost(Region_Nord, 'COAL') = 2;
data_TRDE_ImportCost(Region_Nord, 'NGAS') = 8;
*data_TRDE_ImportCost(Region_Nord, 'CRUD') = ;
*data_TRDE_ImportCost(Region_Nord, 'GSLN') = ;


* Add small cost to avoid unnecessary trade:
set     PROCESS / TRDE_CostAccounting /;
set TRDE_TECH(P)/ TRDE_CostAccounting /;

Parameter data_TRDE_lifetime(P)         /  TRDE_CostAccounting      1000           /;
Parameter data_TRDE_varcost(P)          /  TRDE_CostAccounting       0.1           /;
Parameter data_TRDE_availability(P)     /  TRDE_CostAccounting       1             /;
Parameter data_TRDE_capacityfactor_p(P) /  TRDE_CostAccounting       1             /;

* Small default cost, is overrided by commodity (i.e. by mode):
VariableCost(r,'TRDE_CostAccounting',m,t)$data_ELEC_varcost('TRDE_CostAccounting') = 0.1;

* Commodity- and region-specific import cost, assigned for each mode:
loop(COMMODITY_Traded,
    VariableCost(r,'TRDE_CostAccounting',m,t)$(data_TRDE_ImportCost(r,COMMODITY_Traded) and ord(m) = ord(COMMODITY_Traded)) = data_TRDE_ImportCost(r,COMMODITY_Traded);
);

OperationalLife(r,'TRDE_CostAccounting') = 1000;
AvailabilityFactor(r,'TRDE_CostAccounting',t) = 1;
CapacityFactor(r,'TRDE_CostAccounting',l,t) = 1;
CapacityToActivityUnit(r,'TRDE_CostAccounting') = 1;

Equations
    EQ_TRDE_CostAccounting(r,m,t)
;

* Import costs for each region:
* TradeAnnual is symmetric between r and rr: positive is r trading to rr, negative is rr trading to r.
* 
EQ_TRDE_CostAccounting(r,m,t)..  ActivityAnnualByMode(r,'TRDE_CostAccounting',m,t) =G= sum((rr,COMMODITY_Traded)$(ord(COMMODITY_Traded) = ord(m)), TradeAnnual(rr,r,COMMODITY_Traded,t))

