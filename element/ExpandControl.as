class ExpandControl extends ContextObject{
    var pagetext;
    var pageposmax;
    var pagepos;
    var lasttime;
    var lastx;
    var flagmove;
    var buildable;
    const objsmax = 0;
    function ExpandControl(){
        contextname = "element-build-expand";
        contextNode = null;
        pageposmax = 1161-objsmax*161;
        if(pageposmax > 400) pageposmax = 400;
        buildable = new Array(3);
    }

    function paintNode(){
        pagepos = 400;
        contextNode = node().anchor(50,50).pos(pagepos,240).size(800,480);
        var obji=(global.rect-20)/2;
        var ismax = 0;
        if(obji>=len(EXPAND_LEVEL)){
            obji=len(EXPAND_LEVEL)-1;
            ismax = 1;
        }
        for(var i=0;i<3;i++){
            var obj = contextNode.addsprite("dialogelement2e.png").anchor(50,0).pos(196+i*204,DIALOG_BASE_Y).size(183,276);
            if(ismax == 0){
                obj.setevent(EVENT_TOUCH,beginbuild,i);
                obj.setevent(EVENT_MOVE,beginbuild,i);
                obj.setevent(EVENT_UNTOUCH,beginbuild,i);
            }
            else{
                obj.color(60,60,60,100);
            }
            buildable[i] = dict([["ok",1]]);
        
            obj.addsprite("expand"+str(i)+".png").anchor(50,0).pos(91,15);
            obj.addlabel(str(global.rect+2)+" x "+str(global.rect+2),null,40).anchor(50,50).pos(91,171).color(100,0,0,100);
            var cl=0;
            if(i==0){
                obj.addsprite("tfriend.png").anchor(100,50).pos(89,242);
                if(EXPAND_FRIEND[obji]>len(global.ppyuserdict)-2){
                    buildable[i].update("ok",0);
                    buildable[i].update("好友",EXPAND_FRIEND[obji]-len(global.ppyuserdict)+2);
                    cl = 100;
                }
                obj.addlabel("x"+str(EXPAND_FRIEND[obji]),null,20).anchor(0,50).pos(93,242).color(cl,0,0,100);
            }
            else if(i==1){
                obj.addsprite("caesars_big.png").anchor(100,50).pos(89,242);
                if(EXPAND_CAESARS[obji]>global.user.getValue("caesars")){
                    buildable[i].update("ok",0);
                    buildable[i].update("凯撒币",EXPAND_CAESARS[obji]-global.user.getValue("caesars"));
                    cl = 100;
                }
                obj.addlabel("x"+str(EXPAND_CAESARS[obji]),null,20).anchor(0,50).pos(93,242).color(cl,0,0,100);
            }
            else{
                obj.addsprite("money_big.png").anchor(50,50).pos(39,229).size(20,20);
                if(EXPAND_MONEY[obji]>global.user.getValue("money")){
                    buildable[i].update("ok",0);
                    buildable[i].update("银币",EXPAND_MONEY[obji]-global.user.getValue("money"));
                    cl = 100;
                }
                obj.addlabel(str(EXPAND_MONEY[obji]),null,20).anchor(0,50).pos(68,229).color(cl,0,0,100);
                cl =0;
                if(EXPAND_LEVEL[obji]>global.user.getValue("level")){
                    buildable[i].update("ok",0);
                    buildable[i].update("等级",EXPAND_LEVEL[obji]-global.user.getValue("level"));
                    cl = 100;
                }
                obj.addsprite("tlevel.png").anchor(50,50).pos(39,249);
                obj.addlabel(str(EXPAND_LEVEL[obji]),null,20).anchor(0,50).pos(68,249).color(cl,0,0,100);
            }
        }
    }

    function refreshpage(){
    
    }

    function choosepage(){
        pagepos = contextNode.pos()[0];
        if(pagepos > 400) pagepos = 400;
        else if(pagepos < pageposmax) pagepos = pageposmax;
        contextNode.addaction(moveto(300,pagepos,240));
    }

    function beginbuild(n,e,param,x,y){
        if(global.currentLevel <= 1){
            if(e == EVENT_TOUCH){
                lasttime = time();
                lastx = n.pos()[0]+x+contextNode.pos()[0]-400;
                flagmove = 0;
                global.context[1].nodemove(n,EVENT_HITTEST,0,lastx,240);
                n.texture("dialogelement2e1.png");
                return 1;
            }
            else if(e== EVENT_MOVE){
                if(flagmove == 0){
                    if(x<0 || y<0 || x>n.size()[0] || x>n.size()[1])
                        flagmove =1;
                    else if(time()-lasttime > 1000)
                        flagmove =1;
                    if(flagmove==1){
                        n.texture("dialogelement2e.png");
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
                    if(buildable[param].get("ok")==1){
                        global.lastpage[0] = 6;
                        global.popContext(900+param);
                    }
                    else{
                        global.pushContext(self,new Warningdialog(buildable[param]),NonAutoPop);
                    }
                }
                else{
                    choosepage();
                }
            }
        }
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}