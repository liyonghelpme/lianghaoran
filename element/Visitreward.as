class Visitreward extends ContextObject{
    var bonus;
    function Visitreward(b){
        contextname = "dialog-reward-visit";
        contextNode = null;
        bonus = b;
    }

    function paintNode(){
        contextNode = sprite("dialogback_normal.png").anchor(50,50).pos(400,240);
        contextNode.addsprite("boxbutton1.png").anchor(50,50).pos(257,400).setevent(EVENT_TOUCH,closedialog,1);
        contextNode.addlabel("分享",null,BUTTONFONTSIZE).anchor(50,50).pos(257,400);
        contextNode.addsprite("boxbutton2.png").anchor(50,50).pos(417,400).setevent(EVENT_TOUCH,closedialog,null);
        contextNode.addlabel("返回",null,BUTTONFONTSIZE).anchor(50,50).pos(417,400);
        var dailyback = contextNode.addsprite("dialogback_visitfriend.jpg").pos(163,40);
        global.user.changeValue("money",bonus);
        dailyback.addsprite("money_big.png").anchor(50,50).pos(147,222).size(30,30);
        dailyback.addlabel("x "+str(bonus),null,30).anchor(0,50).pos(170,222).color(0,0,0,100);
    }

    function closedialog(node,event,p){
        if(p==1){
            ppy_postnewsfeed(ppy_username()+"访问好友获得了奖励，赶快加入与"+ppy_username()+"一起打造属于自己的奇迹帝国吧！","http://getmugua.com");
        }
        global.popContext(null);
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}