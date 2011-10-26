class Nestbuilddialog extends ContextObject{
    var mode;
    var list;
    var lock;
    var evnodes;
    var flaghelp;
    var maxperson=10;
    var helpperson;
    var boxfriends;
    function Nestbuilddialog(h){
        contextname = "dialog-nest-build";
        contextNode = null;
        lock=0;
        maxperson = 10;
        boxfriends = h;
        list = boxfriends;
        helpperson= len(h);
        contextLevel=1;
    }
    
    function paintNode(){
        contextNode = sprite("dialogback_a.png").anchor(50,50).pos(400,240);
        mode = global.context[0].flagfriend;
        var head = sprite("nestdialogelement.jpg").pos(17,11);
        head.addsprite(avatar_url(global.context[0].cpid)).pos(8,10).size(50,50);
        var name = global.getfriend(global.context[0].cpid).get("name");
        if(len(name)>9){
            name = name[0]+name[1]+name[2]+name[3]+name[4]+name[5]+"..";
        }
        head.addlabel(name,null,16).anchor(50,50).pos(33,69).color(0,0,0,100);
        if(mode == 1){
            head.addlabel("快帮我激活这个建筑，",null,20).pos(103,19).color(0,0,0,100);
            head.addlabel("大家一起分享吧！",null,20).anchor(100,100).pos(308,69).color(0,0,0,100);
        }
        else{
            global.addtext(head,103,19,"快去求助好友激活龙巢吧！",18);
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
            contextNode.get(1).add(label("求助好友",null,BUTTONFONTSIZE).anchor(50,50).pos(62,19),0,1);
            if(helpperson != maxperson){
                contextNode.get(1).setevent(EVENT_UNTOUCH,askforhelp);
            }
            else{
                contextNode.get(1).get(1).text("激活");
                contextNode.get(1).setevent(EVENT_UNTOUCH,completeopen);
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
        ppy_postnewsfeed(ppy_username()+"获得了能召唤宠物的龙巢，但是需要你们的帮助才能打开，快去帮助它吧！","http://getmugua.com");
    }
    
    function completeopen(n,e){
        if(lock==0){
            lock=1;
            var bd = global.request[contextLevel].baseobj;
            global.http.addrequest(1,"activateComplete",["uid","gid","cid"],[global.userid,bd.posi[0]*RECTMAX+bd.posi[1],global.cityid],self,"completeopenover");
        }
    }

    function openboxwithcaesars(n,e){
        if(lock==0){
            if(global.user.testCost(dict([["caesars",1]]))==0){
                return 0;
            }
            lock=1; 
            var bd = global.request[contextLevel].baseobj;
            global.http.addrequest(1,"activeDragon",["uid", "fid", "gid", "cid"],[global.userid,-1, bd.posi[0]*RECTMAX+bd.posi[1],global.cityid],self,"selfopenover");
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
                boxfriends.append(-1);
                global.request[contextLevel].sreload();
                if(helpperson<maxperson){
                    evnodes[helpperson].add(sprite("boxcaesars.png").pos(0,82),0,0);
                    evnodes[helpperson].add(label("x 1",null,16).pos(30,83),0,1);
                    evnodes[helpperson].setevent(EVENT_UNTOUCH,openboxwithcaesars);
                }
                else{
                    //global.popContext(null);
                    contextNode.get(1).texture("boxbutton1.png");
                    contextNode.get(1).get(1).text("激活");
                    contextNode.get(1).setevent(EVENT_UNTOUCH,completeopen);
                }
            }
        }
        lock=0;
    }

    function reloadNode(re){
    }

    function completeopenover(r,rc,c){
        trace("complete",rc,c);
        if(rc!=0 && json_loads(c).get("id",1)!=0){
            var pn = contextNode.parent();
            contextNode.removefromparent();
            contextNode = sprite("dialogback_expand.png",ARGB_8888).anchor(50,50).pos(400,300);
            contextNode.addsprite("girl1.png").anchor(50,100).pos(0,310).size(191,409);
            //contextNode.addsprite("expandfont.jpg").anchor(0,50).pos(100,100);
            contextNode.addlabel("恭喜你激活了你的龙巢，你可以召唤宠物啦！",null,28,FONT_BOLD,308,0,ALIGN_LEFT).anchor(0,50).pos(100,115).color(0,0,0,100);
            contextNode.addsprite("boxbutton1.png").anchor(50,50).pos(150,234).setevent(EVENT_UNTOUCH,closedialog,1);
            contextNode.addlabel("分享",null,BUTTONFONTSIZE).anchor(50,50).pos(150,234);
            contextNode.addsprite("boxbutton2.png").anchor(50,50).pos(300,234).setevent(EVENT_UNTOUCH,closedialog,null);
            contextNode.addlabel("返回",null,BUTTONFONTSIZE).anchor(50,50).pos(300,234);
            pn.add(contextNode);
            global.request[contextLevel].state=2;
            global.request[contextLevel].petname = "我的宠物";
            global.request[contextLevel].setstate();
           /* contextNode.addsprite("money_big.png").size(32,32).pos(110,191);
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
            setbox(-1,0,0);*/
        }
        lock = 0;
    }

    function helpopenover(r,rc,c){
trace("helpopen",rc,c);
        if(rc!=0 && json_loads(c).get("id")>0){
            evnodes[helpperson].texture("boxperson.png");
            evnodes[helpperson].addsprite(avatar_url(ppy_userid())).pos(6,7).size(50,50);
            evnodes[helpperson].addlabel("我",null,16).anchor(50,50).pos(31,69).color(0,0,0,100);
            helpperson++;
            boxfriends.append(ppy_userid());
            global.request[contextLevel].sreload();
            contextNode.get(1).texture("boxbutton2.png");
            flaghelp = 0;
            if(helpperson>=maxperson){
                //global.popContext(null);
            }
            global.user.changeValueAnimate2(global.context[0].moneyb,"money",1000,-6);
        }
        lock=0;
    }

    function helpopenbox(n,e){
        if(lock==0 && flaghelp == 1){
            lock=1;
            var bd = global.request[contextLevel].baseobj;
            global.http.addrequest(1,"activeDragon",["uid", "fid", "gid", "cid"],[global.userid,global.context[0].cpid,bd.posi[0]*RECTMAX+bd.posi[1],global.context[0].ccid],self,"helpopenover");
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
    }

    function closedialog(node,event,p){
        global.popContext(null);
        if(p==1){
            global.http.addrequest(0,"share",["uid"],[global.userid],global.context[0],"share");
            ppy_postnewsfeed(ppy_username()+"成功地激活了他的龙巢，赶快加入与"+ppy_username()+"一起打造属于自己的奇迹帝国吧！","http://getmugua.com");
        }
    }
    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        contextNode=null;
    }
}