var resallnhasanxuat;
var vtnccs;
var mapncc;
var latncc;
var lngncc;
function init_map2(obj) {
   // console.log(obj);
	latncc=obj.lat;
	lngncc=obj.lng;
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
        map: mapncc,
    });


    mapncc = new google.maps.Map(document.getElementById("mapncc"),
        mapOptions);
    new google.maps.event.trigger(marker, 'click');

    marker.setMap(mapncc);


}

function builddssanxuat(page) {
    var charsearch=$(".search_nhacungcap").val();

    var dataSend={
        page:page,
        record:20,

        charsearch:charsearch

    }

    $(".listnhacungcap tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");

    queryData("nhacungcap/get",dataSend,function (res) {
       // console.log(res);
        if(res.code==1000){

            $(".listnhacungcap").html("");
            buildHTMLsanxuatData(res);
            if(flag==true){
               // console.log("a");
                buildmap(res);
            }

        }else{
            $(".listnhacungcap").html("Tìm không thấy");
        }
    });
}
function buildmap(res) {
    var data=res.data.items;
 //   console.log(data[vtnccs]);
    init_map2(data[vtnccs]);
}
function buildHTMLsanxuatData(res) {

    var data = res.data.items;

    resallnhasanxuat=data;
   // console.log(data);
    // init_map2(data);
    var currentpage=res.data.page;
    stt=printSTT(20,currentpage);
    var html='';

    var stt=1;
    for (item in data) {
        var list=data[item];


        html=html +
            '<tr data-mancc="' + list.mancc + '"data-name="'+list.tenncc+'  "data-vt="' + item + '">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
            '<td class="btn-show-info-cv">' + list.mancc + '</td>' +
            '<td class="btn-show-info-cv">' + list.tenncc + '</td>' +
            '<td class="btn-show-info-cv">' + list.mst + '</td>' +
            '<td class="btn-show-info-cv">' + list.diachi + '</td>' +

            '<td class="btn-show-info-bando"><a href="#">Bản đồ</a></td>' +
            '<td class="btn-show-info-cv">' + list.sdt + '</td>' +
            '<td class="btn-show-info-cv">' + list.email+'</td>'+
            '<td class="btn-show-info-cv">' + list.website+'</td>'+
            '<td class="btn-show-info-cv">' + list.sofax+'</td>'+
            '<td class="btn-show-info-cv">' + list.facebook+'</td>'+


            '<td class="btn-show-info-suancc"><a href="#">  <i class="fa fa-edit"></i></a></td>' +
            '<td class="btn-show-info-xoancc"><a href="#">  <i class="fa fa-remove"></i></a></td>' +


            '</tr>';
        stt++;
        $(".listnhacungcap").html(html)
    }
    buildSlidePage($(".numberpagenhacc"),5,res.data.page,res.data.totalpage);
}
var ncc_current=0;
$(".numberpagenhacc").on('click','button',function () {
    //console.log("nha"+$(this).val());
    ncc_current=$(this).val();
    builddssanxuat($(this).val());

});
function resetViewncc() {
    $(".ncc_username").val("");
    $(".ncc_password").val("");
    $(".ncc_mancc").val("");
    $(".ncc_tenncc").val("");
    $(".ncc_mst").val("");
    $(".ncc_addressncc").val("");
    $(".ncc_sdt").val("");
    $(".ncc_email").val("");
    $(".ncc_website").val("");
    $(".ncc_facebook").val("");
    $(".ncc_diadiem").val("");
	 $(".ncc_sofax").val("");
    $(".modalshowncc").attr("data-editting",false);

    $(".titlencc").html("<i class='fa fa-plus'></i>&nbsp; Tạo mới nhà cung cấp");
    $(".ncc_username").attr('disabled',false);
    $(".ncc_password").attr('disabled',false);
	lng=0;
	lat=0;
}
function datasendncc(){

    var u=   $(".ncc_username").val();
    var p=   $(".ncc_password").val();
    var ma=  $(".ncc_mancc").val();
    var ten=  $(".ncc_tenncc").val();
    var mst= $(".ncc_mst").val();
    var diachi= $(".ncc_addressncc").val();
    var sdt=$(".ncc_sdt").val();
    var email=  $(".ncc_email").val();
    var website=  $(".ncc_website").val();
    var facebook=  $(".ncc_facebook").val();
    var diadiem= $(".ncc_diadiem").val();
    var sofax= $(".ncc_sofax").val();

    var dataSend={


        username:u,
        password:p,
        permission:3,
        tenncc:ten,
        mst:mst,
        diachi:diachi,
        sdt:sdt,
        email:email,
        website:website,
        facebook:facebook,
        diadiem:diadiem,
        sofax:sofax,
        lat:lat,
        lng:lng,
        user:0,
		detailname:ten,
		phone:sdt,
			email:email



    }
    return dataSend;
}
function datasendnccsua(){


    var ma=  $(".ncc_mancc").val();
    var ten=  $(".ncc_tenncc").val();
    var mst= $(".ncc_mst").val();
    var diachi= $(".ncc_addressncc").val();
    var sdt=$(".ncc_sdt").val();
    var email=  $(".ncc_email").val();
    var website=  $(".ncc_website").val();
    var facebook=  $(".ncc_facebook").val();
    var diadiem= $(".ncc_diadiem").val();
    var sofax= $(".ncc_sofax").val();

    var dataSend={



        tenncc:ten,
        mst:mst,
        diachi:diachi,
        sdt:sdt,
        email:email,
        website:website,
        facebook:facebook,
        diadiem:diadiem,
        sofax:sofax,
        lat:lat,
        lng:lng,
		detailname:ten,
		phone:sdt,
			email:email




    }
    return dataSend;
}
$(".search_nhacungcap").keyup(function () {

    builddssanxuat(0);

});
$(".themnccrefesh").click(function () {

    builddssanxuat(0);

});
$(".btn-print-info-save-ncc").click(function () {
    var dataSend=datasendncc();
   // console.log(dataSend);
    if(dataSend.username==""){
        alert_info("Nhập tên đăng nhập");
        $(".ncc_username").focus();
    }else if(dataSend.password==""){
        alert_info("Nhập mật khẩu");
        $(".ncc_username").focus();
    }else if(dataSend.tenncc==""){
        alert_info("Nhập tên nhà cung cấp");
        $(".ncc_tenncc").focus();
    }
    else
    {
        if ($(".modalshowncc").attr("data-editting") == "false") {
            $(".modalshowprogess").modal("show");
            $(".tientrinhxuly").html("Đang thêm dữ liệu");
            queryData("nhacungcap/create", dataSend, function (res) {
               // console.log(res);
                if (res.code == 1000) {
                    $(".modalshowprogess").modal("hide");
                    $(".modalshowncc").modal("hide");
                    builddssanxuat(ncc_current);
                    resetViewncc();
                    //getsanphamData();
                } else if (res.code == 1002) {

                    alert_error("Đã trùng nhà cung cấp");

                    $(".modalshowprogess").modal("hide");
                    resetViewncc();
                } else {
                    $(".modalshowprogess").modal("hide");
                    alert_error("Thêm thất bại");
                }
            });
        } else {

            $(".modalshowprogess").modal("show");
            $(".tientrinhxuly").html("Đang cập nhật dữ liệu");
            dataSend=datasendnccsua();
            dataSend.mancc=mancc;
            dataSend.user=userncc;
          //  console.log(dataSend);
            queryData("nhacungcap/updatenhacungcap", dataSend, function (res) {
             //   console.log(res);
                if (res.code == 1000) {

                    builddssanxuat(ncc_current);
                    resetViewncc();
                    $(".modalshowncc").modal("hide");

                } else {
                    alert_error("Cập nhật thất bại");
                }
                $(".modalshowprogess").modal("hide");
            });

        }
    }
});

var mancc;
var userncc;
$(".listnhacungcap").on('click',".btn-show-info-suancc",function () {

    $(".titlencc").html("<i class='fa fa-edit'></i>&nbsp; Sửa nhà cung cấp");
    $(".modalshowncc").attr("data-editting",true);



    $(".modalshowncc").modal("show");
    mancc=($(this).parents("tr").attr("data-mancc"));
    var tenncc=($(this).parents("tr").attr("data-tenncc"));
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resallnhasanxuat[vt];
    userncc=custom.user;
    $(".ncc_username").val(custom.username);
    $(".ncc_password").val(custom.password);
    $(".ncc_tenncc").val(custom.tenncc);
    $(".ncc_mst").val(custom.mst);
    $(".ncc_addressncc").val(custom.diachi);
    $(".ncc_sdt").val(custom.sdt);
    $(".ncc_email").val(custom.email);

    $(".ncc_website").val(custom.website);
    $(".ncc_sofax").val(custom.sofax);

    $(".ncc_facebook").val(custom.facebook);

    $(".ncc_diadiem").val(custom.diadiem);
    $(".ncc_username").attr('disabled','disabled');
    $(".ncc_password").attr('disabled','disabled');
	latncc=custom.lat;
	lngncc=custom.lng;

});
$(".listnhacungcap").on('click',".btn-show-info-xoancc",function () {
    var id=($(this).parents("tr").attr("data-mancc"));
    var tenncc=($(this).parents("tr").attr("data-tenncc"));
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resallnhasanxuat[vt];
    var vt=($(this).parents("tr").attr("data-vt"));

    bootbox.confirm("Bạn có chắc xóa sản phẩm "+id+" này không?", function(result){
        if(result==true) {

            var dataSend = {
                mancc:id,
                user:custom.user
            };
           // console.log(dataSend);
            $(".modalshowprogess").modal("show");
            $(".tientrinhxuly").html("Đang xóa dữ liệu");
            queryData("nhacungcap/deletenhacungcap", dataSend, function (res) {

                if (res.code == 1000) {
                    builddssanxuat(ncc_current);
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
//click ban do
var flag=false
$(".listnhacungcap").on("click",".btn-show-info-bando",function () {
    $(".modalshowmapncc").modal("show");
    var vtncc=($(this).parents("tr").attr("data-vt"));
    vtnccs=vtncc;
    flag=true;
    builddssanxuat(0);

});
$(".modalshowncc").on("click",".btnchucvu_addressncc",function () {
    $(".ncc_addressncc").val('');
    $("#complete").val('');

    $(".modalshowmappicker").modal("show");
    // initAutocomplete()
    initMap();
});
$(".modalshowmappicker").on("click",".btn-print-info-save-nhapkhospss",function () {
    $(".ncc_addressncc").val(address);
    $(".modalshowmappicker").modal("hide");
})