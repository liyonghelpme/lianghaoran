import element.Rankingdialog;
class FriendControl{
    var friendmode;
    var friendback;
    var flistback;
    var flist;
    var flist1;
    var flist2;
    var fnob;
    var flagfriendover;
    var fpos;
    var flength;
    var selectf;
    var selectp;
    var global;
    var self;
    var visited;
    var friendimage;
    var flagbuffer;
    var bufferflist3;
    var left;
    var right;
    function FriendControl(){
        flagbuffer = 0;
        flist1 = new Array(0);
        flist2 = new Array(0);
        friendimage = new Array(5);
        visited = dict();
        friendimage[0] = fetch("friend_objback1.png");
        friendimage[1] = fetch("friend_objback1s.png");
        friendimage[2] = fetch("friend_visited.png");
        friendimage[3] = fetch("friendinvite.png");
        friendimage[4] = fetch("friend_objlevel.png");
        fpos=[0,0];
        flagfriendover = 0;
        selectf = 0;
        selectp = ppy_userid();
        friendback = sprite("friendback.png").pos(900,375).size(800,105);
        friendback.add(sprite("friendclose.png",ARGB_8888).setevent(EVENT_TOUCH,closefriendmenu),1);
        flistback = null;
        flist = null;
        flength = 0;
        bufferflist1 = null;
        bufferflist2 = null;
        bufferflist3 = null;
        friendback.setevent(EVENT_TOUCH,friendchoose);
        friendback.setevent(EVENT_MOVE,friendchoose);
        friendback.setevent(EVENT_UNTOUCH,friendchoose);
        left = sprite("friendchangepage0.png").anchor(100,50).pos(172,-11);
        left.setevent(EVENT_TOUCH,friendpagechange,-1);
        left.setevent(EVENT_UNTOUCH,friendpagechange,-1);
        right = sprite("friendchangepage0.png").scale(-100,100).anchor(100,50).pos(700,-11);
        right.setevent(EVENT_TOUCH,friendpagechange,1);
        right.setevent(EVENT_UNTOUCH,friendpagechange,1);
        friendback.add(left,20);
        friendback.add(right,20);
    }
    
    function friendpagechange(n,e,p){
        global.context[0].hiddentime = 10;
        if(e==EVENT_TOUCH){
            if(p==-1){
                left.scale(120,120);
            }
            else{
                right.scale(-120,120);
            }
        }
        else{
            if(p==-1){
                left.scale(100,100);
                
            }
            else{
                right.scale(-100,100);
            }
            var pe = (flistback.pos()[0]-45-720*p)/90;
            if(pe <= 8-flength)
                pe = 8-flength;
            if(pe >= 0) 
                pe = 0;
            flistback.addaction(moveto(300,pe*90,0));
            for(var i=0;i<flength;i++){
                if(i<-pe || i>8-pe){
                    if(flist[i]!=null){
                        if(i>=-pe-(p+1)*4&&i<=8-pe-(p-1)*4){
                            flist[i].addaction(sequence(delaytime(300),callfunc(removeself)));
                        }
                        else{
                            flist[i].removefromparent();
                        }
                        flist[i] = null;
                    }
                }
                else if(flist[i] == null){
                    flistback.add(getfnode(i));
                }
            }
            fpos[friendmode-1] = pe*90;
            
            check(pe);
        }
    }
    
    function check(pe){
        if(pe==0){
            left.texture("friendchangepage1.png");
        }
        else{
            left.texture("friendchangepage0.png");
        }
        if(pe<=8-flength){
            right.texture("friendchangepage1.png");
        }
        else{
            right.texture("friendchangepage0.png");
        }
    }
    
    function loadourdata(){
        http_request(BASE_URL+"retlev?uid="+str(global.userid),loadover);
    }
    
    function loaddata(g,s){
        global = g;
        self =s;
        loadfromdb();
        ppy_query("list_friends", null, hfriend);
    }
    var ltime;
    var flaglock;
    function loadfromdb(){
        flaglock=0;
        var db=c_opendb(0,"friends");
        flist1 =null;
        var currenttime = time()/1000-global.timer.base_localtime+global.timer.base_systime;
        ltime = db.get("updatetime");
        
        if(ltime==null){
            ltime=currenttime-86400;
        }
        if(db.get("isbufnew")!=1){
            flist1 = null;
        }
        if(flist1==null){
            flaglock=1;
            flist1 = [dict([["id",0],["name","凯撒"],["level",30],["visited",1]]),dict([["id",ppy_userid()],["name",ppy_username()],["level",0],["visited",1]])];
        }
        var le = len(flist1);
        for(var i=0;i<le;i++){
            if(flist1[i].get("level")!=-1){
                flist1[i].update("visited",1);
                global.ppyuserdict.update(str(flist1[i].get("id")),flist1[i]);
            }
            else if(flist1[i].get("level")==null){
                flaglock=1;
            }
        }
        global.ppyuserdict.get(str(ppy_userid())).update("visited",1);
    }
    
    function updateflist1(){
        var db=c_opendb(0,"friends");
        db.put("friends",flist1);
        ltime = global.timer.base_systime+time()/1000-global.timer.base_localtime;
        db.put("updatetime",ltime);
        if(flaglock==0&&flagfriendover==1){
            db.put("isbufnew",1);
        }
    }

    function closefriendmenu(n,e){
        friendback.addaction(sequence(sineio(moveto(1000,900,375)),callfunc(deleteflist)));
    }

    function deleteflist(){
        for(var i=0;i<flength;i++){
            if(flist[i]!=null){
                flist[i].removefromparent();
                flist[i] = null;
            }
        }
        flist = null;
        flength = 0;
    }
    function openfriendmenu(p){
        if(p!=0){
            friendmode = p;
        }
        if(friendback.pos()[0]!=900){
            return 0;
        }
        friendback.addaction(sineio(moveto(1200,0,375)));
        refreshflist();
    }
    function refreshflist(){
        if(flistback != null){
            flistback.removefromparent();
            deleteflist();
        }
        flistback = friendback.addnode();
        flist = new Array(0);
        if(flaglock==1&&flagfriendover==0){
            flistback.addlabel("正在载入，请稍候……",null,40).anchor(50,50).pos(400,52).color(0,0,0,100);
        }
        else if(flaglock==1&&flagfriendover>1){
            flistback.addlabel("抱歉，现在无法获得您的好友信息",null,20).anchor(50,50).pos(400,52).color(0,0,0,100);
        }
        else{
            var i;
            var j;
            if(friendmode==1){
                if(global.ppyuserdict.get(str(ppy_userid())).get("level",0)<global.user.getValue("level")){
                    global.ppyuserdict.get(str(ppy_userid())).update("level",global.user.getValue("level"));
                }
                var flagloop = 1;
                var tmp;
                var leveldict = dict();
                for(i=-1;i<100;i++){
                    leveldict.update(i,[]);
                }
                var length = len(flist1);
                for(i=1;i<length;i++){
                    leveldict.get(flist1[i].get("level",-1)).append(flist1[i]);
                }
                j=1;
                for(i=99;i>=-1;i--){
                    var ld = leveldict.get(i);
                    for(var k=0;k<len(ld);k++){
                        flist1[j] = ld[k];
                        j++;
                    }
                }
                //updateflist1();
                trace("initing");
                for(i=1;i<length;i++){
                    if(flist1[i].get("id") == selectp){
                        selectf = i+2;
                        break;
                    }
                }
                
                flength = len(flist1)+3;
                for(i=0;i<flength;i++){
                    flist.append(null);
                }
            }
            else if(friendmode==2){
                selectf = flist2.index(selectp)+1;
                flength = global.allymax+1;
                for(i=0;i<flength;i++){
                    flist.append(null);
                }
            }
            flistback.pos(fpos[friendmode-1],0);
            friendchoose(friendback,EVENT_UNTOUCH,0,0);
            check((fpos[friendmode-1]-45)/90);
        }
    }
    var bufferflist1;
    function hfriend(requestId, ret_code, response){
        if(ret_code ==0){
            trace("fail to get friend from us!");
            flagfriendover = 3;
            ppy_query("list_friends", null, hfriend);
            return 0;
        }
        else{
            trace("sucload1!");
            bufferflist1 = response.get("data");
            bufferflist1.append(dict([["name","凯撒"],["id",0],["avatar_version",0],["isplayer",1]]));
            flagbuffer++;
            beginaddlist();
            //global.http.addrequest(0,"retlev",["uid","rrstring"],[global.userid,string1],self,"retlevback");
        }
    }
    
    function loadover(r,rc,c){
        if(rc!=0){
            var data=json_loads(c);
            if(data.get("id")!=0){
                bufferflist3 = data.get("friendlist",[]);
                flagbuffer++;
                beginaddlist();
                return 0;
            }
        }
        loadourdata();
    }
    
    function beginaddlist(){
        if(flagbuffer==2){
            flagbuffer=0;
            flagfriendover=1;
            var cfdict = dict();
            for(var i=0;i<len(flist1);i++){
                cfdict.update(flist1[i].get("id"),flist1[i]);
            }
            for(i=0;i<len(bufferflist1);i++){
                    var fn = bufferflist1[i];
                    var id = fn.get("id");
                    if(cfdict.get(id)!=null){
                        cfdict.get(id).update("name",fn.get("name"));
                        cfdict.get(id).update("avatar_version",fn.get("avatar_version"));
                    }
                    else{
                        flist1.append(fn);
                        cfdict.update(id,fn);
                        fn.update("level",-1);
                    }
            }
            var bd = dict();
            var db = c_opendb(0,"friendinvited");
            for(i=0;i<len(bufferflist3);i++){
                fn = bufferflist3[i];
                id = int(fn.get("papayaid"));
                bd.update(id,1);
                if(cfdict.get(id)!=null){
                    var fb=cfdict.get(id);
                }
                else{
                    continue;
                    fb = dict();
                    fb.update("id",id);
                    flist1.append(fb);
                }
                fb.update("level",fn.get("lev"));
                fb.update("visited",fn.get("visited"));
                if(fb.get("level")>-1)
                    global.ppyuserdict.update(str(id),fb); 
                else if(db.get(str(id))==1){
                    flist1.remove(fb);
                }
            }
            bd.update(ppy_userid(),1);
            for(i=len(bufferflist1)-1;i>=0;i--){
                if(bd.get(bufferflist1[i].get("id"))==1){
                    bufferflist1.pop(i);
                }
            }
            //updateflist1();
            if(flist!=null){
                refreshflist();
            }
            begindownloadfromourserver();
        }
    }
    
    var string1;
    var bufferflist2;
    function begindownloadfromourserver(){
        var le=len(bufferflist1);
        var tmp;
        bufferflist2 = new Array(0);
        if(le!=0){
            tmp = bufferflist1.pop();
            bufferflist2.append(tmp);
            string1 = str(tmp.get("id"))+",0";
            for(var i=1;i<50&&i<le;i++){
                tmp = bufferflist1.pop();
                bufferflist2.append(tmp);
                string1 = string1+";"+str(tmp.get("id"))+",0";
            }
            http_request(BASE_URL+"addppyfriend",retlevback,"uid="+str(global.userid)+"&rrstring="+uri_encode(string1));
            flagfriendover = 0;
            trace(string1);
            trace("uid="+str(global.userid)+"&rrstring="+uri_encode(string1));
        }
        else{
            flaglock=0;
            //updateflist1();
        }
    }
    
    function useaction(p,rc,c){
        if(p=="retlevback"){
            retlevback(0,rc,c);
        }
    }

    function retlevback(r,rc,c){
        if(rc == 0){
            trace("fail to get id");
            flagfriendover = 2;
            http_request(BASE_URL+"addppyfriend",retlevback,"uid="+str(global.userid)+"&rrstring="+uri_encode(string1));
            return 0;
        }
        else{
            var obj = json_loads(c);
            if(obj==null||obj.get("id",1)==0){
                flagfriendover = 2;
                http_request(BASE_URL+"addppyfriend",retlevback,"uid="+str(global.userid)+"&rrstring="+uri_encode(string1));
                return 0;
            }
            var db = c_opendb(0,"friendinvited");
            var cfdict = dict();
            for(var i=0;i<len(flist1);i++){
                cfdict.update(flist1[i].get("id"),flist1[i]);
            }
            for(i=0;i<len(bufferflist2);i++){
                var fn = bufferflist2[i];
                var id = fn.get("id");
                if(cfdict.get(id)!=null){
                    cfdict.get(id).update("avatar_version",fn.get("avatar_version",0));
                    fn = cfdict.get(id);
                }
                else{
                    if(db.get(str(id))==1){
                        continue;
                    }
                    flist1.append(fn);
                }
                if(obj.get(str(id))==null || obj.get(str(id)).get("level")==-1){
                    fn.update("level",-1);
                }
                else{
                    fn.update("level",obj.get(str(id)).get("level"));
                    if(visited.get(id)!=1){
                        fn.update("visited",obj.get(str(id)).get("visited"));
                    }
                    global.ppyuserdict.update(str(id),fn);
                }
            }
            var s=global.getfriend(ppy_userid());
            s.update("visited",1);
            s.update("level",global.user.getValue("level"));
            flagfriendover = 1;
            //updateflist1();
            begindownloadfromourserver();
            if(flist!=null){
                refreshflist();
            }
        }
    }
    
    var flagmove;
    var lasttime;
    var lastx;
    function friendchoose(n,e,p,x){
        global.context[0].hiddentime = 10;
        if(e == EVENT_TOUCH){
            lastx = x;
            return 1;
        }
        else if(e == EVENT_MOVE){
            var np = flistback.pos();
            var pl = (45-np[0])/90;
            np[0] = np[0]+x-lastx;
            flistback.pos(np);
            lastx = x;
            var pn = (45-np[0])/90;
            if(pl != pn){
                for(var i=0;i<flength;i++){
                    if(i<pn-1 || i>pn+8){
                        if(flist[i]!=null){
                            flist[i].removefromparent();
                            flist[i] = null;
                        }
                    }
                    else if(flist[i] == null)
                        flistback.add(getfnode(i));
                }
            }
            return 1;
        }
        else if(e == EVENT_UNTOUCH){
            var pe = (flistback.pos()[0]-45)/90;
            if(pe <= 8-flength)
                pe = 8-flength;
            if(pe >= 0) 
                pe = 0;
            flistback.addaction(moveto(300,pe*90,0));
            for(i=0;i<flength;i++){
                if(i<-pe || i>8-pe){
                    if(flist[i]!=null){
                        flist[i].removefromparent();
                        flist[i] = null;
                    }
                }
                else if(flist[i] == null){
                    flistback.add(getfnode(i));
                }
            }
            fpos[friendmode-1] = pe*90;
            check(pe);
        }
    }
    
    function getfnode(i){
        var nd;
        var param;
        if(friendmode==1){
            if(i==0){
                nd = sprite("friend_objcircle.png");
                param=-1;
            }
            else if(i==1){
                nd = sprite("friend_rank.png");
                param=-5;
            }
            else if(i==flength-1){
                nd = sprite("friend_objinvite.png");
                nd.addsprite(friendimage[3]);
                param=-2;
            }
            else{
                var per=flist1[i-2];
                if(i==2){
                    nd = sprite("friend_caesar.png");
                }
                else{
                    if(i==selectf){
                        nd = sprite(friendimage[1]);
                    }
                    else{
                        nd = sprite(friendimage[0]);
                    }
                    nd.add(sprite(avatar_url(per.get("id"))).pos(13,9).size(50,50),0,1);
                }
                var name = per.get("name");
                if(len(name)>9){
                    name = substring(name,0,6)+"..";
                }
                nd.addlabel(name,null,16).anchor(50,50).pos(36,69).color(0,  0,  0,100);
                if(per.get("level")>-1){
                    var le = nd.addsprite(friendimage[4]).anchor(35,30).pos(0,0);
                    le.addlabel(str(per.get("level")),null,16).anchor(50,50).pos(19,18);
                    param = per.get("id");
                    if(per.get("visited")==0){
                        nd.add(sprite(friendimage[2]).anchor(50,50).pos(57,56),1,2);
                    }
                }
                else{
                    nd.addsprite(friendimage[3]);
                    param=-per.get("id")-10;
                }
            }
        }
        else if(friendmode==2){
            if(i==0){
                nd = sprite("friend_objadd.png");
                param=-3;
            }
            else if(i>len(flist2)){
                nd = sprite("friend_objnone.png");
                param = -4;
            }
            else{
                per = global.getfriend(flist2[i-1]);
                if(per.get("id")==selectp){
                    nd = sprite(friendimage[1]);
                    selectf = i;
                }
                else{
                    nd = sprite("friend_objback2.png");
                }
                nd.add(sprite(avatar_url(per.get("id"))).pos(13,9).size(50,50),0,1);
                name = per.get("name");
                if(len(name)>9){
                    name = substring(name,0,6)+"..";
                }
                nd.addlabel(name,null,16).anchor(50,50).pos(36,69).color(0,  0,  0,100);
                le = nd.addsprite("nobi"+str(fnob[i-1])+".png").anchor(35,30).pos(0,0).size(35,35);
                param = per.get("id");
                if(per.get("visited")==0){
                    nd.add(sprite(friendimage[2]).anchor(50,50).pos(57,56),1,2);
                }
            }
        }
        nd.pos(80+90*i,13);
        nd.setevent(EVENT_TOUCH,friendclicked);
        nd.setevent(EVENT_MOVE,friendclicked);
        nd.setevent(EVENT_UNTOUCH,friendclicked,param);
        flist[i] = nd;
        return nd;
    }
    
    function friendclicked(n,e,param,x){
        if(global.currentLevel <= 1){
            if(e == EVENT_TOUCH){
                lasttime = time();
                flagmove = 0;
                var lx = n.node2world(x,0)[0];
                friendchoose(n,EVENT_TOUCH,0,lx);
                return 1;
            }
            else if(e== EVENT_MOVE){
                if(flagmove == 0){
                    if(x<0|| x>n.size()[0])
                        flagmove =1;
                    else if(time()-lasttime > 1000)
                        flagmove =1;
                    return 0;
                }
                else{
                    lx = n.node2world(x,0)[0];
                    friendchoose(n,EVENT_MOVE,0,lx);
                }
            }
            else if(e == EVENT_UNTOUCH){
                if(flagmove == 0 &&param!=null){
                    if(param>= 0){
                        global.context[0].getfriend(param);
                        var offset=0;
                        if(friendmode==1) offset=2;
                        if(selectf>offset&&flist[selectf]!=null){
                            if(friendmode==1){
                                flist[selectf].texture(friendimage[0]);
                            }
                            else{
                                flist[selectf].texture("friend_objback2.png");
                            }
                        }
                        selectp = param;
                        if(friendmode==1){
                            for(var i=0;i<len(flist1);i++){
                                if(flist1[i].get("id")==param){
                                    selectf = i+2;
                                    break;
                                }
                            }
                        }
                        else{
                            selectf = flist2.index(selectp)+1;
                        }
                        if(selectf<len(flist)&&flist[selectf]!=null){
                            flist[selectf].remove(2);   
                        }
                        global.getfriend(param).update("visited",1);
                        visited.update(param,1);
                        if(selectf>offset &&selectf<len(flist)&&flist[selectf]!=null){
                            flist[selectf].texture(friendimage[1]);
                        }
                    }
                    else if(param == -1){
                        global.pushContext(null,new TestWebControl(0),NonAutoPop);
                    }
                    else if(param == -2){
                        if(sysinfo(21)!=null&&int(sysinfo(21))>=4){
                            invite_friends("木瓜游戏","与我一起玩奇迹帝国吧！","hi，我正在玩奇迹帝国，快与我一起经营、征战、创建自己的帝国吧！*奇迹帝国是一款大型手机社交游戏，各种手机平台都可以下载。下载地址：https://market.android.com/details?id=com.papaya.wonderempire1_cn");
                        }
                        else{
                            global.pushContext(null,new TestWebControl(1),NonAutoPop);
                        }
                    }
                    else if(param == -3){
                        global.context[0].ally(0,0,3);
                    }
                    else if(param==-4){
                        global.pushContext(null,new Warningdialog(["你可以访问好友和好友结盟，盟友会帮你战斗哦！",null,3]),NonAutoPop);
                    }
                    else if(param==-5){
                        global.pushContext(null,new Rankingdialog(),NonAutoPop);
                    }
                    else{
                        invitefriend(-param-10);
                    }
                }
                else{
                    lx = n.node2world(x,0)[0];
                    friendchoose(n,EVENT_UNTOUCH,0,lx);
                }
            }
        }
    }
    
    function invitefriend(ppyid){
        var d=dict([["message","快来和我一起创造奇迹吧！"],["uid",ppyid]]);
        ppy_query("send_notification",d,inviteover);
        for(var i=0;i<len(flist1);i++){
            if(flist1[i].get("id")==ppyid){
                trace("find",i);
                flist1.pop(i);
                var db = c_opendb(0,"friendinvited");
                db.put(str(ppyid),1);
                //updateflist1();
                refreshflist();
                return 0;
            }
        }
    }
    function inviteover(r,rc,cdict){
        trace(rc,cdict);
        if(rc!=0 && cdict.get("status")==1){
            global.pushContext(null,new Warningdialog(["邀请成功！",null,4]),NonAutoPop);
            if(global.task.tasktype==4){
                global.task.inctaskstep(1);
            }
        }
    }
}