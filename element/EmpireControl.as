class EmpireControl extends ContextObject{
    var index;
    var tabs;
    var element;
    function EmpireControl(){
        contextname = "dialog-castleinfo";
        contextNode = null;
    }

    function paintNode(){
        index = -1;
        element = sprite();
        tabs = new Array(3);
        contextNode = sprite("dialogback_empire.png").anchor(50,50).pos(400,240);
        contextNode.addlabel(global.user.getValue("cityname"),null,30).anchor(0,50).pos(196,28);
        contextNode.addlabel(str(global.user.getValue("level")),null,16,FONT_BOLD).anchor(50,50).pos(164,36).color(0,0,0,100);
        contextNode.addsprite("builddialogclose.png").anchor(100,0).pos(508,4).setevent(EVENT_UNTOUCH,closedialog);

        tabs[0] = contextNode.addsprite("dialogelement_state1.png").setevent(EVENT_UNTOUCH,choosetab,0);
        for(var i=0;i<5;i++)
            tabs[0].addsprite("dialogelement_star"+str((4-i)/4)+".png").anchor(50,50).pos(176+32*i,28);
        tabs[1] = contextNode.addsprite("dialogelement_resource0.png").setevent(EVENT_UNTOUCH,choosetab,1);
        tabs[2] = contextNode.addsprite("dialogelement_military0.png").setevent(EVENT_UNTOUCH,choosetab,2);
        choosetab(0,0,0);
    }

    function choosetab(n,e,p){
        if(index!=p){
            var name = ["dialogelement_state","dialogelement_resource","dialogelement_military"];
            for(var i=0;i<3;i++){
                var flag = 0;
                var flag1 = 0;
                if(i==p){
                    flag=1;
                    if(i==2||(i==0&&global.user.getValue("nobility")>=0)){
                        flag=2;
                    }
                }
                else if(i>p) flag1 =1;
                
                tabs[i].texture(name[i]+str(flag)+".png",UPDATE_SIZE).pos(16,59*(i+1)+flag1*228-3);
            }
            index = p;
            element.removefromparent();
            element = getelement(p);
            tabs[p].add(element);
        }
    }
    
    function adddefence(n,e,p,x,y){
        var ns = n.size();
        if(x>0&&x<ns[0]&&y>0&&y<ns[1]){
            global.pushContext(null,new Adddefencedialog(),NonAutoPop);
        }
    }
    
    function getelement(p){
        element = node();
        if(p==0){
            var offy = 74;
            if(global.user.getValue("nobility")<0){
                offy=56;
            }
            else{
                var cdl=element.addlabel(str(global.user.getValue("citydefence")),null,20).anchor(0,50).pos(200,offy).color(0,0,0,100);
                global.user.initText("citydefence",cdl);
                element.addsprite("adddefence2.png").pos(312,offy-15).setevent(EVENT_UNTOUCH,adddefence);
            }
            element.addlabel(str(len(global.ppyuserdict)-2),null,20).anchor(0,50).pos(180,offy+36).color(0,0,0,100);
            element.addlabel(str(global.rect)+"x"+str(global.rect),null,20).anchor(0,50).pos(200,offy+72).color(0,0,0,100);
            element.addlabel(str(global.user.getValue("personmax")),null,20).anchor(0,50).pos(200,offy+107).color(0,0,0,100);
            element.addlabel(str(global.user.getValue("labor"))+"/"+str(global.user.getValue("person")),null,20).anchor(0,50).pos(255,offy+142).color(0,0,0,100);
            element.addlabel(str(global.user.getValue("person")-global.user.getValue("labor")),null,20).anchor(0,50).pos(200,offy+175).color(0,0,0,100);
        }
        else if(p==1){
            element.addsprite("food.png").anchor(50,50).pos(42,77).size(29,32);
            element.addlabel(str(global.user.getValue("food")),null,20).anchor(0,50).pos(60,77).color(0,0,0,100);
            element.addsprite("wood.png").anchor(50,50).pos(190,77).size(29,25);
            element.addlabel(str(global.user.getValue("wood")),null,20).anchor(0,50).pos(208,77).color(0,0,0,100);
            element.addsprite("stone.png").anchor(50,50).pos(338,77).size(33,24);
            element.addlabel(str(global.user.getValue("stone")),null,20).anchor(0,50).pos(356,77).color(0,0,0,100);
            for(var i=0;i<12;i++){
                element.addsprite("gift"+str(i+1)+".png").anchor(50,50).pos(47+113*(i%4),135+50*(i/4)).scale(50);
                element.addlabel(str(global.special[i]),null,20).anchor(0,50).pos(71+113*(i%4),135+50*(i/4)).color(0,0,0,100);
            }
        }
        else if(p==2){
            element.addlabel(str(global.soldiers[0]+global.soldiers[1]),null,20).anchor(0,50).pos(133,113).color(0,0,0,100);
            for(i=0;i<2;i++){
                element.addlabel(str(global.soldiers[i]),null,20).anchor(0,50).pos(89+192*i,161).color(0,0,0,100);
            }
            for(i=2;i<5;i++){
                element.addlabel(str(global.soldiers[i]),null,20).anchor(0,50).pos(150*i-227,236).color(0,0,0,100);
            }
        }
        return element;
    }
    function closedialog(n,e){
        global.popContext(null);
    }

    function deleteContext(){
        contextNode.removefromparent();
    }
}