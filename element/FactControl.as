class FactControl extends ContextObject{
    var objs;
    var pageposmax;
    var pagepos;
    var lasttime;
    var lastx;
    var flagmove;
    var buildable;
    const objsmax = 10;
    const objcontext = [3327,2300,2303,2306,2309,2315,2312,2318,2324,2321];
    const objlevel = [7,1,4,6,8,14,15,21,24,29];
    function FactControl(){
        contextname ="element-build-fact";
        contextNode = null;
        objs = new Array(10);
        buildable = new Array(10);
        pageposmax = 1161-objsmax*161;
        if(pageposmax > 400) pageposmax = 400;
        flagmove = 0;
    }

    function paintNode(){
        pagepos = global.lastpage[2];
        contextNode = node().anchor(50,50).pos(pagepos,240).size(800,480);
        for(var i=0;i<objsmax;i++){
            objs[i] = null;
        }
        refreshpage();
    }
    
    function getcell(i){
            buildable[i] = dict([["ok",1]]);
            var oi = objcontext[i]%100;
            objs[i] = sprite("dialogelement2p.png").pos(DIALOG_BASE_X+i*DIALOG_OFF_X,DIALOG_BASE_Y).size(148,276);
            objs[i].addlabel(global.getname("fact",oi),null,16).anchor(50,0).pos(74,10).color(0,0,0,100);
            var b=100;
            if(objcontext[i]/1000==3) b=66;
            objs[i].addsprite("fact"+str(oi)+".png").anchor(50,100).pos(74,160).scale(b);
            if(i<1){
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
                
                var price = FACT_PRICE[oi];
                if(price > 0){
                    var cl = 0;
                    if(global.user.getValue("money")<price){
                        cl=100;
                        buildable[i].update("ok",0);
                        buildable[i].update("银币",price-global.user.getValue("money"));
                    }
                    objs[i].addsprite("money_big.png").size(20,20).pos(10,202);
                    objs[i].addlabel(str(price),null,16).pos(34,202).color(cl,0,0,100);
                    cl = 0;
                    var nperson = FACT_PERSON[oi];
                    if(global.user.getValue("person")-global.user.getValue("labor") < nperson){
                        cl=100;
                        buildable[i].update("ok",0);
                        buildable[i].update("空闲人口",nperson-global.user.getValue("person")+global.user.getValue("labor"));
                    }
                    objs[i].addsprite("person.png").size(32,30).pos(83,159);
                    objs[i].addlabel(str(nperson),null,16).pos(118,165).color(cl,0,0,100);
                    cl = 0;
                    var food = FACT_FOOD[oi];
                    if(global.user.getValue("food") < food){
                        cl=100;
                        buildable[i].update("ok",0);
                        buildable[i].update("粮食",food-global.user.getValue("food"));
                    }
                    objs[i].addsprite("food.png").size(29,33).pos(80,195);
                    objs[i].addlabel(str(food),null,16).pos(113,202).color(cl,0,0,100);
                }
                else{
                    cl = 0;
                    price = -price;
                    if(global.user.getValue("caesars")<price){
                        cl=100;
                        buildable[i].update("ok",0);
                        buildable[i].update("凯撒币",price-global.user.getValue("caesars"));
                    }
                    objs[i].addsprite("caesars_big.png").size(20,20).pos(10,202);
                    objs[i].addlabel(str(price),null,16).pos(34,202).color(cl,0,0,100);
                }
                var t = FACT_TIME[oi]/60;
                var timestr;
                if(t<60)
                    timestr = str(t)+"min";
                else{
                    t = t/6;
                    if(t%10 == 0)
                        timestr = str(t/10)+"h";
                    else
                        timestr = str(t/10)+"."+str(t%10)+"h";
                }
                objs[i].addsprite("money_big.png").size(20,20).pos(10,246);
                objs[i].addlabel(str(FACT_GAIN[oi])+" per "+timestr,null,16).pos(34,246).color(0,0,0,100);
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
        global.lastpage[2] = pagepos;
    }

    function beginbuild(n,e,param,x,y){
        if(global.currentLevel <= 1){
            if(e == EVENT_TOUCH){
                lasttime = time();
                lastx = n.pos()[0]+x+contextNode.pos()[0]-400;
                flagmove = 0;
                global.context[1].nodemove(n,EVENT_HITTEST,0,lastx,240);
                n.texture("dialogelement2p1.png");
                return 1;
            }
            else if(e== EVENT_MOVE){
                if(flagmove == 0){
                    if(x<0 || y<0 || x>n.size()[0] || x>n.size()[1])
                        flagmove =1;
                    else if(time()-lasttime > 1000)
                        flagmove =1;
                    if(flagmove ==1){
                        n.texture("dialogelement2p.png");
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
                    global.lastpage[0] = 1;
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