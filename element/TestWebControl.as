class TestWebControl extends ContextObject{
    var lock;
    var web;
    var mode;
    var helpstr;
    function TestWebControl(m){
        contextname = "dialog-web";
        contextNode = null;
        lock =0;
        mode = m;
        if(m==0){
            contextname="dialog-circle";
        }
        else if(m==3){
            contextname="dialog-mark";
        }
        else if(m==4){
            contextname="dialog-papayas";
        }
        else if(type(m)==type("")){
            contextname="dialog-help";
            mode=2;
            helpstr = m;
        }
    }

    function paintNode(){
        contextNode = sprite("webback.jpg").anchor(50,50).pos(400,240);
        contextNode.setevent(EVENT_TOUCH,closedialog);
        contextNode.setevent(EVENT_MOVE,closedialog);
        contextNode.setevent(EVENT_UNTOUCH,closedialog);
        contextNode.setevent(EVENT_KEYDOWN,keydown);
        
        if(mode==0){
            web = v_create(V_PPY_WEB_VIEW,4,65,791,411);
            v_root().addview(web);
            web.openurl("static_mycircles_circle?cid=1117");
        }
        else if(mode==1){
            web = v_create(V_PPY_WEB_VIEW,4,65,791,411);
            v_root().addview(web);
            web.openurl("static_invite");
        }
        else if(mode==2){
            web = v_create(V_WEB_VIEW,4,65,791,411);
            v_root().addview(web);
            web.openurl("http://223.4.87.9/#"+helpstr);
            //web.openurl("http://223.4.85.114/#"+helpstr);
        }
        else if(mode==3){
            web = v_create(V_WEB_VIEW,4,65,791,411);
            v_root().addview(web);
            web.openurl("http://market.android.com/details?id=com.papaya.wonderempire1_cn&feature=search_result");
        }
        else if(mode==4){
            web = v_create(V_PPY_WEB_VIEW,4,65,791,411);
            v_root().addview(web);
            web.openurl("static_getpapayas");
        }
        contextNode.focus(1);
    }
    
    function keydown(n,e,p,kc){
        if(kc==4){
            global.popContext(null);
        }
    }

    var isclicked=1;
    function closedialog(node,event,p,x,y){
        if(event!=EVENT_UNTOUCH){
            if(y<=60){
                isclicked=1;
            }
            else{
                isclicked=0;
            }
        }
        else{
            if(isclicked==1){
                global.popContext(null);
            }
        }
    }
    
    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        web.removefromparent();
    }
    
    function pause(){
        contextNode.removefromparent();
        contextNode = null;
        web.removefromparent();
        web = null;
    }
    function resume(){
        global.dialogscreen.add(getNode());
    }
}