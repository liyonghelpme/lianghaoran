class Devinedialog extends ContextObject{
    var tabs;
    var selecttab;
    var element;
    var buildid;

    const godstr = [
    "农作物产量增加20%","民居招募人口数量增加20%","店铺税收增加20%","士兵战斗力增加5%",
    "农作物产量增加40%","民居招募人口数量增加40%","店铺税收增加40%","士兵战斗力增加10%",
    "农作物产量增加60%","民居招募人口数量增加60%","店铺税收增加60%","士兵战斗力增加15%",
    "农作物产量增加80%","民居招募人口数量增加80%","店铺税收增加80%","士兵战斗力增加20%",
    "农作物产量增加100%","民居招募人口数量增加100%","店铺税收增加100%","士兵战斗力增加25%",
    "访问好友奖励增加5银币","访问好友奖励增加10银币","访问好友奖励增加20银币","访问好友奖励增加30银币","访问好友奖励增加50银币"];
    const timestr = ["持续1小时","持续6小时","持续24小时"];

    function Devinedialog(){
        contextname = "dialog-build-devine";
        contextNode = null;
        element = null;
    }

    function getelement(){
        if(element==null){
            tabs = new Array(3);
            buildid = global.request[global.currentLevel].bid;
            element = node();
            element.addsprite("devineback.jpg").anchor(50,0).pos(219,10);
            element.addlabel("神迹",null,30).anchor(50,50).pos(219,43).color(0,0,0,100);
            element.addlabel("在神迹有效时间内，"+godstr[buildid],null,16).anchor(50,50).pos(219,75).color(0,0,0,100);
            selecttab = -1;
            for(var i=0;i<3;i++){
                tabs[i] = element.addsprite("dialogelement_god_normal.png").pos(37+i*125,110).setevent(EVENT_UNTOUCH,choosetab,i);
                tabs[i].addlabel(timestr[i],null,20).anchor(50,50).pos(57,60).color(0,0,0,100);
                tabs[i].addsprite("caesars_big.png").anchor(50,50).pos(33,130);
                tabs[i].addlabel("x"+str(BLESS_CAESARS[i]),null,20).anchor(0,50).pos(52,130).color(0,0,0,100);
            }
            choosetab(0,0,0);
        }
        return element;
    }

    function paintNode(){
        var dialog = new Simpledialog(0,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.usedefaultbutton(2,["施展","取消"]);
    }

    function choosetab(n,e,p){
        if(selecttab != p){
            if(selecttab>=0)
                tabs[selecttab].texture("dialogelement_god_normal.png");
            tabs[p].texture("dialogelement_god_chosen.png");
            selecttab = p;
        }
    }

    function excute(p){
        global.popContext(selecttab);
    }
    
    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}