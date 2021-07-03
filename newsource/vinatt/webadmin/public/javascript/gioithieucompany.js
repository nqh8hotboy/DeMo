var resallcompany;
var idinro=0;
var iduser=1;
$(".themgioithieu").click(function () {
	
	var cont=CKEDITOR.instances.editorgioithieu.getData();
	var cont_en=	CKEDITOR.instances.editorgioithieu_en.getData();
    var dataSend={
		idintro:idinro,
		contentintro_vi:cont,
		contentintro_en:cont_en,
		listimg:JSON.stringify(urllinksetupimagegioithieu)
     
    }
	queryData("gioithieu/create",dataSend,function (res) {
      // console.log(res);
        if(res.code==1000){
			alert_info("Lưu thành công bài viết");
			builddscompany();
		}
		else{
			alert_error("Thực hiện dữ liệu bị lỗi");
		}
	});
});
$(".themgioithieurefesh").click(function () {
    // alert("");
  //swapMain("gioithieu");
  //builddsnhasc(0,record);
  builddscompany()
});
function builddscompany() {
    
    var dataSend={

     
     
    }
   // console.log(dataSend);
    $(".listcompany").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  
    queryData("gioithieu/getintroducecompany",dataSend,function (res) {
       //console.log(res);
        if(res.code==1000){
		console.log(res);
            $(".listcompany").html("");
            buildHTMLCompanyData(res);
            
        }else{
            $(".listcompany").html("Tìm không thấy");
			//$(".numberpage_loaisp").html("");
        }
    });
}
function resetViewGioiThieu() {
		CKEDITOR.instances.editorgioithieu.setData("");
		CKEDITOR.instances.editorgioithieu_en.setData("");
}

var urllinksetupimagegioithieu=[];
function buildHTMLCompanyData(res) {
    
    var data = res.data.items;
   
    resallcompany=data;
   
    var html='';
    var htmlts='';
    var listinffo='';
	var stt=1;
//	var currentpage=parseInt(res.data.page);
  //  stt=printSTT(record,currentpage);
    for (item in data) {
        var list=data[item];
		idinro=list.idintro;
		CKEDITOR.instances.editorgioithieu.setData(list.contentintro_vi);
		CKEDITOR.instances.editorgioithieu_en.setData(list.contentintro_en);
		urllinksetupimagegioithieu=JSON.parse(list.listimg);
		
       
		
    }
	
   
}

var urllinksetupimageactivity=[];
$(".ip-img-user-change_anhgiothieu").change(function () {
    var obj=$(this);
	$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang tải ảnh");
    uploadImage(obj,function (res) {
    	 
        if(res.code=="1000"){
			$(".modalshowprogess").modal("hide");
			alert_info("Tải ảnh lên thành công");
		obj.val("");
		var r1=res.data.url;
		updatelibra(r1);
					
        }
        else{
           	alert_error("Tải ảnh lên không thành công");
			$(".modalshowprogess").modal("hide");
        }
    });
	
});


/////////////////////load thu vien hinh
function builddsimg(page,record) {
    
    var dataSend={

       page:page,
	   record:record,
       
    }
   // console.log(dataSend);
    $(".list_img_libra").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  
    queryData("news/getallimages",dataSend,function (res) {
      // console.log(res);
        if(res.code==1000){
	//	console.log(res);
            $(".list_img_libra").html("");
            buildHTMLimgeslibraData(res);
            
        }else{
            $(".list_img_libra").html("Tìm không thấy");
			$(".numberpage_libra").html("");
        }
    });
}
var resalllibra;
//load thu vien hinh
function buildHTMLimgeslibraData(res) {
    
    var data = res.data.items;
   
    resalllibra=data;
   
    var html='';
    var htmlts='';
    var listinffo='';
	var stt=1;
	var currentpage=parseInt(res.data.page);
    stt=printSTT(record,currentpage);
    for (item in data) {
        var list=data[item];
		var img='img/no_image.png';
        if(list.hinhanh==""){
			img='img/no_image.png';
		}else{
			img=urlLocal+list.listimage;
		}
		var s='<button type="button" class="btn btn-danger click_chon_anh" data-img='+list.listimage+' data-vt='+item+'><i class="fa fa-copy">&nbsp;</i>Chọn</button>';
		if(fg==1){
		s='<button type="button" class="btn btn-danger click_chon_anh" data-img='+list.listimage+' data-vt='+item+'><i class="fa fa-copy">&nbsp;</i>Chọn làm ảnh đại diện</button>';
		}else if(fg==3){
		s='<button type="button" class="btn btn-danger click_chon_anh" data-img='+list.listimage+' data-vt='+item+'><i class="fa fa-copy">&nbsp;</i>Chọn làm ảnh đại diện</button>';
		}
		var t='<button type="button" class="btn btn-danger click_xoa_anh" data-img='+list.listimage+' data-vt='+item+'><i class="fa fa-trash-o">&nbsp;</i>Xóa</button> ';
        html=html +'<div class="col-sm-4 col-lg-4 col-md-4" align="center">'+
                                 '<div class="embed-responsive embed-responsive-16by9">'+
                                '<img src="'+img+'" alt="anh" width="150" height="150" ></div>'+
                                '<p>Ngày tạo: '+getDateTime(list.create_img)+' </p>'+
                                '<h6>'+urlLocal+list.listimage+' </h6>'+
								 s+'&nbsp;&nbsp;&nbsp;'+t+
                            '</div>';
        stt++;
       
		
    }
	 $(".list_img_libra").html(html);
    buildSlidePage($(".numberpage_libra"),5,res.data.page,res.data.totalpage);
}
//xu ly xoa va chon thu vien anh
$(".list_img_libra").on('click',".click_chon_anh",function () {
	 var vt=parseInt($(this).attr("data-vt"));
	
    var custom=resalllibra[vt];
	if(fg==2){
	//urllinksetupimageactivity[0]=custom.listimage;
	addimageactivity(custom.listimage);
	
	}else if(fg==1){
		urllinksetupimagegioithieu[0]=custom.listimage;
	}else{
		//console.log("news");
		$(".news_link").val(custom.listimage);
		
	}
});
$(".list_img_libra").on('click',".click_xoa_anh",function () {
	 var vt=parseInt($(this).attr("data-vt"));
	
    var custom=resalllibra[vt];
	
   

    bootbox.confirm("Bạn có chắc xóa ảnh trong thư viện này không?", function(result){
        if(result==true) {
		//////
		 var dataSend = {
                
				urlimg:custom.listimage
            };
         
            $(".modalshowprogess").modal("show");
            $(".tientrinhxuly").html("Đang xử lý dữ liệu");
            queryData("news/checkimageactivty", dataSend, function (res) {
				if(res.code==1002){
					alert_info("Hình ảnh này đã dược sử dụng. Không thể xóa");
					 $(".modalshowprogess").modal("hide");
				}else{
				var dataSend = {
                id:custom.id,
				urllink:custom.listimage
				};
         
				$(".modalshowprogess").modal("show");
				$(".tientrinhxuly").html("Đang xóa dữ liệu");
				queryData("news/deletelibra", dataSend, function (res) {

                if (res.code == 1000) {
                    alert_info("Xóa thành công");
                    $(".modalshowprogess").modal("hide");
					builddsimg(page_libra,record);
					/////////////phai xoa trong databse nua
					
                }else if(res.code==1001){
                    alert_info("Xóa thất bại");
                    $(".modalshowprogess").modal("hide");
                }else{
					alert_info("Không thể kết nối đến máy chủ");
                    $(".modalshowprogess").modal("hide");
				}
				$(".modalshowprogess").modal("hide");
				});
				}
			})
			
			
		////
            


        }else
        {
            // alert_info("Lỗi");
        }
		});
	
});
var page_libra=0;
$(".numberpage_libra ").on('click','button',function () {
   
	page_libra=$(this).val();
    builddsimg($(this).val(),record);
});
$(".click_libra").click(function () {
 builddsimg(0,record);
});
///////////////////////////////load cac hinh anh hoat dong
function builddsimgactivity(page,record) {
    
    var dataSend={

       page:page,
	   record:record,
       
    }
   // console.log(dataSend);
    $(".list_img_activityimg").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  
    queryData("news/getallimagesactivity",dataSend,function (res) {
     
        if(res.code==1000){
	
            $(".list_img_activityimg").html("");
            buildHTMLimgesactivityData(res);
            
        }else{
            $(".list_img_activityimg").html("Tìm không thấy");
			$(".numberpage_activityimg").html("");
        }
    });
}
var resallactivityimg;
function buildHTMLimgesactivityData(res) {
    
    var data = res.data.items;
   
    resallactivityimg=data;
   
    var html='';
    var htmlts='';
    var listinffo='';
	var stt=1;
	var currentpage=parseInt(res.data.page);
    stt=printSTT(record,currentpage);
    for (item in data) {
        var list=data[item];
		var img='img/no_image.png';
        if(list.hinhanh==""){
			img='img/no_image.png';
		}else{
			img=urlLocal+list.urlimg;
		}
		var s='<button type="button" class="btn btn-danger click_xoa_anh" data-img='+list.urlimg+' data-vt='+item+'><i class="fa fa-trash-o">&nbsp;</i>Xóa</button> ';
        html=html +'<div class="col-sm-4 col-lg-4 col-md-4">'+
                                 '<div class="embed-responsive embed-responsive-16by9">'+
                                '<img src="'+img+'" alt="anh" ></div>'+
                                '<p>Ngày tạo: '+getDateTime(list.create_date)+' </p>'+
                                '<h6>'+urlLocal+list.urlimg+' </h6>'+
								'<div>'+s+'</div>'+
                            '</div>';
        stt++;
       
		
    }
	 $(".list_img_activityimg").html(html);
    buildSlidePage($(".numberpage_activityimg"),5,res.data.page,res.data.totalpage);
}
$(".list_img_activityimg").on('click',".click_xoa_anh",function () {
	 var vt=parseInt($(this).attr("data-vt"));
	
    var custom=resallactivityimg[vt];
	
   

    bootbox.confirm("Bạn có chắc xóa ảnh này không?", function(result){
        if(result==true) {
		//////
		
         
           
				var dataSend = {
                id:custom.id
				};
         
				$(".modalshowprogess").modal("show");
				$(".tientrinhxuly").html("Đang xóa dữ liệu");
				queryData("news/deleteimagesactivity", dataSend, function (res) {

                if (res.code == 1000) {
                    alert_info("Xóa thành công");
                    $(".modalshowprogess").modal("hide");
					builddsimgactivity(activityimges_page,record);
					/////////////phai xoa trong databse nua
					
                }else if(res.code==1001){
                    alert_info("Xóa thất bại");
                    $(".modalshowprogess").modal("hide");
                }else{
					alert_info("Không thể kết nối đến máy chủ");
                    $(".modalshowprogess").modal("hide");
				}
				$(".modalshowprogess").modal("hide");
				});
		
        }else
        {
            // alert_info("Lỗi");
        }
		});
	
});
var activityimges_page=0;
$(".numberpage_activityimg ").on('click','button',function () {
   
 activityimges_page=$(this).val();
    builddsimgactivity($(this).val(),record);
});
var activityimges_page=0;
$(".click_activityimg").click(function () {
	
 builddsimgactivity(0,record);
});

function addimageactivity(urllinksetupimageactivity){
	var dataSend={
		create_date:new Date().getTime(),
		
		urlimg:urllinksetupimageactivity
     
    }
	queryData("news/createimagesactivty",dataSend,function (res) {
       //console.log(res);
        if(res.code==1000){
			alert_info("Lưu thành công hình ảnh hoạt động");
			
			
			builddsimgactivity(activityimges_page,record);
		}
		else{
			alert_error("Thực hiện dữ liệu bị lỗi");
		}
	});
}
$(".themhinhanhhoatdongrefesh").click(function () {
  
  builddsimgactivity(0, record)
});
///////////////////Tin tuc cua cong ty
$(".savenews").hide();
$(".savenews").click(function () {
	if(checkaddnews==0){
		var imgnews=$(".news_link").val();
	var tile_vi=$(".news_title_vi").val();
	var title_en=$(".news_title_en").val();
	var des_vi=$(".news_desc_vi").val();
	var des_en=$(".news_desc_en").val();
	var cont=CKEDITOR.instances.editorcontentnews_vi.getData();
	var cont_en=	CKEDITOR.instances.editorcontentnews_en.getData();
    var dataSend={
		title_vi:tile_vi,
		title_en:title_en,
		short_description_vi:des_vi,
		short_description_en:des_en,
		content_vi:cont,
		content_en:cont_en,
		urlimg:imgnews,//JSON.stringify(urllinksetupimagegioithieu),
		iduser:iduser,
		create_date:new Date().getTime(),
		visible:1
     
    }
	 $(".modalshowprogess").modal("show");
            $(".tientrinhxuly").html("Đang thêm dữ liệu");
	queryData("news/createnews",dataSend,function (res) {
       //console.log(res);
        if(res.code==1000){
			 $(".modalshowprogess").modal("hide");
			alert_info("Lưu thành công bài viết");
			builddsnews(news_current,record);
			resetViewnews();
		}
		else{
			alert_error("Thực hiện dữ liệu bị lỗi");
		}
	});
	}else{//updateCommands
		var imgnews=$(".news_link").val();
	var tile_vi=$(".news_title_vi").val();
	var title_en=$(".news_title_en").val();
	var des_vi=$(".news_desc_vi").val();
	var des_en=$(".news_desc_en").val();
	var cont=CKEDITOR.instances.editorcontentnews_vi.getData();
	var cont_en=	CKEDITOR.instances.editorcontentnews_en.getData();
    var dataSend={
		idnews:idnews,
		title_vi:tile_vi,
		title_en:title_en,
		short_description_vi:des_vi,
		short_description_en:des_en,
		content_vi:cont,
		content_en:cont_en,
		urlimg:imgnews,//JSON.stringify(urllinksetupimagegioithieu),
		iduser:iduser,
		create_date:new Date().getTime(),
		visible:visiblenews
		
     
    }
	queryData("news/udpatenews",dataSend,function (res) {
     //  console.log(res);
        if(res.code==1000){
			alert_info("Cập nhật thành công bài viết");
			builddsnews(news_current,record);
			resetViewnews();
			checkaddnews=0;
		}
		else{
			alert_error("Thực hiện dữ liệu bị lỗi");
		}
	});
	
	
	}
});
$(".themtintucrefesh").click(function () {
	resetViewnews();
  
});
$(".themnews").click(function () {
	checkaddnews=0;
	$(".savenews").show();
});
function resetViewnews() {
	$(".news_title_vi").val("");
	$(".news_title_en").val("");
	$(".news_desc_vi").val("");
	$(".news_desc_en").val("");
		$(".news_link").val("");
	CKEDITOR.instances.editorcontentnews_vi.setData("");
	CKEDITOR.instances.editorcontentnews_en.setData("");
	$(".savenews").hide();
	checkaddnews=0;
}
$(".click_dsnews").click(function () {
	builddsnews(0,record);
});
var anews;
var checkaddnews=0;
function builddsnews(page,record) {
    
    var dataSend={

       page:page,
	   record:record,
       charsearch:""
    }
   // console.log(dataSend);
    $(".list_news_detail").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  
    queryData("news/getnewsweb",dataSend,function (res) {
  //     console.log(res);
        if(res.code==1000){
	//	console.log(res);
            $(".listloaisp").html("");
            buildHTMLNewsData(res);
            
        }else{
            $(".list_news_detail").html("Tìm không thấy");
			$(".numberpage_news").html("");
        }
    });
}
function buildHTMLNewsData(res) {
    
    var data = res.data.items;
   
    anews=data;
   
    var html='';
    var htmlts='';
    var listinffo='';
	var stt=1;
	var currentpage=parseInt(res.data.page);
    stt=printSTT(record,currentpage);
    for (item in data) {
        var list=data[item];
		var s="Hiển thị";
		var k='';
		if(list.visible==1){
			k='<button type="button" class="btn btn-danger click_an" data-vi="0">Ẩn</button>';
		}else{
			s="Ẩn";
			k='<button type="button" class="btn btn-danger click_an" data-vi="1">Hiển thị</button>';
		}
        html=html +
            '<tr data-idnews="' + list.idnews + '"data-name="'+list.idnews+'  "data-vt="' + item + '">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
            '<td class="btn-show-info-cv">' + list.title_vi + '</td>' +
            '<td class="btn-show-info-cv">' + getDateTime(list.create_date)+ '</td>'+
			 '<td class="btn-show-info-cv">' + s + '</td>' +
			
            '<td class="btn-show-info-sua" align="center"><i class="fa fa-edit"></i></td>'+
              
            '<td class="btn-show-info-remove"><a href="#">  <i class="fa fa-trash-o"></i></a></td>' +
			 '<td><a href="#"> '+k+' </a></td>' +
            
            '</tr>';
        stt++;
        $(".list_news_detail").html(html);
		
    }
	
    buildSlidePage($(".numberpage_news"),5,res.data.page,res.data.totalpage);
}
$(".list_news_detail").on('click',".click_an",function () {
	 var id=($(this).parents("tr").attr("data-idnews"));
	  var vi=($(this).attr("data-vi"));
	 var dataSend = {
                visible:vi,
				idnews:id
            };
          // console.log(dataSend);
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang cập nhật trạng thái dữ liệu");
            queryData("gioithieu/udpatenewsvisible", dataSend, function (res) {
                
                if (res.code == 1000) {
               builddsnews(news_current,record);
                    
					$(".modalshowprogess").modal("hide");
                    
                }else{
					alert_info("Cập nhật thất bại");
					$(".modalshowprogess").modal("hide");
				}
				
            });
			
});
var news_current=0;
$(".numberpage_news ").on('click','button',function () {
    //console.log("nha"+$(this).val());
    news_current=$(this).val();
 
    builddsnews($(this).val(),record);
});
var idnews=0;
var visiblenews=1;
$(".list_news_detail").on('click',".btn-show-info-sua",function () {
$(".savenews").show();
	checkaddnews=1;
   
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=anews[vt];
    idnews=custom.idnews;
	$(".news_link").val(custom.urlimg);
   $(".news_title_vi").val(custom.title_vi);
	$(".news_title_en").val(custom.title_en);
	$(".news_desc_vi").val(custom.short_description_vi);
	$(".news_desc_en").val(custom.short_description_en);
   visiblenews=custom.visible;
	CKEDITOR.instances.editorcontentnews_vi.setData(custom.content_vi);
	CKEDITOR.instances.editorcontentnews_en.setData(custom.content_en);
activaTab('home-8');
});
$(".list_news_detail").on('click',".btn-show-info-remove",function () {
	  var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=anews[vt];
	bootbox.confirm("Bạn có chắc xóa tin tức "+custom.idnews+" này không?", function(result){
        if(result==true) {

            var dataSend = {
                idnews:custom.idnews
            };
          
            $(".modalshowprogess").modal("show");
            $(".tientrinhxuly").html("Đang xóa dữ liệu");
            queryData("news/delete", dataSend, function (res) {

                if (res.code == 1000) {
                     builddsnews(news_current,record);
                    $(".modalshowprogess").modal("hide");

                }else if(res.code==1001){
                    alert_info("Xóa thất bại");
                    $(".modalshowprogess").modal("hide");
                }
					$(".modalshowprogess").modal("hide");
            });


        }else
        {
            // alert_info("Lỗi");
        }
    });
});
var checkaddvideoac=0;
$(".savevideohoatdong").hide();
///////////////////////video
$(".themmoivideohoatdong").click(function () {
	checkaddvideoac=0;
	$(".savevideohoatdong").show();
	activaTab('about-7');
$(".title_topic_video").html('<i class="fa fa-plus-square-o"></i>&nbsp;Thêm chủ đề video hoạt động công ty');
});
//huy thaot ac
$(".themvideohoatdongrefesh").click(function () {
	checkaddvideoac=0;
	$(".savevideohoatdong").hide();
// builddsvideoactivity(0,record);
activaTab('about-7');
$(".title_topic_video").html('<i class="fa fa-plus-square-o"></i>&nbsp;Thêm chủ đề video hoạt động công ty');
resetViewvideoac();
});
$(".click_activityvideo").click(function () {
	
 builddsvideoactivity(0,record);
});
function builddsvideoactivity(page,record) {
    
    var dataSend={

       page:page,
	   record:record,
       
    }
   // console.log(dataSend);
    $(".list_video_activityvideo").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  
    queryData("activity/getactivityweb",dataSend,function (res) {
     
        if(res.code==1000){
	
            $(".list_video_activityvideo").html("");
            buildHTMLvideoactivityData(res);
            
        }else{
            $(".list_video_activityvideo").html("Tìm không thấy");
			$(".numberpage_activityvideo").html("");
        }
    });
}
var acvideo_current=0;
var pg=0;
$(".numberpage_activityvideo").on('click','button',function () {
    //console.log("nha"+$(this).val());
    acvideo_current=$(this).val();
   pg=$(this).val();
    builddsvideoactivity($(this).val(),record);
});
var resallactivityvideo;
function buildHTMLvideoactivityData(res) {
    
    var data = res.data.items;
   
    resallactivityvideo=data;
   
    var html='';
    var htmlts='';
    var listinffo='';
	var stt=1;
	var currentpage=parseInt(res.data.page);
    stt=printSTT(record,currentpage);
    for (item in data) {
        var list=data[item];
		var sshow="";
		var va=1;
		if(list.visible==1){
			sshow="Hiển thị";
			va=0;
		}else{
			sshow="Ẩn";
			va=1;
		}
			var video=list.urlac;
		var l='<button type="button" class="btn btn-danger click_themanhien_videolq" data-vi='+va+' data-date='+list.createdate+' data-id='+list.idac+' data-vt='+item+'><i class="fa  fa-eye-slash">&nbsp;</i>'+sshow+'</button> ';
     
		var s='<button type="button" class="btn btn-danger click_xoa_video" data-img='+list.urlac+' data-vt='+item+'><i class="fa fa-trash-o">&nbsp;</i>Xóa</button> ';
		var t='<button type="button" class="btn btn-danger click_sua_video" data-img='+list.urlac+' data-vt='+item+'><i class="fa fa-edit">&nbsp;</i>Sửa</button> ';
		var k='<button type="button" class="btn btn-danger click_them_videolq" data-img='+list.urlac+' data-vt='+item+'><i class="fa  fa-sun-o">&nbsp;</i>Chi tiết</button> ';
        html=html +'<div class="col-sm-4 col-lg-4 col-md-4" align="center">'+
                                '<div class="embed-responsive embed-responsive-16by9">'+
							'<iframe width="560" controls height="315" src="'+video+'" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>'+
								'<p>ID: '+list.idac+' </p>'+		
								'<p>Chủ đề (Vi): '+list.name_vi+' </p>'+
								  '<p>Chủ đề (En): '+list.name_en+' </p>'+
                                '<p>Ngày tạo: '+getDateTime(list.createdate)+' </p>'+
                                '<h6>'+list.urlac+' </h6>'+
								'<div>'+k+"&nbsp;"+s+"&nbsp;"+t+"&nbsp;"+l+'</div>'+
                            '</div>';
        stt++;
       
		
    }
	 $(".list_video_activityvideo").html(html);
    buildSlidePage($(".numberpage_activityvideo"),5,res.data.page,res.data.totalpage);
}
var idac=0;
var visibleac=1;
$(".list_video_activityvideo").on('click',".click_sua_video",function () {
$(".savevideohoatdong").show();
	checkaddvideoac=1;
  
    var vt=parseInt($(this).attr("data-vt"));
    var custom=resallactivityvideo[vt];
	// console.log(custom);
    idac=custom.idac;
   $(".videoac_vi").val(custom.name_vi);
	$(".videoac_en").val(custom.name_en);
	visibleac=custom.visible;
$(".videoac_link").val(custom.urlac);
activaTab('about-7');
$(".title_topic_video").html('<i class="fa fa-edit"></i>&nbsp;Sửa chủ đề video hoạt động công ty');

});
$(".savevideohoatdong").click(function () {
	if(checkaddvideoac==0){
	var videoac_vi=$(".videoac_vi").val();
	var videoac_en=$(".videoac_en").val();
	var videoac_link=$(".videoac_link").val();
	
    var dataSend={
		name_vi:videoac_vi,
		name_en:videoac_en,
		urlac:videoac_link,
		createdate:new Date().getTime(),
		idusertao:iduser,
		visible:1
    }
	   $(".modalshowprogess").modal("show");
            $(".tientrinhxuly").html("Đang thêm dữ liệu");
	queryData("activity/createvideoac",dataSend,function (res) {
       //console.log(res);
        if(res.code==1000){
			$(".modalshowprogess").modal("hide");
			alert_info("Lưu thành công chủ đề video");
			builddsvideoactivity(acvideo_current,record);
			resetViewvideoac();
		}
		else{
			alert_error("Thực hiện dữ liệu bị lỗi");
			$(".modalshowprogess").modal("hide");
		}
	});
	}else{//updateCommands
	
	var videoac_vi=$(".videoac_vi").val();
	var videoac_en=$(".videoac_en").val();
	var videoac_link=$(".videoac_link").val();
	
    var dataSend={
		name_vi:videoac_vi,
		name_en:videoac_en,
		urlac:videoac_link,
		createdate:new Date().getTime(),
		idusertao:iduser,
		idac:idac,
		visible:visibleac
     
    }
	$(".modalshowprogess").modal("show");
            $(".tientrinhxuly").html("Đang cập nhật dữ liệu");
	queryData("activity/udpatevideoac",dataSend,function (res) {
      // console.log(res);
        if(res.code==1000){
			$(".modalshowprogess").modal("hide");
			alert_info("Cập nhật thành công chủ đề video");
			builddsvideoactivity(acvideo_current,record);
			resetViewvideoac();
			checkaddvideoac=0;
		}
		else{
			$(".modalshowprogess").modal("hide");
			alert_error("Thực hiện dữ liệu bị lỗi");
		}
	});
	
	
	}
});
function resetViewvideoac()
{
	$(".savevideohoatdong").hide();
	$(".videoac_vi").val("");
	$(".videoac_en").val("");
	$(".videoac_link").val("");
}
$(".list_video_activityvideo").on('click',".click_xoa_video",function () {
	  var vt=parseInt($(this).attr("data-vt"));
    var custom=resallactivityvideo[vt];
	bootbox.confirm("Bạn có chắc xóa chủ đề "+custom.idac+" này không?", function(result){
        if(result==true) {

            var dataSend = {
                idac:custom.idac
            };
          
            $(".modalshowprogess").modal("show");
            $(".tientrinhxuly").html("Đang xóa dữ liệu");
            queryData("activity/deletevideoac", dataSend, function (res) {

                if (res.code == 1000) {
                   builddsvideoactivity(acvideo_current,record);
                    $(".modalshowprogess").modal("hide");

                }else if(res.code==1001){
                    alert_info("Xóa thất bại");
                    $(".modalshowprogess").modal("hide");
                }else if(res.code==1002){
					alert_info("Chủ đề này đang sử dụng. Không thể xóa");
				}
					$(".modalshowprogess").modal("hide");
            });


        }else
        {
            // alert_info("Lỗi");
        }
    });
});
var idaclq=0;
$(".list_video_activityvideo").on('click',".click_them_videolq",function () {
	  var vt=parseInt($(this).attr("data-vt"));
	  
	   var custom=resallactivityvideo[vt];
	   idaclq=custom.idac;
	   swapMain("videohoatdonglienquan");
	   $(".title_topic").html(custom.name_vi);
	   builddsvideoactivitylq(0,record);
});
$(".click_back_topic").click(function () {
swapMain("videohoatdong");
checkaddvideoaclq=0;
resetViewvideoaclq();
});
/// các chủ đề liên quan
var checkaddvideoaclq=0;
$(".savevideohoatdonglq").hide();
///////////////////////video
$(".themmoivideohoatdonglq").click(function () {
	checkaddvideoaclq=0;

	activaTab('home-15');
	resetViewvideoaclq();
		$(".savevideohoatdonglq").show();
	$(".title_tab").html("Thêm video liên quan");
});
//huy thaot ac
$(".themvideohoatdongrefeshlq").click(function () {
	checkaddvideoaclq=0;
	$(".savevideohoatdonglq").hide();
// builddsvideoactivity(0,record);
});
$(".click_activityvideolq").click(function () {
	
 builddsvideoactivitylq(0,record);
});

function builddsvideoactivitylq(page,record) {
    
    var dataSend={

       page:page,
	   record:record,
       idac:idaclq
    }
   // console.log(dataSend);
    $(".list_video_activityvideolq").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  
    queryData("activity/getvideoactivitybyidacweb",dataSend,function (res) {
     
        if(res.code==1000){
	
            $(".list_video_activityvideolq").html("");
            buildHTMLvideoactivitylqData(res);
            
        }else{
            $(".list_video_activityvideolq").html("Tìm không thấy");
			$(".numberpage_activityvideolq").html("");
        }
    });
}
var acvideo_currentlq=0;
$(".numberpage_activityvideolq").on('click','button',function () {
    //console.log("nha"+$(this).val());
    acvideo_currentlq=$(this).val();
 
    builddsvideoactivitylq($(this).val(),record);
});
var resallactivityvideolq;
function buildHTMLvideoactivitylqData(res) {
    
    var data = res.data.items;
   
    resallactivityvideolq=data;
   
    var html='';
    var htmlts='';
    var listinffo='';
	var stt=1;
	var currentpage=parseInt(res.data.page);
    stt=printSTT(record,currentpage);
    for (item in data) {
        var list=data[item];
		
			var video=list.urlvideo;
		var sshow="";
		var va=1;
		if(list.visible==1){
			sshow="Hiển thị";
			va=0;
		}else{
			sshow="Ẩn";
			va=1;
		}
			
		var l='<button type="button" class="btn btn-danger click_themanhien_videolq" data-vi='+va+' data-date='+list.createdatevi+' data-id='+list.idvi+' data-vt='+item+'><i class="fa  fa-eye-slash">&nbsp;</i>'+sshow+'</button> ';
     
		var s='<button type="button" class="btn btn-danger click_xoa_video" data-img='+list.urlvideo+' data-vt='+item+'><i class="fa fa-trash-o">&nbsp;</i>Xóa</button> ';
		var t='<button type="button" class="btn btn-danger click_sua_video" data-img='+list.urlvideo+' data-vt='+item+'><i class="fa fa-edit">&nbsp;</i>Sửa</button> ';
		
        html=html +'<div class="col-sm-4 col-lg-4 col-md-4" align="center">'+
                                '<div class="embed-responsive embed-responsive-16by9">'+
							'<iframe width="560" controls height="315" src="'+video+'" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>'+
                                 '<p>ID: '+list.idvi+' </p>'+
								 '<p>Chủ đề (Vi): '+list.name_vilq+' </p>'+
								  '<p>Chủ đề (En): '+list.name_enlq+' </p>'+
                                '<p>Ngày tạo: '+getDateTime(list.createdatevi)+' </p>'+
                                '<h6>'+list.urlvideo+' </h6>'+
								'<div>'+l+"&nbsp;"+s+"&nbsp;"+t+'</div>'+
                            '</div>';
        stt++;
       
		
    }
	 $(".list_video_activityvideolq").html(html);
    buildSlidePage($(".numberpage_activityvideolq"),5,res.data.page,res.data.totalpage);
}
var idvi=0;
var visiblevd=1;
$(".list_video_activityvideolq").on('click',".click_sua_video",function () {
	activaTab('home-15');
	
	$(".title_tab").html("Sửa video liên quan");
$(".savevideohoatdonglq").show();
	checkaddvideoaclq=1;
  
    var vt=parseInt($(this).attr("data-vt"));
    var custom=resallactivityvideolq[vt];
	 //console.log(custom);
    idvi=custom.idvi;
	visiblevd=custom.visible;
   $(".videoac_vilq").val(custom.name_vilq);
	$(".videoac_enlq").val(custom.name_enlq);
	
$(".videoac_linklq").val(custom.urlvideo);
});
$(".savevideohoatdonglq").click(function () {
	if(checkaddvideoaclq==0){
	var videoac_vi=$(".videoac_vilq").val();
	var videoac_en=$(".videoac_enlq").val();
	var videoac_link=$(".videoac_linklq").val();
	
    var dataSend={
		name_vilq:videoac_vi,
		name_enlq:videoac_en,
		urlvideo:videoac_link,
		createdatevi:new Date().getTime(),
		idac:idaclq,
		idusertao:iduser,
		visible:1
    }
	$(".modalshowprogess").modal("show");
            $(".tientrinhxuly").html("Đang thêm dữ liệu");
	queryData("activity/createvideoaclq",dataSend,function (res) {
       //console.log(res);
        if(res.code==1000){
			$(".modalshowprogess").modal("hide");
			alert_info("Lưu thành công video liên quan");
			builddsvideoactivitylq(acvideo_currentlq,record);
			resetViewvideoaclq();
		}
		else{
			$(".modalshowprogess").modal("hide");
			alert_error("Thực hiện dữ liệu bị lỗi");
		}
	});
	}else{//updateCommands
	
	var videoac_vi=$(".videoac_vilq").val();
	var videoac_en=$(".videoac_enlq").val();
	var videoac_link=$(".videoac_linklq").val();
	
    var dataSend={
		name_vilq:videoac_vi,
		name_enlq:videoac_en,
		urlvideo:videoac_link,
		createdatevi:new Date().getTime(),
		idac:idaclq,
		idusertao:iduser,
		idvi:idvi,
		visible:visiblevd
    }
	$(".modalshowprogess").modal("show");
    $(".tientrinhxuly").html("Đang cập nhật dữ liệu");
	queryData("activity/udpatevideoaclq",dataSend,function (res) {
      // console.log(res);
        if(res.code==1000){
			$(".modalshowprogess").modal("hide");
			alert_info("Cập nhật thành công video liên quan");
			builddsvideoactivitylq(acvideo_currentlq,record);
			resetViewvideoaclq();
			checkaddvideoaclq=0;
		}
		else{
			$(".modalshowprogess").modal("hide");
			alert_error("Thực hiện dữ liệu bị lỗi");
		}
	});
	
	
	}
});
function resetViewvideoaclq()
{
	$(".savevideohoatdonglq").hide();
	$(".videoac_vilq").val("");
	$(".videoac_enlq").val("");
	$(".videoac_linklq").val("");
}
$(".list_video_activityvideolq").on('click',".click_xoa_video",function () {
	  var vt=parseInt($(this).attr("data-vt"));
    var custom=resallactivityvideolq[vt];
	bootbox.confirm("Bạn có chắc xóa video "+custom.idvi+" này không?", function(result){
        if(result==true) {

            var dataSend = {
                idvi:custom.idvi
            };
          
            $(".modalshowprogess").modal("show");
            $(".tientrinhxuly").html("Đang xóa dữ liệu");
            queryData("activity/deletevideoaclq", dataSend, function (res) {

                if (res.code == 1000) {
                 builddsvideoactivitylq(acvideo_currentlq,record);
                    $(".modalshowprogess").modal("hide");

                }else if(res.code==1001){
                    alert_info("Xóa thất bại");
                    $(".modalshowprogess").modal("hide");
                }else if(res.code==1002){
					alert_info("Chủ đề này đang sử dụng. Không thể xóa");
				}
					$(".modalshowprogess").modal("hide");
            });


        }else
        {
            // alert_info("Lỗi");
        }
    });
});
function activaTab(tab){
    $('.nav-tabs a[href="#' + tab + '"]').tab('show');
};
//
$(".list_video_activityvideo").on('click',".click_themanhien_videolq",function () {
	 var id=($(this).attr("data-id"));
	  var vi=($(this).attr("data-vi"));
	    var date=($(this).attr("data-date"));
	 var dataSend = {
                visible:vi,
				idac:id,
				createdate:date
            };
           //console.log(dataSend);
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang cập nhật trạng thái dữ liệu");
            queryData("gioithieu/udpatevideovisible", dataSend, function (res) {
                
                if (res.code == 1000) {
                 builddsvideoactivity(pg,record);
                    
					$(".modalshowprogess").modal("hide");
                    
                }else{
					alert_info("Cập nhật thất bại");
					$(".modalshowprogess").modal("hide");
				}
				
            });
});
$(".list_video_activityvideolq").on('click',".click_themanhien_videolq",function () {
	 var id=($(this).attr("data-id"));
	  var vi=($(this).attr("data-vi"));
	    var date=($(this).attr("data-date"));
	 var dataSend = {
                visible:vi,
				idvi:id,
				createdatevi:date
            };
           //console.log(dataSend);
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang cập nhật trạng thái dữ liệu");
            queryData("gioithieu/udpatevideolqvisible", dataSend, function (res) {
                
                if (res.code == 1000) {
                 builddsvideoactivitylq(acvideo_currentlq,record);
                    
					$(".modalshowprogess").modal("hide");
                    
                }else{
					alert_info("Cập nhật thất bại");
					$(".modalshowprogess").modal("hide");
				}
				
            });
});