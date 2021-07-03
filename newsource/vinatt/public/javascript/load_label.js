//show labels of web
var record=12;
var maloai=-1;
var poscurrent_news_selected=-1;
var lang="vi";
getLabelAll("vi");

$(".container-fluid").on('click',".click_vi",function () {
  
		getLabelAll("vi");
    
});
$(".container-fluid").on('click',".click_en",function () {
  
		getLabelAll("en");
    
});
function getLabelAll(v) {
	lang=v;
	//alert(v);
    //console.log("V");
   // $(".listlct tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  var dataSend={
	  lang:v
  }
    queryDataGet("load_cookie/index",dataSend,function (res) {
    //console.log("huhu");
        if(res.code==1000){
		console.log(res);
           $(".class_home").html("<i class='fa fa fa-home'> </i> "+res.data.home);
		   $(".class_introduce").html("<i class='fa fa-globe'> </i> "+res.data.Introduce);
		   $(".class_product").html("<i class='fa fa-pagelines'></i> " +res.data.Product);
		   $(".class_support").html("<i class='fa fa-heartbeat'></i> "+res.data.Customer_support);
		   $(".class_gallery").html("<i class='fa fa-picture-o'></i> "+res.data.Gallery);
		   $(".class_news").html("<i class='fa fa-newspaper-o'></i> " +res.data.News);
		   $(".class_contact").html("<i class='fa fa-phone-square'></i> "+res.data.Contact);
		   $(".breadcrumb").html(res.data.News);
		   $(".class_partner").html(res.data.Partner);
		   $(".class_specicalproduct").html(res.data.SpecicalProduct);
		     $(".class_ViewMore").html(res.data.ViewMore);
			   $(".class_Namecompany").html(res.data.Namecompany);
			    $(".class_Add").html(res.data.Add);
				 $(".class_Phone").html(res.data.Phone);
				  $(".class_Email").html(res.data.Email);
				   $(".class_Website").html(res.data.Website);
				   
				     $(".class_USName").html(res.data.USName);
					   $(".class_USAdd").html(res.data.USAdd);
					     $(".class_USEmail").html(res.data.USEmail);
						   $(".class_UShotline").html(res.data.UShotline);
						   
						     $(".class_EUName").html(res.data.EUName);
							$(".class_EUAdd").html(res.data.EUAdd);
					     $(".class_EUEmail").html(res.data.EUEmail);
						   $(".class_EUhotline").html(res.data.EUhotline);
						   console.log(res.data.LoganVINATT);
						     $(".class_LoganVINATT").html(res.data.LoganVINATT);
							   $(".class_LoganVINATT1").html(res.data.LoganVINATT1);
							     $(".class_LoganVINATT2").html(res.data.LoganVINATT2);
								  $(".class_galleryall").html(res.data.GalleryAll);
								  $(".class_videoall").html(res.data.VideoAll);
								 
								 
         $(".class_video").html("<i class='fa fa-video-camera'></i> "+res.data.VideoTree);
            getNews(0,record,"");
			//load language follows relative
			getAllNews(page_current_news,record,"");
			//reload language when menu news is selected
			showDetailNews(poscurrent_news_selected);
			getAllSPMenu(0,record,"");
			getIntroduce();
			getallvideoac(0,10);
			getimageactivity();
			getallSpecialProducts(0,record);
			getallvideoactivity(0,record);
			getallimageactivity(0,record);
			/////load san pham theo ngon ngu
			if(maloai=="-1"){
	
				getProducts(0,record,maloai,"sanpham/getallspvinatt");
			}else
				{
				getProducts(0,record,maloai,"sanpham/getallspvinattbymaloai");
				}
			}else{
			//console.log(res+"VV");
            $(".class_introduce").html("<i class='fa fa-user'> </i>"+res.data.Introduce);
			}
    });
}
//load san pham trong menu

function getAllSPMenu() {
	
   // $(".listlct tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  var dataSend={
	  
	  
  }
   $(".menusp").html("<img src='./img/loading.gif' width='20px' height='20px'/>");
    queryData("loaisp/getloai",dataSend,function (res) {
    console.log(res);
        if(res.code==1000){
		//console.log(res);
           
           buildHTMLMenuSPData(res);
            
        }else{
			 $(".menusp").html("Tìm không thấy");
        }
    });
}
function buildHTMLMenuSPData(res) {
    
    var data = res.data.items;
   
   
    var html='';
	var stt=1;
	var sall='Tất cả';
    for (item in data) {
        var list=data[item];
      
	  if(lang=="vi"){
		  sall='Tất cả';
      html=html+ 	'<p ><a class="dropdown-item click_detailsp" href="#sp" data-id='+list.maloai+'>'+list.tenloai+'</a></p>';
        
	  }else{
		  html=html+	'<p><a class="dropdown-item click_detailsp" href="#sp" data-id='+list.maloai+'>'+list.tenloai_en+'</a></p>';
			sall="All";					
       
        
	  }
    }
	var hf='<p><a class="dropdown-item click_detailsp" href="#sp" data-id="-1">'+sall+'</a></p>';
 
	$(".menusp").html(hf+html);
	
}

//load thong tin gioi thieu cong ty
function getIntroduce() {
	
   // $(".listlct tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  var dataSend={
	  
	  
  }
   $(".addintroduce").html("<img src='./img/loading.gif' width='20px' height='20px'/>");
    queryData("gioithieu/getintroducecompany",dataSend,function (res) {
    console.log(res);
        if(res.code==1000){
		//console.log(res);
           
           buildHTMLIntroduceData(res);
            
        }else{
			 $(".addintroduce").html("Tìm không thấy");
			 
        }
    });
}
function buildHTMLIntroduceData(res) {
    
    var data = res.data.items;
   
   
    var html='	<p><a class="dropdown-item click_detailsp" href="#sp" data-id="-1">Tất cả</a></p>';
 
	var stt=1;
    for (item in data) {
		var img=urlLocal+"image_upload"+"/cty.jpg";
        var list=data[item];
		var k=JSON.parse(list.listimg);
		if(k.length==0){
			img=urlLocal+"image_upload"+"/cty.jpg";
		}else{
		
			obj = JSON.parse(list.listimg);
			img=urlLocal+obj[0];
     // console.log(obj);
		}
		
	 
		  
	  
	  if(lang=="vi"){
		  html='<div class="alert alert-dark" role="alert">'+
					'<h4 class="class_introduce"><i class="fa fa-globe"> </i>&nbsp;Giới thiệu</h4>'+
				'</div>	';
      html=html+'<img class="img-fluid" src="'+img+'" class="mr-3" alt="#">'+
						'<div class="media-body">'+
						
						'</div>'+list.contentintro_vi+
				'<div class="col-lg-12 col-md-12"style="padding-top: 10px;">'+
						
				'</div>';
				 $(".addintroduce").html(html);
	  }else{
			 html='<div class="alert alert-dark" role="alert">'+
					'<h4 class="class_introduce"><i class="fa fa-globe"> </i>&nbsp;Introduce</h4>'+
				'</div>	';
      html=html+'<img class="img-fluid" src="'+img+'" class="mr-3" alt="#">'+
						'<div class="media-body">'+
						
						'</div>'+list.contentintro_en+
				'<div class="col-lg-12 col-md-12"style="padding-top: 10px;">'+
						
				'</div>';
				 $(".addintroduce").html(html);					
       
       
	  }
    }
}
////load anh cong ty
function getimageactivity() {
	
   // $(".listlct tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  var dataSend={
	  
	  
  }
   $(".addimages").html("<img src='./img/loading.gif' width='20px' height='20px'/>");
    queryData("gioithieu/getimagestop",dataSend,function (res) {
    console.log(res);
        if(res.code==1000){
		//console.log(res);
           
           buildHTMLImagesData(res);
            
        }else{
			 $(".addimages").html("Tìm không thấy");
        }
    });
}
function buildHTMLImagesData(res) {
    
    var data = res.data.items;
   
   
    var html='';
 
	var stt=1;
    for (item in data) {
		var img=urlLocal+"cty.jpg";
        var list=data[item];
		if(list.urlimg!=""){
			
			img=urlLocal+list.urlimg;
    
		}
		
	 
		  
	  var smore="Xem nhiều hình ảnh hơn";
	  if(lang=="vi"){
		  html=html+'<img class="img-fluid" src="'+img+'"  alt="#">';
				
		smore="Xem nhiều hình ảnh hơn";
				
				 			
       
       
	  }else{
		  smore="View More Images";
		    html=html+'<img class="img-fluid" src="'+img+'"  alt="#">';
		
	  }
	  	
    }
	var endh='<a href="#imagesactivity" class="click_more_images"><p>&gt;&gt;'+smore+'</p></a>';
	  $(".addimages").html(html+endh);	
}
///
$(".addimages").on('click',".click_more_images",function () {
	
	getallimageactivity(0,record);
})
function getallimageactivity(page,record) {
	
   // $(".listlct tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  var dataSend={
	  page:page,
	  record:record
	  
  }
   $(".addcontentimg").html("<img src='./img/loading.gif' width='20px' height='20px'/>");
    queryData("gioithieu/getimagesactivity",dataSend,function (res) {
    //console.log(res);
        if(res.code==1000){
		//console.log(res);
           
           buildHTMLAllImagesData(res);
            
        }else{
			 $(".addcontentimg").html("Tìm không thấy");
			 $(".numberpageimg").html("");
        }
    });
}
function buildHTMLAllImagesData(res) {
    
    var data = res.data.items;
   
   
    var html='';
 
	var stt=1;
    for (item in data) {
		var img=urlLocal+"cty.jpg";
        var list=data[item];
		if(list.urlimg!=""){
			
			img=urlLocal+list.urlimg;
    
		}
		
	 
		  
	 
	  if(lang=="vi"){
		 
		html=html+ '<div class="col-lg-6 col-md-12">'+
							
									'<p></p>'+
									'<img class="embed-responsive embed-responsive-16by9" height="250" src="'+img+'" alt="">	'+
								
								
							'</div>';		
				 			
       
       
	  }else{
		  
		    html=html+ '<div class="col-lg-6 col-md-12">'+
								
										'<p></p>'+
									'<img class="embed-responsive embed-responsive-16by9" height="250" src="'+img+'" alt="">	'+
									
							
							'</div>';		
				 			
		
	  }
	  	 $(".addcontentimg").html(html);
    }
	
	 buildSlidePage($(".numberpageimg"),5,res.data.page,res.data.totalpage);
	
	 
}
var page_current_images=0;
$(".numberpageimg").on('click','button',function () {
   
    page_current_products=$(this).val();
   getallimageactivity($(this).val(),record);
});
/////load video from menu video
$(".class_video").click(function () {
	
	getallvideoactivity(0,record);
})
function getallvideoactivity(page,record) {
	
   // $(".listlct tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  var dataSend={
	  page:page,
	  record:record
	  
  }
   $(".addcontentvideo").html("<img src='./img/loading.gif' width='20px' height='20px'/>");
    queryData("activity/getallvideoactivity",dataSend,function (res) {
    //console.log(res);
        if(res.code==1000){
		//console.log(res);
           $(".numberpagevideodetail").html("");
           buildHTMLAllVideoContentData(res);
            
        }else{
			 $(".addcontentvideo").html("Tìm không thấy");
			  $(".numberpagevideodetail").html("");
        }
    });
}
function buildHTMLAllVideoContentData(res) {
    
      var data = res.data.items;
   
   
    var html='';
 
	var stt=1;
    for (item in data) {
		var img=urlLocal+"cty.jpg";
        var list=data[item];
		if(list.urlimg!=""){
			
			img=urlLocal+list.urlimg;
    
		}
		
	 
		  
	 
	  if(lang=="vi"){
		 
		 html=html+ '<div class="col-sm-4 col-lg-4 col-md-12" style="padding-top: 10px;">'+
		 	
					'<div class="embed-responsive embed-responsive-16by9">'+
							'<iframe width="560" controls height="315" src="'+list.urlvideo+'" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>'+
				
			
				'</div>';	
				 			
       
       
	  }else{
		  
		   html=html+ '<div class="col-sm-4 col-lg-4 col-md-12" style="padding-top: 10px;">'+
		 	
					'<div class="embed-responsive embed-responsive-16by9">'+
							'<iframe width="560" controls height="315" src="'+list.urlvideo+'" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>					</div>'+
			
				
				'</div>';
		
	  }
	  	 $(".addcontentvideo").html(html);
    }
		
	 buildSlidePage($(".numberpagevideodetail"),5,res.data.page,res.data.totalpage);
	 
}
var page_current_videoall=0;
$(".numberpagevideodetail").on('click','button',function () {
   
    page_current_videoall=$(this).val();
   getallvideoactivity($(this).val(),record);
});