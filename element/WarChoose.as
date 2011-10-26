class WarChoose extends ContextObject{
    var buttons;
    function WarChoose(){
        contextname = "control-warchoose";
        contextNode = null;
    }

    function paintNode(){
        buttons = [0];
        contextNode = node().pos(400,240);
        if(global.user.getValue("level")<10){
            buttons.append(2);
        }
        else{
            buttons.append(1);
        }
        for(var k=0;k<len(buttons);k++){
            var bt = contextNode.addsprite("warchoosebuttonback0.png").pos(128*k-123,-60);
            bt.addsprite("warchoose"+str(buttons[k])+".png").anchor(50,50).pos(59,60);
            bt.setevent(EVENT_TOUCH,buttonclicked,k);
            bt.setevent(EVENT_UNTOUCH,buttonclicked,k);
        }
        if(buttons[1]==2&&global.user.getValue("level")<10){
            bt.texture("warchoosebuttonback0.png",GRAY);
        }
    }

    function reloadNode(re){
        if(re==1){
            global.context[0].warpage.initialdata();
            global.image.begindownload(2);
        }
    }

    function buttonclicked(n,e,p){
        if(global.currentLevel == contextLevel){
            var filter = NORMAL;
            if(p==1&&global.user.getValue("level")<10){
                filter = GRAY;
            }
            if(e==EVENT_TOUCH)
                n.texture("warchoosebuttonback1.png",filter);
            else{
                n.texture("warchoosebuttonback0.png",filter);
                global.popContext(null);
                if(buttons[p] == 0)
                    global.pushContext(null,global.context[0].warmap,NonAutoPop);
                else if(buttons[p] == 1){
                    if(global.user.getValue("nobility")<0){
                        var tmp=new Warningdialog([global.getStaticString(1),1,3]);
                        global.pushContext(self,tmp,NonAutoPop);
                        tmp.contextNode.addsprite("dialogelement_help.png").pos(248,125).scale(150).setevent(EVENT_UNTOUCH,gotohelp,"warmode");
                    }
                    else{
                        global.context[0].entermap(0,0);
                    }
                }
                else if(buttons[p]==2){
                    global.pushContext(null,new Warningdialog([global.getStaticString(0),null,1]),NonAutoPop);
                }
            }
        }
    }
    
    function gotohelp(n,e,p){
        global.pushContext(null,new TestWebControl(p),NonAutoPop);
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        contextNode = null;
    }
}