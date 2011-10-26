class AllyControl extends ContextObject{
    var lock;
    var mode;
    var fname;
    var flagprev;
    var element;
    var dialog;
    function AllyControl(m){
        contextname = "dialog-ally";
        lock =0 ;
        flagprev = 0;
        contextNode = null;
        element = null;
        mode = m;
    }

    function getelement(){
        fname = global.getfriend(global.context[0].cpid).get("name");
        if(element == null){
            element = node();
            if(mode==0){
                element.addlabel("你还剩"+str(global.allymax-len(global.context[0].friend.flist2))+"个盟友名额",null,18).anchor(100,0).pos(358,26).color(0,0,0,100);
                element.addsprite("adddefence.png").anchor(50,50).pos(395,34).setevent(EVENT_UNTOUCH,addallybound);
                element.addlabel("你确定与Ta结盟吗？",null,24).pos(25,81).color(0,0,0,100);
                var ap = element.addsprite("allyelement.png").anchor(50,50).pos(219,159);
                ap.addsprite(avatar_url(global.context[0].cpid)).pos(38,22).size(50,50);
                ap.addlabel(fname,null,20).anchor(0,50).pos(103,48).color(0,0,0,100);
                element.addlabel("在你战斗时，盟军将会提供你士兵援助。请慎重结盟，取消盟约需要花费凯撒币！",null,20,FONT_NORMAL,340,0,ALIGN_LEFT).pos(32,226).color(0,0,0,100);
                dialog.usedefaultbutton(2,["结盟","返回"]);
            }
            else if(mode==1){
                element.addsprite("pic3.jpg").anchor(50,50).pos(80,120);
                element.addlabel("确定与"+fname+"取消结盟？",null,20,FONT_NORMAL,220,0,ALIGN_LEFT).pos(161,47).color(0,0,0,100);
                var cap = element.addsprite("cancelallyelement.png").anchor(50,50).pos(269,150);
                cap.addlabel("惩罚：",null,25).anchor(20,50).color(100,0,0,100);
                cap.addsprite("caesars_big.png").anchor(50,50).pos(80,35).size(32,32);
                cap.addlabel("5",null,30).anchor(0,50).pos(100,35).color(100,0,0,100);
                dialog.usedefaultbutton(2,["确定","取消"]);
            }
            else if(mode==2){
                element.addlabel("你的盟友数已达上限",null,24).anchor(0,50).pos(22,100).color(0,0,0,100);
                element.addsprite("adddefence.png").anchor(0,50).pos(245,100).setevent(EVENT_UNTOUCH,addallybound);
                dialog.usedefaultbutton(2,["增加","关闭"]);
            }
            else if(mode==3){
                element.addlabel("增加一个盟友数",null,30).pos(30,46).color(0,0,0,100);
                var au = element.addsprite("addallybound.jpg").anchor(50,50).pos(202,150);
                au.addsprite("caesars_big.png").anchor(50,50).pos(130,35).size(32,32);
                var cl=0;
                var cae=5+5*(global.allymax-global.user.getValue("nobility")/3);
                if(cae>global.user.getValue("caesars")){
                    cl=100;
                }
                au.addlabel("x "+str(cae),null,30).anchor(0,50).pos(180,35).color(cl,0,0,100);
                dialog.usedefaultbutton(2,["确定","取消"]);
            }
        }
        return element;
    }
    
    function paintNode(){
        trace(0);
        if(global.allymax > len(global.context[0].friend.flist2) && mode==0){
            dialog = new Simpledialog(0,self);
        }
        else{
            dialog = new Simpledialog(1,self);
            if(mode == 0){
                mode = 2;
            }
        }
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        trace(10);
    }
    
    function excute(p){
        if(mode==0){
            makeally();
        }
        else if(mode == 1){
            cancelally();
        }
        else if(mode==2){
            addallybound();
        }
        else if(mode==3){
            allybound();
        }
    }
    function allybound(){
        if(lock == 0){
            lock = 1;
            var cost = dict();
            cost.update("caesars",5+5*(global.allymax-global.user.getValue("nobility")/3));
            if(global.user.testCost(cost)==1){
                global.http.addrequest(1,"addallyupbound",["userid"],[global.userid],self,"addallyupbound");
            }
        }
    }
    
    function useaction(p,rc,c){
        if(p=="addallyupbound"){
            addallyupbound(0,rc,c);
        }
        else if(p=="makeallyover"){
            makeallyover(0,rc,c);
        }
        else if(p=="cancelallyover"){
            cancelallyover(0,rc,c);
        }   
        if(global.context[0].friend.flist!=null && global.context[0].friend.friendmode==2){
            global.context[0].friend.refreshflist();
        }
    }
    
    function addallyupbound(r,rc,c){
        lock=0;
        if(rc!=0&&json_loads(c).get("id")!=0){
            global.user.changeValueAnimate2(global.context[0].moneyb,"caesars",-5*(global.allymax-global.user.getValue("nobility")/3)-5,-6);
            global.allymax++;
            global.popContext(null);
            if(flagprev!=0){
                global.pushContext(null,new AllyControl(0),NonAutoPop);
            }
        }
    }
    function addallybound(){
        global.popContext(null);
        var ac = new AllyControl(3);
        ac.flagprev = 1;
        global.pushContext(null,ac,NonAutoPop);
    }

    function makeally(){
        if(lock==0){
            lock=1;
            global.http.addrequest(1,"makeally",["uid","fid"],[global.userid,global.context[0].cuid],self,"makeallyover");
            //http_request(BASE_URL+"makeally?uid="+str(global.userid)+"&fid="+str(global.context[0].cuid),makeallyover);
        }
    }

    function cancelally(){
        if(lock==0){
            lock=1;
            global.http.addrequest(1,"cancelally",["uid","fid"],[global.userid,global.context[0].cuid],self,"cancelallyover");
            //http_request(BASE_URL+"cancelally?uid="+str(global.userid)+"&fid="+str(global.context[0].cuid),cancelallyover);
        }
    }

    function makeallyover(r,rc,c){
        lock=0;
        if(rc!=0&&json_loads(c).get("id")>0){
            global.context[0].allybutton.texture("unbindButton.png",UPDATE_SIZE);
            global.context[0].flagally = 1;
            global.context[0].friend.flist2.append(global.context[0].cpid);
            global.popContext(null);
        }
    }

    function cancelallyover(r,rc,c){
        lock=0;
        trace("cancel",rc,c);
        if(rc!=0&&json_loads(c).get("id",1)>0){
            global.context[0].allybutton.texture("bindButton.png",UPDATE_SIZE);
            global.context[0].flagally = 0;
            global.context[0].friend.flist2.remove(global.context[0].cpid);
            global.user.changeValueAnimate2(global.context[0].moneyb,"caesars",-5,-6);
            global.popContext(null);
        }
    }
    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        contextNode = null;
    }
}