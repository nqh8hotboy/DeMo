var resallnganhang;

function builddsnganhang(page) {
    
    var dataSend={

       
        charsearch:""
    }
   
    $(".listtk tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  
    queryData("loaisp/getnganhang",dataSend,function (res) {
     
        if(res.code==1000){
		
            $(".listtk").html("");
            buildHTMLnganhangData(res);
            
        }else{
            $(".listtk").html("Tìm không thấy");
        }
    });
}
$(".themtkrefesh").click(function () {
	console.log("d");
 builddsnganhang(0);
});
function resetViewtk() {
    $(".tk_so").val("");
    $(".tk_ten").val("");
	   $(".tk_nh").val("");
  

}


function buildHTMLnganhangData(res) {
    
    var data = res.data.items;
   
    resallnganhang=data;
   
    var html='';
    var htmlts='';
    var listinffo='';
	var stt=1;
    for (item in data) {
        var list=data[item];
      
       
        html=html +
            '<tr data-sotk="' + list.sotk + '"data-name="'+list.sotk+'  "data-vt="' + item + '">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
            '<td class="btn-show-info-cv">' + list.sotk + '</td>' +
            '<td class="btn-show-info-cv">' + list.tentk+ '</td>'+
           
               '<td class="btn-show-info-cv">' + list.nganhang+ '</td>'+
            '<td class="btn-show-info-removetk"><a href="#">  <i class="fa fa-remove"></i></a></td>' +
			
            
            '</tr>';
        stt++;
        $(".listtk").html(html)
    }
    
}

function datasendtk(){

    var so=$(".tk_so").val();
    var ten=$(".tk_ten").val();
	  var nh=$(".tk_nh").val();
	 
   
    var dataSend={
		sotk:so,
		tentk:ten,
		nganhang:nh
		
    }
    return dataSend;
}
$(".btn_save_tk").click(function () {
    var dataSend=datasendtk();
	console.log(dataSend);
    if((dataSend.sotk=="")){
        alert_info("Số tài khoản không thể trống");
        $(".tk_so").focus();
    }
    else if(dataSend.tentk==""){
        alert_info("Nhập tên tài khoản");
        $(".tk_ten").focus();
    }
    else if(dataSend.nganhang=="") {
		 alert_info("Ngân hàng không thể trống");
		  
	}else
	{
		
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang thêm dữ liệu");
            queryData("loaisp/createnh", dataSend, function (res) {
                console.log(res);
                if (res.code == 1000) {
              $(".modalshowprogess").modal("hide");
           $(".modalshowloaisp").modal("hide");
                    builddsnganhang(0);
                    resetViewtk();
					//getsanphamData();
                } else if (res.code == 1002) {

                    alert_error("Đã trùng số tài khoản");
                
                  $(".modalshowprogess").modal("hide");
                    resetViewtk();
                } else {
					$(".modalshowprogess").modal("hide");
                    alert_error("Thêm thất bại");
                }
            });
        
}
});

$(".listtk").on('click',".btn-show-info-removetk",function () {
	 var sotk=($(this).parents("tr").attr("data-sotk"));
	
	
	bootbox.confirm("Bạn có chắc xóa tài khoản này không?", function(result){
        if(result==true) {
            
         var dataSend = {
                sotk:sotk
            };
           
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang xóa dữ liệu");
            queryData("loaisp/deletetk", dataSend, function (res) {
                
                if (res.code == 1000) {
                  builddsnganhang(0);
					$(".modalshowprogess").modal("hide");
                    
                }else if(res.code==1002){
                    alert_info("Tài khoản này không thể xóa");
                }
				
            });
			
			
        }else
        {
            // alert_info("Lỗi");
        }
    });
	
});