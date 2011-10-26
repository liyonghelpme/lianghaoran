class StatueObject extends BuildObject{
    function StatueObject(b){
        contextname = "object-build-statue";
        buildname = "build";
        buildindex = 6;
        initwithbase(b);
    }

    override function beginbuild(){
        //
        var data = global.data.getbuild(bid);
        if(STATUE_PRICE[bid%100]<0){
            global.user.changeValueAnimate(baseobj,"caesars", STATUE_PRICE[bid%100],2); 
        }
        else{
            global.user.changeValueAnimate(baseobj,"money", -STATUE_PRICE[bid%100],2); 
        }
        global.user.changeValueAnimate(baseobj,"citydefence", STATUE_DEFENCE[bid%100],0);
        global.user.changeValueAnimate(baseobj,"labor",STATUE_PERSON[bid%100],-2);
        state = 1;
        begintime = global.timer.currenttime;
        lefttime = 7200;
        super.beginbuild();
    }

    override function objectgettime(){
        if(state == 1) return STATUE_TIME[bid%100];
        else return 0;
    }
}