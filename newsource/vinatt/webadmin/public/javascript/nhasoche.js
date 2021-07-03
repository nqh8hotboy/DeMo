
var resallgroup=[];
var mapnsc;
var address;
var latlng;
var lat;
var lng;
var marker2;
var autocomplete;
var arraychinhanh=[];
var map2;
var marker ;
var marker2 ;
var searchBox;
function fillInAddress() {
    // Get the place details from the autocomplete object.
    var place = autocomplete.getPlace();
    var vt=(JSON.parse(JSON.stringify(place.geometry.location)));
    latlng=vt ;
    console.log(place)
    address=place.formatted_address;
    console.log(vt);
    if (vt != null ) {
        // latlng = new google.maps.LatLng(vt.lat, vt.lng);
        //
        // marker.setPosition(latlng);
        // map2.panTo(latlng)
        var myLocation = new google.maps.LatLng(vt.lat, vt.lng);
        var mapOptions = {
            center: myLocation,
            zoom: 14
        };
        console.log("a")
        var marker = new google.maps.Marker({
            position: myLocation,
            title: "Property Location",
            map: map2,
        });


        map2 = new google.maps.Map(document.getElementById("map2"),
            mapOptions);
        new google.maps.event.trigger(marker, 'click');

        marker.setMap(map2);
    }
            lat=latlng.lat;
           lng=latlng.lng;
}
var map2;
var marker ;
var marker2 ;

function initMap() {
    // initAutocomplete()

    var myLocation = new google.maps.LatLng(lat, lng);
    var mapOptions = {
        center: myLocation,
        zoom: 14
    };
    map2 = new google.maps.Map(document.getElementById("map2"),
        mapOptions);
    if(marker2==null) {
        marker2 = new google.maps.Marker({
            position: myLocation,
            draggable: true,
            title: "Property Location",
            map: map2,
        });
    }
    else
    {
        marker2.setPosition(myLocation);
    }

    new google.maps.event.trigger( marker2, 'click' );
    google.maps.event.addListener(marker2, 'dragend', function()
    {
        geocodePosition(marker2.getPosition());
    });
    marker2.setMap(map2);

    var input = document.getElementById('complete');

    autocomplete = new google.maps.places.Autocomplete(input);
    autocomplete.addListener('place_changed', fillInAddress);

}

// function initAutocomplete() {
//    map = new google.maps.Map(document.getElementById('map'), {
//         center: {lat: -33.8688, lng: 151.2195},
//         zoom: 13,
//         mapTypeId: 'roadmap'
//     });
// console.log("a")
//     // Create the search box and link it to the UI element.
//      input = document.getElementById('pac-input');
//
//     searchBox = new google.maps.places.SearchBox(input);
//     map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
//
//     // Bias the SearchBox results towards current map's viewport.
//     map.addListener('bounds_changed', function() {
//         searchBox.setBounds(map.getBounds());
//     });
//
//
//     // Listen for the event fired when the user selects a prediction and retrieve
//     // more details for that place.
//     searchBox.addListener('places_changed', function() {
//         var places = searchBox.getPlaces();
//
//         if (places.length == 0) {
//             return;
//         }
//
//         // Clear out the old markers.
//         markers.forEach(function(marker) {
//             marker.setMap(null);
//         });
//         markers = [];
//
//         // For each place, get the icon, name and location.
//         var bounds = new google.maps.LatLngBounds();
//         places.forEach(function(place) {
//             if (!place.geometry) {
//                 console.log("Returned place contains no geometry");
//                 return;
//             }
//             var icon = {
//                 url: place.icon,
//                 size: new google.maps.Size(71, 71),
//                 origin: new google.maps.Point(0, 0),
//                 anchor: new google.maps.Point(17, 34),
//                 scaledSize: new google.maps.Size(25, 25)
//             };
//
//             // Create a marker for each place.
//             markers.push(new google.maps.Marker({
//                 map: map,
//                 icon: icon,
//                 title: place.name,
//                 position: place.geometry.location
//             }));
//
//             if (place.geometry.viewport) {
//                 // Only geocodes have viewport.
//                 bounds.union(place.geometry.viewport);
//             } else {
//                 bounds.extend(place.geometry.location);
//             }
//         });
//         map.fitBounds(bounds);
//     });
// }


function init_map1(obj) {
    lat=obj.lat;
    lng=obj.lng;
    var myLocation = new google.maps.LatLng(obj.lat, obj.lng);
    var mapOptions = {
        center: myLocation,
        zoom: 14
    };
    console.log("a")
    var marker = new google.maps.Marker({
        position: myLocation,
        title: "Property Location",
        map: mapnsc,
    });


    mapnsc = new google.maps.Map(document.getElementById("mapnsc"),
        mapOptions);
    new google.maps.event.trigger(marker, 'click');

    marker.setMap(mapnsc);


}
////////////////thong tin hien thi 
var resallnhasc;
var vtnscs;
function builddsnhasc(page,record) {
    var charsearch=$(".search_nhasoche").val();

    var dataSend={
        page:page,
        record:record,

        charsearch:charsearch

    }

    $(".listnhasoche").html("<img src='img/loading.gif' width='20px' height='20px'/>");

    queryData("nhasoche/get",dataSend,function (res) {

        if(res.code==1000){

            $(".listnhasoche").html("");
            buildHTMLsocheData(res);
            if(flag==true){
                console.log("true");
                buildmapnsc(res);
            }
        }else{
            $(".listnhasoche").html("Tìm không thấy");
			$(".numberpagenhasoche").html("");
        }
    });
}
function buildmapnsc(res) {
    var data=res.data.items;
    console.log(data[vtnscs]);
    init_map1(data[vtnscs]);
}
function buildHTMLsocheData(res,record) {

    var data = res.data.items;
var stt=1;
    resallnhasc=data;
    var currentpage=parseInt(res.data.page);
    stt=printSTT(record,currentpage);
    var html='';

    
    for (item in data) {
        var list=data[item];


        html=html +
            '<tr data-mansc="' + list.mansc + '"data-name="'+list.tennsc+'  "data-vt="' + item + '">' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
			 '<td class="btn-show-info-cv">' + list.username + '</td>' +
            '<td class="btn-show-info-cv">' + list.mansc + '</td>' +
            '<td class="btn-show-info-cv">' + list.tennsc + '</td>' +
            '<td class="btn-show-info-cv">' + list.mst + '</td>' +
            '<td class="btn-show-info-cv">' + list.diachi + '</td>' +

          
            '<td class="btn-show-info-cv">' + list.sdt + '</td>' +
            '<td class="btn-show-info-cv">' + list.email+'</td>'+
            '<td class="btn-show-info-cv">' + list.website+'</td>'+
            '<td class="btn-show-info-cv">' + list.sofax+'</td>'+
            '<td class="btn-show-info-cv">' + list.facebook+'</td>'+
           
 '<td class="btn-show-info-cv">'+list.tccs+'</td>'+
           
            '<td class="btn-show-info-suancc"><a href="#">  <i class="fa fa-edit"></i></a></td>' +
            '<td class="btn-show-info-xoancc"><a href="#">  <i class="fa fa-remove"></i></a></td>' +


            '</tr>';
        stt++;
        $(".listnhasoche").html(html)
    }
    buildSlidePage($(".numberpagenhasoche"),5,res.data.page,res.data.totalpage);
}
var nsc_current=0;
$(".numberpagenhasoche").on('click','button',function () {
    //console.log("nha"+$(this).val());
    nsc_current=$(this).val();
    builddsnhasc($(this).val(),record);

});
$(".nhasc_themthongtinsc").click(function () {
    
    $(".modalshowcongnghe").modal("show");
	
	
});
$(".nhasc_themdiadiemsc").click(function () {
    
    $(".modalshowdiadiemsoche").modal("show");
	
	
});
var acongnghesoche=[];
$(".btn-print-info-save-congnghe_soche").click(function () {

 
 var ten=$(".nsc_congnghe_ten").val();
    
	
	acongnghesoche.push(ten);
	showinforCongNghe(acongnghesoche,"nhasc_thongtinsoche");
	$(".nsc_congnghe_ten").val("");
 
});
function showinforCongNghe(abvtv,tenbien){
	var  htmlnd='';
	var stt=1;
    for(i=0;i<abvtv.length;i++){

        htmlnd=htmlnd +
            '<tr data-id="" data-name="  " data-vt="'+i+'">' +
'<td class="btn-show-info-cv">' + stt + '</td>' +
          
            '<td class="btn-show-info-cv">' + abvtv[i] + '</td>' +
 '<td class="btn-show-info-remove"><i class="fa fa-remove"></i></td>' +



            '</tr>';
      
stt++;

    }
    $("."+tenbien).html(htmlnd);
}
$(".nhasc_diadiemsoche").on('click','.btn-show-info-remove',function () {
	
	var vt=parseInt($(this).attr("data-vt"));
	adiadiemsoche.splice(vt,1);
	
	showinforDiadiem(adiadiemsoche,"nhasc_diadiemsoche");
	
	
});
//remove chon
$(".nhasc_thongtinsoche").on('click','.btn-show-info-remove',function () {
	
	var vt=parseInt($(this).attr("data-vt"));
	acongnghesoche.splice(vt,1);
	
	showinforCongNghe(acongnghesoche,"nhasc_thongtinsoche");
	
	
});
var adiadiemsoche=[];
var ib=1;
$(".btn-print-info-save-diadiem_soche").click(function () {

 
 var ten=$(".nsc_diadiem_ten").val();
    var dc=$(".nsc_diadiem_dc").val();
	var dt=$(".nsc_diadiem_sdt").val();
	var email=$(".nsc_diadiem_email").val();
	var data={
		id:ib,
		tencs:ten,
		diachi:dc,
		sdt:dt,
		email:email,
		lat:0,
		lng:0
	}
	adiadiemsoche.push(data);
	ib++;
	showinforDiadiem(adiadiemsoche,"nhasc_diadiemsoche");
	$(".nsc_diadiem_ten").val("");
   $(".nsc_diadiem_dc").val("");
	$(".nsc_diadiem_sdt").val("");
	$(".nsc_diadiem_email").val("");
 
});
function showinforDiadiem(abvtv,tenbien){
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
 '<td class="btn-show-info-remove"><i class="fa fa-remove"></i></td>' +



            '</tr>';
      
stt++;

    }
    $("."+tenbien).html(htmlnd);
}
//remove chon
$(".nhasc_diadiemsc").on('click','.btn-show-info-remove',function () {
	
	var vt=parseInt($(this).attr("data-vt"));
	adiadiemsoche.splice(vt,1);
	
	showinforDiadiem(adiadiemsoche,"nhasc_diadiemsc");
	
	
});
function resetViewnsc() {
    $(".nsc_username").val("");
    $(".nsc_password").val("");
    $(".nsc_mansc").val("");
    $(".nsc_name").val("");
    $(".nsc_mst").val("");
    $(".nsc_addressnsc").val("");
    $(".nsc_sdt").val("");
    $(".nsc_email").val("");
    $(".nsc_website").val("");
    $(".nsc_facebook").val("");
    $(".nsc_diadiem").val("");
	$(".nsc_lat").val("0");
		 $(".nsc_lng").val("0");
    $(".modalshownsc").attr("data-editting",false);
adiadiemsoche=[];
acongnghesoche=[];
    $(".titlensc").html("<i class='fa fa-plus'></i>&nbsp; Tạo mới nhà sơ chế");
    $(".nsc_username").attr('disabled',false);
    $(".nsc_password").attr('disabled',false);
	   CKEDITOR.instances.editortccssoche.setData("");
	 $(".nhasc_thongtinsoche").html("");
	  $(".nhasc_diadiemsoche").html("");
}
function datasendnsc(){

    var u=   $(".nsc_username").val();
    var p=   $(".nsc_password").val();
    var ma=  $(".nsc_mansc").val();
    var ten=  $(".nsc_name").val();
    var mst= $(".nsc_mst").val();
    var diachi= $(".nsc_addressnsc").val();
    var sdt=$(".nsc_sdt").val();
    var email=  $(".nsc_email").val();
    var website=  $(".nsc_website").val();
    var facebook=  $(".nsc_facebook").val();
 var latnew= $(".nsc_lat").val();
 var lngnew=		 $(".nsc_lng").val();
    var sofax= $(".nsc_sofax").val();
	var content=CKEDITOR.instances.editortccssoche.getData();
    var dataSend={


        username:u,
        password:p,
        permission:2,
        tennsc:ten,
        mst:mst,
        diachi:diachi,
        sdt:sdt,
        email:email,
        website:website,
        facebook:facebook,
        
        sofax:sofax,
        lat:latnew,
        lng:lngnew,
        user:0,
		thongtincssc:JSON.stringify(acongnghesoche),
		diadiem:JSON.stringify(adiadiemsoche),
		tccs:content,
		detailname:ten,
		phone:sdt,
			email:email



    }
    return dataSend;
}
function datasendnscsua(){


   
    var ten=  $(".nsc_name").val();
    var mst= $(".nsc_mst").val();
    var diachi= $(".nsc_addressnsc").val();
    var sdt=$(".nsc_sdt").val();
    var email=  $(".nsc_email").val();
    var website=  $(".nsc_website").val();
    var facebook=  $(".nsc_facebook").val();
    var latnew= $(".nsc_lat").val();
 var lngnew=		 $(".nsc_lng").val();
    var sofax= $(".nsc_sofax").val();
     var content=CKEDITOR.instances.editortccssoche.getData();
    var dataSend={


		mansc:mansc,
		user:usernsc,
        tennsc:ten,
        mst:mst,
        diachi:diachi,
        sdt:sdt,
        email:email,
        website:website,
        facebook:facebook,
       
        sofax:sofax,
        lat:latnew,
        lng:lngnew,
thongtincssc:JSON.stringify(acongnghesoche),
		diadiem:JSON.stringify(adiadiemsoche),
	tccs:content,
detailname:ten,
		phone:sdt,
			email:email

    }
    return dataSend;
}
$(".search_nhasoche").keyup(function () {

    builddsnhasc(0,record);

});
$(".themnscrefesh").click(function () {

    builddsnhasc(0,record);

});
$(".btn-print-info-save-nsc").click(function () {
    var dataSend=datasendnsc();
    console.log(dataSend);
    if(dataSend.username==""){
        alert_info("Nhập tên đăng nhập");
        $(".nsc_username").focus();
    }else if(dataSend.password==""){
        alert_info("Nhập mật khẩu");
        $(".nsc_username").focus();
    }else if(dataSend.tennsc==""){
        alert_info("Nhập tên nhà sơ chế hoặc chế biến");
        $(".nsc_name").focus();
    }
    else
    {
        if ($(".modalshownsc").attr("data-editting") == "false") {
            $(".modalshowprogess").modal("show");
            $(".tientrinhxuly").html("Đang thêm dữ liệu");
            queryData("nhasoche/create", dataSend, function (res) {
                console.log(res);
                if (res.code == 1000) {
                    $(".modalshowprogess").modal("hide");
                    $(".modalshownsc").modal("hide");
                    builddsnhasc(nsc_current,record);
                    resetViewnsc();
                    //getsanphamData();
                } else if (res.code == 1002) {

                    alert_error("Tên đăng nhập này đã tồn tại rồi");

                    $(".modalshowprogess").modal("hide");
                    //resetViewnsc();
                } else {
                    $(".modalshowprogess").modal("hide");
                    alert_error("Thêm thất bại");
                }
            });
        } else {

            $(".modalshowprogess").modal("show");
            $(".tientrinhxuly").html("Đang cập nhật dữ liệu");
        var     dataSend1=datasendnscsua();
            
            console.log(dataSend1);
            queryData("nhasoche/updatenhasoche", dataSend1, function (res) {
                console.log(res);
                if (res.code == 1000) {

                    builddsnhasc(nsc_current);
                    resetViewnsc();
                    $(".modalshownsc").modal("hide");

                } else {
                    alert_error("Cập nhật thất bại");
                }
                $(".modalshowprogess").modal("hide");
            });

        }
    }
});

var mansc;
var usernsc;
var nhasc_thongtinsoche=[];
$(".listnhasoche").on('click',".btn-show-info-suancc",function () {

    $(".titlensc").html("<i class='fa fa-edit'></i>&nbsp; Sửa nhà sơ chế/chế biến");
    $(".modalshownsc").attr("data-editting",true);



    $(".modalshownsc").modal("show");
    mansc=($(this).parents("tr").attr("data-mansc"));
    var tennsc=($(this).parents("tr").attr("data-tennsc"));
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resallnhasc[vt];
	console.log(custom);
    usernsc=custom.user;
    $(".nsc_username").val(custom.username);
    $(".nsc_password").val(custom.password);
    $(".nsc_name").val(custom.tennsc);
    $(".nsc_mst").val(custom.mst);
    $(".nsc_addressnsc").val(custom.diachi);
    $(".nsc_sdt").val(custom.sdt);
    $(".nsc_email").val(custom.email);

    $(".nsc_website").val(custom.website);
    $(".nsc_sofax").val(custom.sofax);

    $(".nsc_facebook").val(custom.facebook);

    //$(".nsc_diadiem").val(custom.diadiem);
    $(".nsc_username").attr('disabled','disabled');
    $(".nsc_password").attr('disabled','disabled');
	lng=custom.lng;
	lat=custom.lat;
	 $(".nsc_lat").val(custom.lat);

    $(".nsc_lng").val(custom.lng);

	acongnghesoche=JSON.parse(custom.thongtincssc);
	showinforCongNghe(acongnghesoche,"nhasc_thongtinsoche");
	
	adiadiemsoche=JSON.parse(custom.diadiem);
	showinforDiadiem(adiadiemsoche,"nhasc_diadiemsoche");
	CKEDITOR.instances.editortccssoche.setData(custom.tccs);
});
$(".listnhasoche").on('click',".btn-show-info-xoancc",function () {
    var id=($(this).parents("tr").attr("data-mansc"));
    var tennsc=($(this).parents("tr").attr("data-tennsc"));
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    var custom=resallnhasc[vt];
    var vt=($(this).parents("tr").attr("data-vt"));

    bootbox.confirm("Bạn có chắc xóa nhà sơ chế "+id+" này không?", function(result){
        if(result==true) {

            var dataSend = {
                mansc:id,
                user:custom.user
            };
            console.log(dataSend);
            $(".modalshowprogess").modal("show");
            $(".tientrinhxuly").html("Đang xóa dữ liệu");
            queryData("nhasoche/deletenhasoche", dataSend, function (res) {

                if (res.code == 1000) {
					alert_info("Xóa thành công");
                    builddsnhasc(nsc_current,record);
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
$(".listnhasoche").on("click",".btn-show-info-bando",function () {
    flag=true;
    $(".modalshowmapnsc").modal("show");
    var vtnsc=$(this).parents("tr").attr("data-vt");
    vtnscs=vtnsc;
    console.log(vtnscs);
    builddsnhasc(0,record)
});
$(".modalshownsc").on("click",".btnchucvu_addressnsc",function () {
    $(".nsc_addressnsc").val('');
    $("#complete").val('')
    $(".modalshowmappicker").modal("show");
    // initAutocomplete()
    initMap();
});
$(".modalshowmappicker").on("click",".btn-print-info-save-nhapkhospss",function () {

    $(".nsc_addressnsc").val(address);
    $(".modalshowmappicker").modal("hide");
});
var custom;
var infocs;
$(".listnhasoche").on('click',".btn-show-info-diadiem",function () {

    $(".titleinfo").html("<i class='fa fa-info-circle'></i>&nbsp; Thông tin nhà sơ chế/ chế biến chi nhánh");
    var mansc=($(this).parents("tr").attr("data-mansc"));
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    custom=resallnhasc[vt];
    // console.log(custom);
    // console.log(JSON.parse(custom.diadiem));
    var stt=1;
    var listp=JSON.parse(custom.diadiem);
    if(isEmpty(listp)){
        alert("Không có chi nhánh");
        return;
    }
    else {
        $(".modalshowinforcommon").modal("show");
        var html = '<h4></h4>' +
            ' <div class="portlet-content table-responsive nhasoche">' +
            '<table class="table table-striped table-bordered table-checkable"><thead><tr>' +

            "<th>STT</th>" +
            "<th>Mã nhà sơ chế/chế biến</th>" +
            "<th>Tên nhà sơ chế/chế biến</th>" +
            "<th>Địa chỉ</th>" +
            "<th>Số điện thoại</th>" +
            "<th>Email</th>" +
        

            "</tr>" +
            "</thead>" +

            '<tbody class="listnsc">';


        html = html + "</tbody></table></div>";
        $(".showinfocommon").html(html);
        var htmlnd = '';
        var listthongtincs;
        for (var j in listp) {

            var listthongtincs=listp[j];
            console.log(listthongtincs);
            htmlnd = htmlnd +
                '<tr data-id="" data-name="  " data-vt="">' +

                '<td class="btn-show-info-cv">' + stt + '</td>' +
                '<td class="btn-show-info-cv">' + listthongtincs.id + '</td>' +
                '<td class="btn-show-info-cv">' + listthongtincs.tencs + '</td>' +
                '<td class="btn-show-info-cv">' + listthongtincs.diachi + '</td>' +
                '<td class="btn-show-info-cv">' + listthongtincs.sdt + '</td>' +
                '<td class="btn-show-info-cv">' + listthongtincs.email + '</td>' +
               
                '</tr>';
            $(".listnsc").html(htmlnd);
            stt++;
        }

    }
});
$(".modalshowinforcommon").on("click",".btn-show-info-xemmapchinhanh",function () {
    $(".modalshowinforcommon").modal("hide");
    $(".modalshowmapnsc").modal("show");
    init_map1(custom);
});
$(".listnhasoche").on('click',".btn-show-info-thongtinsc",function () {

    $(".titleinfo").html("<i class='fa fa-info-circle'></i>&nbsp; Thông tin cơ sở sơ chế/ chế biến");
    var mansc=($(this).parents("tr").attr("data-mansc"));
    var vt=parseInt($(this).parents("tr").attr("data-vt"));
    infocs=resallnhasc[vt];
    // console.log(infocs);
    // console.log(JSON.parse(infocs.thongtincssc));
    var stt=1;
    var html=''
    var listp=JSON.parse(infocs.thongtincssc);
    if(isEmpty(listp)){
        alert("Không có thông tin cơ sở sơ chế/ chế biến");
        return;
    }
    else {
        $(".modalshowinforcommon").modal("show");
        for( var i in listp){
            // console.log(listp);
            html=html+listp[i]+'<br>';
        }
        $(".showinfocommon").html(html);

    }
});
