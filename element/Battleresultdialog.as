class Battleresultdialog extends ContextObject{
    var dialog;
    var element;
    function Battleresultdialog(){
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
            element.addsprite("battleresultback.jpg").anchor(50,0).pos(219,10);
            element.addlabel("",null,30).anchor(50,50).pos(219,55);
            element.addlabel("你战胜了",null,30).anchor(50,50).pos(219,67);
        }
        return element;
    }
    
    function paintNode(){
        dialog = new Simpledialog(0,self);
        dialog.self = dialog;
        dialog.global = global;
        dialog.setconfig(0,2,"攻打！");
        contextNode = dialog.getNode();
    }
    
    function excute(){
    }
}
