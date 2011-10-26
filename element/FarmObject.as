class FarmObject extends BuildObject{
    var pstate;
    var plantNode;
    function FarmObject(b){
        contextname = "object-build-resource";
        buildname = "farm";
        buildindex = 3;
        pstate = 0;
        plantNode = null;
        initwithbase(b);
    }

    override function timerefresh(){
        var alltime;
        alltime = objectgettime();
        lefttime = alltime+begintime-time()/1000;
        if(flagquick == 1){
            flagquick = 0;
            updatestate();
        }
        else if(lefttime <= 0){
            updatestate();
        }
        else if(3*(lefttime-1)/alltime + pstate != 3 && bid<5)
            resetplant();
        else if(state == 3 && state2==0 && mstate+4*(lefttime-1)/alltime <4){
            refreshminus();
        }
    }

    override function objectgettime(){
        if(state!=3) return 0;
        if(bid==5){
            return WOOD_TIME[objid];
        }
        else if(bid==6){
            return STONE_TIME[objid];
        }
        else{
            return PLANT_TIME[objid];
        }
    }

    override function beginbuild(){
        global.user.changeValueAnimate(baseobj,"labor",FARM_PERSON[bid],2);
        if(FARM_PRICE[bid]<0){
            global.user.changeValueAnimate(baseobj,"caesars",FARM_PRICE[bid],0);
        }
        else{
            global.user.changeValueAnimate(baseobj,"money", -FARM_PRICE[bid],0);
        }
        global.user.changeValueAnimate(baseobj,"exp",FARM_EXP[bid],-2);
        if(bid>4)
            global.user.changeValueAnimate(baseobj,"food",-FARM_FOOD[bid],4);
        state = 2;
        super.beginbuild();
    }
    
    override function objectinterface(s,p){
        if(s == 4){
            var type = 0;
            if(bid == 5) type = 2;
            else if(bid==6) type=1;
            global.http.addrequest(0,"harvest",["user_id","city_id","grid_id","type"],[global.userid,global.cityid,baseobj.posi[0]*RECTMAX+baseobj.posi[1],type],self,"state4over");
        }
        else if(s == 2 && p!=null){
            if(global.user.getValue("money") > PLANT_PRICE[p]){
                objid = p;
                var ps = baseobj.posi[0]*RECTMAX+baseobj.posi[1];
                type = 0;
                if(bid==5) type = 2;
                else if(bid==6) type = 1;
                global.http.addrequest(0,"planting",["user_id","city_id","grid_id","object_id","type"],[global.userid,global.cityid,ps,objid,type],self,"state2over");
            }
        }
    }

    function state4over(r,rc,c){
trace("harvest",rc,c);
        if(rc != 0 && json_loads(c).get("id")!=0){
            state = 2;
            var bl=10;
            if(global.user.getValue("godtime")[0]>0){
                bl = global.user.getValue("godlevel")[0]*2+12;
            }
            if(bid==5){
                global.user.changeValueAnimate(baseobj,"exp",WOOD_EXP[objid],-1);
                if(time()/1000-begintime<3*86400){
                    global.user.changeValueAnimate(baseobj,"wood",WOOD_GAIN[objid]*bl/10,1);
                }
            }
            else if(bid==6){
                global.user.changeValueAnimate(baseobj,"exp",STONE_EXP[objid],-1);
                if(time()/1000-begintime<3*86400){
                    global.user.changeValueAnimate(baseobj,"stone",STONE_GAIN[objid]*bl/10,1);
                }
            }
            else{
                global.user.changeValueAnimate(baseobj,"exp",PLANT_EXP[objid],-1);
                if(time()/1000-begintime<3*86400){
                    global.user.changeValueAnimate(baseobj,"food",PLANT_FOOD[objid]*(bid+4)/5*bl/10,1);
                }
            }
            state2= 0;
        }
        lock = 0;
        setstate();
    }
    
    override function gettexture(){
        if(state <= 2)
            return "farm"+str(bid)+".png";
        else{
            if(bid<5){
                return "plant"+str(objid+1)+".png";
            }
            else if(bid==5){
                return "wood"+str(objid+1)+".png";
            }
            else{
                return "stone"+str(objid+1)+".png";
            }
        }
    }

    function state2over(r,rc,c){
trace("plant",rc,c);
        if(rc != 0 && json_loads(c).get("id")==1){
            var price;
            if(bid == 5){
                price = WOOD_PRICE[objid];
            }
            else if(bid==6){
                price = STONE_PRICE[objid];
            }
            else{
                price = PLANT_PRICE[objid];
            }
            if(price<0)
                global.user.changeValueAnimate(baseobj,"caesars",price,0);
            else
                global.user.changeValueAnimate(baseobj,"money", -price,0);
            state = 3;
            begintime = time()/1000;
            lefttime = 100000;
        }
        lock = 0;
        setstate();
    }
    
    override function objectsetstate(){
        if(state == 1)
            state=2;
        if(plantNode == null && bid<5){
            plantNode=contextNode.addsprite("plant_1.png").anchor(50,100).pos(63,58).size(85,53);
        }
        if(state == 2){
            stateNode.texture("zzz.png",ALPHA_TOUCH,UPDATE_SIZE).pos(baseobj.contextid*33+1,baseobj.contextid*33-contextNode.size()[1]/2);
            if(bid<5){
                plantNode.texture();
            }
        }
        else if(state == 3){
            if(bid<5){
                if(state2 == 1)
                    stateNode.texture("state1.png",ALPHA_TOUCH,UPDATE_SIZE).pos(baseobj.contextid*33+1,baseobj.contextid*33-contextNode.size()[1]*2/3);
                else if(state2 == 2)
                    stateNode.texture("state2.png",ALPHA_TOUCH,UPDATE_SIZE).pos(baseobj.contextid*33+1,baseobj.contextid*33-contextNode.size()[1]*2/3);
                else
                    stateNode.texture();
                resetplant();
            }
            else{
                if(state2 == 1)
                    stateNode.texture("state3.png",ALPHA_TOUCH,UPDATE_SIZE).pos(baseobj.contextid*33+1,baseobj.contextid*33-contextNode.size()[1]*2/3);
                else if(state2 == 2)
                    stateNode.texture("state4.png",ALPHA_TOUCH,UPDATE_SIZE).pos(baseobj.contextid*33+1,baseobj.contextid*33-contextNode.size()[1]*2/3);
                else
                    stateNode.texture();
            }
            flagquick = 0;
        }
        else if(state == 4){
            if(time()/1000-begintime<3*86400){
                if(bid<5){
                    resetplant();
                    stateNode.texture("plant"+str(objid+1)+"_over.png",ALPHA_TOUCH,UPDATE_SIZE).pos(baseobj.contextid*33+1,baseobj.contextid*33-contextNode.size()[1]/2);
                }
                else if(bid==5)
                    stateNode.texture("woodover.png",ALPHA_TOUCH,UPDATE_SIZE).pos(baseobj.contextid*33+1,baseobj.contextid*33-contextNode.size()[1]/2);
                else if(bid==6)
                    stateNode.texture("stoneover.png",ALPHA_TOUCH,UPDATE_SIZE).pos(baseobj.contextid*33+1,baseobj.contextid*33-contextNode.size()[1]/2);
            }
            else{
                stateNode.texture("resourcefail.png",ALPHA_TOUCH,UPDATE_SIZE).pos(baseobj.contextid*33+1,baseobj.contextid*33-contextNode.size()[1]/2);
                if(bid<5){
                    resetplant();
                }
            }
        }
    }

    function resetplant(){
        if(contextNode==null||plantNode==null){
            return 0;
        }
        var plantstate = gettimeper();
        if(plantstate < 333){
            pstate = 1;
            plantNode.texture("plant_1.png").size(85,53).anchor(50,100);
        }
        else if(plantstate< 666){
            plantNode.texture("plant_2.png").size(85,53).anchor(50,100);
            pstate = 2;
        }
        else if(state!=4){
            plantNode.texture("plant"+str(objid+1)+"_3.png").size(102,64).anchor(45,103);
            pstate = 3;
        }
        else{
            if(time()/1000-begintime<3*86400){
                plantNode.texture("plant"+str(objid+1)+"_4.png").size(102,64).anchor(45,103);
            }
            else{
                plantNode.texture("plant_fail.png").size(102,64).anchor(45,103);
            }
        }
    }
}