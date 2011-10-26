 class Nestpetchange extends ContextObject{
    var objs;
    var left;
    var right;
    var pagemax;
    var pagenum;
    var objmax;
    var titlename;
    var objpath;
    var buildable;
    const PAGEITEMS = 6;
    var objlevel;
    var type;
    function Nestpetchange(t){
        type=t;
        contextname = "dialog-object-pets";
        contextNode = null;
        objs = new Array(0);
        buildable = new Array(0);
        initdata();
        contextLevel=1;
    }
    
    function initdata(){
        pagemax = 1;
        objmax = 6;
        titlename = "更改属性";
        objpath="pet";
    }
    
    function getcell(i){
        var cell = sprite("nesttab0.png");
        //cell.addlabel(global.getname(objpath,i),null,20).anchor(50,50).pos(94,12).color(0,0,0,100);
        cell.addlabel(PETS_NAME[i],null,20).anchor(50,50).pos(94,12).color(0,0,0,100);
        //cell.addsprite(objpath+str(i)+".png").anchor(50,50).pos(94,66).size(67,67);
        cell.addsprite("egg-1.png").anchor(0,0).pos(59,38);

        if(type.objid==i){
            cell.texture("nestpettab1.png");
            cell.addlabel("当前宠物",null,20).anchor(50,50).pos(94,155).color(0,0,0,100);
        }
        else{
            cell.setevent(EVENT_TOUCH,beginPlant,i);
            var price=PETS_PRICE[i];
            if(price<0){
                var cl=0;
                price = -price;
                if(global.user.getValue("caesars") < price){
                    cl=100;
                    buildable[i].update("ok",0);
                    buildable[i].update("凯撒币",price-global.user.getValue("caesars"));
                }
                cell.addsprite("caesars_big.png").size(20,20).anchor(0,50).pos(70,155);
                cell.addlabel(str(price),null,20).anchor(0,50).pos(92,155).color(cl,0,0,100);
            }
            else{
                cl = 0;
                if(global.user.getValue("money") < price){
                    cl=100;
                    buildable[i].update("ok",0);
                    buildable[i].update("银币",price-global.user.getValue("money"));
                }
                cell.addsprite("money_big.png").size(20,20).anchor(0,50).pos(57,155);
                cell.addlabel(str(price),null,20).anchor(0,50).pos(79,155).color(cl,0,0,100);
            }
        }
        return cell;
    }

    function paintNode(){
        pagenum = 1;
        contextNode = sprite("dialogback_plant.png").anchor(50,50).pos(400,240);
        contextNode.addsprite("builddialogclose.png").anchor(100,0).pos(650,5).setevent(EVENT_UNTOUCH,closedialog);
        contextNode.addlabel(titlename,null,40).anchor(50,50).pos(332,31);
        if(objmax > PAGEITEMS){
            left = contextNode.addsprite("left.png").anchor(25,50).pos(0,247).setevent(EVENT_TOUCH,choosePage,-1);
            right = contextNode.addsprite("right.png").anchor(75,50).pos(665,247).setevent(EVENT_TOUCH,choosePage,1);
        }
        else{
            left=null;
        }
        for(var i=0;i<objmax;i++){
            buildable.append(dict([["ok",1]]));
            objs.append(getcell(i).pos(46+i%3*192,76+i/3%2*180));
        }
        choosePage(0,0,0);
    }

    function choosePage(n,e,po){
        if(pagenum == 1 && po == -1 || pagenum == pagemax && po == 1)
            return 0;
        var p = pagenum+po;
        for(var i = 0;i<objmax;i++){
            if(i/6+1==pagenum)
                objs[i].removefromparent();
            if(i/6+1 == p)
                contextNode.add(objs[i]);
        }
        pagenum = p;
        if(left!=null){
            if(p == 1)
                left.color(40,40,40,100);
            else
                left.color(100,100,100,100);
            if(p == pagemax)
                right.color(40,40,40,100);
            else
                right.color(100,100,100,100);
        }
    }

    function beginPlant(node,event,param){
        if(buildable[param].get("ok")==1){
            global.pushContext(self,new Warningdialog([PETS_NAME[param]+"初始战斗力："+str(PETS_POWER[param])+"，每成长点增加战斗力："+str(PETS_UP[param])+"。确定更改吗？",param,6]),NonAutoPop);
        }
        else{
            global.pushContext(self,new Warningdialog(buildable[param]),NonAutoPop);
        }
    }
    var objid;
    function reloadNode(re){
        objid=re;
        global.http.addrequest(1,"changeKind",["uid", "pid", "kind"],[global.userid,type.pid,re],self,"buyegg");
    }
    
    function useaction(p,rc,c){
        if(p=="buyegg"){
            trace(c);
            if(PETS_PRICE[objid]>0){
                global.user.changeValueAnimate2(global.context[0].moneyb,"money",-PETS_PRICE[objid],-6);
            }
            else{
                global.user.changeValueAnimate2(global.context[0].moneyb,"caesars",PETS_PRICE[objid],-6);
            }
            global.popContext(objid);
        }
    }

    function closedialog(node,event){
        global.popContext(null);
    }

    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}