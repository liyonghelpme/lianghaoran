class Monsterrobfood extends ContextObject{
    var element;
    var food;
    function Monsterrobfood(f){
        food = f;
        contextname = "dialog-monster-robfood";
        contextNode = null;
        element = null;
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
            element.addsprite("warning.png").anchor(50,50).pos(80,130).scale(150);
            element.addsprite("warningtitle.jpg").anchor(50,50).pos(202,44);
            element.addlabel("你被怪兽抢走了"+str(food)+"粮食！",null,20,FONT_NORMAL,240,0,ALIGN_LEFT).anchor(50,50).pos(270,130).color(0,0,0,100);
        }
        return element;
    }
    
    function excute(p){
        if(p==1){
            global.popContext(null);
            global.user.changeValueAnimate2(global.context[0].ub,"food",-food,-6);
        }
    }
    
    function paintNode(){
        var dialog = new Simpledialog(1,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.setbutton(1,202,228,"确定",1);
    }
}