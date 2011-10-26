import page.CastlePage;
import element.Simpledialog;
import element.MenuControl;
import element.Feedbackdialog;
import element.Medaldialog;
import global.TaskController;
import global.WarTaskController;
import element.Levelupdialog;
import global.HttpController;
import global.UserController;
import global.ImageController;

var myid;
if(ppy_connected()!=1){
    ppy_login();
}
var global = new GlobalController();
global.self = global;
global.system = new MenuControl();
global.system.initwithconfig();
global.system.pushmusic("0.mp3");
global.http = new HttpController();
global.http.init(global.http,global);
global.task = new TaskController();
global.task.init(global.task,global);
global.wartask = new WarTaskController();
global.wartask.init(global.wartask,global);
global.user = new UserController();
global.user.global = global;
global.image = new ImageController();

trace("init over");
v_scale(800,480);
var ispause = 0;
export("onpause",onpausefunc);
export("onresume",onresumefunc);
    function onpausefunc(){
        if(global.currentLevel>=0&&global.system.flagmusic == 1)
            global.system.music.pause();
        if(global.context[0].initlock==-1){
            global.context[0].pause();
            ispause=1;
        }
    }

    function onresumefunc(){
        if(global.currentLevel>=0&&global.system.flagmusic == 1)
            global.system.music.play(-1);
        if(ispause==1){
            ispause = 0;
            global.context[0].resume();
        }
    }

var castle = new CastlePage();
global.pushContext(null,castle,NonAutoPop);
castle.initialMenu();
global.screen.visible(0);

var flaglogin = 0;
var flaglastimage = 0;

var percent =0;
var page = sprite().setevent(EVENT_TOUCH,donothing).anchor(50,50).pos(400,240);
var lback = fetch("loading-pet.jpg");
var loadingstr = "";
if(lback==null){
    page.texture("loadingback.jpg");
    //checkImages(0,0,0);
    //page.addlabel("正在加载新图片...",null,25).anchor(50,50).pos(400,450);
    node().addaction(request("loading-pet.jpg",1,null));
    //flaglogin=2;
}
else{
    page.texture(lback);
    //checkImages(0,0,0);
}
global.dialogscreen.add(page,0);
page.add(label(loadingstr+"0%",null,25).anchor(50,100).pos(400,440),0,1);
page.add(sprite("loadingbar.png").pos(0,450).size(1,12),0,2);
c_invoke(beginLoading,1000,null);

function beginLoading(){
    c_addtimer(500,loading);
    global.image.begindownload(1);
    castle.initialFactorys();
}

function setlogin(){
    flaglogin=0;
}

var percentmax = 0;
    function loading(timer){
        if(percent == 100){
            timer.stop();
            global.context[0].initialControls();
            page.removefromparent();
        }
        if(castle.initlock == 0 && flaglogin==0 && global.image.isdownloadfinish()==1){
            if(percentmax<81){
                if(global.user.getValue("nobility")>=0){
                    global.image.begindownload(2);
                }
                percentmax=81;
                global.screen.visible(1);
            }
            else{
                flaglogin=1;
                percentmax = 100;
            }
        }
        if(percent < 100 && global.http.flag_netstate==0){
            percent = percent+5+rand(5);
            var tmp=percentmax;
            if(percentmax<80){
                percentmax=(global.image.imageindex)*80/global.image.imagemax;
            }
            else if(percentmax>=81&&percentmax<100){
                percentmax=81+(global.image.imageindex)*18/global.image.imagemax;
            }
            if(global.image.needloading==1){
                if(percentmax>tmp){
                    loadingstr="正在加载游戏...";
                }
                global.image.flagtime++;
                if(global.image.flagtime==27){
                    global.image.checkimages(0,0,0);
                    loadingstr = "如果进度条卡住，请点击返回按钮重启游戏...";
                }
            }
        }
        else if(global.http.flag_netstate!=0){
            percent = percent;
        }
        if(percent>percentmax){
            percent = percentmax;
        }
        page.get(1).text(loadingstr+str(percent)+"%");
        page.get(2).size(8*percent,12);
    }