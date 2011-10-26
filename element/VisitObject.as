class VisitObject extends ContextObject{
    var s;
    function VisitObject(){
        contextname = "time-visit";
        contextNode = null;
    }

    function paintNode(){
        contextNode = sprite("visitback.png").anchor(50,50).pos(400,240);
        s = contextNode.addsprite("visit1.jpg").anchor(50,50).pos(262,141);
        s.addaction(repeat(animate(2000,"visit1.jpg","visit2.jpg","visit3.jpg","visit4.jpg","visit5.jpg","visit6.jpg","visit7.jpg","visit8.jpg")));
    }

    function deleteContext(){
        s.addaction(stop());
        contextNode.removefromparent();
    }
}