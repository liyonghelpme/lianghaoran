class RoomObject extends BuildObject{
    function RoomObject(b){
        contextname = "object-build-room";
        buildname = "room";
        buildindex = 0;
        initwithbase(b);
    }

    override function objectinterface(s,p){
        if(s == 4){
            global.http.addrequest(0,"finipop",["user_id","city_id","grid_id"],[global.userid,global.cityid,baseobj.posi[0]*RECTMAX+baseobj.posi[1]],self,"state4over");
        }
        else if(s==2){
            var buildable = dict([["ok",1]]);
            var pr = ROOM_FOOD[bid];
            var pname = "food";
            var pcname = "粮食";
            if(global.user.getValue(pname)<pr){
                buildable.update("ok",0);
                buildable.update(pcname,pr-global.user.getValue(pname));
            }
            pr = ROOM_PERSON[bid];
            var pp=pr-global.user.getValue("personmax")+global.user.getValue("person");
            if(pp>0){
                buildable.update("ok",0);
                buildable.update("人口上限",pp);
            }
            if(buildable.get("ok")==0){
                global.pushContext(null,new Warningdialog(buildable),NonAutoPop);
                lock=0;
                setstate();
                return 0;
            }
            global.http.addrequest(0,"population",["user_id","city_id","grid_id"],[global.userid,global.cityid,baseobj.posi[0]*RECTMAX+baseobj.posi[1]],self,"state2over");
        }
    }

    function state4over(r,rc,c){
trace("finipop",rc,c);
        if(rc != 0){
            state = 2;
            state2 = 0;
            global.user.changeValueAnimate(baseobj,"exp",ROOM_EXP[bid],0);
            if(time()/1000-begintime<3*86400){
                var bl=10;
                if(global.user.getValue("godtime")[1]>0){
                    bl = global.user.getValue("godlevel")[1]*2+12;
                }
                global.user.changeValueAnimate(baseobj,"person",ROOM_PERSON[bid]*bl/10,2);
            }
        }
        lock = 0;
        setstate();
    }

    override function beginbuild(){
        if(bid%3==0){
            if(ROOM_PRICE[bid]<0){
                global.user.changeValueAnimate(baseobj,"caesars",ROOM_PRICE[bid],0);
            }
            else{
                global.user.changeValueAnimate(baseobj,"money", - ROOM_PRICE[bid],2);
                global.user.changeValueAnimate(baseobj,"food",-ROOM_B_FOOD[bid],0);
            }
        }
        global.user.changeValueAnimate(baseobj,"exp",ROOM_B_EXP[bid],-2);
        state = 1;
        begintime = time()/1000;
        lefttime = ROOM_B_TIME[bid];
        super.beginbuild();
    }

    function state2over(r,rc,c){
trace("population",rc,c);
        if(rc != 0 && json_loads(c).get("id",1)==1){
            global.user.changeValueAnimate(baseobj,"food", - ROOM_FOOD[bid],0);
            state = 3;
            begintime = time()/1000;
            lefttime = ROOM_TIME[bid];
        }
        lock = 0;
        setstate();
    }

    override function objectsetstate(){
        var baseoff = baseobj.contextid*33;
        var buildoff = contextNode.size()[1]*2/3;
        if(state == 4){
            if(time()/1000-begintime<3*86400){
                stateNode.texture("personSuccess.png",UPDATE_SIZE).pos(baseoff+1,baseoff-buildoff);
            }
            else{
                stateNode.texture("personfail.png",UPDATE_SIZE).pos(baseoff+1,baseoff-buildoff);
            }
        }
        else if(state == 2){
            stateNode.texture("zzz.png",UPDATE_SIZE).pos(baseoff+1,baseoff-buildoff);
            flagquick =0;
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
        if(state == 1) return ROOM_B_TIME[bid];
        else if(state == 3) return ROOM_TIME[bid];
        else return 0;
    }
}