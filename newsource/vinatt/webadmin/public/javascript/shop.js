var resalldanhmuc;
builddsshop();
function builddsshop() {
    
    
   
     getListDM("cb_danhmuc");
}





$(".cb_danhmuc").change(function () {
	iddm=$(".cb_danhmuc").val();
    builddsloaisp(iddm,spshop_current);
});
$(".cb_danhmuc").click(function () {
	iddm=$(".cb_danhmuc").val();
    builddsloaisp(iddm,spshop_current);
});
$(".search_sanphamshop").keyup(function () {
	
    builddsloaisp(iddm,spshop_current);
});
var iddm=1;
builddsloaisp(iddm,0);
function builddsloaisp(l,page) {
     var charsearch = $(".search_sanphamshop").val();
    var dataSend={

       page:page,
	   record:20,
        charsearch:charsearch,
       iddm:l
    }
   
    $(".gridloaisp").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  
    queryData("loaisp/getloaibydm",dataSend,function (res) {
      // console.log(res);
        if(res.code==1000){
		
            $(".gridloaisp").html("");
            buildHTMLLoaiSPDMData(res);
            
        }else{
            $(".gridloaisp").html("Tìm không thấy");
        }
    });
}
function buildHTMLLoaiSPDMData(res) {
    
    var data = res.data.items;
   
    resalldanhmuc=data;
   
    var html='';
 
    for (item in data) {
        var list=data[item];
		var pri="";
		var price="";
   if(list.gia=="0"){
	   pri=list.giachuoi+" / "+list.tendvt;
	   price=list.giachuoi;
   }else
   {
	   pri=formatNumber( list.gia , '.', ',')+" VNĐ / "+list.tendvt ;
	   price=list.gia;
   }
        html=html +
		
           '<div class="col-md-3 col-sm-6 detailsp" align="center" >'+
          '<div class="thumbnail">'+
            '<div class="thumbnail-view">'+
             
              '<img src='+urlLocal+list.anhsp+' style=" width:100%" height=200px alt="Gallery Image" />'+
            '</div>'+
			'<div class="caption clicksp" align="center">'+
			'<h4 class="titledanhmucsanpham" style="Color:#FF4433;">'+list.tendm+'</h4>'+
              '<h4 class="titledanhmucsanpham" style="Color:#006241;">'+list.tensp+" "+list.tenloai+" "+list.tenkieu+'</h4>'+
			  
			  '<h4 class="titledanhmucsanpham" style="Color:#367517;">'+pri+'</h4>'+
			   '<input size="3" data-vt="' + item + '" class="form-control slsanphamcart slup'+item+'" value="" type="number" maxlength="3"   placeholder="Số lượng"/>'+
			'</div>'+
			'<div class="caption" align="center"  >'+
              '<a data-idsp='+list.idsp+' data-dvt="'+list.tendvt+'" data-gia="'+price+'" data-tensp="'+list.tensp+" "+list.tenloai+" "+list.tenkieu+' " data-vt='+item+' href="javascript:;" class="fa fa-shopping-cart btn btn-secondary btn-sm btn-sm insertcart">&nbsp;&nbsp;Thêm vào giỏ</a>'+
			'</div>'+
			
          '</div>'+      
			
        '</div> ';

        
      
    }
      $(".gridloaisp").html(html);
	   buildSlidePage($(".numberpagesanphamshop"),5,res.data.page,res.data.totalpage);
}
var spshop_current=0;
$(".numberpagesanphamshop ").on('click','button',function () {
    //console.log("nha"+$(this).val());
    spshop_current=$(this).val();
    builddsloaisp(iddm,spshop_current);

});
///show modal
var datashop=JSON.parse(localStorage.getItem("shopcart"));
if(datashop==null){
	$(".sldh").html("0");
}else
{
//console.log(datashop)
$(".sldh").html(datashop.length);
}

 $(".menushopingcart").click(function () {
	 getListTK("xacnhan_stk");
	$(".modalshowxacnhandonhang").modal("show");
	datashop=JSON.parse(localStorage.getItem("shopcart"));
	$(".xacnhan_ngaydat").val(getDateTimeFromDate(new Date().getTime()));
	$(".xacnhan_ngaygiao").val(getDateTimeFromDate(new Date().getTime()+(36000)));
	var o=JSON.parse(localStorage.getItem("userNS"));
	
	if(o==null){
		
	}else
	{
		$(".xacnhan_ten").val(o.detailname);
		
		$(".xacnhan_dt").val(o.phone);
		$(".xacnhan_email").val(o.email);
	}
	buildHTMLshopcartData(datashop);
});
var ashopcart=[];
//xu ly insert gio hang
$(".gridloaisp").on('click',".insertcart",function () {
  if(slreal==0){
	  alert_info("Số lượng không thể trống");
  }else
  {
  var   idsp=$(this).data("idsp");
  var   tensp=$(this).data("tensp");
   var   gia=$(this).data("gia");
   var   dvt=$(this).data("dvt");
 
    var data={
		idsp:idsp,
		sl:slreal,
		tensp:tensp,
		gia:gia,
		dvt:dvt
	}
	//console.log(data);
	//console.log(datashop);
	 if(datashop==null){
		// ashopcart=[];
	 }else
	 {
		 ashopcart=datashop;
	 }
	 ashopcart.push(data);
	
	 localStorage.setItem("shopcart", JSON.stringify(ashopcart));
	 var sl="slup"+pos;
	$("."+sl).val("");
	$(".sldh").html(ashopcart.length);
	
  }
});
//xac đinh so luong can mua
 var slreal=0;
 var pos=0;
$(".gridloaisp").on('keyup',".slsanphamcart",function () {

  var   vt=$(this).data("vt");
 pos=vt;
  var sl="slup"+vt;
    slreal=$("."+sl).val();
});
var arshop=[];
function buildHTMLshopcartData(res) {
   ashopcart=res;
   
   
    var html='';
	var r=ashopcart;
	if(r==null){
		
	}
	else{
	htmlinfo="";
	var stt=1;
	var sum=0;
    for (var i=0;i<r.length;i++) {
     
       sum=sum+(r[i].sl*r[i].gia);
         htmlinfo = htmlinfo +
                '<tr data-id="'+r[i].idsp+'" data-name="  " data-vt="'+i+'">' +
                '<td class="btn-show-info-cv">' + stt + '</td>' +
                
               
                '<td class="btn-show-info-cv">' + r[i].tensp + '</td>' +
                '<td class="btn-show-info-cv">' +r[i].sl + '</td>' +
				 '<td class="btn-show-info-cv">' +formatNumber( r[i].gia  , '.', ',') + '</td>' +
                '<td class="btn-show-info-cv">' + r[i].dvt + '</td>' +
                '<td class="btn-show-info-cv">' +formatNumber( r[i].sl *r[i].gia  , '.', ',')  + '</td>' +
				 '<td class="btn-show-info-remove"><i class="fa fa-remove"></td>' +
                '</tr>';

       stt++; 
      
    }
	$(".tongtienthanhtoan").html(sum+" VNĐ");
	
	//console.log(htmlinfo);
      $(".listshowcart").html(htmlinfo);
	}
}
//xoa san pham chn
$(".listshowcart").on('click',".btn-show-info-remove",function () {
	 var vt=parseInt($(this).parents("tr").attr("data-vt"));
	ashopcart.splice(vt,1);//remove mang tam
	
	$(".sldh").html(ashopcart.length);
	localStorage.removeItem("shopcart");
	 localStorage.setItem("shopcart", JSON.stringify(ashopcart));
	 var t=JSON.parse(localStorage.getItem("shopcart"));
   buildHTMLshopcartData(t);
})

$(".btn-save-xacnhan").click(function () {

    var o=JSON.parse(localStorage.getItem("userNS"));
	console.log(o);
	if(o==null){
		alert_info("Xin vui lòng đăng nhập tài khoản ");
	}else
	{
		var ten=$(".xacnhan_ten").val();
		
		var phone=$(".xacnhan_dt").val();
		var email=$(".xacnhan_email").val();
		var dcgiao=$(".xacnhan_diachi").val();
		var stk=$(".xacnhan_stk").val();
		var asotk=stk.split(";");
	
		if(dcgiao==""){
			alert_info("Xin vui lòng nhập địa chỉ nhận hàng");
			$(".xacnhan_diachi").focus;
		}else{
			
		var ngaydat=moment($(".xacnhan_ngaydat").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
		var ngaygiao=moment($(".xacnhan_ngaygiao").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
		console.log(ashopcart);
		if(ashopcart==null){
			alert_info("Chọn ít nhất một sản phẩm");
		}else{
		var datakh={
			ten:ten,
			phone:phone,
			email:email,
			dcgiao:dcgiao
		}
		var datatt={
			loai:$(".cb_hinhthuc").val(),
			sotk:asotk[0],
			tentk:asotk[1],
			tennh:asotk[2]
		}
		var datasend={
			inforkh:JSON.stringify(datakh),
			ngaydat:ngaydat,
			ngaygiao:ngaygiao,
			lat:0,
			lng:0,
			infororder:JSON.stringify(ashopcart),
			iduserkh:o.iduser,
			phone:phone,
			inforthanhtoan:JSON.stringify(datatt),
			feeship:0,
			methodship:$(".cb_hinhthucship").val(),
			datetimegiaokhach:ngaygiao
			
		}
		//
		$(".gridloaisp").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  
		queryData("sanpham/createDDH",datasend,function (res) {
       console.log(res);
        if(res.code==1000){
		$(".modalshowxacnhandonhang").modal("hide");
            builddsloaisp(iddm,spshop_current);
			ashopcart=[];
			localStorage.removeItem("shopcart");
			$(".sldh").html(ashopcart.length);
			$(".listshowcart").html("");
			$(".tongtienthanhtoan").html("");
			datashop=null;
			alert_info("Xin vui lòng tra cứu đơn hàng trong mục Lịch sử đơn hàng để biết trạng thái đơn hàng");
        }else{
			 alert_info("Xác nhận đơn hàng thất bại");
           
        }
		});
		//
		}
		}
	}
});
function datasendtaikhoan(){

    var ten=$(".dangky_ten").val();
    var tk=$(".dangky_tk").val();
	  var mk=$(".dangky_matkhau").val();
	   var sdt=$(".dangky_sdt").val();
	    var email=$(".dangky_email").val();
   
    var dataSend={
		detailname:ten,
		username:tk,
		password:mk,
		phone:sdt,
		email:email,
		permission:4
		
    }
    return dataSend;
}
$(".btn_dangkynew").click(function () {
	$(".modaldangkytaikhoan").modal("show");
});
$(".btn_save_dangkynew").click(function () {
    var dataSend=datasendtaikhoan();
	console.log(dataSend);
    if((dataSend.detailname=="")){
        alert_info("Nhập họ và tên");
        $(".dangky_ten").focus();
    }
    else if(dataSend.username==""){
        alert_info("Nhập tên đăng nhập");
        $(".dangky_tk").focus();
    }
    else if(dataSend.password=="") {
		 alert_info("Nhập mật khẩu");
		 $(".dangky_matkhau").focus();
		  
	}else if(dataSend.phone==""){
		alert_info("Nhập số điện thoại");
		 $(".dangky_sdt").focus();
	}
	else
	{
		
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang thêm dữ liệu");
            queryData("users/register", dataSend, function (res) {
                console.log(res);
                if (res.code == 1000) {
              $(".modalshowprogess").modal("hide");
         
                   $(".modaldangkytaikhoan").modal("hide");
                } else if (res.code == 1002) {

                    alert_error("Đã trùng tên đăng nhập");
                
                  $(".modalshowprogess").modal("hide");
                    resetViewloaisp();
                } else {
					$(".modalshowprogess").modal("hide");
                    alert_error("Thêm thất bại");
                }
            });
	}
       
	});
/////////////////////////////
///xem lich su
function builddsddh(iduser,page) {
     
    var dataSend={
	iduser:iduser,
     page:page,
	 record:20,
	 
    }
   
    $(".listhistorydh").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  
    queryData("sanpham/getddh",dataSend,function (res) {
       console.log(res);
        if(res.code==1000){
		
            $(".listhistorydh").html("");
            buildHTMLddhData(res);
            
        }else{
            $(".listhistorydh").html("Tìm không thấy");
        }
    });
}
var resddh;
function buildHTMLddhData(res) {
     var data = res.data.items;
    var currentpage=parseInt(res.data.page);
   resddh=res;
    var htmlinfo='';
   stt=printSTT(20,currentpage);
    for (item in data) {
        var list=data[item];
		var sp=JSON.parse(list.infororder);
		console.log(sp[0].tensp);
		var st="";
		if( list.statusdh==0){
			st="Chưa xử lý";
		}else if(list.statusdh==1)
		{
			st="Đã xác nhận";
		}else{
			st="Đã giao hàng";
		}
		var m="";
		var inforthanhtoan=JSON.parse(list.inforthanhtoan);
		if(inforthanhtoan.loai=="1"){
			m="Tiền mặt";
		}else
		{
			m="Chuyển khoản (STK:'"+inforthanhtoan.sotk+" Tên TK:"+inforthanhtoan.tentk+" Ngân Hàng:"+inforthanhtoan.tennh+")";
		}
		var pp="";
		if(list.methodship=="1"){
			pp="Khách hàng trả phí";
		}else
		{
			pp="Cửa hàng trả phí";
		}
		var sphtml='<tr >'+
			'<td class="btn-show-info-cv"></td>' +
				'<td class="btn-show-info-cv">STT</td>' +
                 '<td class="btn-show-info-cv">Tên Sản phẩm</td>' +
               
                '<td class="btn-show-info-cv">Số lượng</td>' +
                '<td class="btn-show-info-cv">Giá</td>' +
				'<td class="btn-show-info-cv">Đơn vị tính</td>' +
                '<td class="btn-show-info-cv" colspan="2">Thành tiền</td>' +
				'</tr>';
		var sum=0;
		for( i in sp){
			var l=sp[i];
			sum=sum+l.sl*l.gia;
			 
			sphtml=sphtml+'<tr>'+
			'<td class="btn-show-info-cv"></td>' +
				'<td class="btn-show-info-cv">' + (++i) + '</td>' +
                 '<td class="btn-show-info-cv">' + l.tensp + '</td>' +
               
                '<td class="btn-show-info-cv">' + l.sl + '</td>' +
                '<td class="btn-show-info-cv">' +formatNumber( l.gia  , '.', ',') + '</td>' +
				'<td class="btn-show-info-cv">' +l.dvt + '</td>' +
                '<td class="btn-show-info-cv" colspan="2">' +formatNumber( l.sl*l.gia  , '.', ',') + '</td>' +
				'</tr>'+
				'<tr>';
		}
		sphtml=sphtml+
		'<tr><td class="btn-show-info-cv" colspan="5"></td>' +
				'<td  class="btn-show-info-cv"    >Phí Ship</td>' +
				'<td class="btn-show-info-cv"    >'+formatNumber( list.feeship  , '.', ',')+' VNĐ</td>' +
				'</tr>'+
				'<tr><td class="btn-show-info-cv" colspan="5"></td>' +
				'<td class="btn-show-info-cv"  >Tổng thanh toán</td>' +
				'<td class="btn-show-info-cv" >'+formatNumber( (sum+list.feeship)  , '.', ',')+' VNĐ</td>' +
				'</tr>'+
				'<tr><td class="btn-show-info-cv" colspan="7">Ghi chú:Ngày giờ cửa hàng giao hàng:'+getDateTime(list.datetimegiaokhach)+'</td>' +
				
				'</tr>';
         htmlinfo = htmlinfo +
                '<tr data-id="'+list.idddh+'" data-name="  " data-vt="'+item+'">' +
                '<td class="btn-show-info-cv">' + stt + '</td>' +
                 '<td class="btn-show-info-cv">' + list.idddh + '</td>' +
               
                '<td class="btn-show-info-cv">' + getDateTime(list.ngaydat) + '</td>' +
                '<td class="btn-show-info-cv">' +getDateTime(list.ngaygiao) + '</td>' +
				'<td class="btn-show-info-cv">' +pp + '</td>' +
				 '<td class="btn-show-info-cv">' +JSON.parse(list.inforkh).dcgiao + '</td>' +
				    '<td class="btn-show-info-cv">' + m+ '</td>' +
                '<td class="btn-show-info-cv" colspan="2">' + st+ '</td>' +
               
                '</tr>'+sphtml;
				
					
       stt++; 
      
    }
	
      $(".listhistorydh").html(htmlinfo);
	buildSlidePage($(".numberpageddhshop"),5,res.data.page,res.data.totalpage);
}
var ddshop_current=0;
$(".numberpageddhshop").on('click','button',function () {
    //console.log("nha"+$(this).val());
    ddshop_current=$(this).val();
	var oj=JSON.parse(localStorage.getItem("userNS"));
		if(oj!=null){
		builddsddh(oj.iduser,ddshop_current);
		}

});
///
$(".menutracuudonhang").click(function () {
	
	var oj=JSON.parse(localStorage.getItem("userNS"));
		if(oj!=null){
			$(".modalshowtracuudonhang").modal("show");
		builddsddh(oj.iduser,0);
		}else{
			alert_info("Bạn cần đăng nhập mới xem được mục này");
		}
});
function logoutshop() {
    queryData("users/logout",{},function (res) {
		console.log(res);
        if(res.code==1000) {
            localStorage.removeItem("userNS");
            localStorage.removeItem("remmemberNS");
            localStorage.removeItem("usernameNS");
            localStorage.removeItem("passwordNS");
           window.location.href =urlweb+"shop.html";
        }
    });
}
////////////Thanh toan
$(".cb_hinhthuc").click(function () {
if($(".cb_hinhthuc").val()=="1"){
	$(".showtk").hide();
	$(".showsotk").hide();
	//console.log("a");
	
}else if($(".cb_hinhthuc").val()=="2")
{
	$(".showtk").show();
	$(".showsotk").show();
	//console.log("b");
}
	});

////////////
