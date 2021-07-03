var resallnhavc;
var vtnhavc;
var mapnvc;
var latnvc;
var lngnvc;
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

function builddsnhavc(page,record) {
    var charsearch=$(".search_nhavc").val();

    var dataSend={
        page:page,
        record:record,

        charsearch:charsearch

    }

    $(".listnhavc").html("<img src='img/loading.gif' width='20px' height='20px'/>");

    queryData("nhavc/get",dataSend,function (res) {
       // console.log(res);
        if(res.code==1000){

            $(".listnhavc").html("");
            buildHTMLnhaVCData(res);
            if(flag==true){
               // console.log("a");
              //  buildmap(res);
            }

        }else{
            $(".listnhavc").html("Tìm không thấy");
			$(".numberpagenhavc").html("");
        }
    });
}
function buildmap(res) {
    var data=res.data.items;
 //   console.log(data[vtnccs]);
    init_map2(data[vtnccs]);
}
function buildHTMLnhaVCData(res) {

    var data = res.data.items;

    resallnhavc=data;
   // console.log(data);
    // init_map2(data);
	var stt=1;
    var currentpage=parseInt(res.data.page);
    stt=printSTT(record,currentpage);
    var html='';

    
    for (item in data) {
        var list=data[item];


        html=html +
            '<tr data-manvc="' + list.manvc + '"data-name="'+list.tennvc+'  "data-vt="' + item + '">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
			  '<td class="btn-show-info-cv">' + list.username + '</td>' +
            '<td class="btn-show-info-cv">' + list.manvc + '</td>' +
            '<td class="btn-show-info-cv">' + list.tennvc + '</td>' +
            '<td class="btn-show-info-cv">' + list.mst + '</td>' +
            '<td class="btn-show-info-cv">' + list.diachi + '</td>' +

     
            '<td class="btn-show-info-cv">' + list.sdt + '</td>' +
            '<td class="btn-show-info-cv">' + list.email+'</td>'+
            '<td class="btn-show-info-cv">' + list.website+'</td>'+
            '<td class="btn-show-info-cv">' + list.sofax+'</td>'+
            '<td class="btn-show-info-cv">' + list.facebook+'</td>'+


            '<td class="btn-show-info-suanvc"><a href="#">  <i class="fa fa-edit"></i></a></td>' +
            '<td class="btn-show-info-xoanvc"><a href="#">  <i class="fa fa-remove"></i></a></td>' +


            '</tr>';
        stt++;
        $(".listnhavc").html(html)
    }
    buildSlidePage($(".numberpagenhavc"),5,res.data.page,res.data.totalpage);
}
var nvc_current=0;
$(".numberpagenhavc").on('click','button',function () {
    //console.log("nha"+$(this).val());
    nvc_current=$(this).val();
    builddsnhavc($(this).val(),record);

});
function resetViewnvc() {
    $(".nvc_username").val("");
    $(".nvc_password").val("");
    $(".nvc_manvc").val("");
    $(".nvc_tennvc").val("");
    $(".nvc_mst").val("");
    $(".nvc_addressnvc").val("");
    $(".nvc_sdt").val("");
    $(".nvc_email").val("");
    $(".nvc_website").val("");
    $(".nvc_facebook").val("");
   $(".nvc_lat").val("0");
		 $(".nvc_lng").val("0");
	 $(".nvc_sofax").val("");
    $(".modalshownvc").attr("data-editting",false);

    $(".titlencc").html("<i class='fa fa-plus'></i>&nbsp; Tạo mới Nhà Vận Chuyển");
    $(".nvc_username").attr('disabled',false);
    $(".nvc_password").attr('disabled',false);
	lng=0;
	lat=0;
}
function datasendnvc(){

    var u=   $(".nvc_username").val();
    var p=   $(".nvc_password").val();
    var ma=  $(".nvc_manvc").val();
    var ten=  $(".nvc_tennvc").val();
    var mst= $(".nvc_mst").val();
    var diachi= $(".nvc_addressnvc").val();
    var sdt=$(".nvc_sdt").val();
    var email=  $(".nvc_email").val();
    var website=  $(".nvc_website").val();
    var facebook=  $(".nvc_facebook").val();
   
    var sofax= $(".nvc_sofax").val();
	var latnew= $(".nvc_lat").val();
    var lngnew= $(".nvc_lng").val();
    var dataSend={
        username:u,
        password:p,
        permission:5,
        tennvc:ten,
        mst:mst,
        diachi:diachi,
        sdt:sdt,
        email:email,
        website:website,
        facebook:facebook,
       
        sofax:sofax,
        lat:parseFloat(latnew),
        lng:parseFloat(lngnew),
        user:0,
		detailname:ten,
		phone:sdt,
		email:email



    }
    return dataSend;
}
function datasendnvcsua(){


    var ma=  $(".nvc_manvc").val();
    var ten=  $(".nvc_tennvc").val();
    var mst= $(".nvc_mst").val();
    var diachi= $(".nvc_addressnvc").val();
    var sdt=$(".nvc_sdt").val();
    var email=  $(".nvc_email").val();
    var website=  $(".nvc_website").val();
    var facebook=  $(".nvc_facebook").val();
    var latnew= $(".nvc_lat").val();
    var lngnew= $(".nvc_lng").val();
    var sofax= $(".nvc_sofax").val();

    var dataSend={


        tennvc:ten,
        mst:mst,
        diachi:diachi,
        sdt:sdt,
        email:email,
        website:website,
        facebook:facebook,
       
        sofax:sofax,
        lat:latnew,
        lng:lngnew,
		detailname:ten,
		phone:sdt,
			email:email




    }
    return dataSend;
}
$(".search_nhavc").keyup(function () {

    builddsnhavc(0,record);

});
$(".themnvcrefesh").click(function () {

    builddsnhavc(0,record);

});
$(".btn-print-info-save-nvc").click(function () {
    var dataSend=datasendnvc();
    //console.log(dataSend);
    if(dataSend.username==""){
        alert_info("Nhập tên đăng nhập");
        $(".nvc_username").focus();
    }else if(dataSend.password==""){
        alert_info("Nhập mật khẩu");
        $(".nvc_username").focus();
    }else if(dataSend.tennvc==""){
        alert_info("Nhập tên nhà vận chuyển");
        $(".nvc_tennvc").focus();
    }
    else
    {
        if ($(".modalshownvc").attr("data-editting") == "false") {
            $(".modalshowprogess").modal("show");
            $(".tientrinhxuly").html("Đang thêm dữ liệu");
            queryData("nhavc/create", dataSend, function (res) {
            //   console.log(res);
                if (res.code == 1000) {
					alert_info("Thêm thành công");
                    $(".modalshowprogess").modal("hide");
                    $(".modalshowncc").modal("hide");
                    builddsnhavc(nvc_current,record);
                    resetViewnvc();
                    //getsanphamData();
                }else if(res.code==1001){
					alert_info("Thêm thất bại");
                    $(".modalshowprogess").modal("hide");
				}
				else if (res.code == 1002) {

                    alert_error("Đã trùng nhà vận chuyển");

                    $(".modalshowprogess").modal("hide");
                    resetViewnvc();
                } else {
                    $(".modalshowprogess").modal("hide");
                    alert_error("Lỗi kết nối server");
                }
            });
        } else {

            $(".modalshowprogess").modal("show");
            $(".tientrinhxuly").html("Đang cập nhật dữ liệu");
            dataSend=datasendnvcsua();
            dataSend.manvc=manvc;
            dataSend.user=usernvc;
          //  console.log(dataSend);
            queryData("nhavc/updatenhavc", dataSend, function (res) {
             //   console.log(res);
                if (res.code == 1000) {

                     builddsnhavc(nvc_current,record);
                    resetViewnvc();
                    $(".modalshownvc").modal("hide");

                } else {
                    alert_error("Cập nhật thất bại");
                }
                $(".modalshowprogess").modal("hide");
            });

        }
    }
});

var manvc;
var usernvc;
$(".listnhavc").on('click',".btn-show-info-suanvc",function () {

    $(".titlenvc").html("<i class='fa fa-edit'></i>&nbsp; Sửa nhà vận chuyển");
    $(".modalshownvc").attr("data-editting",true);



    $(".modalshownvc").modal("show");
    manvc=($(this).parents("tr").attr("data-manvc"));
    var tennvc=($(this).parents("tr").attr("data-tennvc"));
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resallnhavc[vt];
    usernvc=custom.user;
    $(".nvc_username").val(custom.username);
    $(".nvc_password").val(custom.password);
    $(".nvc_tennvc").val(custom.tennvc);
    $(".nvc_mst").val(custom.mst);
    $(".nvc_addressnvc").val(custom.diachi);
    $(".nvc_sdt").val(custom.sdt);
    $(".nvc_email").val(custom.email);

    $(".nvc_website").val(custom.website);
    $(".nvc_sofax").val(custom.sofax);

    $(".nvc_facebook").val(custom.facebook);
 $(".nvc_lat").val(custom.lat);
  $(".nvc_lng").val(custom.lng);
   
    $(".nvc_username").attr('disabled','disabled');
    $(".nvc_password").attr('disabled','disabled');
	latncc=custom.lat;
	lngncc=custom.lng;

});
$(".listnhavc").on('click',".btn-show-info-xoanvc",function () {
    var id=($(this).parents("tr").attr("data-manvc"));
    var tennvc=($(this).parents("tr").attr("data-tennvc"));
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resallnhavc[vt];
    var vt=($(this).parents("tr").attr("data-vt"));

    bootbox.confirm("Bạn có chắc xóa nhà vận chuyển"+id+" này không?", function(result){
        if(result==true) {

            var dataSend = {
                manvc:id,
                user:custom.user
            };
           // console.log(dataSend);
            $(".modalshowprogess").modal("show");
            $(".tientrinhxuly").html("Đang xóa dữ liệu");
            queryData("nhavc/deletenhavc", dataSend, function (res) {

                if (res.code == 1000) {
					alert_info("Xóa thành công");
                    builddsnhavc(nvc_current,record);
                    $(".modalshowprogess").modal("hide");

                }else if(res.code==1001){
					alert_info("Xóa thất bại");
                    $(".modalshowprogess").modal("hide");
				}else if(res.code==1002){
                    alert_info("Nhà vận này không thể xóa. Do đã đang sử dụng");
                    $(".modalshowprogess").modal("hide");
                }

            });


        }else
        {
            // alert_info("Lỗi");
        }
    });

});
