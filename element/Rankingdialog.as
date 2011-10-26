class Rankingpage extends ContextObject{
    var mode;
    var type;
    var items;
    var left;
    var right;
    var pagetext;
    var pagemax;
    var pagenum;
    var length;
    var newspage;
    var lock;
    const PAGEITEMS = 7;
    const cmd=["fortunerank","warrank","exprank","foodrank"];
    function Rankingpage(m,t){
        mode = m;
        type = t;
        contextname = "dialog-rankpage";
        contextNode = null;
        items = new Array(0);
        pagenum = 1;
        lock=0;
    }
    function paintNode(){
        contextNode =node();
        pagetext = contextNode.addlabel("1/1",null,20).anchor(50,50).pos(290,407).color(0,0,0,100);
        pagemax = 1;
        if(type==0){
            length = 19;
        }
        else{
            length = len(global.ppyuserdict)-2;
        }
        pagemax = (length+1)/PAGEITEMS+1;
        items = global.user.getValue("buffpage"+str(mode*2+type));
        if(items == 0){
            items = new Array(0);
        }
        contextNode =node();
        pagetext = contextNode.addlabel("1/1",null,20).anchor(50,50).pos(360,438).color(0,0,0,100);
        newspage = contextNode.addlabel("正在载入……",null,30).anchor(50,50).pos(360,296).color(0,0,0,100);
        left = contextNode.addsprite("rankleft.png").anchor(50,50).pos(313,438).setevent(EVENT_UNTOUCH,choosePage,-1);
        right= contextNode.addsprite("rankright.png").anchor(50,50).pos(407,438).setevent(EVENT_UNTOUCH,choosePage,1);
        choosePage(0,0,0);
    }

    function choosePage(n,e,po){
        if(lock==1 || pagenum == 1 && po == -1 || pagenum == pagemax && po == 1)
            return 0;
        if(po==0 && type==1){
            var selfindex=0;
            for(var i=0;i<len(items);i++){
                if(int(items[i][2])==ppy_userid()){
                    selfindex = i;
                    break;
                }
            }
            po = (selfindex+2)/7;
        }
        var p = pagenum+po;
        if(p>1)
            left.texture("rankleft.png",NORMAL);
        else
            left.texture("rankleft.png",GRAY);
        if(p < pagemax)
            right.texture("rankright.png",NORMAL);
        else
            right.texture("rankright.png",GRAY);
        pagenum = p;
        pagetext.text(str(pagenum)+"/"+str(pagemax));
        var fpage = pagenum+10;
        var fix = "";
        if(fpage>pagemax){
            fpage=pagemax;
        }
        if(len(items) < fpage*PAGEITEMS && len(items)<length){
            if(lock==0){
                lock = 1;
                global.http.addrequest(0,cmd[mode],["type","off","num","uid"],[type,len(items)+1,length,global.userid],self,"addnewsitems");
            }
        }
        else{
            newspage.removefromparent();
            newspage = contextNode.addnode();
            if(length>0){
                if(pagenum==1){
                    for(i=0;i<3;i++){
                        if(i>=length){
                            break;
                        }
                        var item = items[i];
                        if(int(item[2])==ppy_userid()){
                            fix="self";
                        }
                        else{
                            fix="";
                        }
                        var cell=newspage.addsprite().pos(109,159+i*62);
                        cell.addlabel(str(i+1),null,30,FONT_BOLD).pos(22,14).color(0,0,0,100);
                        cell.addsprite(avatar_url(int(item[2]))).pos(86,9).size(40,40);
                        cell.addlabel(item[0],null,16,FONT_BOLD).pos(133,9).color(0,0,0,100);
                        cell.addlabel(item[1],null,16,FONT_BOLD).pos(319,9).color(0,0,0,100);
                        if(mode==0){
                            cell.texture("rankcell4"+fix+".jpg");
                            cell.addlabel("Level "+str(item[4]),null,16,FONT_BOLD).pos(133,34).color(0,0,0,100);
                            cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(341,34).color(0,0,0,100);
                            //cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(412,34).color(0,0,0,100);
                        }
                        else if(mode==3){
                            cell.texture("rankcell8"+fix+".jpg");
                            cell.addlabel("Level "+str(item[4]),null,16,FONT_BOLD).pos(133,34).color(0,0,0,100);
                            cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(341,34).color(0,0,0,100);
                            //cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(412,34).color(0,0,0,100);
                        }
                        else if(mode==2){
                            cell.texture("rankcell10"+fix+".jpg");
                            cell.addlabel("Level "+str(item[4]),null,16,FONT_BOLD).pos(133,34).color(0,0,0,100);
                            cell.addsprite("exp.png").size(32,20).pos(319,32);
                            cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(353,34).color(0,0,0,100);
                            //cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(412,34).color(0,0,0,100);
                        }
                        else if(mode==1){
                            cell.texture("rankcell6"+fix+".jpg");
                            var nob=item[6]*3+item[7];
                            if(nob>=0){
                                cell.addsprite("nobi"+str(nob)+".png").size(24,24).pos(134,27);
                                cell.addlabel(NOBNAME[nob],null,16,FONT_BOLD).pos(164,34).color(0,0,0,100);
                            }
                            else{
                                cell.addlabel("未开启战争模式",null,16,FONT_BOLD).pos(134,34).color(0,0,0,100);
                            }
                            cell.addlabel("胜利数：",null,16,FONT_BOLD).pos(350,34).color(0,0,0,100);
                            cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(414,34).color(0,0,67,100);
                        }
                    }
                    for(i=3;i<5;i++){
                        if(i>=length){
                            break;
                        }
                        item = items[i];
                        if(int(item[2])==ppy_userid()){
                            fix="self";
                        }
                        else{
                            fix="";
                        }
                        cell=newspage.addsprite("rankcell"+str(-mode*2+9)+fix+".jpg").pos(109,233+i*37);
                        cell.addlabel(str(i+1),null,16).pos(8,10).color(0,0,0,100);
                        cell.addlabel(item[0],null,16,FONT_BOLD).pos(36,10).color(0,0,0,100);
                        cell.addlabel(item[1],null,16,FONT_BOLD).pos(165,10).color(0,0,0,100);
                        
                        if(mode==0){
                            cell.texture("rankcell5"+fix+".jpg");
                            cell.addlabel("lv "+str(item[4]),null,16,FONT_BOLD).pos(304,10).color(0,0,0,100);
                            cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(388,10).color(0,0,0,100);
                            //cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(436,10).color(0,0,0,100);
                        }
                        else if(mode==2){
                            cell.texture("rankcell11"+fix+".jpg");
                            cell.addsprite("exp.png").size(32,20).pos(365,8);
                            cell.addlabel("lv "+str(item[4]),null,16,FONT_BOLD).pos(304,10).color(0,0,0,100);
                            cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(400,10).color(0,0,0,100);
                            //cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(436,10).color(0,0,0,100);
                        }
                        else if(mode==3){
                            cell.texture("rankcell9"+fix+".jpg");
                            cell.addlabel("lv "+str(item[4]),null,16,FONT_BOLD).pos(304,10).color(0,0,0,100);
                            cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(388,10).color(0,0,0,100);
                            //cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(436,10).color(0,0,0,100);
                        }
                        else if(mode==1){
                            cell.texture("rankcell7"+fix+".jpg");
                            nob=item[6]*3+item[7];
                            if(nob>=0){
                                cell.addlabel(NOBNAME[nob],null,16,FONT_BOLD).pos(299,10).color(0,0,0,100);
                            }
                            else{
                                cell.addlabel("未开启",null,16,FONT_BOLD).pos(299,10).color(0,0,0,100);
                            }
                            cell.addlabel("胜利数：",null,16,FONT_BOLD).pos(408,10).color(0,0,0,100);
                            cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(472,10).color(0,0,67,100);
                        }
                    }
                }
                else{
                    for(i=(pagenum-1)*PAGEITEMS-2;i<pagenum*PAGEITEMS-2;i++){
                        if(i>=length){
                            break;
                        }
                        item = items[i];
                        if(int(item[2])==ppy_userid()){
                            fix="self";
                        }
                        else{
                            fix="";
                        }
                        cell=newspage.addsprite().pos(109,159+(i-5)%PAGEITEMS*37);
                        
                        cell.addlabel(str(i+1),null,16).pos(8,10).color(0,0,0,100);
                        cell.addlabel(item[0],null,16,FONT_BOLD).pos(36,10).color(0,0,0,100);
                        cell.addlabel(item[1],null,16,FONT_BOLD).pos(165,10).color(0,0,0,100);
                        if(mode==0){
                            cell.texture("rankcell5"+fix+".jpg");
                            cell.addlabel("lv "+str(item[4]),null,16,FONT_BOLD).pos(304,10).color(0,0,0,100);
                            cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(388,10).color(0,0,0,100);
                            //cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(436,10).color(0,0,0,100);
                        }
                        else if(mode==2){
                            cell.texture("rankcell11"+fix+".jpg");
                            cell.addsprite("exp.png").size(32,20).pos(365,8);
                            cell.addlabel("lv "+str(item[4]),null,16,FONT_BOLD).pos(304,10).color(0,0,0,100);
                            cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(400,10).color(0,0,0,100);
                            //cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(436,10).color(0,0,0,100);
                        }
                        else if(mode==3){
                            cell.texture("rankcell9"+fix+".jpg");
                            cell.addlabel("lv "+str(item[4]),null,16,FONT_BOLD).pos(304,10).color(0,0,0,100);
                            cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(388,10).color(0,0,0,100);
                            //cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(436,10).color(0,0,0,100);
                        }
                        else if(mode==1){
                            cell.texture("rankcell7"+fix+".jpg");
                            nob=item[6]*3+item[7];
                            if(nob>=0){
                                cell.addlabel(NOBNAME[nob],null,16,FONT_BOLD).pos(299,10).color(0,0,0,100);
                            }
                            else{
                                cell.addlabel("未开启",null,16,FONT_BOLD).pos(299,10).color(0,0,0,100);
                            }
                            cell.addlabel("胜利数：",null,16,FONT_BOLD).pos(408,10).color(0,0,0,100);
                            cell.addlabel(str(item[5]),null,16,FONT_BOLD).pos(472,10).color(0,0,67,100);
                        }
                    }
                }
            }
        }
    }
    
    function useaction(p,rc,c){
        if(p=="addnewsitems"){
            addnewsitems(0,rc,c);
        }
    }
    
    function addnewsitems(r,rc,c){
        lock=0;
        if(rc!=0){
            var data = json_loads(c);
            if(data.get("id",1)==0){
                return 0;
            }
            var newlist = data.get("rank");
            for(var i=0;i<len(newlist);i++){
                var name = newlist[i][0];
                var l=len(name);
                var ll=len(uri_encode(name));
                if(l-(ll-l)/6>14){
                    newlist[i][0]=substring(name,0,12)+"..";
                }
                items.append(newlist[i]);
            }
            if(i<1){
                length = len(items);
                pagemax = (length+1)/PAGEITEMS+1;
            }
            choosePage(0,0,0);
        }
    }

    function deleteContext(){
        if(contextNode!=null){
            contextNode.addaction(stop());
            contextNode.removefromparent();
        }
        global.user.setValue("buffpage"+str(mode*2+type),items);
    }
}

class Rankingdialog extends ContextObject{
    var pageindex;
    var pages;
    var tabs;
    var types;
    var mode;
    function Rankingdialog(){
        contextname = "dialog-rank";
        contextNode = null;
        tabs = new Array(0);
        types = new Array(0);
        pageindex = -1;
        mode=0;
    }

    function paintNode(){
        contextNode = sprite("dialogback_rank.png").anchor(50,50).pos(400,240);
        contextNode.addsprite("builddialogclose.png").pos(605,73).setevent(EVENT_UNTOUCH,closedialog);
        pages = new Array(new Rankingpage(0,0),new Rankingpage(0,1),new Rankingpage(1,0),new Rankingpage(1,1),
        new Rankingpage(2,0),new Rankingpage(2,1),new Rankingpage(3,0),new Rankingpage(3,1));
        for(var i=0;i<8;i++){
            pages[i].init(pages[i],global);
        }
        for(i=0;i<4;i++){
            var tab = contextNode.addsprite("ranktabback1.png").pos(i*121+112,104).setevent(EVENT_UNTOUCH,choosetab,i);
            tab.addsprite("ranktab"+str(i)+".png").anchor(50,50).pos(60,20);
            tabs.append(tab);
        }
        for(i=0;i<2;i++){
            tab = contextNode.addsprite("ranktype"+str(i)+"_"+str(1-i)+".png").pos(63,145+i*138).setevent(EVENT_UNTOUCH,choosetype,i);
            types.append(tab);
        }
        tabs[0].prepare();
        choosetab(tabs[0],0,0,1,1);
    }
    
    function choosetab(n,e,p,x,y){
        if(x>0&&y>0&&x<119&&y<41){
            tabs[mode/2].texture("ranktabback1.png");
            mode = mode%2+p*2;
            tabs[p].texture("ranktabback0.png");
            changepage(mode);
        }
    }
    
    function choosetype(n,e,p,x,y){
        if(x>0&&y>0&&x<n.size()[0]&&y<n.size()[1]){
            mode = mode/2*2+p;
            types[0].texture("ranktype0_"+str(1-p)+".png");
            types[1].texture("ranktype1_"+str(p)+".png");
            changepage(mode);
        }
    }
    
    function changepage(i){
        if(pageindex >= 0 && pageindex != i){
            pages[pageindex].getNode().removefromparent();
        }
        if(pageindex != i){
            contextNode.add(pages[i].getNode());
            pageindex = i;
        }
    }

    function closedialog(node,event){
        global.popContext(null);
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        pages[0].deleteContext();
        pages[1].deleteContext();
        pages[2].deleteContext();
        pages[3].deleteContext();
    }
}