$(".showhide").hide();
 
$(".work_date").val(getDateTimeFromDate(new Date().getTime()));
 
var p=0;

var iduser=getUrlParameter("iduser");
getListQRCode("cb_qrcode",iduser);
getListWork("cb_listwork");
var qrcode="";
$(".click_chon").click(function () {
	statuschon=1;
	$(".showhide").show();
	var idworks=parseInt($(".cb_listwork").val());
	idwork=idworks;
	qrcode=$(".cb_qrcode").val();
	awork=[];
	 iddetailwork=0;
	newcreatework();
 
});

var urlwordhinh=[];
var namework="";
var datework="";
var resdata;
var vitrichoncreate=0;
var statuschon=0;//chưa tạo
function showworks(id){
	 var dataSend={

       
        id:id
    }
 
    $(".link_work_image").html("<img src='img/loading.gif' width='20px' height='20px'/>");
 
    queryData("dangkysp/getdetailwork",dataSend,function (res) {
     //console.log(res);
        if(res.code==1000){
			 var data = res.data.items;
			 if(data.length==0){
				 $(".link_work_image").html("");
				 statuschon=0;
			 }else{
			 //console.log(data);
			 $(".link_tip").html("Ghi nhận công việc ngày hôm nay của bạn");
			 resdata=data;
			  var currentpage=parseInt(res.data.page);
				stt=printSTT(record,currentpage);
			 for (item in data) {
			  var list=data[item];	
				var listhinh=JSON.parse(list.listimg);
			//	console.log(listhinh);
               lis=listhinh;
			   namework=list.namebatch;
			   datework=list.createdate;
			    vitrichoncreate=item;
				updateImageLinkWork(qrcode,list.namebatch,list.createdate,listhinh,"link_work_image","imguserchange_anhwork","removelinkwork","savelinkwork");
			
			 }
			 }
			  //buildSlidePage($(".numberpageworks"),5,res.data.page,res.data.totalpage);
        }else{
            $(".link_work_image").html("Chưa cập nhật thông tin");
		//tao cong viec cho nguoi nong dan
        }
		
		
    });
}
var iddetailwork=0;
function newcreatework(){
	
		var dataSend=datasendwork();
 
		console.log(dataSend);
		
            queryData("dangkysp/creatework", dataSend, function (res) {
             //  console.log(res);
                if (res.code == 1000) {
					iddetailwork=res.data;
					//alert_info("Lưu thành công");
					//console.log(iddetailwork);
					 showworks(iddetailwork);
				}else{
					//alert_error("Công việc này đã thực hiện rồi.");
					//showworks(page_num_work,record,qrcode,idwork);
				}
				
			})
}
var urllinksetupimagework=[];
function datasendwork(){
var ngaywork=moment($(".work_date").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
	var idw=  $(".cb_listwork").val();
	//var name_image=   $(".name_image").val();
 
	var dataSend={
		
		createdate:ngaywork,
		idwork:idw,
		namebatch:"",
		
		listimg:JSON.stringify(urllinksetupimagework),
		qrcode:qrcode,
		urlpdf:"",
		type:0,
		othercontent:""
	}
 
    return dataSend;
}

			

var idwork=0;
$(".cb_listwork").click(function () {
	var idworks=parseInt($(".cb_listwork").val());
	idwork=idworks;
	qrcode=$(".cb_qrcode").val();
	awork=[];
  //showworks(0,record,iddetailwork);
    
});
$(".cb_qrcode").click(function () {
	var idworks=parseInt($(".cb_listwork").val());
	idwork=idworks;
	qrcode=$(".cb_qrcode").val();
 // showworks(0,record,iddetailwork);
    
});
/////
function updateImageLinkWork(qrcode,name,date,urlartical,linkurl,imgchange,objremove,objectsave){
	var html="";
			for(var i=0;i<urlartical.length;i++){
				
				var l="l"+i;
				var m=imgchange+i;
				html=html+"<img class='"+m+"' data-url='' style='width: 300px;height:250px; cursor: pointer' src=''><i class='"+l+"'></i>&nbsp;&nbsp;&nbsp;";
							
			
			}
				$("."+linkurl).html('<div><button type="button" class="btn btn-round btn-danger removelinkworkcreate" data-vt='+i+' data-itemp='+i+'><i  class="fa fa-trash-o">&nbsp;Xóa công việc</i></button></div><div portlet-content table-responsive>IDSP:'+qrcode+'<br> Ngày tạo công việc:'+getDateTime(date)+'</div>'+html);
			var s="";
			var b="name_img"
			for(var i=0;i<urlartical.length;i++){
				v=b+i;
				$(".l"+i).html("<textarea class='form-control "+v+"'  placeholder='Mô tả thông tin'>"+urlartical[i].name+"</textarea><p>&nbsp;</p><button type='button' class='btn btn-round btn-info'><i data-vt='"+i+"' class='fa fa-trash-o "+objremove+"'>&nbsp;Xóa ảnh</i></button>&nbsp;&nbsp;<button type='button' class='btn btn-round btn-info'><i data-vt='"+i+"' class='fa fa-save "+objectsave+"'>&nbsp;Lưu thay đổi</i></button><br>");
				 $("."+imgchange+i).attr("src",urlLocal+urlartical[i].limage);
				$("."+imgchange+i).attr("data-url",urlLocal+urlartical[i].limage);
			
			
			}
}
var lis=[];
$(".link_work_image").on('click','.removelinkwork',function () {
	//vi tri trong anh
	var vt=parseInt($(this).attr("data-vt"));
	var cu=resdata[0];
//	console.log(cu);
	 lis=[];
	if(cu.listimg.length==0)
	{
		lis=[];
	}else{
	lis=(JSON.parse(cu.listimg));
	}
	var dataSend=
	{
		
		urllink:JSON.parse(cu.listimg)[vt].limage
	}
	//console.log(dataSend);
	
	queryData('dangkysp/removellink', dataSend, function (res) {
           
			
            if (res.code == 1000) { //khi xoa thanh cong 
				
                  lis.splice(vt,1);
              
			 updateImageLinkWork(qrcode,namework,datework,lis,"link_work_image","imguserchange_anhwork","removelinkwork","savelinkwork");
				//update lai database san pham
				//urlwordhinh[0]=r1.replace("./image_upload/","image_upload/");
			var ngaywork=moment($(".work_date").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
				var dataSend=
				{
		
					
					id:cu.id,
					listhinh:JSON.stringify(lis),
					createdate:ngaywork
				}
				//console.log(dataSend);
				queryData('dangkysp/updatedetailwork_batch', dataSend, function (res) {
					 // console.log("Thành công"+lis);
					  showworks(cu.id);
				});
            } else {
				alert_error("File trên máy chủ xóa thất bại");
           
		   }
					
		
        });
		
});
//xoa công việc
$(".link_work_image").on('click','.removelinkworkcreate',function () {
	//vi tri trong anh
	var vt=vitrichoncreate;
	
	//vi tri cha
	//var vtp=parseInt($(this).attr("data-itemp"));
	var cu=resdata[vt];
	console.log(cu);
	
			var ngaywork=moment($(".work_date").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
				var dataSend=
				{
		
					id:cu.id
					
				}
				//console.log(dataSend);
				queryData('dangkysp/deletedetailwork', dataSend, function (res) {
					if(res.code==1000)
					{
					  showworks(cu.id);
   
					}
					else{
						alert_info("Xóa thất bại");
					}
				});
            
					
		
        
		
});
//update anh vao trong cong viec
var awork=[];//luu tung cong viec
$(".ip-img-user-change_anhwork").change(function () {
	if(statuschon==0){
		alert_info("Xin vui lòng chọn chọn tạo công việc mới");
	}else{
	if(lis.length==0){
		//awork=[];
	}else{
		//console.log(lis);
		//awork.push(urlwordhinh);
		awork=lis;
		
	}
	//console.log(awork);
//	console.log(resdata[0].listimg);
//	awork=resdata[0].listimg.limage;
	// showworks(page_num_work,record,qrcode,idwork);
    var obj=$(this);
		var idw=$(".cb_listwork").val();
		var idsp=$(".cb_qrcode").val();
		if(idw==undefined || idw==null ||idw=="")
		{
			alert_info("Chọn Tên công việc");
		}else if(idsp==undefined || idsp==null || idsp==""){
			alert_info("Chọn Mã sản phẩm");
		}else{
			uploadImage(obj,function (res) {
    	 //JSON.stringify(urlwordhinh)
        if(res.code=="1000"){
			  obj.val("");
			var r1=res.data.url;
			
					//urlwordhinh[0]=r1.replace("./image_upload/","image_upload/");
			var ob={
					name:"",
					date_update_img:new Date().getTime(),
					limage:r1,
					lat:lat,
					lng:lng
				}
				awork.push(ob);
				
				//console.log(awork);
				var ngaywork=moment($(".work_date").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
           var dataSend=
				{
					id:iddetailwork,
					listhinh:JSON.stringify(awork),
					createdate:ngaywork
				}
				//console.log(dataSend);
				queryData('dangkysp/updatedetailwork_batch', dataSend, function (res) {
				//	console.log(res);
					  showworks(res.data.id);
					  awork=[];
				});
			

        }
        else{
            alert("Upload hình lỗi! Vui lòng thử lại");
        }
		});
		}
	}
});
//thuc hien luu cong viec
$(".link_work_image").on('click','.savelinkwork',function () {
	//vi tri trong anh
	var vt=parseInt($(this).attr("data-vt"));
	var cu=resdata[0];
	var leng=0;

	 var listem=[];
	if(cu.listimg.length==0)
	{
		
	}else{
	lis=(JSON.parse(cu.listimg));
	listem=(JSON.parse(cu.listimg));
	leng=lis.length;
	}
	
	var vl="name_img"+vt;
	
	
	 //lis.splice(vt,1);//remove vitri
	 var ob={
		 name:$("."+vl).val(),
		 date_update_img:listem[vt].date_update_img,
		 limage:listem[vt].limage,
		  lat:listem[vt].lat,
		 lng:listem[vt].lng
	 }
//	  console.log(lis);
	 lis[vt]=ob;
	// console.log(lis);
	 
	
			var ngaywork=moment($(".work_date").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
				var dataSend=
				{
		
					
					id:cu.id,
					listhinh:JSON.stringify(lis),
					createdate:ngaywork
				}
				//console.log(dataSend);
				 $("."+vl).html("<img src='img/loading.gif' width='20px' height='20px'/>");
				queryData('dangkysp/updatedetailwork_batch', dataSend, function (res) {
					 // console.log("Thành công"+lis);
					 if(res.code==1000){
						 alert_info("Cập nhật thành công");
					 showworks(cu.id);
					 $("."+vl).html("");
					
					 }else{
						  alert_info("Cập nhật thất bại");
					 }
					 
				});
            
		
});
//tab2
//////////////
var idworkpreview=0;
var qrcodepreview=0;

$(".click_xemlaiwork").click(function () {
	getListWork("cbpre_listwork");
	getListQRCode("cbpre_qrcode",iduser);
	var idworks=parseInt($(".cb_listwork").val());

	var qrcode=$(".cb_qrcode").val();
	
 idworkpreview=idworks;
 qrcodepreview=qrcode;
  $(".list_works_famers").html("");
 showallworks(0,record,idworkpreview,qrcodepreview);
});
$(".click_chonxem").click(function () {
	getListWork("cbpre_listwork");
	getListQRCode("cbpre_qrcode",iduser);
	var idworks=$(".cbpre_listwork").val();

	var qrcode=$(".cbpre_qrcode").val();
	
 idworkpreview=idworks;
 qrcodepreview=qrcode;
  $(".list_works_famers").html("");
 
 showallworks(0,record,idworks,qrcode);
});
var resdataall;
function showallworks(page,record,idwork,idsp){
	 var dataSend={

       page:page,
	   record:record,
        qrcode:idsp,
		idwork:idwork
    }
 
    $(".list_works_famers_pro").html("<img src='img/loading.gif' width='20px' height='20px'/>");
 
    queryData("dangkysp/getallworks",dataSend,function (res) {
     console.log(res);
        if(res.code==1000){
			 var data = res.data.items;
			
			 resdataall=data;
			  var currentpage=parseInt(res.data.page);
				stt=printSTT(record,currentpage);
				 var k='';
			 for (item in data) {
				var html='';
			
			  var list=data[item];	
				var listhinh=JSON.parse(list.listimg);
				console.log(listhinh);
           
			  datework=list.createdate;
				html=html+'<div align="center" class="col-lg-4 col-md-4 col-sm-4"><!--<button type="button" class="btn btn-round btn-danger removelinkwork" data-vt='+item+' data-itemp='+item+'><i  class="fa fa-trash-o">&nbsp;Xóa công việc</i></button>&nbsp;<button type="button" class="btn btn-round btn-danger addlinkwork" data-vt='+item+' data-itemp='+item+'><i  class="fa fa-plus-square-o">&nbsp;Thêm công việc</i></button>--><h4>Ngày tạo:'+getDateTime(list.createdate)+'</h4>';
			var htmls='';
			var b="name_img_admin"+item;
			var c="name_ob_admin";
			var d="name_save";
			for(var j=0;j<listhinh.length;j++){
				v=b+j;
				objremove=c+j;
				objectsave=d+j;
				var pa=urlLocal+listhinh[j].limage;
				htmls=htmls+'<div  ><img src='+pa+' style="width:350px;height:350px; cursor: pointer"  alt="anh"><textarea  class="form-control '+v+'">'+listhinh[j].name+'</textarea></div><!-- <div><button type="button" class="btn btn-round btn-info"><i data-vt='+j+' data-vtpa='+item+' class="fa fa-trash-o removelinkwork_admin '+objremove+'">&nbsp;Xóa ảnh</i></button>&nbsp;<button type="button" class="btn btn-round btn-info"><i data-vt='+j+' data-vtpa='+item+' class="fa fa-save savelinkwork_admin '+objectsave+'">&nbsp;Lưu thay đổi</i></button></div> -->';
			}
			 k=k+html+htmls+"<div style='background-Color:red;'></div></div>";
			
			 }
			  $(".list_works_famers").html(k);
			  $(".list_works_famers_pro").html("");
			  buildSlidePage($(".numberpage_works_famers"),5,res.data.page,res.data.totalpage);
        }else{
            $(".list_works_famers").html("Chưa cập nhật thông tin công việc");
			$(".list_works_famers_pro").html("");
		//tao cong viec cho nguoi nong dan
		$(".numberpage_works_famers").html("");
        }
		
		
    });
}
var numpage_detailwork=0;
$(".numberpage_works_famers").on('click','button',function () {
//	$(".list_works_famers").html("");
	numpage_detailwork=$(this).val();
   showallworks($(this).val(),record,idworkpreview,qrcodepreview);
   

});

$(".click_thuchienwork").click(function () {
	
	 $(".work_date").val(getDateTimeFromDate(new Date().getTime()));
	
 
});
$(".list_works_famers").on('click','.removelinkwork',function () {
	//vi tri trong anh
	var vt=parseInt($(this).attr("data-vt"));
	
	//vi tri cha
	var vtp=parseInt($(this).attr("data-itemp"));
	var cu=resdataall[vtp];
	console.log(cu);
	
			var ngaywork=moment($(".work_date").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
				var dataSend=
				{
		
					id:cu.id
					
				}
				//console.log(dataSend);
				queryData('dangkysp/deletedetailwork', dataSend, function (res) {
					if(res.code==1000)
					{
					  showallworks(numpage_detailwork,record,idworkpreview,qrcodepreview);
   
					}
					else{
						alert_info("Xóa thất bại");
					}
				});
            
					
		
        
		
});

//thuc hien xoa trong anh
$(".list_works_famers").on('click','.savelinkwork_admin',function () {
	//vi tri trong anh
	var vtpa=parseInt($(this).attr("data-vtpa"));
	console.log(vtpa);
	var vt=parseInt($(this).attr("data-vt"));
	console.log(vt);
	var cu=resdataall[vtpa];
	console.log(cu);
	
	var leng=0;

	 var listem=[];
	if(cu.listimg.length==0)
	{
		
	}else{
	lis=(JSON.parse(cu.listimg));
	listem=(JSON.parse(cu.listimg));
	leng=lis.length;
	}
	
	var vl="name_img_admin"+vtpa+vt;
	
	
	 //lis.splice(vt,1);//remove vitri
	 var ob={
		 name:$("."+vl).val(),
		 date_update_img:listem[vt].date_update_img,
		 limage:listem[vt].limage,
		 lat:listem[vt].lat,
		 lng:listem[vt].lng
		 
	 }
  
	 lis[vt]=ob;
//	 console.log(lis);
	 
	
			var ngaywork=moment($(".work_date").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
				var dataSend=
				{
		
					
					id:cu.id,
					listhinh:JSON.stringify(lis),
					createdate:ngaywork
				}
				//console.log(dataSend);
				 $("."+vl).html("<img src='img/loading.gif' width='20px' height='20px'/>");
				queryData('dangkysp/updatedetailwork_batch', dataSend, function (res) {
					 // console.log("Thành công"+lis);
					 if(res.code==1000){
						 alert_info("Cập nhật thành công");
					 showallworks(numpage_detailwork,record,idworkpreview,qrcodepreview);
					 $("."+vl).html("");
					 }else{
						  alert_info("Cập nhật thất bại");
					 }
				});
        
		
});
$(".list_works_famers").on('click','.removelinkwork_admin',function () {
	//vi tri trong anh
	var vtpa=parseInt($(this).attr("data-vtpa"));
	console.log(vtpa);
	var vt=parseInt($(this).attr("data-vt"));
	console.log(vt);
	var cu=resdataall[vtpa];
	console.log(cu);
	
	 lis=[];
	if(cu.listimg.length==0)
	{
		lis=[];
	}else{
	lis=(JSON.parse(cu.listimg));
	}
	var dataSend=
	{
		
		urllink:JSON.parse(cu.listimg)[vt].limage
	}
	//console.log(dataSend);
	
	queryData('dangkysp/removellink', dataSend, function (res) {
           
			
            if (res.code == 1000) { //khi xoa thanh cong 
				
                  lis.splice(vt,1);
              
			 //updateImageLinkWork(qrcode,namework,datework,lis,"link_work_image","imguserchange_anhwork","removelinkwork","savelinkwork");
				//update lai database san pham
				//urlwordhinh[0]=r1.replace("./image_upload/","image_upload/");
			var ngaywork=moment($(".work_date").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
				var dataSend=
				{
		
					
					id:cu.id,
					listhinh:JSON.stringify(lis),
					createdate:ngaywork
				}
				//console.log(dataSend);
				queryData('dangkysp/updatedetailwork_batch', dataSend, function (res) {
					if(res.code==1000){
						
					 showallworks(numpage_detailwork,record,idworkpreview,qrcodepreview);
					  alert_info("Xóa thành thành công");
					 $("."+vl).html("");
					 }else{
						  alert_info("Xóa thất bại");
					 }
				});
            } else {
				alert_error("File trên máy chủ xóa thất bại");
           
		   }
					
		
        });
		
});
////
var lat=0.0;
var lng=0.0;
function initGeolocation()
     {
        if( navigator.geolocation )
        {
           // Call getCurrentPosition with success and failure callbacks
           navigator.geolocation.getCurrentPosition( success, fail );
        }
        else
        {
           alert("Sorry, your browser does not support geolocation services.");
        }
     }

     function success(position)
     {

         lat= position.coords.longitude;
         lng= position.coords.latitude
     }

     function fail()
     {
        // Could not obtain location
     }

/////////////
var addawork=[];//luu tung cong viec
$(".ip-img-user-change_anhwork_add").change(function () {
	
	 var obj=$(this);
	uploadImage(obj,function (res) {
    	 //JSON.stringify(urlwordhinh)
        if(res.code=="1000"){
			  obj.val("");
			var r1=res.data.url;
			//addawork=r1;
			
		
			var ob={
					name:$(".w_mota").val(),
					date_update_img:new Date().getTime(),
					limage:r1,
					lat:lat,
					lng:lng
				}
				addawork.push(ob);
				
				//console.log(awork);
				var ngaywork=moment($(".work_date").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
           var dataSend=
				{
					id:idaddthem,
					listhinh:JSON.stringify(addawork),
					createdate:date_old
				}
				//console.log(dataSend);
				queryData('dangkysp/updatedetailwork_batch', dataSend, function (res) {
				//	console.log(res);
					  showallworks(numpage_detailwork,record,idworkpreview,qrcodepreview);
					  alert_info("Thêm mới công việc thành công");
					  addawork=[];
					   $(".modalshowaddworks").modal("hide");
				});
			

        }
        else{
            alert("Upload hình lỗi! Vui lòng thử lại");
        }
		});
		
	
});
var idaddthem=0;
var date_old;
$(".list_works_famers").on('click','.addlinkwork',function () {
	//vi tri trong anh
	var vt=parseInt($(this).attr("data-vt"));
	
	//vi tri cha
	var vtp=parseInt($(this).attr("data-itemp"));
	var cu=resdataall[vtp];
	//console.log(cu);
	idaddthem=cu.id;
	addawork=JSON.parse(cu.listimg);
	//console.log(addawork);
	date_old=cu.createdate;
	//console.log(cu);
	 $(".w_mota").val("");
	 $(".modalshowaddworks").modal("show");
	 /*
			var ngaywork=moment($(".work_date").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
				var dataSend=
				{
		
					id:cu.id
					
				}
				//console.log(dataSend);
				queryData('dangkysp/deletedetailwork', dataSend, function (res) {
					if(res.code==1000)
					{
					  showallworks(numpage_detailwork,record,idworkpreview,qrcodepreview);
   
					}
					else{
						alert_info("Xóa thất bại");
					}
				});
            
					
		
        */
		
});