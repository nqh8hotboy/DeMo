var resallpartner;

function builddsworks(page,record) {
    
    var dataSend={

       page:page,
	   record:record,
        charsearch:""
    }
   // console.log(dataSend);
    $(".addlistworks").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  
    queryData("gioithieu/getworks",dataSend,function (res) {
      //console.log(res);
        if(res.code==1000){
	//	console.log(res);
            $(".addlistworks").html("");
            buildHTMLworksData(res);
            
        }else{
            $(".addlistworks").html("Tìm không thấy");
			$(".numberpage_works").html("");
        }
    });
}
function resetViewworks() {
    $(".w_name").val("");
   
    $(".modalshowworks").attr("data-editting",false);
//$(".imguserchange_partner").attr("src",'./img/up.png');
//urlImagepartner="";
$(".titleworks").html("<i class='fa fa-plus'></i>&nbsp; Tạo mới công việc");
 // $(".loaisp_maloai").attr('disabled',false);
}


function buildHTMLworksData(res) {
    
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
		
		var s="Hiển thị";
		var k='';
		if(list.visible==1){
			k='<button type="button" class="btn btn-danger click_an" data-vi="0">Ẩn</button>';
		}else{
			s="Ẩn";
			k='<button type="button" class="btn btn-danger click_an" data-vi="1">Hiển thị</button>';
		}
        html=html +
            '<tr data-id="' + list.idw + '"data-name="'+list.namew+'  "data-vt="' + item + '">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
           
            '<td class="btn-show-info-cv">' + list.namew+ '</td>'+
			
			 '<td class="btn-show-info-cv">' + s + '</td>' +
           '<td class="btn-show-info-editpartner"><a href="#">  <i class="fa fa-edit"></i></a></td>' +
			
            '<td class="btn-show-info-removepartner"><a href="#">  <i class="fa fa-remove"></i></a></td>' +
			 '<td><a href="#"> '+k+' </a></td>' +
            '</tr>';
        stt++;
        $(".addlistworks").html(html);
		
    }
	
    buildSlidePage($(".numberpage_works"),5,res.data.page,res.data.totalpage);
}
var works_current=0;
$(".numberpage_works ").on('click','button',function () {
    //console.log("nha"+$(this).val());
    works_current=$(this).val();
 
    builddsworks($(this).val(),record);
});

function datasendworks(){

    var name=$(".w_name").val();
   
  
 
    var dataSend={
		namew:name,
       
		visible:visibleworks
		
		
		
    }
    return dataSend;
}
$(".btn_works").click(function () {
    var dataSend=datasendworks();
	console.log(dataSend);
    if((dataSend.name=="")){
        alert_info("Nhập tên công việc");
        $(".w_name").focus();
    }
    else
	{
		if ($(".modalshowworks").attr("data-editting") == "false") {
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang thêm dữ liệu");
            queryData("gioithieu/createworks", dataSend, function (res) {
              //  console.log(res);
                if (res.code == 1000) {
              $(".modalshowprogess").modal("hide");
           $(".modalshowworks").modal("hide");
                    builddsworks(works_current,record);
                    resetViewworks();
					//getsanphamData();
                } else if (res.code == 1002) {

                    alert_error("Đã trùng tên công việc");
                
                  $(".modalshowprogess").modal("hide");
                    resetViewworks();
                } else {
					$(".modalshowprogess").modal("hide");
                    alert_error("Thêm thất bại");
                }
            });
        } else {
           dataSend.idw=idworks;
          $(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang cập nhật dữ liệu");
            queryData("gioithieu/udpateworks", dataSend, function (res) {
             
                if (res.code == 1000) {
                 
                     builddsworks(works_current,record);
                     resetViewworks();
                    $(".modalshowworks").modal("hide");
                    
                } else {
                    alert_error("Cập nhật thất bại");
                }
				$(".modalshowprogess").modal("hide");
            });

        }
}
});
var idworks=0;
var visibleworks=1;
$(".addlistworks").on('click',".btn-show-info-editpartner",function () {

	$(".titleworks").html("<i class='fa fa-edit'></i>&nbsp; Sửa công việc");
    $(".modalshowworks").attr("data-editting",true);

 
    $(".modalshowworks").modal("show");
    var id=($(this).parents("tr").attr("data-id"));
	idworks=id;
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resallpartner[vt];
    visibleworks=custom.visible;
    $(".w_name").val(custom.namew);
    
});
$(".themworks").click(function () {
    $(".modalshowworks").modal("show");
    $(".modalshowworks").attr('data-editting',false);
	resetViewworks();

});
$(".themworksrefesh").click(function () {
  //  $(".modalshowworks").modal("show");
    $(".modalshowworks").attr('data-editting',false);
	resetViewworks();
	builddsworks(0,record);
});
$(".addlistworks").on('click',".btn-show-info-removepartner",function () {
	 var id=($(this).parents("tr").attr("data-id"));
	
	
	bootbox.confirm("Bạn có chắc xóa công việc này không?", function(result){
        if(result==true) {
            
         var dataSend = {
                idw:id
            };
          // console.log(dataSend);
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang xóa dữ liệu");
            queryData("gioithieu/deleteworks", dataSend, function (res) {
                
                if (res.code == 1000) {
                 builddsworks(works_current,record);
                    
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

$(".addlistworks").on('click',".click_an",function () {
	 var id=($(this).parents("tr").attr("data-id"));
	  var vi=($(this).attr("data-vi"));
	 var dataSend = {
                visible:vi,
				idw:id
            };
          // console.log(dataSend);
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang cập nhật trạng thái dữ liệu");
            queryData("gioithieu/udpateworksvisible", dataSend, function (res) {
                
                if (res.code == 1000) {
                builddsworks(works_current,record);
                    
					$(".modalshowprogess").modal("hide");
                    
                }else{
					alert_info("Cập nhật thất bại");
					$(".modalshowprogess").modal("hide");
				}
				
            });
			
});