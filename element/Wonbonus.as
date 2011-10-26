class Wonbonus extends ContextObject{
    var bonus;
    var bnum;
    function Wonbonus(bn,bo){
        bnum=bn;
        bonus=bo;
        contextname = "dialog-expand";
        contextNode = null;
    }

    function paintNode(){
        contextNode = sprite("dialogback_expand.png",ARGB_8888).anchor(50,50).pos(400,300);
        contextNode.addsprite("girl1.png").anchor(50,100).pos(0,310).size(191,409);
        contextNode.addlabel("恭喜你获得了"+str(bonus)+"银币的进贡。你当前拥有"+str(bnum)+"个殖民地。殖民地越多你每天收获的进贡越多哦!",null,26,FONT_BOLD,308,0,ALIGN_LEFT).anchor(0,50).pos(100,114).color(0,0,0,100);
        contextNode.addsprite("dialogelement_help.png").scale(150).pos(308,140).setevent(EVENT_UNTOUCH,gotohelp,"colony");
        contextNode.addsprite("boxbutton1.png").anchor(50,50).pos(150,234).setevent(EVENT_UNTOUCH,closedialog,1);
        contextNode.addlabel("分享",null,BUTTONFONTSIZE).anchor(50,50).pos(150,234);
        contextNode.addsprite("boxbutton2.png").anchor(50,50).pos(300,234).setevent(EVENT_UNTOUCH,closedialog,null);
        contextNode.addlabel("返回",null,BUTTONFONTSIZE).anchor(50,50).pos(300,234);
    }
    
    function gotohelp(n,e,p,x,y){
        if(x>0&&y>0&&x<n.size()[0]&&y<n.size()[1]){
            global.pushContext(null,new TestWebControl(p),NonAutoPop);
        }
    }
    
    function closedialog(n,e,p){
        global.popContext(null);
        if(p!=null){
            global.http.addrequest(0,"share",["uid"],[global.userid],global.context[0],"share");
            ppy_postnewsfeed(ppy_username()+"从殖民地获取了进攻奖励，赶快加入与"+ppy_username()+"一起打造属于自己的奇迹帝国吧！","http://getmugua.com");
        }
    }

    function deleteContext(){
        contextNode.removefromparent();
    }
}