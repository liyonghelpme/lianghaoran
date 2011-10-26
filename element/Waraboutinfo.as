import element.Attacklistpage;
import element.Defencelistpage;
import element.Warrecordpage;
import element.Warrecordinfo;
import element.Warrecordlist;
class Waraboutinfo extends ContextObject{
    var pageindex;
    var pages;
    var tabs;
    var attackpage;
    var mode;
    function Waraboutinfo(m){
        contextname = "dialog-warinfo";
        contextNode = null;
        tabs = new Array(0);
        pageindex = -1;
        mode = m;
    }

    function paintNode(){
        contextNode = sprite("dialogback_warabout.png").anchor(50,100).pos(400,480);
        contextNode.addsprite("warabout"+str(mode)+".png").pos(205,37);
        contextNode.addsprite("builddialogclose.png").anchor(100,0).pos(741,0).setevent(EVENT_UNTOUCH,closedialog);
        
        if(mode == 0){
            pages = new Array(new Warrecordpage(),new Attacklistpage(),new Defencelistpage());
        }
        else{
            pages = new Array(new Warrecordinfo(),new Warrecordlist(),new Warrecordlist());
            //http_request(BASE_URL+"warrecord/"+str(global.userid),getrecordover);
            //if(global.user.getValue("warrecord")!=0){
                global.http.addrequest(1,"warrecord",["uid"],[global.userid],self,"getrecordover");
            //}
            //else{
            //    var info = global.user.getValue("warrecord");
            //    pages[0].setinfo(info);
            //    pages[1].setinfo(info.get("wonlist"));
            //    pages[2].setinfo(info.get("lostlist"));
            //}
        }
        for(var i=0;i<len(pages);i++){
            var tab = contextNode.addsprite("dialogtab_warabout0.png").anchor(0,100).pos(i*121+279,58).setevent(EVENT_UNTOUCH,changePage,i);
            tab.add(sprite("warinfotab"+str(mode)+str((i+(1-mode)*2)%3)+".png").anchor(50,50).pos(58,18),2,2);
            pages[i].self = pages[i];
            pages[i].global = global;
            tabs.append(tab);
        }
        changePage(0,0,0);
    }
    
    function useaction(p,rc,c){
        if(p=="getrecordover"){
            getrecordover(0,rc,c);
        }
    }
    
    function getrecordover(r,rc,c){
        trace("warrecord",rc,c);
        var info = json_loads(c);
        pages[0].setinfo(info);
        pages[1].setinfo(info.get("wonlist"));
        pages[2].setinfo(info.get("lostlist"));
    }

    function changePage(n,e,i){
        if(pageindex >= 0 && pageindex != i){
            pages[pageindex].getNode().removefromparent();
            tabs[pageindex].texture("dialogtab_warabout0.png");
        }
        if(pageindex != i){
            contextNode.add(pages[i].getNode());
            tabs[i].texture("dialogtab_warabout1.png");
            pageindex = i;
        }
    }

    function closedialog(node,event){
        global.popContext(null);
    }

    function deleteContext(){
        if(mode==0){
            pages[0].deleteContext();
        }
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}