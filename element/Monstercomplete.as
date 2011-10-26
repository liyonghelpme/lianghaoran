class Monstercomplete extends ContextObject{
    var element;
    var power;
    var exp;
    var money;
    function Monstercomplete(p){
        contextname = "dialog-monster-complete";
        contextNode = null;
        element = null;
        power = p;
    }
    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        contextNode = null;
        element.removefromparent();
        element=null;
        global.user.changeValueAnimate2(global.context[0].moneyb,"money",money,-8);
        global.user.changeValueAnimate2(global.context[0].moneyb,"exp",exp,-8);
    }
    
    function excute(p){
        global.popContext(null);
        if(p==1){
            global.http.addrequest(0,"share",["uid"],[global.userid],global.context[0],"share");
            ppy_postnewsfeed(ppy_username()+"消灭了所有怪物保卫了领地和财产安全，赶快加入与"+ppy_username()+"一起打造属于自己的奇迹帝国吧！","http://getmugua.com");
        }
    }
    
    function getelement(){
        if(element == null){
            element = node();
            var l = global.user.getValue("level");
            if(l<9){
                exp = (power+3)/4;
                money=(power+1)/2*30;
            }
            else if(l<15){
                exp = (power*2+4)/5;
                money=(power*3+4)/5*30;
            }
            else{
                exp = (power+1)/2;
                money=(power*13+19)/20*30;
            }
            var d=element.addsprite("monstercomplete.jpg").pos(10,10);
            element.addsprite("money_big.png").anchor(50,50).pos(137,229).size(32,32);
            element.addlabel(str(money),null,30).anchor(0,50).pos(155,229).color(0,0,0,100);
            element.addsprite("exp.png").anchor(50,50).pos(265,229);
            element.addlabel(str(exp),null,30).anchor(0,50).pos(309,229).color(0,0,0,100);
        }
        return element;
    }
    
    function paintNode(){
        var dialog = new Simpledialog(0,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.usedefaultbutton(2,["分享","返回"]);
    }
}