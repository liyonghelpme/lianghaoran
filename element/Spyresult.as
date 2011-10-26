class Spyresult extends ContextObject{
    var data;
    var dialog;
    var element;
    var eid;
    var mode;
    const textpos=[[129,121],[318,121],[141,212],[141,241],[334,212]];
    function Spyresult(d,g,m){
        contextname = "dialog-battle-spy-result";
        contextNode = null;
        data = d;
        element = null;
        eid = g;
        mode = m;
    }
    
    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        contextNode = null;
        element.removefromparent();
        element=null;
        if(mode<3){
            global.soldiers[2+mode]=global.soldiers[2+mode]-data.get("dead");
        }
    }
    
    function getelement(){
        if(element == null){
            element = node();
            element.addsprite("spyresultback.jpg").anchor(50,0).pos(219,10);
            element.addlabel("你损失了"+str(data.get("dead",0))+"个侦察兵，获取了"+global.context[0].warpage.userdict.get(eid)[4]+"的情报：",null,24,FONT_NORMAL,393,0,ALIGN_LEFT).pos(23,25).color(0,0,0,100);
            var spyres = [data.get("won"),data.get("total"),data.get("power"),data.get("allynum"),data.get("citydefence")];
            var spyitems = ["获胜次数：","参战次数：","士兵战斗力：","盟友战斗力：","城堡防御力："];
            var spypos=[[33,123],[223,123],[33,214],[33,245],[223,214]];
            for(var i=0;i<5;i++){
                var tl=element.addlabel(spyitems[i],null,18).pos(spypos[i]).color(0,0,0,100);
                tl.prepare();
                var value = spyres[i];
                if(value!=null){
                    element.addlabel(str(value),null,18).pos(spypos[i][0]+tl.size()[0],spypos[i][1]).color(0,0,0,100);
                }
                else{
                    element.addlabel("未侦察到",null,18).pos(spypos[i][0]+tl.size()[0],spypos[i][1]).color(30,30,30,100);
                }
            }
        }
        return element;
    }
    
    function paintNode(){
        dialog = new Simpledialog(0,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.usedefaultbutton(2,["出兵攻打","返回"]);
    }
    
    function excute(p){
        global.popContext(null);
        global.pushContext(null,new AttackControl(eid),NonAutoPop);
    }
}
