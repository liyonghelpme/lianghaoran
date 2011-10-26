class Cardget extends ContextObject{
    var element;
    var cardid;
    var cardlevel;
    function Cardget(c,l){
        cardid = c;
        cardlevel=l;
        contextname = "dialog-card-monster";
        contextNode = null;
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
            var mb=element.addsprite("medaltabback1.png").anchor(50,50).pos(80,120);
            mb.addlabel(cardprename[cardid]+cardlevelname[cardlevel],null,16).anchor(50,0).pos(62,10).color(0,0,0,100);
            mb.addsprite("medaltab"+str(cardlevel)+".png").pos(3,32);
            if(cardid<6){
                var m=sprite("monster_"+str(cardid*3+cardlevel/2)+"_1.png").anchor(0,100).pos(29,128);
                m.prepare();
                var ms = m.size();
                m.size(70,ms[1]*70/ms[0]);
            }
            else if(cardid<12){
                m=sprite("monster_"+str(cardid*3+cardlevel/2)+"_1.png").anchor(50,100).pos(62,128);
            }
            else{
                m=sprite("medalcard"+str(cardid-13)+"_"+str(cardlevel)+".png").pos(3,32);
            }
            mb.add(m);
            var endstr = "!";
            if(cardid>13&&cardid<18){
                if(cardlevel<5){
                    endstr = "。赶快升级到紫金级别吧，那么你能无限次免费使用一键操作功能！";
                }
                else{
                    endstr = "。你已经能够无限次免费使用一键操作功能!";
                }
            }
            element.addlabel("恭喜你获得了"+cardprename[cardid]+cardlevelname[cardlevel]+endstr,null,24,FONT_NORMAL,240,0,ALIGN_LEFT).anchor(50,50).pos(268,105).color(0,0,0,100);
        }
        return element;
    }
    
    function excute(p){
        if(p==1){
            global.popContext(null);
            global.http.addrequest(0,"share",["uid"],[global.userid],global.context[0],"share");
            ppy_postnewsfeed(ppy_username()+"获得了"+cardprename[cardid]+cardlevelname[cardlevel]+"，赶快加入与"+ppy_username()+"一起打造属于自己的奇迹帝国吧！","http://getmugua.com");
        }
    }
    
    function paintNode(){
        var dialog = new Simpledialog(1,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.usedefaultbutton(2,["分享","确定"]);
    }
}