class Activitydialog extends ContextObject{
    function Activitydialog(){
        contextname = "dialog-activity";
        contextNode = null;
    }

    function paintNode(){
        contextNode = sprite("dialogback_normal.png").anchor(50,50).pos(400,240);
        contextNode.addsprite("activityback.jpg").pos(156,30);
        contextNode.addsprite("boxbutton1.png").anchor(50,50).pos(257,400).setevent(EVENT_TOUCH,closedialog,1);
        contextNode.addlabel("去看看",null,BUTTONFONTSIZE).anchor(50,50).pos(257,400);
        contextNode.addsprite("boxbutton2.png").anchor(50,50).pos(417,400).setevent(EVENT_TOUCH,closedialog,null);
        contextNode.addlabel("知道了",null,BUTTONFONTSIZE).anchor(50,50).pos(417,400);
    }

    function closedialog(node,event,p){
        global.popContext(null);
        if(p==1){
            global.pushContext(null,new TestWebControl(0),NonAutoPop);
        }
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}