import element.Refreshdialog;
class Monsterdialog extends ContextObject{
    var mid;
    var mtype;
    var mpower;
    var element;
    var flagdefeatable;
    function Monsterdialog(m){
        contextname = "dialog-battle-monster";
        contextNode = null;
        mid = m;
        element = null;
    }
    
    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        contextNode = null;
        element.removefromparent();
        element=null;
    }
    
    function getelement(){
        if(element == null){
            element = node();
            flagdefeatable=1;
            
            element.addsprite("monsterelement.png").anchor(50,50).pos(219,160);
            mtype = global.context[1].monstercontroller.monsters[mid];
            if(global.flagnew ==1){
                mtype = 0;
            }
            mpower = MONSTER_POWER[mtype];
            if(global.context[1].monstercontroller.mlevel>=60){
                mpower = mpower+global.context[1].monstercontroller.mlevel-59;
            }
            element.addlabel(MONSTERNAME[mtype],null,20).anchor(50,50).pos(219,78).color(0,0,0,100);
            element.addsprite("monster_"+str(mtype)+"_1.png").anchor(50,50).pos(219,160).scale(150);
            element.addlabel("战斗力为："+str(mpower),null,20).anchor(50,50).pos(219,242).color(0,0,0,100);
            var warning=element.addlabel("",null,20).anchor(50,50).pos(219,285).color(100,0,0,100);
        
            if(global.soldiers[0]+global.soldiers[1]<mpower){
                warning.text("你的战斗力不足！");
                flagdefeatable = 0;
            }
        }
        return element;
    }
    
    function paintNode(){
        var dialog = new Simpledialog(0,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.usedefaultbutton(2,["攻击","返回"]);
        if(flagdefeatable == 0){
            contextNode.get(0).texture("boxbutton2.png");
            contextNode.get(0).setevent(EVENT_UNTOUCH,null);
        }
    }
    
    function excute(p){
        global.popContext(null);
        if(global.flagnew == 1){
            defeatmonster(0,1,"{'id':1,'infantrypower':30,'powerlost':0}");
        }
        else{
            global.http.addrequest(1,"defeatmonster",["uid","gridid"],[global.userid,mid],self,"defeatmonster");
        }
    }
    
    function useaction(p,rc,c){
        if(p == "defeatmonster"){
            defeatmonster(p,rc,c);
        }
        else if(p=="datarefresh"){
            datarefresh(json_loads(c));
        }
    }
    
    function defeatmonster(r,rc,c){
        if(rc!=0){
            var data = json_loads(c);
            if(data.get("id",1)!=0){
                var m = global.context[1].baseNode.get(mid+8);
                var sid = "1";
                if(mpower >= 70){
                    sid="2";
                }
                m.setevent(EVENT_UNTOUCH,null);
                var s = m.addsprite("animate_self_left_"+sid+"_2.png").anchor(100,100).pos(-40,m.size()[1]).color(0,0,0,0);
                s.addaction(sequence(tintto(1000,100,100,100,100),
                spawn(moveby(1000,60,0),repeat(animate(500,"animate_self_left_"+sid+"_1.png","animate_self_left_"+sid+"_2.png"),2)),
                repeat(animate(250,"animate_self_left_"+sid+"_3.png","animate_self_left_"+sid+"_2.png"),4),delaytime(500),
                spawn(repeat(animate(500,"animate_self_"+sid+"_1.png","animate_self_"+sid+"_2.png"),4),sequence(delaytime(1000),tintto(1000,0,0,0,0))),
                callfunc(removeself)));
                if(mtype<18){
                    m.addaction(sequence(stop(),delaytime(3500),animate(3000,"01.png","02.png","03.png","04.png","05.png","06.png","07.png","08.png","09.png","10.png","11.png","12.png","13.png","14.png","15.png"),itexture(""),delaytime(2000),callfunc(removeself)));
                }
                else{
                    m.addaction(sequence(stop(),delaytime(3500),itexture("monster_"+str(mtype)+"_dead.png"),delaytime(1000),animate(2500,"01.png","02.png","03.png","04.png","05.png","06.png","07.png","08.png","09.png","10.png","11.png","12.png","13.png","14.png","15.png"),itexture(""),delaytime(2000),callfunc(removeself)));
                }
                c_addtimer(1000,defeatover,[m,data.get("powerlost",0),data.get("specialgoods","")],3500,1);
                global.soldiers[0] = data.get("infantrypower",0);
                global.soldiers[1] = data.get("cavalrypower",0);
                global.context[1].powerlabel.text(str(global.soldiers[0]+global.soldiers[1]));
                global.card[mtype/3]++;
                var cl = cardlevelnum.index(global.card[mtype/3]);
                if(cl!=-1){
                    var cdict = dict();
                    cdict.update("name","getcard");
                    cdict.update("cardid",mtype/3);
                    cdict.update("cardlevel",cl+1);
                    global.context[0].addcmd(cdict);
                }
                global.context[0].warmap.monstercontroller.defeatmonster(mid);
                if(global.context[0].warmap.monstercontroller.monsternum == 0){
                    cdict =dict();
                    cdict.update("name","monstercomplete");
                    cdict.update("power",mpower);
                    global.context[0].addcmd(cdict);
                }
            }
            else{
                global.pushContext(self,new Refreshdialog(),NonAutoPop);
            }
        }
    }
    function datarefresh(data){
        if(data.get("id")==0){
            global.pushContext(self,new Refreshdialog(),NonAutoPop);
            return 0;
        }
                global.soldiers[0] = data.get("infantrypower",0);
                global.soldiers[1] = data.get("cavalrypower",0);
                global.user.setValue("money",data.get("corn"));
                global.user.setValue("exp",data.get("exp"));
                global.user.setValue("power",global.soldiers[0]+global.soldiers[1]);
            var cardstr = data.get("monsterdefeat","0;0;0;0;0;0;0;0;0;0;0;0");
            var cards = cardstr.split(";");
            for(var k=0;k<12&&k<len(cards);k++){
                global.card[k]=int(cards[k]);
            }
        var mstr = data.get("monsterstr");
        var monsternum = 0;
        var monsters = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
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
        }
        global.context[0].warmap.monstercontroller.monsters=monsters;
        global.context[0].warmap.monstercontroller.monsternum=monsternum;
        
                var cl = cardlevelnum.index(global.card[mtype/3]);
                if(cl!=-1){
                    var cdict = dict();
                    cdict.update("name","getcard");
                    cdict.update("cardid",mtype/3);
                    cdict.update("cardlevel",cl+1);
                    global.context[0].addcmd(cdict);
                }
                global.context[0].warmap.monstercontroller.defeatmonster(mid);
                if(global.context[0].warmap.monstercontroller.monsternum == 0){
                    cdict =dict();
                    cdict.update("name","monstercomplete");
                    cdict.update("power",mpower);
                    global.context[0].addcmd(cdict);
                }
    }
    function defeatover(timer,tick,m){
        if(m[1] == 0){
            global.user.changeValueAnimate2(m[0],"exp",10,0);
        }
        else{
            global.user.changeValueAnimate2(m[0],"power",-m[1],-4);
            var exp;
            var money;
            var l = global.user.getValue("level");
            if(l<9){
                exp = (mpower+3)/4;
                money=(mpower+1)/2*30;
            }
            else if(l<15){
                exp = (mpower*2+4)/5;
                money=(mpower*3+4)/5*30;
            }
            else{
                exp = (mpower+1)/2;
                money=(mpower*13+19)/20*30;
            }
            global.user.changeValueAnimate2(m[0],"exp",exp,0);
            global.user.changeValueAnimate2(m[0],"money",money,-2);
            if(m[2] != ""){
                var specs = m[2].split("!");
                var le = len(specs);
                var si = m[0].size();
                for(var i=0;i<le;i++){
                    global.special[int(specs[i])]++;
                    var s=sprite("gift"+str(int(specs[i])+1)+".png").anchor(50,100).scale(50).color(0,0,0,0);
                    m[0].add(s.pos(-15*le+i*50+si[0]/2,si[1]),-1);
                    s.addaction(sequence(tintto(500,100,100,100,100),delaytime(3000),tintto(1000,0,0,0,0)));
                }
            }
        }
    }
}
