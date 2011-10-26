class Levelupdialog extends ContextObject{
    function Levelupdialog(){
        trace("level init");
        contextname = "dialog-reward-levelup";
        contextNode = null;
    }

    function paintNode(){
        trace("level up pop");
        if(global.flagnew == 1){
            global.newcontext.getNode().visible(0);
            global.dark[len(global.dark)-1].visible(1);
        }
        var level = global.user.getValue("level");
        contextNode = sprite("dialogback_normal.png").anchor(50,50).pos(400,240);
        if(level>3){
            contextNode.addsprite("boxbutton1.png").anchor(50,50).pos(257,400).setevent(EVENT_TOUCH,closedialog,1);
            contextNode.addlabel("分享",null,BUTTONFONTSIZE).anchor(50,50).pos(257,400);
            contextNode.addsprite("boxbutton2.png").anchor(50,50).pos(417,400).setevent(EVENT_TOUCH,closedialog,null);
            contextNode.addlabel("返回",null,BUTTONFONTSIZE).anchor(50,50).pos(417,400);
        }
        else{
            contextNode.addsprite("boxbutton1.png").anchor(50,50).pos(380,400).setevent(EVENT_TOUCH,closedialog,null);
            contextNode.addlabel("确定",null,BUTTONFONTSIZE).anchor(50,50).pos(380,400);
        }
        var levelback = contextNode.addsprite("dialogback_levup.jpg").pos(163,40);
        levelback.addlabel(str(global.user.getValue("level")),null,36).anchor(0,50).pos(299,48).color(100,0,0,100);
        levelback.addsprite("money_big.png").anchor(50,50).pos(144,137).size(24,24);
        var m = global.user.getValue("level")*200;
        levelback.addlabel(str(m),null,24).anchor(0,50).pos(160,137).color(0,0,0,100);
        
        if(level%10==0){
            levelback.addsprite("caesars_big.png").anchor(50,50).pos(260,137).size(24,24);
            levelback.addlabel(str(level/10),null,24).anchor(0,50).pos(276,137).color(0,0,0,100);
            levelback.addsprite("personlimit.png").anchor(50,50).pos(360,137).size(22,24);
            levelback.addlabel(str(250),null,24).anchor(0,50).pos(376,137).color(0,0,0,100);
        }
        var unlockobjs = new Array(0);
        if(global.user.getValue("level")<len(UNLOCK)&&UNLOCK[global.user.getValue("level")] != ""){
            unlockobjs = UNLOCK[global.user.getValue("level")].split(";");
        }
        for(var i=0;i<len(unlockobjs);i++){
            var obj = unlockobjs[i].split(",");
            levelback.addsprite("dialogelement_objunlock.png").anchor(50,50).pos(i%3*88+144,212+i/3*75);
            levelback.addsprite(obj[1]).anchor(50,50).pos(i%3*88+144,212+i/3*75).scale(int(obj[0]));
        }
    }
    
    function closedialog(node,event,p){
        global.popContext(null);
        var level = global.user.getValue("level");
        global.user.changeValueAnimate2(global.context[0].moneyb,"money",level*200,-8);
        if(level%10==0){
            global.user.changeValueAnimate2(global.context[0].ub,"personmax",250,-6);
            global.user.changeValueAnimate2(global.context[0].moneyb,"caesars",level/10,-6);
        }
        if(p==1){
            global.http.addrequest(0,"share",["uid"],[global.userid],global.context[0],"share");
            ppy_postnewsfeed(ppy_username()+"升到第"+str(global.user.getValue("level"))+"级啦，赶快加入与"+ppy_username()+"一起打造属于自己的奇迹帝国吧！","http://getmugua.com");
        }
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        if(global.flagnew==1){
            global.newcontext.contextNode.visible(1);
        }
    }
}