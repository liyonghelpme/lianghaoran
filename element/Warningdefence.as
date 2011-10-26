class Warningdefence extends ContextObject{
    var data;
    var dialog;
    var timelabel;
    var element;
    function Warningdefence(m){
        contextname = "dialog-battle-warning";
        contextNode = null;
        data = m;
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
            element.addsprite("defenceback.jpg").anchor(50,50).pos(219,191);
            global.addtext(element,23,95,"<g>"+data[0]+"<g>+已经派出大军攻打你的城市",20);
            global.addtext(element,35,243,"*注:敌人战争之神施展神迹也会提高一定比例+<b>     <b>的战斗力",20);
            element.addlabel("*如何提高防御力？",null,20).pos(28,323).color(0,0,0,100);
            element.addsprite("help.png").anchor(50,50).pos(235,335).setevent(EVENT_UNTOUCH,null);
            timelabel = element.addlabel("",null,20).anchor(0,50).pos(197,174).color(0,0,0,100);
            element.addlabel(str(data[1]),null,20).anchor(0,50).pos(197,205).color(0,0,0,100);
        }
        return element;
    }
    
    function paintNode(){
        dialog = new Simpledialog(0,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.setbutton(1,354,335,"返回",null);
    }
}
