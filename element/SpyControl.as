class SpyControl extends ContextObject{
    var tabs;
    var selecttab;
    var gid;
    var euid;
    var element;

    function SpyControl(g){
        contextname = "dialog-battle-spy-detect";
        contextNode = null;
        gid =g;
        element = null;
        tabs = new Array(4);
    }

    function getelement(){
        if(element ==null){
            element = node();
            element.addsprite("spyback.jpg").anchor(50,0).pos(279,12);
            element.addlabel("注：侦察级别越高，获得的信息越多哦！",null,20).anchor(0,50).pos(46,370).color(0,0,0,100);
            euid = global.context[1].userdict.get(gid)[5];
            selecttab = -1;
            var snum = [6,6,6,2*(global.user.getValue("nobility")/3+1)];
            for(var i=0;i<4;i++){
                tabs[i] = element.addsprite("spytab0.png").pos(35+i%2*247,130+i/2*117).setevent(EVENT_UNTOUCH,choosetab,i);
                tabs[i].addsprite("spyelement"+str(i)+".png").anchor(50,50).pos(120,55);
                tabs[i].addlabel(str(snum[i]),null,20).anchor(0,50).pos(152,89).color(0,0,0,100);
            }
            choosetab(0,0,0);
        }
        return element;
    }

    function paintNode(){
        var dialog = new Simpledialog(3,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.usedefaultbutton(2,["确定","取消"]);
    }

    function choosetab(n,e,p){
        if(selecttab != p){
            if(selecttab>=0)
                tabs[selecttab].texture("spytab0.png");
            tabs[p].texture("spytab1.png");
            selecttab = p;
        }
    }

    function excute(p){
        if(selecttab==3){
            var cost = dict();
            cost.update("caesars",2*(global.user.getValue("nobility")/3+1));
            if(global.user.testCost(cost)==0){
                return 0;
            }
        }
        else{
            if(global.soldiers[2+selecttab]<6){
                var buildable = dict([["ok",0]]);
                buildable.update(global.getname("soldier",6+selecttab),6-global.soldiers[2+selecttab]);
                global.pushContext(null,new Warningdialog(buildable),NonAutoPop);
                return 0;
            }
        }
        global.popContext(null);
        global.http.addrequest(1,"detect",["uid","enemy_id","type"],[global.userid,euid,selecttab],self,"detectover");
        //http_request(BASE_URL+"detect?uid="+str(global.userid)+"&enemy_id="+str(euid)+"&type="+str(selecttab),detectover);
    }
    
    function useaction(p,rc,c){
        if(p=="detectover"){
            detectover(0,rc,c);
        }
    }
    
    function detectover(r,rc,c){
        if(rc!=0){
            var re=json_loads(c);
            if(re.get("id",1)==0){
                return 0;
            }
            if(selecttab==3){
                global.user.changeValueAnimate2(global.context[0].moneyb,"caesars",-2*(global.user.getValue("nobility")/3+1),-6);
            }
            global.pushContext(null,new Spyresult(re,gid,selecttab),NonAutoPop);
        }
    }
    
    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}