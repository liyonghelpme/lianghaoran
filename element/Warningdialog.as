class Warningdialog extends ContextObject{
    var info;
    var element;
    var dialog;
    function Warningdialog(i){
        contextname = "dialog-warning";
        contextNode = null;
        element = null;
        info = i;
    }
    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        contextNode = null;
        element.removefromparent();
        element=null;
    }
    
    function excute(p){
        global.popContext(info[1]);
    }
    
    function gotohelp(n,e,p){
        global.pushContext(null,new TestWebControl(p),NonAutoPop);
    }
    
    function getelement(){
        if(element == null){
            element = node();
            if(type(info)==2){
                element.addsprite("pic"+str(info[2])+".jpg").anchor(50,50).pos(80,120);
                if(info[1]>=0){
                    element.addlabel(info[0],null,24,FONT_NORMAL,240,0,ALIGN_LEFT).anchor(50,50).pos(268,105).color(0,0,0,100);
                    dialog.usedefaultbutton(2,["确定","取消"]);
                }
                else if(info[1]==-1){
                    element.addlabel(info[0],null,24,FONT_NORMAL,216,0,ALIGN_LEFT).anchor(0,50).pos(148,105).color(0,0,0,100);
                    element.addsprite("dialogelement_help.png").anchor(0,0).pos(248,118).scale(150).setevent(EVENT_UNTOUCH,gotohelp,"gift");
                    dialog.usedefaultbutton(1,"确定");
                }
                else if(info[1]==null){
                    element.addlabel(info[0],null,24,FONT_NORMAL,240,0,ALIGN_LEFT).anchor(50,50).pos(268,105).color(0,0,0,100);
                    dialog.usedefaultbutton(1,"确定");
                }
            }
            else if(info.get("ok")==0){
                element.addsprite("pic6.jpg").anchor(50,50).pos(80,120);
                var infos = info.keys();
                infos.remove("ok");
                var basey = 53+(3-len(infos))*14;
                for(var i=0;i<len(infos);i++){
                    element.addlabel("你还缺少",null,24).pos(148,basey+28*i).color(0,0,0,100);
                    element.addlabel(str(info.get(infos[i]))+infos[i],null,24).pos(244,basey+28*i).color(100,0,0,100);
                }
                if(infos.index("人口上限")!=-1){
                    element.addsprite("dialogelement_help.png").pos(148,basey+28*i).scale(150).setevent(EVENT_UNTOUCH,gotohelp,"personmax");
                }
                dialog.usedefaultbutton(1,"确定");
            }
            else if(info.get("ok")==-1){
                element.addsprite("pic4.jpg").anchor(50,50).pos(80,120);
                element.addlabel("你的特殊物品不足",null,24,FONT_NORMAL,240,0,ALIGN_LEFT).anchor(0,50).pos(148,105).color(0,0,0,100);
                element.addsprite("dialogelement_help.png").anchor(50,50).pos(365,105).scale(150).setevent(EVENT_UNTOUCH,gotohelp,"special");
                dialog.usedefaultbutton(1,"确定");
            }
        }
        return element;
    }
    
    function paintNode(){
        dialog = new Simpledialog(1,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
    }
}