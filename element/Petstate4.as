class Petstate4 extends ContextObject{
    var build;
    function Petstate4(b){
        build=b;
        contextname = "dialog-pet-state4";
        contextNode = null;
    }

    function paintNode(){
        contextNode = sprite("dialogback_expand.png",ARGB_8888).anchor(50,50).pos(400,300);
        contextNode.addsprite("girl1.png").anchor(50,100).pos(0,310).size(191,409);
        contextNode.addlabel(build.petname+"孵化成功啦！它是一条土属性龙。目前成长点为：51，属性为："+str(PETS_UP[build.objid])+"，战斗力为："+str(build.attack),null,26,FONT_BOLD,308,0,ALIGN_LEFT).anchor(0,50).pos(100,114).color(0,0,0,100);
        //contextNode.addsprite("dialogelement_help.png").scale(150).pos(334,166).setevent(EVENT_UNTOUCH,gotohelp,"colony");
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
            ppy_postnewsfeed(ppy_username()+"成功孵化出宠物，赶快加入与"+ppy_username()+"一起打造属于自己的奇迹帝国吧！","http://getmugua.com");
        }
    }

    function deleteContext(){
        contextNode.removefromparent();
    }
}