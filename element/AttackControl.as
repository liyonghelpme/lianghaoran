class AttackControl extends ContextObject{
    var slabels;
    var soldiers;
    var soldiermaxs;
    var lastx;
    var eid;
    var atime;
    var btime;
    var slabel;
    var timelabel;
    function AttackControl(g){
        contextname = "dialog-battle-choosesoldier";
        contextNode = null;
        slabels = new Array(2);
        eid = g;
    }
    function paintNode(){
        soldiermaxs = [global.soldiers[0],global.soldiers[1]];
        soldiers = [0,0];
        contextNode = sprite("dialogback_attack.png").anchor(50,50).pos(400,240);
        contextNode.addlabel(str(soldiermaxs[0]+soldiermaxs[1]),null,20).anchor(0,50).pos(120,99).color(0,0,0,100);
        slabel = contextNode.addlabel(str(0),null,20).anchor(0,50).pos(383,99).color(0,0,0,100);
        var dtime = [[7200,14400,0],[5400,12600,14400],[4680,9000,11520],[3960,6480,8640],[3240,5400,7200],[1800,3240,4680]];
        //if(global.flagnew == 1) dtime = 0;
        var t=dtime[global.user.getValue("nobility")/3];
        var spos = global.context[1].getposbyid(global.context[1].selfgid);
        var epos = global.context[1].getposbyid(eid);
        trace(spos,epos);
        if(spos[0]==epos[0]&&spos[1]==epos[1]){
            atime = t[0];
        }
        else{
            var mw=abs(spos[1]/2-epos[1]/2);
            atime = t[2]*(abs(spos[0]-epos[0])+mw)+t[1]*(abs(spos[1]-epos[1])-mw);
        }
        timelabel = contextNode.addlabel(global.gettimestr(atime),null,20).anchor(0,50).pos(119,371).color(0,0,0,100);
        var bt = sprite("boxbutton1.png").anchor(50,50).pos(142,420).setevent(EVENT_UNTOUCH,attack);
        contextNode.add(bt,2,0);
        bt.addlabel("攻击",null,BUTTONFONTSIZE).anchor(50,50).pos(62,19);
        contextNode.addsprite("boxbutton2.png").anchor(50,50).pos(416,420).setevent(EVENT_UNTOUCH,closedialog);
        contextNode.addlabel("返回",null,BUTTONFONTSIZE).anchor(50,50).pos(416,420);
        for(var i=1;i>=0;i--){
            var mb = contextNode.addsprite("moveback.png").anchor(0,50).pos(57,175+i*88);
            mb.setevent(EVENT_TOUCH,csnum,i);
            mb.setevent(EVENT_MOVE,csnum,i);
            mb.addlabel(str(0),null,20).anchor(100,50).pos(-4,16).color(0,0,0,100);
            mb.addlabel(str(soldiermaxs[i]),null,20).anchor(0,50).pos(417,16).color(0,0,0,100);
            mb.add(sprite("moveblock.png").anchor(50,50).pos(79,16),1,0);
            slabels[i] = mb.addlabel("0",null,16).anchor(0,50).pos(59,-21).color(0,0,0,100);
        }
        if(global.flagnew == 0){
            csnum(mb,EVENT_TOUCH,0,70);
        }
        else{
            csnum(mb,EVENT_TOUCH,0,600);
        }
    }
    
    function csnum(n,e,p,x){
        var move = n.get(0);
        if(x>333) x = 333;
        else if(x<79) x = 79;
        var po = move.pos();
        move.pos(x,po[1]);
        soldiers[p] = soldiermaxs[p]*(x-79)/254;
        slabels[p].text(str(soldiers[p]));
        var tnum = soldiers[0]+soldiers[1];
        slabel.text(str(tnum));
        if(tnum == 0){
            contextNode.get(0).texture("boxbutton2.png");
            contextNode.get(0).setevent(EVENT_UNTOUCH,null);
        }
        else{
            contextNode.get(0).texture("boxbutton1.png");
            contextNode.get(0).setevent(EVENT_UNTOUCH,attack);
        }
        var bz = tnum;
        var b1 = soldiers[0];
        if(bz == 0){
            bz = 1;
            b1 = 1;
        }
        btime = 100*(bz+b1)/(2*bz)*atime/100;
        timelabel.text(global.gettimestr(btime));
    }
    
    function attack(){
        if(global.currentLevel == contextLevel){
            if(global.timer.times2c(global.user.getValue("nobattletime"))>global.timer.currenttime){
                global.pushContext(null,Warningdialog(["在保护期中攻打其他玩家，保护状态将会终止",1,1]),NonAutoPop);
                return 0;
            }
            var euid = global.context[1].userdict.get(eid)[5];
            global.http.addrequest(1,"attack",["uid","enemy_id","timeneed","infantry","cavalry"],[global.userid,euid,btime,soldiers[0],soldiers[1]],self,"attackover");
        }
    }
    
    function useaction(p,rc,c){
        if(p=="attackover"){
            attackover(0,rc,c);
        }
    }
    
    function attackover(r,rc,c){
        if(rc!=0){
            var data = json_loads(c);
            if(data.get("id",1)==1){
                global.soldiers[0] = global.soldiers[0] - soldiers[0];
                global.soldiers[1] = global.soldiers[1] - soldiers[1];
                var epid = global.context[1].userdict.get(eid)[0];
                global.popContext(null);
                var etime = global.timer.currenttime+btime;
                global.battlelist.append([etime,epid,1,eid,soldiers[0],soldiers[1]]);
                global.context[1].setuserflag(eid);
                global.context[1].refreshlist();
                global.user.setValue("nobattletime",0);
                global.pushContext(null,new Attackbegindialog(etime),NonAutoPop);
            }
            else{
                if(data.get("status")==0){
                    global.pushContext(null,new Warningdialog(["该玩家的领地正在受保护中",null,1]),NonAutoPop);
                    global.context[1].userdict.get(eid)[7] = data.get("endtime");
                    global.context[1].setuserflag(eid);
                }
                else if(data.get("status")==1){
                    global.pushContext(null,new Warningdialog(["你已经在进攻他了哦！",null,1]),NonAutoPop);
                }
                else if(data.get("status")==2){
                    global.pushContext(null,new Warningdialog(["你已经征服他了哦！",null,1]),NonAutoPop);
                }
                else if(data.get("status")==3){
                    global.pushContext(null,new Warningdialog(["抱歉，该玩家已经升级到更高等级的地图。",null,1]),NonAutoPop);
                    global.context[1].atklist.remove(global.context[1].userdict.pop(eid));
                    global.context[1].refreshmap(1);
                }
            }
        }
    }
    
    function closedialog(){
        if(global.currentLevel == contextLevel)
            global.popContext(null);
    }
    
    function reloadNode(re){
        if(re==1){
            var euid = global.context[1].userdict.get(eid)[5];
            global.http.addrequest(1,"attack",["uid","enemy_id","timeneed","infantry","cavalry"],[global.userid,euid,btime,soldiers[0],soldiers[1]],self,"attackover");
        }
    }
    
    function deleteContext(){
        contextNode.removefromparent();
        contextNode = null;
    }
}