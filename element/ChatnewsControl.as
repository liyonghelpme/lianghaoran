class ChatnewsControl extends ContextObject{
    var items;
    var left;
    var right;
    var pagetext;
    var pagemax;
    var pagenum;
    var length;
    var newspage;
    var lock;
    const PAGEITEMS = 3;
    function ChatnewsControl(){
        contextname = "dialog-chat";
        contextNode = null;
        items = new Array(0);
        pagenum = 1;
        lock=0;
    }

    function paintNode(){
        contextNode =node();
        contextNode.addsprite("pagenumback.png").anchor(50,50).pos(290,407);
        pagetext = contextNode.addlabel("1/1",null,20).anchor(50,50).pos(290,407).color(0,0,0,100);
        left = contextNode.addsprite("warabout_left.png").anchor(100,50).pos(248,407).setevent(EVENT_UNTOUCH,choosePage,-1);
        right= contextNode.addsprite("warabout_right.png").anchor(0,50).pos(332,407).setevent(EVENT_UNTOUCH,choosePage,1);
        newspage = contextNode.addlabel("正在载入……",null,30).anchor(50,50).pos(290,227).color(0,0,0,100);
        pagemax = 1;
        lock=1;
        global.http.addrequest(0,"fetchMsg",["uid","start","end"],[global.userid,0,-1],self,"addnewsitems");
        choosePage(0,0,0);
    }
    
    function choosePage(n,e,po){
        if(lock==1 || pagenum == 1 && po == -1 || pagenum == pagemax && po == 1)
            return 0;
        var p = pagenum+po;
        if(p>1)
            left.texture("warabout_left.png",NORMAL);
        else
            left.texture("warabout_left.png",GRAY);
        if(p < pagemax)
            right.texture("warabout_right.png",NORMAL);
        else
            right.texture("warabout_right.png",GRAY);
        pagenum = p;
        pagetext.text(str(pagenum)+"/"+str(pagemax));
        var fpage = pagenum+10;
        if(fpage>pagemax){
            fpage=pagemax;
        }
        if(len(items) < fpage*PAGEITEMS && len(items)<length){
            //if(lock==0){
            //    lock = 1;
            //global.http.addrequest(0,"getgift",["uid","off","num"],[ppy_userid(),0,length],self,"addnewsitems");
            //}
        }
        else{
            newspage.removefromparent();
            newspage = contextNode.addnode();
            if(length>0){
                for(var i=(pagenum-1)*PAGEITEMS;i<pagenum*PAGEITEMS;i++){
                    if(i>=length){
                        break;
                    }
                    var item = items[i];
                    var cell=newspage.addsprite("messagetab_new"+str(item[4])+".jpg").pos(30,76+i%PAGEITEMS*104);
                    if(item[4]==0){
                        cell.addsprite("new.png").pos(9,57);
                    }
                    var itemstr=global.getfriend(item[5]).get("name");
                    cell.addlabel(itemstr,null,16).pos(66,5).color(0,0,0,100);
                    cell.addlabel(global.getdatetimestr(item[3]),null,14).pos(277,8).color(0,0,0,100);
                    cell.addsprite(avatar_url(item[5])).pos(12,6).size(40,40).setevent(EVENT_UNTOUCH,receivegift,i);
                    cell.addlabel(item[2],null,16,FONT_NORMAL,448,0,ALIGN_LEFT).pos(64,32).color(0,0,0,100);
                    for(var j=0;j<2;j++){
                        var b=cell.addsprite("chatbuttonback0.png").pos(383+j*77,76);
                        b.setevent(EVENT_TOUCH,chatop);
                        b.setevent(EVENT_UNTOUCH,chatop,[i,j]);
                        b.addsprite("chatbutton"+str(j)+".png").anchor(50,50).pos(25,11);
                    }
                }
            }
            else{
                newspage.addlabel("还没有任何消息哦！",null,30).anchor(50,50).pos(290,227).color(0,0,0,100);
            }
        }
    }
    
    function chatop(n,e,p){
        if(e==EVENT_TOUCH){
            n.texture("chatbuttonback1.png");
            return;
        }
        n.texture("chatbuttonback0.png");
        if(p[1]==0){
            global.pushContext(null,new Chatdialog(items[p[0]][1]),NonAutoPop);
        }
        else{
            items.pop(p[0]);
            length--;
            pagemax=(length-1)/PAGEITEMS+1;
            choosePage(0,0,0);
        }
    }
    
    function receivegift(n,e,p){
        var index = p;
        var item = items[index];
        var id=item[5];
        global.popContext(null);
        global.context[0].getfriend(id);
    }
    
    function useaction(p,rc,c){
        if(p=="addnewsitems"){
            addnewsitems(0,rc,c);
        }
    }
    
    function addnewsitems(r,rc,c){
        trace("getnews",rc,c);
        lock=0;
        if(rc!=0){
            var data = json_loads(c);
            if(data==null||data.get("id",1)==0){
                return 0;
            }
            items = data.get("msg");
            length = len(items);
            pagemax=(length-1)/PAGEITEMS+1;
            for(var i=0;i<length;i++){
                items[i][5]=int(items[i][5]);
            }
            choosePage(0,0,0);
        }
    }

    function closedialog(node,event){
        global.popContext(null);
    }

    function deleteContext(){
        if(contextNode!=null){
            contextNode.addaction(stop());
            contextNode.removefromparent();
            for(var i=len(items)-1;i>=0;i--){
                if(items[i][5]==-1){
                    items.pop(i);
                }
            }
            global.user.setValue("buffgift",items);
        }
    }
}