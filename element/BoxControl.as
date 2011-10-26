class BoxControl extends ContextObject{
    var mode;
    var list;
    var lock;
    var evnodes;
    var boxbutton;
    var flaghelp;
    var maxperson;
    var helpperson;
    var boxfriends;
    function BoxControl(){
        contextname = "dialog-box";
        contextNode = null;
        lock=0;
        maxperson = 0;
        helpperson= 0;
        boxfriends = [];
        
        boxbutton = sprite("button2.png").pos(20,210);
        boxbutton.setevent(EVENT_TOUCH,enterbox);
        boxbutton.setevent(EVENT_UNTOUCH,enterbox);
        boxbutton.add(label("",null,20).anchor(50,100).pos(30,63).color(0,0,0,100),0,0);
        boxbutton.add(label("",null,20).anchor(50,100).pos(33,62).color(0,0,0,100),0,1);
        boxbutton.add(label("",null,20).anchor(50,100).pos(33,64).color(0,0,0,100),0,2);
        boxbutton.add(label("",null,20).anchor(50,100).pos(32,63).color(100,100,100,100),0,3);
    }
    
    function setbox(r,rc,c){
        if((rc!=0&&json_loads(c).get("id")==1) || r==-1){
            boxbutton.pos(20,140);
            if(global.context[0].flagfriend==1){
                boxbutton.pos(20,210);
            }
            if(maxperson == 0||global.context[0].cpid==0){
                boxbutton.visible(0);
                return 0;
            }
            else{
                boxbutton.visible(1);
                boxbutton.get(0).text(str(helpperson)+"/"+str(maxperson));
                boxbutton.get(1).text(str(helpperson)+"/"+str(maxperson));
                boxbutton.get(2).text(str(helpperson)+"/"+str(maxperson));
                boxbutton.get(3).text(str(helpperson)+"/"+str(maxperson));
            }
        }
    }
    
    function enterbox(n,e){
        if(0 == global.currentLevel){
            if(e == EVENT_TOUCH){
                n.scale(120);
                return 0;
            }
            else if(e == EVENT_UNTOUCH){
                n.scale(100);
                mode = global.context[0].flagfriend;
                list = new Array(0);
                for(var i=0;i<len(boxfriends);i++)
                    list.append(int(boxfriends[i]));
                global.pushContext(null,self,NonAutoPop);
                return 0;
            }
        }
    }

    function paintNode(){
        contextNode = sprite("dialogback_a.png").anchor(50,50).pos(400,240);
        if(mode == 1){
            var head = sprite("boxelement1.jpg").pos(17,11);
            head.addsprite(avatar_url(global.context[0].cpid)).pos(8,10).size(50,50);
            var name = global.getfriend(global.context[0].cpid).get("name");
            if(len(name)>9){
                name = name[0]+name[1]+name[2]+name[3]+name[4]+name[5]+"..";
            }
            head.addlabel(name,null,16).anchor(50,50).pos(33,72).color(0,0,0,100);
            head.addlabel("快帮我打开这个宝箱，",null,20).pos(103,19).color(0,0,0,100);
            head.addlabel("大家一起分享宝藏吧！",null,20).anchor(100,100).pos(308,69).color(0,0,0,100);
        }
        else{
            head = sprite("boxelement0.png").pos(17,11);
            global.addtext(head,93,3,"城堡里突然飘来一只<g>神秘宝箱<g>！！+快邀请好友一起开启吧！！+有神秘礼物等着你哦！",20);
        }
        contextNode.add(head,0,0);
        contextNode.add(sprite("dialogback_white.png").pos(21,92),0,3);
        contextNode.add(sprite("boxbutton1.png").pos(50,330),0,1);
        if(mode == 1){
            contextNode.get(1).addlabel("帮忙",null,BUTTONFONTSIZE).anchor(50,50).pos(62,19);
            if(list.index(ppy_userid())==-1 && helpperson<maxperson){
                flaghelp = 1;
                contextNode.get(1).setevent(EVENT_UNTOUCH,helpopenbox);
            }
            else{
                flaghelp = 0;
                contextNode.get(1).texture("boxbutton2.png");
            }
        }
        else{
            contextNode.get(1).add(label("打开宝箱",null,BUTTONFONTSIZE).anchor(50,50).pos(62,19),0,1);
            if(helpperson == maxperson){
                contextNode.get(1).setevent(EVENT_UNTOUCH,completeopen);
            }
            else{
                contextNode.get(1).get(1).text("求助好友");
                contextNode.get(1).setevent(EVENT_UNTOUCH,askforhelp);
            }
        }
        contextNode.add(sprite("boxbutton2.png").pos(270,330).setevent(EVENT_UNTOUCH,closedialog),0,2);
        contextNode.get(2).addlabel("关闭",null,BUTTONFONTSIZE).anchor(50,50).pos(62,19);
        var l = contextNode.addlabel("",null,30).pos(133,37).color(0,0,0,100);
        evnodes = new Array(0);
        var xx;
        for(var i=0;i<maxperson;i++){
            if(i<helpperson){
                if(list[i]!=ppy_userid() && mode==1)
                    xx =contextNode.addsprite("boxunknownperson.png").pos(32+78*(i%5),103+107*(i/5));
                else{
                    xx=contextNode.addsprite("boxperson.png").pos(32+78*(i%5),103+107*(i/5));
                    if(list[i]<0 || list[i]==ppy_userid()){
                        xx.addsprite(avatar_url(ppy_userid())).pos(6,7).size(50,50);
                        xx.addlabel("我",null,16).anchor(50,50).pos(31,69).color(0,0,0,100);
                    }
                    else{
                        var fid = list[i];
                        var fn = global.getfriend(fid);
                        name = fn.get("name");
                        if(name == null) name = "未知";
                        if(len(name)>9)
                            name = name[0]+name[1]+name[2]+name[3]+name[4]+name[5]+"..";
                        xx.addlabel(name,null,16).anchor(50,50).pos(31,69).color(0,0,0,100);
                        xx.addsprite(avatar_url(fn.get("id"))).pos(6,7).size(50,50);
                    }
                }
            }
            else{
                xx = contextNode.addsprite("boxmoreperson.png").pos(32+78*(i%5),103+107*(i/5));
                if(mode==0 && i==helpperson){
                    xx.add(sprite("boxcaesars.png").pos(0,82),0,0);
                    xx.add(label("x 1",null,16).pos(30,83),0,1);
                    xx.setevent(EVENT_UNTOUCH,openboxwithcaesars);
                }
                else if(mode == 1){
                    xx.setevent(EVENT_UNTOUCH,helpopenbox);
                }                
            }
            evnodes.append(xx);
        }
        if(maxperson==0){
            quitgame();
        }
    }
    
    function askforhelp(){
        global.popContext(null);
        ppy_postnewsfeed(ppy_username()+"获得了一只神秘的宝箱，但是需要你们的帮助才能打开，快去帮助它吧！","http://getmugua.com");
    }

    function completeopen(n,e){
        if(lock==0){
            lock=1;
            global.http.addrequest(1,"completeopen",["user_id"],[global.userid],self,"completeopenover");
        }
    }

    function getelement(){
        var element = node();
        element.addsprite("boxelement2.jpg").pos(106,19);
        var w=element.addsprite("boxreward.png").anchor(50,0).pos(220,144);
        element.addsprite("girl1.png").anchor(50,100).pos(0,375).size(191,409);
        return element;
    }
    
    function excute(p){
        global.popContext(null);
        if(p==1){
            global.http.addrequest(0,"share",["uid"],[global.userid],global.context[0],"share");
            ppy_postnewsfeed(ppy_username()+"打开了一只神秘宝箱，赶快加入与"+ppy_username()+"一起打造属于自己的奇迹帝国吧！","http://getmugua.com");
        }
    }

    function completeopenover(r,rc,c){
        trace("complete",rc,c);
        if(rc!=0 && json_loads(c).get("id",1)!=0){
            var pn = contextNode.parent();
            contextNode.removefromparent();
            var dialog = new Simpledialog(0,self);
            dialog.init(dialog,global);
            contextNode = dialog.getNode();
            contextNode.focus(1);
            pn.add(contextNode.pos(400,270));
            dialog.setbutton(1,183,339,"分享",1);
            dialog.setbutton(2,355,339,"返回",null);
            
            contextNode.addsprite("money_big.png").size(32,32).pos(110,191);
            var v=2000+50*global.user.getValue("level");
            global.user.changeValueAnimate2(global.context[0].moneyb,"money",v,-6);
            contextNode.addlabel(str(v),null,30).pos(145,191).color(0,0,0,100);
            v = global.user.getValue("level")+5;
            global.user.changeValueAnimate2(global.context[0].ub,"exp",v,-6);
            contextNode.addsprite("exp.png").pos(104,242);
            contextNode.addlabel(str(v),null,30).pos(170,242).color(0,0,0,100);
            var goods = json_loads(c).get("specialgoods");
            for(var i=0;i<2;i++){
                var gi = goods[i];
                global.special[gi]++;
                var block=contextNode.addsprite("specialblock.png").pos(255+78*i,196);
                block.addsprite("gift"+str(gi+1)+".png").anchor(50,50).pos(32,32).scale(60);
            }
            maxperson = 0;
            helpperson = 0;
            setbox(-1,0,0);
        }
        lock = 0;
    }

    function openboxwithcaesars(n,e){
        if(lock==0){
            if(global.user.getValue("caesars")<1){
                global.pushContext(self,new Warningdialog(dict([["ok",0],["凯撒币",1]])),NonAutoPop);
                return 0;
            }
            lock=1;
            global.http.addrequest(1,"selfopen",["user_id"],[global.userid],self,"selfopenover");
        }
    }

    function selfopenover(r,rc,c){
trace("selfopen",rc,c);
        if(rc!=0){
            if(json_loads(c).get("id")>0){
                evnodes[helpperson].remove(1);
                evnodes[helpperson].remove(0);
                evnodes[helpperson].texture("boxperson.png");
                evnodes[helpperson].addsprite(avatar_url(ppy_userid())).pos(6,7).size(50,50);
                evnodes[helpperson].addlabel("我",null,16).anchor(50,50).pos(31,69).color(0,0,0,100);
                evnodes[helpperson].setevent(EVENT_UNTOUCH,null);
                helpperson++;
                global.user.changeValueAnimate2(global.context[0].moneyb,"caesars",-1,-6);
                boxfriends.append(str(-1));
                if(helpperson<maxperson){
                    evnodes[helpperson].add(sprite("boxcaesars.png").pos(0,82),0,0);
                    evnodes[helpperson].add(label("x 1",null,16).pos(30,83),0,1);
                    evnodes[helpperson].setevent(EVENT_UNTOUCH,openboxwithcaesars);
                }
                else{
                    contextNode.get(1).texture("boxbutton1.png");
                    contextNode.get(1).get(1).text("打开宝箱");
                    contextNode.get(1).setevent(EVENT_UNTOUCH,completeopen);
                }
                setbox(-1,0,0);
            }
        }
        lock=0;
    }

    function reloadNode(re){
    }

    function helpopenover(r,rc,c){
trace("helpopen",rc,c);
        if(rc!=0 && json_loads(c).get("id")>0){
            evnodes[helpperson].texture("boxperson.png");
            evnodes[helpperson].addsprite(avatar_url(ppy_userid())).pos(6,7).size(50,50);
            evnodes[helpperson].addlabel("我",null,16).anchor(50,50).pos(31,69).color(0,0,0,100);
            helpperson++;
            boxfriends.append(str(ppy_userid()));
            setbox(-1,0,0);
            contextNode.get(1).texture("boxbutton2.png");
            flaghelp = 0;
            global.user.changeValueAnimate2(global.context[0].moneyb,"money",1000,-6);
        }
        lock=0;
    }

    function helpopenbox(n,e){
        if(lock==0 && flaghelp == 1){
            lock=1;
            global.http.addrequest(1,"helpopen",["user_id","fuser_id"],[global.userid,global.context[0].cuid],self,"helpopenover");
        }
    }
    
    function useaction(p,rc,c){
        if(p=="helpopenover"){
            helpopenover(0,rc,c);
        }
        else if(p=="selfopenover"){
            selfopenover(0,rc,c);
        }
        else if(p=="completeopenover"){
            completeopenover(0,rc,c);
        }
        else if(p=="setbox"){
            setbox(0,rc,c);
        }
    }

    function closedialog(node,event){
        global.popContext(null);
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        contextNode=null;
    }
}