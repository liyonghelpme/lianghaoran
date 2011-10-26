class Calldialog extends ContextObject{
    var info;
    var element;
    var dialog;
    var goddes=["丰收之神施展神迹能提升农作物产量","人口之神施展神迹能提升招募人口数量","财富之神施展神迹能提升店铺税收","战争之神施展神迹能提升士兵战斗力"];
    function Calldialog(i){
        contextname = "dialog-build-callgod";
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
        global.popContext(null);
        if(info<0){
            global.popContext(info);
        }
        else{
            global.popContext(info+2400);
        }
    }
    
    function getelement(){
        if(element == null){
            element = node();
            element.addsprite("pic0.png").anchor(50,50).pos(80,120);
            if(info<0){
                element.addlabel("龙巢可以召唤属于你的独特宠物哦！确定召唤龙巢吗？",null,20,FONT_NORMAL,220,0,ALIGN_LEFT).anchor(50,50).pos(268,120).color(0,0,0,100);
            }
            else{
                element.addlabel(substring(global.getname("god",info),0,12)+"能施展神迹。确定要召唤"+substring(global.getname("god",info),0,12)+"吗？",null,20,FONT_NORMAL,220,0,ALIGN_LEFT).anchor(50,50).pos(268,120).color(0,0,0,100);
                //element.addlabel("注："+goddes[info],null,18,FONT_NORMAL,216,0,ALIGN_LEFT).anchor(50,50).pos(268,155).color(0,0,0,100);
            }
        }
        return element;
    }
    
    function paintNode(){
        dialog = new Simpledialog(1,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.usedefaultbutton(2,["召唤","取消"]);
    }
}