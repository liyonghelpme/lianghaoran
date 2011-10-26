class BuildObject extends ContextObject{
    var state;
    var state2;
    var bid;
    var objid;
    var begintime;
    var lefttime;

    var baseobj;
    var lockNode;
    var stateNode;

    var lock;
    var select;

    var slabel;
    var sfilter;

    var flagquick;
    var flagmulti;
    var buildname;
    var buildindex;
    
    var minuslock=0;
    var mstate=0;
    var mstate2=0;

    function initwithbase(b){
        contextname = "object-build-base";
        contextNode = null;
        stateNode = null;
        baseobj = b;
        lock = 0;
        select = 0;
        contextLevel = 0;
        flagquick = 0;
        flagmulti = 0;
        sfilter = null;
        slabel = null;
    }

    function loaddata(s,id,oid,b){
        state = s;
        bid = id;
        objid = oid;
        begintime = time()/1000 - b;
        lefttime = 1;
        state2 = 0;
        sfilter = null;
    }

    function paintNode(){
        contextNode = sprite(buildname+str(bid)+".png",ALPHA_TOUCH);
        contextNode.setevent(EVENT_HITTEST,objSelected);
        contextNode.setevent(EVENT_MOVE,objSelected);
        contextNode.setevent(EVENT_UNTOUCH,objSelected);
        contextNode.setevent(EVENT_TOUCH,objSelected);
        contextNode.setevent(EVENT_MULTI_TOUCH,objSelected);
        contextNode.setevent(EVENT_MULTI_UNTOUCH,objSelected);
        contextNode.prepare();
        setstate();
    }

    function objSelected(n,e,p,x,y,ps){
        if(contextLevel >= global.currentLevel && lock ==0 ){
            if(global.context[0].flagbuild!=0){
                return baseobj.objSelected(n,e,p,x,y);
            }
            if(global.context[0].flagfriend == 1 && (state!=3||(state2!=1 && state2!=2)))
                return 0;
            if(e == EVENT_HITTEST){
                if(n == stateNode && state!=2 && state!=4)
                    return 0;
                return 1;
            }
            else if(e == EVENT_TOUCH){
                select = 1;
                var c = n.node2world(x,y);
                c = global.context[0].getNode().world2node(c[0],c[1]);
                global.context[0].nodeMoveEvent(n,EVENT_TOUCH,p,c[0],c[1],ps);
                flagmulti = 0;
                return 1;
            }
            else if(e==EVENT_MULTI_TOUCH){
                select = 0;
                flagmulti++;
                var p0 = ps.get(0);
                p0 = n.node2world(p0[0],p0[1]);
                p0 = global.context[0].contextNode.world2node(p0[0],p0[1]);
                ps.update(0,p0);
                p0 = ps.get(1);
                p0 = n.node2world(p0[0],p0[1]);
                p0 = global.context[0].contextNode.world2node(p0[0],p0[1]);
                ps.update(1,p0);
                global.context[0].nodeMoveEvent(n,EVENT_MULTI_TOUCH,0,0,0,ps);
                return 1;
            }
            else if(e== EVENT_MULTI_UNTOUCH){
                flagmulti--;
                p0 = ps.get(0);
                p0 = n.node2world(p0[0],p0[1]);
                p0 = global.context[0].contextNode.world2node(p0[0],p0[1]);
                ps.update(0,p0);
                p0 = ps.get(1);
                p0 = n.node2world(p0[0],p0[1]);
                p0 = global.context[0].contextNode.world2node(p0[0],p0[1]);
                ps.update(1,p0);
                global.context[0].nodeMoveEvent(n,EVENT_MULTI_UNTOUCH,0,0,0,ps);
                return 1;
            }
            else if(e == EVENT_MOVE){
                if(select == 1){
                    var coor = n.size();
                    if(x <0 || y <0 || x>coor[0] || y>coor[1])
                        select = 0;
                }
                else{
                    var c2 = n.node2world(x,y);
                    c2 = global.context[0].getNode().world2node(c2[0],c2[1]);
                    if(flagmulti==1){
                        p0 = ps.get(0);
                        p0 = n.node2world(p0[0],p0[1]);
                        p0 = global.context[0].contextNode.world2node(p0[0],p0[1]);
                        ps.update(0,p0);
                        p0 = ps.get(1);
                        p0 = n.node2world(p0[0],p0[1]);
                        p0 = global.context[0].contextNode.world2node(p0[0],p0[1]);
                        ps.update(1,p0);
                    }
                    global.context[0].nodeMoveEvent(n,EVENT_MOVE,p,c2[0],c2[1],ps);
                }
                return 0;
            }
            else if(e == EVENT_UNTOUCH && select == 0){
                global.context[0].nodeMoveEvent(n,EVENT_UNTOUCH,0,0,0,ps);
                return 0;
            }
            lock = 1;
            if(state == 4){
                objectinterface(4,null);
            }
            else if(state==3 &&state2 != 3 && state2 != 0){
                global.http.addrequest(0,"eliminusstate",["uid","city_id","grid_id"],[global.userid,global.context[0].ccid,baseobj.posi[0]*RECTMAX+baseobj.posi[1]],self,"eliminus");
            }
            else if(state != 0){
                global.pushContext(self,new BuildControl(buildindex,self),AutoPop);
                lock=0;
            }
            setstate();
        }
    }

    function objectinterface(s,p){
    }

    function eliminusstateover(r,rc,c){
        trace("eliminus",rc,c);
        if(rc!=0){
            state2 = 3;
            if(json_loads(c).get("id",1)==1){
                var lev=global.user.getValue("level");
                global.user.changeValueAnimate2(baseobj.contextNode,"exp",(lev+9)/10,0);
                global.user.changeValueAnimate2(baseobj.contextNode,"money",50+(lev-1)/10*20,2);
                if(global.task.tasktype == 6 && global.context[0].ccid!=global.cityid){
                    global.task.inctaskstep(1);
                }
            }
        }
        lock = 0;
        setstate();
    }

    function reloadNode(re){
        if(re!= null && state == 2){
            lock=1;
            objectinterface(2,re);
        }
        setstate();
    }

    function beginbuild(){
        flagquick = 0;
        if(contextNode!=null){
            contextNode.texture(buildname+str(bid)+".png",UPDATE_SIZE,ALPHA_TOUCH);
            contextNode.prepare();
        }
        lock = 0;
        setstate();
    }
    
    var isAnimating;

    function setstate(){
        if(contextNode == null){
            return 0;
        }
        if(state == 1)
            contextNode.color(40,40,40,100);
        else if(state > 1)
            contextNode.color(50,50,60,100);
        else
            contextNode.color(50,50,50,50);
        if(stateNode == null){
            stateNode = baseobj.contextNode.addsprite("",ALPHA_TOUCH).anchor(50,100).color(50,50,60,100);
            stateNode.setevent(EVENT_HITTEST,objSelected);
            stateNode.setevent(EVENT_MOVE,objSelected);
            stateNode.setevent(EVENT_UNTOUCH,objSelected);
            stateNode.setevent(EVENT_TOUCH,objSelected);
            stateNode.setevent(EVENT_MULTI_TOUCH,objSelected);
            stateNode.setevent(EVENT_MULTI_UNTOUCH,objSelected);
            lockNode=null;
        }
        if(lockNode!=null && lock==0){
            lockNode.removefromparent();
            lockNode.addaction(stop());
            lockNode = null;
        }
        else if(lock == 1){
            if(lockNode==null){
                lockNode = sprite("wait1.png").anchor(50,50).size(75,75).pos(baseobj.contextid*33+1,0);
                lockNode.add(sprite("lock1.png").size(75,75),-1);
                if(buildindex == 4 && bid%4!=1&&bid<20){
                    lockNode.pos(baseobj.contextid*33+1,54);
                }
                lockNode.addaction(waitaction1);
                stateNode.texture();
                contextNode.add(lockNode);
            }
            return 0;
        }
        if(state > 0){
            if(state == 1){
                stateNode.size(102,20).texture("buildingback.png").pos(baseobj.contextid*33+1,baseobj.contextid*33-contextNode.size()[1]);
                if(buildindex == 4 && bid%4!=1&&bid<20){
                    stateNode.pos(baseobj.contextid*33+1,baseobj.contextid*33-contextNode.size()[1]+54);
                }
                stateNode.addaction(sequence(iscaleto(100,100),stop()));
            }
            else{
                if(sfilter != null){
                    slabel.removefromparent();
                    sfilter.removefromparent();
                    sfilter = null;
                    slabel = null;
                }
                objectsetstate();
                stateNode.prepare();
                stateNode.addaction(sequence(delaytime(rand(2000)),stop(),repeat(scaleto(750,125,125),delaytime(500),scaleto(750,100,100))));
            }
        }
        else{
            if(sfilter != null){
                slabel.removefromparent();
                sfilter.removefromparent();
                sfilter = null;
                slabel = null;
            }
            stateNode.texture();
        }
        if(global.context[0].flagfriend == 1 && (state!=3||(state2!=1 && state2!=2))){
            stateNode.visible(0);
        }
        else{
            stateNode.visible(global.system.flagnotice);
        }
    }

    function objectsetstate(){
        stateNode.texture();
    }

    function sreload(){
        if(sfilter == null){
            sfilter = stateNode.addsprite("buildingfilter.png").size(1,16).pos(2,2);
            slabel = stateNode.addlabel("0.0%",null,15).anchor(50,50).pos(51,10).color(100,100,100,100);
        }
        var per = gettimeper();
        var per1 = per%10;
        var per2 = per/10;
        slabel.text(str(per2)+"."+str(per1)+"%");
        sfilter.size(per/10,16);
    }

    function buildfinish(r,rc,c){
        if(rc!=0 && json_loads(c).get("id")==1){
            updatestate();
        }
        lock = 0;
        setstate();
    }

    function objectgettime(){
    }

    function timerefresh(){
        var alltime;
        alltime = objectgettime();
        lefttime = alltime+begintime-time()/1000;
        if(flagquick == 1){
            flagquick = 0;
            updatestate();
        }
        else if(lefttime <= 0){
            if(state == 1 && lock==0){
                lock = 1;
                if(global.context[0].flagfriend==0){
                    global.http.addrequest(0,"finish_building",["user_id","city_id","grid_id"],[global.userid,global.cityid,baseobj.posi[0]*RECTMAX+baseobj.posi[1]],self,"buildfinish");
                }
                else if(global.context[0].flagfriend>=1){
                    buildfinish(0,1,"{'id':1}");
                }
            }
            else if(state == 1)
                lefttime = 0;
            else
                updatestate();
        }
        else if(state == 1)
            sreload();
        else if(state == 3 && state2==0 && mstate+4*(lefttime-1)/alltime <4){
            refreshminus();
        }
    }
    function refreshminus(){
        if(minuslock==1){
            return 0;
        }
        var per = gettimeper();
        if(per < 250){
            mstate = 1;
            mstate2 =-1;
        }
        else if(per < 500){
            mstate = 2;
            mstate2 = rand(12)-8;
        }
        else if(per < 750){
            mstate = 3;
            mstate2 = rand(8)-4;
        }
        else{
            mstate = 4;
            mstate2 = rand(4);
        }
        if(mstate2 < 0){
            return 0;
        }
        minuslock = 1;
        if(mstate2 <= 1){
            mstate2 = mstate2%2+1;
        }
        else{
            mstate2 = 3;
        }
        //var rdict = dict();
        //rdict.update("name","addminusstate");
        //rdict.update("builds",[self]);
        //rdict.update("city",global.context[0].ccid
        //global.context[0]
        if(rand(10)==5)
            global.http.addrequest(0,"addminusstate2",["city_id","type","grid_id"],[global.context[0].ccid,mstate2,baseobj.posi[0]*RECTMAX+baseobj.posi[1]],self,"addminus");
    }

    function gettimeper(){
        var alltime = objectgettime();
        if(alltime == 0) return 1000;
        return (alltime-lefttime)*1000/alltime;
    }

    function gettexture(){
        return buildname+str(bid)+".png";
    }

    function updatestate(){
        state2=0;
        if(state < 4)
            state = state+1;
        setstate();
    }
    
    function useaction(p,rc,c){
        if(p=="state4over"){
            self.state4over(0,rc,c);
        }
        else if(p=="state2over"){
            self.state2over(0,rc,c);
        }
        else if(p=="buildfinish"){
            buildfinish(0,rc,c);
        }
        else if(p=="addminus"){
            addminus(0,rc,c);
        }
        else if(p=="eliminus"){
            eliminusstateover(0,rc,c);
        }
    }
    
    function addminus(r,rc,c){
        trace("addminus",rc,c);
        if(rc!=0 && json_loads(c).get("id",1)!=0){
            state2 = mstate2;
        }
        else{
            state2 = 3;
        }
        minuslock = 0;
        setstate();
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        contextNode = null;
    }
}