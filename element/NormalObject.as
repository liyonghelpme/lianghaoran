import element.GodObject;
import element.RoomObject;
import element.FactObject;
import element.CampObject;
import element.FarmObject;
import element.StatueObject;
import element.EmpireControl;
import element.Adddefencedialog;
import element.NestObject;
import element.PetRename;
import element.Petstate4;
import element.Nestbuilddialog;

import element.BuildObject;
class NormalObject extends ContextObject{
    var contextid;
    var objectid;
    var posi;

    var backnode;
    var objnode;
    var statenode;
    var extendnode;
    var state;

    var lock;
    var select;

    var lastpoint;
    var cposi;
    var posused;

    var flagnew;
    var flagrect;
    var flagmove;

    var lasttime;
    var flagmulti;
    var buildcontextname;

    function NormalObject(id,l,r){
        contextname = "object-build-normal";
        if(id<0){
            trace("meet nest1");
            objectid=-id;
            contextid=0;
        }
        else{
            contextid = id/1000;
            objectid = id%1000;
        }
        posi = new Array(l,r);
        lastpoint = new Array(0,0);
        lock = 0;
        select = 0;
        contextLevel = 0;
        posused = 0;
        flagnew = 0;
        flagrect= 0;
        objnode= null;
        state=0;
    }

    function paintNode(){
        if(contextid==0){
            trace("meet nest2");
            contextid=global.data.getbuild(objectid).get("size");
        }
        contextNode = sprite().anchor(47,100).pos(PBX+posi[0]*(-34)+posi[1]*30,PBY-1+posi[0]*17+posi[1]*16).size(64*contextid-2,33*contextid+1);
        var classid = objectid/100;
        if(objectid>=500&&objectid<600){
            objnode = sprite("object"+str(objectid-500)+".png",ALPHA_TOUCH).anchor(0,100).pos(0,33*contextid+1).color(50,50,60,100);
            contextNode.add(objnode,-1);
            objnode.setevent(EVENT_TOUCH,objclicked);
            objnode.setevent(EVENT_HITTEST,objclicked);
            objnode.setevent(EVENT_MOVE,objclicked);
            objnode.setevent(EVENT_MULTI_TOUCH,objclicked);
            objnode.setevent(EVENT_MULTI_UNTOUCH,objclicked);
            objnode.setevent(EVENT_UNTOUCH,objclicked);
            if(objectid>=512&&objectid<=516){
                contextNode.add(sprite("object"+str(objectid-500)+"_l.png").anchor(0,100).pos(0,33*contextid+1),1);
            }
            buildcontextname = "obj";
        }
        else if(objectid>0){
            if(objnode!=null){
                contextNode.add(objnode.getNode().anchor(0,100).pos(0,33*contextid+1).color(50,50,60,100),-1);
                return 0;
            }
            var obj;
            if(classid == 1){
                obj = new RoomObject(self);
                obj.self = obj;
                obj.global = global;
                obj.loaddata(0,objectid%100,0,0);
                contextNode.add(obj.getNode().anchor(0,100).pos(0,33*contextid +1).color(50,50,60,100),-1);
                objnode = obj;
                buildcontextname = "room";
            }
            else if(classid == 3){
                obj = new FactObject(self);
                obj.self = obj;
                obj.global = global;
                obj.loaddata(0,objectid%100,0,0);
                contextNode.add(obj.getNode().anchor(0,100).pos(0,33*contextid +1).color(50,50,60,100),-1);
                objnode = obj;
                buildcontextname = "fact";
            }
            else if(classid == 2){
                obj = new CampObject(self);
                obj.self = obj;
                obj.global = global;
                obj.loaddata(0,objectid%100,0,0);
                contextNode.add(obj.getNode().anchor(0,100).pos(0,33*contextid +1).color(50,50,60,100),-1);
                objnode = obj;
                buildcontextname = "camp";
            }
            else if(classid == 0){
                obj = new FarmObject(self);
                obj.self = obj;
                obj.global = global;
                obj.loaddata(0,objectid%100,0,0);
                contextNode.add(obj.getNode().anchor(0,100).pos(0,33*contextid +1).color(50,50,60,100),-1);
                objnode = obj;
                buildcontextname = "farm";
            }
            else if(classid == 4){
                obj = new GodObject(self);
                obj.self = obj;
                obj.global = global;
                obj.loaddata(0,objectid%100,0,0);
                contextNode.add(obj.getNode().anchor(100,100).pos(contextNode.size()).color(50,50,60,100),-1);
                objnode = obj;
                buildcontextname = "god";
            }
            else if(classid==6){
                obj = new StatueObject(self);
                obj.self = obj;
                obj.global = global;
                obj.loaddata(0,objectid,0,0);
                contextNode.add(obj.getNode().anchor(100,100).pos(contextNode.size()).color(50,50,60,100),-1);
                objnode = obj;
                buildcontextname = "statue";
            }
            else if(classid == 10){
                trace("meet nest3");
                obj = new NestObject(self);
                obj.self = obj;
                obj.global = global;
                obj.loaddata(0,objectid,0,0);
                contextNode.add(obj.getNode().anchor(100,100).pos(contextNode.size()).color(50,50,60,100),-1);
                objnode = obj;
                buildcontextname = "nest";
            }
        }
        else if(contextid == 9){
            flagrect = 1;
            contextNode.size(530,283).anchor(50,100).color(50,50,60,100);
            objnode = sprite("empire1.png",ALPHA_TOUCH).anchor(50,100).pos(269,283).size(524,398);
            contextNode.add(objnode,-1);
            objnode.setevent(EVENT_HITTEST,empireSelected);
            objnode.setevent(EVENT_TOUCH,empireSelected);
            objnode.setevent(EVENT_MOVE,empireSelected);
            objnode.setevent(EVENT_UNTOUCH,empireSelected);
            objnode.setevent(EVENT_MULTI_TOUCH,empireSelected);
            objnode.setevent(EVENT_MULTI_UNTOUCH,empireSelected);
        }
        if(flagnew == 1){
            cposi = posi;
            checkmap();
            if(posused == 1)
                contextNode.texture("blockback"+str(contextid)+"_red.png");
            else
                changemap(1);
            statenode = contextNode.addsprite("buildynback.png").anchor(50,100).pos(31*contextid,0);
            statenode.setevent(EVENT_HITTEST,objSelected);
            statenode.setevent(EVENT_MOVE,objSelected);
            statenode.setevent(EVENT_UNTOUCH,objSelected);
            var tmp = statenode.addsprite("buildno.png").anchor(50,50).pos(25,25);
            tmp.setevent(EVENT_HITTEST,buildover,0);
            tmp.setevent(EVENT_MOVE,buildover,0);
            tmp.setevent(EVENT_UNTOUCH,buildover,0);
            tmp = statenode.addsprite().anchor(50,50).pos(86,25);
            if(posused==1){
                tmp.texture("buildyes.png",GRAY);
            }
            else{
                tmp.texture("buildyes.png",NORMAL);
            }
            tmp.setevent(EVENT_HITTEST,buildover,1);
            tmp.setevent(EVENT_MOVE,buildover,1);
            tmp.setevent(EVENT_UNTOUCH,buildover,1);
            statenode.scale(15000/(100+global.context[0].mode));
        }
        else
            changemap(1);
    }

    function empireSelected(n,e,p,x,y,ps){
        if(contextLevel >= global.currentLevel && lock ==0 ){
            if(global.context[0].flagbuild!=0){
                return objSelected(n,e,p,x,y);
            }
            if(global.context[0].flagfriend == 1)
                return 0;
            if(e == EVENT_HITTEST){
                return 1;
            }
            else if(e == EVENT_TOUCH){
                select = 1;
                lastpoint = [x,y];
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
                    if(x <0 || y <0 || x>coor[0] || y>coor[1] ||(lastpoint[0]-x)*(lastpoint[0]-x)+(lastpoint[1]-y)*(lastpoint[0]-y)>2500)
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
            global.pushContext(self,new EmpireControl(),NonAutoPop);
            lock=0;
        }
    }

    function objclicked(n,e,p,x,y,ps){
        if(contextLevel >= global.currentLevel && lock ==0 ){
            if(global.context[0].flagbuild!=0){
                return objSelected(n,e,p,x,y);
            }
            if(global.context[0].flagfriend == 1)
                return 0;
            if(e == EVENT_HITTEST){
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
            global.pushContext(self,new BuildControl(-1,self),AutoPop);
            lock=0;
        }
    }

    function buildover(n,e,p,x,y){
        if(global.currentLevel == 0){
            if(e == EVENT_HITTEST){
                flagmove = 0;
                objSelected(n,EVENT_HITTEST,p,x,y);
                return 1;
            }
            else if(e== EVENT_MOVE){
                if(flagmove == 0){
                    if(x<0 || y<0 || x>n.size()[0] || x>n.size()[1])
                        flagmove =1;
                    return 0;
                }
                else{
                    objSelected(n,EVENT_MOVE,0,x,y);
                }
            }
            else if(e == EVENT_UNTOUCH){
                objSelected(n,EVENT_UNTOUCH,0,0,0);
                if(flagmove == 0){
                    if(p==1 && posused== 1)
                        return 0;
                    statenode.removefromparent();
                    if(flagnew == 1 && p==1)
                        changemap(1);
                    global.context[0].buildover(p);
                }
            }
            return 1;
        }
        else return 0;
    }

    function objSelected(n,e,p,x,y){
        if(contextLevel >= global.currentLevel && lock == 0){
        if(global.context[0].flagbuild-flagnew == 1){
            var c = n.node2world(x,y);
            c = global.context[0].getNode().world2node(c[0],c[1]);
            if(e == EVENT_HITTEST){
                select = 1;
                lastpoint = c;
                cposi = [posi[0],posi[1]];
                contextNode.removefromparent();
                global.context[0].contextNode.add(contextNode,3280);
                if(posused==0)
                    changemap(0);
                if(flagnew == 1){
                    statenode.visible(0);
                }
                return 1;
            }
            if(e == EVENT_MOVE){
                var ox = c[0] - lastpoint[0];
                var oy = c[1] - lastpoint[1];
                var rx = (-ox+2*oy)/62;
                var ry = (ox+2*oy)/62;
                if(posi[0] + rx != cposi[0] || posi[1]+ry != cposi[1]){
                    cposi[0] = posi[0] + rx;
                    cposi[1] = posi[1] + ry;
                    var cu = posused;
                    if(cposi[0] < contextid-flagrect-1) cposi[0] =contextid-flagrect-1;
                    else if(cposi[0] >= global.rect) cposi[0] = global.rect-1;
                    if(cposi[1] < contextid-1) cposi[1] = contextid-1;
                    else if(cposi[1] >= global.rect) cposi[1] = global.rect-1;
                    checkmap();
                    if(cu != posused){
                        if(posused == 1)
                            contextNode.texture("blockback"+str(contextid)+"_red.png");
                        else
                            contextNode.texture();
                    }
                    //lastpoint = [lastpoint[0]+rx*(-34)+ry*30,lastpoint[1]+rx*17+ry*16];
                    contextNode.pos(PBX+cposi[0]*(-34)+cposi[1]*30,PBY-1+cposi[0]*17+cposi[1]*16);
                }
                return 1;
            }
            if(e == EVENT_UNTOUCH){
                posi = [cposi[0],cposi[1]];
                if(posused == 0){
                    contextNode.texture();
                    changemap(1);
                    if(flagnew == 2){
                        flagnew =0;
                        global.context[0].setmovelock(0);
                    }
                }
                else if(flagnew == 0){
                    flagnew = 2;
                    global.context[0].setmovelock(1);
                }
                if(flagnew == 1){
                    statenode.visible(1);
                    if(posused == 1)
                        statenode.subnodes()[1].texture("buildyes.png",GRAY);
                    else{
                        statenode.subnodes()[1].texture("buildyes.png",NORMAL);
                    }
                }
                resetgrid();
                return 1;
            }
        }
        }
        return 0;
    }

    function resetgrid(){
            contextNode.removefromparent();
            contextNode.pos(PBX+posi[0]*(-34)+posi[1]*30,PBY-1+posi[0]*17+posi[1]*16);
            var deep = (posi[0]+posi[1]+1-contextid)*(posi[0]+posi[1]+2-contextid)/2+posi[0];
            if(posused==1){
                deep = 3280;
            }
            global.context[0].contextNode.add(contextNode,deep);
    }

    function checkmap(){
        for(var i=0;i<contextid-flagrect;i++){
            for(var j=0;j<contextid;j++)
                if(global.context[0].map[(cposi[0]-i)*RECTMAX+cposi[1]-j] != 0){
                    posused = 1;
                    return 0;
                }
        }
        posused = 0;
        return 0;
    }

    function changemap(b){
        if(b == 0){
            for(var i=0;i<contextid-flagrect;i++){
                for(var j=0;j<contextid;j++)
                    global.context[0].map[(posi[0]-i)*RECTMAX+posi[1]-j] = 0;
            }
            posused = 0;
            contextNode.texture();
        }
        else{
            for(i=0;i<contextid-flagrect;i++){
                for(j=0;j<contextid;j++)
                    global.context[0].map[(posi[0]-i)*RECTMAX+posi[1]-j] = -1;
            }
            //global.context[0].map[RECTMAX*posi[0]+posi[1]] = contextid*1000+objectid;
        }
    }

    function reloadNode(re){
        if(re == 1){
            var g = posi[0]*RECTMAX+posi[1];
            global.http.addrequest(1,"sell",["user_id","city_id","grid_id"],[global.userid,global.cityid,g],self,"saleover");
        }
    }
    
    function useaction(p,rc,c){
        if(p=="saleover"){
            saleover(0,rc,c);
        }
    }

    function saleover(r,rc,c){
trace("sell",r,rc,c);
        if(rc!= 0){
            var ot = objectid/100;
            var oi = objectid%100;
            var ol=0;
            var m=0;
            var p=0;
            if(ot==0){
                m = FARM_PRICE[oi];
                p = FARM_PERSON[oi];
            }
            else if(ot==1){
                m = ROOM_PRICE[oi/3*3];
                ol = oi%3;
            }
            else if(ot==2){
                m = CAMP_PRICE[oi/3*3];
                p = CAMP_PERSON[oi];
                ol = oi%3;
            }
            else if(ot==3){
                m = FACT_PRICE[oi/3*3];
                p = FACT_PERSON[oi];
                ol = oi%3;
            }
            else if(ot==4){
                var ott;
                if(oi<20) ott=oi%4;
                else ott=oi/5;
                global.user.setValueInArray("godtime",ott,-1);
                m = GOD_B_PRICE[0];
                ol = oi/4;
                if(ol>4){
                    ol=(oi-20)%5;
                }
                p = -GOD_PERSON_MAX[ol];
            }
            else if(ot==6){
                m = STATUE_PRICE[oi];
                p = STATUE_PERSON[oi];
            }
            else{
                m = OBJ_PRICE[oi];
                p = -OBJ_PERSON[oi];
            }
            if(m<0){
                m = -2000*m;
            }
            if(ol==0){
                m=m/4;
            }
            else if(ol==1){
                m=m/2;
            }
            else if(ol==3){
                m=m*2;
            }
            else if(ol==4){
                m=m*4;
            }
            global.user.changeValueAnimate2(contextNode,"money",m,0);
            if(p>0){
                global.user.changeValueAnimate2(contextNode,"labor",-p,-2);
            }
            else if(p<0){
                global.user.changeValueAnimate2(contextNode,"personmax",p,-2);
            }
            deleteContext();
        }
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        if(posused==0)
            changemap(0);
        global.context[0].grounds.remove(self);
    }
}