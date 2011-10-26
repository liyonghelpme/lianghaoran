class Nobilitydialog extends ContextObject{
    var dialog;
    var element;
    function Nobilitydialog(){
        contextNode = null;
        contextname = "dialog-nobility";
        element = null;
    }
    
    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        contextNode = null;
        element.removefromparent();
        element=null;
        if(global.user.getValue("nobility")%3==0&&global.context[0].warpage.contextNode!=null){
            global.context[0].warpage.initialdata();
        }
        if(global.context[0].warpage.rightmenu!=null){
            global.context[0].warpage.refreshnob();
        }
    }
    
    function getelement(){
        if(element == null){
            element = node();
            var nob = global.user.getValue("nobility");
            if(nob%3==2&&global.card[12]<18){
                nob++;
            }
            var nback=element.addsprite("nobilityback.png").anchor(50,50).pos(219,191);
            nback.addsprite("nobi"+str(nob)+".png").anchor(50,50).pos(215,62);
            var upstr = "恭喜！你晋级到了"+NOBNAME[nob];
            if(nob%3==0){
                var db = c_opendb(0,"flag");
                db.put("mapnew",1);
                upstr =upstr+"，你即将进入新地图，在那里你会遇到更强大的对手，努力战胜他们吧！";
                global.user.setValue("nobility",nob);
                var reward=[5000,250,10000,500,30000,1500,50000,2500,70000,3500,100000,5000];
                var index = (nob/3-1)*2;                
                element.addsprite("nobilityreward.jpg").pos(32,229);
                element.addsprite("money_big.png").anchor(50,50).pos(128,270).size(32,32);
                element.addlabel(str(reward[index]),null,30).anchor(0,50).pos(150,270).color(0,0,0,100);
                element.addsprite("food.png").scale(110).anchor(50,50).pos(268,270);
                element.addlabel(str(reward[index+1]),null,30).anchor(0,50).pos(290,270).color(0,0,0,100);
                global.user.changeValueAnimate2(global.context[0].moneyb,"money",reward[index],-6);
                global.user.changeValueAnimate2(global.context[0].ub,"food",reward[index+1],-6);
                global.allymax++;
                global.http.addrequest(1,"upgrademap",["userid"],[global.userid],global.context[0].warpage,"refresh");
                for(var i=0;i<len(global.battlelist);i++){
                    if(global.battlelist[i][2]==1){
                        global.soldiers[0] = global.soldiers[0]+global.battlelist[i][4];
                        global.soldiers[1] = global.soldiers[1]+global.battlelist[i][5];
                    }
                }
                global.battlelist.clear();
                element.addlabel(upstr,null,20,FONT_NORMAL,360,0,ALIGN_LEFT).anchor(50,0).pos(219,155).color(0,0,0,100);
                return element;
            }
            if(nob%3==2){
                upstr = upstr+"，你的领地也升级啦！";
                if(global.context[0].warpage.inite==1){
                    global.context[0].warpage.userdict.get(global.context[0].warpage.selfgid)[6]=2;
                    if(global.context[1].contextname=="page-war"){
                        global.context[1].refreshmap(1);
                    }
                }
            }
            else{
                upstr = upstr +"，再升一级你领地就可以升级罗！";
            }
            element.addlabel(upstr,null,24,FONT_NORMAL,360,0,ALIGN_LEFT).anchor(50,0).pos(219,172).color(0,0,0,100);
        }
        return element;
    }
    
    function paintNode(){
        dialog = new Simpledialog(0,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.usedefaultbutton(2,["分享","确定"]);
    }
        
    function excute(p){
        global.popContext(null);
        if(p==1){
            global.http.addrequest(0,"share",["uid"],[global.userid],global.context[0],"share");
            ppy_postnewsfeed(global.getFormatString(7+global.user.getValue("nobility")%3,["[USERNAME]",ppy_username(),"[NOBNAME]",NOBNAME[global.user.getValue("nobility")]]),"http://getmugua.com");
        }
    }
}
