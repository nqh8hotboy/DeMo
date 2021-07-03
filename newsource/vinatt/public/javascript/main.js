////
var oj=JSON.parse(localStorage.getItem("userAGRI"));
if(oj!=null){
	
	
	$(".nameuserdropdown").html("&nbsp;" +oj.username);
var pj=oj.permission;
    if(pj!=0){
		alert_info("Bạn không có đủ quyền truy cập nôi dung này");
		 window.location.href = "login.html";

	}
}
///
//getListLoaiSP("cb_loaispdangky");
swapMain("dangkysp");
 

var urlLocal="https://www.vinatt.vn:9000/";

var urlweb="https://www.vinatt.vn/vinatt/";
var urlexcel="https://www.vinatt.vn/excel/";
var myUser=JSON.parse(localStorage.getItem("userAGRI"));

$(".themncc").click(function () {
    // alert("")
    $(".modalshowncc").modal("show");
	resetViewncc();
	
});
var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = window.location.search.substring(1),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
        }
    }
};
function queryData(url,dataSend,callback){
  // console.log("nha11"+urlLocal+url);
    $.ajax({
        type: 'POST',
        url: urlLocal+url,
        data: dataSend,
        async: true,
        xhrFields: {
            withCredentials: true
        },
        dataType: 'json',
        success: function (data) {
            
            if(data.code==9998){
               // window.location.href =urlweb+ "login.html";
            }
            else{
                callback(data);
            }
        }
    });
}

var queryDataClient=function(url,dataSend,callback){
    $.ajax({
        type: 'POST',
        url: urlLocal+url,
        data: dataSend,
        async: true,
        xhrFields: {
            withCredentials: true
        },
        dataType: 'json',
        success: function (data) {
            if(data.code==9998){
                window.location.href =urlweb+ "login.html";
            }
            else{
                callback(data);
            }
        }
    });
};


var arr = [];

function queryDataGet(url,dataSend,callback){
    // console.log(dataSend);
    $.ajax({
        type: 'GET',
        url: urlLocal+url,
        data: dataSend,
        async: true,
        dataType: 'json',
        success: function (data) {
            if(data.code==9998){
                window.location.href = urlweb+ "login.html";
            }
            else{
                callback(data);
            }
        }
    });
}
function queryAddress(classname,latlng,callback){
    var classnametemp=classname;
    // console.log("http://maps.googleapis.com/maps/api/geocode/json?latlng="+latlng+"&sensor=true");
    $.ajax({
        type: 'GET',
        url: "http://maps.googleapis.com/maps/api/geocode/json?latlng="+latlng+"&sensor=true",
        // data: dataSend,
        async: true,
        dataType: 'json',
        success: function (data) {
            callback(classnametemp,data);
        }
    });
}
function avatarURLUser(avatar) {
    return avatar==""?'./public/images/up.png':avatar.replace("./public/image_upload/",urlLocal+"public/image_upload/")
}

function avatarURLLogo(listim,avatar) {
    return avatar==""?listim:avatar;
}
function uploadFile(obj,callback) {
    var formData = new FormData();
    formData.append('file', obj[0].files[0]);
    // console.log(formData);
    $.ajax({
        url: urlLocal+"uploadfile",
        type : 'POST',
        data : formData,
        async: true,
        xhrFields: {
            withCredentials: true
        },
        processData: false,  // tell jQuery not to process the data
        contentType: false,  // tell jQuery not to set contentType
        success : callback
    });
}
function readURL(input) {
    ischoose=true;
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
            // console.log("src url 1"+ e.target.result)
            $('.info-img1change')
                .attr('src', e.target.result)
                .width(100)
                .height(100);
        };
        reader.readAsDataURL(input.files[0]);
    }
}
function uploadImage(obj,callback) {

    var formData = new FormData();
    formData.append('file', obj[0].files[0]);
    // console.log(formData);
    $.ajax({
        url: urlLocal+"upload",
        type : 'POST',
        data : formData,
        async: true,
        xhrFields: {
            withCredentials: true
        },
        processData: false,  // tell jQuery not to process the data
        contentType: false,  // tell jQuery not to set contentType
        success : callback
    });
}
function activaTab(tab){// active cái tab mà khi dùng nav-tabs của bootstrap
    $('.nav-tabs a[href="' + tab + '"]').tab('show');
}

function getDateTime(str) {//lấy ngày giờ từ chuổi timestamp
    var date=new Date(str);
    var d=date.getDate()<10? "0"+date.getDate():date.getDate();
    var m=(date.getMonth()+1)<10? "0"+(date.getMonth()+1):(date.getMonth()+1);
    var y=date.getFullYear()<10? "0"+date.getFullYear():date.getFullYear();
    var h=date.getHours()<10? "0"+date.getHours():date.getHours();
    var mu=date.getMinutes()<10? "0"+date.getMinutes():date.getMinutes();
    var ss=date.getSeconds()<10? "0"+date.getSeconds():date.getSeconds();
    return  d+"-"+m+"-"+y+" "+h+":"+mu+":"+ss
}
function getDateTimeFromDate(date) {//lấy ngày giờ từ chuổi timestamp
    date=new Date(date);
    var d=date.getDate()<10? "0"+date.getDate():date.getDate();
    var m=(date.getMonth()+1)<10? "0"+(date.getMonth()+1):(date.getMonth()+1);
    var y=date.getFullYear()<10? "0"+date.getFullYear():date.getFullYear();
    var h=date.getHours()<10? "0"+date.getHours():date.getHours();
    var mu=date.getMinutes()<10? "0"+date.getMinutes():date.getMinutes();
    var ss=date.getSeconds()<10? "0"+date.getSeconds():date.getSeconds();
    return  d+"-"+m+"-"+y+" "+h+":"+mu+":"+ss
}
function getTime(milisec) {//lấy ngày giờ từ chuổi timestamp
    var date=new Date(milisec);
    var h=date.getHours()<10? "0"+date.getHours():date.getHours();
    var mu=date.getMinutes()<10? "0"+date.getMinutes():date.getMinutes();
    var ss=date.getSeconds()<10? "0"+date.getSeconds():date.getSeconds();
    return h+":"+mu+":"+ss
}
function getTimeHM(milisec) {//lấy ngày giờ từ chuổi timestamp
    var date=new Date(milisec);
    var h=date.getHours()<10? "0"+date.getHours():date.getHours();
    var mu=date.getMinutes()<10? "0"+date.getMinutes():date.getMinutes();
    return h+":"+mu;
}
function getDateTimeCurrent() {//lấy ngày giờ từ chuổi timestamp
    date=new Date();
    var d=date.getDate()<10? "0"+date.getDate():date.getDate();
    var m=(date.getMonth()+1)<10? "0"+(date.getMonth()+1):(date.getMonth()+1);
    var y=date.getFullYear()<10? "0"+date.getFullYear():date.getFullYear();
    var h=date.getHours()<10? "0"+date.getHours():date.getHours();
    var mu=date.getMinutes()<10? "0"+date.getMinutes():date.getMinutes();
    var ss=date.getSeconds()<10? "0"+date.getSeconds():date.getSeconds();
    return  d+"-"+m+"-"+y+" "+h+":"+mu+":"+ss
}
function getDateTimeIn(str) {//lấy ngày giờ từ chuổi timestamp
    var date=new Date(str);
    var d=date.getDate()<10? "0"+date.getDate():date.getDate();
    var m=(date.getMonth()+1)<10? "0"+(date.getMonth()+1):(date.getMonth()+1);
    var y=date.getFullYear()<10? "0"+date.getFullYear():date.getFullYear();
    var h=date.getHours()<10? "0"+date.getHours():date.getHours();
    var mu=date.getMinutes()<10? "0"+date.getMinutes():date.getMinutes();
    var ss=date.getSeconds()<10? "0"+date.getSeconds():date.getSeconds();
    return  "Ngày "+d+" tháng "+m+" năm "+y;
}
function getDateCurrent() {//lấy ngày giờ từ chuổi timestamp
    date=new Date();
    var d=date.getDate()<10? "0"+date.getDate():date.getDate();
    var m=(date.getMonth()+1)<10? "0"+(date.getMonth()+1):(date.getMonth()+1);
    var y=date.getFullYear()<10? "0"+date.getFullYear():date.getFullYear();
    
    return  "Ngày "+d+" tháng "+m+" năm "+y;
}
function scrollBottomUl(obj, time) {
    // console.log(obj);
    obj.animate({scrollTop:obj.get(0).scrollHeight},time);
}
function getMonthFromDate(date) {//lấy ngày giờ từ chuổi timestamp
    date=new Date(date);
   
    var m=(date.getMonth()+1)<10? "0"+(date.getMonth()+1):(date.getMonth()+1);
 
    return  m;
}
function scrollTopUl(obj, time) {
    obj.animate({scrollTop:500},time);
}

function getDate(str) {//lấy ngày giờ từ chuổi timestamp
    if(str.length==10){
        return str;
    }
    var date=new Date(str);
    var d=date.getDate()<10? "0"+date.getDate():date.getDate();
    var m=(date.getMonth()+1)<10? "0"+(date.getMonth()+1):(date.getMonth()+1);
    var y=date.getFullYear()<10? "0"+date.getFullYear():date.getFullYear();
    var h=date.getHours()<10? "0"+date.getHours():date.getHours();
    var mu=date.getMinutes()<10? "0"+date.getMinutes():date.getMinutes();
    var ss=date.getSeconds()<10? "0"+date.getSeconds():date.getSeconds();
    return  d+"-"+m+"-"+y;
}




function auto_grow(element) {// tự động mở rộng khung texarea (<texarea onkeyup="auto_grow(this)"></texarea>)
    element.style.height = "5px";
    element.style.height = (element.scrollHeight)+"px";
}
jQuery(function($) {
    var _oldShow = $.fn.show;

    $.fn.show = function(speed, oldCallback) {
        return $(this).each(function() {
            var obj         = $(this),
                newCallback = function() {
                    if ($.isFunction(oldCallback)) {
                        oldCallback.apply(obj);
                    }
                    obj.trigger('afterShow');
                };

            // you can trigger a before show if you want
            obj.trigger('beforeShow');

            // now use the old function to show the element passing the new callback
            _oldShow.apply(obj, [speed, newCallback]);
        });
    }
});
function buildSlidePage(obj,codan,pageActive,totalPage) {
    var html="";
    pageActive=parseInt(pageActive);
    for(i = 1 ; i <=codan; i++) {
        if(pageActive-i<0) break;
        html='<button type="button" class="btn btn-outline btn-default" value="'+(pageActive-i)+'">'+(pageActive-i+1)+'</button>'+html;
    }
    if(pageActive>codan){
        html='<button type="button" class="btn btn-outline btn-default" value="'+(pageActive-i)+'">...</button>'+html;
    }
    html+='<button type="button" class="btn btn-outline btn-default" style="background-color: #5cb85c" value="'+pageActive+'">'+(pageActive+1)+'</button>';
    for(i = 1 ; i <=codan; i++){
        if(pageActive+i>=totalPage) break;
        html=html+'<button  type="button" class="btn btn-outline btn-default" value="'+(pageActive+i)+'">'+(pageActive+i+1)+'</button>';
    }
    if(totalPage-pageActive>codan+1){
        html=html+'<button type="button" value="'+(pageActive+i)+'" class="btn btn-outline btn-default">...</button>';
    }
    obj.html(html);
}

function alert_error(mes) {
    bootbox.alert({
        size: "small",
        title: "<span style='color: red'>Thất bại</span>",
        message: mes,
        callback: function(){ /* your callback code */ }
    });
}
function alert_success(mes,callback) {
    bootbox.alert({
        size: "small",
        title: "Thành công",
        message: mes,
        callback: callback
    });
}
function alert_info(mes) {
    bootbox.alert({
        size: "small",
        title: "Thông báo",
        message: mes,
        callback: function(){ /* your callback code */ }
    });
}
function avatarURLGroup(avatar) {
    // return avatar==""?'./images/icogroup.ico':avatar
    return '../images/icogroup.ico';
}
// function avatarURLUser(avatar) {
//     return avatar==""?'./images/up.png':avatar.replace("./image_upload/","http://viennhacoffee.xekia.vn:8990/image_upload/")
// }
function logout() {
    queryData("users/logout",{},function (res) {
		console.log(res);
        if(res.code==1000) {
            localStorage.removeItem("userAGRI");
            localStorage.removeItem("remmemberAGRI");
            localStorage.removeItem("usernameAGRI");
            localStorage.removeItem("passwordAGRI");
           window.location.href =urlweb+"login.html";
        }
    });
}

function validateEmail(email) {
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}
$(document).on('hidden.bs.modal', '.modal', function () {
    $('.modal:visible').length && $(document.body).addClass('modal-open');
});
function updateImageLink(urlartical,linkurl,imgchange,objremove){
    var html="";
    for(var i=0;i<urlartical.length;i++){

        var l="l"+i;
        var m=imgchange+i;
        html=html+"<img class='"+m+"' data-url='' style='border-radius: 50%;width: 90px;height: 90px; cursor: pointer' src=''><i class='"+l+"'></i>&nbsp;&nbsp;&nbsp;<i data-vt='"+i+"' class='fa fa-trash-o "+objremove+"'></i></br>";


    }
    $("."+linkurl).html(html+"");
    var s="";
    for(var i=0;i<urlartical.length;i++){
        $(".l"+i).html(urlartical[i]);
        $("."+imgchange+i).attr("src",urlartical[i]);
        $("."+imgchange+i).attr("data-url",urlartical[i]);


    }
}
 swapMain("dscaytrong");
 $(".xemmenumaphientrang").click(function () {
	window.location.href = "public/show/showmaphientrangcaytrong.html";
});
$(".xemmenumapxuonggiong").click(function () {
	window.location.href = "public/show/showmapxuonggiong.html";
});
$(".xemmenumaptiendosx").click(function () {
	window.location.href = "public/show/showmaptdsx.html";
});
$(".xemmenumapdichhai").click(function () {
	window.location.href = "public/show/showmapdichhai.html";
});
$(".xemmenumapcanhbaodichhai").click(function () {
	window.location.href = "public/show/showmapcanhbaodichhai.html";
});
////////////////////////////////bo sung them
$(".menulct").click(function () {
    // alert("");
  swapMain("dscaytrong");
 // builddslct(0);
 builddsloaicaytrong();
});
$(".menutv").click(function () {
    // alert("");
  swapMain("tv");
 // builddslct(0);
});
$(".menuinforct").click(function () {
    // alert("");
  swapMain("inforct");
 // builddslct(0);
 builddsinforcaytrong(0);
});
var flagct=0;
$(".menucauhoi").click(function () {
    // alert("");
  swapMain("cauhoibenh");
 // builddslct(0);
 builddscauhoi(0);
});
$(".menugct").click(function () {
    // alert("");
    swapMain("dsgiongcaytrong");
    // builddslct(0);
    builddsgiongcaytrong(0);
});
$(".menuinfodichbenh").click(function () {
    // alert("");
    flagct=1;
    swapMain("infordichbenh");
    // builddslct(0);
    builddsinfordichbenh(0);
});
$(".menuxuatexcelvct").click(function () {
    // alert("");
    flagct=1;
    swapMain("xuatexccelvct");
    // builddslct(0);
    builddsvungcanhtac(0);
});
$(".menutkbenh").click(function () {
    swapMain("thongkebenh");
    // builddslct(0);
   builddsthongkedichbenh(0);
});
$(".menubieudobenh").click(function () {
    swapMain("bieudobenh");
  
});
$(".menuinfohoptacxa").click(function () {
    swapMain("kinhtehtx");
    // builddslct(0);
    builddsinforhoptacxa(0);
});
$(".menumaphientrang").click(function () {
    swapMain("maphientrangct");
    // builddslct(0);
  builddsinformapthuctrang(0);
});
$(".menumapxuonggiong").click(function () {
    swapMain("mapxuonggiong");
    // builddslct(0);
    builddsinformapxuonggiong(0);
});
$(".menumaptiendosx").click(function () {
    swapMain("maptiendosx");
    // builddslct(0);
    builddsinforlistmaptiendosx(0);
});
function swapMain(main){
	$(".dscaytrong").addClass("is-hidden");
	$(".tv").addClass("is-hidden");
	$(".inforct").addClass("is-hidden");
	$(".cauhoibenh").addClass("is-hidden");
	$(".cautraloi").addClass("is-hidden");
	$(".dsgiongcaytrong").addClass("is-hidden");
	$(".infordichbenh").addClass("is-hidden");
	$(".xuatexccelvct").addClass("is-hidden");
	$(".thongkebenh").addClass("is-hidden");
	$(".bieudobenh").addClass("is-hidden");
	$(".maphientrangct").addClass("is-hidden");
	$(".mapxuonggiong").addClass("is-hidden");
	$(".maptiendosx").addClass("is-hidden");
	$(".kinhtehtx").addClass("is-hidden");
    $("."+main).removeClass("is-hidden");

}

function buildUserDropdown(){

    myUser=JSON.parse(localStorage.getItem("userAGRI"));
	
}
 function printSTT(record,pageCurr){
    if ((pageCurr+1)==1) {
        return 1;
    }else{
        return record*(pageCurr+1)-(record-1);
    }
}

function showJSONQuiCach(a){
	var s='<table border="1" class="table table-striped">';
	for(var i=0;i<a.length;i++){
		if(a[i].name!=""){
		       s=s +
            '<tr>' +
           
			   
			   '<td>'+a[i].name+'</td>' +
			    
				'<td>'+a[i].content+'</td>' +
            '</tr>';
		}
        
	}
	s=s+'</table>';
	return s;
}
function formatNumber(nStr, decSeperate, groupSeperate) {
    nStr += '';
    x = nStr.split(decSeperate);
    x1 = x[0];
    x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + groupSeperate + '$2');
    }
    return x1 + x2;
}
function updateImageLink(urlartical,linkurl,imgchange,objremove){
	var html="";
			for(var i=0;i<urlartical.length;i++){
				
				var l="l"+i;
				var m=imgchange+i;
				html=html+"<img class='"+m+"' data-url='' style='border-radius: 50%;width: 90px;height: 90px; cursor: pointer' src=''><i class='"+l+"'></i>&nbsp;&nbsp;&nbsp;<i data-vt='"+i+"' class='fa fa-trash-o "+objremove+"'></i></br>";
							
			
			}
				$("."+linkurl).html(html+"");
			var s="";
			for(var i=0;i<urlartical.length;i++){
				$(".l"+i).html(urlartical[i]);
				 $("."+imgchange+i).attr("src",urlLocal+urlartical[i]);
				$("."+imgchange+i).attr("data-url",urlLocal+urlartical[i]);
			
			
			}
}
//show len combobox
function getListLoaiCayTrong(tenbien){
	 var dataSend = {
                  charsearch:""
                };
                queryData("vungsx/getcaytrongweb", dataSend, function (res) {
					 //console.log(res);
                    if (res.code == 1000) {
                        var card=res.data.items;
						
						var html='<option value="0">Tất cả</option>';
						 for (item in card) {
						
						
						
							 
							 html=html+'<option value="'+card[item].id+'">'+card[item].ten+'</option>';
						 }
						
						
						  $("."+tenbien).html(html);
                    }else
					{
						
							var html='<option value="none">Không có loại cây trồng nào cả</option>';
							$("."+tenbien).html(html);
					
					}
                });
}
function getListTinhHuyen(tenbien){
	 var dataSend = {
                  charsearch:""
                };
                queryData("nongho/gettinhhuyen", dataSend, function (res) {
					 //console.log(res);
                    if (res.code == 1000) {
                        var card=res.data.items;
						
						var html='<option value="0">Tất cả</option>';
						 for (item in card) {
						
						
						
							 
							 html=html+'<option value="'+card[item].districtid+'">'+card[item].type+" "+card[item].name+'</option>';
						 }
						
						
						  $("."+tenbien).html(html);
                    }else
					{
						
							var html='<option value="none">Không có huyện nào cả</option>';
							$("."+tenbien).html(html);
					
					}
                });
}
function getListXa(tenbien,v){
	 var dataSend = {
                  districtid:v
                };
                queryData("nongho/getxa", dataSend, function (res) {
					 //console.log(res);
                    if (res.code == 1000) {
                        var card=res.data.items;
						
						var html='<option value="0">Tất cả</option>';
						 for (item in card) {
						
						
						
							 
							 html=html+'<option value="'+card[item].wardid+'">'+card[item].type+" "+card[item].name+'</option>';
						 }
						
						
						  $("."+tenbien).html(html);
                    }else
					{
						
							var html='<option value="none">Không có xã nào cả</option>';
							$("."+tenbien).html(html);
					
					}
                });
}
function getListAp(tenbien,v){
	 var dataSend = {
                  idward:v
                };
                queryData("nongho/getap", dataSend, function (res) {
					 //console.log(res);
                    if (res.code == 1000) {
                        var card=res.data.items;
						
						var html='<option value="0">Tất cả</option>';
						 for (item in card) {
						
						
						
							 
							 html=html+'<option value="'+card[item].id+'">'+card[item].type+" "+card[item].name+'</option>';
						 }
						
						
						  $("."+tenbien).html(html);
                    }else
					{
						
							var html='<option value="none">Không có ấp nào cả</option>';
							$("."+tenbien).html(html);
					
					}
                });
}
/////
function getListTinhHuyen_mang(tenbien){
	 var dataSend = {
                  charsearch:""
                };
                queryData("nongho/gettinhhuyen", dataSend, function (res) {
					 //console.log(res);
                    if (res.code == 1000) {
                        var card=res.data.items;
						
						var html='<option value="0;0">Tất cả</option>';
						 for (item in card) {
						
						
						
							 
							 html=html+'<option value="'+card[item].districtid+";"+card[item].type+" "+card[item].name+'">'+card[item].type+" "+card[item].name+'</option>';
						 }
						
						
						  $("."+tenbien).html(html);
                    }else
					{
						
							var html='<option value="none">Không có huyện nào cả</option>';
							$("."+tenbien).html(html);
					
					}
                });
}
function getListXa_mang(tenbien,v){
	 var dataSend = {
                  districtid:v
                };
                queryData("nongho/getxa", dataSend, function (res) {
					 //console.log(res);
                    if (res.code == 1000) {
                        var card=res.data.items;
						
						var html='<option value="0;0">Tất cả</option>';
						 for (item in card) {
						
						
						
							 
							 html=html+'<option value="'+card[item].wardid+";"+card[item].type+" "+card[item].name+'">'+card[item].type+" "+card[item].name+'</option>';
						 }
						
						
						  $("."+tenbien).html(html);
                    }else
					{
						
							var html='<option value="none">Không có xã nào cả</option>';
							$("."+tenbien).html(html);
					
					}
                });
}
function getListAp_mang(tenbien,v){
	 var dataSend = {
                  idward:v
                };
                queryData("nongho/getap", dataSend, function (res) {
					 //console.log(res);
                    if (res.code == 1000) {
                        var card=res.data.items;
						
						var html='<option value="0;0">Tất cả</option>';
						 for (item in card) {
						
						
						
							 
							 html=html+'<option value="'+card[item].id+";"+card[item].type+" "+card[item].name+'">'+card[item].type+" "+card[item].name+'</option>';
						 }
						
						
						  $("."+tenbien).html(html);
                    }else
					{
						
							var html='<option value="none">Không có ấp nào cả</option>';
							$("."+tenbien).html(html);
					
					}
                });
}
function getListcaytrong_array(tenbien){
    var dataSend = {

    };
    queryData("giongct/getallcaytrong", dataSend, function (res) {
        console.log(res);
        if (res.code == 1000) {
            var card=res.data.items;

          //  var html='<option value="0;0">'+card[0].ten+'</option>';
            for (item in card) {




                html=html+'<option data-vt="' + item + '" value="'+card[item].id+'">'+card[item].ten+'</option>';
            }


            $("."+tenbien).html(html);
        }else
        {

            var html='<option value="none">Không có cây trồng nào</option>';
            $("."+tenbien).html(html);

        }
    });
}
function getListthuoc_array(tenbien){
    var dataSend = {

    };
    queryData("danhmucthuoc/getthuocforcauhoi", dataSend, function (res) {
        console.log(res);
        if (res.code == 1000) {
            var card=res.data.items;

            //var html='<option value="0">'+"Tất cả"+'</option>';
            for (item in card) {




                html=html+'<option data-id="' + card[item].id + '" value="'+card[item].tenthuoc+','+card[item].id +'">'+card[item].tenthuoc+'</option>';
            }


            $("."+tenbien).html(html);
        }else
        {

            var html='<option value="none">Không có cây trồng nào</option>';
            $("."+tenbien).html(html);

        }

    });
}
function getListcaytrongchon_array(tenbien){
    var dataSend = {

    };
    queryData("giongct/getallcaytrong", dataSend, function (res) {
        console.log(res);
        if (res.code == 1000) {
            var card=res.data.items;

            var html='<option value="0">'+"Chọn cây trồng"+'</option>';
            for (item in card) {




                html=html+'<option data-vt="' + item + '" value="'+card[item].id+'">'+card[item].ten+'</option>';
            }


            $("."+tenbien).html(html);
        }else
        {

            var html='<option value="none">Không có cây trồng nào</option>';
            $("."+tenbien).html(html);

        }
    });
}
function getListgiaychungnhan_array(tenbien){
    var dataSend = {

    };
    queryData("vungsx/getgiaycn", dataSend, function (res) {
        console.log(res);
        if (res.code == 1000) {
            var card=res.data.items;

           // var html='<option value="0">'+"Chọn cây trồng"+'</option>';
            for (item in card) {




                html=html+'<option data-vt="' + item + '" value="'+card[item].id+'">'+card[item].ten+'</option>';
            }


            $("."+tenbien).html(html);
        }else
        {

            var html='<option value="none">Không có giấy chứng nhận</option>';
            $("."+tenbien).html(html);

        }
    });
}

function getListbenhthuoccaytrong_array(idcaytrong,tenbien){
    var dataSend = {
caytrong:idcaytrong
    };
    queryData("danhmucbenh/get", dataSend, function (res) {
        console.log(res);
        if (res.code == 1000) {
            var card=res.data.items;

            var html='<option value="0">'+"Chọn dịch bệnh"+'</option>';
            for (item in card) {




                html=html+'<option data-vt="' + item + '" value="'+card[item].id+"-"+card[item].tenbenh+'">'+card[item].tenbenh+'</option>';
            }


            $("."+tenbien).html(html);
        }else
        {

            var html='<option value="none">Không có dịch bệnh nào</option>';
            $("."+tenbien).html(html);

        }
    });
}
var slcaytrong;
function getCheckBoxcaytrong_array(tenbien){
    var dataSend = {

    };
    queryData("giongct/getallcaytrong", dataSend, function (res) {
        console.log(res);
        if (res.code == 1000) {
            var card=res.data.items;
            slcaytrong=card.length;
var html='';
          //  var html='<option value="0">'+"Tất cả"+'</option>';
            for (item in card) {



           html=html+ '<input type="checkbox" class="mycheck"  name="locationthemes" style="width: 20px" data-vt="' + item + '" value="'+card[item].id+"-"+card[item].ten+'"/>'+card[item].ten+'<br>';
            }


            $("."+tenbien).html(html);
        }else
        {

            // var html='<option value="none">Không có cây trồng nào</option>';
            // $("."+tenbien).html(html);

        }
    });
}
function getCheckBoxdichbenh_array(idcaytrong,tenbien){

    var dataSend = {
        caytrong:idcaytrong
    };
    queryData("danhmucbenh/get", dataSend, function (res) {
        console.log(res);
        if (res.code == 1000) {
            var card=res.data.items;

            var html='';
            for (item in card) {




                html=html+ '<input type="checkbox" class="mycheckbenh" onclick="onClickHandlerbenh()" name="locationthemesbenh" style="width: 20px" data-vt="' + item + '" value="'+card[item].id+"-"+card[item].tenbenh+'"/>'+card[item].tenbenh+'<br>';
            }


            $("."+tenbien).html(html);
        }else
        {

            var html='Không có dịch bệnh>';
            $("."+tenbien).html(html);

        }
    });
}

function getListthuoctheobenhcaytrong_array(benh,tenbien){
    var dataSend = {
        benh:benh
    };
    console.log(dataSend);

    queryData("danhmucthuoc/get", dataSend, function (res) {
        console.log(res);
        if (res.code == 1000) {
            var card=res.data.items;

            // var html='<option value="">'+"Tất cả"+'</option>';
            for (item in card) {




                html=html+'<option data-vt="' + item + '" value="'+card[item].id+"-"+card[item].tenthuoc+'">'+card[item].tenthuoc+'</option>';
            }


            $("."+tenbien).html(html);
        }else
        {

            var html='<option value="none">Bệnh không có thuốc điều trị</option>';
            $("."+tenbien).html(html);

        }
    });
}
function getListalldichbenh_array(tenbien){
    var dataSend = {
    };
    queryData("danhmucbenh/getalldichbenh", dataSend, function (res) {
        console.log(res);
        if (res.code == 1000) {
            var card=res.data.items;

            var html='<option value="0" selected>'+"Chọn dịch bệnh"+'</option>';
            for (item in card) {




                html=html+'<option data-vt="' + item + '" value="'+card[item].id+"-"+card[item].tenbenh+'">'+card[item].tenbenh+'</option>';
            }


            $("."+tenbien).html(html);
        }else
        {

            var html='<option value="none">Không có dịch bệnh nào</option>';
            $("."+tenbien).html(html);

        }
    });
}

var dateFormat = function() {
    var token = /d{1,4}|m{1,4}|yy(?:yy)?|([HhMsTt])\1?|[LloSZ]|"[^"]*"|'[^']*'/g,
        timezone = /\b(?:[PMCEA][SDP]T|(?:Pacific|Mountain|Central|Eastern|Atlantic) (?:Standard|Daylight|Prevailing) Time|(?:GMT|UTC)(?:[-+]\d{4})?)\b/g,
        timezoneClip = /[^-+\dA-Z]/g,
        pad = function(val, len) {
            val = String(val);
            len = len || 2;
            while (val.length < len) val = "0" + val;
            return val;
        };

    // Regexes and supporting functions are cached through closure
    return function(date, mask, utc) {
        var dF = dateFormat;

        // You can't provide utc if you skip other args (use the "UTC:" mask prefix)
        if (arguments.length == 1 && Object.prototype.toString.call(date) == "[object String]" && !/\d/.test(date)) {
            mask = date;
            date = undefined;
        }

        // Passing date through Date applies Date.parse, if necessary
        date = date ? new Date(date) : new Date;
        if (isNaN(date)) throw SyntaxError("invalid date");

        mask = String(dF.masks[mask] || mask || dF.masks["default"]);

        // Allow setting the utc argument via the mask
        if (mask.slice(0, 4) == "UTC:") {
            mask = mask.slice(4);
            utc = true;
        }

        var _ = utc ? "getUTC" : "get",
            d = date[_ + "Date"](),
            D = date[_ + "Day"](),
            m = date[_ + "Month"](),
            y = date[_ + "FullYear"](),
            H = date[_ + "Hours"](),
            M = date[_ + "Minutes"](),
            s = date[_ + "Seconds"](),
            L = date[_ + "Milliseconds"](),
            o = utc ? 0 : date.getTimezoneOffset(),
            flags = {
                d: d,
                dd: pad(d),
                ddd: dF.i18n.dayNames[D],
                dddd: dF.i18n.dayNames[D + 7],
                m: m + 1,
                mm: pad(m + 1),
                mmm: dF.i18n.monthNames[m],
                mmmm: dF.i18n.monthNames[m + 12],
                yy: String(y).slice(2),
                yyyy: y,
                h: H % 12 || 12,
                hh: pad(H % 12 || 12),
                H: H,
                HH: pad(H),
                M: M,
                MM: pad(M),
                s: s,
                ss: pad(s),
                l: pad(L, 3),
                L: pad(L > 99 ? Math.round(L / 10) : L),
                t: H < 12 ? "a" : "p",
                tt: H < 12 ? "am" : "pm",
                T: H < 12 ? "A" : "P",
                TT: H < 12 ? "AM" : "PM",
                Z: utc ? "UTC" : (String(date).match(timezone) || [""]).pop().replace(timezoneClip, ""),
                o: (o > 0 ? "-" : "+") + pad(Math.floor(Math.abs(o) / 60) * 100 + Math.abs(o) % 60, 4),
                S: ["th", "st", "nd", "rd"][d % 10 > 3 ? 0 : (d % 100 - d % 10 != 10) * d % 10]
            };

        return mask.replace(token, function($0) {
            return $0 in flags ? flags[$0] : $0.slice(1, $0.length - 1);
        });
    };
}();

// Some common format strings
dateFormat.masks = {
    "default": "ddd mmm dd yyyy HH:MM:ss",
    shortDate: "m/d/yy",
    mediumDate: "mmm d, yyyy",
    longDate: "mmmm d, yyyy",
    fullDate: "dddd, mmmm d, yyyy",
    shortTime: "h:MM TT",
    mediumTime: "h:MM:ss TT",
    longTime: "h:MM:ss TT Z",
    isoDate: "yyyy-mm-dd",
    isoTime: "HH:MM:ss",
    isoDateTime: "yyyy-mm-dd'T'HH:MM:ss",
    isoUtcDateTime: "UTC:yyyy-mm-dd'T'HH:MM:ss'Z'"
};

// Internationalization strings
dateFormat.i18n = {
    dayNames: [
        "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat",
        "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
    ],
    monthNames: [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
        "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
    ]
};

// For convenience...
Date.prototype.format = function(mask, utc) {
    return dateFormat(this, mask, utc);
};
function toDate(date) {
    if (date === void 0) {
        return new Date(0);
    }
    if (isDate(date)) {
        return date;
    } else {
        return new Date(parseFloat(date.toString()));
    }
}

function isDate(date) {
    return (date instanceof Date);
}

function format(date, format) {
    var d = toDate(date);
    return format
        .replace(/Y/gm, d.getFullYear().toString())
        .replace(/m/gm, ('0' + (d.getMonth() +1)).substr(-2))
        .replace(/d/gm, ('0' + (d.getDate() )).substr(-2))
        .replace(/H/gm, ('0' + (d.getHours() + 0)).substr(-2))
        .replace(/i/gm, ('0' + (d.getMinutes() + 0)).substr(-2))
        .replace(/s/gm, ('0' + (d.getSeconds() + 0)).substr(-2))
    //.replace(/v/gm, ('0000' + (d.getMilliseconds() % 1000)).substr(-3));
}
//////