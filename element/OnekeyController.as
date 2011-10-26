class OnekeyController extends ContextObject{
    var tabs;
    var selecttab;
    var element;
    var mode;
    var objid;
    var tabstr;
    var costcae;

    function OnekeyController(m){
        contextname = "dialog-build-onekey";
        contextNode = null;
        element = null;
        mode = m;
        if(m==0){
            tabstr = ["一键播种","一键收获"];
        }
        else if(m==1){
            tabstr = ["一键收税"];
        }
        costcae=1;
    }

    function getelement(){
        if(element==null){
            tabs = new Array(2);
            if(global.card[14+mode]>=5){
                costcae=0;
            }
            else{
                costcae=1;
            }
            element = node();
            element.addsprite("devineback.jpg").anchor(50,0).pos(219,30);
            element.addlabel("一键操作",null,30).anchor(50,50).pos(219,63).color(0,0,0,100);
            selecttab = -1;
            var tabsize = len(tabstr);
            for(var i=0;i<tabsize;i++){
                tabs[i] = element.addsprite("dialogelement_god_normal.png").pos(232-tabsize*70+i*140,110).setevent(EVENT_UNTOUCH,choosetab,i);
                tabs[i].addlabel(tabstr[i],null,20).anchor(50,50).pos(57,60).color(0,0,0,100);
                tabs[i].addsprite("caesars_big.png").anchor(50,50).pos(43,130);
                tabs[i].addlabel("x"+str(costcae),null,20).anchor(0,50).pos(62,130).color(0,0,0,100);
            }
            choosetab(0,0,0);
        }
        return element;
    }

    function paintNode(){
        var dialog = new Simpledialog(0,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.usedefaultbutton(2,["施展","取消"]);
    }

    function choosetab(n,e,p){
        if(selecttab != p){
            if(selecttab>=0)
                tabs[selecttab].texture("dialogelement_god_normal.png");
            tabs[p].texture("dialogelement_god_chosen.png");
            selecttab = p;
        }
    }

    function excute(p){
        var cost = dict();
        cost.update("caesars",costcae);
        if(global.user.testCost(cost)==0){
            return 0;
        }
        if(selecttab==0){
            if(mode==0){
                var length=len(global.context[0].grounds);
                var isok = 0;
                for(var i=0;i<length;i++){
                    var build = global.context[0].grounds[i];
                    if(build.objectid<5&&build.objectid>0){
                        if(build.objnode.state==2){
                            isok=1;
                        }
                    }
                }
                if(isok==1){
                    global.pushContext(self,new PlantControl(),NonAutoPop);
                }
                else{
                    global.pushContext(null,new Warningdialog([global.getStaticString(15),null,5]),NonAutoPop);
                }
            }
            else if(mode==1){
                length=len(global.context[0].grounds);
                isok = 0;
                for(i=0;i<length;i++){
                    build = global.context[0].grounds[i];
                    if(build.objectid<400&&build.objectid>=300){
                        if(build.objnode.state==4){
                            isok=1;
                        }
                    }
                }
                if(isok==1){
                    global.http.addrequest(1,"productall",["user_id","city_id"],[global.userid,global.cityid],self,"productall");
                }
                else{
                    global.pushContext(null,new Warningdialog([global.getStaticString(19),null,5]),NonAutoPop);
                }
            }
        }
        else{
            if(mode==0){
                length=len(global.context[0].grounds);
                isok = 0;
                for(i=0;i<length;i++){
                    build = global.context[0].grounds[i];
                    if(build.objectid<5&&build.objectid>0){
                        if(build.objnode.state==4){
                            isok=1;
                        }
                    }
                }
                if(isok==1){
                    global.http.addrequest(1,"harvestall",["user_id","city_id"],[global.userid,global.cityid],self,"harvestall");
                }
                else{
                    global.pushContext(null,new Warningdialog([global.getStaticString(16),null,5]),NonAutoPop);
                }
            }
        }
    }
    
    function reloadNode(re){
        if(mode==0){
            objid=re;
            if(re%3==2){
                var cost = dict();
                cost.update("caesars",costcae-PLANT_PRICE[re]);
                if(global.user.testCost(cost)==0){
                    return 0;
                }
            }
            global.http.addrequest(1,"plantingall",["user_id","city_id","object_id"],[global.userid,global.cityid,re],self,"plantingall");
        }
    }
    
    function useaction(p,rc,c){
        if(p=="harvestall"){
            var data = json_loads(c);
            if(data.get("id")==1){
                global.popContext(null);
                global.user.changeValueAnimate2(global.context[0].moneyb,"caesars",-costcae,-6);
                var length=len(global.context[0].grounds);
                for(var i=0;i<length;i++){
                    var build = global.context[0].grounds[i];
                    if(build.objectid<5&&build.objectid>0){
                        if(build.objnode.state==4){
                            build.objnode.state4over(0,1,"{'id':1}");
                            var ani=build.contextNode.addsprite().anchor(50,100).pos(build.contextid*34,build.contextid*33);
                            ani.addaction(sequence(animate(2000,"blessing1.png","blessing2.png","blessing3.png","blessing4.png","blessing5.png","blessing6.png","blessing7.png","blessing8.png","blessing9.png"),callfunc(removeself)));
                        }
                    }
                }
            }
        }
        else if(p=="productall"){
            data = json_loads(c);
            if(data.get("id")==1){
                global.popContext(null);
                global.user.changeValueAnimate2(global.context[0].moneyb,"caesars",-costcae,-6);
                length=len(global.context[0].grounds);
                for(i=0;i<length;i++){
                    build = global.context[0].grounds[i];
                    if(build.objectid<400&&build.objectid>=300){
                        if(build.objnode.state==4){
                            build.objnode.state4over(0,1,"{'id':1}");
                            ani=build.contextNode.addsprite().anchor(50,100).pos(build.contextid*34,build.contextid*33);
                            ani.addaction(sequence(animate(2000,"blessing1.png","blessing2.png","blessing3.png","blessing4.png","blessing5.png","blessing6.png","blessing7.png","blessing8.png","blessing9.png"),callfunc(removeself)));
                        }
                    }
                }
            }
        }
        else if(p=="plantingall"){
            data = json_loads(c);
            var overlist = data.get("plant");
            //if(data.get("id")==1){
                global.popContext(null);
                global.user.changeValueAnimate2(global.context[0].moneyb,"caesars",-costcae,-6);
                var istask = 0;
                trace(global.task.tasktype,global.task.taskreq);
                if(global.task.tasktype==0&&global.task.taskreq=="planting"){
                    var pair=["object_id",objid,"type",0];
                    trace(pair,global.task.taskpair);
                    istask=1;
                    for(i=0;i<len(global.task.taskpair);i++){
                        if(pair[i]!=global.task.taskpair[i]){
                            istask=0;
                            break;
                        }
                    }
                }
                length=len(global.context[0].grounds);
                var num=0;
                for(i=0;i<length;i++){
                    build = global.context[0].grounds[i];
                    if(overlist.index(build.posi[0]*RECTMAX+build.posi[1])!=-1){
                        num++;
                        build.objnode.objid=objid;
                        build.objnode.state2over(0,1,"{'id':1}");
                            ani=build.contextNode.addsprite().anchor(50,100).pos(build.contextid*34,build.contextid*33);
                            ani.addaction(sequence(animate(2000,"blessing1.png","blessing2.png","blessing3.png","blessing4.png","blessing5.png","blessing6.png","blessing7.png","blessing8.png","blessing9.png"),callfunc(removeself)));
                    }
                }
                if(istask==1){
                    global.task.inctaskstep(num);
                }
            //}
        }
    }
    
    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}