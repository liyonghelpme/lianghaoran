class Simpledialog extends ContextObject{
    const dialogsize = [[439,383],[404,270],[381,374],[558,471]];
    const dialogpic = ["dialogback_a.png","dialogback_b.png","dialogback_c.png","dialogback_d.png"];
    var dialogtype;
    var buttontab;
    
    var dialogelement;
    
    function Simpledialog(t,e){
        contextNode = null;
        dialogtype = t;
        buttontab =0;
        dialogelement=e;
    }
    
    function setclosebutton(){
        contextNode.add(sprite("builddialogclose.png").anchor(100,0).pos(dialogsize[dialogtype][0]-10,10).setevent(EVENT_UNTOUCH,closedialog,null),1);
    }
    
    function usedefaultbutton(buttonnum,name){
        var w=dialogsize[dialogtype][0];
        var h=dialogsize[dialogtype][1]-42;
        if(buttonnum == 1){
            setbutton(1,w/2,h,name,null);
        }
        else if(buttonnum==2){
            setbutton(1,w/3-17,h,name[0],1);
            setbutton(2,w*2/3+17,h,name[1],null);
        }
    }
    
    function closedialog(n,e,p){
        if(p==null){
            global.popContext(null);
        }
        else{
            dialogelement.excute(p);
        }
    }
    
    function settitle(path){
        contextNode.add(sprite(path).anchor(50,40).pos(dialogsize[dialogtype][0]/2,0),1);
        contextNode.pos(400,249);
    }
    
    function setbutton(bt,x,y,n,param){
        var button = sprite("boxbutton"+str(bt)+".png").anchor(50,50).pos(x,y);
        button.addlabel(n,null,BUTTONFONTSIZE).anchor(50,50).pos(62,19);
        button.setevent(EVENT_UNTOUCH,closedialog,param);
        contextNode.add(button,1,buttontab);
        buttontab++;
    }
    
    function paintNode(){
        contextNode = sprite(dialogpic[dialogtype]).anchor(50,50).pos(400,240);
        contextNode.setevent(EVENT_KEYDOWN,dialogkeydown);
        contextNode.add(dialogelement.getelement(),0);
    }
    
    function dialogkeydown(n,e,p,kc){
        if(kc == 4){
            closedialog(0,0,null);
        }
    }
}