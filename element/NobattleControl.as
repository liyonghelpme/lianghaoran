class NobattleControl extends ContextObject{
    var element;
    const timestr = ["2小时","8小时","24小时"];
    const caesars = [4999,14999,-2];
    var endtime;
    var timeisend;
    var timelabel;
    var selecttab;

    function NobattleControl(){
        contextname = "dialog-nobattle";
        contextNode = null;
        element = null;
        timeisend = 0;
    }

    function gotohelp(n,e,p,x,y){
        if(x>0&&y>0&&x<n.size()[0]&&y<n.size()[1]){
            global.pushContext(null,new TestWebControl(p),NonAutoPop);
        }
    }
    
    function getelement(){
        if(element==null){
            element = node();
            endtime = global.timer.times2c(global.user.getValue("nobattletime"));
            var filter = NORMAL;
            timelabel=null;
            element.addsprite("selfandroid.jpg").pos(38,92);
            if(endtime>global.timer.currenttime){
                filter = GRAY;
                element.addlabel("保护中",null,20,FONT_BOLD).pos(139,105).color(0,0,0,100);
                timelabel = element.addlabel("",null,20).pos(199,105).color(0,0,0,100);
                global.timer.addlistener(endtime,self);
                timerefresh();
            }
            else{
                element.addlabel("开启保护模式",null,20,FONT_BOLD).pos(139,105).color(0,0,0,100);
                element.addsprite("help2.png").pos(319,101).setevent(EVENT_UNTOUCH,gotohelp,"nobattle");
            }
            element.addsprite("power.png").pos(28,22);
            element.addlabel(str(global.soldiers[0]+global.soldiers[1]),null,16).color(0,0,0,100).pos(58,26);
            element.addsprite("defence.png").pos(148,22).size(28,29);
            element.addlabel(str(global.user.getValue("citydefence")),null,16).color(0,0,0,100).pos(178,26);
            element.addsprite("friendbutton2.png").pos(260,22).size(28,29);
            element.addlabel(str(len(global.context[0].friend.flist2)),null,16).color(0,0,0,100).pos(290,26);
            element.addsprite("selfwon.png").pos(28,55);
            element.addlabel("殖民地："+str(global.user.getValue("wonnum")),null,16).color(0,0,0,100).pos(58,59);
            for(var i=0;i<3;i++){
                var tab=element.addsprite("nobattletab0.png",filter).pos(14+i*126,135);
                tab.setevent(EVENT_UNTOUCH,choosetab,i);
                tab.setevent(EVENT_TOUCH,choosetab,i);
                tab.addlabel(timestr[i],null,20).anchor(50,50).pos(63,30).color(0,0,0,100);
                if(caesars[i]<0){
                    tab.addsprite("caesars_big.png",filter).anchor(50,50).pos(43,90);
                    tab.addlabel(str(-caesars[i]),null,20).anchor(0,50).pos(71,90).color(0,0,0,100);
                }
                else{
                    tab.addsprite("money_big.png",filter).anchor(50,50).pos(28,90);
                    tab.addlabel(str(caesars[i]),null,20).anchor(0,50).pos(56,90).color(0,0,0,100);
                }
            }
        }
        return element;
    }
    
    function timerefresh(){
        var lefttime =endtime-global.timer.currenttime;
        timelabel.text(global.gettimestr(lefttime));
    }
    function timeend(){
        if(contextNode!=null){
            element.removefromparent();
            element=null;
            contextNode.add(getelement());
        }
    }
    function paintNode(){
        var dialog = new Simpledialog(1,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.setclosebutton();
    }

    function choosetab(n,e,p,x,y){
        if(timelabel!=null){
            return 0;
        }
        if(e==EVENT_TOUCH){
            n.texture("nobattletab1.png");
        }
        else{
            n.texture("nobattletab0.png");
            if(x>0&&y>0&&x<n.size()[0]&&y<n.size()[1]){
                var cost = dict();
                if(caesars[p]<0){
                    cost.update("caesars",-caesars[p]);
                }
                else{
                    cost.update("money",caesars[p]);
                }
                if(global.user.testCost(cost)!=0){
                    selecttab = p;
                    global.http.addrequest(1,"addprotect",["uid","type"],[global.userid,p],self,"addprotect");
                }
            }
        }
    }
    
    function useaction(p,rc,c){
        if(p=="addprotect"){
            addprotect(0,rc,c);
        }
    }
    
    function addprotect(r,rc,c){
        if(rc!=0&&json_loads(c).get("id",1)!=0){
            var times=[7200,43200,86400];
            global.user.setValue("nobattletime",global.timer.timec2s(global.timer.currenttime+times[selecttab]));
            if(caesars[selecttab]<0){
                global.user.changeValue("caesars",caesars[selecttab]);
            }
            else{
                global.user.changeValue("money",-caesars[selecttab]);
            }
            timeend();
        }
    }
    
    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        contextNode = null;
        timeisend = 1;
    }
}