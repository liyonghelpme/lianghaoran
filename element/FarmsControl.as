class FarmsControl extends ContextObject{
    var pagetext;
    var pageposmax;
    var pagepos;
    var lasttime;
    var lastx;
    var flagmove;
    var objs;
    var buildable;
    const objsmax = 6;
    const objcontext = [2001,2002,3005,3006,2003,2004];
    const objlevel = [1,10,10,18,20,30];
    function FarmsControl(){
        contextname = "element-build-resource";
        contextNode = null;
        buildable = new Array(6);
        pageposmax = 1161-objsmax*161;
        if(pageposmax > 400) pageposmax = 400;
    }

    function paintNode(){
        pagepos = 400;
        contextNode = node().anchor(50,50).pos(pagepos,240).size(800,480);
        objs = new Array(0);
        for(var i=0;i<objsmax;i++){
            objs.append(null);
        }
        refreshpage();
    }
    
    function getcell(i){
            buildable[i] = dict([["ok",1]]);
            var bi = objcontext[i]%100;
            var farm = sprite("dialogelement2u.png").pos(DIALOG_BASE_X+i*DIALOG_OFF_X,DIALOG_BASE_Y).size(148,276);
            farm.addlabel(global.getname("farm",bi),null,16).anchor(50,0).pos(74,10).color(0,0,0,100);
            var bl = 100;
            if(objcontext[i] >3000)
                bl=66;
            farm.addsprite("farm"+str(bi)+".png").anchor(50,100).pos(74,160).scale(bl);
            if(objlevel[i]>global.user.getValue("level")){
                farm.texture("dialogelement_lock2.png");
                farm.addlabel(str(objlevel[i]),null,16).anchor(50,50).pos(119,244).color(100,0,0,100);
            }
            else{
                farm.setevent(EVENT_TOUCH,beginbuild,i);
                farm.setevent(EVENT_MOVE,beginbuild,i);
                farm.setevent(EVENT_UNTOUCH,beginbuild,i);
                var cl = 0;
                var price = FARM_PRICE[bi];
                if(price>0){
                    if(global.user.getValue("money")<price){
                        cl=100;
                        buildable[i].update("ok",0);
                        buildable[i].update("银币",price-global.user.getValue("money"));
                    }
                    farm.addsprite("money_big.png").size(20,20).pos(10,202);
                    farm.addlabel(str(price),null,16).pos(34,202).color(cl,0,0,100);
                }
                else{
                    price = -price;
                    if(global.user.getValue("caesars")<price){
                        cl=100;
                        buildable[i].update("ok",0);
                        buildable[i].update("凯撒币",price-global.user.getValue("caesars"));
                    }
                    farm.addsprite("caesars_big.png").size(20,20).pos(10,202);
                    farm.addlabel(str(price),null,16).pos(34,202).color(cl,0,0,100);
                }
                var food = FARM_FOOD[bi];
                if(food > 0){
                    cl = 0;
                    if(global.user.getValue("food") < food){
                        cl=100;
                        buildable[i].update("ok",0);
                        buildable[i].update("粮食",food-global.user.getValue("food"));
                    }
                    farm.addsprite("food.png").size(29,33).pos(80,195);
                    farm.addlabel(str(food),null,16).pos(113,202).color(cl,0,0,100);
                }
                var person = FARM_PERSON[bi];
                if(person>0){
                    cl = 0;
                    if(global.user.getValue("person")-global.user.getValue("labor") < person){
                        cl=100;
                        buildable[i].update("ok",0);
                        buildable[i].update("空闲人口",person-global.user.getValue("person")+global.user.getValue("labor"));
                    }
                    farm.addsprite("person.png").size(32,30).pos(83,165);
                    farm.addlabel(str(person),null,16).pos(118,170).color(cl,0,0,100);
                }
                farm.addlabel(FARM_USE[bi],null,16).pos(10,246).color(0,0,0,100);
            }
            objs[i] = farm;
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
                    if(flagmove==1){
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
                n.texture("dialogelement2u.png");
                if(flagmove == 0){
                    global.lastpage[0] = 2;
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