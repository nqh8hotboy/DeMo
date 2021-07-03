
var iduservinatt=localStorage.getItem("iduserVINATT");
var o={}
o.permission=0;
var p=o.permission;
var resalldangkysp;
getListLoaiSP("cb_loaispdangky");
builddsdangkysp(record,0,p,o);
function builddsdangkysp(record,page,p,o) {
    var charsearch = $(".search_dangkysp").val();
    var loaisp = $(".cb_loaispdangky").val();
	 var expire = $(".cb_expire").val();
	
	if(p==0){
    var dataSend={

        page:page,
        record:record,
        charsearch:charsearch,
        maloai:loaisp,
		expire:expire
    }
  
    $(".listdangkysp").html("<img src='img/loading.gif' width='20px' height='20px'/>");

    queryData("dangkysp/getbyadminweb",dataSend,function (res) {
       //console.log(res);
        if(res.code==1000){

            $(".listdangkysp").html("");
            buildHTMLdangkyspData(res);

        }else{
            $(".listdangkysp").html("Tìm không thấy");
			$(".numberpagedangkysp").html("");
        }
    });
	}
}
$(".lammoidangky").click(function () {
    getListLoaiSP("cb_loaispdangky");
    builddsdangkysp(record,0,p,o);
});
$(".cb_expire").click(function () {

    builddsdangkysp(record,0,p,o);
});
$(".cb_loaispdangky").click(function () {

    builddsdangkysp(record,0,p,o);
});
var search_dangkysp="";
$(".search_dangkysp").keyup(function () {

    builddsdangkysp(record,0,p,o);
});
var dksp_current=0;
$(".numberpagedangkysp ").on('click','button',function () {
    //console.log("nha"+$(this).val());
    dksp_current=$(this).val();
    builddsdangkysp(record,$(this).val(),p,o);

});
$(".dangkysp_loaisp").click(function () {
var loaisp = $(".dangkysp_loaisp").val();
getListSanPhamByLoai("dangkysp_tensp",loaisp,0);
    
});
$(".btn-print-info-save-bvtv").click(function () {
 var ngay=moment($(".bvtv_ngaysudung").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
 var loaithuoc=$(".bvtv_loaithuoc").val();
 var ll=$(".bvtv_ll").val();
    var data={
		ngaysd:ngay,
		loai:loaithuoc,
		lieuluong:ll
	}
	
	abvtv.push(data);
	showinforBVTV(abvtv,"dangkysp_bvtv");
	$(".bvtv_loaithuoc").val("");
 $(".bvtv_ll").val("");
});
//remove chon
$(".dangkysp_bvtv").on('click','.btn-show-info-remove',function () {
	if(p==2||p==1){ //so che, phan phoi
					$(".dangkysp_bvtv").attr('disabled',true);
					
	}else{
	var vt=parseInt($(this).attr("data-vt"));
	abvtv.splice(vt,1);
	
	showinforBVTV(abvtv,"dangkysp_bvtv");
	}
	
});
$(".btn-print-info-save-phanbon").click(function () {
 var ngay=moment($(".phanbon_ngaysudung").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
 var loai=$(".phanbon_loai").val();
 var ll=$(".phanbon_ll").val();
    var data={
		ngaysd:ngay,
		loai:loai,
		lieuluong:ll
	}
	
	aphanbon.push(data);
	showinforBVTV(aphanbon,"dangkysp_phanbon");
	$(".phanbon_loai").val("");
 $(".phanbon_ll").val("");
});
//remove chon
$(".dangkysp_phanbon").on('click','.btn-show-info-remove',function () {
	if(p==2||p==1){ //so che, phan phoi
					$(".dangkysp_phanbon").attr('disabled',true);
					
	}else{
	var vt=parseInt($(this).attr("data-vt"));
	aphanbon.splice(vt,1);
	
	showinforBVTV(aphanbon,"dangkysp_phanbon");
	}
	
});
function showinforBVTV(abvtv,tenbien){
	var  htmlnd='';
	var stt=1;
    for(i=0;i<abvtv.length;i++){

        htmlnd=htmlnd +
            '<tr data-id="" data-name="  " data-vt="'+i+'">' +
'<td class="btn-show-info-cv">' + stt + '</td>' +
            '<td class="btn-show-info-cv">' + getDate(abvtv[i].ngaysd) + '</td>' +
            '<td class="btn-show-info-cv">' + abvtv[i].loai+ '</td>' +
            '<td class="btn-show-info-cv">' + abvtv[i].lieuluong + '</td>' +
 '<td class="btn-show-info-remove"><i class="fa fa-remove"></i></td>' +



            '</tr>';
      
stt++;

    }
    $("."+tenbien).html(htmlnd);
}
//////upload anh san pham
var urllinksetupimagedk=[];


$(".ip-img-user-change_anhdangky").change(function () {
    var obj=$(this);
    uploadImage(obj,function (res) {
    	 
        if(res.code=="1000"){
			
            obj.val("");
			var r1=res.data.url;
			var html="";
						if(urllinksetupimagedk.length<100){
				
		//	urllinksetupimagedk.push(r1.replace("./image_upload/",urlLocal+"image_upload/"));
					urllinksetupimagedk.push(r1.replace("./image_upload/","image_upload/"));
			
			}else{
				alert("Tối đa 100 ảnh");
			}
					updateImageLink(urllinksetupimagedk,"link_dangkysp_anhsp","imguserchange_anhdangky","removelinkdangky");
    
			

        }
        else{
            alert("Upload hình lỗi! Vui lòng thử lại");
        }
    });
	
});
//xoa anh da chon
$(".link_dangkysp_anhsp").on('click','.removelinkdangky',function () {
	
	var id=parseInt($(this).attr("data-vt"));
	
	var dataSend=
	{
		
		urllink:urllinksetupimagedk[id]
	}
	queryData('dangkysp/removellink', dataSend, function (res) {
           
			 
            if (res.code == 1000) {
                urllinksetupimagedk.splice(id,1);
              
				updateImageLink(urllinksetupimagedk,"link_dangkysp_anhsp","imguserchange_anhdangky","removelinkdangky");
				//update lai database san pham
				var dataSend=
				{
		
					idsp:savebarcode,
					listhinh:JSON.stringify(urllinksetupimagedk)
				}
				queryData('dangkysp/updatedangkyspbyidsp', dataSend, function (res) {
					 // console.log("Thành công"+urllinksetupimagedk);
				});
            } else {
				alert_error("File trên máy chủ xóa thất bại");
           
		   }
					
		
        });
});
function buildHTMLdangkyspData(res) {
//	console.log(res);
    var data = res.data.items;

    resalldangkysp=data;
    var currentpage=parseInt(res.data.page);
	var stt=1;
    stt=printSTT(record,currentpage);
    var html='';
    var htmlts='';
    var listinffo='';

    for (item in data) {
        var list=data[item];
        var mota=(JSON.parse(list.mota));
        var sanpham=(JSON.parse(list.infosanpham));
        var ncc=(JSON.parse(list.infoncc));
		var vc=(JSON.parse(list.infonvc));
        var nsc=(JSON.parse(list.infonsc));
        var npp=(JSON.parse(list.infonpp));
        // for(j in thongtin){
        //    listinffo=listinffo+thongtin[j]+'<br>';
        // }
        var s="",p="",v="";
        if(nsc.tennsc==undefined){
            s="Chưa cập nhật";
        }else
        {
            s=nsc.tennsc;
        }
if(vc.tennvc==undefined){
            v="Chưa cập nhật";
        }else
        {
            v=vc.tennvc;
        }
        if(npp.tennpp==undefined){
            p="Chưa cập nhật";
        }else
        {
            p="Xem và cập nhật";
        }
		var e="Còn hạn"
		 //localStorage.setItem("barcode", list.idsp);
		 if(list.expire==0){
		      e="Còn hạn";
		 }else{
			e="Hết hạn";
		 }
        html=html +
            '<tr data-idsp="'+ list.idsp + '" data-name="'+sanpham.tensp+'" data-vt="' + item + '" data-iduser="'+list.iduser+'"  data-expire="'+list.expire+'">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
            '<td class="btn-show-info-cv">' + list.idsp + '</td>' +
			'<td class="btn-show-info-print"><a href="printbarcode.html" target="_blank">Link in QRcode</a></br><a href="'+list.linkqrcode+'" target="_blank">Link xem sản phẩm</a></td>' +
			 '<td class="btn-show-info-ncc">' + ncc.tenncc + '</td>'+
			  '<td class="btn-show-info-ncc">' + list.lo + '</td>'+
            '<td class="btn-show-info-cv">' + sanpham.tensp+'</td>' +
			
			'<td class="btn-show-info-tccs"><i class="fa fa-info-circle"></i> Xem</td>' +
            '<td class="btn-show-info-cv">' +  mota.vietGAP+ '</td>'+
            '<td class="btn-show-info-cv">' + mota.code + '</td>'+
            '<td class="btn-show-info-cv">' + getDate(list.ngaysx) + '</td>'+

            '<td class="btn-show-info-cv">' + getDate(list.hansd) + '</td>'+
          //  '<td class="btn-show-info-thuoc" align="center"><i class="fa fa-info-circle"></i></td>'+
        //    '<td class="btn-show-info-phanbon" align="center"><i class="fa fa-info-circle"></i></td>'+
         //   '<td class="btn-show-info-cv">' + v+'</td>' +
		//	 '<td class="btn-show-info-cv">' + list.biensoxe+'</td>' +
          //  '<td class="btn-show-info-nsc">' + s + '</td>'+
          //  '<td class="btn-show-info-npp">' + p + '</td>'+
			 '<td><a class="btn-work" href="#"><button type="button" class="btn btn-round btn-primary"><i class="fa fa-info-circle">&nbsp;Bắt đầu</i></button></a></td>' +
			   '<td class="btn-show-info-cv">' + e + '</td>'+
            '<td><a class="btn-suandangkysp" href="#"><i class="fa fa-edit"></i></a></td>' +
            '<td><a class="btn-removedangkysp" href="#"><i class="fa fa-trash-o"></i></a></td>' +
			  '<td><a class="btn-lockdangkysp" href="#"><i class="fa fa-lock"></i></a></td>' +
            '</tr>';
        stt++;
        $(".listdangkysp").html(html)
    }
    buildSlidePage($(".numberpagedangkysp"),5,res.data.page,res.data.totalpage);
}
$(".listdangkysp").on('click',".btn-show-info-print",function () {


   var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resalldangkysp[vt];
	//console.log(custom.linkqrcode);
	localStorage.setItem("barcode", custom.linkqrcode);
	//window.location.href = "index.html";
});
function buildhtmldangkysp(res) {
    // var listnhasc = $(".listdangkysp tbody").html("");
 //   console.log(res)
    var data = res.data.items;
    var currentpage=res.data.page;
  //  console.log(data);
   // console.log(data[0].diadiem);

    var arr=JSON.parse(data[0].diadiem);
  //  console.log(arr.length);
    if(arr.length==0){
        alert("Không có chi nhánh nào") ;
        $(".modalshowdschinhanh").modal("hide")
        return;
    }
    else {
        $(".modalshowdschinhanh").modal("show");
      //  console.log("â")
        stt=printSTT(record,currentpage);
        var html='';
        var htmlts='';
        var listinffo='';
        for (item in arr) {
            var list=arr[item];

            html=html +
                '<tr data-id="' + list.id + '"data-name="'+list.tencs+'  "data-vt="' + item + '">' +

                '<td class="btn-show-info-cv">' + stt + '</td>' +
                '<td class="btn-show-info-cv">' + list.tencs + '</td>' +
                '<td class="btn-show-info-cv">' + list.diachi + '</td>'+
                '<td class="btn-show-info-xemmapchinhanh"><a href="#">  '+'>>Xem'+'</a></td>' +
                '<td class="btn-show-info-cv">' + list.sdt + '</td>'+
                '<td class="btn-show-info-cv">' + list.email + '</td>'+

                '<td><a class="btn-removenhasc" href="#"><i class="fa fa-trash-o"></i></a></td>' +
                '</tr>';
            stt++;
            $(".listdschinhanh").html(html)
        }
        buildSlidePage($(".numberpagechitietchnhanh"),5,res.data.page,res.data.totalpage);}
}
$(".listdangkysp").on('click',".btn-show-info-tccs",function () {

    $(".titletccs").html("<i class='fa fa-info-circle'></i>&nbsp; Thông tin ");



    $(".modalshowtccs").modal("show");
    idsp=($(this).parents("tr").attr("data-idsp"));
    var masp=($(this).parents("tr").attr("data-masp"));
	 var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resalldangkysp[vt];
	 $(".addtieuchuan").html(custom.tccs);
});

$(".listdangkysp").on('click',".btn-show-info-thuoc",function () {

    $(".titleinfo").html("<i class='fa fa-info-circle'></i>&nbsp; Thông tin thuốc BVTV");



    $(".modalshowinforcommon").modal("show");
    idsp=($(this).parents("tr").attr("data-idsp"));
    var masp=($(this).parents("tr").attr("data-masp"));
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resalldangkysp[vt];
    var stt=1;
    var listp=JSON.parse(custom.listthuoc);
    var html='<table class="table table-striped table-bordered table-checkable"><thead><tr>'+


        "<th>STT</th>"+
		"<th>Ngày sử dụng</th>"+
        
        "<th>Loại thuốc</th>"+
        "<th>Liều lượng</th>"+

        "</tr>"+
        "</thead>"+

        '<tbody class="listthuoc">';

    html=html+"</tbody></table>";
    $(".showinfocommon").html(html);
    var  htmlnd='';
    for(i=0;i<listp.length;i++){

        htmlnd=htmlnd +
            '<tr data-id="" data-name="  " data-vt="">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
            '<td class="btn-show-info-cv">' + getDate(listp[i].ngaysd) + '</td>' +
            '<td class="btn-show-info-cv">' + listp[i].loai+ '</td>' +
            '<td class="btn-show-info-cv">' + listp[i].lieuluong + '</td>' +


            '</tr>';
        stt++;


    }
    $(".listthuoc").html(htmlnd);





});
//show phan bon
//show phan bon
function isEmpty(obj) {
    for(var key in obj) {
        if(obj.hasOwnProperty(key))
            return false;
    }
    return true;
}
$(".listdangkysp").on('click',".btn-show-info-phanbon",function () {

    $(".titleinfo").html("<i class='fa fa-info-circle'></i>&nbsp; Thông tin phân bón");



    $(".modalshowinforcommon").modal("show");
    idsp=($(this).parents("tr").attr("data-idsp"));
    var masp=($(this).parents("tr").attr("data-masp"));
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resalldangkysp[vt];
    var stt=1;
    var listp=JSON.parse(custom.listphan);
    var html='<table class="table table-striped table-bordered table-checkable"><thead><tr>'+


        "<th>STT</th>"+
        "<th>Ngày sử dụng</th>"+
        "<th>Loại phân bón</th>"+
        "<th>Liều lượng</th>"+



        "</tr>"+
        "</thead>"+

        '<tbody class="listphanbon">';

    html=html+"</tbody></table>";
    $(".showinfocommon").html(html);
    var  htmlnd='';
    for(i=0;i<listp.length;i++){

        htmlnd=htmlnd +
            '<tr data-id="" data-name="  " data-vt="">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
            '<td class="btn-show-info-cv">' + getDate(listp[i].ngaysd) + '</td>' +
            '<td class="btn-show-info-cv">' + listp[i].loai+ '</td>' +
            '<td class="btn-show-info-cv">' + listp[i].lieuluong + '</td>' +



            '</tr>';
        stt++;


    }
    $(".listphanbon").html(htmlnd);





});
$(".listdangkysp").on('click',".btn-show-info-nsc",function () {

    $(".titleinfo").html("<i class='fa fa-info-circle'></i>&nbsp; Thông tin nhà sơ chế/ chế biến");
    idsp=($(this).parents("tr").attr("data-idsp"));
    var masp=($(this).parents("tr").attr("data-masp"));
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resalldangkysp[vt];
    // console.log(  custom.infonsc);

   // console.log(JSON.parse(custom.infonsc));
    var stt=1;
    var listp=JSON.parse(custom.infonsc);
    if(isEmpty(listp)){
        alert("Chưa cập nhật");
        // $(".listphanbon").html("Tìm không thấy");
        // $(".listphu").html("Tìm không thấy");
        // $(".modalshowinforcommon").modal('hide');
        return;
    }
    else {
        $(".modalshowinforcommon").modal("show");
        var listthongtin = JSON.parse(custom.thongtinsc);
        // console.log(listthongtin);
        var html = '<h4>Nhà sơ chế/ chế biến chính</h4>' +
            ' <div class="portlet-content table-responsive nhasoche">' +
            '<table class="table table-striped table-bordered table-checkable"><thead><tr>' +

            "<th>STT</th>" +
            "<th>Mã nhà sơ chế/chế biến</th>" +
            "<th>Tên nhà sơ chế/chế biến</th>" +
            "<th>Mã số thuế</th>" +
            "<th>Địa chỉ</th>" +
            "<th>Số điện thoại</th>" +
            "<th>Email</th>" +
            "<th>Số fax</th>" +
            "<th>Facebook</th>" +
            "<th>Website</th>" +
            "<th>Thông tin cơ sở sơ chế</th>" +

            "</tr>" +
            "</thead>" +

            '<tbody class="listphanbon">';


        html = html + "</tbody></table></div>";
        $(".showinfocommon").html(html);
        var htmlnd = '';
        var htmlinfo = '';
        var listthongtincs = '';
        var tt = JSON.parse(listp.thongtincssc);
        for (var j in tt) {
            listthongtincs = listthongtincs + tt[j] + '<br>';
        }
        htmlnd = htmlnd +
            '<tr data-id="" data-name="  " data-vt="">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
            '<td class="btn-show-info-cv">' + listp.mansc + '</td>' +
            '<td class="btn-show-info-cv">' + listp.tennsc + '</td>' +
            '<td class="btn-show-info-cv">' + listp.mst + '</td>' +
            '<td class="btn-show-info-cv">' + listp.diachi + '</td>' +
            '<td class="btn-show-info-cv">' + listp.sdt + '</td>' +
            '<td class="btn-show-info-cv">' + listp.email + '</td>' +
            '<td class="btn-show-info-cv">' + listp.sofax + '</td>' +
            '<td class="btn-show-info-cv">' + listp.facebook + '</td>' +
            '<td class="btn-show-info-cv">' + listp.website + '</td>' +
            '<td class="btn-show-info-cv">' + listthongtincs + '</td>' +


            '</tr>';

        $(".listphanbon").html(htmlnd);
        var htmls = '<h4>Nhà sơ chế/chế biến chi nhánh</h4>' +
            ' <div class="portlet-content table-responsive">' +

            '<table class="table table-striped table-bordered table-checkable"><thead><tr>' +

            "<th>STT</th>" +
            "<th>Công nghệ</th>" +
            "<th>Mã nhà sơ chế/chế biến</th>" +
            "<th>Tên nhà sơ chế/chế biến</th>" +
            "<th>Địa chỉ</th>" +
            "<th>Số điện thoại</th>" +
            "<th>Email</th>" +
            "</tr>" +
            "</thead>" +

            '<tbody class="listphu">';

        htmls = htmls + "</tbody></table></div>";
        $(".showinfocommon").append(htmls);
        var htmlinfo = '';
        var congnghe = '';
        var listcongnghe = listthongtin.congnghe;
        for (var c in listcongnghe) {
            congnghe = congnghe + listcongnghe[c] + '<br>';
        }
        // console.log(listthongtin.diadiem);
        var listdd = listthongtin.diadiem;
        for (var i in listdd) {
            // console.log(listdd[i]);
            htmlinfo = htmlinfo +
                '<tr data-id="" data-name="  " data-vt="">' +
                '<td class="btn-show-info-cv">' + stt + '</td>' +
                '<td class="btn-show-info-cv">' + congnghe + '</td>' +

                '<td class="btn-show-info-cv">' + listdd[i].id + '</td>' +
                '<td class="btn-show-info-cv">' + listdd[i].tencs + '</td>' +
                '<td class="btn-show-info-cv">' + listdd[i].diachi + '</td>' +
                '<td class="btn-show-info-cv">' + listdd[i].sdt + '</td>' +
                '<td class="btn-show-info-cv">' + listdd[i].email + '</td>' +
                '</tr>';
            stt++;
            // console.log(htmlinfo);
            $(".listphu").html(htmlinfo);
        }
    }
});
//remove tung phan tu trong mang
/////////////xu ly update thong tin nha phan phoi
$(".listnhapp").on('click',".btn-show-info-removesingle",function () {
	
	 // iddh=parseInt($(this).parents("tr").attr("data-id"));
	  idsp=$(this).parents("tr").attr("data-idsp");
	   var posvt=parseInt($(this).parents("tr").attr("data-vt"));
	    var posvtj=parseInt($(this).parents("tr").attr("data-vtj"));
	//	console.log(posvt);
		//console.log(posvtj);
	   //$(".modalapgia").modal("show");
	//$(".apgianew").val("");
	//console.log(tempNPP[posvt]);
	/*tempNPP.splice(posvt,1);
	var dataSend={
		idsp:idsp,
		thongtinpp:JSON.stringify(tempNPP)
	}
	console.log(dataSend);
	$(".modalshowprogess").modal("show");
 queryData("dangkysp/updatenhapp", dataSend, function (res) {
             
                if (res.code == 1000) {
                 
                   // builddsddhadmin(schon,ddshopadmin_current);
                  // apush=[];
				  // $(".modalapgia").modal("hide");
				  showHTMLNHAPPP(tempNPP,idsp);
                    
                } else {
                    alert_error("Cập nhật thất bại");
                }
				$(".modalshowprogess").modal("hide");
            });
			*/
})
///////////
/////////////xu ly update thong tin nha phan phoi
$(".listnhapp").on('click',".btn-show-info-removeall",function () {
	
	 // iddh=parseInt($(this).parents("tr").attr("data-id"));
	  idsp=$(this).parents("tr").attr("data-idsp");
	   var posvt=parseInt($(this).parents("tr").attr("data-vt"));
	   //$(".modalapgia").modal("show");
	//$(".apgianew").val("");
	//console.log(tempNPP[posvt]);
	tempNPP.splice(posvt,1);
	var dataSend={
		idsp:idsp,
		thongtinpp:JSON.stringify(tempNPP)
	}
//	console.log(dataSend);
	$(".modalshowprogess").modal("show");
 queryData("dangkysp/updatenhapp", dataSend, function (res) {
             
                if (res.code == 1000) {
                 
                   // builddsddhadmin(schon,ddshopadmin_current);
                  // apush=[];
				  // $(".modalapgia").modal("hide");
				  showHTMLNHAPPP(tempNPP,idsp);
                    
                } else {
                    alert_error("Cập nhật thất bại");
                }
				$(".modalshowprogess").modal("hide");
            });
})
///////////
var tempNPP=[];
$(".listdangkysp").on('click',".btn-show-info-npp",function () {
    // console.log("a")
    $(".titleinfo").html("<i class='fa fa-info-circle'></i>&nbsp; Thông tin nhà phân phối");

    idsp=($(this).parents("tr").attr("data-idsp"));
    var masp=($(this).parents("tr").attr("data-masp"));
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resalldangkysp[vt];
    // console.log(custom);

  //   console.log( JSON.parse(custom.infonpp));
    var stt=1;
    var listp=JSON.parse(custom.infonpp);
    if(isEmpty(listp)){
        alert("Chưa cập nhật");
        return;
    }
    else {
        $(".modalshowinforlistnpp").modal("show");
		if(custom.thongtinpp==null ||custom.thongtinpp=="" ||custom.thongtinpp==undefined){
			listthongtin=[];
		}
		else
		{
        listthongtin = JSON.parse(custom.thongtinpp);
		}
      //  console.log(listthongtin);
        tempNPP=listthongtin;
        showHTMLNHAPPP(listthongtin,custom.idsp);
        // $(".showinfocommon").append(htmls);
    }
});
function showHTMLNHAPPP(listthongtin,idsp){
	var htmlnd = '';
		var stt=1;
		for(i in listthongtin){
			var l=listthongtin[i];
			var li=l.list;
			var htmlinfo='<tr data-id="" data-name="  " data-vt="" >' +
				'<td class="btn-show-info-cv"></td>' +
                '<td class="btn-show-info-cv">STT</td>' +
                '<td class="btn-show-info-cv">Tên</td>' +
                '<td class="btn-show-info-cv">Địa chỉ</td>' +
                '<td class="btn-show-info-cv">Kênh phân phối</td>' +
                '<td class="btn-show-info-cv">Số điện thoại</td>' +
                '<td class="btn-show-info-cv">Email</td>' +
               '<td class="btn-show-info-remove">Xóa</td>' +
               
                '</tr>';
			var stts=1;
			for(var j in li ){
				var k=li[j];
				htmlinfo = htmlinfo +
                '<tr data-id="'+idsp+'" data-name="  " data-vt="'+i+'" data-vtj="'+j+'" >' +
				'<td class="btn-show-info-cv"></td>' +
                '<td class="btn-show-info-cv">' + stts + '</td>' +
              
                '<td class="btn-show-info-cv">' + k.tencs + '</td>' +
                '<td class="btn-show-info-cv">' + k.diachi + '</td>' +
                '<td class="btn-show-info-cv">' + k.kenhpp + '</td>' +
                '<td class="btn-show-info-cv">' + k.sdt + '</td>' +
                '<td class="btn-show-info-cv">' + k.email + '</td>' +
				'<td class="btn-show-info-removesingle"><i class="fa fa-remove"></i></td>' +
                '</tr>';
            stts++;
			}
        htmlnd = htmlnd +
            '<tr data-idsp="'+idsp+'" data-name="  " data-vt="'+i+'" >' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
            '<td class="btn-show-info-cv">' + l.manpp + '</td>' +
            '<td class="btn-show-info-cv">' + l.tennpp + '</td>' +
            '<td class="btn-show-info-cv">' + l.mst + '</td>' +
            '<td class="btn-show-info-cv">' + l.diachi + '</td>' +
            '<td class="btn-show-info-cv">' + l.sdt + '</td>' +
            '<td class="btn-show-info-cv">' + l.email + '</td>' +
            '<td class="btn-show-info-cv">' + l.sofax + '</td>' +
            '<td class="btn-show-info-cv">' + l.facebook + '</td>' +
            '<td class="btn-show-info-cv">' + l.website + '</td>' +
			'<td class="btn-show-info-removeall"><i class="fa fa-remove"></i></td>' +
            '</tr>'+htmlinfo;
			stt++;
		

       


        
        
	}
	 $(".listnhapp").html(htmlnd);
}
$(".listdangkysp").on('click',".btn-show-info-ncc",function () {
    // console.log("a")
    $(".titleinfo").html("<i class='fa fa-info-circle'></i>&nbsp; Thông tin nhà cung cấp");

    idsp=($(this).parents("tr").attr("data-idsp"));
    var masp=($(this).parents("tr").attr("data-masp"));
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resalldangkysp[vt];
    // console.log(custom);
    // console.log( JSON.parse(custom.infoncc));
    var stt=1;
    var listp=JSON.parse(custom.infoncc);
    if(isEmpty(listp)){
        alert("Chưa cập nhật");
        return;
    }
    else {
        $(".modalshowinforcommon").modal("show");

        var html = ' <div class="portlet-content table-responsive nhaphanphoi">' +

            '<table class="table table-striped table-bordered table-checkable"><thead><tr>' +

            "<th>STT</th>" +
            "<th>Mã nhà cung cấp</th>" +
            "<th>Tên nhà cung cấp</th>" +
            "<th>Mã số thuế</th>" +
            "<th>Địa chỉ</th>" +
            "<th>Số điện thoại</th>" +
            "<th>Email</th>" +
            "<th>Số fax</th>" +
            "<th>Facebook</th>" +
            "<th>Website</th>" +

            "</tr>" +
            "</thead>" +

            '<tbody class="listphanbon">';

        html = html + "</tbody></table></div>";
        $(".showinfocommon").html(html);
        var htmlnd = '';
        var htmlinfo = '';
        htmlnd = htmlnd +
            '<tr data-id="" data-name="  " data-vt="">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
            '<td class="btn-show-info-cv">' + listp.mancc + '</td>' +
            '<td class="btn-show-info-cv">' + listp.tenncc + '</td>' +
            '<td class="btn-show-info-cv">' + listp.mst + '</td>' +
            '<td class="btn-show-info-cv">' + listp.diachi + '</td>' +
            '<td class="btn-show-info-cv">' + listp.sdt + '</td>' +
            '<td class="btn-show-info-cv">' + listp.email + '</td>' +
            '<td class="btn-show-info-cv">' + listp.sofax + '</td>' +
            '<td class="btn-show-info-cv">' + listp.facebook + '</td>' +
            '<td class="btn-show-info-cv">' + listp.website + '</td>' +


            '</tr>';

        $(".listphanbon").html(htmlnd);
    }
});
//serach nha cung cap
$(".search_dangkynhacungcap").keyup(function () {
    
    buildsearchdssanxuat(0);
});
$(".dangkysp_themmoinhcungcap").click(function () {
    $(".modalshowinforncc").modal("show");
    buildsearchdssanxuat(0);
});
function buildsearchdssanxuat(page) {
    var charsearch=$(".search_dangkynhacungcap").val();

    var dataSend={
        page:page,
        record:20,

        charsearch:charsearch

    }

    $(".listsearchnhacungcap tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");

    queryData("nhacungcap/get",dataSend,function (res) {
       
        if(res.code==1000){

            $(".listsearchnhacungcap").html("");
            buildHTMLsearchsanxuatData(res);
            

        }else{
            $(".listsearchnhacungcap").html("Tìm không thấy");
			$(".numberpagesearchnhacc").html("");
        }
    });
}
var aNCC=[];

function buildHTMLsearchsanxuatData(res) {

    var data = res.data.items;
aNCC=data;
     var stt=1;
    var currentpage=parseInt(res.data.page);
    stt=printSTT(20,currentpage);
    var html='';

   
    for (item in data) {
        var list=data[item];


        html=html +
            '<tr data-mancc="' + list.mancc + '" data-iduser="' + list.iduser + '" data-name="'+list.tenncc+'  "data-vt="' + item + '" class="showchonncc">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
            '<td class="btn-show-info-cv">' + list.mancc + '</td>' +
            '<td class="btn-show-info-cv">' + list.tenncc + '</td>' +
            '<td class="btn-show-info-cv">' + list.mst + '</td>' +
            '<td class="btn-show-info-cv">' + list.diachi + '</td>' +

            
            '<td class="btn-show-info-cv">' + list.sdt + '</td>' +
            '<td class="btn-show-info-cv">' + list.email+'</td>'+
            '<td class="btn-show-info-cv">' + list.website+'</td>'+
            '<td class="btn-show-info-cv">' + list.sofax+'</td>'+
            '<td class="btn-show-info-cv">' + list.facebook+'</td>'+

'<td class="btn-show-info-cv"><input type="radio" name="abc"/></td>' +
         


            '</tr>';
        stt++;
        $(".listsearchnhacungcap").html(html)
    }
    buildSlidePage($(".numberpagesearchnhacc"),5,res.data.page,res.data.totalpage);
}
$(".numberpagesearchnhacc").on('click','button',function () {
    
    buildsearchdssanxuat($(this).val());
    
});
var iduservinatt_save=0;
$(".listsearchnhacungcap").on('click',".btn-show-info-cv",function () {
	 var vt=($(this).parents("tr").attr("data-vt"));
	  var id=($(this).parents("tr").attr("data-iduser"));
		$(".dangkysp_mancc").val(aNCC[vt].mancc);
		iduservinatt_save=id;
		
		  $(".modalshowinforncc").modal("hide");
	
});
///////////serch nha so che che bien

$(".search_dangkynsc").keyup(function () {
    
    buildsearchdssc(0);
});
$(".dangkysp_themmoinhsc").click(function () {
    $(".modalshowinfornsc").modal("show");
    buildsearchdssc(0);
});
function buildsearchdssc(page) {
    var charsearch=$(".search_dangkynsc").val();

    var dataSend={
        page:page,
        record:20,

        charsearch:charsearch

    }

    $(".listsearchnhasc tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");

    queryData("nhasoche/get",dataSend,function (res) {
       
        if(res.code==1000){

            $(".listsearchnhasc").html("");
            buildHTMLsearchscData(res);
            

        }else{
            $(".listsearchnhasc").html("Tìm không thấy");
			$(".numberpagesearchnhasc").html("");
        }
    });
}
var aSoche=[];

function buildHTMLsearchscData(res) {

    var data = res.data.items;
   aSoche=data;
   
   var currentpage=parseInt(res.data.page);
    stt=printSTT(20,currentpage);
    var html='';
    
	var stt=1;
    for (item in data) {
        var list=data[item];
      
       
        html=html +
            '<tr data-mansc="' + list.mansc + '"data-name="'+list.tennsc+'  "data-vt="' + item + '">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
            '<td class="btn-show-info-cv">' + list.mansc + '</td>' +
			'<td class="btn-show-info-cv">' + list.tennsc + '</td>' +
			'<td class="btn-show-info-cv">' + list.mst + '</td>' +
			'<td class="btn-show-info-cv">' + list.diachi + '</td>' +
			
			'<td class="btn-show-info-cv">' + list.sdt + '</td>' +
            '<td class="btn-show-info-cv">' + list.email+'</td>'+
			  '<td class="btn-show-info-cv">' + list.website+'</td>'+
			    '<td class="btn-show-info-cv">' + list.sofax+'</td>'+
				 '<td class="btn-show-info-cv">' + list.facebook+'</td>'+
			 
			
            
            '</tr>';
        stt++;
        $(".listsearchnhasc").html(html)
    }
    buildSlidePage($(".numberpagesearchnhasc"),5,res.data.page,res.data.totalpage);
}
//////////////////////////
$(".dangkysp_themmoinhavc").click(function () {
    $(".modalshowinfornvc").modal("show");
    buildsearchdsvc(0);
});
$(".search_dangkynvc").keyup(function () {
    
    buildsearchdsvc(0);
});
//////////////
function buildsearchdsvc(page) {
    var charsearch=$(".search_dangkynvc").val();

    var dataSend={
        page:page,
        record:20,

        charsearch:charsearch

    }

    $(".listsearchnhavc tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");

    queryData("nhavc/get",dataSend,function (res) {
       
        if(res.code==1000){

            $(".listsearchnhavc").html("");
            buildHTMLsearchvcData(res);
            

        }else{
            $(".listsearchnhavc").html("Tìm không thấy");
			$(".numberpagesearchnhavc").html("");
        }
    });
}
var aVC=[];

function buildHTMLsearchvcData(res) {

    var data = res.data.items;
   aVC=data;
   
   var currentpage=parseInt(res.data.page);
    stt=printSTT(20,currentpage);
    var html='';
    
	var stt=1;
    for (item in data) {
        var list=data[item];
      
       
        html=html +
            '<tr data-mansc="' + list.manvc + '"data-name="'+list.tennvc+'  "data-vt="' + item + '">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
            '<td class="btn-show-info-cv">' + list.manvc + '</td>' +
			'<td class="btn-show-info-cv">' + list.tennvc + '</td>' +
			'<td class="btn-show-info-cv">' + list.mst + '</td>' +
			'<td class="btn-show-info-cv">' + list.diachi + '</td>' +
			
			'<td class="btn-show-info-cv">' + list.sdt + '</td>' +
            '<td class="btn-show-info-cv">' + list.email+'</td>'+
			  '<td class="btn-show-info-cv">' + list.website+'</td>'+
			    '<td class="btn-show-info-cv">' + list.sofax+'</td>'+
				 '<td class="btn-show-info-cv">' + list.facebook+'</td>'+
			 
			
            
            '</tr>';
        stt++;
        $(".listsearchnhavc").html(html)
    }
    buildSlidePage($(".numberpagesearchnhavc"),5,res.data.page,res.data.totalpage);
}
$(".numberpagesearchnhavc").on('click','button',function () {
    
    buildsearchdsvc($(this).val());
    
});
$(".listsearchnhavc").on('click',".btn-show-info-cv",function () {
	 var vt=($(this).parents("tr").attr("data-vt"));
	  var id=($(this).parents("tr").attr("data-iduser"));
		$(".dangkysp_manvc").val(aVC[vt].manvc);
		iduser=id;
		
		  $(".modalshowinfornvc").modal("hide");
	
});
/////////////////////////
var luudiadiem=[];
var luuthongtinsc=[];
$(".listsearchnhasc").on('click',".btn-show-info-cv",function () {
	 var vt=($(this).parents("tr").attr("data-vt"));
	  luumanhasc=aSoche[vt].mansc;
		var listdd=JSON.parse(aSoche[vt].diadiem);
		var inforsc=aSoche[vt].thongtincssc;
		var congnghe=JSON.parse(inforsc);
		luudiadiem=listdd;
		luuthongtinsc=congnghe;
		var stt=1;
			var htmlinfo='';
			for(var i=0;i<listdd.length;i++){
				
        htmlinfo = htmlinfo +
                '<tr data-id="" data-name="  " data-vt="">' +
                '<td class="btn-show-info-cv">' + stt + '</td>' +
                '<td class="btn-show-info-cv">' + congnghe + '</td>' +

                '<td class="btn-show-info-cv">' + listdd[i].id + '</td>' +
                '<td class="btn-show-info-cv">' + listdd[i].tencs + '</td>' +
                '<td class="btn-show-info-cv">' + listdd[i].diachi + '</td>' +
                '<td class="btn-show-info-cv">' + listdd[i].sdt + '</td>' +
                '<td class="btn-show-info-cv">' + listdd[i].email + '</td>' +
				 '<td class="btn-show-info-chon"><input type="checkbox" name="nhasc" value='+i+'></td>' +
                '</tr>';
				stt++;
			}
			$(".listdetailsoche").html(htmlinfo)
		  $(".modalshowdetailinfornhasoche").modal("show");
		    $(".modalshowinfornsc").modal("hide");
	
});
//lay thong tin checkable
var listsoche=[];
function getValueUsingParentTagActive(){
	//var chkArray = [];
	var chkArrayhome = [];
	listsoche=[];
	$('input[name="nhasc"]:checked').each(function() {
   chkArrayhome.push(this.value);
});
		
	
		
	
	if(chkArrayhome.length > 0){
		listsoche=chkArrayhome;
		chkArrayhome=[];
		//alert("You have selected " + listsoche);	
	}else{
		alert("Phải chọn ít nhất 1 địa điểm sơ chế hoặc chế biến");	
	}
	
}
var dataluunsc=[];
$(".btn-print-info-chon-dangkychonnhasoche").click(function () {
	getValueUsingParentTagActive();
	dataluunsc=[];
    $(".modalshowdetailinfornhasoche").modal("hide");
	//console.log(listsoche);
	for(var i=0;i<listsoche.length;i++){
	//	console.log(luudiadiem[listsoche[i]]);
		dataluunsc.push(luudiadiem[listsoche[i]]);
	}
	$(".dangkysp_mansc").val(luumanhasc);

	
});
/////////////xu ly phan nha phan phoi
var luudiadiemphanphoi=[];
var aPhanphoi=[];
var arnpp=[];
$(".listsearchnhapp").on('click',".btn-show-info-cv",function () {
	 var vt=($(this).parents("tr").attr("data-vt"));
	 luumanhapp=aPhanphoi[vt].manpp;
	 arnpp=aPhanphoi[vt];
		var listdd=JSON.parse(aPhanphoi[vt].diadiem);
		
		luudiadiemphanphoi=listdd;
		
		var stt=1;
			var htmlinfo='';
			for(var i=0;i<listdd.length;i++){
				
        htmlinfo = htmlinfo +
                '<tr data-id="" data-name="  " data-vt="">' +
                '<td class="btn-show-info-cv">' + stt + '</td>' +
                
               
                '<td class="btn-show-info-cv">' + listdd[i].tencs + '</td>' +
                '<td class="btn-show-info-cv">' + listdd[i].diachi + '</td>' +
				 '<td class="btn-show-info-cv">' + listdd[i].kenhpp + '</td>' +
                '<td class="btn-show-info-cv">' + listdd[i].sdt + '</td>' +
                '<td class="btn-show-info-cv">' + listdd[i].email + '</td>' +
				 '<td class="btn-show-info-chon"><input type="checkbox" name="nhapp" value='+i+'></td>' +
                '</tr>';
				stt++;
			}
			$(".listdetailphanphoi").html(htmlinfo)
		  $(".modalshowdetailinfornhaphanphoi").modal("show");
		 // $(".modalshowinfornpp").modal("hide");
		  
	
});
//lay thong tin checkable
var listpp=[];
function getValueUsingParentTagActivePP(){
	//var chkArray = [];
	var chkArrayhome = [];
	listpp=[];
	$('input[name="nhapp"]:checked').each(function() {
   chkArrayhome.push(this.value);
});
		
	
		
	
	if(chkArrayhome.length > 0){
		listpp=chkArrayhome;
		chkArrayhome=[];
		//alert("You have selected " + listsoche);	
	}else{
		alert("Phải chọn ít nhất 1 địa điểm phân phối sản phẩm");	
	}
	
}
var dataluunpp=[];
var luumanhapp;
var luumanhasc;
var luumanhanvc;
var mangGloal=[];
$(".btn-print-info-chon-dangkychonnhaphanphoi").click(function () {
	getValueUsingParentTagActivePP();
	dataluunpp=[];
    $(".modalshowdetailinfornhaphanphoi").modal("hide");
	
	for(var i=0;i<listpp.length;i++){
		
		dataluunpp.push(luudiadiemphanphoi[listpp[i]]);
	}
	var d={
		list:dataluunpp,
		manpp:arnpp.manpp,
		tennpp:arnpp.tennpp,
		mst:arnpp.mst,
		diachi:arnpp.diachi,
		sdt:arnpp.sdt,
		email:arnpp.email,
		website:arnpp.website,
		sofax:arnpp.sofax,
		facebook:arnpp.facebook,
		lat:arnpp.lat,
		lng:arnpp.lng
	}
	//mang nay la mang chua nhieu nha phan phoi
	mangGloal.push(d);
	//console.log(mangGloal);
	$(".dangkysp_manpp").val(luumanhapp);
});


/////////
$(".numberpagesearchnhasc").on('click','button',function () {
    
    buildsearchdssc($(this).val());
    
});

///////////////nha phan phoi
///////////serch nha so che che bien

$(".search_dangkynpp").keyup(function () {
    
    buildsearchdspp(0);
});
$(".dangkysp_themmoinhpp").click(function () {
    $(".modalshowinfornpp").modal("show");
    buildsearchdspp(0);
});
function buildsearchdspp(page) {
    var charsearch=$(".search_dangkynpp").val();

    var dataSend={
        page:page,
        record:20,

        charsearch:charsearch

    }

    $(".listsearchnhapp tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");

    queryData("nhaphanphoi/get",dataSend,function (res) {
       
        if(res.code==1000){

            $(".listsearchnhapp").html("");
            buildHTMLsearchppData(res);
            

        }else{
            $(".listsearchnhapp").html("Tìm không thấy");
        }
    });
}

function buildHTMLsearchppData(res) {

    var data = res.data.items;
   
    aPhanphoi=data;
   var currentpage=parseInt(res.data.page);
    stt=printSTT(20,currentpage);
    var html='';
    
	var stt=1;
    for (item in data) {
        var list=data[item];
      
       
        html=html +
            '<tr data-manpp="' + list.manpp + '"data-name="'+list.tennpp+'  "data-vt="' + item + '">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
            '<td class="btn-show-info-cv">' + list.manpp + '</td>' +
			'<td class="btn-show-info-cv">' + list.tennpp + '</td>' +
			'<td class="btn-show-info-cv">' + list.mst + '</td>' +
			'<td class="btn-show-info-cv">' + list.diachi + '</td>' +
			
            
			'<td class="btn-show-info-cv">' + list.sdt + '</td>' +
            '<td class="btn-show-info-cv">' + list.email+'</td>'+
			  '<td class="btn-show-info-cv">' + list.website+'</td>'+
			    '<td class="btn-show-info-cv">' + list.sofax+'</td>'+
				 '<td class="btn-show-info-cv">' + list.facebook+'</td>'+
			  
			
            
            '</tr>';
        stt++;
        $(".listsearchnhapp").html(html)
    }
    buildSlidePage($(".numberpagesearchnhasc"),5,res.data.page,res.data.totalpage);
}

$(".numberpagesearchnhasc").on('click','button',function () {
    
    buildsearchdspp($(this).val());
    
});
////////////Xu ly tao doi tuong
var linkqrcode="";
$(".dangkysp_qrcode").blur(function(){
	var qrcode=  $(".dangkysp_qrcode").val();
   linkqrcode=urlwebtrace+"trace.html?idsp=-"+qrcode;
   $(".dangkysp_linkqrcode").val(linkqrcode);
});

function datasenddangky(){
var asanpham;
	var qrcode=  $(".dangkysp_qrcode").val();
 var mancc= $(".dangkysp_mancc").val();
 var manpp= 0;//  $(".dangkysp_manpp").val();
 var mansc=0;//  $(".dangkysp_mansc").val();
 var manvc=0;//  $(".dangkysp_manvc").val();
 var biensoxe="";//  $(".dangkysp_biensoxe").val();
  var masp=  $(".dangkysp_tensp").val();
   var lo=  $(".dangkysp_lo").val();
 var linkqrcode= $(".dangkysp_linkqrcode").val();
  var linkqrcode_rutgon= "";//$(".dangkysp_linkqrcode_rutgon").val();
  var mausac={
	  vietGAP:"",//$(".dangkysp_mavietgap").val(),
	  mausac:$(".dangkysp_mausac").val(),
	  code:""//$(".dangkysp_code").val()
  }
  
  var ngaysx=moment($(".dangky_ngaysx").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
   var tem=ngaysx;
  var hansd=moment($(".dangky_hansd").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
 var date=new Date(tem);
    var d=date.getDate()<10? "0"+date.getDate():date.getDate();
    var m=(date.getMonth()+1)<10? "0"+(date.getMonth()+1):(date.getMonth()+1);
    var y=date.getFullYear()<10? "0"+date.getFullYear():date.getFullYear();
	var n=y.toString().substr(2,2);
	var thongtin={
		congnghe:luuthongtinsc,
		diadiem:dataluunsc
		
	}
 var content=CKEDITOR.instances.editortccssanpham.getData();
 var contentlink=CKEDITOR.instances.editorexternallink.getData();
 if(qrcode=="" || qrcode==undefined || qrcode==null){
	   alert_info("Phải nhập mã qrcode");
 }else 
  if(masp==null || masp=="" || masp==undefined){
	  alert_info("Phải chọn sản phẩm để cấp mã QRCode");
  }else{
	var dataSend={
		
		
		idsp:qrcode,
		masp:masp,
		mancc:mancc,
		mansc:mansc,
		manpp:manpp,
		manvc:manvc,
		biensoxe:biensoxe,
		mota:JSON.stringify(mausac),
		lo:lo,
		externallink:contentlink,
		//listthuoc:JSON.stringify(abvtv),
		//listphan:JSON.stringify(aphanbon),
		ngaysx:ngaysx,
		hansd:hansd,
		listhinh:JSON.stringify(urllinksetupimagedk),
		thongtinsc:JSON.stringify(thongtin),
		//thongtinpp:JSON.stringify(dataluunpp),
		thongtinpp:JSON.stringify(mangGloal),
		tccs:content,
		iduser:iduservinatt_save,
		expire:0,
		linkqrcode:linkqrcode,
		rutgonlink:linkqrcode_rutgon
		
		
   
  }
	
  }
   
    return dataSend;
}
function resetViewdangkysp() {
	$(".showhidetensp").hide();
	$(".dangkysp_linkqrcode").val("");
	//$(".dangkysp_linkqrcode_rutgon").val("");
	$(".dangkysp_qrcode").val("");
     $(".dangkysp_mancc").val("");
  //$(".dangkysp_manpp").val("");
   //$(".dangkysp_mansc").val("");
   //$(".dangkysp_manvc").val("");
 //$(".dangkysp_biensoxe").val("");
//$(".dangkysp_phanbon").html("");
// $(".dangkysp_bvtv").html("");
  $(".link_dangkysp_anhsp").html("");
	  $(".dangkysp_mavietgap").val("");
	  $(".dangkysp_mausac").val("");
	  $(".dangkysp_code").val("");
 abvtv=[];
 aphanbon=[];
  urllinksetupimagedk=[];
dataluunsc=[];
dataluunpp=[];
luudiadiem=[];
luuthongtinsc=[];
mangGloal=[];
    $(".titledangkysanpham").html("<i class='fa fa-plus'></i>&nbsp; Tạo đăng ký mới sản phẩm");
   $(".showhidengaysx").show();	
$(".showhideloaisp").show();
 $(".dangkysp_mancc").attr('disabled',false);
 $(".dangkysp_themmoinhcungcap").attr('disabled',false);
CKEDITOR.instances.editortccssanpham.setData("");
CKEDITOR.instances.editorexternallink.setData("");
}

//them
$(".btn-print-info-save-dangkysp").click(function () {
    if ($(".modalshowdangkysanpham").attr("data-editting") == "false") {
   
	  var dataSend=datasenddangky();
 //  console.log(dataSend);
  if(dataSend.manpp==""){
	  dataSend.manpp=0;
  }
   if(dataSend.mansc==""){
	  dataSend.mansc=0;
  }
     if(dataSend.mancc==""){
		   alert_info("Chọn nhà cung cấp");
        $(".dangkysp_mancc").focus();
	}else if(dataSend.masp==""){
		 alert_info("Chọn sản phẩm");
        $(".masp").focus();
	}else if(dataSend.ngaysx==undefined){
        alert_info("Chọn ngày sản xuất");
        $(".dangky_ngaysx").focus();
    }
   else
	{
		
		$(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang thêm dữ liệu");
            queryData("dangkysp/create", dataSend, function (res) {
               
                if (res.code == 1000) {
             $(".modalshowprogess").modal("hide");
         //  $(".modalshowdangkysanpham").modal("hide");
                    builddsdangkysp(record,dksp_current,p,o);
                    resetViewdangkysp();
					swapMain("dangkysp");
					//getsanphamData();
                } else if (res.code == 1002) {

                    alert_error("Đã trùng mã QRCode");
                
                  $(".modalshowprogess").modal("hide");
                   // resetViewdangkysp();
					
                } else {
					$(".modalshowprogess").modal("hide");
                    alert_error("Thêm thất bại");
                }
            });
        }
	}		else {
           
          $(".modalshowprogess").modal("show");
           $(".tientrinhxuly").html("Đang cập nhật dữ liệu");
		   dataSend=datasendsuadangky();
		  
		
            queryData("dangkysp/update", dataSend, function (res) {
            // console.log(res);
                if (res.code == 1000) {
                 
                    builddsdangkysp(record,dksp_current,p,o);
                    resetViewdangkysp();
                   // $(".modalshowdangkysanpham").modal("hide");
					swapMain("dangkysp");
                    
                } else {
                    alert_error("Cập nhật thất bại");
                }
				$(".modalshowprogess").modal("hide");
            });

        }


});
var savebarcode,savesoche,savepp,savemasp,savengaysx,savehansd,expire=0;
$(".listdangkysp").on('click',".btn-suandangkysp",function () {
	//getListLoaiSP("dangkysp_loaisp");
	swapMain("adddangkysp");
	if(p==2){
			$(".dangkysp_mausac").attr('disabled',true);
			$(".dangkysp_code").attr('disabled',true);
			$(".dangkysp_mavietgap").attr('disabled',true);
					$(".dangkysp_thembvtv").attr('disabled',true);
					$(".dangkysp_themphanbon").attr('disabled',true);
	}		
		if(p==1){//phan phoi
			
			$(".dangkysp_mansc").attr('disabled',true);
				$(".dangkysp_manvc").attr('disabled',true);
				
			$(".dangkysp_themmoinhsc").attr('disabled',true);
			$(".dangkysp_mausac").attr('disabled',true);
			$(".dangkysp_code").attr('disabled',true);
			$(".dangkysp_mavietgap").attr('disabled',true);
				$(".dangkysp_thembvtv").attr('disabled',true);
					$(".dangkysp_themphanbon").attr('disabled',true);
			
		}
$(".showhidetensp").show();	
$(".showhideloaisp").hide();	
$(".dangkysp_mancc").attr('disabled',false);
$(".dangkysp_themmoinhcungcap").attr('disabled',false);
   var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resalldangkysp[vt];
	console.log(custom);
	$(".titledangkysanpham").html("<i class='fa fa-edit'></i>&nbsp; Sửa sản phẩm đăng ký:"+custom.idsp);
    $(".modalshowdangkysanpham").attr("data-editting",true);

   CKEDITOR.instances.editortccssanpham.setData(custom.tccs);
   CKEDITOR.instances.editorexternallink.setData(custom.externallink);
  //  $(".modalshowdangkysanpham").modal("show");
    $(".dangkysp_lo").val(custom.lo);
     $(".dangkysp_mancc").val(custom.mancc);
	//  $(".dangkysp_mansc").val(custom.mansc);
	  //  $(".dangkysp_manvc").val(custom.manvc);
	//	$(".dangkysp_biensoxe").val(custom.biensoxe);
	  // $(".dangkysp_manpp").val(custom.manpp);
	   var inforsp=JSON.parse(custom.infosanpham);
	  expire=custom.expire;
	//  console.log(""+inforsp.maloaisp);
	   $(".dangkysp_tensp_sua").val(inforsp.tensp);
	  //  $(".dangkysp_tensp").val(inforsp.tensp);
	$(".dangkysp_qrcode").val(custom.idsp);
	   var mota=JSON.parse(custom.mota);
	   $(".dangkysp_mausac").val(mota.mausac);
	    // $(".dangkysp_mavietgap").val(mota.vietGAP);
		 //  $(".dangkysp_code").val(mota.code);
		    $(".dangky_ngaysx").val(getDate(custom.ngaysx));
			  $(".dangky_hansd").val(getDate(custom.hansd));
			 $(".dangkysp_linkqrcode").val(custom.linkqrcode);
			// $(".dangkysp_linkqrcode_rutgon").val(custom.rutgonlink);
	 // aphanbon=JSON.parse(custom.listphan);
	  
	//showinforBVTV(aphanbon,"dangkysp_phanbon");
	//  abvtv=JSON.parse(custom.listthuoc);
	  
	//showinforBVTV(abvtv,"dangkysp_bvtv");
	urllinksetupimagedk=JSON.parse(custom.listhinh);
	updateImageLink(urllinksetupimagedk,"link_dangkysp_anhsp","imguserchange_anhdangky","removelinkdangky");
///
savebarcode=custom.idsp;
savemasp=custom.masp;
savengaysx=custom.ngaysx;
savehansd=custom.hansd;
savesoche=custom.thongtinsc;
//savepp=custom.thongtinpp;
dataluunpp=JSON.parse(custom.thongtinpp);
if(custom.thongtinsc==""||custom.thongtinsc==null||custom.thongtinsc==undefined||custom.thongtinsc==[]){
	
}
else
{
var temp=JSON.parse(custom.thongtinsc);
dataluunsc=temp.diadiem;
luuthongtinsc=temp.congnghe;
}
iduservinatt_save=custom.iduser;
});
function datasendsuadangky(){
var asanpham;
 var linkqrcode= $(".dangkysp_linkqrcode").val();
 var linkqrcode_rutgon= "";//$(".dangkysp_linkqrcode_rutgon").val();
 var mancc=   $(".dangkysp_mancc").val();
 var manpp= 0;//  $(".dangkysp_manpp").val();
 var mansc=0;//  $(".dangkysp_mansc").val();
 var manvc=0;//  $(".dangkysp_manvc").val();
  var biensoxe="";//  $(".dangkysp_biensoxe").val();
  var masp=  savemasp;
  var mausac={
	  vietGAP:"",//$(".dangkysp_mavietgap").val(),
	  mausac:$(".dangkysp_mausac").val(),
	  code:""//$(".dangkysp_code").val()
  }
  var lo=   $(".dangkysp_lo").val();
 
   var content=CKEDITOR.instances.editortccssanpham.getData();
   var contentlink=CKEDITOR.instances.editorexternallink.getData();
 
	var thongtin={
		congnghe:luuthongtinsc,
		diadiem:dataluunsc
		
	}
 
   var ngaysx=moment($(".dangky_ngaysx").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
  
  var hansd=moment($(".dangky_hansd").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
	
	var dataSend={
		
		
		idsp:savebarcode,
		masp:savemasp,
		mancc:mancc,
		mansc:mansc,
		manpp:manpp,
		manvc:manvc,
		biensoxe:biensoxe,
		mota:JSON.stringify(mausac),
		lo:lo,
		//listthuoc:JSON.stringify(abvtv),
		//listphan:JSON.stringify(aphanbon),
		ngaysx:ngaysx,
		hansd:hansd,
		listhinh:JSON.stringify(urllinksetupimagedk),
		thongtinsc:JSON.stringify(thongtin),
		thongtinpp:JSON.stringify(dataluunpp),
		tccs:content,
		externallink:contentlink,
		expire:expire,
		iduser:iduservinatt_save,
		linkqrcode:linkqrcode,
		rutgonlink:linkqrcode_rutgon
		
		
    }
  
	
  
   
    return dataSend;
}
$(".listdangkysp").on('click',".btn-removedangkysp",function () {
	
	if(p==0 || p==3)//admin, nong dan
	{
		
	
    var id=($(this).parents("tr").attr("data-idsp"));
    

    bootbox.confirm("Bạn có chắc xóa sản phẩm đăng ký có mã "+id+" này không?", function(result){
        if(result==true) {

            var dataSend = {
                idsp:id
            };
          
            $(".modalshowprogess").modal("show");
            $(".tientrinhxuly").html("Đang xóa dữ liệu");
            queryData("dangkysp/delete", dataSend, function (res) {

                if (res.code == 1000) {
                     builddsdangkysp(record,dksp_current,p,o);
                    $(".modalshowprogess").modal("hide");

                }else if(res.code==1002){
                    
                    $(".modalshowprogess").modal("hide");
                }
$(".modalshowprogess").modal("hide");
            });


        }else
        {
            // alert_info("Lỗi");
        }
    });
	}else
	{
		alert("Bạn không có đủ quyền xóa. (Chỉ có Admin hoặc Nhà cung cấp mới được xóa");
	
	}

});
$(".listdangkysp").on('click',".btn-lockdangkysp",function () {
	
	if(p==0)//admin, nong dan
	{
		
	
    var id=($(this).parents("tr").attr("data-idsp"));
     var ex=($(this).parents("tr").attr("data-expire"));
	var s="";
	 if(ex==0)
	 {
		 onex=1;
		 s="khóa"
	 }else{
		onex=0;
		s="Mở lại "
	 }

    bootbox.confirm("Bạn có "+s+" tính năng truy suất nguồn gốc sản phẩm đăng ký có mã "+id+" này không?", function(result){
        if(result==true) {

            var dataSend = {
                idsp:id,
				expire:onex
            };
          
            $(".modalshowprogess").modal("show");
            $(".tientrinhxuly").html("Đang xóa dữ liệu");
            queryData("dangkysp/updateexpire", dataSend, function (res) {

                if (res.code == 1000) {
                     builddsdangkysp(record,dksp_current,p,o);
                    $(".modalshowprogess").modal("hide");

                }else if(res.code==1002){
                    
                    $(".modalshowprogess").modal("hide");
                }
$(".modalshowprogess").modal("hide");
            });


        }else
        {
            // alert_info("Lỗi");
        }
    });
	}else
	{
		alert("Bạn không có đủ quyền xóa. (Chỉ có Admin hoặc Nhà cung cấp mới được xóa");
	
	}

});
$(".back_dangky").click(function () {
	swapMain("dangkysp");
});
var qrcode="";
$(".listdangkysp").on('click',".btn-work",function () {
	//swapMain("listworks");
	//getListWork("cb_listwork");
    var iduserfarmer=($(this).parents("tr").attr("data-iduser"));
	//qrcode=idsp;
	  window.location.href = "admin_show_works_farmer.html?iduser="+iduserfarmer;
	
});
var urlwordhinh=[];
var namework="";
var datework="";
function showworks(page,record,qrcode,idwork){
	 var dataSend={

        page:page,
        record:record,
        qrcode:qrcode,
		idwork:idwork
    }
 
    $(".link_work_image").html("<img src='img/loading.gif' width='20px' height='20px'/>");
 
    queryData("dangkysp/getdetailwork",dataSend,function (res) {
    //  console.log(res);
        if(res.code==1000){
			 var data = res.data.items;
			  var currentpage=parseInt(res.data.page);
				stt=printSTT(record,currentpage);
			 for (item in data) {
			  var list=data[item];	
				var listhinh=JSON.parse(list.listimg);
				//console.log(listhinh);
              urlwordhinh=listhinh;
			  namework=list.namebatch;
			  datework=list.createdate;
            updateImageLinkWork(qrcode,list.namebatch,list.createdate,listhinh,"link_work_image","imguserchange_anhwork","removelinkwork");
			
			 }
			  buildSlidePage($(".numberpageworks"),5,res.data.page,res.data.totalpage);
        }else{
            $(".link_work_image").html("Chưa cập nhật thông tin");
			newcreatework();//tao cong viec cho nguoi nong dan
        }
    });
}
function newcreatework(){
		var dataSend=datasendwork();
 
		
		
            queryData("dangkysp/creatework", dataSend, function (res) {
               
                if (res.code == 1000) {
					//alert_info("Lưu thành công");
					 showworks(page_num_work,record,qrcode,idwork);
				}else{
					//alert_error("Công việc này đã thực hiện rồi.");
					//showworks(page_num_work,record,qrcode,idwork);
				}
				
			})
}
var urllinksetupimagework=[];
function datasendwork(){

	var idw=  $(".cb_listwork").val();
	//var name_image=   $(".name_image").val();
 
	var dataSend={
		
		createdate:new Date().getTime(),
		idwork:idw,
		namebatch:"",
		
		listimg:JSON.stringify(urllinksetupimagework),
		qrcode:qrcode
		
	}
 
    return dataSend;
}

			
var page_num_work=0;
$(".numberpageworks").on('click','button',function () {
   page_num_work=$(this).val();
    showworks($(this).val(),record,qrcode,idwork);

});
var idwork=0;
$(".cb_listwork").click(function () {
	var idworks=parseInt($(".cb_listwork").val());
	idwork=idworks;
  showworks(0,record,qrcode,idwork);
    
});
$(".btn_back_dk").click(function () {
	swapMain("dangkysp");
});
