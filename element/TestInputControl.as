class TestInputControl extends ContextObject{
    var lock;
    var web;
    var warning;
    var element;
    var dialog;

    function TestInputControl(){
        contextname = "dialog-rename";
        contextNode = null;
        element = null;
        lock =0;
    }
    
    function getelement(){
        if(element == null){
            element = node();
            element.addsprite("renamepic.jpg").pos(17,42);
            element.addlabel("请输入帝国名称：",null,20).pos(136,85).color(0,0,0,100);
            //element.addsprite("renameelement.jpg").pos(136,110);
            web = v_create(V_INPUT_VIEW,333,222,236,60);
            v_root().addview(web);
            web.text(global.user.getValue("cityname"));
            
            warning = element.addlabel("",null,16).pos(136,160).color(100,0,0,100);
        }
        return element;
    }

    function paintNode(){
        dialog = new Simpledialog(1,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.settitle("renametitle.png");
        dialog.usedefaultbutton(2,["修改","取消"]);
        if(global.flagnew == 1){
            contextNode.get(1).setevent(EVENT_UNTOUCH,null);
        }
    }
    

    function excute(p){
        if(lock == 0){
            lock = 1;
            var t = web.text();
            var l = len(t);
            var st = uri_encode(t);
            var ul = len(st);
            l = l-(ul - l)/6;
            if(l>14){
                warning.text("限7个汉字或者14个英文字符！");
                lock=0;
                return 0;
            }
            if(t==""|| t == "我的帝国" || t==global.user.getValue("cityname")){
                warning.text("不能改成这个名字！");
                lock = 0;
                return 0;
            }
            web.visible(0);
            contextNode.visible(0);
            global.http.addrequest(1,"changename",["userid","newname"],[global.userid,t],self,"renameover");
        }
    }
    
    function useaction(p,rc,c){
        if(p=="renameover"){
            renameover(0,rc,c);
        }
    }
    
    function renameover(r,rc,c){
        contextNode.visible(1);
        web.visible(1);
        if(rc != 0 && json_loads(c).get("id") == 1){
            var t = web.text();
            global.user.setValue("cityname",t);
            global.popContext(null);
            if(global.flagnew == 1){
                global.newcontext.getNode().visible(1);
                global.newcontext.nextstate(0,0);
                global.user.changeValueAnimate2(global.context[0].ub,"exp",5,-6);
            }
        }
        else{
            warning.text("抱歉，因网络原因本次改名失败！");
        }
        lock = 0;
    }

    function closedialog(node,event){
        if(global.flagnew == 0)
            global.popContext(null);
    }

    function deleteContext(){
        contextNode.removefromparent();
        web.removefromparent();
    }
}