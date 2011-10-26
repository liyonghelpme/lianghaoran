class TaskController extends ContextObject{
    var tasktype;
    var taskreq;
    var taskpair;
    var taskdes;
    var taskreward;
    var tasknum;
    var taskstep;
    var taskid;
    var enternode;
    var tasklib;
    function TaskController(){
        contextNode = null;
        contextname = "dialog-task";
        enternode = sprite("task0.png").anchor(50,50);
        enternode.setevent(EVENT_UNTOUCH,entertask);
        tasktype =-1;
        tasklib = dict();
        var taskfile = c_res_file("task.txt");
        var taskstr = c_file_op(C_FILE_READ,taskfile);
        var taskstrs = taskstr.split(";");
        for(var i=0;i<len(taskstrs);i++){
            var taskobj = json_loads(taskstrs[i]);
            if(taskobj==null){
                trace("taskerr",i);
            }
            else{
                tasklib.update(taskobj.get("id"),taskobj);
            }
        }
    }
    
    function inittask(p,s){
        if(p==null || p==-1){
            tasktype = -1;
            taskid = -1;
            enternode.visible(0);
        }
        else{
            loadtask(p,s);
            if(taskid<0){
                tasktype = -1;
                enternode.visible(0);
            }
            else{
                enternode.visible(1);
            }
        }
    }
    
    function entertask(){
        global.pushContext(null,self,NonAutoPop);
        enternode.addaction(sequence(stop(),itexture("task0.png")));
        var tmp=enternode.get(1);
        if(tmp!=null){
            tmp.addaction(stop());
            tmp.removefromparent();
        }
    }
    
    function loadtask(id,step){
        if(tasklib.get(id)==null){
            taskid = -1;
            tasktype = -1;
            return 0;
        }
        var task=tasklib.get(id);
        tasktype = task.get("type");
        taskid = task.get("id");
        taskreq = task.get("req");
        taskpair = task.get("pair");
        taskdes=task.get("des");
        taskreward=task.get("reward");
        tasknum=task.get("checknum");
        trace(step);
        if(type(step) == type("")){
            step = int(step);
        }
        taskstep=step;
        if(taskstep>=tasknum){
            enternode.addaction(sequence(stop(),itexture("task0.png")));
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
            enternode.addaction(repeat(animate(800,"task1.png","task2.png","task3.png","task2.png",ARGB_8888)));
        }
        if(taskid==12 && taskstep == 0 && global.context[0].box.maxperson==0){
            global.context[0].box.maxperson = 1;
            global.context[0].box.helpperson = 0;
            global.context[0].box.boxfriends = [];
            global.http.addrequest(0,"newtbox",["user_id","num"],[global.userid,1],global.context[0].box,"setbox");
        }
        else if(tasktype == 0 && (taskreq=="build"||taskreq=="updatebuilding") && (taskpair[1]>=400&&taskpair[1]<500)){
            var g=taskpair[1]-400;
            if(global.user.getValue("godlevel")[g%4]>=g/4){
                inctaskstep(1);
            }
        }
        else if(tasktype == 0 && taskreq=="expand"){
            if(global.rect==40){
                inctaskstep(1);
            }
        }
    }
    function inctaskstep(i){
        taskstep=taskstep+i;
        global.http.addrequest(0,"taskstep",["uid","taskstring"],[global.userid,taskstep],self,"taskstep");
        if(taskstep>=tasknum){
            enternode.addaction(sequence(stop(),itexture("task0.png")));
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
        contextNode = sprite("taskback1.png").anchor(50,50).pos(373,240);
        contextNode.addlabel(taskdes[0],null,40,FONT_BOLD).anchor(50,50).pos(334,60).color(0,0,0,100);
        if(taskstep >= tasknum){
            contextNode.addlabel("恭喜你完成了任务！快去与好友分享吧！",null,20,FONT_NORMAL,120,0,ALIGN_LEFT).pos(171,110).color(27,21,9,100);
            contextNode.addlabel("点击分享将会有奖励哦！",null,20,FONT_NORMAL,120,0,ALIGN_LEFT).pos(171,182).color(12,72,80,100);
            var element = contextNode.addsprite("taskover.png").pos(310,96);
            element.addsprite("money_big.png").anchor(50,50).pos(30,172).size(32,32);
            element.addlabel(str(taskreward[0]),null,30).anchor(0,50).pos(50,172).color(0,0,0,100);
            element.addsprite("exp.png").anchor(50,50).pos(158,172);
            element.addlabel(str(taskreward[1]),null,30).anchor(0,50).pos(200,172).color(0,0,0,100);
            setbutton(4,256,407,"分享").setevent(EVENT_UNTOUCH,taskcomplete,1);
            setbutton(1,498,407,"完成").setevent(EVENT_UNTOUCH,taskcomplete,null);
        }
        else{
            contextNode.addlabel(taskdes[1],null,20,FONT_NORMAL,120,0,ALIGN_LEFT).pos(171,110).color(27,21,9,100);
            element = contextNode.addsprite("task.png").pos(314,96);
            if(len(taskdes)==4){
                element.addlabel(taskdes[3],null,18,FONT_NORMAL,234,0,ALIGN_LEFT).anchor(100,100).color(43,75,0,100).pos(240,185);
            }
            element.addlabel(taskdes[2]+"  "+str(taskstep)+"/"+str(tasknum),null,20,FONT_NORMAL,240,0,ALIGN_LEFT).pos(13,30).color(0,0,0,100);
            element.addsprite("money_big.png").anchor(50,50).pos(30,247).size(32,32);
            element.addlabel(str(taskreward[0]),null,30).anchor(0,50).pos(50,247).color(0,0,0,100);
            element.addsprite("exp.png").anchor(50,50).pos(158,247);
            element.addlabel(str(taskreward[1]),null,30).anchor(0,50).pos(200,247).color(0,0,0,100);
            setbutton(1,256,407,"确定").setevent(EVENT_UNTOUCH,closedialog);
            setbutton(2,498,407,"放弃").setevent(EVENT_UNTOUCH,taskgiveup);
        }
        contextNode.setevent(EVENT_KEYDOWN,keydown);
    }
    function keydown(n,e,p,kc){
        if(kc==4){
            closedialog(0,0);
        }
    }
    
    function gotoMacket(){
        inctaskstep(1);
        //global.pushContext(null,new TestWebControl(3),NonAutoPop);
        openUrl("http://papayamobile.com/a/mr?p=com.papaya.wonderempire1_cn&referrer=in_game_rating");
    }
    
    function reloadNode(re){
        if(re==1){
            global.http.addrequest(1,"taskgivenup",["uid"],[global.userid],self,"taskgivenup");
        }
    }
    
    function taskgiveup(){
        global.pushContext(self,new Warningdialog(["放弃任务将失去一次额外奖励的机会哦",1,5]),NonAutoPop);
    }
    
    function taskcomplete(n,e,p){
        global.popContext(null);
        enternode.visible(0);
        if(p==1){
            global.http.addrequest(0,"share",["uid"],[global.userid],global.context[0],"share");
            ppy_postnewsfeed(ppy_username()+"完成了"+taskdes[0]+"任务，赶快加入与"+ppy_username()+"一起打造属于自己的奇迹帝国吧！","http://getmugua.com");
        }
        global.http.addrequest(0,"taskaccomplished",["uid"],[global.userid],self,"taskaccomplished");
    }
    
    function useaction(p,rc,c){
        if(p=="taskstep"){
            taskstepover(0,rc,c);
        }
        else if(p=="taskgivenup"){
            trace("taskgiveup",rc,c);
            taskgivenup(0,rc,c);
        }
        else if(p=="taskaccomplished"){
            trace("taskcomplete",rc,c);
            taskaccomplished(0,rc,c);
        }
    }

    function taskstepover(r,rc,c){
        trace("step",rc,c);
    }
    
    function taskgivenup(r,rc,c){
        if(rc>0&&json_loads(c).get("id",1)!=0){
            global.popContext(null);
            inittask(json_loads(c).get("task",-1),0);
        }
    }
    
    function taskaccomplished(r,rc,c){
        if(rc>0&&json_loads(c).get("id",1)!=0){
            global.user.changeValueAnimate2(global.context[0].moneyb,"money",taskreward[0],-6);
            global.user.changeValueAnimate2(global.context[0].ub,"exp",taskreward[1],-6);
            inittask(json_loads(c).get("task",-1),0);
        }
    }
        
    function deleteContext(){
        contextNode.removefromparent();
        contextNode = null;
    }
    
    function closedialog(n,e){
        global.popContext(null);
        if(tasktype==3){
            gotoMacket();
        }
        else if(taskid==9){
            global.pushContext(null,new TestWebControl(0),NonAutoPop);
        }
    }
}