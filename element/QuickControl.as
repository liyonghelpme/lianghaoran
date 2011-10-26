class QuickControl extends ContextObject{
    var timelabel;
    var lock;
    var qlabel;
    var qfiller;
    var element;
    var flagquick;
    var moneylabel;
    var moneylabel1;
    var costcae;
    function QuickControl(){
        contextname = "dialog-build-quick";
        contextNode = null;
        element = null;
        lock =0;
        flagquick = 0;
    }

    function getelement(){
        if(element == null){
            element = node();
            element.addsprite("objectblock.png").anchor(50,50).pos(109,121);
            var obj=global.request[global.currentLevel];
            var bl=100;
            if(obj.baseobj.contextid == 3){
                bl = 67;
            }
            else if(obj.bid>=600&&obj.bid<700){
                bl = 67;
            }
            else if(obj.baseobj.objectid/100 == 4){
                bl = 52;
                if(obj.bid>=20){
                    bl=60;
                }
            }
            element.addsprite(obj.gettexture()).anchor(50,50).pos(109,121).scale(bl);
            element.addsprite("quickback.jpg").pos(202,58);
            qfiller = element.addsprite("quickfiller.jpg").pos(203,59).size(0,20);
            qlabel = qfiller.addlabel("0%",null,20).color(0,0,0,100).anchor(50,50).pos(82,10);
            timelabel = element.addlabel("",null,18).color(0,0,0,100).pos(207,94);
            global.timer.addlistener(time()/1000+global.request[contextLevel].lefttime,self);
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
            var qobj = global.request[contextLevel].baseobj;
            global.http.addrequest(1,"speedup",["user_id","city_id","grid_id"],[global.userid,global.cityid,qobj.posi[0]*RECTMAX+qobj.posi[1]],self,"speedbegin");
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
            global.request[contextLevel].flagquick = 1;
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
            var lefttime = global.request[contextLevel].lefttime;
            costcae = (lefttime-1)/10800+1;
            if(costcae>3){
                costcae=5;
            }
            moneylabel.text(str(costcae));
            moneylabel1.text(str(costcae));
            timelabel.text("剩余时间:"+global.gettimestr(lefttime));
            var per = global.request[contextLevel].gettimeper();
            var per1 = per/10;
            var per2 = per%10;
            qlabel.text(str(per1)+"."+str(per2)+"%");
            qfiller.size(per1 * 165/100,20);
        }
        else if(flagquick < 2){
            flagquick++;
        }
        else if(flagquick == 2){
            global.user.changeValueAnimate(global.request[global.currentLevel].baseobj,"caesars",-costcae,0);
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