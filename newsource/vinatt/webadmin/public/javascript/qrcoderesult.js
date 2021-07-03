//console.log(getUrlParameter("idsp"));

var id=getUrlParameter("idsp");
var lang=getUrlParameter("lang");
var role=getUrlParameter("role");
var iduser=getUrlParameter("iduser");

var tem=id.split("-");
idsp=tem[1];
console.log(idsp);

if(lang==undefined)
{
	lang="vi";
}


if(role==undefined)
{
	role=0;
}


if(iduser==undefined){
	iduser=0;
 }
var snd="",ssoche="",snhavc="",snhapp="";
 if(role==0 || role==4 || role==6){//admin,nong dan, nguoi dung dieu xem san pham duoc
	builddsresult(idsp,lang);
 }else if(role==2)//nha so che
 {
	 builddsresult(idsp,lang);
	 updatesoche(idsp,iduser);
	 //update user
 }else if(role==3){//nha phan phoi
	builddsresult(idsp,lang);
	updatepp(idsp,iduser)
 }else if(role==5){ //nha van chuyen
 	builddsresult(idsp,lang);
	updatevc(idsp,iduser)
 }else if(role==1){
	 builddsresult(idsp,lang);
	//updatend(idsp,iduser)
 }
///////update nha so che va nha phan phoi
function updatesoche(idsp,iduser) {
  

    var dataSend={
		idsp:idsp,
		iduser:iduser,
		datetimejoin:new Date().getTime()
    }
 console.log(dataSend);
    //$(".listresult tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");

    queryData("dangkysp/updateallsc",dataSend,function (res) {
      console.log(res);
           
        if(res.code==1000){
  
            alert_info("Ghi nhận nhà sơ chế vào mã code thành công");
           

        }else if(res.code==1001){
			 alert_info("Đã cập nhật rồi");
		}else if(res.code==1002){
			 //alert_info("Nhà sơ chế này đã cập nhật  trong mã code này rồi");
			 ssoche="Nhà sơ chế này đã cập nhật  trong mã code này rồi";
			 $(".title_role").html("Nhà sơ chế này đã cập nhật  trong mã code này rồi");
		}
		else if(res.code==1003){
			alert_info("Tài khoản này chưa khai báo trong hệ thống");
		}
		else{
            //alert_error("Xin vui lòng kiểm tra lại kết nối mạng");
		
        }
    });
}
function updatepp(idsp,iduser) {
  

    var dataSend={
		idsp:idsp,
		iduser:iduser,
		datetimejoin:new Date().getTime()
    }

    //$(".listresult tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");

    queryData("dangkysp/updateallpp",dataSend,function (res) {
  //    console.log(res);
           
        if(res.code==1000){
  
            alert_info("Ghi nhận nhà phân phối vào mã code thành công");
           

        }else if(res.code==1001){
			 alert_info("Đã cập nhật rồi");
		}else if(res.code==1002){
			 //alert_info("Nhà phân phối này đã cập nhật  trong mã code này rồi");
			 snhapp="Nhà phân phối này đã cập nhật  trong mã code này rồi";
			  $(".title_role").html("Nhà phân phối này đã cập nhật  trong mã code này rồi");
		}
		else if(res.code==1003){
			alert_info("Tài khoản này chưa khai báo trong hệ thống");
		}
		else{
           // alert_error("Xin vui lòng kiểm tra lại kết nối mạng");
		
        }
    });
}
function updatevc(idsp,iduser) {
  

    var dataSend={
		idsp:idsp,
		iduser:iduser,
		datetimejoin:new Date().getTime()
    }

    //$(".listresult tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");

    queryData("dangkysp/updateallvc",dataSend,function (res) {
  //    console.log(res);
           
        if(res.code==1000){
  
            alert_info("Ghi nhận nhà vận chuyển vào mã code thành công");
           

        }else if(res.code==1001){
			 alert_info("Đã cập nhật rồi.");
		}else if(res.code==1002){
			// alert_info("Nhà vận chuyển đã cập nhật  trong mã code này rồi");
			snhavc="Nhà vận chuyển đã cập nhật  trong mã code này rồi";
			 $(".title_role").html("Nhà vận chuyển đã cập nhật  trong mã code này rồi");
		}
		else if(res.code==1003){
			alert_info("Tài khoản này chưa khai báo trong hệ thống");
		}
		else{
           // alert_error("Xin vui lòng kiểm tra lại kết nối mạng");
		
        }
    });
}
function updatend(idsp,iduser) {
  

    var dataSend={
		idsp:idsp,
		iduser:iduser
    }

    //$(".listresult tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");

    queryData("dangkysp/updatend",dataSend,function (res) {
  //    console.log(res);
           
        if(res.code==1000){
  
            alert_info("Ghi nhận hộ sản xuất vào mã code thành công");
           

        }else if(res.code==1001){
			 alert_info("Đã cập nhật rồi.");
		}else if(res.code==1002){
			// alert_info("Hộ sản xuất đã cập nhật  trong mã code này rồi");
			snd="Hộ sản xuất đã cập nhật trong mã code này rồi";
			$(".title_role").html("Hộ sản xuất đã cập nhật trong mã code này rồi");
		}
		else if(res.code==1003){
			alert_info("Tài khoản này chưa khai báo trong hệ thống");
		}
		else{
           // alert_error("Xin vui lòng kiểm tra lại kết nối mạng");
		
        }
    });
}
function builddsresult(idsp,lang) {
  

    var dataSend={
		idsp:idsp
    }

    $(".listresult tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");

    queryData("dangkysp/getbyid",dataSend,function (res) {
      console.log(res);
           
        if(res.code==1000){
  
            buildHTMLTraceData(res);
           

        }else{
            $(".listresult").html("Sản Phẩm Của Bạn Không Tìm Thấy Trong Hệ Thống ");
		
        }
    });
}
$(".listresult").on('click',".showup",function () {
	$(".showhideworks").empty();
});
$(".listresult").on('click',".showdown",function () {
	
	//$(".showhideworks").show();
	$(".showhideworks").html("<img src='img/loading.gif' width='20px' height='20px'/>");

    queryData("dangkysp/getallwork",{},function (res) {
      //console.log(res);
          
        if(res.code==1000){
  
            buildHTMLWorksData(res);
           

        }else{
            $(".showhideworks").html("Không tìm thấy");
		
        }
    });
});
function buildHTMLWorksData(res) {

    var data = res.data.items;

 
    var htmls='';

    var stt=1;
    for (item in data) {
        var list=data[item];
		htmls=htmls+'<div class="btn btn-xs btn-block" align="left"><div align="left" style="color:blue;" class="showdowndetail" data-idw='+list.idw+' data-vt='+item+'>'+
            list.namew+' <span class="tools pull-right" >'+
           ' <a style="color:red;" href="javascript:;" class="fa fa-chevron-down showdowndetail"  data-idw='+list.idw+' data-vt='+item+'></a>&nbsp;&nbsp;&nbsp;'+
          ' <a href="javascript:;" style="color:red;" class="fa fa-chevron-up showupdetail"></a>'+
           ' </span></div>'+
       ' </div>'+
	   
             
			  ' <div class="notification-info">'+
                   '<div class="panel-heading adddetail'+item+'">'+
           
				' </div>';
	   
	}
	$(".showhideworks").html(htmls);
}
//show chi tiet
$(".listresult").on('click',".showupdetail",function () {
		var s='adddetail'+vtchon;
		$("."+s).hide();
});
var vtchon=0;
$(".listresult").on('click',".showdowndetail",function () {
	
	var id=($(this).attr("data-idw"));
	vtchon=($(this).attr("data-vt"));
	//console.log(id);
	var s='adddetail'+vtchon;
		$("."+s).show();
	var data={
		qrcode:idsp,
		idw:id
	}
	//console.log(data);
	queryData("dangkysp/getdetailworkidw",data,function (res) {
      console.log(res);
          
        if(res.code==1000){
  
           buildHTMLDetailWorksData(res);
           

        }else{
            var s='adddetail'+vtchon;
				$("."+s).html("Lấy dữ liệu bị lỗi");
		
        }
    });
});
function buildHTMLDetailWorksData(res) {

    var data = res.data.items;

 
    var htmls='';

    var stt=1;
	if(data.length==0){
		var s='adddetail'+vtchon;
	$("."+s).html("Chưa cập nhật thông tin");
	}else{
    for (item in data) {
        var list=data[item];
		var li=JSON.parse(list.listimg);
		console.log(li);
		var h='';
		for(var i=0;i<li.length;i++){
			h=h+'<img src="'+urlLocal+li[i].limage+'" alt=""><p align="center" >'+li[i].name+'</p>';
		}
		htmls=htmls+'<header class="panel-heading">'+h+
         
         ' <p>&nbsp;</p></a>&nbsp;&nbsp;&nbsp;'+
         
           ' </span>'+
       ' </header>';
             
         
	}
	
	var s='adddetail'+vtchon;
	$("."+s).html(htmls);
	}
}
function buildHTMLTraceData(res) {

    var data = res.data.items;

 
    var html='';

    var stt=1;
    for (item in data) {
        var list=data[item];
		var l=JSON.parse(list.infoncc);
		var sp=JSON.parse(list.infosanpham);
		var mo=JSON.parse(list.mota);
		var pp=JSON.parse(list.infonpp);
		var sc=JSON.parse(list.infonsc);
		var vc=JSON.parse(list.infonvc);
		var listhinh=JSON.parse(list.listhinh);
		var htmls='';
		for(var i=0;i<listhinh.length;i++)
		{
		var img=urlLocal+listhinh[i];
		htmls=htmls+'<div class="img"><img src="'+img+'" alt=""></div><div><p>&nbsp;</p></div>';
		}
		
		var works='<div>'+
  
    '<section class="panel">'+
        '<header class="btn btn-danger btn-xs btn-block">'+
            '<b class="showdown">Thông Tin Vùng Trồng </b><span class="tools pull-right" style="color:red;">'+
           ' <a href="javascript:;" class="fa fa-chevron-down showdown"></a>&nbsp;&nbsp;&nbsp;'+
          ' <a href="javascript:;" class="fa fa-chevron-up showup"></a>'+
           ' </span>'+
       ' </header><p>&nbsp;</p>'+
        '<div class="showhideworks" align="left">'+
           
            
            
       ' </div>'+
    '</section>'+
   
'</div>';
        html=html +
		'<div class="title_role"><i style="color:red;">'+snd+ssoche+snhavc+snhapp+'  </i></div>'+
		'<div align="left"><button type="button" class="btn btn-danger btn-xs btn-block" data-idsp="'+list.idsp+'">THÔNG TIN SẢN PHẨM</button></div><div><p>&nbsp;</p></div>'+htmls+
			'<div><i class="fa fa-square-o" style="color:red;"> Mã sản phẩm: </i> '+list.idsp+'</div>'+
			   '<div><i class="fa fa-square-o" style="color:red;"> Tên sản phẩm: </i> '+sp.tensp+'</div>'+
			 '<div><i class="fa fa-square-o" style="color:red;"> Số lô: </i> '+list.lo+'</div>'+
			   '<div><i class="fa fa-square-o" style="color:red;"> Màu sắc quả: </i> '+mo.mausac+'</div>'+
				
				'<div><i class="fa fa-square-o" style="color:red;"> Ngày sản xuất: </i> '+getDate(list.ngaysx)+'</div>'+
				'<div><i class="fa fa-square-o" style="color:red;"> Ngày hết hạn: </i> '+getDate(list.hansd)+'</div>'+
				'<div><i class="fa fa-square-o" style="color:red;"> Tiêu chuẩn cơ bản của sản phẩm: </i> '+list.tccs+'</div>'+
				'<div><button type="button" class="btn btn-success btn-xs btn-block">THÔNG TIN HỘ SẢN XUẤT</button></div>'+
			     '<div><i class="fa fa-square-o" style="color:red;"> Hộ sản xuất: </i> '+l.tenncc+'</div>'+
				 '<div><i class="fa fa-square-o" style="color:red;"> Địa chỉ: </i> '+l.diachi+'</div>'+  
					'<div><i class="fa fa-square-o" style="color:red;"> Điện thoại: </i> '+l.sdt+'</div>'+
					 '<div><i class="fa fa-square-o" style="color:red;"> Số Fax: </i> '+l.sofax+'</div>'+
					 '<div><i class="fa fa-square-o" style="color:red;"> Email:</i> '+l.email+'</div>'+
					 '<div><i class="fa fa-square-o" style="color:red;"> Website </i> '+l.website+'</div>'+
					 '<div>'+works+'</div>'+
					 	 '<div><button type="button" class="btn btn-success btn-xs btn-block" data-idsp="'+list.idsp+'" ><i class="showpro "></i><b class="showdownsoche">THÔNG TIN NHÀ SƠ CHẾ</b> &nbsp;<span class="tools pull-right"><i class="fa fa-chevron-down showdownsoche" style="color:red;"></i>&nbsp;&nbsp;&nbsp;<i class="fa fa-chevron-up showupsoche" style="color:red;"></i></span></button></div>'+
						 '<div class="addnhasoche"></div>'+
						 '<div><p>&nbsp;</p></div>'+
					     '<div><button type="button" class="btn btn-success btn-xs btn-block" data-idsp="'+list.idsp+'"><i class="showprovc"></i><b class="showdownvc">THÔNG TIN NHÀ VẬN CHUYỂN</b> &nbsp;<span class="tools pull-right"><i class="fa fa-chevron-down showdownvc" style="color:red;"></i>&nbsp;&nbsp;&nbsp;<i class="fa fa-chevron-up showupvc" style="color:red;"></i></span></button></div>'+
					     '<div class="addnhavc"></div>'+
						  '<div><p>&nbsp;</p></div>'+
						 '<div><button type="button" class="btn btn-success btn-xs btn-block" data-idsp="'+list.idsp+'"><i class="showpropp"></i><b class="showdownpp">THÔNG TIN NHÀ PHÂN PHỐI</b> &nbsp;<span class="tools pull-right"><i class="fa fa-chevron-down showdownpp" style="color:red;"></i>&nbsp;&nbsp;&nbsp;<i class="fa fa-chevron-up showuppp" style="color:red;"></i></span></button></div>'+
						 '<div class="addnhapp"></div>'+
						  '<div><p>&nbsp;</p></div>'+
					 '<div><button type="button" class="btn btn-success btn-xs btn-block">THÔNG TIN KHÁC</button></div>'+
					 '<div>'+list.externallink+'</div>'+
			'<div align="left"><button type="button" class="btn btn-danger btn-xs btn-block">VINA T&T THÀNH CÔNG TỪ CHẤT LƯỢNG</button></div>';
       
        $(".listresult").html(html)
    }
  
}
/////////////nha so che
$(".listresult").on('click',".showupsoche",function () {
	$(".addnhasoche").empty();
});
///xu ly nha so che
$(".listresult").on('click',".showdownsoche",function () {
	//alert("");
	//$(".showhideworks").show();
	var idsp=$(this).parents("button").attr("data-idsp");
	$(".showpro").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  
	var dataSend={
		idsp:idsp
	}
	console.log(dataSend);
    queryData("dangkysp/getallsochejoin",dataSend,function (res) {
      console.log(res);
          
        if(res.code==1000){
  
            buildHTMLNhaSoCheData(res);
           

        }else{
            $(".showpro").html("Lỗi");
		
        }
    });
});
function buildHTMLNhaSoCheData(res) {

    var data = res.data.items;

 
    var htmls='<b style="color:blue;">Sản phẩm đã được các nhà sơ chế/chế biến:</b><br>';

    var stt=1;
    for (item in data) {
        var list=data[item];
		htmls=htmls+'<div><i class="fa fa-square-o" style="color:green;"> Cơ sở sơ chế thứ : </i> <b style="color:blue;" >'+stt+'</b></div>'+
            '<div><i class="fa fa-square-o" style="color:red;"> Cơ sở sơ chế: </i> '+list.tennsc+'</div>'+
				 '<div><i class="fa fa-square-o" style="color:red;"> Địa chỉ: </i> '+list.diachi+'</div>'+  
			'<div><i class="fa fa-square-o" style="color:red;"> Điện thoại: </i> '+list.sdt+'</div>'+
					 '<div><i class="fa fa-square-o" style="color:red;"> Số Fax: </i> '+list.sofax+'</div>'+
					 '<div><i class="fa fa-square-o" style="color:red;"> Email:</i> '+list.email+'</div>'+
					 '<div><i class="fa fa-square-o" style="color:red;"> Website </i> '+list.website+'</div>';
    
	   stt++;
	}
	$(".addnhasoche").html(htmls);
	$(".showpro").html("");
}
///////nha van chuyen
$(".listresult").on('click',".showupvc",function () {
	$(".addnhavc").empty();
});

$(".listresult").on('click',".showdownvc",function () {
	//alert("");
	//$(".showhideworks").show();
		var idsp=$(this).parents("button").attr("data-idsp");
	$(".showprovc").html("<img src='img/loading.gif' width='20px' height='20px'/>");
   
	var dataSend={
		idsp:idsp
	}
    queryData("dangkysp/getallvanchuyenjoin",dataSend,function (res) {
      console.log(res);
          
        if(res.code==1000){
  
            buildHTMLNhaVCData(res);
           

        }else{
            $(".showprovc").html("Lỗi");
		
        }
    });
});
function buildHTMLNhaVCData(res) {

    var data = res.data.items;

 
    var htmls='<b style="color:blue;">Sản phẩm đã vận chuyển qua các nhà vận chuyển:</b><br>';

    var stt=1;
    for (item in data) {
        var vc=data[item];
		htmls=htmls+'<div><i class="fa fa-square-o" style="color:green;"> Nhà vận chuyển thứ : </i> <b style="color:blue;" >'+stt+'</b></div>'+
					'<div><i class="fa fa-square-o" style="color:red;"> Tên: </i> '+vc.tennvc+'</div>'+
					'<div><i class="fa fa-square-o" style="color:red;"> Địa chỉ: </i> '+vc.diachi+'</div>'+  
					'<div><i class="fa fa-square-o" style="color:red;"> Điện thoại: </i> '+vc.sdt+'</div>'+
					 '<div><i class="fa fa-square-o" style="color:red;"> Số Fax: </i> '+vc.sofax+'</div>'+
					 '<div><i class="fa fa-square-o" style="color:red;"> Email:</i> '+vc.email+'</div>'+
					 '<div><i class="fa fa-square-o" style="color:red;"> Website </i> '+vc.website+'</div>'+
					 '<div><i class="fa fa-square-o" style="color:red;"> Tài xế: </i> '+vc.nametx+'</div>'+
					   '<div><i class="fa fa-square-o" style="color:red;"> Số ĐT: </i> '+vc.phonetx+'</div>'+
					    '<div><i class="fa fa-square-o" style="color:red;"> Biển số:</i> '+vc.biensopt+'</div>';
    
	   stt++;
	}
	$(".addnhavc").html(htmls);
	$(".showprovc").html("");
}
///////nha van chuyen
$(".listresult").on('click',".showuppp",function () {
	$(".addnhapp").empty();
});

$(".listresult").on('click',".showdownpp",function () {
	//alert("");
	//$(".showhideworks").show();
	var	idsp=$(this).parents("button").attr("data-idsp");
	$(".showpropp").html("<img src='img/loading.gif' width='20px' height='20px'/>");
 
	var dataSend={
		idsp:idsp
	}
    queryData("dangkysp/getallphanphoijoin",dataSend,function (res) {
      console.log(res);
          
        if(res.code==1000){
  
            buildHTMLNhaPPData(res);
           

        }else{
            $(".showpropp").html("Lỗi");
		
        }
    });
});
function buildHTMLNhaPPData(res) {

    var data = res.data.items;

 
    var htmls='<b style="color:blue;">Sản phẩm đã được phân phối qua các nhà phân phối:</b><br>';

    var stt=1;
    for (item in data) {
        var pp=data[item];
		htmls=htmls+'<div><i class="fa fa-square-o" style="color:green;"> Nhà phân phối thứ : </i> <b style="color:blue;" >'+stt+'</b></div>'+
				'<div><i class="fa fa-square-o" style="color:red;"> Cơ sở phân phối: </i> '+pp.tennpp+'</div>'+
				 '<div><i class="fa fa-square-o" style="color:red;"> Địa chỉ: </i> '+pp.diachi+'</div>'+  
			'<div><i class="fa fa-square-o" style="color:red;"> Điện thoại: </i> '+pp.sdt+'</div>'+
					 '<div><i class="fa fa-square-o" style="color:red;"> Số Fax: </i> '+pp.sofax+'</div>'+
					 '<div><i class="fa fa-square-o" style="color:red;"> Email:</i> '+pp.email+'</div>'+
					 '<div><i class="fa fa-square-o" style="color:red;"> Website </i> '+pp.website+'</div>';//
    
	   stt++;
	}
	$(".addnhapp").html(htmls);
	$(".showpropp").html("");
}