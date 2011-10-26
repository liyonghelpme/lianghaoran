import global.ContextObject;
class CampControl extends ContextObject{
    var objs;
    var left;
    var right;
    var pagetext;
    var pageposmax;
    var pagepos;
    var lasttime;
    var lastx;
    var flagmove;
    const objsmax = 3;
    const objcontext = [2200,2206,2203];
    const objlevel = [1,3,11];
    var buildable;
    function CampControl(){
        contextname = "element-build-camp";
        contextNode = null;
        objs = new Array(3);
        buildable = new Array(3);
        pageposmax = 1161-objsmax*161;
        if(pageposmax > 400) pageposmax = 400;
        flagmove = 0;
    }

    function paintNode(){
        pagepos = global.lastpage[3];
        contextNode = node().anchor(50,50).pos(pagepos,240).size(800,480);
        for(var i=0;i<objsmax;i++){
            objs[i]=null;
        }
        refreshpage();
    }
    
    function getcell(i){
    
            buildable[i] = dict([["ok",1]]);
            var objid = objcontext[i]%100;
            objs[i] = sprite("dialogelement2u.png").pos(DIALOG_BASE_X+i*DIALOG_OFF_X,DIALOG_BASE_Y).size(148,276);
            objs[i].addlabel(global.getname("camp",objid),null,16).anchor(50,0).pos(74,10).color(0,0,0,100);
            objs[i].addsprite("camp"+str(objid)+".png").anchor(50,100).pos(74,160);
            if(i==1){
                objs[i].addsprite("new.png").anchor(100,100).scale(150).pos(137,160);
            }
            if(objlevel[i] > global.user.getValue("level")){
                objs[i].texture("dialogelement_lock2.png");
                objs[i].addlabel(str(objlevel[i]),null,16).anchor(50,50).pos(119,244).color(100,0,0,100);
            }
            else{
                objs[i].setevent(EVENT_TOUCH,beginbuild,i);
                objs[i].setevent(EVENT_MOVE,beginbuild,i);
                objs[i].setevent(EVENT_UNTOUCH,beginbuild,i);

                var cl = 0;
                var price = CAMP_PRICE[objid];
                if(global.user.getValue("money")<price){
                    cl=100;
                    buildable[i].update("ok",0);
                    buildable[i].update("银币",price-global.user.getValue("money"));
                }
                objs[i].addsprite("money_big.png").size(20,20).pos(10,202);
                objs[i].addlabel(str(price),null,16).pos(34,202).color(cl,0,0,100);
                cl = 0;
                    var nperson = CAMP_PERSON[objid];
                    if(global.user.getValue("person")-global.user.getValue("labor") < nperson){
                        cl=100;
                        buildable[i].update("ok",0);
                        buildable[i].update("空闲人口",nperson-global.user.getValue("person")+global.user.getValue("labor"));
                    }
                objs[i].addsprite("person.png").size(32,30).pos(83,165);
                objs[i].addlabel(str(nperson),null,16).pos(118,170).color(cl,0,0,100);
                cl = 0;
                    var food = CAMP_FOOD[objid];
                    if(global.user.getValue("food") < food){
                        cl=100;
                        buildable[i].update("ok",0);
                        buildable[i].update("粮食",food-global.user.getValue("food"));
                    }
                objs[i].addsprite("food.png").size(29,33).pos(80,195);
                objs[i].addlabel(str(food),null,16).pos(113,202).color(cl,0,0,100);
                objs[i].addlabel(CAMP_USE[objid/3],null,16).pos(10,246).color(0,0,0,100);
            }
    }
    
    function refreshpage(){
        pagepos = contextNode.pos()[0];
        var index = (400-pagepos)/DIALOG_OFF_X;
        for(var i=0;i<objsmax;i++){
            if(i<index||i>index+6){
                if(objs[i]!=null){
                    objs[i].removefromparent();
                    objs[i] = null;
                }
            }
            else if(objs[i]==null){
                getcell(i);
                contextNode.add(objs[i]);
            }
        }
    }


    function choosepage(){
        pagepos = contextNode.pos()[0];
        if(pagepos > 400) pagepos = 400;
        else if(pagepos < pageposmax) pagepos = pageposmax;
        var index = (400-pagepos)/DIALOG_OFF_X;
        for(var i=0;i<objsmax;i++){
            if(i<index||i>index+6){
                if(objs[i]!=null){
                    objs[i].removefromparent();
                    objs[i] = null;
                }
            }
            else if(objs[i]==null){
                getcell(i);
                contextNode.add(objs[i]);
            }
        }
        contextNode.addaction(moveto(300,pagepos,240));
        global.lastpage[3] = pagepos;
    }

    function beginbuild(n,e,param,x,y){
        if(global.currentLevel <= 1){
            if(e == EVENT_TOUCH){
                lasttime = time();
                lastx = n.pos()[0]+x+contextNode.pos()[0]-400;
                flagmove = 0;
                global.context[1].nodemove(n,EVENT_HITTEST,0,lastx,240);
                n.texture("dialogelement2u1.png");
                return 1;
            }
            else if(e== EVENT_MOVE){
                if(flagmove == 0){
                    if(x<0 || y<0 || x>n.size()[0] || x>n.size()[1])
                        flagmove =1;
                    else if(time()-lasttime > 1000)
                        flagmove =1;
                    if(flagmove == 1){
                        n.texture("dialogelement2u.png");
                    }
                    return 0;
                }
                else{
                    lastx = n.pos()[0]+x+contextNode.pos()[0]-400;
                    global.context[1].nodemove(n,EVENT_MOVE,0,lastx,240);
                }
            }
            else if(e == EVENT_UNTOUCH){
                if(flagmove == 0){
                    n.texture("dialogelement2u.png");
                    global.lastpage[0] = 3;
                    if(buildable[param].get("ok")==0){
                        global.pushContext(self,new Warningdialog(buildable[param]),NonAutoPop);
                    }
                    else{
                        global.popContext(objcontext[param]);
                    }
                }
                else{
                    choosepage();
                }
            }
        }
    }

    function reloadNode(re){
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}