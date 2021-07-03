var resallproducts;

getProducts(0,record,maloai,"sanpham/getallspvinatt");//hiển thị tất cả dòng
 $(".menusp").on('click',".click_detailsp",function () {

$(".numberpageproducts").show();
$(".numberpageimgaes").hide();
$(".numberpagevideo").hide();
$(".numberpageallvideo").hide();
   // var idnews=($(this).attr("data-id"));
	 maloai=($(this).attr("data-id"));
	if(maloai=="-1"){
	
	getProducts(0,record,maloai,"sanpham/getallspvinatt");
	}else
	{
		getProducts(0,record,maloai,"sanpham/getallspvinattbymaloai");
	}
   
});
function getProducts(page,record,maloaisp,str) {
	
   // $(".listlct tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  var dataSend={
	  page:page,
	  record:record,
	  maloaisp:maloaisp
	  
  }
   $(".addcontentsp").html("<img src='./img/loading.gif' width='20px' height='20px'/>");
    queryData(""+str,dataSend,function (res) {
    //console.log(res);
        if(res.code==1000){
		//console.log(res);
           
           buildHTMLProductData(res);
            
        }else{
			 $(".addcontentsp").html("Tìm không thấy");
			  $(".numberpageproducts").html("");
        }
    });
}
function buildHTMLProductData(res) {
    
    var data = res.data.items;
   
    resallproducts=data;
   
    var html='';
 
	var stt=1;
    for (item in data) {
        var list=data[item];
      var img='./img/no_logo_news.png'
	  
	  if(list.anhsp!="")
	  {
		  img=urlLocal+list.anhsp;
	  }else{
		  img='./img/no_logo_news.png'
	  }
	  
		 
	  if(lang=="vi"){
		  var gia="Giá liên hệ";
		  if(list.gia==0){
			gia=list.giachuoi;
		  }else{
			  gia=list.gia;
		  }
		   $(".breadcrumb").html("Những Sản phẩm");
		html=html+ '<div class="col-lg-3 col-md-6">'+
								'<div class="feature-item">'+
									'<h4>'+list.tensp+'</h4>'+
									'<img class="img-fluid" src="'+img+'" alt="">	'+
									'<p></p>'+
									'<h5>'+gia+'/'+list.tendvt+'</h5>'+
								'</div>'+
							'</div>';
							
       
       
	  }else{
		   $(".breadcrumb").html("Products");
		  var gia="contact price";
		  if(list.gia==0){
			gia=list.giachuoi_en;
		  }else{
			  gia=list.gia;
		  }
		  html=html+ '<div class="col-lg-3 col-md-6">'+
								'<div class="feature-item">'+
									'<h4>'+list.tensp_en+'</h4>'+
									'<img class="img-fluid" src="'+img+'" alt="">	'+
									'<p></p>'+
									'<h5>'+gia+'/'+list.tendvt_en+'</h5>'+
								'</div>'+
							'</div>';
        
	  }
	  $(".addcontentsp").html(html);
    }
	 
    buildSlidePage($(".numberpageproducts"),5,res.data.page,res.data.totalpage);
}
var page_current_products=0;
$(".numberpageproducts").on('click','button',function () {
   
    page_current_products=$(this).val();
   // showtraloi($(this).val(),idcauhoitraloi);
  //getProducts($(this).val(),record,"");
  if(maloai=="-1"){
	
	getProducts($(this).val(),record,maloai,"sanpham/getallspvinatt");
	}else
	{
		getProducts($(this).val(),record,maloai,"sanpham/getallspvinattbymaloai");
	}
});
///////////////////////////load video hoat dong
function getallvideoac(page,record) {
	
   // $(".listlct tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  var dataSend={
	  page:page,
	  record:record
	  
  }
   $(".addvideoac").html("<img src='./img/loading.gif' width='20px' height='20px'/>");
    queryData("activity/getactivity",dataSend,function (res) {
    console.log(res);
        if(res.code==1000){
		//console.log(res);
           
           buildHTMLVideoData(res);
            
        }else{
			 $(".addvideoac").html("Tìm không thấy");
			  $(".numberpageproducts").html("");
        }
    });
}
function buildHTMLVideoData(res) {
    
    var data = res.data.items;
   
    
     
	var html='';
	var stt=1;
    for (item in data) {
        var list=data[item];
      var he="";
	  if(lang=="vi"){
		 
		
				
		html=html+ '<div class="col-lg-12 col-md-12" style="padding-top: 10px;">'+
					
					'<div class="embed-responsive embed-responsive-16by9">'+
							'<iframe width="560" controls height="315" src="'+list.urlac+'" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>				</div>'+
				'<h5 align="center">'+list.name_vi+'</h5>'+
				'<a href="#video" data-id="'+list.idac+'" class="click_more_video"><p>>>Xem nhiều video hơn</p></a>'+
				'</div>';
							
       
       
	  }else{
		  
		 html=html+ '<div class="col-lg-12 col-md-12" style="padding-top: 10px;">'+
		 	
					'<div class="embed-responsive embed-responsive-16by9">'+
							'<iframe width="560" controls height="315" src="'+list.urlac+'" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>					</div>'+
				'<h5 align="center">'+list.name_en+'</h5>'+
				'<a href="#video" data-id="'+list.idac+'" class="click_more_video"><p>>>More Videos</p></a>'+
				'</div>';
							
        
	  }
	  $(".addvideoac").html(html);
    }
	 
	
    //buildSlidePage($(".numberpageproducts"),5,res.data.page,res.data.totalpage);
}
///////////////////////////
var idac=0;
$(".addvideoac").on('click',".click_more_video",function () {
	idac=($(this).attr("data-id"));
	getalldetialvideoactivity(idac,0,record);
})
function getalldetialvideoactivity(id,page,record) {
	
   // $(".listlct tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  var dataSend={
	  page:page,
	  record:record,
	  idac:id
	  
  }
   $(".addcontentvideo").html("<img src='./img/loading.gif' width='20px' height='20px'/>");
    queryData("activity/getvideoactivitybyidac",dataSend,function (res) {
    console.log(res);
        if(res.code==1000){
		//console.log(res);
           
           buildHTMLAllDetailVideoData(res);
            
        }else{
			 $(".addcontentvideo").html("Tìm không thấy");
			  $(".numberpagevideodetail").html("");
			 
        }
    });
}
function buildHTMLAllDetailVideoData(res) {
    
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
		 
		 html=html+ '<div class="col-lg-4 col-md-12" style="padding-top: 10px;">'+
		 	
					'<div class="embed-responsive embed-responsive-16by9">'+
							'<iframe width="560" controls height="315" src="'+list.urlvideo+'" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>					</div>'+
				
			
				'</div>';	
				 			
       
       
	  }else{
		  
		   html=html+ '<div class="col-lg-4 col-md-12" style="padding-top: 10px;">'+
		 	
					'<div class="embed-responsive embed-responsive-16by9">'+
							'<iframe width="560" controls height="315" src="'+list.urlvideo+'" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>					</div>'+
			
				
				'</div>';
		
	  }
	  	 $(".addcontentvideo").html(html);
    }
		
		
	 buildSlidePage($(".numberpagevideodetail"),5,res.data.page,res.data.totalpage);
	
	 
}
var page_current_video=0;
$(".numberpagevideodetail").on('click','button',function () {
   
    page_current_video=$(this).val();
   getalldetialvideoactivity(idac,$(this).val(),record);
});
////////////////////////////////////////////////////////////////////////////////
//load special products
function getallSpecialProducts(page,record) {
	
   // $(".listlct tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  var dataSend={
	  page:page,
	  record:record
	  
  }
   $(".addspecialproduct").html("<img src='./img/loading.gif' width='20px' height='20px'/>");
    queryData("sanpham/getallspvinattspecial",dataSend,function (res) {
    console.log(res);
        if(res.code==1000){
		//console.log(res);
           
           buildHTMLSpecialProductData(res);
            
        }else{
			 $(".addspecialproduct").html("Tìm không thấy");
        }
    });
}
function buildHTMLSpecialProductData(res) {
    
    var data = res.data.items;
   
    
     
	var html='';
	var stt=1;
    for (item in data) {
		 var list=data[item];
		var gia="contact price";
		  if(list.gia==0){
			gia=list.giachuoi_en;
		  }else{
			  gia=list.gia;
		  }
       
       var img='./img/no_logo_news.png'
	  
	  if(list.anhsp!="")
	  {
		  img=urlLocal+list.anhsp;
	  }else{
		  img='./img/no_logo_news.png'
	  }
	  
		 
	  if(lang=="vi"){
		 
		html=html+ '<div class="col-lg-4 col-md-6" >'+
								'<div class="feature-item">'+
									'<h4>'+list.tensp+'</h4>'+
									'<img class="img-fluid" src="'+img+'" alt="">	'+
									'<p></p>'+
									'<h5>'+gia+'/'+list.tendvt+'</h5>'+
								'</div>'+
							'</div>';
				
		
      
       
	  }else{
		 
		html=html+ '<div class="col-lg-4 col-md-6">'+
								'<div class="feature-item">'+
									'<h4>'+list.tensp+'</h4>'+
									'<img class="img-fluid" src="'+img+'" alt="">	'+
									'<p></p>'+
									'<h5>'+gia+'/'+list.tendvt+'</h5>'+
								'</div>'+
							'</div>';
				
	  }
	  
    }
	
							
	 $(".addspecialproduct").html(html);
	
    //buildSlidePage($(".numberpageproducts"),5,res.data.page,res.data.totalpage);
}