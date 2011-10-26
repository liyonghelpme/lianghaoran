const buildcontext = [9000,2001,2002,2003,2004,3005,3006,
2100,2101,2102,2103,2104,2105,2106,2107,2108,2109,2110,2111,2112,2113,2114,2115,2116,2117,2118,2119,2120,2121,2122,2123,2124,2125,2126,2127,2128,2129,2130,2131,2132,2133,2134,2135,3136,3137,3138,3139,3140,3141,3142,3143,3144,3145,3146,3147,3148,3149,3150,3151,3152,3153,3154,3155,3156,3157,3158,3159,2160,2161,2162,2163,2164,2165,2166,2167,2168,2169,2170,2171,3172,3173,3174,3175,3176,3177,
2200,2201,2202,2203,2204,2205,2206,2207,2208,
2300,2301,2302,2303,2304,2305,2306,2307,2308,2309,2310,2311,2312,2313,2314,2315,2316,2317,2318,2319,2320,2321,2322,2323,2324,2325,2326,3327,3328,3329,
2400,2401,2402,2403,2404,2405,2406,2407,2408,2409,2410,2411,2412,2413,2414,2415,2416,2417,2418,2419,2420,2421,2422,2423,2424,
//todo
1500,1501,1502,1503,1504,1505,1506,1507,1508,1509,1510,1511,1512,1513,1514,1515,1516,1517,1518,1519,1520,1521,1522,1523,1524,1525,1526,1527,1528,1529,1530,1531,1532,1533,1534,1535,1536,1537,1538,2539,2540,2541,
2600,2601];
const darkColorAlpha = 65;
const AutoPop = 1;
const NonAutoPop = 0;
const NotAdd = 2;

const allcardlevelnum = [[2,4,7,15,30],[1000,5000,20000,50000,100000],[10000,50000,100000,500000,1000000]];
//const BASE_URL = "http://223.4.87.9:8000/";
const BASE_URL = "http://uhz000738.chinaw3.com:8080/";

const NEWDATA = [[1000,1,200,370,590,0,60],[1450,2,220,370,590,6,60],[2550,5,190,370,600,26,60]];

const FARM_PRICE = [0,1000,-10,-15,-20,10000,28500];
//const FARM_SALE = [0,375,750,1125,1500,2500,7125];
const FARM_PERSON = [0,80,0,0,0,120,250];
const FARM_EXP = [0,5,15,40,70,20,30];
const FARM_FOOD = [0,0,0,0,0,600,1000];
const FARM_USE = [0,"种植粮食","种植粮食（x1.2）","种植粮食（x1.4）","种植粮食（x1.6）","采集木材","采集石材"];

const PLANT_TIME = [600,2700,3600,9360,22680,14400,1800,5400,9000,11520,29160,25200];
const PLANT_PRICE = [50,165,-1,700,1440,-3,230,600,-2,1210,3000,-5];
const PLANT_EXP = [1,3,8,7,12,25,5,9,30,15,25,50];
const PLANT_FOOD = [20,50,120,150,300,430,52,80,280,200,410,650];

const STONE_TIME = [4320,21600,6480,5400,25200,9000];
const WOOD_TIME = [4320,21600,6480,5400,25200,9000];
const STONE_PRICE = [1200,3600,-5,2000,5500,-10];
const WOOD_PRICE = [600,1850,-4,1000,2500,-8];
const STONE_EXP = [10,20,30,15,25,65];
const WOOD_EXP = [5,15,20,10,20,50];
const STONE_GAIN =[20,50,70,40,80,120];
const WOOD_GAIN = [20,50,70,40,80,120];

const ROOM_B_TIME = [600,1200,2400,600,1200,2400,600,1200,2400,600,1200,2400,1800,4320,9000,1800,4320,9000,1800,4320,9000,1800,4320,9000,15840,24480,30600,15840,24480,30600,15840,24480,30600,15840,24480,30600,5400,11160,21240,5400,11160,21240,5400,11160,21240,5400,11160,21240,25200,36720,68040,25200,36720,68040,25200,36720,68040,25200,36720,68040,7560,15480,30600,7560,15480,30600,7560,15480,30600,7560,15480,30600,12240,19800,28800,12240,19800,28800];
const ROOM_B_FOOD = [10,30,-70,10,30,-70,10,30,-70,10,30,-70,60,120,-100,60,120,-100,60,120,-100,60,120,-100,400,-150,-100150,400,-150,-100150,400,-150,-100150,400,-150,-100150,200,-120,-100120,200,-120,-100120,200,-120,-100120,200,-120,-100120,600,-200,-100200,600,-200,-100200,600,-200,-100200,600,-200,-100200,0,-300,-100300,0,-300,-100300,0,-300,-100300,0,-300,-100300,0,-310,-100310,0,-310,-100310];
const ROOM_B_EXP = [3,8,15,3,8,15,3,8,15,3,8,15,5,13,24,5,13,24,5,13,24,5,13,24,13,21,30,13,21,30,13,21,30,13,21,30,11,25,39,11,25,39,11,25,39,11,25,39,20,32,43,20,32,43,20,32,43,20,32,43,15,25,40,15,25,40,15,25,40,15,25,40,20,30,50,20,30,50];
const ROOM_PRICE = [500,1400,2800,550,1540,3080,600,1680,3360,650,1820,3640,1500,4800,9000,1650,5280,9900,1800,5760,10800,1950,6240,11700,7300,15000,19000,8030,16500,20900,8760,18000,22800,9490,19500,24700,3500,6600,11000,3850,7260,12100,4200,7920,13200,4550,8580,14300,10500,15500,19500,11550,17050,21450,12600,18600,23400,13650,20150,25350,-10,20000,25000,-11,22000,27500,-12,24000,30000,-13,26000,32500,-8,22000,26000,-9,24200,28600];
const ROOM_TIME = [1800,1800,1800,1800,1800,1800,1800,1800,1800,1800,1800,1800,7560,7560,7560,7560,7560,7560,7560,7560,7560,7560,7560,7560,18720,18720,18720,18720,18720,18720,18720,18720,18720,18720,18720,18720,12600,12600,12600,12600,12600,12600,12600,12600,12600,12600,12600,12600,29880,29880,29880,29880,29880,29880,29880,29880,29880,29880,29880,29880,14400,14400,14400,14400,14400,14400,14400,14400,14400,14400,14400,14400,21600,21600,21600,21600,21600,21600];
const ROOM_FOOD = [20,30,40,20,30,40,20,30,40,20,30,40,64,86,110,64,86,110,64,86,110,64,86,110,140,174,200,140,174,200,140,174,200,140,174,200,90,116,142,90,116,142,90,116,142,90,116,142,190,230,270,190,230,270,190,230,270,190,230,270,150,225,300,150,225,300,150,225,300,150,225,300,170,245,339,170,245,339];
const ROOM_PERSON = [10,15,20,10,15,20,10,15,20,10,15,20,32,43,55,32,43,55,32,43,55,32,43,55,70,83,100,70,83,100,70,83,100,70,83,100,50,62,75,50,62,75,50,62,75,50,62,75,95,115,135,95,115,135,95,115,135,95,115,135,100,150,200,100,150,200,100,150,200,100,150,200,110,165,230,110,165,230];
const ROOM_EXP = [1,2,5,1,2,5,1,2,5,1,2,5,3,7,11,3,7,11,3,7,11,3,7,11,7,14,21,7,14,21,7,14,21,7,14,21,6,10,17,6,10,17,6,10,17,6,10,17,12,24,36,12,24,36,12,24,36,12,24,36,15,25,35,15,25,35,15,25,35,15,25,35,17,26,39,17,26,39];
const ROOM_UP = [0,"1;a,1","2;a,2;b,3",0,"1;a,1","2;a,2;b,3",0,"1;a,1","2;a,2;b,3",0,"1;a,1","2;a,2;b,3",0,"3;b,2;c,2","4;c,2;d,3",0,"3;b,2;c,2","4;c,2;d,3",0,"3;b,2;c,2","4;c,2;d,3",0,"3;b,2;c,2","4;c,2;d,3",0,"4;f,2;g,2","5;g,2;h,3",0,"4;f,2;g,2","5;g,2;h,3",0,"4;f,2;g,2","5;g,2;h,3",0,"4;f,2;g,2","5;g,2;h,3",0,"5;d,2;e,2","6;e,2;f,3",0,"5;d,2;e,2","6;e,2;f,3",0,"5;d,2;e,2","6;e,2;f,3",0,"5;d,2;e,2","6;e,2;f,3",0,"7;h,2;i,2","8;i,2;j,3",0,"7;h,2;i,2","8;i,2;j,3",0,"7;h,2;i,2","8;i,2;j,3",0,"7;h,2;i,2","8;i,2;j,3",0,"12;b,2;c,2","15;c,2;d,3",0,"12;b,2;c,2","15;c,2;d,3",0,"12;b,2;c,2","15;c,2;d,3",0,"12;b,2;c,2","15;c,2;d,3",0,"15;a,2;f,2","20;d,2;i,4",0,"15;a,2;f,2","20;d,2;i,4"];

const FACT_B_TIME = [600,1800,3600,3600,10440,15120,5400,14400,23400,19800,35280,46800,8280,22320,28800,20520,25200,33120,21600,28800,36720,30600,37440,46800,25200,30240,39600,16200,28800,41400];
const FACT_PRICE = [300,500,1100,1200,1800,3000,-5,5000,7000,2000,3300,4500,5000,7000,13500,-8,9000,11000,7200,11000,19900,8000,13000,21000,-11,13000,17000,10000,20000,50000];
const FACT_GAIN = [100,300,500,600,900,1200,800,1400,2100,1200,1800,2600,2300,3200,4500,2500,4400,6800,1400,2100,3100,3500,6500,8000,7500,13000,17500,1800,2600,4400];
const FACT_FOOD = [20,30,-70,45,-100,-100100,0,-120,-100120,80,-150,-100150,100,-170,-100170,0,-200,-100200,130,-210,-100210,170,-230,-100230,0,-250,-100250,1000,-300,-100300];
const FACT_B_EXP = [3,7,11,5,9,14,15,20,25,7,9,11,9,11,13,25,30,35,20,33,45,29,45,61,35,45,60,8,15,25];
const FACT_EXP = [1,2,5,3,5,9,5,9,15,5,9,17,12,20,29,18,28,40,10,19,30,23,34,45,30,50,70,4,8,12];
const FACT_TIME = [600,600,600,5400,5400,5400,1800,1800,1800,10440,10440,10440,21600,21600,21600,7200,7200,7200,11160,11160,11160,30600,30600,30600,26280,26280,26280,16200,16200,16200];
const FACT_PERSON = [20,25,35,40,50,65,0,0,0,50,65,85,70,90,115,0,0,0,90,115,145,110,140,175,0,0,0,55,73,100];
const FACT_UP = [0,"1;a,1","2;a,2;b,3",0,"3;b,2;c,2","4;c,2;d,3",0,"6;b,2;c,2","7;c,2;d,3",0,"5;d,2;e,2","6;e,2;f,3",0,"7;f,2;g,2","8;g,2;h,3",0,"10;d,2;e,2","11;e,2;f,3",0,"9;h,2;i,2","10;i,2;j,3",0,"10;j,2;k,2","11;k,2;l,3",0,"12;h,2;i,2","13;i,2;j,3",0,"7;a,5;i,4","10;c,5;d,6"];

const GOD_B_TIME = [7200,21600,43200,64800,86400];
//const GOD_SALE = [2500,7500,20000,45000,170000];
const GOD_B_PRICE = [10000,20000,50000,100000,500000];
const GOD_UP = [0,"5","10","15","30"];
const GOD_FOOD = [500,1000,2000,5000,10000];
const GOD_PERSON_MAX = [250,500,750,1000,1250];
const GOD_EXP = [50,100,170,250,350];

const BLESS_CAESARS = [3,15,30];

const CAMP_PRICE = [4000,9000,20000,12000,25000,50000,6000,12000,25000];
//const CAMP_SALE = [1000,3250,8250,3000,9250,21750,1500,4500,10750];
const CAMP_FOOD = [130,-200,-100200,320,-500,-100500,150,-300,-100300];
const CAMP_PERSON = [100,120,170,130,150,200,90,110,160];
const CAMP_EXP = [5,10,20,15,20,35,7,15,30];
const CAMP_TIME = [3600,11520,22680,7200,14760,28440,10800,21600,32400];
const CAMP_USE = ["训练步兵","训练骑兵","训练侦察兵"];
const CAMP_UP = [0,"5;a,3","10;b,3;c,4",0,"7;b,3","15;c,3;d,4",0,"3;c,3","7;d,3;e,4"];

const SOLDIER_TIME = [7200,21600,43200];
const SOLDIER_EXP = [5,8,13,9,15,21,16,25,34,10,15,20,30,40,50,60,75,90,3,6,9,5,8,13,9,15,21];
const SOLDIER_PRICE=[750,2400,4800,1600,5000,10000,2400,7500,15000,2000,6300,12600,2600,7900,15800,3300,10000,20000,150,500,1000,310,990,1980,480,1500,3000];
const SOLDIER_PERSON = [30,15,2];
const SOLDIER_FOOD = [3,6,9,10,20,30,5,10,15];
const SOLDIER_POWER = [1,2,3,4,5,6,0,0,0];
const SOLDIER_NAME = ["民兵","步兵","白银步兵","轻骑兵","重骑兵","黄金骑兵","普通侦察兵","中级侦察兵","高级侦察兵"];
const MONSTERNAME = ["普通蛇怪","中级蛇怪","高级蛇怪","普通野猪怪","中级野猪怪","高级野猪怪","普通狼怪","中级狼怪","高级狼怪","普通熊怪","中级熊怪","高级熊怪","普通狮子","中级狮子","高级狮子","普通恶龙","中级恶龙","高级恶龙","普通蛇王","中级蛇王","高级蛇王","普通野猪王","中级野猪王","高级野猪王","普通狼王","中级狼王","高级狼王","普通熊王","中级熊王","高级熊王","普通狮子王","中级狮子王","高级狮子王","普通恶龙王","中级恶龙王","高级恶龙王"];
const MONSTER_POWER = [20,30,41,25,37,49,28,42,56,33,49,65,40,58,77,50,75,100,42,65,90,51,74,104,60,90,120,73,109,145,80,120,160,100,150,200];

const EXPAND_LEVEL=[4,7,10,15,20,25,30,40,50,60];
const EXPAND_MONEY=[10000,50000,100000,500000,1000000,1500000,2000000,2500000,3000000,5000000];
const EXPAND_CAESARS=[1,3,5,7,10,15,20,27,37,50];
const EXPAND_FRIEND=[1,10,30,60,100,150,210,280,360,450];
const EXPAND_EXP=[10,20,50,90,140,200,330,580,740,920];


    
    const PETS_NAME=["初级龙蛋A","中级龙蛋A","高级龙蛋A","初级龙蛋B","中级龙蛋B","高级龙蛋B"];
    const PETS_PRICE=[50000,100000,500000,-10,-50,-100];
    const PETS_POWER = [100,250,1000,300,1200,1500];
    const PETS_UP = [5,6,10,7,12,17];
    
    const EXTEND_UP=[0,3,3];
    const EXTEND_NAME=["earth","fire","water"];
    const EXTEND_PETS_NAME=["土龙","火龙","水龙"];

const OBJ_PRICE = [10,20,30,50,-1,100,100,100,100,100,100,200,-3,400,600,800,1000,900,1200,2000,-5,1500,1500,1500,1600,1600,1600,1600,-3,-3,-3,-3,1800,1800,1800,2000,2000,2000,-10,5000,-5,-10];
const OBJ_PERSON = [5,5,5,5,50,6,6,6,6,6,6,8,170,15,20,25,30,35,40,50,300,60,60,60,65,65,65,65,150,150,150,150,70,70,70,80,80,80,300,90,150,300];

const STATUE_PRICE = [80000,-8];
const STATUE_DEFENCE=[600,700];
const STATUE_PERSON=[20,40];
const STATUE_TIME = [7200,14400];
const STATUE_NAME = ["蛇女","野猪勇士"];

const DIALOG_BASE_X = 100-74;
const DIALOG_BASE_Y = 112+22;
const DIALOG_OFF_X = 161;
const DIALOG_OFF_Y = 112-22;

const RECTMAX = 40;
const PAGE_W = 2750;
const PAGE_H = 1460;
const PBX = 1451;
const PBY = 126;
const PS_MAX = 50;
const PS_MIN = -50;
const MS_MAX = 100;
const MS_MIN = -50;
const FILLER_W = 119;
const FILLER_H = 13;
const BUTTONFONTSIZE = 26;

const LEV_EXP =[0,20,50,110,210,360,660,1160,1960,3160,4860,7160,10160,14060,19130,25721,34289,43713,54079,65481,78023,91819,106994,123686,142047,162244,184460,208897,235777,265345];

const ROOMNAME = ["橙色普通农舍","橙色中级农舍","橙色高级农舍","红色普通农舍","红色中级农舍","红色高级农舍","蓝色普通农舍","蓝色中级农舍","蓝色高级农舍","紫色普通农舍","紫色中级农舍","紫色高级农舍","橙色普通民宅","橙色中级民宅","橙色高级民宅","红色普通民宅","红色中级民宅","红色高级民宅","蓝色普通民宅","蓝色中级民宅","蓝色高级民宅","紫色普通民宅","紫色中级民宅","紫色高级民宅","橙色普通别墅","橙色中级别墅","橙色高级别墅","红色普通别墅","红色中级别墅","红色高级别墅","蓝色普通别墅","蓝色中级别墅","蓝色高级别墅","紫色普通别墅","紫色中级别墅","紫色高级别墅","橙色普通豪宅","橙色中级豪宅","橙色高级豪宅","红色普通豪宅","红色中级豪宅","红色高级豪宅","蓝色普通豪宅","蓝色中级豪宅","蓝色高级豪宅","紫色普通豪宅","紫色中级豪宅","紫色高级豪宅","橙色普通庄园","橙色中级庄园","橙色高级庄园","红色普通庄园","红色中级庄园","红色高级庄园","蓝色普通庄园","蓝色中级庄园","蓝色高级庄园","紫色普通庄园","紫色中级庄园","紫色高级庄园","橙色普通神奇屋","橙色中级神奇屋","橙色高级神奇屋","红色普通神奇屋","红色中级神奇屋","红色高级神奇屋","蓝色普通神奇屋","蓝色中级神奇屋","蓝色高级神奇屋","紫色普通神奇屋","紫色中级神奇屋","紫色高级神奇屋","普通丹桂月宫","中级丹桂月宫","高级丹桂月宫","普通金碧月宫","中级金碧月宫","高级金碧月宫"];
const FACTNAME = ["普通面包房","中级面包房","高级面包房","普通水果店","中级水果店","高级水果店","普通肉铺","中级肉铺","高级肉铺","普通餐厅","中级餐厅","高级餐厅","普通诊所","中级诊所","高级诊所","普通书店","中级书店","高级书店","普通服装店","中级服装店","高级服装店","普通首饰店","中级首饰店","高级首饰店","普通赌场","中级赌场","高级赌场","普通嫦娥织坊","中级嫦娥织坊","高级嫦娥织坊"];
const CAMPNAME = ["普通步兵训练营","中级步兵训练营","高级步兵训练营","普通骑兵训练营","中级骑兵训练营","高级骑兵训练营","普通侦察兵训练营","中级侦察兵训练营","高级侦察兵训练营"];
const FARMNAME = [null,"普通农田","水晶农田","宝石农田","精灵农田","伐木场","采石场"];
const GONAME = ["丰收之神（青铜）","人口之神（青铜）","财富之神（青铜）","战争之神（青铜）","丰收之神（白银）","人口之神（白银）","财富之神（白银）","战争之神（白银）","丰收之神（黄金）","人口之神（黄金）","财富之神（黄金）","战争之神（黄金）","丰收之神（蓝玉）","人口之神（蓝玉）","财富之神（蓝玉）","战争之神（蓝玉）","丰收之神（紫金）","人口之神（紫金）","财富之神（紫金）","战争之神（紫金）","友谊之神（青铜）","友谊之神（白银）","友谊之神（黄金）","友谊之神（蓝玉）","友谊之神（紫金）"];
//todo
const OBJNAME = ["砖石路","格子路","彩砖路","石头路","黄金路","白心花坛","红心花坛","粉心花坛","黄心花坛","蓝心花坛","紫心花坛","草坪","精灵灯","普通路灯","高杆路灯","吊灯","心形花灯","路牌","椅子","普通水井","魔法水井","紫色花丛","红色花丛","橙色花丛","深绿忘忧草","黄色忘忧草","绿色忘忧草","蓝色忘忧草","粉色樱花树","紫色樱花树","淡紫樱花树","红色樱花树","橙色灌木","黄色灌木","绿色灌木","春天枫树","夏天枫树","秋天枫树","天使雕像","月兔送福","丰收月饼台","吉祥兔儿神"];
const UNLOCK = [null,null,"90,object0.png;90,object1.png;90,object2.png","50,plant2.png","50,fact3.png;90,object3.png","90,object4.png;50,room12.png;50,plant3.png","90,object5.png;50,fact6.png","90,object11.png;50,plant4.png","90,object12.png;50,room60.png;25,shen0.png;50,fact9.png","90,object13.png;50,plant5.png","90,object14.png;90,object20.png;50,farm2.png;50,plant6.png;50,room24.png;33,farm5.png","90,object15.png;50,camp3.png","90,object16.png;25,shen1.png","90,object17.png;50,plant7.png","90,object18.png;90,wood1.png;50,fact15.png","90,object19.png;90,object28.png;33,room36.png;50,fact12.png","90,object21.png;50,plant8.png;25,shen3.png","90,wood2.png","90,object24.png;33,farm6.png","90,object32.png;90,object38.png","50,farm3.png;50,plant9.png;33,room48.png;25,shen2.png","50,fact18.png;90,wood3.png","90,stone1.png","50,plant10.png","50,fact24.png;90,stone2.png","90,object35.png;50,plant12.png;90,wood5.png","50,plant11.png","90,stone3.png","90,wood4.png","50,fact21.png","90,stone5.png;50,farm4.png;90,stone4.png"];
const nobilityname = ["平民","男爵","子爵","伯爵","侯爵","公爵","帝王"];
const NOBNAME = ["三等平民","二等平民","一等平民","三等男爵","二等男爵","一等男爵","三等子爵","二等子爵","一等子爵","三等伯爵","二等伯爵","一等伯爵","三等侯爵","二等侯爵","一等侯爵","三等公爵","二等公爵","一等公爵","帝王"]
const PLANTNAME=["小麦","胡萝卜","玉米","菠萝","茄子","西红柿","青椒","南瓜","水蜜桃","西瓜","芒果","草莓"];
const STONENAME=["砾石","玄武岩","石灰岩","花岗岩","大理石","石英"];
const WOONAME =["枫树","柳树","白杨","梧桐","松树","橡树"];
const GIFTNAME =["木条","沙子","铁钉","铆钉","红砖","房梁","木门","三合板","碎石","青砖","木桩","钢管"];

const waitaction1 = repeat(animate(2000,"wait1.png","wait2.png","wait3.png","wait4.png","wait5.png","wait6.png","wait7.png","wait8.png","wait9.png","wait10.png","wait11.png","wait12.png","wait13.png","wait14.png","wait15.png","wait16.png","wait17.png","wait18.png","wait19.png","wait20.png"));
const cardprename = ["蛇怪","野猪","狼怪","熊怪","狮子","恶龙","蛇王","野猪王","狼王","熊王","狮王","龙王","爵位","嫦娥","种植达人","商业达人"];
const cardlevelname = ["卡","铜卡","银卡","金卡","蓝玉卡","紫金卡","勋章"];
const cardlevelnum = [5,15,45,85,135];

const GRAY =m_color(30,59,11,0,0, 30,59,11,0,0, 30,59,11,0,0, 0,0,0,100,0);
const NORMAL = m_color(100,0,0,0,0, 0,100,0,0,0, 0,0,100,0,0, 0,0,0,100,0);

//const scale_node = sprite().addaction(repeat(scaleto(750,1),
const cardnum = 13;
const NEWFLAG = 8;
    
const staticString = ["你需要升到10级才能开启战争模式","开启战争模式之后暂时就不能退出咯，请查看帮助文档",
"恭喜你抵挡住了[ENAME]的攻势，保卫了领地不被侵犯！","[ENAME]兵力过于强大，你的军队不幸战败，快去加强你的军事力量吧！",
"[ENAME]兵力过于强大，回去厉兵秣马，来日再战！","恭喜你战胜了[ENAME]，你离帝王宝座又近了一步！","如何提高战斗力",
"[USERNAME]进入新的地图啦，赶快加入与[USERNAME]一起打造属于自己的奇迹帝国吧！","[USERNAME]升级为[NOBNAME]啦，赶快加入与[USERNAME]一起打造属于自己的奇迹帝国吧！",
"[USERNAME]的领地升级啦，赶快加入与[USERNAME]一起打造属于自己的奇迹帝国吧！","[USERNAME]成功战胜侵略者，赶快加入与[USERNAME]一起打造属于自己的奇迹帝国吧！",
"[USERNAME]被YYYY[ENAME]打败了，赶快加入帮助[USERNAME]复仇吧！","[USERNAME]的大军被击退，赶快加入与[USERNAME]一起侵略其他领地吧！",
"[USERNAME]战胜了[ENAME]，赶快加入与[USERNAME]一起打造属于自己的奇迹帝国吧！","你需要升到15级才能使用一键操作","你没有空闲的农田，不能使用一键操作","你的农作物正在生长，无法一键收获",
"[WHO]的[TYPE]数需要达到[NUM]才能升到下一等级。该卡紫金级别可以让[WHO]无限次免费使用一键操作功能！","[WHO]还需要战胜[NUM]个用户才能升级到[CARD]",
"你的店铺正在工作，无法一键收税"];
//next 20

var image=dict();    
function getimage(str){
    if(image.get(str)==null){
        image.update(str,fetch(str));
    }
    return image.get(str);
}

function removeself(n){
    n.removefromparent();
}

function donothing(){
    trace("sb");
    return 1;
}
    
function destroynode(p){
    var sn=p.subnodes();
    if(sn!=null){
            for(var i=0;i<len(sn);i++){
                destroynode(sn[i]);
            }
        }
        p.addaction(stop());
        p.removefromparent();
    }

import global.TimeController;

class DataController{
    var datadict;
    var builddict;
    function DataController(){
        builddict = dict();
        var build = dict([["size",3],["level",15],["price",100000],["food",1000],["exp",0],["personmax",100],["name","龙巢"]]);
        builddict.update(1000,build);
    }
    function getbuild(id){
        return builddict.get(abs(id));
    }
}


class GlobalController{
    var self;
    var screen;
    var dialogscreen;
    var shotscreen;
    var context;
    var request;
    var currentLevel;
    var dark;
    var newcontext;
    var card;

    var battlelist;

    var money;
    var caesars;
    
    var personlimit;
    var rect;
    var allymax;
    var flagnew;
    var lastpage;
    var soldiers;
    var special;
    var nobility;
    var http;
    var image;
    var task;
    var wartask;
    
    var ppyuserdict;

    var godbuild;

    var userid;
    var cityid;
    var mapid;
    var system;
    var timer;
    var user;
    var data;

    var dataname;
    
    var lockpage;
    var flagshownew;
    function lock(){
        if(lockpage==null){
            lockpage = new ClockObject();
            lockpage.init(lockpage,self);
            black(NonAutoPop);
            dialogscreen.add(lockpage.getNode());
        }
    }
    
    function unlock(){
        if(lockpage!=null){
            lockpage.deleteContext();
            white();
            lockpage = null;
        }
    }
    
    function getStaticString(index){
        if(len(staticString)<=index||index<0){
            return "";
        }
        else{
            return staticString[index];
        }
    }
    
    function getMedalString(index,pre,leftnum,medallevel){
        var medalstr = pre+"还需要";
        if(index<12){
            medalstr = medalstr+"战胜"+str(leftnum)+"个"+substring(MONSTERNAME[index*3],6);
        }
        else if(index==13){
            medalstr = medalstr+"连续登录"+str(leftnum)+"天";
        }
        medalstr = medalstr+"才能获得"+cardprename[index]+cardlevelname[medallevel];
        return medalstr;
    }
    
    function getFormatString(num,pair){
        var rstr = staticString[num];
        for(var i=0;i<len(pair);i=i+2){
            rstr = rstr.replace(pair[i],pair[i+1]);
        }
        return rstr;
    }

    function GlobalController(){
        flagshownew = 0;
        lockpage = null;
        var s = getscene();
        screen = s.addsprite();
        flagnew = 0;
        dialogscreen = s.addsprite();
        shotscreen = s.addsprite().size(800,480);
        
        context = new Array(15);
        request = new Array(15);
        currentLevel = -1;
        dark = new Array(0);
        lastpage = new Array(0,400,400,400,0,400,400);
        godbuild = new Array(0,0,0,0);
        rect = 20;
        soldiers = [0,0,0,0,0];
        battlelist = new Array(0);
        dataname = new dict();
        dataname.update("room",ROOMNAME);
        dataname.update("fact",FACTNAME);
        dataname.update("god",GONAME);
        dataname.update("camp",CAMPNAME);
        dataname.update("farm",FARMNAME);
        dataname.update("obj",OBJNAME);
        dataname.update("soldier",SOLDIER_NAME);
        dataname.update("plant",PLANTNAME);
        dataname.update("stone",STONENAME);
        dataname.update("wood",WOONAME);
        dataname.update("statue",STATUE_NAME);
        timer =null;
        data = new DataController();
        ppyuserdict = dict([[str(ppy_userid()),dict([["name",ppy_username()]])],["0",dict([["name","凯撒"]])]]);
    }
    
    function inittimer(t){
        if(timer == null){
            timer=new TimeController(t);
        }
    }

    function getfriend(papayaid){
        if(type(papayaid)!=4){
            papayaid=str(papayaid);
        }
        var u = ppyuserdict.get(papayaid);
        if(u==null){
            u = dict([["name","unknown"],["level",-1]]);
        }
        return u;
    }

    function getname(namestr,nameid){
        return dataname.get(namestr)[nameid];
    }

    function changesoldiers(ne,b,value,hi){
        soldiers[b] = soldiers[b]+value;
        if(ne.contextNode!=null){
            var ps = ne.contextNode.pos();
            var x = ps[0]+ne.contextid*2;
            var y = ps[1]-ne.contextid*17-hi*17;
            var n = node().pos(x,y);
            n.add(sprite("flysoldier.png").anchor(100,50).pos(-5,0));
            var ns = str(value);
            var f = 0;
            if(value > 0){
                ns = "+"+ns;
                f = 1;
            }
            n.addlabel(ns,null,40).color(100,f*100,0,100).anchor(0,50).pos(5,0);
            n.addaction(sequence(moveby(1000,0,-80),tintto(1000,0,0,0,0),callfunc(removeself)));
            context[0].contextNode.add(n.scale(80),20000);
        }
        if(task.tasktype==1){
            if(value>0 && ne.objectid/100==2 && ne.objnode.bid/3==task.taskpair[1] && ne.objnode.objid/3==task.taskpair[3]){
                task.inctaskstep(value);
            }
        }
        if(wartask.wartasktype==1){
            if(value>0 && ne.objectid/100==2 && ne.objnode.bid/3==wartask.wartaskpair[1] && ne.objnode.objid/3==wartask.wartaskpair[3]){
                wartask.incwartaskstep(value);
            }
        }
    }

    function keydown(n,e,p,c){
        trace(c);
        //quitgame();
    }

    function black(auto){
        var i= len(dark);
        if(i>0)
            dark[i-1].visible(0);
        dark.append(dialogscreen.addsprite("dark.png").size(800,480).color(0,  0,  0,darkColorAlpha));
        dark[i].setevent(EVENT_TOUCH,autopopContext,auto);
        if(flagnew == 1 && newcontext.getNode().visible()==1)
            dark[i].visible(0);
    }

    function autopopContext(n,e,p){
        if(p == AutoPop){
            popContext(null);
        }
    }

    function white(){
        dark.pop().removefromparent();
        if(len(dark) > 0 && (flagnew==0||newcontext.getNode().visible()==0))
            dark[len(dark)-1].visible(1);
    }

    function pushContext(re,co,auto){
        if(currentLevel>=0 && context[currentLevel].contextname.rfind("control")==0){
            popContext(null);
        }
        if(auto == NotAdd){
            flagnew = 1;
            newcontext = co;
        }
        else{
            currentLevel++;
            if(currentLevel > 0)
                black(auto);
            request[currentLevel] = re;
            if(re == null && currentLevel>0)
                request[currentLevel] = context[currentLevel-1];
            context[currentLevel] = co;
        }
        co.global = self;
        co.self = co;
        co.contextLevel = currentLevel;
        if(auto == NotAdd)
            shotscreen.add(co.getNode());
        else if(currentLevel == 0)
            screen.add(co.getNode());
        else
            dialogscreen.add(co.getNode());
        if(flagnew == 0 || auto == NotAdd)
            co.getNode().focus(1);
        context[0].hiddentime = 10;
        if(task.tasktype==2){
            if(task.taskreq == co.contextname){
                task.inctaskstep(1);
            }
        }
        if(wartask.wartasktype==2){
            if(wartask.wartaskreq == co.contextname){
                wartask.incwartaskstep(1);
            }
        }
    }

    function popContext(re){
        if(re == -999){
            newcontext.deleteContext();
            flagnew = 0;
            context[currentLevel].getNode().focus(1);
            if(len(dark)>0)
                dark[len(dark)-1].visible(1);
        }
        else if(currentLevel > 0){
            context[currentLevel].deleteContext();
            context[currentLevel] = null;
            currentLevel--;
            white();
            if(flagnew == 0)
                context[currentLevel].getNode().focus(1);
            request[currentLevel+1].response(re);
        }
    }
    
    function getdatestr(seconds){
        var day = seconds/86400;
        var months=[31,28,31,30,31,30,31,31,30,31,30,31];
        var year = 2011;
        var month = 0;
        while(day>months[month]){
            day=day-months[month];
            month = (month+1)%12;
            if(month==0){
                year++;
                if(year%4==0){
                    months[1]=29;
                }
                else{
                    months[1]=28;
                }
            }
        }
        return str(year)+"-"+str(month+1)+"-"+str(day+1);
    }
    
    function getdatetimestr(t){
        return getdatestr(t)+" "+gettimestr(t%86400);
    }

    function gettimestr(t){
        var ti = new Array(3);
        ti[2] = t%60;
        ti[1] = t%3600/60;
        ti[0] = t/3600;
        for(var i=0;i<3;i++){
            if(ti[i] < 10)
                ti[i] = "0"+str(ti[i]);
            else
                ti[i] = str(ti[i]);
        }
        return ti[0]+":"+ti[1]+":"+ti[2];
    }

    function getnobility(nob,subnob){
        if(subnob==3) subnob=2;
        var n = sprite("nobi"+str(nob*3+subnob)+".png").size(30,30);
        n.addlabel(NOBNAME[nob*3+subnob],null,20).anchor(0,50).pos(32,15).color(0,0,0,100);
        return n;
    }
    
    function addtext(n,x,y,text,fsize){
        var strs = text.split("+");
        for(var i=0;i<len(strs);i++){
            if(strs[i].rfind("<b>")!= -1){
                var str = strs[i].split("<b>");
                var tmp1=n.addlabel(str[0],null,fsize).pos(x,y+fsize*6/5*i).color(0,0,0,100);
                tmp1.prepare();
                var tmp2=n.addlabel(str[1],null,fsize).pos(x+tmp1.size()[0],y+fsize*6/5*i).color(0,0,67,100);
                tmp2.prepare();
                n.addlabel(str[2],null,fsize).pos(x+tmp1.size()[0]+tmp2.size()[0],y+fsize*6/5*i).color(0,0,0,100);
            }
            else if(strs[i].rfind("<g>")!=-1){
                str = strs[i].split("<g>");
                tmp1=n.addlabel(str[0],null,fsize).pos(x,y+fsize*6/5*i).color(0,0,0,100);
                tmp1.prepare();
                tmp2=n.addlabel(str[1],null,fsize).pos(x+tmp1.size()[0],y+fsize*6/5*i).color(43,75,0,100);
                tmp2.prepare();
                n.addlabel(str[2],null,fsize).pos(x+tmp1.size()[0]+tmp2.size()[0],y+fsize*6/5*i).color(0,0,0,100);
            }
            else if(strs[i].rfind("<r>")!=-1){
                str = strs[i].split("<r>");
                tmp1=n.addlabel(str[0],null,fsize).pos(x,y+fsize*6/5*i).color(0,0,0,100);
                tmp1.prepare();
                tmp2=n.addlabel(str[1],null,fsize).pos(x+tmp1.size()[0],y+fsize*6/5*i).color(75,0,0,100);
                tmp2.prepare();
                n.addlabel(str[2],null,fsize).pos(x+tmp1.size()[0]+tmp2.size()[0],y+fsize*6/5*i).color(0,0,0,100);
            }
            else{
                n.addlabel(strs[i],null,fsize).pos(x,y+fsize*6/5*i).color(0,0,0,100);
            }
        }
    }
}