class SoldierControl extends ContextObject{
    var tabs;
    var soldiers;
    var selecttab;
    var pagenum;
    var stype;
    var element;
    var level;
    var buildable;

    const S_BASE_X = 111;
    const S_BASE_Y = 200;
    const S_OFF_X = 168;
    function SoldierControl(p,l){
        contextname = "dialog-object-soldier";
        stype = p+1;
        contextNode = null;
        soldiers = new Array(9);
        buildable = new Array(9);
        tabs = new Array(3);
        pagenum = 3;
        element = null;
        level = l;
    }

    function getelement(){
        if(element == null){
            element = node();
            element.addsprite("soldierback.jpg").pos(10,10);
            selecttab = -1;
            for(var i=0;i<3;i++){
                var sid = i+(stype-1)*3;
                tabs[i] = sprite("soldiertab0.png").anchor(50,100).pos(S_BASE_X+i*S_OFF_X,S_BASE_Y);
                tabs[i].add(sprite("soldier"+str(stype)+"_"+str(i+1)+".png").anchor(50,50).pos(81,57),0,1);
                if(i<=level){
                    var tab = sprite("soldiertab.png").pos(7-i*34,120).visible(0);
                    tab.addlabel(global.getname("soldier",sid),null,16).anchor(0,50).pos(14,13).color(0,0,0,100);
                    var sp= SOLDIER_POWER[sid];
                    if(sp == 0){
                        tab.addlabel("用于侦察",null,16).anchor(100,50).pos(202,13).color(0,0,0,100);
                    }
                   else{
                        tab.addlabel("单位战斗力",null,16).anchor(0,50).pos(80,13).color(0,0,0,100);
                        tab.addsprite("power.png").anchor(50,50).pos(182,13);
                        tab.addlabel(str(sp),null,16).anchor(0,50).pos(198,13).color(0,0,0,100);
                    }
                }
                else{
                    tab = sprite("dialogelement_lock3.png").pos(7-i*S_OFF_X,120).visible(0);
                }
                tabs[i].add(tab,1,2);
                tabs[i].setevent(EVENT_TOUCH,changesoldiers,i);
                element.add(tabs[i],1);
            }
            var personlevel = [1,3,6];
            for(i=0;i<3*level+3;i++){
                buildable[i] = dict([["ok",1]]);
                soldiers[i] = sprite("dialogelement2s.png").anchor(50,0).pos(S_BASE_X+i%3*S_OFF_X,S_BASE_Y+40).setevent(EVENT_UNTOUCH,beginsoldier,i);
                soldiers[i].addsprite("trainlevel"+str(i%3)+".png").anchor(50,50).pos(33,44);
                sp = SOLDIER_PERSON[stype-1]*personlevel[i%3];
                soldiers[i].addlabel("x"+str(sp),null,24).pos(68,42).color(0,0,0,100);
                soldiers[i].addsprite("time.png").pos(57,4);
                soldiers[i].addlabel(global.gettimestr(SOLDIER_TIME[i%3]),null,12).anchor(50,50).pos(111,17).color(0,0,0,100);
                
                var cl = 0;
                var value = SOLDIER_PRICE[(stype-1)*9+i];
                if(value > global.user.getValue("money")){
                    cl=100;
                    buildable[i].update("ok",0);
                    buildable[i].update("银币",value-global.user.getValue("money"));
                }
                soldiers[i].addsprite("money_big.png").anchor(50,50).pos(24,100).size(20,20);
                soldiers[i].addlabel(str(value),null,16).anchor(0,50).pos(36,100).color(cl,0,0,100);
                
                cl = 0;
                value = SOLDIER_FOOD[(stype-1)*3+i/3]*sp;
                if(value > global.user.getValue("food")){
                    cl=100;
                    buildable[i].update("ok",0);
                    buildable[i].update("粮食",value-global.user.getValue("food"));
                }
                soldiers[i].addsprite("food.png").anchor(50,50).size(29,33).pos(24,131);
                soldiers[i].addlabel(str(value),null,16).anchor(0,50).pos(35,131).color(cl,0,0,100);
                
                cl = 0;
                if(sp > global.user.getValue("person")-global.user.getValue("labor")){
                    cl=100;
                    buildable[i].update("ok",0);
                    buildable[i].update("空闲人口",sp-global.user.getValue("person")+global.user.getValue("labor"));
                }
                soldiers[i].addsprite("personmax.png").anchor(50,50).pos(95,131);
                soldiers[i].addlabel(str(sp),null,16).anchor(0,50).pos(112,131).color(cl,0,0,100);
                soldiers[i].addsprite("exp.png").anchor(50,50).size(42,21).pos(30,173);
                soldiers[i].addlabel(str(SOLDIER_EXP[stype*9-9+i]),null,16).anchor(0,50).pos(53,173).color(0,0,0,100);
                soldiers[i].addsprite("power.png").anchor(50,50).pos(95,173);
                soldiers[i].addlabel(str(sp*SOLDIER_POWER[(stype-1)*3+i/3]),null,16).anchor(0,50).pos(109,173).color(0,0,0,100);
            }/*
            for(i=level+1;i<3;i++){
                soldiers[i*3] = sprite("dialogelement_lock3.png").pos(S_BASE_X-74,S_BASE_Y+40);
            }*/
            changesoldiers(0,0,level);
        }
        return element;
    }

    function paintNode(){
        var dialog = new Simpledialog(3,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.setclosebutton();
    }

    function beginsoldier(n,e,p){
        if(buildable[p].get("ok") == 0)
            global.pushContext(self,new Warningdialog(buildable[p]),NonAutoPop);
        else
            global.popContext(p);
    }

    function changesoldiers(n,e,p){
        if(selecttab != p){
            if(selecttab >= 0 ){
                tabs[selecttab].texture("soldiertab0.png");
                tabs[selecttab].get(1).scale(100);
                tabs[selecttab].get(2).visible(0);
            }
            tabs[p].texture("soldiertab1.png");
            tabs[p].get(1).scale(110);
            tabs[p].get(2).visible(1);
            
            for(var k=0;k<level*3+3;k++){
                if(k/3 == p)
                    element.add(soldiers[k]);
                else if(k/3==selecttab)
                    soldiers[k].removefromparent();
            }
            selecttab = p;
        }
    }

    function closedialog(node,event){
        global.popContext(null);
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}