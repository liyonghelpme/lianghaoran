class Quitdialog extends ContextObject{
    function Quitdialog(){
        contextNode = null;
    }

    function paintNode(){
        contextname = "dialog-quit";
        contextNode = sprite("dialogback_quit.png").anchor(50,50).pos(400,240);
        var button = contextNode.addsprite("boxbutton1.png").anchor(50,50).pos(95,150).setevent(EVENT_TOUCH,closedialog,1);
        button.addlabel("退出",null,20).anchor(50,50).pos(62,19);
        button = contextNode.addsprite("boxbutton2.png").anchor(50,50).pos(255,150).setevent(EVENT_TOUCH,closedialog,0);
        button.addlabel("返回",null,20).anchor(50,50).pos(62,19);
    }

    function closedialog(node,event,p){
        if(p==1) quitgame();
        else global.popContext(null);
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}