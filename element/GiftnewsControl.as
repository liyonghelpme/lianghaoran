class GiftnewsControl extends ContextObject{
    var items;
    var left;
    var right;
    var pagetext;
    var pagemax;
    var pagenum;
    var length;
    var newspage;
    var lock;
    const PAGEITEMS = 5;
    function GiftnewsControl(){
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
        left = contextNode.addsprite("warabout_left.png").anchor(100,50).pos(248,407).setevent(EVENT_UNTOUCH,choosePage,-1);
        right= contextNode.addsprite("warabout_right.png").anchor(0,50).pos(332,407).setevent(EVENT_UNTOUCH,choosePage,1);
        newspage = contextNode.addlabel("正在载入……",null,30).anchor(50,50).pos(290,227).color(0,0,0,100);
        pagemax = 1;
        length = global.user.getValue("newgift");
        pagemax = (length-1)/PAGEITEMS+1;
        items = global.user.getValue("buffgift");
        if(items == 0){
            items = new Array(0);
        }
        choosePage(0,0,0);
    }
    
    function choosePage(n,e,po){
        if(global.context[0].reqlock==1 ||lock==1 || pagenum == 1 && po == -1 || pagenum == pagemax && po == 1)
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
            global.http.addrequest(0,"getgift",["uid","off","num"],[ppy_userid(),0,length],self,"addnewsitems");
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
                    var cell=newspage.addsprite("infocell"+str(item[3])+".jpg").pos(30,79+i%PAGEITEMS*60);
                    var itemstr=global.getfriend(item[1]).get("name");
                    cell.addsprite(avatar_url(int(item[1]))).pos(12,6).size(40,40);
                    var giftstr = GIFTNAME[item[2]];
                    
                    if(item[3] == 0){
                        itemstr = itemstr+"赠送你礼物"+giftstr;
                    }
                    else{
                        itemstr = itemstr+"向你索取礼物"+giftstr;
                    }
                    cell.addlabel(itemstr,null,20).pos(57,19).color(0,0,0,100);
                    if(item[0]==-1){
                        cell.addlabel("该请求已处理",null,20,FONT_ITALIC).pos(374,19).color(20,20,20,100);
                    }
                    else{
                        if(item[3]==1){
                            cell.addsprite("infobutton1.png").pos(452,8).setevent(EVENT_UNTOUCH,receivegift,-i-1);
                        }
                        cell.addsprite("infobutton0.png").pos(374,8).setevent(EVENT_UNTOUCH,receivegift,i);
                    }
                }
            }
            else{
                newspage.addlabel("还没有任何请求哦！",null,30).anchor(50,50).pos(290,227).color(0,0,0,100);
            }
        }
    }
    
    function receivegift(n,e,p){
        //
        //
        var index = p;
        var refuse = 0;
        if(index<0){
            index=-index-1;
            refuse = 1;
        }
        var item = items[index];
        var id=item[0];
        item[0]=-1;
        if(refuse==1){
            var ag=2;
        }
        else{
            ag = item[3];
            if(ag==0){
                global.special[item[2]]++;
            }
        }
        global.user.changeValue("newgift",-1);
        var rdict = dict();
        rdict.update("name","receivegift");
        rdict.update("giftstr",item[1]+","+str(item[2])+","+str(ag)+","+str(id));
        global.context[0].reqlist.append(rdict);
        choosePage(0,0,0);
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
            var giftlist = data.get("gift");
            for(var i=0;i<len(giftlist);i++){
                items.append(giftlist[i]);
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
                if(items[i][0]==-1){
                    items.pop(i);
                }
            }
            global.user.setValue("buffgift",items);
        }
    }
}