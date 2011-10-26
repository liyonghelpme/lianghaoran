import element.Monstercomplete;
import element.Monsterrefresh;

class MonsterController extends ContextObject{
    var monsters;
    var monsternum;
    var endtime;
    var isShown;
    var isTiming;
    var timelabel;
    var monsterbutton;
    var timeisend;
    var mlevel;
    var mbaselevel = [0,0,0,0,0,0,0,0,0,0];
    function MonsterController(){
        contextname = "monstercontroller";
        monsters = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
        mlevel = -1;
        monsternum = 0;
        isShown = 0;
        isTiming=0;
        timeisend= 0;
    }
    
    function initdata(mstr,mtime){
        monsternum = 0;
        if(mstr!=null && mstr!=""){
            var mstr_objs = mstr.split(";");
            for(var i=0;i<len(mstr_objs);i++){
                var mstr_obj = mstr_objs[i].split(",");
                var mi =int(mstr_obj[0]);
                if(int(mstr_obj[1])>=10){
                    continue;
                }
                monsters[int(mstr_obj[1])] = mi;
                if(mi>-1){
                    monsternum++;
                }
            }
            refreshmblevel();
        }
        else{
            monsters = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
        }
        if(monsternum != 0){
            endtime = 0;
        }
        else{
            endtime = global.timer.times2c(mtime);
            trace(endtime,mtime);
            timeisend=2;
            if(isTiming==0){
                isTiming = 1;
                global.timer.addlistener(endtime,self);
                trace("addtimer");
            }
        }
    }
    function show(){
        if(global.currentLevel>=1 && global.context[1].contextname == "page-map" && monsternum ==0){
            global.context[1].contextNode.add(getNode().pos(230,-112),0);
            contextNode.get(1).scale(100,100);
            isShown = 1;
        }
    }
    function close(){
        if(isShown == 1 && contextNode!=null){
            contextNode.removefromparent();
            contextNode = null;
            isShown=0;
        }
    }
    var bvalue =5;
    function paintNode(){
        contextNode = sprite("mapleftmenuback.png").anchor(50,0);
        contextNode.add(sprite("mapleftmenubutton.png").anchor(50,50).pos(180,172),0,1);
        contextNode.setevent(EVENT_UNTOUCH,monsterbarvisible);
        contextNode.addlabel("下一波怪兽来袭倒计时",null,20).pos(30,126).color(0,0,0,100);
        timelabel = contextNode.addlabel(global.gettimestr(endtime-time()/1000),null,20).pos(240,126).color(0,0,0,100);
        var btname = ["延迟一天","立即刷怪"];
        if(mlevel<40){
            bvalue=mlevel/10+1;
        }
        for(var i=0;i<2;i++){
            var tab=contextNode.addsprite("mapleftmenutab0.png").anchor(50,50).pos(104+152*i,62);
            tab.addlabel(btname[i],null,20).anchor(50,50).pos(63,18).color(0,0,0,100);
            tab.addsprite("caesars_big.png").anchor(50,50).pos(36,63);
            tab.addlabel(str(bvalue),null,18).color(0,0,0,100).anchor(0,50).pos(70,63);
            tab.setevent(EVENT_TOUCH,tabclicked,i);
            tab.setevent(EVENT_UNTOUCH,tabclicked,i);
        }
    }
    function tabclicked(n,e,p){
        if(e==EVENT_TOUCH){
            n.texture("mapleftmenutab1.png");
        }
        else if(e==EVENT_UNTOUCH){
            n.texture("mapleftmenutab0.png");
                if(global.user.getValue("caesars")<bvalue){
                    global.pushContext(null,new Warningdialog(dict([["ok",0],["凯撒币",bvalue-global.user.getValue("caesars")]])),NonAutoPop);
                    return 0;
                }
                if(p==0){
                    global.http.addrequest(1,"delaymonster",["uid"],[global.userid],self,"delaymonster");
                }
                else if(p==1){
                    var mstr = refreshmonsters();
                    timeisend=1;
                    isTiming = 0;
                    global.http.addrequest(1,"speedupmonster",["uid","monsterstr"],[global.userid,mstr],self,"speedupmonster");
                }
        }
    }
    
    function refreshmblevel(){
        var i;
        //if(mlevel<60){
            for(i=0;i<10;i++){
                if(monsters[i]>=0){
                    mbaselevel[i]=monsters[i]%3;
                }
            }
        //}
    }
    
    function refreshmlevel(){
        var i;
        if(mlevel<60){
            var mnum=[[10,0,0],[7,3,0],[4,5,1],[0,7,3],[0,3,7]];
            mnum = mnum[mlevel%5];
            for(i=0;i<10;i++){
                var tmp=rand(10-i);
                if(tmp<mnum[0]){
                    mnum[0]--;
                    mbaselevel[i]=0;
                }
                else if(tmp<mnum[0]+mnum[1]){
                    mnum[1]--;
                    mbaselevel[i]=1;
                }
                else{
                    mnum[2]--;
                    mbaselevel[i]=2;
                }
            }
            return 0;
        }
        else{
            for(i=0;i<10;i++){
                mbaselevel[i]=rand(3);
            }
        }
    }
    
    function refreshmonsters(){
        mlevel++;
        var i;
        var mstr="";
        refreshmlevel();
        if(mlevel<60){
            var ml=mlevel/5;
            for(i=0;i<10;i++){
                monsters[i]=mbaselevel[i]+ml*3;
                mstr = mstr+";"+str(monsters[i])+","+str(i);
            }
        }
        else{
            for(i=0;i<10;i++){
                monsters[i] = mbaselevel[i]+rand(12)*3;
                mstr = mstr+";"+str(monsters[i])+","+str(i);
            }
        }
        return substring(mstr,1);
    }
    
    function monsterbarvisible(n,e,p,x,y){
        if(y>112){
            var ps = n.pos();
            if(ps[1] == 0){
                n.addaction(moveto(200,230,-112));
                n.get(1).addaction(sequence(delaytime(200),scaleto(200,100,100)));
            }
            else{
                n.addaction(moveto(200,230,0));
                n.get(1).addaction(sequence(delaytime(200),scaleto(200,100,-100)));
            }
        }
    }
    function timerefresh(){
        if(isShown == 1){
            timelabel.text(global.gettimestr(endtime-time()/1000));
        }
        else{
        trace(global.currentLevel,global.context[global.currentLevel].contextname,monsternum);
            if(global.currentLevel==1 && global.context[1].contextname == "page-map"){
                self.show();
            }
        }
    }
    function timeend(){
        if(endtime != 0){
            if(isShown == 1){
                timelabel.text("马上来临");
            }
            var mstr = refreshmonsters();
            global.http.addrequest(0,"monsterrefresh",["userid","monsterstr"],[global.userid,mstr],self,"refreshover");
        }
        isTiming=0;
    }
    
    function refreshover(r,rc,c){
        trace("monsterrefresh",rc,c);
        if(rc!=0 && json_loads(c).get("id",1)!=0){
            if(r==1){
                global.user.changeValue("caesars",-bvalue);
            }
            var maxlevel=0;
            monsternum=10;
            for(var i=0;i<len(monsters);i++){
                if(MONSTER_POWER[monsters[i]]>MONSTER_POWER[maxlevel]){
                    maxlevel = monsters[i];
                }
            }
            endtime=0;
            if(global.currentLevel>0 && global.context[1].contextname == "page-map"){
                global.context[1].refreshmonster();
                close();
            }
            var cdict = dict();
            cdict.update("name","monsterrefresh");
            cdict.update("max",maxlevel);
            global.context[0].addcmd(cdict);
            sprite().addaction(sequence(delaytime(60000),callfunc(askforrob)));
        }
    }
    
    function askforrob(){
        if(global.system.flagrob==0){
            global.http.addrequest(0,"foodlost",["uid"],[global.userid],global.context[0],"foodlost");
        }
    }
    
    function delaymonster(r,rc,c){
        trace("delay",rc,c);
        if(rc!=0 && json_loads(c).get("id",1)!=0){
            global.user.changeValue("caesars",-bvalue);
            endtime = endtime + 86400;
            timeisend = 2;
        }
    }
    
    function useaction(p,rc,c){
        if(p=="refreshover"){
            refreshover(0,rc,c);
        }
        else if(p=="delaymonster"){
            delaymonster(0,rc,c);
        }
        else if(p=="speedupmonster"){
            refreshover(1,rc,c);
        }
        else if(p=="monstercomplete"){
            monstercomplete(0,rc,c);
        }
    }
    
    function monstercomplete(r,rc,c){
        if(rc!=0){
            var data = json_loads(c);
            if(data.get("id",1)==0){
                return;
            }
            var t = data.get("monstertime");
            initdata(null,t);
        }
    }
    
    function defeatmonster(i){
        if(global.flagnew == 1){
            return;
        }
        if(monsters[i] > -1){
            monsters[i] = -1;
            monsternum--;
            trace("monster left",monsternum);
        }
            if(monsternum ==0){
                global.http.addrequest(1,"monstercomplete",["uid"],[global.userid],self,"monstercomplete");
            }
    }
}