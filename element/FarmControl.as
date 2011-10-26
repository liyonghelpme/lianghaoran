import element.QuickControl;
import element.PlantControl;

class FarmControl extends ContextObject{
    var farm;
    var timelabel;
    function FarmControl(f){
        contextNode = null;
        farm = f;
        timelabel = null;
    }

    function paintNode(){
        var posi = farm.getNode().pos();
        posi[1] = posi[1] - 30;
        if(posi[0] < 150) posi[0] = 150;
        else if(posi[0] > 2250) posi[0] = 2250;
        if(posi[1] < 150) posi[1] = 150;
        else if(posi[1] > 1375) posi[1] = 1375;
        var tpos = farm.getNode().parent().node2world(posi[0],posi[1]);
        var toff = [0,0];
        if(tpos[0] < 150)
            toff[0] = 150-tpos[0];
        else if(tpos[0] > 650)
            toff[0] = 650-tpos[0];

        if(tpos[1] < 150)
            toff[1] = 150-tpos[1];
        else if(tpos[1] > 355)
            toff[1] = 355-tpos[1];

        global.context[0].nodeMove(toff[0],toff[1]);
        contextNode = sprite("circle.png").anchor(50,50).pos(tpos[0]+toff[0],tpos[1]+toff[1]).size(250,250);
        if(farm.state == 0){
            contextNode.addsprite("circleButton.png").anchor(50,50).pos(125,0);
            contextNode.addsprite("plantButton.png").anchor(50,50).pos(125,0).setevent(EVENT_TOUCH,beginPlant);
        }
        else if(farm.state < 4){
            contextNode.addsprite("circleButton.png").anchor(50,50).pos(125,0);
            contextNode.addsprite("quickButton.png").anchor(50,50).pos(125,0).setevent(EVENT_TOUCH,beginQuick);
            contextNode.addsprite("plant"+str(farm.plantid)+".png").anchor(50,90).pos(125,125).size(100,100);
            timelabel = contextNode.addlabel("",null,40).anchor(50,-10).pos(125,125);
            timelabel.addaction(repeat(callfunc(updatetime),delaytime(1000)));
        }
trace("paint OVER");
    }

    function updatetime(){
        var lefttime = farm.lefttime;
        timelabel.text(global.gettimestr(lefttime));
        if(lefttime == 0){
            global.popContext(null);
        }
    }

    function beginPlant(node,event){
        global.popContext(null);
        global.pushContext(farm,new PlantControl(),NonAutoPop);
    }

    function beginQuick(node,event){
        global.popContext(null);
        global.pushContext(farm,new QuickControl(),NonAutoPop);
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        if(timelabel!=null){
            timelabel.addaction(stop());
            timelabel.removefromparent();
        }
    }
}