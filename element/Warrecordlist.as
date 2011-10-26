class Warrecordlist extends ContextObject{
    var items;
    var datas;
    var left;
    var right;
    var pagetext;
    var pagemax;
    var pagenum;
    var length;
    const PAGEITEMS = 6;
    function Warrecordlist(){
        contextname = "element-warinfo-record";
        contextNode = null;
        items = new Array(0);
        pagenum = 1;
        length = 0;
        pagemax = 1;
    }

    function paintNode(){
        contextNode = node();
        pagetext = contextNode.addlabel("1/1",null,20).anchor(50,50).pos(505,384).color(0,0,0,100);
        left = contextNode.addsprite("warabout_left.png").anchor(100,50).pos(463,384).setevent(EVENT_UNTOUCH,choosePage,-1);
        right= contextNode.addsprite("warabout_right.png").anchor(0,50).pos(547,384).setevent(EVENT_UNTOUCH,choosePage,1);
        contextNode.addlabel("注：每次进入新的战场，该列表将清空",null,20).pos(313,414).color(0,0,0,100);
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
        items[index] = sprite("warrecordcell.png").pos(290,80+index%PAGEITEMS*45);
        items[index].addsprite(avatar_url(int(datas[index][0]))).size(35,35).pos(14,4);
        items[index].addlabel(datas[index][1],null,24).anchor(0,50).pos(55,21).color(0,0,0,100);
        items[index].addlabel(global.getdatestr(datas[index][4]),null,24).anchor(100,50).pos(396,21).color(0,0,0,100);
        return items[index];
    }
    
    function setinfo(info){
        datas = info;
        length = len(datas);
        for(var i=0;i<length;i++){
            items.append(null);
        }
        pagemax = (length+PAGEITEMS-1)/PAGEITEMS;
        if(pagemax==0) pagemax=1;
    }
    
    function closedialog(node,event){
        global.popContext(null);
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}