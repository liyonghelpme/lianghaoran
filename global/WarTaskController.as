class WarTaskController extends ContextObject{
    var wartasktype;
    var wartaskreq;
    var wartaskpair;
    var wartaskdes;
    var wartaskreward;
    var wartasknum;
    var wartaskstep;
    var wartaskid;
    var enternode;
    var wartasklib;
    function WarTaskController(){
        contextNode = null;
        contextname = "dialog-wartask";
        enternode = sprite("wtask3.png").anchor(50,50).scale(90);
        enternode.setevent(EVENT_UNTOUCH,enterwartask);
        wartasktype =-1;
        wartasklib = dict();
        wartasklib.update(0,json_loads("{'id':0,'type':0,'req':'warinfo','pair':[],'des':['开启战争模式','升到第10级之后可以开启战争模式，你将能与其他玩家一起角逐帝王之路！还在等什么？赶快升到第10级吧！！','开启战争模式','提示：首先点击地图按钮，再点击战争图标'],'checknum':1,'reward':[5000,10,0]}"));
        wartasklib.update(1,json_loads("{'id':1,'type':2,'req':'dialog-help','des':['查看帮助文档','战争系统有很多新的设定，快去看看有哪些新设定吧！','查看战争相关帮助文档'],'checknum':1,'reward':[100,5,0]}"));
        wartasklib.update(2,json_loads("{'id':2,'type':0,'req':'makeally','pair':[],'des':['好友结盟','与一个强大的好友结盟，等你与其他人作战时，盟友会给你援军哦！','与一个好友结盟'],'checknum':1,'reward':[500,10,0]}"));
        wartasklib.update(3,json_loads("{'id':3,'type':3,'req':'adddefence','des':['增加防御力','城墙防御力可以有效阻挡其他用户的进攻点击城堡再点击加号按钮增加防御力','增加100城墙防御力'],'checknum':100,'reward':[1000,15,0]}"));
        wartasklib.update(4,json_loads("{'id':4,'type':0,'req':'build','pair':['ground_id',206],'des':['建造侦察兵训练营','建造侦察兵训练营可以训练侦察兵侦察敌情','建造普通侦察兵训练营'],'checknum':1,'reward':[500,8,0]}"));
        wartasklib.update(5,json_loads("{'id':5,'type':1,'req':'soldiers','pair':['btype',2,'objtype',0],'des':['训练侦察兵','普通侦察兵可以从事侦察工作，为你获取敌人信息','训练普通侦察兵'],'checknum':9,'reward':[800,10,0]}"));
        wartasklib.update(6,json_loads("{'id':6,'type':0,'req':'detect','pair':[],'des':['侦察敌人','知己知彼百战百胜，侦察敌人可以获取到Ta的战斗力信息','侦察敌人'],'checknum':1,'reward':[300,7,0]}"));
        wartasklib.update(7,json_loads("{'id':7,'type':0,'req':'attack','pair':[],'des':['攻打敌人','战胜敌人可以升级爵位，获取敌人的资源，成就帝王之路！','攻打敌人'],'checknum':1,'reward':[1000,10,0]}"));
        wartasklib.update(8,json_loads("{'id':8,'type':0,'req':'addallyupbound','pair':[],'des':['增加盟友位','你可以通过增加盟友位置来与更多的好友结盟','增加盟友位'],'checknum':1,'reward':[1500,20,0]}"));
        wartasklib.update(9,json_loads("{'id':9,'type':2,'req':'dialog-nobility','pair':[],'des':['升级爵位','爵位越高可以前往越高等级的地图','升级爵位'],'checknum':1,'reward':[2000,25,0]}"));
        wartasklib.update(10,json_loads("{'id':10,'type':0,'req':'upgrademap','pair':[],'des':['进入高级地图','打败一定数量的敌人可以进入到更高级的地图',' 进入更高一级地图'],'checknum':1,'reward':[2000,25,0]}"));
/*
        var wartaskfile = c_res_file("wartask.txt");
        var wartaskstr = c_file_op(C_FILE_READ,wartaskfile);
        var wartaskstrs = wartaskstr.split(";");
        for(var i=0;i<len(wartaskstrs);i++){
            var wartaskobj = json_loads(wartaskstrs[i]);
            if(wartaskobj==null){
                trace("wartaskerr",i);
            }
            else{
                wartasklib.update(wartaskobj.get("id"),wartaskobj);
            }
        }
        */
    }
    
    function initwartask(p,s){
        if(p==null || p==-1){
            wartasktype = -1;
            wartaskid = -1;
            enternode.visible(0);
        }
        else{
            loadwartask(p,s);
            if(wartaskid<0){
                wartasktype = -1;
                enternode.visible(0);
            }
            else{
                enternode.visible(1);
            }
        }
    }
    
    function enterwartask(){
        global.pushContext(null,self,NonAutoPop);
        enternode.addaction(sequence(stop(),itexture("wtask3.png")));
        var tmp=enternode.get(1);
        if(tmp!=null){
            tmp.addaction(stop());
            tmp.removefromparent();
        }
    }
    
    function loadwartask(id,step){
        if(wartasklib.get(id)==null){
            wartaskid = -1;
            wartasktype = -1;
            return 0;
        }
        var wartask=wartasklib.get(id);
        wartasktype = wartask.get("type");
        wartaskid = wartask.get("id");
        wartaskreq = wartask.get("req");
        wartaskpair = wartask.get("pair");
        wartaskdes=wartask.get("des");
        wartaskreward=wartask.get("reward");
        wartasknum=wartask.get("checknum");
        trace(step);
        if(type(step) == type("")){
            step = int(step);
        }
        wartaskstep=step;
        if(wartaskstep>=wartasknum){
            enternode.addaction(sequence(stop(),itexture("wtask3.png")));
            var tmp = sprite("taskover0.png").pos(33,47);
            tmp.addaction(repeat(animate(1200,"taskover0.png","taskover2.png","taskover3.png","taskover4.png","taskover5.png","taskover7.png"),delaytime(800)));
            enternode.add(tmp,1,1);
        }
        else{
            tmp=enternode.get(1);
            if(tmp!=null){
                tmp.addaction(stop());
                tmp.removefromparent();
            }
            enternode.addaction(repeat(animate(1200,"wtask4.png","wtask3.png","wtask2.png","wtask1.png","wtask2.png","wtask3.png",ARGB_8888)));
        }
    }
    function incwartaskstep(i){
        wartaskstep=wartaskstep+i;
        global.http.addrequest(0,"wartaskstep",["uid","taskstring"],[global.userid,wartaskstep],self,"wartaskstep");
        if(wartaskstep>=wartasknum){
            enternode.addaction(sequence(stop(),itexture("wtask3.png")));
            var tmp = sprite("taskover0.png").pos(33,47);
            tmp.addaction(repeat(animate(1200,"taskover0.png","taskover2.png","taskover3.png","taskover4.png","taskover5.png","taskover7.png"),delaytime(800)));
            enternode.add(tmp,1,1);
        }
    }
    function setbutton(bt,x,y,n){
        var button = contextNode.addsprite("boxbutton"+str(bt)+".png").anchor(50,50).pos(x,y);
        button.addlabel(n,null,BUTTONFONTSIZE).anchor(50,50).pos(62,19);
        return button;
    }
    function paintNode(){
        contextNode = sprite("taskback2.png").anchor(50,50).pos(373,240);
        contextNode.addlabel(wartaskdes[0],null,40,FONT_BOLD).anchor(50,50).pos(334,60).color(0,0,0,100);
        if(wartaskstep >= wartasknum){
            contextNode.addlabel("恭喜你完成了任务！快去与好友分享吧！",null,20,FONT_NORMAL,120,0,ALIGN_LEFT).pos(171,110).color(27,21,9,100);
            contextNode.addlabel("点击分享将会有奖励哦！",null,20,FONT_NORMAL,120,0,ALIGN_LEFT).pos(171,182).color(12,72,80,100);
            var element = contextNode.addsprite("taskover.png").pos(310,96);
            element.addsprite("money_big.png").anchor(50,50).pos(30,172).size(32,32);
            element.addlabel(str(wartaskreward[0]),null,30).anchor(0,50).pos(50,172).color(0,0,0,100);
            element.addsprite("exp.png").anchor(50,50).pos(158,172);
            element.addlabel(str(wartaskreward[1]),null,30).anchor(0,50).pos(200,172).color(0,0,0,100);
            setbutton(4,356,407,"分享").setevent(EVENT_UNTOUCH,wartaskcomplete,1);
            setbutton(1,498,407,"完成").setevent(EVENT_UNTOUCH,wartaskcomplete,null);
        }
        else{
            contextNode.addlabel(wartaskdes[1],null,20,FONT_NORMAL,120,0,ALIGN_LEFT).pos(171,110).color(27,21,9,100);
            element = contextNode.addsprite("task.png").pos(314,96);
            if(len(wartaskdes)==4){
                element.addlabel(wartaskdes[3],null,18,FONT_NORMAL,234,0,ALIGN_LEFT).anchor(100,100).color(43,75,0,100).pos(240,185);
            }
            element.addlabel(wartaskdes[2]+"  "+str(wartaskstep)+"/"+str(wartasknum),null,20,FONT_NORMAL,240,0,ALIGN_LEFT).pos(13,30).color(0,0,0,100);
            element.addsprite("money_big.png").anchor(50,50).pos(30,247).size(32,32);
            element.addlabel(str(wartaskreward[0]),null,30).anchor(0,50).pos(50,247).color(0,0,0,100);
            element.addsprite("exp.png").anchor(50,50).pos(158,247);
            element.addlabel(str(wartaskreward[1]),null,30).anchor(0,50).pos(200,247).color(0,0,0,100);
            setbutton(1,356,407,"确定").setevent(EVENT_UNTOUCH,closedialog);
            setbutton(2,498,407,"放弃").setevent(EVENT_UNTOUCH,wartaskgiveup);
        }
        contextNode.setevent(EVENT_KEYDOWN,keydown);
    }
    function keydown(n,e,p,kc){
        if(kc==4){
            closedialog(0,0);
        }
    }
    
    function reloadNode(re){
        if(re==1){
            global.http.addrequest(1,"wartaskgivenup",["uid"],[global.userid],self,"wartaskgivenup");
        }
    }
    
    function wartaskgiveup(){
        global.pushContext(self,new Warningdialog(["放弃任务将失去一次额外奖励的机会哦",1,5]),NonAutoPop);
    }
    
    function wartaskcomplete(n,e,p){
        global.popContext(null);
        enternode.visible(0);
        if(p==1){
            global.http.addrequest(0,"share",["uid"],[global.userid],global.context[0],"share");
            ppy_postnewsfeed(ppy_username()+"完成了"+wartaskdes[0]+"任务，赶快加入与"+ppy_username()+"一起打造属于自己的奇迹帝国吧！","http://getmugua.com");
        }
        global.http.addrequest(0,"wartaskaccomplished",["uid"],[global.userid],self,"wartaskaccomplished");
    }
    
    function useaction(p,rc,c){
        if(p=="wartaskstep"){
            wartaskstepover(0,rc,c);
        }
        else if(p=="wartaskgivenup"){
            trace("wartaskgiveup",rc,c);
            wartaskgivenup(0,rc,c);
        }
        else if(p=="wartaskaccomplished"){
            trace("wartaskcomplete",rc,c);
            wartaskaccomplished(0,rc,c);
        }
    }

    function wartaskstepover(r,rc,c){
        trace("step",rc,c);
    }
    
    function wartaskgivenup(r,rc,c){
        if(rc>0&&json_loads(c).get("id",1)!=0){
            global.popContext(null);
            initwartask(json_loads(c).get("task",-1),0);
        }
    }
    
    function wartaskaccomplished(r,rc,c){
        if(rc>0&&json_loads(c).get("id",1)!=0){
            global.user.changeValueAnimate2(global.context[0].moneyb,"money",wartaskreward[0],-6);
            global.user.changeValueAnimate2(global.context[0].ub,"exp",wartaskreward[1],-6);
            initwartask(json_loads(c).get("task",-1),0);
            if(wartaskid==1) enterwartask();
        }
    }
        
    function deleteContext(){
        contextNode.removefromparent();
        contextNode = null;
    }
    
    function closedialog(n,e){
        global.popContext(null);
        if(wartaskid==1){
            global.pushContext(null,new TestWebControl("war"),NonAutoPop);
        }
    }
}