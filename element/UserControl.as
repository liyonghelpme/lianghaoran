import element.AttackControl;
import element.Attackbegindialog;
import element.SpyControl;
import element.Spyresult;
import element.SpeedattackControl;

class UserControl extends ContextObject{
    var pn;
    var gid;
    var buttons;
    var endtime;
    var timelabel;
    var timeisend;
    var mode;
    var ebdata;
    function UserControl(p){
        contextname = "control-battle";
        gid = p;
        contextNode = null;
        timeisend = 0;
    }
    
    function timerefresh(){
        var lefttime =endtime-global.timer.currenttime;
        timelabel.text(global.gettimestr(lefttime));
    }
    
    var l;
    function timeend(){
        global.popContext(null);
    }

    function paintNode(){
        pn = global.context[1].placedict.get(gid/8).get(gid%8);
        var eudata = global.context[1].userdict.get(gid);
        mode = 0;
        if(eudata[8] != 1 || global.flagnew==1){
            var ebindex = -1;
            for(var i=0;i<len(global.battlelist);i++){
                if(global.battlelist[i][2]==1&&global.battlelist[i][1] == eudata[0]){
                    ebindex = i;
                    ebdata = global.battlelist[i];
                    break;
                }
            }
            if(ebindex!=-1){
                mode = 1;
            }
            else if(global.timer.times2c(eudata[7])>global.timer.currenttime){
                mode=2;
            }
        }
        else{
            mode=3;
        }
        var posi = pn.pos();
        var tpos = pn.parent().node2world(posi[0],posi[1]);
        var toff = [0,0];
        if(tpos[0] < 153)
            toff[0] = 150-tpos[0];
        else if(tpos[0] > 800-153)
            toff[0] = 800-153-tpos[0];

        if(tpos[1] < 70)
            toff[1] = 70-tpos[1];
        else if(tpos[1] > 480-70)
            toff[1] = 480-70-tpos[1];

        global.context[1].nodeMove(toff[0],toff[1]);
        contextNode = sprite().pos(tpos[0]+toff[0],tpos[1]+toff[1]);
        
        var board=contextNode.addsprite("mapuserboard"+str(eudata[1])+".png").anchor(100,50).pos(70,0);
        board.prepare();
        if(eudata[1]==0){
            board.texture("android.png");
        }
        else{
            board.texture("ipod.png");
        }
        board.addsprite(avatar_url(int(eudata[0]))).pos(12,56).size(40,40);
        board.addsprite("nobi"+str(eudata[2]*3+eudata[6])+".png").pos(56,56);
        board.addlabel(eudata[4],null,18).pos(100,56).color(0,0,0,100);
        board.addlabel(NOBNAME[eudata[2]*3+eudata[6]],null,18).pos(100,77).color(0,0,0,100);
        l=board.addlabel("",null,18).pos(12,107).color(0,0,0,100);
        buttons = [14,15];
        if(mode == 3){
            l.text("已征服");
        }
        else if(mode==0){
            l.text("未征服");
            buttons = [12,13];
        }
        else{
            if(mode==2){
                endtime = global.timer.times2c(eudata[7]);
                l.text("保护中").color(0,0,67,100);
                timelabel = board.addlabel("",null,18).pos(197,107).anchor(100,0).color(0,0,0,100);
                global.timer.addlistener(endtime,self);
                timerefresh();
            }
            else{
                endtime = ebdata[0];
                if(endtime<global.timer.currenttime){
                    buttons[1]=16;
                    l.text("正在交战").color(75,0,0,100);
                }
                else{
                    buttons[1]=0;
                    l.text("进攻中").color(75,0,0,100);
                    timelabel = board.addlabel("",null,18).pos(197,107).anchor(100,0).color(0,0,0,100);
                    global.timer.addlistener(endtime,self);
                    timerefresh();
                }
            }
        }
        
        for(var k=0;k<2;k++){
            var filter = NORMAL;
            if(buttons[k]>=14){
                filter = GRAY;
            }
            var bt = contextNode.addsprite("buttontab0.png",filter).pos(65,-83+72*k);
            bt.add(sprite("opbutton"+str(buttons[k])+".png").anchor(50,50).pos(46,46),1,10+k);
            bt.setevent(EVENT_TOUCH,buttonclicked,k);
            bt.setevent(EVENT_UNTOUCH,buttonclicked,k);
        }
    }
    function buttonclicked(n,e,p){
        if(global.currentLevel == contextLevel){
            var filter = NORMAL;
            if(buttons[p]>=14){
                filter = GRAY;
            }
            if(e==EVENT_TOUCH)
                n.texture("buttontab1.png",filter);
            else{
                n.texture("buttontab0.png",filter);
                if(buttons[p]<14)
                    global.popContext(null);
                if(buttons[p] == 12){
                    global.pushContext(null,new SpyControl(gid),NonAutoPop);
                }
                else if(buttons[p] == 13){
                    global.pushContext(null,new AttackControl(gid),NonAutoPop);
                }
                else if(buttons[p]==0){
                    global.pushContext(null,new SpeedattackControl(ebdata),NonAutoPop);
                }
            }
        }
    }

    function deleteContext(){
        timeisend = 1;
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}