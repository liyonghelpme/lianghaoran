class ImageController{
    var images1 = ["friend_objback1s.png","new.png","opbutton9.png",
    "object39.png","object40.png","object41.png","room72.png","room73.png","room74.png","room75.png","room76.png","room77.png","fact27.png","fact28.png","fact29.png",
    "camp6.png","camp7.png","camp8.png","dialogelement_military2.png","dialogelement_state2.png","soldier3_1.png","soldier3_2.png","soldier3_3.png",
    "dialogback_info.png","dialogtab_info0.png","dialogtab_info1.png","infobutton0.png","infobutton1.png","infocell0.jpg","infocell1.jpg","infotab0.png","infotab1.png",
    "medalcard0_1.png","medalcard0_2.png","medalcard0_3.png","medalcard0_4.png","medalcard0_5.png","medalcard1_1.png","medalcard1_2.png","medalcard1_3.png","medalcard1_4.png","medalcard1_5.png",
    "medalnob.png","wtask1.png","wtask2.png","wtask3.png","wtask4.png","medalbutton2.png","medalIcon2.png","loadingwarback.jpg","warchoosebuttonback0.png","warchoosebuttonback1.png",
    "dialogback_rank.png","friend_rank.png","rankcell4.jpg","rankcell5.jpg","rankcell6.jpg","rankcell7.jpg","rankleft.png","warchoose0.png","warchoose1.png","warchoose2.png",
    "rankright.png","ranktab0_0.png","ranktab0_1.png","ranktab1_0.png","ranktab1_1.png","ranktype0_0.png","ranktype0_1.png","ranktype1_0.png","ranktype1_1.png","egg-3-2.png",
    "egg-3-3.png","egg-3-4.png","egg-3-5.png","egg-3-6.png","egg-3-7.png","egg-3.png","nestbuildingback.png","nestbuildingfiller.png","nestdialogelement.jpg","nestpetfiller0.png",
    "nestpetfiller1.png","nestpetfiller2.png","nestpettab1.png","nesttab0.png","opbutton19.png","opbutton21.png","opbutton23.png","opbutton25.png","petrenamepic.jpg","build1000.png",
    "egg-1-0.png","egg-1-1.png","egg-1-2.png","egg-1-3.png","egg-1.png","egg-2-0.png","egg-2-1.png","egg-2-2.png","egg-2-3.png","egg-2.png","egg-3-0.png","egg-3-1.png",
    "blessing1.png","blessing2.png","blessing3.png","blessing4.png","blessing5.png","blessing6.png","blessing7.png","blessing8.png","blessing9.png","opbutton17.png"];
    const images2 = [
"addallybound.jpg","allyelement.png","bindButton.png","cancelallyelement.png","friend_objadd.png","friend_objback2.png","friend_objnone.png","friendbutton2.png",
"wartabperson.png","adddefence.png","attack_head.png","attackbeginelement.png", 
"animate_self_left_2_4.png","animate_enemy_1_1.png","dialogback_attack.png",
"animate_enemy_1_2.png","animate_enemy_2_1.png","animate_enemy_2_2.png","animate_enemy_left_0_1.png","animate_enemy_left_0_2.png","animate_enemy_left_0_3.png",
"animate_enemy_left_0_4.png","animate_enemy_left_0_5.png","animate_enemy_left_0_6.png","animate_enemy_left_0_8.png","animate_enemy_left_0_9.png","animate_enemy_left_0_10.png",
"animate_enemy_left_0_11.png","animate_enemy_left_0_12.png","animate_enemy_left_0_13.png","animate_enemy_left_1_1.png","animate_enemy_left_1_2.png","animate_enemy_left_1_3.png",
"animate_enemy_left_1_4.png","animate_enemy_left_2_1.png","animate_enemy_left_2_2.png","animate_enemy_left_2_3.png","animate_enemy_left_2_4.png","animate_self_left_0_1.png",
"animate_self_left_0_2.png","animate_self_left_0_3.png","animate_self_left_0_4.png","animate_self_left_0_5.png","animate_self_left_0_6.png","animate_self_left_0_8.png",
"animate_self_left_0_9.png","animate_self_left_0_10.png","animate_self_left_0_11.png","animate_self_left_0_12.png","animate_self_left_0_13.png","animate_self_left_1_4.png",
"battle1.png","battle2.png","battle3.png","battle4.png","battle5.png","battle6.png","battle7.png","battle8.png","battle9.png","battleresultback.jpg","battleuserback0.png","battleuserback1.png",
"defence_head.png","defenceback.jpg","dialogback_warabout.png","dialogtab_warabout0.png","adddefence2.png",
"dialogtab_warabout1.png","flagother.png","help.png","mapelement0.png","mapelement2.png","mapelement3.png","mapempirelv1.png",
"mapempirelv2.png","mapempirelv2_self.png","mapempirelv3.png","mapempirelv3_self.png","mapempirelv4.png","mapempirelv4_self.png","mapempirelv5.png","mapempirelv5_self.png",
"mapempirelv6.png","mapempirelv6_self.png","mapempirelv7.png","mapempirelv7_self.png","mapobj0lv1.png","mapobj0lv2.png","mapobj0lv3.png","mapobj1lv1.png","mapobj1lv2.png",
"mapobj1lv3.png","mapobj2lv1.png","mapobj2lv2.png","mapobj2lv3.png","mapobj3lv1.png","mapobj3lv2.png","mapobj3lv3.png","mapobj4lv1.png","mapobj4lv2.png","mapobj4lv3.png",
"mapuserboard0.png","moveback.png","moveblock.png",
"nobi0.png","nobi1.png","nobi2.png","nobi3.png","nobi4.png","nobi5.png","nobi6.png","nobi7.png","nobi8.png","nobi9.png","nobi10.png","nobi11.png","nobi12.png","nobi13.png","nobi14.png","nobi15.png","nobi16.png","nobi17.png","nobi18.png",
"nobilityback.png","nobilityreward.jpg",
"opbutton12.png","opbutton13.png","opbutton14.png","opbutton15.png","spyback.jpg","spyelement0.png","spyelement1.png",
"spyelement2.png","spyelement3.png","spyresultback.jpg","spytab0.png","spytab1.png","unbindButton.png","warabout0.png","warabout1.png","warback.png","warbutton00.png",
"warbutton01.png","warbutton10.png","warbutton11.png","warbutton20.png","warbutton21.png",
"warinfotab00.png","warinfotab01.png","warinfotab10.png","warinfotab11.png","warinfotab12.png","warmenulistback.png","warmenutab0.png",
"warmenutab1.png","warrecord.png","warrecordcell.png","4.mp3", "adddefencetitle.png","adddefenceboard.jpg","nobattletab0.png","nobattletab1.png","wartabperson_b.png","wartabperson_r.png",
"warlostleft.jpg","warwinelement2.jpg","warwinleft.jpg","warloseelement2.jpg","help2.png","defence.png","opbutton16.png"];
    var images;
    var imageindex;
    var imagemax;
    var flagtime;
    var needloading;
    function ImageController(){
        needloading=-1;
        trace("sysinfo",sysinfo(21));
        if(2>=3){
            var taskfile = c_res_file("resfile.txt");
            var taskstr = c_file_op(C_FILE_READ,taskfile);
            images1 = taskstr.split(",");
        }
    }
    function begindownload(i){
        if(i==1){
            images=images1;
        }
        else if(i==2){
            images=images2;
        }
        needloading=0;
        imagemax = len(images);
        imageindex = 0;
        flagtime=0;
        checkimages(0,0,0);
    }
    function checkimages(s,f,p){
        while(imageindex<imagemax&&checkimage(images[imageindex])==1){
            imageindex++;
            flagtime=0;
        }
    }
    
    function checkimage(str){
        var im=fetch(str);
        if(im!=null){
            return 1;
        }
        else{
            node().addaction(request(str,1,checkimages));
            needloading=1;
            imageindex++;
            return 0;
        }
    }
    
    function isdownloadfinish(){
        if(needloading==-1 || imageindex==imagemax){
            return 1;
        }
        return 0;
    }
}