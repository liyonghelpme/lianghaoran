class GiftControl extends ContextObject{
    var tabs;
    var selecttab;
    var pagenum;
    var pagemax;
    var left;
    var right;
    var gifts;
    var lock=0;

    function GiftControl(){
        contextname = "dialog-gift-ask&give";
        contextNode = null;
        tabs = new Array(6);
        gifts = new Array(12);
        pagemax = 2;
        pagenum = 1;
        lock=0;
    }

    function paintNode(){
        contextNode = sprite("dialogback_a.png").anchor(50,50).pos(400,240).size(439,383);
        contextNode.addsprite("gift.jpg").pos(25,13);
        global.addtext(contextNode,115,41,"选择一件礼物赠送给<g>"+global.getfriend(global.context[0].cpid).get("name")+"<g>",20);
        contextNode.addsprite("builddialogclose.png").anchor(100,0).pos(439,0).setevent(EVENT_UNTOUCH,closedialog);
        selecttab = -1;
        for(var i=0;i<12;i++){
            gifts[i] = sprite("gift"+str(i+1)+".png").anchor(50,50).pos(57,57);
        }
        for(i=0;i<6;i++){
            tabs[i] = contextNode.addsprite("dialogelement_gift0.png").pos(37+i%3*125,94+i/3*112).setevent(EVENT_UNTOUCH,choosetab,i);
        }
        left = contextNode.addsprite("left.png").anchor(50,50).pos(0,191).setevent(EVENT_UNTOUCH,choosepage,-1);
        right = contextNode.addsprite("right.png").anchor(50,50).pos(439,191).setevent(EVENT_UNTOUCH,choosepage,1);
        choosetab(0,0,0);
        choosepage(0,0,0);
        contextNode.addsprite("boxbutton1.png").pos(270,331).setevent(EVENT_TOUCH,gagift,1);
        contextNode.addlabel("索要",null,BUTTONFONTSIZE).anchor(50,50).pos(332,350);
        contextNode.addsprite("boxbutton4.png").pos(50,331).setevent(EVENT_TOUCH,gagift,0);
        contextNode.addlabel("赠送",null,BUTTONFONTSIZE).anchor(50,50).pos(112,350);
    }

    function reloadNode(re){
    }

    function gagift(n,e,p){
        if(global.currentLevel == 1 && lock==0){
            lock = 1+p;
            global.popContext(null);
            global.http.addrequest(1,"selectgift",["uid","fid","specialgoods","askorgive"],[global.userid,global.context[0].cuid,selecttab+(pagenum-1)*6,p],self,"gagiftover");
        }
    }
    
    function useaction(p,rc,c){
        if(p=="gagiftover"){
            gagiftover(0,rc,c);
        }
    }

    function gagiftover(r,rc,c){
        trace("selectgift",rc,c);
        var ganame=["你每天只能赠送给同一个好友至多一个礼物哦^_^","你每天只能向同一个好友至多索要一个礼物哦^_^"];
        if(rc!=0 && json_loads(c).get("id")==0){
            global.pushContext(null,new Warningdialog([ganame[lock-1],-1,5]),NonAutoPop);
        }
        lock = 0;
    }

    function choosepage(n,e,p){
        var newp = pagenum+p;
        if(newp < 1 || newp > pagemax)
            return 0;
        if(newp == 1) left.color(40,40,40,100);
        else left.color(100,100,100,100);
        if(newp == pagemax) right.color(40,40,40,100);
        else right.color(100,100,100,100);
        pagenum = newp;
        for(var i=0;i<12;i++){
            if(i/6 == pagenum-1)
                tabs[i%6].add(gifts[i]);
            else
                gifts[i].removefromparent();
        }
    }
    function choosetab(n,e,p){
        if(selecttab != p){
            if(selecttab>=0)
                tabs[selecttab].texture("dialogelement_gift0.png");
            tabs[p].texture("dialogelement_gift1.png");
            selecttab = p;
        }
    }

    function closedialog(node,event){
        global.popContext(null);
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}