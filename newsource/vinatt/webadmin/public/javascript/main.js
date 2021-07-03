////

swapMain("dangkysp");
 
var linkimage="https://www.vinatt.vn/vinatt/";
var urlLocal="https://www.vinatt.vn:9000/";
var urlweb="https://www.vinatt.vn/vinatt/webadmin/";
var urlwebtrace="https://www.vinatt.vn/";
var ul='https://www.vinatt.vn/vinatt/webadmin/public/';
var myUser=JSON.parse(localStorage.getItem("userNS"));
var form_change=0;//phieu thu , 1 : tao don hang
var vitri_trongform=1;

function queryData(url,dataSend,callback){
   
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

function insertLS(tenform,cn,ndt,nds){
    var data={


        form:tenform,
        ngaygiotruycap:new Date().getTime(),
        chucnang:cn,
        noidungtruoc:ndt,
        noidungsau:nds


    }
    queryData("slichsutruycap/insertlichsutruycap", data, function (res) {
        if (res.code == 1000) {
        }
        else
        {
            alert("Thất bại");
        }


    });
}
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
            localStorage.removeItem("userVINATT");
            localStorage.removeItem("remmemberVINATT");
            localStorage.removeItem("usernameVINA");
            localStorage.removeItem("passwordVINA");
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
////////////////////////////////bo sung them
var record=15;
var fg=1;//gioi thieu 2 la hinh anh hoat dong
$(".menupartner").click(function () {
    // alert("");
  swapMain("partner");
 builddspartner(0,record);
});
$(".menucontact").click(function () {
    // alert("");
  swapMain("contact");
  builddscontact(0,record);
});
$(".menunews").click(function () {
    // alert("");
	fg=3;
  swapMain("news");
 
});
$(".menucongviecnongdan").click(function () {
    // alert("");
  swapMain("dsworks");
 builddsworks(0,record);
});
$(".menuhinhanhhoatdong").click(function () {
    // alert("");
	fg=2;
  swapMain("hinhanhhoatdong");
  //builddsnhasc(0,record);
  //builddscompany()
  builddsimgactivity(0,record);
});
$(".menugioithieu").click(function () {
    // alert("");
	fg=1;
  swapMain("gioithieu");
  //builddsnhasc(0,record);
  builddscompany()
});
$(".menuvideohoatdong").click(function () {
    // alert("");
	fg=3;
  swapMain("videohoatdong");
  builddsvideoactivity(0,record);
  //builddsnhasc(0,record);
//  builddscompany()
});

$(".menunhasoche").click(function () {
    // alert("");
  swapMain("nsc");
  builddsnhasc(0,record);
});
$(".menudangkysp").click(function () {
  swapMain("dangkysp");
  getListLoaiSP("cb_loaispdangky");
});
$(".menunhacungcap").click(function () {
    swapMain("ncc");
	builddssanxuat(0);
});
$(".menunhavc").click(function () {
    swapMain("nvc");
	builddsnhavc(0,record);
});
$(".menunhaphanphoi").click(function () {
    swapMain("npp");
	builddsnhaphanphoi(0,record);
});
$(".menuloaisp").click(function () {
   swapMain("loaisp");
   builddsloaisp(0,record);
});
var schon=0;

$(".menusanpham").click(function () {
    swapMain("sanpham");
	builddssanpham(0,record);
	 getListLoaiSP("cb_tenloaisp");
	   getListDVT("cb_dvtinhsp");
	getListDVT_en("cb_dvtinhsp_en");
	getListLoaiSP("cbloaisp");
});
$(".themloaisp").click(function () {
    $(".modalshowloaisp").modal("show");
    $(".modalshowloaisp").attr('data-editting',false);
	resetViewloaisp();

});
$(".themsp").click(function () {
    
    $(".modalshowsanpham").modal("show");
     $(".modalshowsanpham").attr('data-editting',false);
	// getListLoai("cb_loai");
	// getListLoaiSP("cb_tenloaisp");
	
	 // getListDVT("cb_dvtinhsp_en");
	// getListDVT_en("cb_dvtinhsp_en");
	 resetViewsanpham();
});
$(".themsprefesh").click(function () {
    
   builddssanpham(0,record);
	getListLoaiSP("cbloaisp");
});
$(".themloaisprefesh").click(function () {
    
   builddsloaisp(0,record);
});
$(".themncc").click(function () {
    // alert("")
    $(".modalshowncc").modal("show");
	resetViewncc();
	
});
$(".themnvc").click(function () {
    // alert("")
    $(".modalshownvc").modal("show");
	resetViewnvc();
	
});
$(".themnsc").click(function () {
    // alert("")
    $(".modalshownsc").modal("show");
	resetViewnsc();
	
});
$(".themnpp").click(function () {
    // alert("")
    $(".modalshownpp").modal("show");
	 $(".modalshownpp").attr('data-editting',false);
	resetViewnpp();
});
$(".themdangkysp").click(function () {
   $(".modalshowdangkysanpham").attr('data-editting',false);
  //  $(".modalshowdangkysanpham").modal("show");
  swapMain("adddangkysp");
		getListLoaiSP("dangkysp_loaisp");
		resetViewdangkysp();
	
});
var abvtv=[];
$(".modalshowdangkysanpham").on("click",".dangkysp_thembvtv",function () {
    
    $(".modalshowthuocbvtv").modal("show");
	
	
});
var aphanbon=[];

$(".modalshowdangkysanpham").on("click",".dangkysp_themphanbon",function () {
    $(".modalshowphanbon").modal("show");
});

function swapMain(main){
	$(".nsc").addClass("is-hidden");
	$(".nvc").addClass("is-hidden");
	$(".ncc").addClass("is-hidden");
	$(".npp").addClass("is-hidden");
	$(".loaisp").addClass("is-hidden");
	$(".sanpham").addClass("is-hidden");
	//$(".confirmddh").addClass("is-hidden");
    $(".dangkysp").addClass("is-hidden");
	$(".adddangkysp").addClass("is-hidden");
	$(".listworks").addClass("is-hidden");
	$(".gioithieu").addClass("is-hidden");
	$(".hinhanhhoatdong").addClass("is-hidden");
	$(".videohoatdong").addClass("is-hidden");
	$(".news").addClass("is-hidden");
	$(".videohoatdonglienquan").addClass("is-hidden");
	
	$(".partner").addClass("is-hidden");
	$(".contact").addClass("is-hidden");
	$(".dsworks").addClass("is-hidden");
    $("."+main).removeClass("is-hidden");

}

function buildUserDropdown(){

    myUser=JSON.parse(localStorage.getItem("userNS"));
	
}
 function printSTT(record,pageCurr){
    if ((pageCurr+1)==1) {
        return 1;
    }else{
        return record*(pageCurr+1)-(record-1);
    }
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
function getListLoaiSP(tenbien){
	 var dataSend = {
                  charsearch:""
                };
                queryData("loaisp/getloai", dataSend, function (res) {
					 //console.log(res);
                    if (res.code == 1000) {
                        var card=res.data.items;
						
						var html='';
						 for (item in card) {
						
						
						
							 
							 html=html+'<option value="'+card[item].maloai+'">'+card[item].tenloai+'</option>';
						 }
						
						
						  $("."+tenbien).html(html);
                    }else
					{
						
							var html='<option value="none">Không có loại nào cả</option>';
							$("."+tenbien).html(html);
					
					}
                });
}


//get san pham
function getListSanPhamByLoai(tenbien,maloai,page){
	 var dataSend = {
                  charsearch:"",
				  page:page,
					record:300,
					maloaisp:maloai
                };
                queryData("sanpham/getallspvinattbymaloai", dataSend, function (res) {
					
                    if (res.code == 1000) {
                        var card=res.data.items;
						
						var html='';
						 for (item in card) {
						
						
						//console.log(card[item]);
							 
							 html=html+'<option value="'+card[item].idsp+'">'+card[item].tensp+'</option>';
						 }
						
						
						  $("."+tenbien).html(html);
                    }else
					{
						
							var html='<option value="none">Không có sản phẩm nào cả</option>';
							$("."+tenbien).html(html);
					
					}
                });
}
function getListDVT(tenbien){
	 var dataSend = {
                  
                };
                queryData("sanpham/getdvt", dataSend, function (res) {
					
                    if (res.code == 1000) {
                        var card=res.data.items;
						
						var html='';
						 for (item in card) {
						
						
						
							 
							 html=html+'<option value="'+card[item].tendvt+'">'+card[item].tendvt+'</option>';
						 }
						
						
						  $("."+tenbien).html(html);
                    }else
					{
						
							var html='<option value="none">Không có đơn vị tính nào cả</option>';
							$("."+tenbien).html(html);
					
					}
                });
}
function getListDVT_en(tenbien){
	 var dataSend = {
                  
                };
                queryData("sanpham/getdvt", dataSend, function (res) {
					
                    if (res.code == 1000) {
                        var card=res.data.items;
						
						var html='';
						 for (item in card) {
						
						
						
							 
							 html=html+'<option value="'+card[item].tendvt_en+'">'+card[item].tendvt_en+'</option>';
						 }
						
						
						  $("."+tenbien).html(html);
                    }else
					{
						
							var html='<option value="none">Không có đơn vị tính nào cả</option>';
							$("."+tenbien).html(html);
					
					}
                });
}
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
function getListWork(tenbien){
	 var dataSend = {
                  
                };
                queryData("dangkysp/getallwork", dataSend, function (res) {
					
                    if (res.code == 1000) {
                        var card=res.data.items;
						
						var html='';
						 for (item in card) {
						
						
						
							 
							 html=html+'<option value="'+card[item].idw+'">'+card[item].namew+'</option>';
						 }
						
						
						  $("."+tenbien).html(html);
                    }else
					{
						
							var html='<option value="none">Không có công việc nào</option>';
							$("."+tenbien).html(html);
					
					}
                });
}
function getListQRCode(tenbien,iduser){
	 var dataSend = {
                  iduser:iduser
                };
                queryData("dangkysp/getallqrcode", dataSend, function (res) {
					
					console.log(res);
                    if (res.code == 1000) {
						
                        var card=res.data.items;
						//console.log(card.length);
						if(card.length==0){
							$(".notify").html("Bạn chưa có cấp mã QRCode.<br> Xin Vui Lòng Liên Hệ Nhà Quản Trị ");
						
						}else{
						var html='';
						 for (item in card) {
						
						
						
							 
							 html=html+'<option value="'+card[item].idsp+'">'+"IDSP: "+card[item].idsp+" - Lô:"+card[item].lo+" - Cây: ("+card[item].tensp+")"+'</option>';
						 }
						
						
						  $("."+tenbien).html(html);
						}
                    }else
					{
						
							var html='<option value="none">Lỗi</option>';
							$("."+tenbien).html(html);
					
					}
                });
}
//update len server anh
function updatelibra(r1){
	var dataSend=
			{
		
			listimage:r1,
			create_img:new Date().getTime()
			}
			queryData('news/createlibra', dataSend, function (res) {
           
			 console.log(res);
            if (res.code == 1000) {
				
			}
			})
}
///////////////////////////////////////////Xu ly login
	$(".remember").prop('checked', true);
	$(".username").focus();

    $(".formlogin").show(200);
    $(".nametitle").html("Đăng nhập")
    
    $(".btn-backselect").click(function () {
        
        $(".formlogin").hide();

    });
    $(".btn-lg").click(function () {
        var username=$(".username").val();
        var password=$(".password").val();
       

        login(username,password);
      
    });

    function login(username,password) {
	//console.log("nha");
        if(username==""||password==""){
            alert("Vui lòng nhập đầy đủ thông tin");
            return;
        }
        queryData("users/login",{username:username, password:password},function (res) {
          //  console.log(res);
            if(res.code==1000) {
				 if(res.data.permission==0){
                if ($(".remember").is(':checked')) {
                    localStorage.setItem("remmemberVINATT", true);
                }
                localStorage.setItem("userVINATT", JSON.stringify(res.data));
                localStorage.setItem("iduserVINATT", res.data.iduser);
                localStorage.setItem("usernameVINA", username);
                localStorage.setItem("passwordVINA", password);
              
			    
				goto(res);
			   }else{
				   if(res.data.permission==6){ //quanly nha nuoc
						window.location.href = "admin_show_works_farmer.html";
				   }else //phai dang nhap
				   {   alert("Bạn không đủ quyền truy cập trang web này");
					   window.location.href = "login.html";
				   }
				}
            }
            else{
                alert("Sai tên đăng nhập hoặc mật khẩu");
                return;
            }

        });
    }



    function goto(res) {


        window.location.href = "index.html";




    }
	$(".btn-changepass").click(function () {

$(".nhaplaipassnew").html('');
$(".nhaplaipassold").html('');
		var iduser=localStorage.getItem('iduserVINATT');
            var passwordold=$(".old_password").val();
            var passwordnew=$(".new_password").val();
            var passworknewagain=$(".newagain_password").val();
            if(passwordnew!=passworknewagain){
                $(".nhaplaipassnew").html("Nhập lại mật khẩu mới");
                $(".newagain_password").focus();

                return;
            }
            var dataSend={
                iduser:iduser,
                passwordold:passwordold,
                passwordnew:passwordnew
            }
            //console.log(dataSend);
            queryData("users/changepassword",dataSend,function (res) {
               // console.log(res);
                if(res.code==1000){
                    alert("Thay đổi thành công!");
                    window.location.href = "index.html";

                }else{
                    alert("Thay đổi thất bại");

                    $(".nhaplaipassold").html("Mật khẩu cũ không đúng");
                    $(".old_password").focus();
                    $(".old_password").change(function () {
                       // console.log("a")
                        $(".nhaplaipassold").html();
                    })
                    // window.location.href = "login.html";

                }
            });
        });
		function check(){
 var re=localStorage.getItem('remmemberVINATT');  
//console.log(re); 
	if(re=="true"){
		//console.log(re); 
		$(".username").val(localStorage.getItem('usernameVINA'));
        $(".password").val(localStorage.getItem('passwordVINA'));
		$(".remember").prop('checked', true);
        login(localStorage.getItem('usernameVINA'),localStorage.getItem('passwordVINA'));
}else{
		$(".username").val("");
        $(".password").val("");
}	
		}
///////////////////////////////////////////////////////
