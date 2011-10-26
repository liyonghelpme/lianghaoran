class MedalControl extends ContextObject{
    var pageposmax;
    var pagepos;
    var objsmax;
    var medals;
    var clevels;
    var lasttime;
    var lastx;
    var flagmove;
    var cardcontext = [12,15,14,13,0,1,2,3,4,5,6,7,8,9,10,11];
    function MedalControl(m){
        medals=m;
        contextname ="element-medal-monster";
        contextNode = null;
    }
    function paintNode(){
        if(medals[12]<0){
            cardcontext.remove(12);
        }
        objsmax=len(cardcontext);
        clevels = new Array(0);
        for(var i=0;i<objsmax;i++){
            clevels.append(0);
        }
        pageposmax = 1174-(objsmax+1)/2*150;
        if(pageposmax > 400) pageposmax = 400;
        pagepos = 400;
        contextNode = node().anchor(50,50).pos(pagepos,240).size(800,480);
        for(i=0;i<objsmax;i++){
            var obj = contextNode.addsprite("medaltabback1.png").pos(26+i/2*150,119+(i%2)*162);
            var clevel;
            var ci = cardcontext[i];
            if(ci!=12){
                if(ci<12){
                    var clevelnum=cardlevelnum;
                }
                else{
                    clevelnum = allcardlevelnum[ci-13];
                }
                if(ci>13&&ci<18){
                    clevel = medals[ci];
                }
                else{
                    for(clevel=0;clevel<5&&medals[ci]>=clevelnum[clevel];clevel++){
                    }
                } 
            }
            else{
                clevel = 6;
            }
            obj.addlabel(cardprename[ci]+cardlevelname[clevel],null,18).anchor(50,0).pos(62,10).color(23,20,3,100);
            if(ci<6){
                var m=sprite("monster_"+str(ci*3+clevel/2)+"_1.png").anchor(0,100).pos(29,128);
                m.prepare();
                var ms = m.size();
                m.size(70,ms[1]*70/ms[0]);
            }
            else if(ci<12){
                m=sprite("monster_"+str(ci*3+clevel/2)+"_1.png").anchor(50,100).pos(62,128);
            }
            if(clevel==0){
                obj.texture("medaltabback0.png");
                if(ci<12){
                    m.color(40,40,40,100);
                    obj.add(m);
                }
                else{
                    obj.addsprite("medalcard"+str(ci-13)+"_1.png").pos(3,32).color(40,40,40,100);
                }
            }
            else{
                if(ci<12){
                    obj.addsprite("medaltab"+str(clevel)+".png").pos(3,32);
                    obj.add(m);
                }
                else if(ci!=12){
                    obj.addsprite("medalcard"+str(ci-13)+"_"+str(clevel)+".png").pos(3,32);
                }
                else{
                    obj.addsprite("medalnob.png").pos(3,32);
                    obj.addsprite("nobi"+str(medals[ci]%100)+".png").anchor(50,0).pos(62,47).size(50,50);
                    obj.addlabel(NOBNAME[medals[ci]%100],null,18).anchor(50,0).pos(62,105).color(23,20,3,100);
                }
            }
            if(clevel<5||(ci==12&&medals[ci]%100<18)){
                obj.setevent(EVENT_TOUCH,objselect,ci);
                obj.setevent(EVENT_MOVE,objselect,ci);
                obj.setevent(EVENT_UNTOUCH,objselect,ci);
            }
            clevels[ci]=clevel;
        }
    }
    

    function objselect(n,e,param,x,y){
        if(global.currentLevel <= 1){
            if(e == EVENT_TOUCH){
                lasttime = time();
                lastx = n.pos()[0]+x+contextNode.pos()[0]-400;
                flagmove = 0;
                global.context[1].nodemove(n,EVENT_TOUCH,0,lastx,240);
                return 1;
            }
            else if(e== EVENT_MOVE){
                if(flagmove == 0){
                    if(x<0 || y<0 || x>n.size()[0] || x>n.size()[1])
                        flagmove =1;
                    else if(time()-lasttime > 1000)
                        flagmove =1;
                    return 0;
                }
                else{
                    lastx = n.pos()[0]+x+contextNode.pos()[0]-400;
                    global.context[1].nodemove(n,EVENT_MOVE,0,lastx,240);
                }
            }
            else if(e == EVENT_UNTOUCH){
                if(flagmove == 0){
                    var pn="你";
                    if(global.context[0].cuid!=global.userid){
                        pn = "Ta";
                    }
                    if(param==12){
                        global.pushContext(null,new Warningdialog([global.getFormatString(18,["[WHO]",pn,"[NUM]",str(medals[param]/100),"[CARD]",NOBNAME[medals[param]%100+1]]),null,1]),NonAutoPop);
                        return 0;
                    }
                    else if(param>13&&param<18){
                        if(param==14)
                            global.pushContext(null,new Warningdialog([global.getFormatString(17,["[WHO]",pn,"[TYPE]","粮食","[NUM]",str(allcardlevelnum[1][clevels[param]])]),null,6]),NonAutoPop);
                        else if(param==15)
                            global.pushContext(null,new Warningdialog([global.getFormatString(17,["[WHO]",pn,"[TYPE]","银币","[NUM]",str(allcardlevelnum[2][clevels[param]])]),null,6]),NonAutoPop);
                        return 0;
                    }
                    if(param<12){
                        var clevelnum = cardlevelnum;
                    }
                    else{
                        clevelnum = allcardlevelnum[param-13];
                    }
                    global.pushContext(null,new Warningdialog([global.getMedalString(param,pn,clevelnum[clevels[param]]-medals[param],clevels[param]+1),null,1]),NonAutoPop);
                }
                else{
                    choosepage();
                }
            }
        }
    }

    function choosepage(){
        pagepos = contextNode.pos()[0];
        if(pagepos > 400) pagepos = 400;
        else if(pagepos < pageposmax) pagepos = pageposmax;
        contextNode.addaction(moveto(300,pagepos,240));
    }
}

class Medaldialog extends ContextObject{
    var medalcontrol;
    var flagmove;
    var lastx;
    var medals;
    function Medaldialog(m){
        medals = m;
        contextname = "dialog-medal";
        contextNode = null;
        flagmove= 0;
        lastx=0;
    }

    function paintNode(){
        contextNode = sprite("dialogback_build.png").anchor(50,50).pos(400,240);
        contextNode.addsprite("builddialogclose.png").anchor(100,0).pos(796,4).size(48,50).setevent(EVENT_TOUCH,closedialog);
        contextNode.setevent(EVENT_TOUCH,nodemove);
        contextNode.setevent(EVENT_MOVE,nodemove);
        contextNode.setevent(EVENT_UNTOUCH,nodemove);
        
        contextNode.addsprite("medaltitle.jpg").anchor(50,0).pos(400,25);
        contextNode.add(sprite("dialogback_left.png",ARGB_8888).pos(0,97),1);
        contextNode.add(sprite("dialogback_right.png",ARGB_8888).anchor(100,0).pos(800,97),1);
        medalcontrol = new MedalControl(medals);
        medalcontrol.init(medalcontrol,global);
        contextNode.add(medalcontrol.getNode());
    }

    function nodemove(n,e,param,x,y){
        if(e == EVENT_TOUCH){
            if(y<66){
                flagmove=0;
                return 0;
            }
            flagmove= 1;
            lastx = x;
            return 1;
        }
        else if(e == EVENT_MOVE){
            if(flagmove == 0)
                return 0;
            medalcontrol.getNode().addaction(imoveby(x-lastx,0));
            lastx = x;
        }
        else if(e== EVENT_UNTOUCH){
            if(flagmove == 0)
                return 0;
            medalcontrol.choosepage();
        }
        return 1;
    }

    function closedialog(node,event){
        global.popContext(null);
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}