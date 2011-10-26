import global.GlobalController;
class ContextObject{
    var global;
    var contextLevel;
    var contextNode;
    var contextname;
    var self;
    function ContextObject(){
        contextNode = null;
    }
    function getNode(){
        if(contextNode == null){
            self.paintNode();
        }
        return contextNode;
    }
    function init(s,g){
        self = s;
        global = g;
    }
    function response(p){
        if(p!=null){
            self.reloadNode(p);
        }
    }
}