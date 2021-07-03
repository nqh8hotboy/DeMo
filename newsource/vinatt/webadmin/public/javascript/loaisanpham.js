

	
var oj=JSON.parse(localStorage.getItem("userVINATT"));
 

if(oj!=null || oj!=undefined){
	
		$(".nameuserdropdown").html("&nbsp;" +oj.username);
		
}
else{
		window.location.href ="login.html";
}
var resallloaisp;

function builddsloaisp(page,record) {
    
    var dataSend={

       page:page,
	   record:record,
        charsearch:""
    }
   // console.log(dataSend);
    $(".listloaisp").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  
    queryData("loaisp/getloaidm",dataSend,function (res) {
       console.log(res);
        if(res.code==1000){
	//	console.log(res);
            $(".listloaisp").html("");
            buildHTMLloaispData(res);
            
        }else{
            $(".listloaisp").html("Tìm không thấy");
			$(".numberpage_loaisp").html("");
        }
    });
}
function resetViewloaisp() {
    $(".loaisp_maloai").val("");
    $(".loaisp_tenloai").val("");
	$(".loaisp_tenloai_en").val("");
  //  $(".chucvu_macv").removeAttr('disabled');
    $(".modalshowloaisp").attr("data-editting",false);
$(".imguserchange_loaisp").attr("src",'./img/up.png');
urlImageloaisp="";
$(".titleloaisp").html("<i class='fa fa-plus'></i>&nbsp; Tạo mới loại sản phẩm");
  $(".loaisp_maloai").attr('disabled',false);
}


function buildHTMLloaispData(res) {
    
    var data = res.data.items;
   
    resallloaisp=data;
   
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
			img=urlLocal+list.hinhanh;
		}
        html=html +
            '<tr data-maloai="' + list.maloai + '"data-name="'+list.maloai+'  "data-vt="' + item + '">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
            '<td class="btn-show-info-cv">' + list.maloai + '</td>' +
            '<td class="btn-show-info-cv">' + list.tenloai+ '</td>'+
			'<td class="btn-show-info-cv">' + list.tenloai_en+ '</td>'+
            '<td class="btn-show-info-cv" align="center"><img class="anhsp" style="border-radius: 40%;width: 70px;height: 40px; cursor: pointer" src='+img+'></td>'+
              
            '<td class="btn-show-info-sualoaisp"><a href="#">  <i class="fa fa-edit"></i></a></td>' +
			
            
            '</tr>';
        stt++;
        $(".listloaisp").html(html);
		
    }
	
    buildSlidePage($(".numberpage_loaisp"),5,res.data.page,res.data.totalpage);
}
var loaisp_current=0;
$(".numberpage_loaisp ").on('click','button',function () {
    //console.log("nha"+$(this).val());
    loaisp_current=$(this).val();
 
    builddsloaisp($(this).val(),record);
});
var urlImageloaisp="";
$(".ip-img-user-change_loaisp").change(function () {
   $(".linkloaisanpham").html("<img src='img/loading.gif' width='20px' height='20px'/>");
        var obj=$(this);
        uploadImage(obj,function (res) {
            console.log(res);
            if(res.code=="1000"){
               $(".linkloaisanpham").html("")
				var r1=res.data.url;
				 $(".imguserchange_loaisp").attr("src",urlLocal+r1.replace("./image_upload/","image_upload/"));
                urlImageloaisp=r1.replace("./image_upload/","image_upload/");
              
            }
            else{
                alert("Upload hình lỗi! Vui lòng thử lại");
            }
        });
    });
function datasendloaisanpham(){

    var maloai=$(".loaisp_maloai").val();
    var tenloai=$(".loaisp_tenloai").val();
 
    var tenloai_en=$(".loaisp_tenloai_en").val();
 
    var dataSend={
		maloai:maloai,
        tenloai:tenloai,
		tenloai_en:tenloai_en,
		
		hinhanh:urlImageloaisp
		
    }
    return dataSend;
}
$(".btn-print-info-save-loaisp").click(function () {
    var dataSend=datasendloaisanpham();
	console.log(dataSend);
    if((dataSend.maloai=="")){
        alert_info("Nhập mã loại sản phẩm");
        $(".loaisp_maloai").focus();
    }
    else if(dataSend.tenloai==""){
        alert_info("Nhập tên loại sản phẩm");
        $(".sanpham_tenloai").focus();
    }
    else
	{
		if ($(".modalshowloaisp").attr("data-editting") == "false") {
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang thêm dữ liệu");
            queryData("loaisp/create", dataSend, function (res) {
                console.log(res);
                if (res.code == 1000) {
              $(".modalshowprogess").modal("hide");
           $(".modalshowloaisp").modal("hide");
                    builddsloaisp(loaisp_current,record);
                    resetViewloaisp();
					//getsanphamData();
                } else if (res.code == 1002) {

                    alert_error("Đã trùng mã loại sản phẩm");
                
                  $(".modalshowprogess").modal("hide");
                    resetViewloaisp();
                } else {
					$(".modalshowprogess").modal("hide");
                    alert_error("Thêm thất bại");
                }
            });
        } else {
           
          $(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang cập nhật dữ liệu");
            queryData("loaisp/updatelsp", dataSend, function (res) {
             
                if (res.code == 1000) {
                 
                     builddsloaisp(loaisp_current,record);
                     resetViewloaisp();
                    $(".modalshowloaisp").modal("hide");
                    
                } else {
                    alert_error("Cập nhật thất bại");
                }
				$(".modalshowprogess").modal("hide");
            });

        }
}
});
$(".listloaisp").on('click',".btn-show-info-sualoaisp",function () {

	$(".titleloaisp").html("<i class='fa fa-edit'></i>&nbsp; Sửa loại sản phẩm");
    $(".modalshowloaisp").attr("data-editting",true);

    $(".loaisp_maloai").attr('disabled','disabled');
 
    $(".modalshowloaisp").modal("show");
    var maloai=($(this).parents("tr").attr("data-maloai"));
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resallloaisp[vt];
    
    $(".loaisp_maloai").val(custom.maloai);
    $(".loaisp_tenloai").val(custom.tenloai);
	 $(".loaisp_tenloai_en").val(custom.tenloai_en);
	
	urlImageloaisp=custom.hinhanh;
	//console.log(urlImageloaisp);
	
	if(custom.hinhanh==""){
		 $(".imguserchange_loaisp").attr("src","images/up.png");
	}
	else{
    $(".imguserchange_loaisp").attr("src",urlLocal+custom.hinhanh);
	}

});