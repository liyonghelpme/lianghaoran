class FactObject extends BuildObject{
    function FactObject(b){
        contextname = "object-build-fact";
        buildname ="fact";
        buildindex = 1;
        initwithbase(b);
    }

    override function objectinterface(s,p){
        if(s == 4){
            global.http.addrequest(0,"product",["user_id","city_id","grid_id"],[global.userid,global.cityid,baseobj.posi[0]*RECTMAX+baseobj.posi[1]],self,"state4over");
        }
    }

    function state4over(r,rc,c){
trace("product",rc,c);
        if(rc != 0){
            state = 3;
            global.user.changeValueAnimate(baseobj,"exp",FACT_EXP[bid],0);
            if(time()/1000-begintime<3*86400){
                var bl=10;
                if(global.user.getValue("godtime")[2]>0){
                    bl = global.user.getValue("godlevel")[2]*2+12;
                }
                global.user.changeValueAnimate(baseobj,"money",FACT_GAIN[bid]*bl/10,2);
            }
            begintime = time()/1000;
            lefttime = 1;
            state2=0;
        }
        lock = 0;
        setstate();
    }

    override function beginbuild(){
        if(bid%3==0){
            if(FACT_PRICE[bid] < 0)
                global.user.changeValueAnimate(baseobj,"caesars",FACT_PRICE[bid],0);
            else{
                global.user.changeValueAnimate(baseobj,"money", - FACT_PRICE[bid],4);
                global.user.changeValueAnimate(baseobj,"food",-FACT_FOOD[bid],2);
                global.user.changeValueAnimate(baseobj,"labor",FACT_PERSON[bid],0);
            }
        }
                global.user.changeValueAnimate(baseobj,"exp",FACT_B_EXP[bid],-2);
                state = 1;
                begintime = time()/1000;
                lefttime = FACT_B_TIME[bid];
        super.beginbuild();
    }

    override function objectsetstate(){
                if(state == 4){
                    if(time()/1000-begintime<3*86400){
                        stateNode.texture("factSuccess.png",UPDATE_SIZE).pos(baseobj.contextid*33+1,baseobj.contextid*33-contextNode.size()[1]*2/3);
                    }
                    else{
                        stateNode.texture("factfail.png",UPDATE_SIZE).pos(baseobj.contextid*33+1,baseobj.contextid*33-contextNode.size()[1]*2/3);
                    }
                }
                else{
                    if(state == 2){
                        state =3;
                        begintime = time()/1000;
                        lefttime = 1;
                    }
                    if(state2 == 1){
                        stateNode.texture("state3.png",UPDATE_SIZE).pos(baseobj.contextid*33+1,baseobj.contextid*33-contextNode.size()[1]*2/3);
                    }
                    else if(state2 == 2){
                        stateNode.texture("state4.png",UPDATE_SIZE).pos(baseobj.contextid*33+1,baseobj.contextid*33-contextNode.size()[1]*2/3);
                    }
                    else{
                        stateNode.texture();
                    }
                    flagquick = 0;
                }
    }

    override function objectgettime(){
        if(state == 1) return FACT_B_TIME[bid];
        else if(state == 3) return FACT_TIME[bid];
        else return 0;
    }
}