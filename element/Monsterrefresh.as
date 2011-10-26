class Monsterrefresh extends ContextObject{
    var element;
    var maxlevel;
    function Monsterrefresh(m){
        contextname = "dialog-monster-refresh";
        contextNode = null;
        element = null;
        maxlevel =m;
    }
    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        contextNode = null;
        element.removefromparent();
        element=null;
    }
    
    function getelement(){
        if(element == null){
            element = node();
            var d=element.addsprite("monsterrefresh.jpg").pos(20,35);
            d.addlabel("哈哈哈，"+global.user.getValue("cityname")+"领主，献出你的粮食吧，否则你们将永不得安宁！",null,20,FONT_NORMAL,200,0,ALIGN_LEFT).pos(15,17).color(0,0,0,100);
            
            element.addsprite("monster_"+str(maxlevel)+"_1.png").pos(280,65).scale(110);
        }
        return element;
    }
    
    function paintNode(){
        var dialog = new Simpledialog(1,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.usedefaultbutton(1,"确定");
    }
}