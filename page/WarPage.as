import element.UserControl;
import element.NobattleControl;
import element.Waraboutinfo;
class WarPage extends ContextObject{

    var lastpoint;
    var lastlength;
    var lastclicktime=0;
    var mode;

    var menu;
    var topmenu;
    var leftmenu;
    var leftbutton;
    var rightmenu;
    var rightbutton;

    var flagmulti;
    var flagmove;

    var select;
    var places;
    var pn;
    var placesNode;
    var baseNode;
    var placedict;
    var userdict;
    var atklist;
    var winlist;
    var won;
    var lost;
    var nobility;
    var level;
    var selfgid;
    var left;
    const eplace=[[178,165],[199,584],[406,429],[478,188],[707,553],[868,173],[1011,640],[1040,311]];
    const oplace=[[93,80],[1133,86],[903,572],[714,91],[93,436],[638,340],[472,642]];
    var initlock;
    var subnobility;
    var WS_MIN = -20;
    function WarPage(){
        contextname = "page-war";
        contextNode = null;
        rightmenu = null;
        lastpoint = null;
        flagmulti = 0;
        flagmove = 1;
        mode = 0;
        pn = 0;
        select = 0;
        placesNode = null;
        placedict = dict();
        userdict = dict();
        selfgid = 8;
        initlock = 0;
        image = dict();
    }

    function paintNode(){
        global.system.pushmusic("3.mp3");
        contextNode = sprite("wartexture.png",ARGB_8888).size(800,480).anchor(50,50).pos(-400,240);
        baseNode = contextNode.addsprite().color(0,0,0,0);
        contextNode.addsprite("warbackright.png",ARGB_8888).anchor(100,0).pos(800,0);
        left=global.dialogscreen.addsprite("warbackleft.png",ARGB_8888).pos(-67,0);
        contextNode.setevent(EVENT_TOUCH,nodeMoveEvent);
        contextNode.setevent(EVENT_UNTOUCH,nodeMoveEvent);
        contextNode.setevent(EVENT_MULTI_TOUCH,nodeMoveEvent);
        contextNode.setevent(EVENT_MULTI_UNTOUCH,nodeMoveEvent);
        contextNode.setevent(EVENT_MOVE,nodeMoveEvent);
        contextNode.addaction(sequence(moveby(400,67,0),moveby(600,733,0),callfunc(animateover)));
        left.addaction(moveby(400,67,0));
        initlock++;
    }
    
    function animateover(){
        initlock--;
        global.screen.visible(0);
        left.removefromparent();
        contextNode.add(left,1);
    }
    
    function keydownhandle(n,e,p,kc){
        if(kc==4){
            nodemovewithgid(selfgid);
        }
    }
    var flagisinit;
    function initover(timer){
        var loadingpage = global.dialogscreen.get(10);
        if(loadingpage!=null){
            if(percentmax<90){
                percentmax = global.image.imageindex*90/global.image.imagemax;
            }
            else if(initlock<2&&percentmax<100){
                percentmax = 100;
                if(flagisinit==1){
                    global.user.setValue("nobility",0);
                    global.context[0].refreshbuttons();
                    global.pushContext(null,self,NonAutoPop);
                }
            }
            percent = percent+4+rand(3);
            if(percent>percentmax){
                percent = percentmax;
            }
            loadingpage.get(1).text("正在加载战争数据，请稍候..."+str(percent)+"%");
            loadingpage.get(2).size(8*percent,12);
            if(percent==100){
                loadingpage.removefromparent();
                loadingpage=null;
                if(global.wartask.wartaskid==0){
                    global.wartask.enterwartask();
                }
                else{
                    var db = c_opendb(0,"flag");
                    if(db.get("mapnew")==1){
                        db.put("mapnew",0);
                        global.pushContext(null,new Warningdialog(["恭喜你进入了新的地图！提示：不要太快进入更高等级的地图哦，先暗中积攒兵力吧^_^",null,3]),NonAutoPop);
                    }
                }
            }
        }
        if(initlock==-1&&loadingpage==null){
            timer.stop();
            rightmenu.removefromparent();
            left.get(0).removefromparent();
            menu.removefromparent();
            refreshmap(1);
            initialMenu();
            nodemovewithgid(selfgid);
            return 0;
        }
        if(initlock != 0 || loadingpage!=null){
            return 0;
        }
        timer.stop();
        nodemovewithgid(selfgid);
        contextNode.setevent(EVENT_KEYDOWN,keydownhandle);
        baseNode.addaction(tintto(800,100,100,100,100));
        initialMenu();
        initlock = -1;
    }

    var inite = 0;
    var percentmax;
    var percent;
    function initialdata(){
        if(inite==0){
            if(global.user.getValue("nobility")<0){
                flagisinit=1;
            }
            else{
                flagisinit=0;
            }
            percentmax = 0;
            percent = 0;
            var loadingpage = sprite("loadingwarback.jpg").size(800,480).setevent(EVENT_TOUCH,donothing);
            loadingpage.add(label("正在加载战争数据，请稍候... 0%",null,20).anchor(50,100).pos(400,445).color(0,0,0,100),0,1);
            loadingpage.add(sprite("loadingbar.png").pos(0,450).size(1,12),0,2);
            global.dialogscreen.add(loadingpage,10,10);
            initlock=initlock+2;
            global.http.addrequest(0,"warinfo",["userid"],[global.userid],self,"initialover");
            //global.http.addrequest(0,"warrecord",["uid"],[global.userid],self,"getrecordover");
            inite=1;
        }
        c_addtimer(200,initover);
    }
    
    function useaction(p,rc,c){
        if(p=="initialover"){
            initialover(0,rc,c);
        }
        else if(p=="refresh"){
            var data = json_loads(c);
            if(data.get("id")==0){
                return 0;
            }
            global.mapid = data.get("mapid");
            global.card[12] = global.user.getValue("nobility")+data.get("minus",1)*100;
            if(inite==1){
                inite=0;
            }
        }
        else if(p=="getrecordover"){
            //global.user.setValue("warrecord",json_loads(c));   
        }
    }

    function initialover(r,rc,c){
trace("warinfo",rc,c);
        initlock=initlock-2;
        trace("net unlock",initlock);
        if(rc!=0){
            userdict.clear();
            var data = json_loads(c);
            if(data.get("id",1)!=0){
                selfgid = data.get("gridid",4);
                nobility = data.get("nobility",0);
                won = data.get("won",0);
                var mappn = [1,2,3,4,5,8,10];
                pn=mappn[nobility];
                if(pn>1){
                    WS_MIN=-60;   
                }
                var list = data.get("list",[[887077,0,0,1,"linan",0,0]]);
                subnobility = data.get("subno",0);
                global.user.setValue("nobility",nobility*3+subnobility);
                global.user.setValue("nobattletime",data.get("protect"));
                userdict.update(selfgid,[str(global.context[0].cpid),0,nobility,selfgid,global.user.getValue("cityname"),global.userid,subnobility,0,1]);
                atklist = new Array(0);
                for(var i=0;i<len(list);i++){
                    userdict.update(list[i][3],list[i]);
                    if(list[i][8]==0){
                        atklist.append(list[i]);
                    }
                }
            }
        }
    }

    function boolrand(n,b){
        var m=8126553;
        for(var i=0;i<=n;i++){
            m = (m*(361+global.mapid*11)-53244)/(169+b);
        }
        return m;
    }

    function setuserflag(gid){
        var userplace=placedict.get(gid/8);
        if(userplace == null) return 0;
        var user=userdict.get(gid);
        var flagn = userplace.get(gid%8).get(2);
        var m=0;
        var length = len(global.battlelist);
        for(var i=0;i<length;i++){
            if(global.battlelist[i][2]==1&&global.battlelist[i][1] == user[0]){
                m=1;
                break;
            }
        }
        if(m==0){
            flagn.texture("flagother.png").anchor(0,100).pos(117,125);
            if(user[8]==1){
                flagn.addaction(repeat(animate(1000,"flag1.png","flag2.png","flag3.png","flag4.png","flag5.png","flag6.png",UPDATE_SIZE)));
            }
        }
        else{
            flagn.addaction(repeat(animate(1000,"battle1.png","battle2.png","battle3.png","battle4.png","battle5.png","battle6.png","battle7.png","battle8.png","battle9.png",UPDATE_SIZE)));
        }
        flagn = userplace.get(gid%8).get(1);
        if(user[8]==1){
            flagn.texture("mapelement1.png");
        }
        else if(m==1){
            flagn.texture("mapelement2.png");
        }
        else if(global.timer.times2c(user[7])>global.timer.currenttime){
            flagn.texture("mapelement3.png");
        }
        else{
            flagn.texture("mapelement0.png");
        }   
    }
        


    function addplace(x,y){
        var s=sprite(getimage("warback.png"),ARGB_8888).size(1204,724).pos(1200*y,720*x);/*
        if(x==-1||x==pn||y==-1||y==pn){
            if(x==-1){
                if(y==-1)
                    s.addsprite("mapback-5.png",ARGB_8888).anchor(100,100).pos(1204,724).scale(100,100);
                else if(y==pn)
                    s.addsprite("mapback-5.png",ARGB_8888).anchor(100,100).pos(0,724).scale(-100,100);
                else{
                    s.addsprite("mapback-1.png",ARGB_8888).anchor(0,100).pos(0,724).scale(400,100);
                }
            }
            else if(x==pn){
                if(y==-1)
                    s.addsprite("mapback-5.png",ARGB_8888).anchor(100,100).pos(1204,0).scale(100,-100);
                else if(y==pn)
                    s.addsprite("mapback-5.png",ARGB_8888).anchor(100,100).pos(1204,724).scale(-100,-100);
                else{
                    s.addsprite("mapback-2.png",ARGB_8888).anchor(100,0).pos(0,0).scale(-100,400);
                }
            }
            else if(y==-1){
                s.addsprite("mapback-2.png",ARGB_8888).anchor(100,0).pos(1204,0).scale(100,400);
            }
            else{
                s.addsprite("mapback-1.png",ARGB_8888).anchor(0,100).pos(0,0).scale(400,-100);
            }
            baseNode.add(s);
            placedict.update(10001+(x+1)*(pn+2)+y,s);
            return 0;
        }*/
        var blockid=x*pn+y;
        baseNode.add(s,10000-blockid);
        placedict.update(blockid,s);
        var objlist = [0,0,1,2,2,3+abs(boolrand(3,y)%2),4-abs(boolrand(4,x)%2)];
        var objlev = [0,0,0,0,0,0,0,0];
        for(var i=0;i<7;i++){
            if(boolrand(i,blockid)%2 == 1){
                continue;
            }
            objlev[i] = nobility/3+1;
            var j=boolrand(i+8,blockid)%3;
            if(j<nobility%3){
                objlev[i]++;
            }
        }
        for(var k=0;k<8;k++){
            var user = userdict.get(blockid*8+k,null);
            if(user!=null){
                var em = sprite(getimage("mapempirelv"+str((user[6]+user[2]*3+4)/3)+".png")).anchor(50,50).pos(eplace[k]).scale(85);
                s.add(em,2,k);
                var flagn = sprite(getimage("flagother.png")).anchor(0,100).pos(117,125);
                em.add(flagn,2,2);
                var fly = sprite(getimage("mapelement0.png")).anchor(50,50).pos(35,0);
                fly.addsprite(avatar_url(int(user[0]))).size(38,38).pos(15,11);
                var name = user[4];
                if(len(name)>9){
                    name = name[0]+name[1]+name[2]+name[3]+name[4]+name[5]+".."
                }
                fly.addlabel(name,null,16).anchor(50,0).pos(32,52).color(0,0,0,100);
                fly.color(50,50,50,50);
                em.add(fly,1,1);
                setuserflag(blockid*8+k);
                em.setevent(EVENT_HITTEST,objSelected,blockid*8+k);
                em.setevent(EVENT_UNTOUCH,objSelected,blockid*8+k);
                em.setevent(EVENT_MOVE,objSelected,blockid*8+k);
                em.setevent(EVENT_MULTI_TOUCH,objSelected,blockid*8+k);
                em.setevent(EVENT_MULTI_UNTOUCH,objSelected,blockid*8+k);
                if(k+blockid*8==selfgid){
                    if(global.flagnew == 1){
                        flagn.visible(0);
                    }
                    else{
                        em.texture("mapempirelv"+str((global.user.getValue("nobility")+4)/3)+"_self.png").scale(110);
                    }
                }
            }
            if(objlev[k] > 0){
                s.add(sprite(getimage("mapobj"+str(objlist[k])+"lv"+str(objlev[k])+".png")).anchor(50,50).pos(oplace[k]),1);
            }
        }
    }

    function removeplace(x,y){
        var key = x*pn+y;
        if(x==-1||x==pn||y==-1||y==pn){
            key=10001+(x+1)*(pn+2)+y;
        }
        var page=placedict.pop(key);
        destroynode(page);
    }

    function refreshmap(flag){
        var bp = baseNode.world2node(0,0);
        bp[0] = (bp[0]+1200)/1200-1;
        bp[1] = (bp[1]+720)/720-1;
        
        var ep = baseNode.world2node(800,480);
        ep[0] = ep[0]/1200;
        ep[1] = ep[1]/720;
        
        for(var x=-1;x<=pn;x++){
            for(var y=-1;y<=pn;y++){
                var i = x*pn+y;
                if(x==-1||x==pn||y==-1||y==pn){
                    i=10001+(x+1)*(pn+2)+y;
                }
                if(placedict.get(i)!=null){
                    if(flag==1||x<bp[1]||x>ep[1]||y<bp[0]||y>ep[0])
                        removeplace(x,y);
                }
                if(placedict.get(i)==null&&x>=bp[1]&&x<=ep[1]&&y>=bp[0]&&y<=ep[0])
                    addplace(x,y);
            }
        }
    }
    function objSelected(node,event,p,x,y,ps){
        if(contextLevel >= global.currentLevel){
            if(event == EVENT_HITTEST){
                select = 1;
                var c = node.node2world(x,y);
                c = contextNode.world2node(c[0],c[1]);
                nodeMoveEvent(node,EVENT_TOUCH,p,c[0],c[1],0);
                return 1;
            }
            else if(event==EVENT_MULTI_TOUCH){
                select = 0;
                var p0 = ps.get(0);
                p0 = node.node2world(p0[0],p0[1]);
                p0 = contextNode.world2node(p0[0],p0[1]);
                ps.update(0,p0);
                p0 = ps.get(1);
                p0 = node.node2world(p0[0],p0[1]);
                p0 = contextNode.world2node(p0[0],p0[1]);
                ps.update(1,p0);
                nodeMoveEvent(node,EVENT_MULTI_TOUCH,0,0,0,ps);
                return 1;
            }
            else if(event== EVENT_MULTI_UNTOUCH){
                p0 = ps.get(0);
                p0 = node.node2world(p0[0],p0[1]);
                p0 = contextNode.world2node(p0[0],p0[1]);
                ps.update(0,p0);
                p0 = ps.get(1);
                p0 = node.node2world(p0[0],p0[1]);
                p0 = contextNode.world2node(p0[0],p0[1]);
                ps.update(1,p0);
                nodeMoveEvent(node,EVENT_MULTI_UNTOUCH,0,0,0,ps);
                return 1;
            }
            else if(event == EVENT_MOVE){
                if(select == 1){
                    var coor = node.size();
                    if(x <0 || y <0 || x>coor[0] || y>coor[1])
                        select = 0;
                }
                else{
                    var c2 = node.node2world(x,y);
                    c2 = contextNode.world2node(c2[0],c2[1]);
                    if(ps!=null && len(ps)==3){
                        p0 = ps.get(0);
                        p0 = node.node2world(p0[0],p0[1]);
                        p0 = contextNode.world2node(p0[0],p0[1]);
                        ps.update(0,p0);
                        p0 = ps.get(1);
                        p0 = node.node2world(p0[0],p0[1]);
                        p0 = contextNode.world2node(p0[0],p0[1]);
                        ps.update(1,p0);
                    }
                    nodeMoveEvent(node,EVENT_MOVE,p,c2[0],c2[1],ps);
                }
                return 0;
            }
            else if(event == EVENT_UNTOUCH && select == 0){
                return 0;
            }
            if(p == selfgid && global.flagnew == 0)
                global.pushContext(self,new NobattleControl(),NonAutoPop);
            else
                global.pushContext(self,new UserControl(p),AutoPop);
        }
    }

    function reloadNode(re){
        if(re == -1){
            var m = placedict.get(selfgid/8).get(selfgid%8);
            m.texture("mapempirelv"+str((nobility*3+subnobility+4)/3)+"_self.png");
            m.get(2).visible(1);
        }
    }


    var lists;
    var tabs;

    function refreshnob(){
        if(rightmenu!=null){
            rightmenu.remove(11);
            var nob=global.user.getValue("nobility");
        var RIGHTOFF=40;
            rightmenu.add(global.getnobility(nob/3,nob%3).pos(88+RIGHTOFF,40),0,11);
        }
    }

    function initialMenu(){
        var RIGHTOFF=40;
        menu = contextNode.addsprite();

        rightmenu = menu.addsprite("warmenuback.png",ARGB_8888).anchor(100,0).pos(985,0).setevent(EVENT_TOUCH,wartabvisible);
        var listback=rightmenu.addsprite("warmenulistback.png").anchor(100,100).pos(253,480);
        lists = new Array(2);
        selecttab = 0;
        lists[0] = listback.addnode();
        lists[1] = listback.addnode().visible(0);
        listback.setevent(EVENT_UNTOUCH,listselect);
        listback.setevent(EVENT_TOUCH,listselect);
        listback.setevent(EVENT_MOVE,listselect);
        rightmenu.addsprite("warmenutop.png").anchor(100,0).pos(252,0);
        var mbutton = sprite("warmenubutton.png").anchor(50,50).pos(RIGHTOFF,240);
        rightmenu.add(mbutton,1,1);
        rightmenu.addsprite("wartabuser.png").pos(30+RIGHTOFF,12);
        rightmenu.addsprite(avatar_url(ppy_userid())).pos(33+RIGHTOFF,15).size(50,50);
        for(var i=0;i<3;i++){
            var b=rightmenu.addsprite("warbutton"+str(i)+"0.png").pos(30+RIGHTOFF+i*60,73);
            b.setevent(EVENT_UNTOUCH,buttonclicked,i);
            b.setevent(EVENT_TOUCH,buttonclicked,i);
            if(i==1){
                var n=b.addnode().pos(56,56);
                global.user.initMultiText("warrecordnum",n);
            }
        }
        rightmenu.addlabel(global.user.getValue("cityname"),null,20).anchor(0,50).pos(88+RIGHTOFF,25).color(0,0,0,100);
        rightmenu.add(global.getnobility(nobility,subnobility).pos(88+RIGHTOFF,40),0,11);
        tabs = new Array(2);
        tabs[0]=rightmenu.addsprite("warmenutab1.png").anchor(0,100).pos(27+RIGHTOFF,120+60).setevent(EVENT_UNTOUCH,tabchange,0);
        tabs[1]=rightmenu.addsprite("warmenutab0.png").anchor(100,100).pos(213+RIGHTOFF,120+60).setevent(EVENT_UNTOUCH,tabchange,1);
        rightmenu.addlabel("作战中",null,16).anchor(50,100).pos(73+RIGHTOFF,114+60).color(0,0,0,100);
        rightmenu.addlabel("可攻打",null,16).anchor(50,100).pos(159+RIGHTOFF,114+60).color(0,0,0,100);
        left.add(sprite("backbutton.png").anchor(0,100).pos(0,480).setevent(EVENT_UNTOUCH,goback),0,0);
        refreshlist();
    }
    
    function refreshlist(){
        var listnodes = lists[0].subnodes();
        if(type(listnodes)==2){
            for(var i=len(listnodes)-1;i>=0;i--){
                listnodes[i].removefromparent();
            }
        }
        listnodes = lists[1].subnodes();
        if(type(listnodes)==2){
            for(i=len(listnodes)-1;i>=0;i--){
                listnodes[i].removefromparent();
            }
        }
        var i0=1;
        var i1=0;
        var pidlist = new Array(0);
        var le = len(global.battlelist);
        var u=sprite("refreshcell.png").pos(5,15);
        u.setevent(EVENT_UNTOUCH,nodemovewithgidevent,-1);
        u.setevent(EVENT_TOUCH,nodemovewithgidevent);
        u.setevent(EVENT_MOVE,nodemovewithgidevent);
        lists[0].add(u);
        for(i=0;i<le;i++){
            pidlist.append(global.battlelist[i][1]);
            u = sprite();
            var udata = userdict.get(global.battlelist[i][3]);
            u.addsprite(avatar_url(int(udata[0]))).pos(5,5).size(40,40);
            u.addlabel(udata[4],null,16).pos(50,5).color(0,0,0,100);
            u.setevent(EVENT_UNTOUCH,nodemovewithgidevent,udata[3]);
            u.setevent(EVENT_TOUCH,nodemovewithgidevent);
            u.setevent(EVENT_MOVE,nodemovewithgidevent);
                lists[0].add(u.pos(5,15+i0*54));
                if(global.battlelist[i][0]>global.timer.currenttime){
                    u.addlabel(global.gettimestr(global.battlelist[i][0]-global.timer.currenttime),null,16).pos(105,25);
                    if(global.battlelist[i][2]==1){
                        u.texture("wartabperson_b.png");
                        u.addlabel("进攻中",null,16).pos(50,25);
                    }
                    else{
                        u.texture("wartabperson_r.png");
                        u.addlabel("防御中",null,16).pos(50,25);
                    }
                }
                else{
                        u.addlabel("正在作战",null,16).pos(50,25).color(0,0,0,100);
                }
                i0++;
        }
        le = len(atklist);
        for(i=0;i<le;i++){
            udata = atklist[i];
            var index = pidlist.index(udata[0]);
            if(index!=-1){
                continue;
            }
            u = sprite("wartabperson.png");
            u.addsprite(avatar_url(int(udata[0]))).pos(5,5).size(40,40);
            u.addlabel(udata[4],null,16).pos(50,5).color(0,0,0,100);
            u.addlabel(NOBNAME[udata[2]*3+udata[6]],null,16).anchor(100,100).pos(172,45).color(0,0,0,100);
            u.setevent(EVENT_UNTOUCH,nodemovewithgidevent,udata[3]);
            u.setevent(EVENT_TOUCH,nodemovewithgidevent);
            u.setevent(EVENT_MOVE,nodemovewithgidevent);
            lists[1].add(u.pos(5,15+i1*54));
            i1++;
        }
    }
    
    var lasty;
    function listselect(n,e,p,x,y){
        if(e == EVENT_TOUCH){
            lasty = y;
            return 1;
        }
        else if(e == EVENT_MOVE){
            var np=lists[selecttab].pos();
            lists[selecttab].pos(np[0],np[1]+y-lasty);
            lasty = y;
            return 1;
        }
        else if(e == EVENT_UNTOUCH){
            np = lists[selecttab].pos();
            var lt=0;
            var ln=lists[selecttab].subnodes();
            if(ln!=null){
                lt=len(ln);
            }
            if(np[1]<-54*(lt-5)){
                np[1] = -54*(lt-5);
            }
            if(np[1]>0){
                np[1] = 0;
            }
            lists[selecttab].pos(np);
        }
    }
    
    var selecttab;
    function tabchange(n,e,p){
        tabs[p].texture("warmenutab1.png");
        tabs[1-p].texture("warmenutab0.png");
        lists[p].visible(1);
        lists[1-p].visible(0);
        selecttab=p;
    }

    function buttonclicked(n,e,p){
        if(e == EVENT_TOUCH){
            n.texture("warbutton"+str(p)+"1.png");
        }
        else{
            n.texture("warbutton"+str(p)+"0.png");
            if(p==0){
                nodemovewithgid(selfgid);
            }
            else if(p==1){
                global.pushContext(self,new Waraboutinfo(0),NonAutoPop);
            }
            else if(p==2){
                global.pushContext(self,new Waraboutinfo(1),NonAutoPop);
            }
        }   
    }

    function nodemovewithgidevent(n,e,p,x,y){
            if(e == EVENT_TOUCH){
                flagmove = 0;
                var l = n.node2world(x,y);
                listselect(n,EVENT_TOUCH,null,l[0],l[1]);
                return 1;
            }
            else if(e== EVENT_MOVE){
                if(flagmove == 0){
                    if(x<0|| x>n.size()[0]||y<0||y>n.size()[1])
                        flagmove =1;
                    return 0;
                }
                else{
                    l = n.node2world(x,y);
                    listselect(n,EVENT_MOVE,0,l[0],l[1]);
                }
            }
            else if(e == EVENT_UNTOUCH){
                if(flagmove==0){
                    if(p==-1){
                        global.http.addrequest(1,"battlelist",["uid"],[global.userid],global.context[0],"battlelist");
                    }
                    else
                        nodemovewithgid(p);
                }
                else{
                    listselect(n,EVENT_UNTOUCH,0,0,0);
                }
            }
    }

    function wartabvisible(n,e,pa,x,y){
        if(x< 67){
            var p = rightmenu.pos();
            if(p[0] == 985){
                rightmenu.addaction(moveto(200,800,0));
                rightmenu.get(1).addaction(sequence(delaytime(200),scaleto(200,-100,100)));
            }
            else{
                rightmenu.addaction(moveto(200,985,0));
                rightmenu.get(1).addaction(sequence(delaytime(200),scaleto(200,100,100)));
            }
        }
    }

    function nodemovewithgid(gid){
        var mapid = gid/8;
        var gridid = gid%8;
        var p = baseNode.node2world(mapid%pn*1200+eplace[gridid][0],mapid/pn*720+eplace[gridid][1]);
        nodeMove(400-p[0],240-p[1]);
    }

    function sizeWithMode(){
        var p=baseNode.world2node(400,240);
        baseNode.scale(100+mode);
        var p2 = baseNode.node2world(p[0],p[1]);
        nodeMove(400-p2[0],240-p2[1]);
    }

    function sizeModeftAnimate(){
        if(mode<=20){
            sizeModeft(mode,50);
        }
        else{
            sizeModeft(mode,0);
        }
    }

    function nodeMoveEvent(node,event,param,x,y,points){
        if(contextLevel >= global.currentLevel){
            if(event == EVENT_TOUCH){
                lastpoint = contextNode.node2world(x,y);
            }
            else if(event == EVENT_MULTI_TOUCH){
                var p0 = points.get(0);
                var p1 = points.get(1);
                lastlength = sqrt((p0[0]-p1[0])*(p0[0]-p1[0])+(p0[1]-p1[1])*(p0[1]-p1[1]));
                lastpoint = contextNode.node2world((p0[0]+p1[0])/2,(p0[1]+p1[1])/2);
            }
            else if(event == EVENT_MULTI_UNTOUCH){
                if(len(points)==3){
                    var flg = 1-points.get(-1);
                    var pl = points.get(flg);
                    lastpoint = contextNode.node2world(pl[0],pl[1]);
                }
            }
            else if(event == EVENT_UNTOUCH){
                if(lastclicktime!=0 && time()-lastclicktime<400){
                    lastclicktime=0;
                    sizeModeftAnimate();
                }
                else{
                    lastclicktime = time();
                }
            }
            else if(event == EVENT_MOVE){
                if(points==null || len(points) != 3){
                    var point = contextNode.node2world(x,y);
                    var i = point[0]-lastpoint[0];
                    var j = point[1]-lastpoint[1];
         
                    nodeMove(i,j);
                    lastpoint = point;
                }
                else{
                    p0 = points.get(0);
                    p1 = points.get(1);
                    point = contextNode.node2world((p0[0]+p1[0])/2,(p0[1]+p1[1])/2);
                    nodeMove(point[0]-lastpoint[0],point[1]-lastpoint[1]);
                    lastpoint = point;
                    var length = sqrt((p0[0]-p1[0])*(p0[0]-p1[0])+(p0[1]-p1[1])*(p0[1]-p1[1]));
                    
                    var pm = length*(100+mode)/lastlength;
                    lastlength = length;
                    sizeModeft(mode,pm-100);
                }
            }
        }
    }
    function goback(){
        contextname = "";
        contextNode.add(node().size(800,480).setevent(EVENT_HITTEST,donothing));
        if(rightmenu.pos()[0]==800){
            wartabvisible(0,0,0,0,0);
        }
        baseNode.addaction(sequence(tintto(600,0,0,0,0),callfunc(releasenode)));
        contextNode.addaction(sequence(delaytime(600),moveby(600,-733,0),moveby(400,-67,0)));
        left.addaction(sequence(delaytime(1200),moveby(400,-67,0),callfunc(releasecontext)));
    }
    
    function releasecontext(){
        global.popContext(null);
        contextname = "page-war";
    }
    
    function releasenode(){
        baseNode.removefromparent();
        rightmenu.removefromparent();
        left.get(0).removefromparent();
        left.removefromparent();
        global.dialogscreen.add(left);
        global.screen.visible(1);
    }
    

    function getposbyid(id){
        var blockid = id/8;
        return [blockid/pn,blockid%pn*2+id%8/4];
    }

    function nodeMove(x,y){
        var c1 = baseNode.node2world(0,0);
        var c2 = baseNode.node2world(1200*pn,720*pn);
        if(c2[0]+x<800)
            x = 800-c2[0];
        if(c2[1]+y<480)
            y = 480-c2[1];
        if(c1[0]+x>0) x= -c1[0];
        if(c1[1]+y>0) y= -c1[1];
        baseNode.addaction(imoveby(x,y));
        refreshmap(0);
    }

    function sizeModeft(from,to){
        if((from == WS_MIN && to <= WS_MIN) || (from == MS_MAX && to>=MS_MAX))
            return 0;
        if(to <= WS_MIN){
            to=WS_MIN;
        }
        else if(to>=MS_MAX){
            to = MS_MAX;
        }
        mode = to;
        sizeWithMode();
    }

    function deleteContext(){
        contextNode.removefromparent();
        contextNode = null;
        baseNode.removefromparent();
        baseNode = null;
        global.system.popmusic();
        placedict.clear();
        global.screen.visible(1);
        left.removefromparent();
        initlock=0;
        mode= 0;
    }
}