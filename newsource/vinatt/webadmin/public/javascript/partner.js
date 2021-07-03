var resallpartner;

function builddspartner(page,record) {
    
    var dataSend={

       page:page,
	   record:record,
        charsearch:""
    }
   // console.log(dataSend);
    $(".listpartner").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  
    queryData("gioithieu/getpartner",dataSend,function (res) {
     //  console.log(res);
        if(res.code==1000){
	//	console.log(res);
            $(".listpartner").html("");
            buildHTMLpartnerData(res);
            
        }else{
            $(".listpartner").html("Tìm không thấy");
			$(".numberpage_partner").html("");
        }
    });
}
function resetViewpartner() {
    $(".par_name").val("");
    $(".par_link").val("");
	
    $(".modalshowpartner").attr("data-editting",false);
$(".imguserchange_partner").attr("src",'./img/up.png');
urlImagepartner="";
$(".titlepartner").html("<i class='fa fa-plus'></i>&nbsp; Tạo mới đối tác");
 // $(".loaisp_maloai").attr('disabled',false);
}


function buildHTMLpartnerData(res) {
    
    var data = res.data.items;
   
    resallpartner=data;
   
    var html='';
    var htmlts='';
    var listinffo='';
	var stt=1;
	var currentpage=parseInt(res.data.page);
    stt=printSTT(record,currentpage);
    for (item in data) {
        var list=data[item];
		var img='img/no_image.png';
        if(list.logo==""){
			img='img/no_image.png';
		}else{
			img=urlLocal+list.logo;
		}
		var s="Hiển thị";
		var k='';
		if(list.visible==1){
			k='<button type="button" class="btn btn-danger click_an" data-vi="0">Ẩn</button>';
		}else{
			s="Ẩn";
			k='<button type="button" class="btn btn-danger click_an" data-vi="1">Hiển thị</button>';
		}
        html=html +
            '<tr data-id="' + list.id + '"data-name="'+list.name+'  "data-vt="' + item + '">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
           
            '<td class="btn-show-info-cv">' + list.name+ '</td>'+
			'<td class="btn-show-info-cv">' + list.link+ '</td>'+
			 '<td class="btn-show-info-cv">' + s + '</td>' +
            '<td class="btn-show-info-cv" align="center"><img class="anhsp" style="border-radius: 40%;width: 70px;height: 40px; cursor: pointer" src='+img+'></td>'+
              
            '<td class="btn-show-info-editpartner"><a href="#">  <i class="fa fa-edit"></i></a></td>' +
			
            '<td class="btn-show-info-removepartner"><a href="#">  <i class="fa fa-remove"></i></a></td>' +
			 '<td><a href="#"> '+k+' </a></td>' +
            '</tr>';
        stt++;
        $(".listpartner").html(html);
		
    }
	
    buildSlidePage($(".numberpage_partner"),5,res.data.page,res.data.totalpage);
}
var partner_current=0;
$(".numberpage_partner ").on('click','button',function () {
    //console.log("nha"+$(this).val());
    partner_current=$(this).val();
 
    builddspartner($(this).val(),record);
});
var urlImagepartner="";
$(".ip-img-user-change_partner").change(function () {
   $(".linklogo").html("<img src='img/loading.gif' width='20px' height='20px'/>");
        var obj=$(this);
        uploadImage(obj,function (res) {
            console.log(res);
            if(res.code=="1000"){
               $(".linklogo").html("")
				var r1=res.data.url;
				 $(".imguserchange_partner").attr("src",urlLocal+r1.replace("./image_upload/","image_upload/"));
                urlImagepartner=r1.replace("./image_upload/","image_upload/");
              
            }
            else{
                alert("Upload hình lỗi! Vui lòng thử lại");
            }
        });
    });
function datasendpartner(){

    var name=$(".par_name").val();
    var link=$(".par_link").val();
 
  
 
    var dataSend={
		name:name,
        link:link,
		logo:urlImagepartner,
		visible:visiblepartner
		
		
		
    }
    return dataSend;
}
$(".btn_partner").click(function () {
    var dataSend=datasendpartner();
	
    if((dataSend.name=="")){
        alert_info("Nhập tên đối tác");
        $(".par_name").focus();
    }
    else if(dataSend.link==""){
        alert_info("Nhập link liên kết");
        $(".par_link").focus();
    }
    else
	{
		if ($(".modalshowpartner").attr("data-editting") == "false") {
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang thêm dữ liệu");
            queryData("gioithieu/createpartner", dataSend, function (res) {
              //  console.log(res);
                if (res.code == 1000) {
              $(".modalshowprogess").modal("hide");
           $(".modalshowpartner").modal("hide");
                    builddspartner(partner_current,record);
                    resetViewpartner();
					//getsanphamData();
                } else if (res.code == 1002) {

                    alert_error("Đã trùng đối tác");
                
                  $(".modalshowprogess").modal("hide");
                    resetViewpartner();
                } else {
					$(".modalshowprogess").modal("hide");
                    alert_error("Thêm thất bại");
                }
            });
        } else {
           dataSend.id=idpartner;
          $(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang cập nhật dữ liệu");
            queryData("gioithieu/udpatepartner", dataSend, function (res) {
             
                if (res.code == 1000) {
                 
                     builddspartner(partner_current,record);
                     resetViewpartner();
                    $(".modalshowpartner").modal("hide");
                    
                } else {
                    alert_error("Cập nhật thất bại");
                }
				$(".modalshowprogess").modal("hide");
            });

        }
}
});
var idpartner=0;
var visiblepartner=1;
$(".listpartner").on('click',".btn-show-info-editpartner",function () {

	$(".titlepartner").html("<i class='fa fa-edit'></i>&nbsp; Sửa đối tác");
    $(".modalshowpartner").attr("data-editting",true);

 
    $(".modalshowpartner").modal("show");
    var id=($(this).parents("tr").attr("data-id"));
	idpartner=id;
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resallpartner[vt];
    visiblepartner=custom.visible;
    $(".par_name").val(custom.name);
    $(".par_link").val(custom.link);
	 $(".loaisp_tenloai_en").val(custom.tenloai_en);
	
	urlImagepartner=custom.logo;
	//console.log(urlImagepartner);
	
	if(custom.logo==""){
		 $(".imguserchange_partner").attr("src","img/up.png");
	}
	else{
    $(".imguserchange_partner").attr("src",urlLocal+custom.logo);
	}

});
$(".thempartner").click(function () {
    $(".modalshowpartner").modal("show");
    $(".modalshowpartner").attr('data-editting',false);
	resetViewpartner();

});
$(".thempartnerrefesh").click(function () {
  //  $(".modalshowpartner").modal("show");
    $(".modalshowpartner").attr('data-editting',false);
	resetViewpartner();
builddspartner(0,record);
});
$(".listpartner").on('click',".btn-show-info-removepartner",function () {
	 var id=($(this).parents("tr").attr("data-id"));
	
	
	bootbox.confirm("Bạn có chắc xóa đối tác này không?", function(result){
        if(result==true) {
            
         var dataSend = {
                id:id
            };
          // console.log(dataSend);
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang xóa dữ liệu");
            queryData("gioithieu/deletepartner", dataSend, function (res) {
                
                if (res.code == 1000) {
                 builddspartner(partner_current,record);
                    
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

$(".listpartner").on('click',".click_an",function () {
	 var id=($(this).parents("tr").attr("data-id"));
	  var vi=($(this).attr("data-vi"));
	 var dataSend = {
                visible:vi,
				id:id
            };
          // console.log(dataSend);
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang cập nhật trạng thái dữ liệu");
            queryData("gioithieu/udpatepartnervisible", dataSend, function (res) {
                
                if (res.code == 1000) {
                builddspartner(partner_current,record);
                    
					$(".modalshowprogess").modal("hide");
                    
                }else{
					alert_info("Cập nhật thất bại");
					$(".modalshowprogess").modal("hide");
				}
				
            });
			
});