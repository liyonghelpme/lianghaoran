class ClockObject extends ContextObject{
    var m;
    function ClockObject(){
        contextname = "time-normal";
        contextNode = null;
    }

    function paintNode(){
        contextNode = sprite("clockback.png",ARGB_8888).anchor(50,50).pos(400,240);
        m = contextNode.addsprite("clock1.png").anchor(50,50).pos(110,125);
        m.addaction(repeat(animate(2000,"clock1.jpg","clock2.jpg","clock3.jpg","clock4.jpg","clock5.jpg","clock6.jpg","clock7.jpg","clock8.jpg")));
    }

    function deleteContext(){
        m.addaction(stop());
        contextNode.removefromparent();
    }
}