import element.GiftnewsControl;
import element.ChatnewsControl;
import element.NewsControl;
class Infodialog extends ContextObject{
    var pageindex;
    var pages;
    var tabs;
    var attackpage;
    var mode;
    function Infodialog(){
        contextname = "dialog-info";
        contextNode = null;
        tabs = new Array(0);
        pageindex = -1;
    }

    function paintNode(){
        contextNode = sprite("dialogback_info.png").anchor(50,50).pos(400,240);
        contextNode.addsprite("builddialogclose.png").anchor(100,0).pos(575,5).setevent(EVENT_UNTOUCH,closedialog);
        pages = new Array(new ChatnewsControl(),new GiftnewsControl(),new NewsControl());
        for(var i=0;i<len(pages);i++){
            var tab = contextNode.addsprite("newinfotab1.png").anchor(0,100).pos(i*108+128,61).setevent(EVENT_UNTOUCH,changePage,i);
            tab.add(sprite("newstab"+str(i)+".png").anchor(50,50).pos(53,19),2,2);
            pages[i].init(pages[i],global);
            tabs.append(tab);
        }
        changePage(0,0,0);
    }
    
    function changePage(n,e,i){
        if(pageindex >= 0 && pageindex != i){
            pages[pageindex].getNode().removefromparent();
            tabs[pageindex].texture("newinfotab1.png");
        }
        if(pageindex != i){
            contextNode.add(pages[i].getNode());
            tabs[i].texture("newinfotab0.png");
            pageindex = i;
        }
    }

    function closedialog(node,event){
        global.popContext(null);
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        if(pages[1].contextNode!=null){
            pages[1].deleteContext();
        }
    }
}