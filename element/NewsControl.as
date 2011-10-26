class NewsControl extends ContextObject{
    var items;
    var left;
    var right;
    var pagetext;
    var pagemax;
    var pagenum;
    var length;
    var newspage;
    var lock;
    const PAGEITEMS = 9;
    function NewsControl(){
        contextname = "dialog-new";
        contextNode = null;
        items = new Array(0);
        pagenum = 1;
        lock=0;
    }

    function paintNode(){
        contextNode =node();
        contextNode.addsprite("pagenumback.png").anchor(50,50).pos(290,407);
        pagetext = contextNode.addlabel("1/1",null,20).anchor(50,50).pos(290,407).color(0,0,0,100);
        newspage = contextNode.addlabel("正在载入……",null,30).anchor(50,50).pos(290,227).color(0,0,0,100);
        pagemax = 1;
        left = contextNode.addsprite("warabout_left.png").anchor(100,50).pos(248,407).setevent(EVENT_UNTOUCH,choosePage,-1);
        right= contextNode.addsprite("warabout_right.png").anchor(0,50).pos(332,407).setevent(EVENT_UNTOUCH,choosePage,1);
        global.http.addrequest(0,"getnewsnum",["uid"],[global.userid],self,"setlength");
    }
    
    function setlength(r,rc,c){
        if(rc!=0){
            length = json_loads(c).get("id",0);
            pagemax = (length-1)/PAGEITEMS+1;
            choosePage(0,0,0);
        }
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
            if(lock==0){
                lock = 1;
                global.http.addrequest(0,"getnews",["uid","off","size"],[global.userid,len(items),5*PAGEITEMS],self,"addnewsitems");
            }
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
                    newspage.addsprite("dialogelement_newsflag.png").pos(54,83+i%PAGEITEMS*34);
                    var itemstr="";
                    if(item[1] == 0){
                        itemstr = "<b>"+global.getfriend(item[0]).get("name")+"<b>访问了你的领地";
                    }
                    else if(item[1] == 1){
                        itemstr = "<b>"+global.getfriend(item[0]).get("name")+"<b>帮助你打理城堡";
                    }
                    else if(item[1] == 2){
                        itemstr = "<b>"+global.getfriend(item[0]).get("name")+"<b>赠送了你礼物";
                    }
                    else if(item[1] == 3){
                        itemstr = "你战胜了<b>"+global.getfriend(item[0]).get("name")+"<b>";
                    }
                    else if(item[1] == 4){
                        itemstr = "<b>"+global.getfriend(item[0]).get("name")+"<b>战胜了你";
                    }
                    else if(item[1] == 5){
                        itemstr = "<b>"+global.getfriend(item[0]).get("name")+"<b>帮助你打开宝箱";
                    }
                    else if(item[1] == 6){
                        itemstr = "<b>"+global.getfriend(item[0]).get("name")+"<b>帮助你喂养了宠物";
                    }
                    global.addtext(newspage,75,73+i%PAGEITEMS*34,itemstr,20);
                }
            }
            else{
                newspage.addlabel("还没有任何新闻哦！",null,30).anchor(50,50).pos(290,227).color(0,0,0,100);
            }
        }
    }
    
    function useaction(p,rc,c){
        if(p=="addnewsitems"){
            addnewsitems(0,rc,c);
        }
        else if(p=="setlength"){
            setlength(0,rc,c);
        }
    }
    
    function addnewsitems(r,rc,c){
        lock=0;
        if(rc!=0){
            var data = json_loads(c);
            if(data.get("id",1)==0){
                return 0;
            }
            var newlist = data.get("news");
            for(var i=0;i<len(newlist);i++){
                items.append(newlist[i]);
            }
            choosePage(0,0,0);
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