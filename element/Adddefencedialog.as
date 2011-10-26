class Adddefencedialog extends ContextObject{
    var element;
    var costtype;
    function Adddefencedialog(){
        contextname = "dialog-adddefence";
        contextNode = null;
        element = null;
    }

    function paintNode(){
        var dialog = new Simpledialog(0,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.settitle("adddefencetitle.png");
        dialog.setclosebutton();
        dialog.setbutton(1,336,256,"普通增加",1);
        dialog.setbutton(4,336,331,"快速增加",0);
    }
    
    var defencenum;
    var defencenumlabel;
    var defencemax;
    var cmlabel;
    var cflabel;
    var cclabel;
    function getelement(){
        if(element == null){
            element = node();
            var tmp=element.addlabel("你所选择要增加的防御力：",null,20).pos(44,53).color(0,0,0,100);
            tmp.prepare();
            defencenumlabel = element.addlabel("0",null,20).pos(50+tmp.size()[0],53).color(0,0,0,100);
            var maxlist=[100,300,500,700,1000,3000,5000];
            defencemax=maxlist[global.user.getValue("nobility")/3];
            defencenum = 0;
            element.addlabel("0",null,16).pos(60,95).color(0,0,0,100);
            element.addlabel(str(defencemax),null,16).pos(350,95).color(0,0,0,100);
            var mb = element.addsprite("moveback.png").pos(42,117).size(355,32);
            mb.setevent(EVENT_TOUCH,csnum);
            mb.setevent(EVENT_MOVE,csnum);
            mb.add(sprite("moveblock.png").anchor(50,50).pos(79,16),1,0);
            element.addsprite("adddefenceboard.jpg").pos(21,168);
            element.addsprite("money_big.png").pos(78,204);
            cmlabel = element.addlabel("0",null,18).pos(120,212).color(0,0,0,100);
            element.addsprite("flyfood.png").size(42,30).pos(74,245);
            cflabel = element.addlabel("0",null,18).pos(120,251).color(0,0,0,100);
            element.addsprite("caesars_big.png").pos(78,317);
            cclabel = element.addlabel("0",null,18).pos(120,324).color(0,0,0,100);
            
        }
        return element;
    }

    function csnum(n,e,p,x){
        var move = n.get(0);
        if(x>295) x = 295;
        else if(x<60) x = 60;
        var po = move.pos();
        move.pos(x,po[1]);
        defencenum = defencemax*(x-60)/235;
        defencenumlabel.text(str(defencenum));
        cmlabel.text(str(defencenum*100));
        cflabel.text(str(defencenum*5));
        cclabel.text(str((defencenum+99)/100));
        if(defencenum == 0){
            contextNode.get(0).texture("boxbutton2.png");
            contextNode.get(1).texture("boxbutton2.png");
        }
        else{
            contextNode.get(0).texture("boxbutton1.png");
            contextNode.get(1).texture("boxbutton4.png");
        }
    }
    function excute(p){
        if(defencenum==0){
            return 0;
        }
        costtype = p;
        var cost = dict();
        if(p==0){
            cost.update("caesars",(defencenum+99)/100);
        }
        else{
            cost.update("money",defencenum*100);
            cost.update("food",defencenum*5);
        }
        if(global.user.testCost(cost)!=0){
            global.popContext(null);
            global.http.addrequest(1,"adddefence",["uid","defencenum","type"],[global.userid,defencenum,p],self,"adddefence");
        }
    }
    
    function useaction(p,rc,c){
        if(p=="adddefence"){
            if(json_loads(c).get("id",1)!=0){
                global.user.changeValue("citydefence",defencenum);
                if(global.wartask.wartasktype==3){
                    global.wartask.incwartaskstep(defencenum);
                }
                if(costtype==0){
                    global.user.changeValueAnimate2(global.context[0].moneyb,"caesars",-(defencenum+99)/100,-6);
                }
                else{
                    global.user.changeValueAnimate2(global.context[0].moneyb,"money",-defencenum*100,-6);
                    global.user.changeValueAnimate2(global.context[0].ub,"food",-defencenum*5,-6);
                }
            }
        }
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}