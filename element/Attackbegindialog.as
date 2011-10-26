class Attackbegindialog extends ContextObject{
    var endtime;
    var timelabel;
    var timeisend;
    var element;
    function Attackbegindialog(t){
        contextname = "dialog-battle-attackover";
        endtime = t;
        contextNode = null;
        element = null;
        timeisend = 0;
    }
    
    function timerefresh(){
        var lefttime =endtime-time()/1000;
        timelabel.text(global.gettimestr(lefttime));
    }
    
    function timeend(){
        global.popContext(null);
    }

    function getelement(){
        if(element == null){
            element = node();
            element.addsprite("attackbeginelement.png").anchor(100,0).pos(394,10);
            element.addlabel("你的军队已经出征啦！",null,24).pos(32,35).color(0,0,0,100);
            element.addlabel("注：与敌方战斗时，主帅在线会增加士兵战斗力!",null,20,FONT_NORMAL,344,0,ALIGN_LEFT).pos(30,159).color(0,0,0,100);
            timelabel=element.addlabel("",null,30).anchor(50,50).pos(202,127).color(0,0,0,100);
            global.timer.addlistener(endtime,self);
        }
        return element;
    }

    function paintNode(){
        var dialog = new Simpledialog(1,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.usedefaultbutton(1,"确定");
    }
    
    function deleteContext(){
        timeisend = 1;
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}