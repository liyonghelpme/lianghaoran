class SpeedattackControl extends ContextObject{
    var timelabel;
    var lock;
    var qlabel;
    var qfiller;
    var element;
    var flagquick;
    var moneylabel;
    var moneylabel1;
    var costcae;
    var battledata;
    function SpeedattackControl(ebdata){
        contextname = "dialog-battle-quick";
        contextNode = null;
        element = null;
        lock =0;
        flagquick = 0;
        battledata = ebdata;
    }

    var alltime;
    function getelement(){
        if(element == null){
        var dtime = [[7200,14400,0],[5400,12600,14400],[4680,9000,11520],[3960,6480,8640],[3240,5400,7200],[1800,3240,4680]];
        //if(global.flagnew == 1) dtime = 0;
        var t=dtime[global.user.getValue("nobility")/3];
        var spos = global.context[1].getposbyid(global.context[1].selfgid);
        var epos = global.context[1].getposbyid(battledata[3]);
        if(spos[0]==epos[0]&&spos[1]==epos[1]){
            var atime = t[0];
        }
        else{
            var mw=abs(spos[1]/2-epos[1]/2);
            atime = t[2]*(abs(spos[0]-epos[0])+mw)+t[1]*(abs(spos[1]-epos[1])-mw);
        }
        var bz = battledata[4]+battledata[5];
        var b1 = battledata[4];
        if(bz == 0){
            bz = 1;
            b1 = 1;
        }
        alltime = 100*(bz+b1)/(2*bz)*atime/100;
            element = node();
            element.addsprite("objectblock.png").anchor(50,50).pos(109,121);
            element.addsprite("animate_self_left_2_2.png").anchor(50,63).pos(109,121);
            element.addsprite("quickback.jpg").pos(202,58);
            qfiller = element.addsprite("quickfiller.jpg").pos(203,59).size(0,20);
            qlabel = qfiller.addlabel("0%",null,20).color(0,0,0,100).anchor(50,50).pos(82,10);
            timelabel = element.addlabel("",null,18).color(0,0,0,100).pos(207,94);
            global.timer.addlistener(battledata[0],self);
        }
        return element;
    }
    
    function paintNode(){
        var dialog = new Simpledialog(1,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.settitle("quicktitle.png");
        dialog.usedefaultbutton(2,["加速","取消"]);
        var cae = sprite("caesars_big.png").anchor(50,50).pos(56,228).size(40,40);
        moneylabel1 = cae.addlabel("",null,30,FONT_BOLD).pos(22,13).color(0,0,0,100);
        moneylabel = cae.addlabel("",null,24,FONT_BOLD).pos(25,16).color(100,100,100,100);
        contextNode.add(cae,4);
        timerefresh();
    }

    function excute(p){
        if(lock == 0){
            var cost = dict();
            cost.update("caesars",costcae);
            if(global.user.testCost(cost)==0){
                return 0;
            }
            lock = 1;
            contextNode.get(1).setevent(EVENT_UNTOUCH,null);
            trace(battledata);
            var edata = global.context[1].userdict.get(battledata[3]);
            global.http.addrequest(1,"attackspeedup",["uid","enemy_id"],[global.userid,edata[5]],self,"speedbegin");
        }
    }
    
    function useaction(p,rc,c){
        if(p=="speedbegin"){
            speedbegin(0,rc,c);
        }
    }

    function speedbegin(r,rc,c){
trace("speed",rc,c);
        if(rc != 0){
            flagquick = 1;
            for(var i=0;i<len(global.battlelist);i++){
                if(battledata[1]==global.battlelist[i][1]&&global.battlelist[i][2]==1){
                    global.battlelist[i][0]=global.timer.base_localtime;
                }
            }
            timelabel.removefromparent();
            qlabel.removefromparent();
            qfiller.addaction(sizeto(600,165,20));
        }
        else
            lock=0;
    }

    var timeisend=0;
    function timeend(){
        global.popContext(null);
    }
    function timerefresh(){
        if(flagquick == 0){
            var lefttime = battledata[0]-global.timer.currenttime;
            costcae = (lefttime-1)/10800*2+2;
            if(costcae>6){
                costcae=10;
            }
            moneylabel.text(str(costcae));
            moneylabel1.text(str(costcae));
            timelabel.text("剩余时间:"+global.gettimestr(lefttime));
            var per = (alltime-lefttime)*1000/alltime;
            var per1 = per/10;
            var per2 = per%10;
            qlabel.text(str(per1)+"."+str(per2)+"%");
            qfiller.size(per1 * 165/100,20);
        }
        else if(flagquick < 2){
            flagquick++;
        }
        else if(flagquick == 2){
            global.user.changeValue("caesars",-costcae);
            global.popContext(null);
            lock = 0;
            timeisend=1;
        }
    }

    function reloadNode(re){
    }

    function deleteContext(){
        timeisend = 1;
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}