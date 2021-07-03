var resallnhapp;
var vtnppps;
var mapnpp;
var latnpp;
var lngnpp;
function init_map3(obj) {
   
  
    var myLocation = new google.maps.LatLng(obj.lat, obj.lng);
    // console.log(obj.lat);
    // console.log(obj.lng);
    // arraylatlng.push(obj.lat);
    // arraylatlng.push(obj.lng);
    // console.log(arraylatlng)
    var mapOptions = {
        center: myLocation,
        zoom: 14
    };
    // console.log("a")
    var marker = new google.maps.Marker({
        position: myLocation,
        title: "Property Location",
        map: mapnpp,
    });


    mapnpp = new google.maps.Map(document.getElementById("mapnpp"),
        mapOptions);
    new google.maps.event.trigger(marker, 'click');

    marker.setMap(mapnpp);


}

function builddsnhaphanphoi(page,record) {
    var charsearch=$(".search_nhaphanphoi").val();
	
    var dataSend={
		page:page,
        record:record,
       
        charsearch:charsearch
		
    }
    
    $(".listnhaphanphoi").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  
    queryData("nhaphanphoi/get",dataSend,function (res) {
       console.log(res);
        if(res.code==1000){

            $(".listnhaphanphoi").html("");
            buildHTMLphanphoiData(res,record);
            if((flag==true)){
                console.log("s");
                buildmapnpp(res);
            }
        }else{
            $(".listnhaphanphoi").html("Tìm không thấy");
			$(".numberpagenhapp").html("");
        }
    });
}
function buildmapnpp(res) {
    var data=res.data.items;
    console.log(data[vtnppps]);
    init_map3(data[vtnppps]);
}
function buildHTMLphanphoiData(res,record) {
    console.log(res);
    var data = res.data.items;
   var stt=1;
    resallnhapp=data;
   var currentpage=parseInt(res.data.page);
    stt=printSTT(record,currentpage);
    var html='';
    
	
    for (item in data) {
        var list=data[item];
      
       
        html=html +
            '<tr data-manpp="' + list.manpp + '"data-name="'+list.tennpp+'  "data-vt="' + item + '">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
			'<td class="btn-show-info-cv">' + list.username + '</td>' +
            '<td class="btn-show-info-cv">' + list.manpp + '</td>' +
			'<td class="btn-show-info-cv">' + list.tennpp + '</td>' +
			'<td class="btn-show-info-cv">' + list.mst + '</td>' +
			'<td class="btn-show-info-cv">' + list.diachi + '</td>' +
			
          
			'<td class="btn-show-info-cv">' + list.sdt + '</td>' +
            '<td class="btn-show-info-cv">' + list.email+'</td>'+
			  '<td class="btn-show-info-cv">' + list.website+'</td>'+
			    '<td class="btn-show-info-cv">' + list.sofax+'</td>'+
				 '<td class="btn-show-info-cv">' + list.facebook+'</td>'+
			  '<td class="btn-show-info-diadiemnpp">Xem</td>'+
			
			 	 '<td class="btn-show-info-suancc"><a href="#">  <i class="fa fa-edit"></i></a></td>' +
			 '<td class="btn-show-info-xoancc"><a href="#">  <i class="fa fa-remove"></i></a></td>' +
			
            
            '</tr>';
        stt++;
        $(".listnhaphanphoi").html(html)
    }
    buildSlidePage($(".numberpagenhapp"),5,res.data.page,res.data.totalpage);
}
var npp_current=0;
$(".numberpagenhapp").on('click','button',function () {
    //console.log("nha"+$(this).val());
    npp_current=$(this).val();
    builddsnhaphanphoi($(this).val(),record);
    
});
function resetViewnpp() {
    $(".npp_username").val("");
    $(".npp_password").val("");
   $(".npp_manpp").val("");
    $(".npp_tennpp").val("");
	 $(".npp_mst").val("");
    $(".npp_addressnpp").val("");
	 $(".npp_sdt").val("");
	  $(".npp_email").val("");
	   $(".npp_website").val("");
	    $(".npp_facebook").val("");
		 $(".npp_diadiem").val("");
		 $(".npp_lat").val("0");
		 $(".npp_lng").val("0");
    $(".modalshownpp").attr("data-editting",false);

$(".titlenpp").html("<i class='fa fa-plus'></i>&nbsp; Tạo mới nhà phân phối");
 $(".npp_username").attr('disabled',false);
	 $(".npp_password").attr('disabled',false);
	 adiadiemphanphoi=[];
}
function datasendnpp(){

 var u=   $(".npp_username").val();
 var p=   $(".npp_password").val();
 var ma=  $(".npp_manpp").val();
  var ten=  $(".npp_tennpp").val();
	var mst= $(".npp_mst").val();
   var diachi= $(".npp_addressnpp").val();
	 var sdt=$(".npp_sdt").val();
	var email=  $(".npp_email").val();
	 var website=  $(".npp_website").val();
	  var facebook=  $(".npp_facebook").val();
		
			var sofax= $(".npp_sofax").val();
   var latnew=parseFloat( $(".npp_lat").val());
   var lngnew= parseFloat($(".npp_lng").val());
    var dataSend={
		
		
		username:u,
		password:p,
		permission:3,
		tennpp:ten,
		mst:mst,
		diachi:diachi,
		sdt:sdt,
		email:email,
		website:website,
		facebook:facebook,
		diadiem:JSON.stringify(adiadiemphanphoi),
		sofax:sofax,
		lat:latnew,
		lng:lngnew,
		user:0,
		detailname:ten,
		phone:sdt,
		email:email
		
		
		
    }
    return dataSend;
}
function datasendnppsua(){


 var ma=  $(".npp_manpp").val();
  var ten=  $(".npp_tennpp").val();
	var mst= $(".npp_mst").val();
   var diachi= $(".npp_addressnpp").val();
	 var sdt=$(".npp_sdt").val();
	var email=  $(".npp_email").val();
	 var website=  $(".npp_website").val();
	  var facebook=  $(".npp_facebook").val();
		
			var sofax= $(".npp_sofax").val();
     var latnew= parseFloat($(".npp_lat").val());
   var lngnew= parseFloat($(".npp_lng").val());
    var dataSend={
		
		
	
		tennpp:ten,
		mst:mst,
		diachi:diachi,
		sdt:sdt,
		email:email,
		website:website,
		facebook:facebook,
		diadiem:JSON.stringify(adiadiemphanphoi),
		sofax:sofax,
		lat:latnew,
		lng:lngnew,
		detailname:ten,
		phone:sdt,
		email:email
		
		
		
		
    }
    return dataSend;
}
$(".search_nhaphanphoi").keyup(function () {
   
    builddsnhaphanphoi(0,record);
 
});
$(".themnpprefesh").click(function () {
   
    builddsnhaphanphoi(0,record);
 
});
$(".btn-print-info-save-npp").click(function () {
    var dataSend=datasendnpp();
   console.log(dataSend);
     if(dataSend.username==""){
		   alert_info("Nhập tên đăng nhập");
        $(".npp_username").focus();
	}else if(dataSend.password==""){
		 alert_info("Nhập mật khẩu");
        $(".npp_username").focus();
	}else if(dataSend.tennpp==""){
        alert_info("Nhập tên nhà cung cấp");
        $(".npp_tennpp").focus();
    }
   else
	{
		if ($(".modalshownpp").attr("data-editting") == "false") {
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang thêm dữ liệu");
            queryData("nhaphanphoi/create", dataSend, function (res) {
                console.log(res);
                if (res.code == 1000) {
              $(".modalshowprogess").modal("hide");
           $(".modalshownpp").modal("hide");
                    builddsnhaphanphoi(npp_current,record);
                    resetViewnpp();
					//getsanphamData();
                } else if (res.code == 1002) {

                    alert_error("Đã trùng nhà phân phối");
                
                  $(".modalshowprogess").modal("hide");
                    resetViewnpp();
                } else {
					$(".modalshowprogess").modal("hide");
                    alert_error("Thêm thất bại");
                }
            });
        } else {
           
          $(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang cập nhật dữ liệu");
		   dataSend=datasendnppsua();
		  dataSend.manpp=manpp;
		  dataSend.user=usernpp;
		 console.log(dataSend);
            queryData("nhaphanphoi/updatenhaphanphoi", dataSend, function (res) {
             console.log(res);
                if (res.code == 1000) {
                 
                    builddsnhaphanphoi(npp_current,record);
                     resetViewnpp();
                    $(".modalshownpp").modal("hide");
                    
                } else {
                    alert_error("Cập nhật thất bại");
                }
				$(".modalshowprogess").modal("hide");
            });

        }
}
});

var manpp;
var usernpp;
$(".listnhaphanphoi").on('click',".btn-show-info-suancc",function () {
 
	$(".titlenpp").html("<i class='fa fa-edit'></i>&nbsp; Sửa nhà phân phối");
    $(".modalshownpp").attr("data-editting",true);

   

    $(".modalshownpp").modal("show");
     manpp=($(this).parents("tr").attr("data-manpp"));
	var tennpp=($(this).parents("tr").attr("data-tennpp"));
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resallnhapp[vt];
	usernpp=custom.user;
     $(".npp_username").val(custom.username);
	  $(".npp_password").val(custom.password);
    $(".npp_tennpp").val(custom.tennpp);
    $(".npp_mst").val(custom.mst);
	$(".npp_addressnpp").val(custom.diachi);
	$(".npp_sdt").val(custom.sdt);
	$(".npp_email").val(custom.email);
	
	$(".npp_website").val(custom.website);
	$(".npp_sofax").val(custom.sofax);
	
	$(".npp_facebook").val(custom.facebook);
	adiadiemphanphoi=JSON.parse(custom.diadiem);
	showinforDiadiemPP(adiadiemphanphoi,"nhapp_diadiempp");
	 $(".npp_username").attr('disabled','disabled');
	 $(".npp_password").attr('disabled','disabled');
	 lat=custom.lat;
	 lng=custom.lng;
$(".npp_lat").val(custom.lat);
$(".npp_lng").val(custom.lng);
});
$(".listnhaphanphoi").on('click',".btn-show-info-xoancc",function () {
	 var id=($(this).parents("tr").attr("data-manpp"));
	var tennpp=($(this).parents("tr").attr("data-tennpp"));
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resallnhapp[vt];
	var vt=($(this).parents("tr").attr("data-vt"));
	
	bootbox.confirm("Bạn có chắc xóa nhà phân phối có "+id+" này không?", function(result){
        if(result==true) {
            
         var dataSend = {
                manpp:id,
				user:custom.user
            };
           console.log(dataSend);
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang xóa dữ liệu");
            queryData("nhaphanphoi/deletenhaphanphoi", dataSend, function (res) {
                
                if (res.code == 1000) {
					alert_info("Xóa thành công");
                  builddsnhaphanphoi(npp_current,record);
					$(".modalshowprogess").modal("hide");
                    
                }else if(res.code==1001){
					alert_info("Xóa thất bại");
					$(".modalshowprogess").modal("hide");
				}else if(res.code==1002){
                    alert_info("Sản phẩm này không thể xóa. Do đã đang sử dụng");
					$(".modalshowprogess").modal("hide");
                }
				
            });
			
			
        }else
        {
            // alert_info("Lỗi");
        }
    });
	
});
var flag=false;
$(".listnhaphanphoi").on("click",".btn-show-info-bando",function () {
    $(".modalshowmapnpp").modal("show");
    var vtnpp=($(this).parents("tr").attr("data-vt"));

    vtnppps=vtnpp;
    console.log(vtnppps);
    flag=true;
    builddsnhaphanphoi(0,record);

});
$(".modalshownpp").on("click",".btnchucvu_addressnpp",function () {
    console.log("a")
    $(".npp_addressnpp").val('');
    $("#complete").val('');
    $(".modalshowmappicker").modal("show");
    // initAutocomplete()
    initMap();
});
$(".modalshowmappicker").on("click",".btn-print-info-save-nhapkhospss",function () {

    $(".npp_addressnpp").val(address);
    $(".modalshowmappicker").modal("hide");
});
var customnpp;
var vtcus;
$(".listnhaphanphoi").on('click',".btn-show-info-diadiemnpp",function () {

    $(".titleinfo").html("<i class='fa fa-info-circle'></i>&nbsp; Thông tin nhà phân phối chi nhánh");
    var mansc=($(this).parents("tr").attr("data-manpp"));
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    customnpp=resallnhapp[vt];
    // console.log(customnpp);
    vtcus=(JSON.parse(customnpp.diadiem));
    // console.log(vtcus)
    var stt=1;
    var listp=JSON.parse(customnpp.diadiem);
    if(isEmpty(listp)){
        alert("Không có chi nhánh");
        return;
    }
    else {
        $(".modalshowinforcommon").modal("show");
        var html = '<h4></h4>' +
            ' <div class="portlet-content table-responsive nhaphanphoi">' +
            '<table class="table table-striped table-bordered table-checkable"><thead><tr>' +

            "<th>STT</th>" +
            "<th>Mã nhà phân phối</th>" +
            "<th>Tên nhà phân phối</th>" +
            "<th>Địa chỉ</th>" +
            "<th>Số điện thoại</th>" +
            "<th>Email</th>" +
            "<th>Trang điện tử</th>" +
            "<th>Map</th>" +

            "</tr>" +
            "</thead>" +

            '<tbody class="listnpp">';


        html = html + "</tbody></table></div>";
        $(".showinfocommon").html(html);
        var htmlnd = '';
        var listthongtin;
        for (var j in listp) {

           var listthongtin=listp[j];
            console.log(listthongtin);
            htmlnd = htmlnd +
                '<tr data-id="" data-name="  " data-vt="'+j+'">' +

                '<td class="btn-show-info-cv">' + stt + '</td>' +
                '<td class="btn-show-info-cv">' + listthongtin.id + '</td>' +
                '<td class="btn-show-info-cv">' + listthongtin.tencs + '</td>' +
                '<td class="btn-show-info-cv">' + listthongtin.diachi + '</td>' +
                '<td class="btn-show-info-cv">' + listthongtin.sdt + '</td>' +
                '<td class="btn-show-info-cv">' + listthongtin.email + '</td>' +
                '<td class="btn-show-info-cv">' + listthongtin.kenhpp + '</td>' +
                '<td class="btn-show-info-xemmapchinhanhnpp">>>Xem</td>' +
                '</tr>';
            $(".listnpp").html(htmlnd);
            stt++;
        }

    }
});
$(".modalshowinforcommon").on("click",".btn-show-info-xemmapchinhanhnpp",function () {
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    $(".modalshowinforcommon").modal("hide");
    $(".modalshowmapnsc").modal("show");
    console.log(vtcus[vt])
    init_map3(vtcus);
});
$(".nhapp_themdiadiempp").click(function () {
    
    $(".modalshowdiadiemphanphoi").modal("show");
	
	
});
var adiadiemphanphoi=[];
var ibpp=1;
$(".btn-print-info-save-diadiem_phanphoi").click(function () {

 
 var ten=$(".npp_diadiem_ten").val();
    var dc=$(".npp_diadiem_dc").val();
	var dt=$(".npp_diadiem_sdt").val();
	var email=$(".npp_diadiem_email").val();
	var kpp=$(".npp_diadiem_kenhphanphoi").val();
	var data={
		id:ibpp,
		tencs:ten,
		diachi:dc,
		sdt:dt,
		email:email,
		lat:0,
		lng:0,
		kenhpp:kpp
	}
	adiadiemphanphoi.push(data);
	ibpp++;
	showinforDiadiemPP(adiadiemphanphoi,"nhapp_diadiempp");
	$(".npp_diadiem_ten").val("");
   $(".npp_diadiem_dc").val("");
	$(".npp_diadiem_sdt").val("");
	$(".npp_diadiem_email").val("");
	$(".npp_diadiem_kenhphanphoi").val("");
 
});
function showinforDiadiemPP(abvtv,tenbien){
	var  htmlnd='';
	var stt=1;
    for(i=0;i<abvtv.length;i++){

        htmlnd=htmlnd +
            '<tr data-id="" data-name="  " data-vt="'+i+'">' +
'<td class="btn-show-info-cv">' + stt + '</td>' +
          
            '<td class="btn-show-info-cv">' + abvtv[i].tencs + '</td>' +
			 '<td class="btn-show-info-cv">' + abvtv[i].diachi + '</td>' +
			  '<td class="btn-show-info-cv">' + abvtv[i].sdt + '</td>' +
			   '<td class="btn-show-info-cv">' + abvtv[i].email + '</td>' +
			   '<td class="btn-show-info-cv">' + abvtv[i].kenhpp + '</td>' +
 '<td class="btn-show-info-remove"><i class="fa fa-remove"></i></td>' +



            '</tr>';
      
stt++;

    }
    $("."+tenbien).html(htmlnd);
}
//remove chon
$(".nhapp_diadiempp").on('click','.btn-show-info-remove',function () {
	
	var vt=parseInt($(this).attr("data-vt"));
	adiadiemphanphoi.splice(vt,1);
	
	showinforDiadiemPP(adiadiemphanphoi,"nhapp_diadiempp");
	
	
});