class Refreshdialog extends ContextObject{
    var element;
    function Refreshdialog(){
        contextname = "dialog-refresh";
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
    
    function excute(p){
        global.http.addrequest(1,"datarefresh",["uid"],[global.userid],global.request[contextLevel],"datarefresh");
        global.popContext(null);
    }
    
    function getelement(){
        if(element == null){
            element = node();
            element.addsprite("pic4.jpg").anchor(50,50).pos(80,120);
            element.addlabel("因为网络问题，导致了数据异常，请刷新数据",null,24,FONT_NORMAL,240,0,ALIGN_LEFT).anchor(50,50).pos(268,105).color(0,0,0,100);
        }
        return element;
    }
    
    function paintNode(){
        var dialog = new Simpledialog(1,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.usedefaultbutton(2,["刷新","取消"]);
    }
}