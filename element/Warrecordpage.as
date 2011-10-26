class Warrecordpage extends ContextObject{
    var items;
    var datas;
    var left;
    var right;
    var pagetext;
    var powertext;
    var pagemax;
    var pagenum;
    var length;
    const PAGEITEMS = 6;
    var removelist;
    function Warrecordpage(){
        contextname = "element-warinfo-warrecord";
        contextNode = null;
        items = new Array(0);
        datas = new Array(0);
        removelist = new Array(0);
        pagenum = 1;
        length = 0;
        pagemax = 1;
    }

    function paintNode(){
        contextNode = node();
        var outnum = 0;
        datas = global.user.getValue("warrecordlist");
        length = len(datas);
        pagemax = (length-1)/PAGEITEMS+1;
        for(var i=0;i<length;i++)
            items.append(null);
        pagetext = contextNode.addlabel("1/1",null,20).anchor(50,50).pos(505,414).color(0,0,0,100);
        left = contextNode.addsprite("warabout_left.png").anchor(100,50).pos(463,414).setevent(EVENT_UNTOUCH,choosePage,-1);
        right= contextNode.addsprite("warabout_right.png").anchor(0,50).pos(547,414).setevent(EVENT_UNTOUCH,choosePage,1);
        choosePage(0,0,0);
    }

    function choosePage(n,e,po){
        if(pagenum == 1 && po == -1 || pagenum == pagemax && po == 1)
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
        for(var i = 0;i<length;i++){
            if(i/PAGEITEMS+1!=p && items[i]!=null){
                items[i].removefromparent();
                items[i] = null;
            }
            else if(i/PAGEITEMS+1 == p&&items[i]==null){
                contextNode.add(getitem(i));
            }
        }
        pagenum = p;
        pagetext.text(str(pagenum)+"/"+str(pagemax));
    }
    
    function getitem(index){
        items[index] = sprite("warrecordcell"+datas[index][1]+".jpg").pos(270,80+index%PAGEITEMS*51);
        items[index].addsprite(avatar_url(int(datas[index][7]))).size(40,40).pos(10,6);
        //items[index].addlabel(global.getdtimestr(datas[index][0]-global.timer.currenttime),null,24).anchor(50,50).pos(205,21).color(0,0,0,100);
        items[index].addlabel(datas[index][10],null,18).pos(58,7).color(0,0,0,100);
        if(datas[index][0]==0){
            items[index].addlabel("该请求已处理",null,20,FONT_ITALIC).pos(305,14).color(20,20,20,100);
        }
        else{
            items[index].addsprite("wrbutton1.png").pos(296,8).setevent(EVENT_UNTOUCH,receivegift,index);
            items[index].addsprite("wrbutton0.png").pos(382,8).setevent(EVENT_UNTOUCH,receivegift,-index-1);
        }
        return items[index];
    }
    
    function receivegift(n,e,p){
            var record = new WarControl(0);
            record.init(record,global);
            record.datadict = record.formatstringtodata(datas[p]);
            record.flagresult = 1;
        if(p>=0){
            record.flaganimate=1;
        }
        else{
            record.flaganimate=0;
            p=-p-1;
        }
            global.pushContext(null,record,NonAutoPop);
        datas[p][0]=0;
        items[p].removefromparent();
        contextNode.add(getitem(p));
        removelist.append(p);
    }

    function closedialog(node,event){
        global.popContext(null);
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        if(len(removelist)>0){
            var removestr = json_dumps(removelist);
            global.http.addrequest(0,"removeRead",["uid","warList"],[global.userid,removestr],global.context[0],"nothing");
            global.user.changeValue("warrecordnum",-len(removelist));
            removelist.clear();
        }
    }
}