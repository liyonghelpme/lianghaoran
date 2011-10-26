class PetRename extends ContextObject{
    var lock;
    var web;
    var warning;
    var element;
    var dialog;
    var nest;

    function PetRename(n){
        contextname = "dialog-rename";
        contextNode = null;
        element = null;
        lock =0;
        nest = n;
    }
    
    function getelement(){
        if(element == null){
            element = node();
            element.addsprite("petrenamepic.jpg").pos(17,42);
            element.addlabel("请输入宠物名称：",null,20).pos(136,85).color(0,0,0,100);
            //element.addsprite("renameelement.jpg").pos(136,110);
            web = v_create(V_INPUT_VIEW,333,213,236,60);
            v_root().addview(web);
            web.text(nest.petname);
            
            warning = element.addlabel("命名之后不能更改，请慎重命名",null,16).pos(136,160).color(100,0,0,100);
        }
        return element;
    }

    function paintNode(){
        dialog = new Simpledialog(1,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.usedefaultbutton(2,["修改","取消"]);
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
            if(t==""|| t == "我的宠物"){
                warning.text("不能改成这个名字！");
                lock = 0;
                return 0;
            }
            web.visible(0);
            contextNode.visible(0);
            global.http.addrequest(1,"namePet",["uid", "gid", "name", "cid"],[global.userid,nest.baseobj.posi[0]*RECTMAX+nest.baseobj.posi[1],t,global.cityid],self,"renameover");
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
            nest.petname=t;
            global.popContext(null);
            global.pushContext(self,new Warningdialog(["为了更好地体验宠物系统，请查看帮助文档",1,4]),NonAutoPop);
        }
        else{
            warning.text("抱歉，因网络原因本次改名失败！");
        }
        lock = 0;
    }
    
    function reloadNode(re){
        global.pushContext(null,new TestWebControl("pet"),NonAutoPop);
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