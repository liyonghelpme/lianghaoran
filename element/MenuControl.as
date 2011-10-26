class MenuControl extends ContextObject{
    var music;
    var flagmusic;
    var flagrob;
    var musicbutton;
    var flagnotice;
    var flagnight;
    var noticebutton;
    var refreshbutton;
    var screenbutton;
    var quitbutton;
    var lock=0;
    var musiclist;
    var bigbutton;
    var smallbutton;

    function MenuControl(){
        contextname = "dialog-system";
        contextNode = null;
        lock=0;
        musiclist=new Array(0);
        flagrob = 0;
    }

    //config: flagmusic,flagnotice
    function initwithconfig(){
        var fp = c_file_open("config"+str(ppy_userid()),1);
        var configstr = "11";
        if(c_file_exist(fp) != 0){
            configstr = c_file_op(C_FILE_READ,fp);
            if(len(configstr)!=2){
                configstr = "11";
            }
        }
        flagmusic = int(configstr[0]);
        flagnotice = int(configstr[1]);
        fp = null;
        rewriteconfig();
        music = null;
    }
    
    function rewriteconfig(){
        var fp = c_file_open("config"+str(ppy_userid()),1);
        c_file_op(C_FILE_WRITE,fp,str(flagmusic)+str(flagnotice));
    }
    
    function pushmusic(name){
        if(music != null && flagmusic==1){
            music.stop();
        }
        musiclist.append(name);
        if(flagmusic == 1){
            music = createaudio(name);
            music.play(-1);
        }
    }
    
    function popmusic(){
        if(music != null && flagmusic == 1){
            music.stop();
        }
        musiclist.pop();
        if(flagmusic == 1 && len(musiclist)>0){
            music = createaudio(musiclist[len(musiclist)-1]);
            music.play(-1);
        }
    }

    function paintNode(){
        contextNode = sprite("dialogback_menu.png").anchor(50,50).pos(400,240).size(439,383);
        contextNode.addsprite("builddialogclose.png").anchor(100,0).pos(423,13).setevent(EVENT_UNTOUCH,closedialog);
        //refreshbutton = contextNode.addsprite("refreshbutton.png").pos(17,76).setevent(EVENT_UNTOUCH,refreshuser);
        contextNode.addsprite("nightbutton0.png").pos(17,76).setevent(EVENT_UNTOUCH,changenight);
        musicbutton = contextNode.addsprite("musicbutton"+str(flagmusic)+".png").pos(154,76).setevent(EVENT_UNTOUCH,switchmusic);
        noticebutton = contextNode.addsprite("noticebutton"+str(flagnotice)+".png").pos(291,76).setevent(EVENT_UNTOUCH,switchnotice);
        screenbutton = contextNode.addsprite("screenbutton.png").pos(17,213).setevent(EVENT_UNTOUCH,screenshot);
        contextNode.addsprite("helpbutton.png").pos(154,213).setevent(EVENT_UNTOUCH,help);
        contextNode.addsprite("invitebutton.png").pos(291,213).setevent(EVENT_UNTOUCH,invite);
    }
    
    function invite(){
        global.popContext(null);
        if(sysinfo(21)!=null&&int(sysinfo(21))>=4){
            invite_friends("木瓜游戏","与我一起玩奇迹帝国吧！","hi，我正在玩奇迹帝国，快与我一起经营、征战、创建自己的帝国吧！*奇迹帝国是一款大型手机社交游戏，各种手机平台都可以下载。下载地址：https://market.android.com/details?id=com.papaya.wonderempire1_cn");
        }
        else{
            global.pushContext(null,new TestWebControl(1),NonAutoPop);
        }
    }
    
    function entermedal(){
        global.popContext(null);
        global.pushContext(null,new Medaldialog(global.card),NonAutoPop);
    }
    
    function changenight(n){
        flagnight=1-flagnight;
        n.texture("nightbutton"+str(flagnight)+".png");
    }
    
    function help(){
        global.popContext(null);
        global.pushContext(null,new TestWebControl(""),NonAutoPop);
    }

    function sizechange(n,e,p){
        var mode = global.context[0].mode;
        var tmode = mode+p;
        trace(mode,tmode);
        if(mode == PS_MAX && p<0){
            bigbutton.color(100,100,100,100);
        }
        else if(mode == PS_MIN && p>0){
            smallbutton.color(100,100,100,100);
        }
        if(tmode >= PS_MAX){
            bigbutton.color(40,40,40,100);
        }
        else if(tmode <= PS_MIN){
            smallbutton.color(40,40,40,100);
        }
        global.context[0].sizeModeft(mode,tmode);
    }

    function refreshuser(n,e){
        global.popContext(null);
    }

    function screenshot(n,e){
        if(global.currentLevel == contextLevel){
            global.popContext(null);
            //global.dialogscreen.visible(0);
            global.context[0].menu.visible(0);
            global.shotscreen.bitmap(shotover,1);
        }
    }

    function shotover(n,b,p){
        trace("shotover",p);
        ppy_postnewsfeed(ppy_username()+"晒出了自己领地的截图，大家快来围观吧！","http://getmugua.com",b.bitmap2bytes("png"));
        global.context[0].menu.visible(1);
        if(global.task.tasktype==5){
            global.task.inctaskstep(1);
        }
    }

    function quit(n,e){
        if(global.currentLevel == contextLevel){
            global.popContext(null);
            global.pushContext(null,new Quitdialog(),NonAutoPop);
        }
    }
    function switchmusic(n,e){
        if(global.currentLevel == contextLevel){
            flagmusic = 1-flagmusic;
            musicbutton.texture("musicbutton"+str(flagmusic)+".png");
            rewriteconfig();
            if(flagmusic == 1){
                music = createaudio(musiclist[len(musiclist)-1]);
                music.play(-1);
            }
            else{
                music.stop();
            }
        }
    }

    function switchnotice(n,e){
        if(global.currentLevel == contextLevel){
            flagnotice = 1-flagnotice;
            noticebutton.texture("noticebutton"+str(flagnotice)+".png");
            rewriteconfig();
            var grounds = global.context[0].grounds;
            if(flagnotice == 1){
                for(var i=0;i<len(grounds);i++){
                    if(grounds[i].contextid == 2 || grounds[i].contextid == 3)
                        grounds[i].objnode.stateNode.visible(1);
                }
            }
            else{
                for(i=0;i<len(grounds);i++){
                    if(grounds[i].contextid == 2 || grounds[i].contextid == 3)
                        grounds[i].objnode.stateNode.visible(0);
                }
            }
        }
    }

    function reloadNode(re){
    }

    function closedialog(node,event){
        global.popContext(null);
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        contextNode = null;
    }
}