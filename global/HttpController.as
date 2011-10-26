class HttpController extends ContextObject{
    var requestlist;
    var handledict;
    var handledict2;
    var responsedict;
    var synlock;
    
    var flag_netstate;
    var retrylist;
    var requestnum;
    function HttpController(){
        requestlist = new Array(0);
        handledict = dict();
        handledict2 = dict();
        synlock = 0;
        flag_netstate = 0;
        retrylist = new Array(0);
        contextname = "dialog-network";
        requestnum = 0;
        //c_addtimer(500,handlerequest);
    }
    function addrequest(syn,requrl,postkey,postvalue,cmdobj,cmd){
        trace("addhttprequest",requrl,postkey,postvalue);
        if(syn == 1 && synlock == 0){
            global.lock();
            synlock = 1;
        }
        var handle = dict();
        handle.update("syn",syn);
        handle.update("request",requrl);
        var poststr =null;
        if(postkey!=null&&len(postkey)!=0){
            var param = dict();
            poststr = "";
            var length = len(postkey);
            for(var i=0;i<length;i++){
                param.update(postkey[i],postvalue[i]);
                poststr = poststr+"&"+postkey[i]+"=";
                if(type(postvalue[i])==1){
                    poststr = poststr + str(postvalue[i]);
                }
                else{
                    poststr = poststr + uri_encode(postvalue[i]);
                }
            }
            handle.update("param",param);
            poststr = substring(poststr,1);
            handle.update("poststr",poststr);
        }
        else{
            handle.update("param",dict());
            handle.update("poststr",null);
        }
        handle.update("target",cmdobj);
        handle.update("action",cmd);
        handle.update("retry",0);
        addhandle(handle);
    }
    
    function addhandle(handle){
        if(handle.get("target").contextname.rfind("object-build")!=-1){
            if(len(handledict2)<1){
                var rid=http_request(BASE_URL+handle.get("request"),httpcallback,handle.get("poststr"),15000);
                handledict2.update(rid,handle);
                requestnum++;
 
            }
            else{
                requestlist.append(handle);
            }
        }
        else{
            rid=http_request(BASE_URL+handle.get("request"),httpcallback,handle.get("poststr"),15000);
            handledict.update(rid,handle);
        }
    }
    
    function paintNode(){
        var dialog = new Simpledialog(1,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.setbutton(1,117,228,"重试",1);
        dialog.setbutton(2,286,228,"取消",0);
    }
    
    function excute(p){
        if(p==0){
            quitgame();
        }
        else{
            deleteContext();
            global.lock();
            synlock = 1;
            flag_netstate = 0;
            for(var i=0;i<len(retrylist);i++){
                var handle = retrylist[i];
                trace("LOG","retry",handle.get("request"),handle.get("poststr"));
                addhandle(handle);
            }
            retrylist = new Array(0);
        }
    }
    
    const noticestr = ["貌似断网了，请检查是否有网络连接","网络连接遇到了问题，请稍候再试"];
    function getelement(){
        var element = node();
        element.addsprite("networkelement.jpg").pos(19,50);
        element.addlabel(noticestr[flag_netstate-1],null,20,FONT_NORMAL,200,0,ALIGN_LEFT).pos(156,60).color(0,0,0,100);
        return element;
    }
    
    function deleteContext(){
        contextNode.removefromparent();
        contextNode = null;
    }
    
    function httpcallback(r,rc,c){
        var handle = handledict.pop(r,null);
        if(handle == null){
            handle=handledict2.pop(r,null);
            if(handle!=null){
                requestnum--;
            }
        }
        if(handle==null){
            trace("LOG callback error!",r);
            return 0;
        }
        if(rc != 1||c==null||type(c)!=type("str")){
            if(flag_netstate>0){
                trace("LOG",handle.get("request"),"fail-retry");
                handle.update("retry",0);
                retrylist.append(handle);
                return 0;
            }
            if(handle.get("retry")==1){
                if(synlock==1){
                    synlock = 0;
                    global.unlock();
                }
                flag_netstate = 1+ppy_connected();
                retrylist.append(handle);
                trace("LOG",handle.get("request"),"fail-retry-network");
                global.shotscreen.add(self.getNode());
                contextNode.add(sprite("dark.png").color(0,0,0,darkColorAlpha).anchor(50,50).size(800,480).pos(202,135).setevent(EVENT_UNTOUCH,donothing),-1);
            }
            else{
                trace("LOG",handle.get("request"),handle.get("poststr"),"retry");
                handle.update("retry",handle.get("retry")+1);
                addhandle(handle);
            }
            return 0;
        }
        trace("LOG",handle.get("request"),"success");
        if(synlock==1 && len(handledict)==0){
            synlock=0;
            global.unlock();
        }
        if(requestnum<5&&len(requestlist)>0){
            addhandle(requestlist.pop(0));
        }
        handle.get("target").useaction(handle.get("action"),rc,c);
        if(global.task.tasktype == 0){
            if(global.task.taskreq == handle.get("request")){
                var ok=1;
                if(global.task.taskreq == "planting"){
                    handle.get("param").update("bid",handle.get("target").bid);
                }
                for(var i=0;i<len(global.task.taskpair);i=i+2){
                    var key = global.task.taskpair[i];
                    var value = global.task.taskpair[i+1];
                    var cvalue = handle.get("param").get(key);
                    if(key=="ground_id"){
                        if(cvalue/100==1){
                            cvalue = cvalue%100%3+100+cvalue%100/12*12;
                        }
                        else if(cvalue>=404 && cvalue<412){
                            cvalue=400+cvalue%100/4*4;
                        }
                        else if(cvalue>=505 && cvalue<=510){
                            cvalue = 505;
                        }
                        else if(cvalue>=521 && cvalue<=523){
                            cvalue = 521;
                        }
                        else if(cvalue>=524 && cvalue<=527){
                            cvalue = 524;
                        }
                        else if(cvalue>=528 && cvalue<=531){
                            cvalue = 528;
                        }
                        else if(cvalue>=532 && cvalue<=534){
                            cvalue = 532;
                        }
                        else if(cvalue>=535 && cvalue<=537){
                            cvalue = 535;
                        }
                    }
                    if(value != cvalue){
                        ok=0;
                    }
                }
                if(ok==1){
                    global.task.inctaskstep(1);
                }
            }
        }
        if(global.wartask.wartasktype == 0){
            if(global.wartask.wartaskreq == handle.get("request")){
                ok=1;
                for(i=0;i<len(global.wartask.wartaskpair);i=i+2){
                    key = global.wartask.wartaskpair[i];
                    value = global.wartask.wartaskpair[i+1];
                    cvalue = handle.get("param").get(key);
                    if(value != cvalue){
                        ok=0;
                    }
                }
                if(ok==1){
                    global.wartask.incwartaskstep(1);
                }
            }
        }
    }
}