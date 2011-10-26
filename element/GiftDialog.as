class GiftDialog extends ContextObject{
    var giftid;
    var ppyid;
    var askorgive;
    function GiftDialog(p,g,a){
        contextname = "dialog-gift-notice";
        contextNode = null;
        ppyid=p;
        giftid=g;
        askorgive=a;
    }

    function paintNode(){
        var button;
        var name = global.getfriend(ppyid).get("name");
        contextNode = sprite("dialogback_b.png").anchor(50,50).pos(400,240);
        contextNode.addsprite("dialogback_receivegift"+str(askorgive)+".jpg").pos(16,15);
        if(askorgive==0){
            contextNode.addsprite(avatar_url(ppyid)).pos(24,23).size(50,50);
            contextNode.addlabel(name,null,16).anchor(0,50).pos(195,37).color(96,54,4,100);
            contextNode.addsprite("gift"+str(giftid+1)+".png").anchor(50,50).pos(248,105);
            button = contextNode.addsprite("boxbutton1.png").anchor(50,0).pos(202,200).setevent(EVENT_TOUCH,closedialog,1);
            button.addlabel("接受",null,20).anchor(50,50).pos(62,19);
        }
        else{
            contextNode.addsprite(avatar_url(ppyid)).pos(325,23).size(50,50);
            contextNode.addlabel(name,null,16).anchor(0,50).pos(104,37).color(96,54,4,100);
            contextNode.addsprite("gift"+str(giftid+1)+".png").anchor(50,50).pos(154,105);
            button = contextNode.addsprite("boxbutton1.png").pos(52,200).setevent(EVENT_TOUCH,closedialog,1);
            button.addlabel("赠送",null,20).anchor(50,50).pos(62,19);
            button = contextNode.addsprite("boxbutton2.png").pos(227,200).setevent(EVENT_TOUCH,closedialog,0);
            button.addlabel("返回",null,20).anchor(50,50).pos(62,19);
        }
    }

    function closedialog(node,event,p){
        if(p==1){
            var req = dict();
            req.update("name","receivegift");
            req.update("giftstr",str(ppyid)+","+str(giftid)+","+str(askorgive));
            global.context[0].reqlist.append(req);
            if(askorgive == 0){
                global.special[giftid]++;
            }
        }
        global.popContext(null);
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}