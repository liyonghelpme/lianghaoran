class SoldierImage{
    var images;
    function SoldierImage(){
        images = dict();
    }
    function getImage(imagestr){
        var t=images.get(imagestr);
        if(t==null){
            t=fetch(imagestr);
            images.update(imagestr,t);
        }
        return t;
    }
}

class Soldier{
    var enemy;
    var image;
    var type;
    var health;
    var atk;
    var defencenum;
    var speed;
    var colorstr;
    var body;
    var posi;
    var mposi;
    var jump;
    var state;
    var state2;
    function Soldier(t,color,im){
        type=t;
        colorstr = color;
        enemy=null;
        image=im;
        jump = 0;
        body=null;
        posi=null;
        mposi=null;
        state =-1;
        state2 =1;
        if(type==1){
            health = 7;
            atk=1;
        }
        else if(type == 2){
            health = 20;
            atk = 3;
        }
    }
    
    function needjump(){
        if(jump>0){
            jump--;
            return 1;
        }
        return 0;
    }
    
    function appear(f){
        body = sprite(image.getImage("animate_"+colorstr+"_left_"+str(type)+"_2.png")).anchor(50,100);
        body.color(0,0,0,0);
        body.prepare();
        jump = 4;
        posi = [0,rand(300)+170];
        if(f==0){
            body.pos(posi).scale(80,80);
            posi[0] = 50;
            body.addaction(spawn(moveby(600,50,0),tintto(600,100,100,100,100),repeat(animate(200,image.getImage("animate_"+colorstr+"_left_"+str(type)+"_1.png"),image.getImage("animate_"+colorstr+"_left_"+str(type)+"_2.png")),3)));
        }
        else if(f==1){
            posi[0] = 750;
            body.pos(posi).scale(-80,80);
            body.addaction(spawn(moveby(600,-50,0),tintto(600,100,100,100,100),repeat(animate(200,image.getImage("animate_"+colorstr+"_left_"+str(type)+"_1.png"),image.getImage("animate_"+colorstr+"_left_"+str(type)+"_2.png")),3)));
        }
        state=2;
    }
    
    function setenemy(e){
        enemy = e;
        if(e!=null){
            e.defencenum++;
        }
    }
    
    function move(p){
        posi = body.pos();
        var off = [p[0]-posi[0],p[1]-posi[1]];
        if(off[0]<-10){
            body.scale(-80,80);
        }
        else if(off[0]>10){
            body.scale(80,80);
        }
        var length = abs(off[0])+abs(off[1]);
        if(length<10){
            length=10;
            mposi = null;
        }
        off = [off[0]*13/length,off[1]*13/length];
        posi = [posi[0]+off[0],posi[1]+off[1]];
        body.pos(posi);
        if(state==2){
            state=1;
        }
        else{
            state=2;
        }
        state2=state-1;
        body.texture(image.getImage("animate_"+colorstr+"_left_"+str(type)+"_"+str(state)+".png"));
    }
    
    function executeAction(){
        posi = body.pos();
        if(enemy==null){
            if(mposi==null){
                mposi=[rand(800),rand(300)+170];
                while(abs(posi[0]-mposi[0])+abs(posi[1]-mposi[1])<100){
                    mposi=[rand(800),rand(300)+170];
                }
            }
            move(mposi);
            return;
        }
        mposi = null;
        var p = enemy.body.pos();
        var off=[p[0]-posi[0],p[1]-posi[1]];
        var length = abs(off[0])+abs(off[1]);
        if(length<70){
            attack();
        }
        else{
            move(p);
        }
    }
    
    function isdead(){
        if(health<=0){
            body.addaction(sequence(stop(),itexture(image.getImage("animate_"+colorstr+"_left_"+str(type)+"_4.png")),tintto(2000,0,0,0,0),callfunc(removeself)));
            return 1;
        }
        return 0;
    }
    
    function attack(){
        state2 = 1-state2;
        if(state2==0){
            return;
        }
        if(state<=2){
            state=3;
            enemy.health = enemy.health-atk;
        }
        else{
            state=2;
        }
        body.texture(image.getImage("animate_"+colorstr+"_left_"+str(type)+"_"+str(state)+".png"));
    }
    
    function win(){
        body.addaction(sequence(stop(),repeat(animate(400,image.getImage("animate_"+colorstr+"_"+str(type)+"_1.png"),image.getImage("animate_"+colorstr+"_"+str(type)+"_2.png")),4)));
    }
}

class WarControl extends ContextObject{
    var datadict;
    var flaganimate;
    var flagresult;
    var element;
    var _self;
    var _enemy;
    var leftuser;
    var rightuser;
    var lblock;
    var rblock;
    function WarControl(dl){
        contextname = "dialog-battle-notice&result";
        contextNode = null;
        flaganimate = 0;
        flagresult = 0;
        datadict = dl;
    }
    
    function formatstringtodata(dl){
        var data = dict();
        var d;
        if(type(dl)==type(""))
            d= dl.split(",");
        else if(type(dl)==type([]))
            d=dl;
        var leftself = int(d[1]);
        if(leftself==1){
            _self = "left";
            _enemy = "right";
            data.update("leftwin",int(d[2]));
        }
        else{
            _self = "right";
            _enemy = "left";
            data.update("leftwin",1-int(d[2]));
        }
        data.update("enemyuid",int(d[0]));
        data.update("leftself",leftself);
        data.update("reward",d[6]);
        data.update("powerlost",int(d[3]));
        data.update(_self+"power",int(d[4]));
        data.update(_enemy+"power",int(d[5]));
        data.update(_self+"ppyid",ppy_userid());
        data.update(_enemy+"ppyid",int(d[7]));
        data.update(_self+"power2",int(d[8])+int(d[9]));
        data.update(_enemy+"power2",int(d[12])+int(d[13]));
        data.update(_self+"name",global.user.getValue("cityname"));
        data.update(_enemy+"name",d[10]);
        data.update(_self+"nob",global.user.getValue("nobility"));
        data.update(_enemy+"nob",int(d[11]));
        data.update(_self+"godpower",int(d[14]));
        data.update(_enemy+"godpower",int(d[15]));
        if(len(d)>=17){
            data.update("defence",int(d[16]));
        }
        else{
            data.update("defence",global.user.getValue("citydefence"));   
        }
        return data;
    }
    
    
    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        contextNode = null;
        element.removefromparent();
        if(flaganimate==2){
            global.system.popmusic();
        }
    }
    
    function excute(p){
        if(flagresult==0){
            flaganimate = p;
            flagresult=1;
            if(datadict.get("leftself")==1&&datadict.get("leftwin")==1&&global.context[0].warpage.inite==1){
                for(var i=len(global.context[0].warpage.atklist)-1;i>=0;i--){
                    if(int(global.context[0].warpage.atklist[i][0])==datadict.get(_enemy+"ppyid")){
                        global.context[0].warpage.atklist.pop(i)[8]=1;
                        break;
                    }
                }
            }
            if(global.context[1].contextname=="page-war"){
                global.context[1].refreshmap(1);
                global.context[1].refreshlist();
            }
            global.popContext(null);
            global.pushContext(null,self,NonAutoPop);
        }
    }

    function setbutton(bt,x,y,n){
        var button = contextNode.addsprite("boxbutton"+str(bt)+".png").anchor(50,50).pos(x,y);
        button.addlabel(n,null,BUTTONFONTSIZE).anchor(50,50).pos(62,19);
        return button;
    }
    function getelement(){
        element = node();
        element.addsprite("pic1.jpg").anchor(50,50).pos(80,120);
        if(flagresult==0){
            if(datadict.get("leftself")==1){
                element.addlabel("你的大军已经抵达"+datadict.get(_enemy+"name")+"领地，战争即将展开！",null,24,FONT_NORMAL,240,0,ALIGN_LEFT).color(0,0,0,100).anchor(50,50).pos(264,124);
            }
            else{
                element.addlabel(datadict.get(_enemy+"name")+"的军队已经兵临城下，你的领地即将遭受攻击！",null,24,FONT_NORMAL,240,0,ALIGN_LEFT).color(0,0,0,100).anchor(50,50).pos(264,124);
            }
        }
        return element;
    }
    
    function gotohelp(n,e,p){
        global.pushContext(null,new TestWebControl(p),NonAutoPop);
    }
    
    function itext(n,p){
        n.get(1).text(p);
    }
    
    function closedialog(n,e,p){
        global.popContext(null);
        if(p==1){
            ppy_postnewsfeed(global.getFormatString(10+2*datadict.get("leftself")+datadict.get("leftwin"),["[USERNAME]",ppy_username(),"[ENAME]",datadict.get(_enemy+"name")]),"http://getmugua.com");
        }
    }
    
    function paintNode(){
                function powernumtolevel(num){
                    if(num>=100000){
                        return 5;
                    }
                    else if(num>=10000){
                        return 4;
                    }
                    else if(num>=1000){
                        return 3;
                    }
                    else if(num>=500){
                        return 2;
                    }
                    else if(num>=100){
                        return 1;
                    }
                    return 0;
                }
        if(flagresult==0){
            datadict = formatstringtodata(datadict);
            var dialog = new Simpledialog(1,self);
            dialog.init(dialog,global);
            contextNode = dialog.getNode();
            dialog.setbutton(1,118,228,"观战",1);
            dialog.setbutton(2,286,228,"跳过",0);
        }
        else if(flagresult==1){
            contextNode = sprite("taskback2.png").anchor(50,50).pos(373,240);
            var winstr = "win";
            if(datadict.get("leftwin") != datadict.get("leftself")){
                winstr = "lose";
            }
            contextNode.addsprite("war"+winstr+"left.jpg").pos(168,19);
            var rwn=contextNode.addsprite("war"+winstr+"element2.jpg").pos(317,19);
            var rwd = datadict.get("reward").split("!");
            var infolabel = contextNode.addlabel(global.getFormatString(2+2*datadict.get("leftself")+datadict.get("leftwin"),["[ENAME]",datadict.get(_enemy+"name")]),null,20,FONT_NORMAL,120,0,ALIGN_LEFT).pos(171,110);
            contextNode.addlabel(global.getStaticString(6),null,20).pos(320,349).color(0,0,0,100);
            contextNode.addsprite("dialogelement_help.png").pos(463,349).scale(130).setevent(EVENT_UNTOUCH,gotohelp,"power");
            var offy=152;
            if(datadict.get("leftwin") == datadict.get("leftself")){
                infolabel.color(76,3,0,100);
                if(rwd[0]!="0"){
                    rwn.addsprite("caesars_big.png").anchor(50,50).pos(89,130).size(32,32);
                    rwn.addlabel(rwd[0],null,24).anchor(0,50).pos(136,130).color(0,0,0,100);
                    offy = 174;
                }
                rwn.addsprite("money_big.png").anchor(50,50).pos(89,offy).size(32,32);
                rwn.addlabel(rwd[1],null,24).anchor(0,50).pos(136,offy).color(0,0,0,100);
            }
            else{
                infolabel.color(0,17,76,100);
                rwn.addsprite("money_big.png").anchor(50,50).pos(89,133).size(32,32);
                rwn.addlabel(rwd[1],null,24).anchor(0,50).pos(136,133).color(0,0,0,100);
            }
                if(datadict.get("leftself")==1){
                    contextNode.addlabel("派出战斗力："+str(datadict.get("powerlost")+datadict.get(_self+"power2")),null,20).pos(343,220).color(0,0,0,100);
                    contextNode.addlabel("损失战斗力：",null,20).pos(343,245).color(0,0,0,100);
                    contextNode.addlabel(str(-datadict.get("powerlost")),null,20).pos(463,245).color(100,0,0,100);
                    contextNode.addlabel("返回战斗力："+str(datadict.get(_self+"power2")),null,20).pos(343,270).color(0,0,0,100);
                }
                else{
                    contextNode.addlabel("留守防御力："+str(datadict.get("defence")+datadict.get("powerlost")+datadict.get(_self+"power2")),null,20).pos(343,220).color(0,0,0,100);
                    contextNode.addlabel("损失防御力：",null,20).pos(343,245).color(0,0,0,100);
                    contextNode.addlabel(str(-datadict.get("powerlost")),null,20).pos(463,245).color(100,0,0,100);
                    contextNode.addlabel("剩余防御力："+str(datadict.get("defence")+datadict.get(_self+"power2")),null,20).pos(343,270).color(0,0,0,100);
                    if(datadict.get("leftwin")==1){
                        contextNode.addlabel("损失银币：",null,20).pos(359,309).color(0,0,0,100);
                        contextNode.addlabel(rwd[2],null,20).pos(459,309).color(100,0,0,100);
                    }
                }
            setbutton(1,356,407,"分享").setevent(EVENT_UNTOUCH,closedialog,1);
            setbutton(2,498,407,"确定").setevent(EVENT_UNTOUCH,closedialog,null);
            if(flaganimate==1){
                element = global.dialogscreen.addsprite("warback.jpg").anchor(50,50).pos(400,240).color(0,0,0,0);
                contextNode.visible(0);
                contextNode.add(sprite("dark.png").size(820,500).anchor(50,50).pos(335,233).color(0,0,0,darkColorAlpha),-1);
                element.addaction(sequence(tintto(1500,100,100,100,100),callfunc(initanimate,datadict)));

                if(datadict.get("leftself") == 1){
                    leftuser = element.addsprite("battleuserback0.png");
                    rightuser= element.addsprite("battleuserback1.png").anchor(100,0).pos(800,0);
                }
                else{
                    leftuser = element.addsprite("battleuserback1.png");
                    rightuser= element.addsprite("battleuserback0.png").anchor(100,0).pos(800,0);
                }
                leftuser.addsprite(avatar_url(datadict.get("leftppyid"))).pos(25,19).size(50,50);
                rightuser.addsprite(avatar_url(datadict.get("rightppyid"))).pos(25,19).size(50,50);
                leftuser.add(label("攻击力："+str(datadict.get("leftpower")),null,16).anchor(0,50).pos(21,86),0,1);
                rightuser.add(label("防御力："+str(datadict.get("rightpower")),null,16).anchor(0,50).pos(21,86),0,1);
                leftuser.addlabel(datadict.get("leftname"),null,18).pos(82,22).color(0,0,0,100);
                rightuser.addlabel(datadict.get("rightname"),null,18).pos(82,22).color(0,0,0,100);
                leftuser.addsprite("nobi"+str(datadict.get("leftnob"))+".png").anchor(50,50).pos(94,57).size(25,25);
                rightuser.addsprite("nobi"+str(datadict.get("rightnob"))+".png").anchor(50,50).pos(94,57).size(25,25);
                leftuser.addlabel(NOBNAME[datadict.get("leftnob")],null,18).pos(111,51).color(0,0,0,100);
                rightuser.addlabel(NOBNAME[datadict.get("rightnob")],null,18).pos(111,51).color(0,0,0,100);
                
                var lgpower = datadict.get("leftgodpower");
                if(lgpower>0){
                    var l=leftuser.addlabel("+"+str(lgpower),null,20).anchor(50,0).pos(118,300).color(0,0,0,0);
                    l.addaction(sequence(delaytime(1500),itintto(100,100,0,100),moveby(2000,0,-200),tintto(2000,0,0,0,0)));
                    datadict.update("leftpower",datadict.get("leftpower")+lgpower);
                    leftuser.addaction(sequence(delaytime(3500),callfunc(itext,"攻击力："+str(datadict.get("leftpower")))));
                    for(var rl=0;rl<3;rl++){
                        var r=leftuser.addsprite("rain1.png").anchor(50,0).pos(60,40+rl*140);
                        r.addaction(sequence(delaytime(1500),repeat(animate(2000,"rain1.png","rain2.png","rain3.png","rain4.png","rain5.png","rain6.png"),2),callfunc(removeself)));
                    }
                }
                lgpower = datadict.get("rightgodpower");
                if(lgpower>0){
                    l=rightuser.addlabel("+"+str(lgpower),null,20).anchor(50,0).pos(118,300).color(0,0,0,0);
                    l.addaction(sequence(delaytime(1500),itintto(100,100,0,100),moveby(2000,0,-200),tintto(2000,0,0,0,0)));
                    datadict.update("rightpower",datadict.get("rightpower")+lgpower);
                    leftuser.addaction(sequence(delaytime(3500),callfunc(itext,"防御力："+str(lgpower))));
                    for(rl=0;rl<3;rl++){
                        r=rightuser.addsprite("rain1.png").anchor(50,0).pos(60,40+rl*140);
                        r.addaction(sequence(delaytime(1500),repeat(animate(2000,"rain1.png","rain2.png","rain3.png","rain4.png","rain5.png","rain6.png"),2),callfunc(removeself)));
                    }
                }
                                /*
                var appear_time = 1500;
                var walk_time = 2000;
                var race_time = 800;
                var fight_time = 3000;
                var win_time = 1500;
                var wait_time = appear_time+walk_time+fight_time+race_time;
                
                var astr = "animate_";
                element.addsprite("mapempirelv1"+estr+".png").anchor(50,50).pos(400,130).scale(110);


                var lpower = powernumtolevel(datadict.get("leftpower"));
                var rpower = powernumtolevel(datadict.get("rightpower"));
                var ibasex = [40,-10,40];
                var ibasey = [20,80,140];
                var soldpos = [[0,20],[40,40],[00,60],[40,80],[0,100]];
                var lsoldier = [(lpower+2)/3,(lpower+3)/3,(lpower+1)/3];
                if(lpower==1){
                    lsoldier = [1,0,1];
                }
                
                var h0 = sprite(lstr+"left_0_1.png").pos(200-100,70);
                h0.addaction(sequence(animate(appear_time,lstr+"left_0_9.png",lstr+"left_0_10.png",lstr+"left_0_11.png",lstr+"left_0_12.png",lstr+"left_0_13.png",lstr+"left_0_1.png"),
                spawn(moveby(walk_time,200,0),repeat(animate(walk_time/4,lstr+"left_0_2.png",lstr+"left_0_3.png",lstr+"left_0_4.png",lstr+"left_0_5.png",lstr+"left_0_6.png",lstr+"left_0_1.png"),4)),
                repeat(animate(appear_time,lstr+"left_0_9.png",lstr+"left_0_10.png",lstr+"left_0_11.png",lstr+"left_0_12.png",lstr+"left_0_13.png",lstr+"left_0_1.png"),5)));
                element.add(h0,70);
                var lgpower = datadict.get("leftgodpower");
                if(lgpower>0){
                    var l=leftuser.addlabel("+"+str(datadict.get("leftgodpower")),null,20).anchor(50,0).pos(118,300).color(0,0,0,0);
                    l.addaction(sequence(delaytime(appear_time),itintto(100,100,0,100),moveby(walk_time/2,0,-200),tintto(walk_time/2,0,0,0,0)));
                    datadict.update("leftpower",datadict.get("leftpower")+lgpower);
                    leftuser.addaction(callfunc(itext,"攻击力："+str(datadict.get("leftpower"))));
                }
                lgpower = datadict.get("rightgodpower");
                if(lgpower>0){
                    l=rightuser.addlabel("+"+str(datadict.get("rightgodpower")),null,20).anchor(50,0).pos(118,300).color(0,0,0,0);
                    l.addaction(sequence(delaytime(appear_time),itintto(100,100,0,100),moveby(walk_time/2,0,-200),tintto(walk_time/2,0,0,0,0)));
                    datadict.update("rightpower",datadict.get("rightpower")+lgpower);
                    rightuser.addaction(callfunc(itext,"防御力："+str(datadict.get("rightpower"))));
                }
                for(var i=0;i<3;i++){
                    if(lsoldier[i]==0){
                        continue;
                    }
                    else{
                        var slstr = lstr+"left_"+str(lsoldier[i])+"_";
                    }
                    for(var j=0;j<5;j++){
                        var h1 = sprite(slstr+"2.png").anchor(50,0).pos(-ibasex[i]+soldpos[j][0]+90,ibasey[i]+100+soldpos[j][1]);
                        if(i%2==1){
                            h1.addaction(sequence(delaytime(appear_time),
                            spawn(moveby(walk_time,200,0),repeat(animate(walk_time/4,slstr+"1.png",slstr+"2.png",slstr+"1.png",slstr+"2.png",slstr+"1.png",slstr+"2.png"),4)),
                            delaytime(race_time/2),spawn(moveby(race_time/2,50,0),animate(race_time/2,slstr+"1.png",slstr+"2.png")),
                            repeat(animate(fight_time/8,slstr+"3.png",slstr+"2.png"),8)));
                        }
                        else{
                            h1.addaction(sequence(delaytime(appear_time),
                            spawn(moveby(walk_time,200,0),repeat(animate(walk_time/4,slstr+"1.png",slstr+"2.png",slstr+"1.png",slstr+"2.png",slstr+"1.png",slstr+"2.png"),4)),
                            spawn(moveby(race_time,100,0),repeat(animate(race_time/2,slstr+"1.png",slstr+"2.png"),2)),
                            repeat(animate(fight_time/8,slstr+"3.png",slstr+"2.png"),8)));
                        }
                        if(datadict.get("leftwin")==1){
                            h1.addaction(sequence(delaytime(wait_time),repeat(animate(400,lstr+str(lsoldier[i])+"_1.png",lstr+str(lsoldier[i])+"_2.png"),win_time/400)));
                        }
                        else{
                            h1.addaction(sequence(delaytime(wait_time),stop(),itexture(slstr+"4.png")));
                        }
                        element.add(h1,ibasey[i]+100+soldpos[j][1]+1);
                    }
                    if(datadict.get("leftgodpower")!=0){
                        h1.prepare();
                        var r=h1.addsprite("rain1.png").anchor(50,100).pos(h1.size()[0]/2,40);
                        r.addaction(sequence(delaytime(appear_time),repeat(animate(walk_time/2,"rain1.png","rain2.png","rain3.png","rain4.png","rain5.png","rain6.png"),2),callfunc(removeself)));
                    }
                }
                if(datadict.get("leftwin")==0){
                    h0.addaction(sequence(delaytime(wait_time),stop(),itexture(lstr+"left_0_8.png")));
                }
                
                var rsoldier = [(rpower+2)/3,(rpower+3)/3,(rpower+1)/3];
                if(rpower==1){
                    rsoldier = [1,0,1];
                }
                lstr = rstr;
                lsoldier=rsoldier;
                h0 = sprite(lstr+"left_0_1.png").pos(600+100,70).scale(-100,100);
                h0.addaction(sequence(animate(appear_time,lstr+"left_0_9.png",lstr+"left_0_10.png",lstr+"left_0_11.png",lstr+"left_0_12.png",lstr+"left_0_13.png",lstr+"left_0_1.png"),
                spawn(moveby(walk_time,-200,0),repeat(animate(walk_time/4,lstr+"left_0_2.png",lstr+"left_0_3.png",lstr+"left_0_4.png",lstr+"left_0_5.png",lstr+"left_0_6.png",lstr+"left_0_1.png"),4)),
                repeat(animate(appear_time,lstr+"left_0_9.png",lstr+"left_0_10.png",lstr+"left_0_11.png",lstr+"left_0_12.png",lstr+"left_0_13.png",lstr+"left_0_1.png"),5)));
                element.add(h0,70);
                for(i=0;i<3;i++){
                    if(lsoldier[i]==0){
                        continue;
                    }
                    else{
                        slstr = lstr+"left_"+str(lsoldier[i])+"_";
                    }
                    for(j=0;j<5;j++){
                        h1 = sprite(slstr+"2.png").anchor(50,0).pos(ibasex[i]-soldpos[j][0]+710,ibasey[i]+100+soldpos[j][1]).scale(-100,100);
                        if(i%2==1){
                            h1.addaction(sequence(delaytime(appear_time),
                            spawn(moveby(walk_time,-200,0),repeat(animate(walk_time/4,slstr+"1.png",slstr+"2.png",slstr+"1.png",slstr+"2.png",slstr+"1.png",slstr+"2.png"),4)),
                            delaytime(race_time/2),spawn(moveby(race_time/2,-50,0),animate(race_time/2,slstr+"1.png",slstr+"2.png")),
                            repeat(animate(fight_time/8,slstr+"3.png",slstr+"2.png"),8)));
                        }
                        else{
                            h1.addaction(sequence(delaytime(appear_time),
                            spawn(moveby(walk_time,-200,0),repeat(animate(walk_time/4,slstr+"1.png",slstr+"2.png",slstr+"1.png",slstr+"2.png",slstr+"1.png",slstr+"2.png"),4)),
                            spawn(moveby(race_time,-100,0),repeat(animate(race_time/2,slstr+"1.png",slstr+"2.png"),2)),
                            repeat(animate(fight_time/8,slstr+"3.png",slstr+"2.png"),8)));
                        }
                        if(datadict.get("leftwin")==0){
                            h1.addaction(sequence(delaytime(wait_time),repeat(animate(400,lstr+str(lsoldier[i])+"_1.png",lstr+str(lsoldier[i])+"_2.png"),win_time/400)));
                        }
                        else{
                            h1.addaction(sequence(delaytime(wait_time),stop(),itexture(slstr+"4.png")));
                        }
                        element.add(h1,ibasey[i]+100+soldpos[j][1]+1);
                    }
                    if(datadict.get("rightgodpower")!=0){
                        h1.prepare();
                        r=h1.addsprite("rain1.png").anchor(50,100).pos(h1.size()[0]/2,40);
                        r.addaction(sequence(delaytime(appear_time),repeat(animate(walk_time/2,"rain1.png","rain2.png","rain3.png","rain4.png","rain5.png","rain6.png"),2),callfunc(removeself)));
                    }
                }
                if(datadict.get("leftwin")==1){
                    h0.addaction(sequence(delaytime(wait_time),stop(),itexture(lstr+"left_0_8.png")));
                }*/
                global.system.pushmusic("4.mp3");
                flaganimate=2;
            }
        }
    }
    var soldiers1;
    var soldiers2;
    var leftself;
    var leftwin;
    var images;
    var background;
    
    function initanimate(showback,data){
        function getSoldierArray(p){
            var result = new Array(0);
            var bresult = [0,0];
            if(p<100){
                bresult = [p/30+1,0];
            }
            else if(p<1000){
                bresult = [p/100+4,0];
            }
            else if(p<10000){
                bresult = [10,p/1000];
            }
            else if(p<100000){
                bresult = [5,p/10000+10];
            }
            else{
                bresult = [0,25+p/100000];
            }
            for(var i=0;i<bresult[0];i++){
                result.append(1);
            }
            for(i=0;i<bresult[1];i++){
                result.append(2);
            }
            return result;
        }
        images = new SoldierImage();
        leftwin = data.get("leftwin");
        leftself = data.get("leftself");
        soldiers1 = getSoldierArray(data.get("leftpower"));
        
        soldiers2 = getSoldierArray(data.get("rightpower"));
        for(var i=0;i<len(soldiers1);i++){
            if(leftself==1){
                soldiers1[i] = new Soldier(soldiers1[i],"self",images);
            }
            else{
                soldiers1[i] = new Soldier(soldiers1[i],"enemy",images);
            }
        }
        for(i=0;i<len(soldiers2);i++){
            if(leftself==0){
                soldiers2[i] = new Soldier(soldiers2[i],"self",images);
            }
            else{
                soldiers2[i] = new Soldier(soldiers2[i],"enemy",images);
            }
        }
        if(leftwin==1){
            for(i=0;i<len(soldiers1);i++){
                soldiers1[i].health = soldiers1[i].health*3/2;
            }
        }
        else{
            for(i=0;i<len(soldiers2);i++){
                soldiers2[i].health = soldiers2[i].health*3/2;
            }
        }
        c_addtimer(100,animaterefresh);
        background = showback;
    }
    
    function executeAnimate(src,des){
        var iswin=0;
        if(len(des)==0){
            iswin=1;
        }
        var i;
        if(iswin==1){
            for(i=0;i<len(src);i++){
                if(src[i].body!=null){
                    src[i].win();
                }
            }
            return 1;
        }
        var f=0;
        if(src == soldiers2){
            f=1;
        }
        for(i=0;i<len(src);i++){
            if(src[i].needjump()==1){
                break;
            }
            if(src[i].body==null){
                src[i].appear(f);
                background.add(src[i].body,src[i].posi[1]);
                break;
            }
            else{
                src[i].body.removefromparent();
                var e=findnearest(src[i],des);
                src[i].setenemy(e);
                src[i].executeAction();
                background.add(src[i].body,src[i].posi[1]);
            }
        }
        return 0;
    }
    
    function findnearest(src,des){
        var nearest = null;
        var minlength = 100000;
        for(var i=0;i<len(des);i++){
            if(des[i].body==null||(des[i].defencenum>1&&des[i].enemy!=src)){
                continue;
            }
            var length = abs(src.posi[0]-des[i].posi[0])+abs(src.posi[1]-des[i].posi[1]);
            if(length<minlength){
                minlength=length;
                nearest = des[i];
            }
        }
        return nearest;
    }
    
    function check(src){
        for(var i=len(src)-1;i>=0;i--){
            src[i].defencenum=0;
            if(src[i].isdead()==1){
                src.pop(i);
            }
        }
    }
    
    function animaterefresh(timer){
        check(soldiers1);
        check(soldiers2);
        if(executeAnimate(soldiers1,soldiers2)==1||executeAnimate(soldiers2,soldiers1)==1){
            timer.stop();
            contextNode.addaction(sequence(delaytime(2000),callfunc(animateover)));
        }
    }
    
    function animateover(){
        contextNode.visible(1);
    }
}