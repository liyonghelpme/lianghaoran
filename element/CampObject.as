class CampObject extends BuildObject{
    function CampObject(b){
        contextname = "object-build-camp";
        buildname = "camp";
        buildindex = 2;
        initwithbase(b);
    }

    override function objectinterface(s,p){
        if(s == 4){
            var p1 = baseobj.posi[0]*RECTMAX+baseobj.posi[1];
            global.http.addrequest(0,"soldier",["user_id","city_id","grid_id"],[global.userid,global.cityid,p1],self,"state4over");
        }
        else if(s == 2){
            objid = p;
            p1 = baseobj.posi[0]*RECTMAX+baseobj.posi[1];
            global.http.addrequest(0,"training",["user_id","city_id","grid_id","sid"],[global.userid,global.cityid,p1,objid+bid/3*9],self,"state2over");
        }
    }

    function state4over(r,rc,c){
trace("soldier",rc,c);
        if(rc != 0 && json_loads(c).get("id")==1){
            state = 2;
            state2 =0;
            var sid=bid/3;
            objid = objid%9;
            var slevel =[1,3,6];
            var snum = SOLDIER_PERSON[sid]*slevel[objid%3];
            global.user.changeValueAnimate(baseobj,"exp",SOLDIER_EXP[sid*9+objid],1);
            if(time()/1000-begintime<3*86400){
                if(sid == 2){
                    sid = sid+objid/3;
                }
                else{
                    snum = snum*SOLDIER_POWER[sid*3+objid/3];
                }
                global.changesoldiers(baseobj,sid,snum,-1);
            }
        }
        lock = 0;
        setstate();
    }


    override function beginbuild(){
        if(bid%3==0){
            global.user.changeValueAnimate(baseobj,"money", - CAMP_PRICE[bid],4);
            global.user.changeValueAnimate(baseobj,"food",-CAMP_FOOD[bid],2);
            global.user.changeValueAnimate(baseobj,"labor",CAMP_PERSON[bid],0);
        }
        global.user.changeValueAnimate(baseobj,"exp",CAMP_EXP[bid],-2);
        state = 1;
        begintime = time()/1000;
        lefttime = CAMP_TIME[bid];
        super.beginbuild();
    }

    function state2over(r,rc,c){
trace("training",rc,c);
        if(rc != 0 && json_loads(c).get("id")==1){
            objid = objid%9;
            var sid=bid/3;
            var slevel =[1,3,6];
            var snum = SOLDIER_PERSON[sid]*slevel[objid%3];
            sid = sid*3+objid/3;
            global.user.changeValueAnimate(baseobj,"money",- SOLDIER_PRICE[bid/3*9+objid],2);
            global.user.changeValueAnimate(baseobj,"food",- SOLDIER_FOOD[sid]*snum,0);
            global.user.changeValueAnimate(baseobj,"person",-snum,-2);
            state = 3;
            begintime = time()/1000;
            lefttime = CAMP_TIME[bid];
        }
        lock = 0;
        setstate();
    }

    override function objectsetstate(){
        objid = objid%9;
        var baseoff = baseobj.contextid*33;
        var buildoff = contextNode.size()[1]*2/3;
        if(state == 4){
            if(time()/1000-begintime>86400*3){
                stateNode.texture("soldierfail.png",UPDATE_SIZE).pos(baseobj.contextid*33+1,baseobj.contextid*33-contextNode.size()[1]+27);
            }
            else{
                stateNode.texture("soldierSuccess.png",UPDATE_SIZE).pos(baseobj.contextid*33+1,baseobj.contextid*33-contextNode.size()[1]+27);
            }
        }
        else if(state == 2){
            stateNode.texture("zzz.png",UPDATE_SIZE).pos(baseobj.contextid*33+1,baseobj.contextid*33-contextNode.size()[1]+27);
            flagquick = 0;
        }
        else{
            if(state2 == 1)
                stateNode.texture("state3.png",UPDATE_SIZE).pos(baseoff+1,baseoff-buildoff);
            else if(state2 == 2)
                stateNode.texture("state4.png",UPDATE_SIZE).pos(baseoff+1,baseoff-buildoff);
            else
                stateNode.texture();
        }
    }

    override function objectgettime(){
        if(state == 1) return CAMP_TIME[bid];
        else if(state == 3) return SOLDIER_TIME[objid%3];
        else return 0;
    }
}