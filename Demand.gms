***************************************************************************************************
*
*   Demand
*

table data_demand(r,c,t)
                              2020      2030      2040      2050      2060      2070      2080      2090      2100
World . Steel                 1817      2280      2696      3053      3346      3580      3764      3905      4012
World . Cement                4050      5463      6387      7001      7413      7701      7891      8018      8102
World . Aluminium              63.7      89.8      116       140       161       178.5     192.6     203.8     212.4
World . Copper                 23.3      29        34.1      38.4      42        44.8      47        48.7      50
World . Nickel                  2.5       3.1       3.7       4.1       4.5       4.8       5         5.2       5.4
World . Paper                 116.4      98.2      86.7      79.1      73.9      70.3      67.8      65.9      64.6
World . Board                 241       276.9     306.9     331       350.1     364.9     376.1     384.7     391.1
World . Tissue                 51        55.9      59.8      62.9      65.2      67        68.4      69.4      70.2
World . WoodLogs              780       870       945      1005      1052      1090      1118      1140      1157
World . ThermoPlst            222.2     328.9     442       552.2     652.8     740.3     813.6     873.4     921.2
World . ThermoSets            107.2     158.7     213.3     266.4     314.9     357.1     392.5     421.4     444.4
World . SolventsEtc           107.3     158.8     213.5     266.6     315.2     357.5     392.9     421.8     444.8
World . OtherPetro            108.9     161.2     216.6     270.6     319.9     362.8     398.7     428.1     451.5
World . NitroFertil           274.7     406.6     546.5     682.6     807       915.2    1005.8    1079.8    1138.8
World . OthChemDmd            820.3    1214.2    1631.8    2038.5    2409.8    2732.8    3003.6    3224.4    3400.7
World . OtherIndOil          7652      7652      7277      6664      5935      5175      4443      3771      3172
World . OtherIndGas         12336     12336     11731     10744      9567      8343      7163      6079      5114
World . OtherIndSolid       12193     12193     11595     10619      9456      8247      7080      6008      5055
World . OtherIndElec        20851     32068     41909     51125     59360     66470     72458     77410     81452
World . OtherIndStea         1703      2076      2406      2687      2916      3100      3245      3356      3442
World . PassengerCarsPkm    33613650 37477107  43040553  48604000  53866161  58638129  64830745  69430992  76178887
World . PassengerBusPkm     14386594 17172809  24636074  32099338  35574606  38726137  42815900  45854023  50310507
World . PassengerRailPkm    4119000  5128884   5913670   6760631   7492578   8156340   9017709   9657586   10596193
World . PassengerDomAviPkm  3165500  3821000   4911000   6001000   6650704   7239886   8004471   8572451   9405594
World . PassengerIntAviPkm  5846000  7203000   11381000  15559000  17243511  18771102  20753468  22226089  24386209
World . FreightRoadTkm      21485000 25289000  33176000  41063000  45890615  50883165  56092835  61241371  67167841
World . FreightRailTkm      10842000 13949000  20491500  27034000  30212281  33499147  36928956  40318516  44220233
World . FreightWaterTkm     97946000 124668000 174046500 223425000 249692195 276856809 305202778 333216113 365462213
World . BLDN_ELEC             47447     59419     72582     84495     94821    104202    112950    121285    129362
World . BLDN_LIQUID           12800      9024      5788      4361      3046      2128      1486      1038       725
World . BLDN_GASES            32200     24118     17228     12587      9444      7086      5317      3989      2993
World . BLDN_SOLID            32100     22806     17430     12974      9523      6991      5132      3767      2765
World . BLDN_HEAT              6700     10508     12307     13055     13615     13771     13656     13365     12964
World . TRAD_BIOM             28322     26171     22467     18018     13089      8091      2702      EPS       EPS
World . FoodCrops              2991      3336      3649      4002      4293      4526      4674      4733      4714
World . FoodBeef               67.9      73.8      76.4      75.5      70.7      64.1      56.2      47.5      46
World . FoodShoat              16        17.4      18        17.8      16.7      15.1      13.2      11.2      10.8
World . FoodPork              109.8     119.7     123.9     119.6     111.4     102.5      93.5      84.2      77.5
World . FoodPoultry           119.5     149.6     176.2     198.8     213.2     226.1     233.1     234.9     224.2
World . FoodMilk              886.9    1020.8    1117.3    1165.9    1166.4    1154.7    1121.1    1070      1015.1
World . FoodEggs               86.7      99.8     109.2     114       114       112.9     109.6     104.6      99.2
;


DemandSpecifiedAnnual(r,c,t)$data_demand(r,c,t) = data_demand(r,c,t);

* Annual fraction of energy-service or commodity demand that is required in each time slice.
* For each year, all the defined SpecifiedDemandProfile input values should sum up to 1.
DemandSpecifiedProfile(r,c,'ANNUAL',t)$data_demand(r,c,t) = 1;



****************************************************************************************************
**
**   Tansportation Demand
**   Source: ITF Transportation Outlook 2021 until 2050, SSP2 growth onwards
**
*
** Passenger transportation demand (mln. p-km/year)
*table data_demand(time,commodity)
*        PassengerCarsPkm    PassengerBusPkm     PassengerRailPkm    PassengerDomAviPkm  PassengerIntAviPkm
*2020    33613650            14386594            4119000             3165500             5846000 
*2030    37477107            17172809            5128884             3821000             7203000 
*2040    43040553            24636074            5913670             4911000             11381000
*2050    48604000            32099338            6760631             6001000             15559000
*2060    53866161            35574606            7492578             6650704             17243511
*2070    58638129            38726137            8156340             7239886             18771102
*2080    64830745            42815900            9017709             8004471             20753468
*2090    69430992            45854023            9657586             8572451             22226089
*2100    76178887            50310507            10596193            9405594             24386209
*;                                                                                            
*
** Freight transportation demand (mln. t-km/year)
*table data_demand(time,commodity)
*          FreightRoadTkm    FreightRailTkm  FreightWaterTkm
*2020      21485000          10842000        97946000      
*2030      25289000          13949000        124668000     
*2040      33176000          20491500        174046500     
*2050      41063000          27034000        223425000     
*2060      45890615          30212281        249692195     
*2070      50883165          33499147        276856809     
*2080      56092835          36928956        305202778     
*2090      61241371          40318516        333216113     
*2100      67167841          44220233        365462213     
*;                                                                    
*
*
****************************************************************************************************
**
**   Chemical sector demand
**
*
*table data_demand(time,commodity)
*        ThermoPlst  ThermoSets   SolventsEtc    OtherPetro   NitroFertil    OthChemDmd 
*2020      222.2       107.2         107.3         108.9         274.7          820.3                   
*2030      328.9       158.7         158.8         161.2         406.6         1214.2  
*2040      442.0       213.3         213.5         216.6         546.5         1631.8  
*2050      552.2       266.4         266.6         270.6         682.6         2038.5  
*2060      652.8       314.9         315.2         319.9         807.0         2409.8  
*2070      740.3       357.1         357.5         362.8         915.2         2732.8  
*2080      813.6       392.5         392.9         398.7        1005.8         3003.6  
*2090      873.4       421.4         421.8         428.1        1079.8         3224.4  
*2100      921.2       444.4         444.8         451.5        1138.8         3400.7  
*;
*
*
****************************************************************************************************
**
**   Industrial production demand
**
*
*table data_demand(time,commodity)
*        Steel  Aluminium   Cement  Copper  Nickel
*2020    1817      63.7      4050    23.3     2.5  
*2030    2280      89.8      5463    29.0     3.1  
*2040    2696     116.0      6387    34.1     3.7  
*2050    3053     140.0      7001    38.4     4.1  
*2060    3346     161.0      7413    42.0     4.5  
*2070    3580     178.5      7701    44.8     4.8  
*2080    3764     192.6      7891    47.0     5.0  
*2090    3905     203.8      8018    48.7     5.2  
*2100    4012     212.4      8102    50.0     5.4  
*;
*
*
*table data_demand(time,commodity)
*        Paper      Board      Tissue
*2020    116.4      241.0      51.0
*2030     98.2      276.9      55.9
*2040     86.7      306.9      59.8
*2050     79.1      331.0      62.9
*2060     73.9      350.1      65.2
*2070     70.3      364.9      67.0
*2080     67.8      376.1      68.4
*2090     65.9      384.7      69.4
*2100     64.6      391.1      70.2
*;
*
** Direct energy consumption for other industrial sectors
*table data_demand(time,commodity)
*          OtherIndOil     OtherIndGas   OtherIndSolid   OtherIndElec  OtherIndStea
*2020          7652          12336           12193           20851       1703
*2030          7652          12336           12193           32068       2076
*2040          7277          11731           11595           41909       2406
*2050          6664          10744           10619           51125       2687
*2060          5935          9567            9456            59360       2916
*2070          5175          8343            8247            66470       3100
*2080          4443          7163            7080            72458       3245
*2090          3771          6079            6008            77410       3356
*2100          3172          5114            5055            81452       3442
*;
*
*
****************************************************************************************************
**
**   Buildings energy demand
**
*
*table data_demand(time,commodity)
*          BLDN_ELEC    BLDN_LIQUID   BLDN_GASES     BLDN_SOLID    BLDN_HEAT
*2020       47447           12800        32200         32100         6700  
*2030       59419           9024         24118         22806         10508 
*2040       72582           5788         17228         17430         12307  
*2050       84495           4361         12587         12974         13055  
*2060       94821           3046         9444          9523          13615  
*2070       104202          2128         7086          6991          13771  
*2080       112950          1486         5317          5132          13656  
*2090       121285          1038         3989          3767          13365 
*2100       129362          725          2993          2765          12964 
*;
*
*
*table data_demand(time,commodity)
*          TRAD_BIOM
*2020       28322  
*2030       26171  
*2040       22467  
*2050       18018  
*2060       13089  
*2070       8091   
*2080       2702   
*2090       0      
*2100       0      
*;
*
*
*
*************************************************************
** Agricultural and forestry demand (Mt DM/year):
** 2020 from FAO, scenarios by scaling each 2020 demand with MESSAGE/MAgPIE SSP2 scenario
*
*table data_demand(time,commodity)
*        FoodCrops    FoodBeef     FoodShoat     FoodPork     FoodPoultry    FoodMilk    FoodEggs     WoodLogs
*2020    2991          67.9          16.0         109.8          119.5         886.9       86.7          780  
*2030    3336          73.8          17.4         119.7          149.6         1020.8      99.8          870  
*2040    3649          76.4          18.0         123.9          176.2         1117.3      109.2         945  
*2050    4002          75.5          17.8         119.6          198.8         1165.9      114.0        1005  
*2060    4293          70.7          16.7         111.4          213.2         1166.4      114.0        1052  
*2070    4526          64.1          15.1         102.5          226.1         1154.7      112.9        1090  
*2080    4674          56.2          13.2         93.5           233.1         1121.1      109.6        1118  
*2090    4733          47.5          11.2         84.2           234.9         1070.0      104.6        1140  
*2100    4714          46.0          10.8         77.5           224.2         1015.1      99.2         1157  
*;
*
*
****************************************************************************************************
**
**   Assign input data to OSEMOSYS parameters 
**
*
** Total specified demand for the year, linked to a specific time of use during the year.
*DemandSpecifiedAnnual('World',c,t)$data_demand(t,c) = data_demand(t,c);
**
** Annual fraction of energy-service or commodity demand that is required in each time slice.
** For each year, all the defined SpecifiedDemandProfile input values should sum up to 1.
*DemandSpecifiedProfile('World',c,'ANNUAL',t)$data_demand(t,c) = 1;
*



***************************************************************************************************
*
*   Unused parameters / other 
*


* Accumulated Demand for a certain commodity in one specific year.
* It cannot be defined for a commodity if its SpecifiedAnnualDemand for the same year is already defined and vice versa.
DemandAccumulatedAnnual(r,c,t) = NO;


