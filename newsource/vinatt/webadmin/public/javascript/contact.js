var resallcontact;

function builddscontact(page,record) {
    
    var dataSend={

       page:page,
	   record:record,
        charsearch:""
    }
   // console.log(dataSend);
    $(".listcontact").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  
    queryData("gioithieu/getcontact",dataSend,function (res) {
     //  console.log(res);
        if(res.code==1000){
	//	console.log(res);
            $(".listcontact").html("");
            buildHTMLcontactData(res);
            
        }else{
            $(".listcontact").html("Tìm không thấy");
			$(".numberpage_contact").html("");
        }
    });
}
function resetViewcontact() {
    $(".contact_phone").val("");
    $(".contact_name").val("");
	 $(".contact_codetext").val("");
    $(".modalshowcontact").attr("data-editting",false);
$(".imguserchange_partner").attr("src",'./img/up.png');
urlImagecontact="";
$(".titlecontact").html("<i class='fa fa-plus'></i>&nbsp; Tạo mới liên hệ");
 // $(".loaisp_maloai").attr('disabled',false);
}


function buildHTMLcontactData(res) {
    
    var data = res.data.items;
   
    resallcontact=data;
   
    var html='';
    var htmlts='';
    var listinffo='';
	var stt=1;
	var currentpage=parseInt(res.data.page);
    stt=printSTT(record,currentpage);
    for (item in data) {
        var list=data[item];
		var img='img/no_image.png';
        if(list.avatar==""){
			img='img/no_image.png';
		}else{
			img=urlLocal+list.avatar;
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
            '<tr data-phone="' + list.id + '"data-name="'+list.name+'  "data-vt="' + item + '">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
           '<td class="btn-show-info-cv">' + list.name+ '</td>'+
            '<td class="btn-show-info-cv">' + list.phone+ '</td>'+
			
			 '<td class="btn-show-info-cv">' + list.codetext + '</td>' +
			
            '<td class="btn-show-info-cv" align="center"><img class="anhsp" style="border-radius: 40%;width: 70px;height: 40px; cursor: pointer" src='+img+'></td>'+
                '<td class="btn-show-info-cv"><button type="button" class="btn btn-round btn-info-show">'+s+'</button></td>' +
            '<td class="btn-show-info-editpartner"><a href="#">  <i class="fa fa-edit"></i></a></td>' +
			
            '<td class="btn-show-info-removepartner"><a href="#">  <i class="fa fa-remove"></i></a></td>' +
			  '<td><a href="#"> '+k+' </a></td>' +
            '</tr>';
        stt++;
        $(".listcontact").html(html);
		
    }
	
    buildSlidePage($(".numberpage_contact"),5,res.data.page,res.data.totalpage);
}
var contact_current=0;
$(".numberpage_contact ").on('click','button',function () {
    //console.log("nha"+$(this).val());
    contact_current=$(this).val();
 
    builddscontact($(this).val(),record);
});
var urlImagecontact="";
$(".ip-img-user-change_contact").change(function () {
   $(".imguserchange_contact").html("<img src='img/loading.gif' width='20px' height='20px'/>");
        var obj=$(this);
        uploadImage(obj,function (res) {
            console.log(res);
            if(res.code=="1000"){
             
				var r1=res.data.url;
				 $(".imguserchange_contact").attr("src",urlLocal+r1.replace("./image_upload/","image_upload/"));
                urlImagecontact=r1.replace("./image_upload/","image_upload/");
              
            }
            else{
                alert("Upload hình lỗi! Vui lòng thử lại");
            }
        });
    });
	var visiblecontact=1;
function datasendcontact(){

     var phone=$(".contact_phone").val();
   var name= $(".contact_name").val();
	var codetext= $(".contact_codetext").val();
  
 
    var dataSend={
		phone:phone,
        codetext:codetext,
		name:name,
		
		avatar:urlImagecontact,
		visible:visiblecontact
		
		
		
    }
    return dataSend;
}
$(".btn_contact").click(function () {
    var dataSend=datasendcontact();
	
    if((dataSend.name=="")){
        alert_info("Nhập tên liên hệ");
        $(".contact_name").focus();
    }
    else if(dataSend.phone==""){
        alert_info("Nhập số phone");
        $(".contact_phone").focus();
    }
    else
	{
		if ($(".modalshowcontact").attr("data-editting") == "false") {
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang thêm dữ liệu");
            queryData("gioithieu/createcontact", dataSend, function (res) {
              //  console.log(res);
                if (res.code == 1000) {
              $(".modalshowprogess").modal("hide");
           $(".modalshowcontact").modal("hide");
                    builddscontact(contact_current,record);
                    resetViewcontact();
					//getsanphamData();
                } else if (res.code == 1002) {

                    alert_error("Đã trùng liên hệ");
                
                  $(".modalshowprogess").modal("hide");
                    resetViewcontact();
                } else {
					$(".modalshowprogess").modal("hide");
                    alert_error("Thêm thất bại");
                }
            });
        } else {
           dataSend.id=phonecontact;
          $(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang cập nhật dữ liệu");
            queryData("gioithieu/udpatecontact", dataSend, function (res) {
             
                if (res.code == 1000) {
                 
                     builddscontact(contact_current,record);
                     resetViewcontact();
                    $(".modalshowcontact").modal("hide");
                    
                } else {
                    alert_error("Cập nhật thất bại");
                }
				$(".modalshowprogess").modal("hide");
            });

        }
}
});
var phonecontact="";
$(".listcontact").on('click',".btn-show-info-editpartner",function () {

	$(".titlecontact").html("<i class='fa fa-edit'></i>&nbsp; Sửa liên hệ");
    $(".modalshowcontact").attr("data-editting",true);

 
    $(".modalshowcontact").modal("show");
    var id=($(this).parents("tr").attr("data-phone"));
	phonecontact=id;
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resallcontact[vt];
    visiblecontact=custom.visible;
  $(".contact_phone").val(custom.phone);
    $(".contact_name").val(custom.name);
	$(".contact_codetext").val(custom.codetext);
  
	urlImagecontact=custom.avatar;
	//console.log(urlImagecontact);
	
	if(custom.avatar==""){
		 $(".imguserchange_contact").attr("src","img/up.png");
	}
	else{
    $(".imguserchange_contact").attr("src",urlLocal+custom.avatar);
	}

});
$(".themlienhe").click(function () {
    $(".modalshowcontact").modal("show");
    $(".modalshowcontact").attr('data-editting',false);
	resetViewcontact();

});
$(".themlienherefesh").click(function () {
  //  $(".modalshowcontact").modal("show");
    $(".modalshowcontact").attr('data-editting',false);
	resetViewcontact();
builddscontact(0,record);
});
$(".listcontact").on('click',".btn-show-info-removepartner",function () {
	 var id=($(this).parents("tr").attr("data-phone"));
	
	
	bootbox.confirm("Bạn có chắc xóa liên hệ này không?", function(result){
        if(result==true) {
            
         var dataSend = {
                id:id
            };
          // console.log(dataSend);
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang xóa dữ liệu");
            queryData("gioithieu/deletecontact", dataSend, function (res) {
                
                if (res.code == 1000) {
                 builddscontact(contact_current,record);
                    
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
$(".listcontact").on('click',".click_an",function () {
	 var id=($(this).parents("tr").attr("data-phone"));
	  var vi=($(this).attr("data-vi"));
	 var dataSend = {
                visible:vi,
				id:id
            };
           console.log(dataSend);
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang cập nhật trạng thái dữ liệu");
            queryData("gioithieu/udpatecontactvisible", dataSend, function (res) {
                
                if (res.code == 1000) {
                 builddscontact(contact_current,record);
                    
					$(".modalshowprogess").modal("hide");
                    
                }else{
					alert_info("Cập nhật thất bại");
					$(".modalshowprogess").modal("hide");
				}
				
            });
			
});