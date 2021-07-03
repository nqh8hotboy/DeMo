var resallsanpham;

function builddssanpham(page,record) {
    var charsearch=$(".search_sanpham").val();
	var maloaisp=$(".cbloaisp").val();
    var dataSend={
		page:page,
        record:record,
       
        charsearch:charsearch,
		maloaisp:maloaisp
    }
    
    $(".listsanpham").html("<img src='img/loading.gif' width='10px' height='10px'/>");
  
    queryData("sanpham/getallspvinattbymaloai",dataSend,function (res) {
     //  console.log(res);
        if(res.code==1000){

            $(".listsanpham").html("");
            buildHTMLsanphamData(res);
            
        }else{
            $(".listsanpham").html("Tìm không thấy");
        }
    });
}
$(".listsanpham").on('click',".click_an",function () {
	 var idsp=($(this).parents("tr").attr("data-idsp"));
	  var vi=($(this).attr("data-vi"));
	 var dataSend = {
                visible:vi,
				idsp:idsp
            };
          // console.log(dataSend);
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang cập nhật trạng thái dữ liệu");
            queryData("sanpham/udpatespvisible", dataSend, function (res) {
                
                if (res.code == 1000) {
                builddssanpham(sp_current,record);
                    
					$(".modalshowprogess").modal("hide");
                    
                }else{
					alert_info("Cập nhật thất bại");
					$(".modalshowprogess").modal("hide");
				}
				
            });
			
});
function resetViewsanpham() {
    $(".sp_masp").val("");
    $(".sp_tensp").val("");
	$(".sp_tensp_en").val("");
	 $(".sp_gia").val("0");
    $(".sp_giachuoi").val("");
	 $(".sp_giachuoi_en").val("");
	 $(".sp_tensp").val("");
	 $(".sp_tensp_en").val("");
	$(".sp_des").val("");
	$(".sp_des_en").val("");
  //  $(".chucvu_macv").removeAttr('disabled');
    $(".modalshowsanpham").attr("data-editting",false);
$(".linksanpham").html("");
$(".titlesanpham").html("<i class='fa fa-plus'></i>&nbsp; Tạo mới sản phẩm");
 $(".imguserchange_sp").attr("src",'img/up.png');
urlImagesp=[];
}
function datasendsanpham(){

    var masp=$(".sp_masp").val();
    var tensp=$(".sp_tensp").val();
	var tensp_en=$(".sp_tensp_en").val();
	  var maloaisp=$(".cb_tenloaisp").val();
	 var sp_des=$(".sp_des").val();
	 var sp_des_en=$(".sp_des_en").val();
	 var gia=$(".sp_gia").val();
	 var dvt=$(".cb_dvtinhsp").val();
	 var dvt_en=$(".cb_dvtinhsp_en").val();
	 if(gia==""){
		 gia=0;
	 }
	  var giachuoi=$(".sp_giachuoi").val();
	  if(giachuoi==""){
		  giachuoi="";
	  }
	   var giachuoi_en=$(".sp_giachuoi_en").val();
	    if(giachuoi_en==""){
		  giachuoi_en="";
	  }
	  var im="";
	  if(urlImagesp.length==0)
	  {
		  im="";
	  }else{
	  im=urlImagesp[0];
	  }
    var dataSend={
		
		masp:masp,
        tensp:tensp,
		 tensp_en:tensp_en,
		
		maloaisp:maloaisp,
		gia:gia,
		giachuoi:giachuoi,
		giachuoi_en:giachuoi_en,
		anhsp:im,
		tendvt:dvt,
		tendvt_en:dvt_en,
		desc_vi:sp_des,
		desc_en:sp_des_en,
		ispecial:1,
		visible:1
		
		
		
    }
    return dataSend;
}
$(".search_sanpham").keyup(function () {
   
    builddssanpham(0,record);
 
});
$(".cbloaisp").blur(function () {
   
    builddssanpham(0,record);
  
});
$(".cbloaisp").change(function () {
   
    builddssanpham(0,record);
  
});
$(".cbloaisp").click(function () {
   
    builddssanpham(0,record);
  
});
function buildHTMLsanphamData(res) {
    
    var data = res.data.items;
   
    resallsanpham=data;
	var stt=1;
   var currentpage=parseInt(res.data.page);
    stt=printSTT(record,currentpage);
    var html='';
    
	
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
            '<tr data-idsp="' + list.idsp + '" data-name="'+list.masp+'" data-vt="' + item + '">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
            '<td class="btn-show-info-cv">' + list.idsp + '</td>' +
			'<td class="btn-show-info-cv">' + list.masp + '</td>' +
			'<td class="btn-show-info-cv">' + list.tensp + '</td>' +
            '<td class="btn-show-info-cv">' + list.tensp_en+'</td>'+
			  '<td class="btn-show-info-cv">' + list.tenloai+'</td>'+
			  '<td class="btn-show-info-cv">' + list.tenloai_en+ '</td>'+
             '<td class="btn-show-info-cv">' + list.gia+ '</td>'+
			   '<td class="btn-show-info-cv">' + list.giachuoi+ '</td>'+
			     '<td class="btn-show-info-cv">' + list.giachuoi_en+ '</td>'+
			     '<td class="btn-show-info-cv" align="center"><img class="anhsp" style="border-radius: 50%;width: 60px;height: 40px; cursor: pointer" src='+urlLocal+list.anhsp+'></td>'+
             '<td class="btn-show-info-cv">' + s + '</td>' +
			
            '<td class="btn-show-info-suasanpham"><a href="#">  <i class="fa fa-edit"></i></a></td>' +
			 '<td class="btn-show-info-xoasanpham"><a href="#">  <i class="fa fa-remove"></i></a></td>' +
			 '<td><a href="#"> '+k+' </a></td>' +
            
            '</tr>';
        stt++;
        $(".listsanpham").html(html)
    }
    buildSlidePage($(".numberpagesanpham"),5,res.data.page,res.data.totalpage);
}
var urlImagesp=[];
$(".ip-img-user-change_sp").change(function () {
  // $(".imguserchange_sp").html("<img src='img/loading.gif' width='20px' height='20px'/>");
        var obj=$(this);
        uploadImage(obj,function (res) {
            
            if(res.code=="1000"){
				   obj.val("");
             //  $(".linksanpham").html("")
				var r1=res.data.url;
				// $(".imguserchange_sp").attr("src",urlLocal+r1.replace("./image_upload/","image_upload/"));
                urlImagesp[0]=r1.replace("./image_upload/","image_upload/");
              updateImageLink(urlImagesp,"linksanpham","imguserchange_sp","removelinksp");
            }
            else{
                alert("Upload hình lỗi! Vui lòng thử lại");
            }
        });
    });
	$(".linksanpham").on('click','.removelinksp',function () {
	
	var id=parseInt($(this).attr("data-vt"));
	
	var dataSend=
	{
		
		urllink:urlImagesp[id]
	}
	queryData('dangkysp/removellink', dataSend, function (res) {
           
			 
            if (res.code == 1000) {
                urlImagesp.splice(id,1);
              
				 updateImageLink(urlImagesp,"linksanpham","imguserchange_sp","removelinksp");
				
            } else {
				alert_error("File trên máy chủ xóa thất bại");
           
		   }
					
		
        });
});
var sp_current=0;
$(".numberpagesanpham ").on('click','button',function () {
    //console.log("nha"+$(this).val());
    sp_current=$(this).val();
    builddssanpham($(this).val(),record);
    
});

$(".btn-print-info-save-sanpham").click(function () {
    var dataSend=datasendsanpham();
 //console.log(dataSend);
    if((dataSend.masp=="")){
        alert_info("Nhập mã sản phẩm");
        $(".sp_masp").focus();
    }
    else if(dataSend.tensp==""){
        alert_info("Nhập tên  sản phẩm");
        $(".sp_tensp").focus();
    }
   else
	{
		if ($(".modalshowsanpham").attr("data-editting") == "false") {
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang thêm dữ liệu");
            queryData("sanpham/create", dataSend, function (res) {
               console.log(res);
                if (res.code == 1000) {
              $(".modalshowprogess").modal("hide");
           $(".modalshowsanpham").modal("hide");
                    builddssanpham(sp_current);
                    resetViewsanpham();
					//getsanphamData();
                } else if (res.code == 1002) {

                    alert_error("Đã trùng mã sản phẩm");
                
                  $(".modalshowprogess").modal("hide");
                    resetViewsanpham();
                } else {
					$(".modalshowprogess").modal("hide");
                    alert_error("Thêm thất bại");
                }
            });
        } else {
           
          $(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang cập nhật dữ liệu");
		  dataSend.idsp=idsp;
		 
            queryData("sanpham/updatesanpham", dataSend, function (res) {
            // console.log(res);
                if (res.code == 1000) {
                 
                    builddssanpham(sp_current);
                     resetViewsanpham();
                    $(".modalshowsanpham").modal("hide");
                    
                } else {
                    alert_error("Cập nhật thất bại");
                }
				$(".modalshowprogess").modal("hide");
            });

        }
}
});
var idsp=0;
var visiblesp=1;
$(".listsanpham").on('click',".btn-show-info-suasanpham",function () {
 
	$(".titlesanpham").html("<i class='fa fa-edit'></i>&nbsp; Sửa sản phẩm");
    $(".modalshowsanpham").attr("data-editting",true);

  

    $(".modalshowsanpham").modal("show");
     idsp=($(this).parents("tr").attr("data-idsp"));
	var masp=($(this).parents("tr").attr("data-masp"));
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resallsanpham[vt];
  // console.log( custom.kieu);
    $(".sp_masp").val(custom.masp);
    $(".sp_tensp").val(custom.tensp);
	 $(".sp_tensp_en").val(custom.tensp_en);
	$(".sp_des").val(custom.desc_vi);
	$(".sp_des_en").val(custom.desc_en);
	visiblesp=custom.visible;
	$(".cb_tenloaisp").val(custom.maloaisp);
	$(".cb_dvtinhsp").val(custom.tendvt);
	$(".cb_dvtinhsp_en").val(custom.tendvt_en);
	urlImagesp[0]=custom.anhsp;
	 updateImageLink(urlImagesp,"linksanpham","imguserchange_sp","removelinksp");
	 $(".sp_gia").val(custom.gia);
    $(".sp_giachuoi").val(custom.giachuoi);
	$(".sp_giachuoi_en").val(custom.giachuoi_en);
	
	
	

});
$(".listsanpham").on('click',".btn-show-info-xoasanpham",function () {
	 var id=($(this).parents("tr").attr("data-idsp"));
	var masp=($(this).parents("tr").attr("data-name"));
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resallsanpham[vt];
	var vt=($(this).parents("tr").attr("data-vt"));
	
	bootbox.confirm("Bạn có chắc xóa sản phẩm này không?", function(result){
        if(result==true) {
            
         var dataSend = {
                idsp:id,
				masp:masp
            };
           console.log(dataSend);
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang xóa dữ liệu");
            queryData("sanpham/deletesanpham", dataSend, function (res) {
                
                if (res.code == 1000) {
                  builddssanpham(sp_current);
					$(".modalshowprogess").modal("hide");
                    
                }else if(res.code==1002){
                    alert_info("Sản phẩm này không thể xóa. Đang sử dụng");
					$(".modalshowprogess").modal("hide");
                }else{
					alert_info("Xóa thất bại");
					$(".modalshowprogess").modal("hide");
				}
				
            });
			
			
        }else
        {
            // alert_info("Lỗi");
        }
    });
	
});