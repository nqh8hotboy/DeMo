var resallnews;
getNews(0,5,"");//hiển thị 3 dòng
getAllNews(0,record,"");
function getNews(page,record,charsearch) {
	
   // $(".listlct tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  var dataSend={
	  page:page,
	  record:record,
	  charsearch:charsearch
	  
  }
   $(".addnews").html("<img src='./img/loading.gif' width='20px' height='20px'/>");
    queryData("news/getnews",dataSend,function (res) {
    console.log(res);
        if(res.code==1000){
		//console.log(res);
           
           buildHTMLNewsData(res);
            
        }else{
			 $(".addnews").html("Tìm không thấy");
        }
    });
}
function buildHTMLNewsData(res) {
    
    var data = res.data.items;
   
    resallnews=data;
   
    var html='';
    var news="Tin tức";
	var stt=1;
    for (item in data) {
        var list=data[item];
      var img='./img/no_logo_news.png'
	   var img='./img/no_logo_news.png'
	  if(list.urlimg!="")
	  {
		  img=urlLocal+list.urlimg;
	  }else{
		  img='./img/no_logo_news.png'
	  }
	  if(lang=="vi"){
		  news="Tin tức";
      html=html+ '<div class="row align-items-center justify-content-center click_detailnews" data-id="' + list.idnews+'"  data-vt="' + item + '">'	+	
									'<div class="col-lg-12 col-md-12" align="justify" >'+
																
										'<img class="img-fluid" src="'+img+'" alt="">'+
										'<div class="section-title text-middle">'+
											'<h4 class="title_news">'+list.title_vi+'</h4>'+
											'<div class="shortdescript" align="justify">'+	list.short_description_vi+ '</div>'+
								
												'<div class="shortdescript" align="justify" style="color:red">Ngày đăng: '+	getDate(list.create_date)+ '</div>'+
									
										'</div>'+
										
									'</div>'+
								'</div>';
								
							
        stt++;
       
	  }else{
		  news="News";
		  html=html+ '<div class="row align-items-center justify-content-center click_detailnews" data-id="' + list.idnews+'"  data-vt="' + item + '">'	+	
									'<div class="col-lg-12 col-md-12" align="justify">'+
																
										'<img class="img-fluid" src="'+img+'" alt="">'+
										'<div class="section-title text-middle">'+
											'<h4 class="title_news">'+list.title_en+'</h4>'+
											'<div class="shortdescript" align="justify">'+	list.short_description_en+ '</div>'+
											'<div class="shortdescript" align="justify" style="color:red">Created Date: '+	getDate(list.create_date)+ '</div>'+
									
										'</div>'+
										
									'</div>'+
								'</div>';
								
        stt++;
       
	  }
	  var hnews='<div class="alert alert-dark" role="alert">'+
					'<h4 class="class_news" >'+news+'</h4>'+
				'</div>';
				 $(".addnews").html(hnews+html);
    }
    
}
//load news when is selected
function showDetailNews(posnews){
	//console.log(posnews);
	if(posnews==-1){
	}else{
	var html='';
	if(lang=="vi"){
		$(".class_newss").html("Chi tiết Tin tức");
	html=html+'<div class="col-lg-12 md-12"style="padding-top: 10px;">'+
				'<div class="alert alert-dark" role="alert">'+
					'<h4 >'+resallnews[posnews].title_vi+'</h4>'+
				'</div>'+
				'<div class="media">'+
					
						'<div class="media-body" align="justify">'+resallnews[posnews].content_vi+'</div>'+
						
						
				'</div>'+
				'<div class="col-lg-12 col-md-12" style="padding-top: 10px;">'+
						'<div class="alert alert-dark" role="alert">'+
					'<h4 class="relativenews">Các tin tức liên quan</h4>'+
					
				'</div>'+
				'</div>'+
			'</div>';
	}else{
		$(".class_newss").html("Detail News");
		html=html+'<div class="col-lg-12 md-12"style="padding-top: 10px;">'+
				'<div class="alert alert-dark" role="alert">'+
					'<h4  >'+resallnews[posnews].title_en+'</h4>'+
				'</div>'+
				'<div class="media">'+
					
						'<div class="media-body" align="justify">'+resallnews[posnews].content_en+'</div>'+
						
						
				'</div>'+
				'<div class="col-lg-12 col-md-12" style="padding-top: 10px;">'+
				'<div class="alert alert-dark" role="alert">'+
					'<h4 class="relativenews">Relative News</h4>'+
					
				'</div>'+
				'</div>'+
			'</div>';
	}
 $(".addcontentnews").html(html);
	}
}
//click menu news
$(".addnews").on('click',".click_detailnews",function () {


   // var idnews=($(this).attr("data-id"));
	var posnews=($(this).attr("data-vt"));
	poscurrent_news_selected=posnews;
	showDetailNews(posnews);
   
});
//when click news relatives
$(".addnewsdetail").on('click',".detal_relative_news",function () {


   // var idnews=($(this).attr("data-id"));
	var posnews=($(this).attr("data-vt"));
	poscurrent_news_selected=posnews;
	showDetailNews(posnews);
   
});
//hien thi tat ca cac tin tuc
function getAllNews(page,record,charsearch) {
	
   // $(".listlct tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  var dataSend={
	  page:page,
	  record:record,
	  charsearch:charsearch
	  
  }
   $(".addnewsdetail").html("<img src='./img/loading.gif' width='20px' height='20px'/>");
    queryData("news/getnews",dataSend,function (res) {
   // console.log(res);
        if(res.code==1000){
		//console.log(res);
           
           buildHTMLAllNewsData(res);
            
        }else{
			 $(".addnewsdetail").html("Tìm không thấy");
        }
    });
}
function buildHTMLAllNewsData(res) {
    
    var data = res.data.items;
    var html='';
    
	for (item in data) {
        var list=data[item];
		 var img='./img/no_logo_news.png'
	  if(list.urlimg!="")
	  {
		  img=urlLocal+list.urlimg;
	  }else{
		  img='./img/no_logo_news.png'
	  }
	  if(lang=="vi"){
		   $(".relativenews").html("Các tin tức liên quan");
		 
	html=html+'<div class="media detal_relative_news" data-vt="'+item+'"><img src="'+img+'" class="mr-3" alt="news" width="90px" height="90px">'+
						'<div class="media-body">'+
						'<h4 class="mt-0" class="class_title_news">'+list.title_vi+'</h4>'+
						'<p class="class_short_news">'+list.short_description_vi+'</p>'+
						'<p class="class_short_news">Ngày đăng'+getDate(list.create_date)+'</p>'+
							'</div></div>';
	  }else{
		   $(".relativenews").html("Relative News");
		  	html=html+'<div class="media"><img src="'+img+'" class="mr-3" alt="news" width="90px" height="90px">'+
						'<div class="media-body">'+
						'<h4 class="mt-0" class="class_title_news">'+list.title_en+'</h4>'+
						'<p class="class_short_news">'+list.short_description_en+'</p>'+
						'<p class="class_short_news"> Created Date'+getDate(list.create_date)+'</p>'+
							'</div></div>';
	  }		  
						   $(".addnewsdetail").html(html);
	}
	
	buildSlidePage($(".numberpagenews"),5,res.data.page,res.data.totalpage);
}
var page_current_news=0;
$(".numberpagenews").on('click','button',function () {
   
    page_current_news=$(this).val();
   // showtraloi($(this).val(),idcauhoitraloi);
  getAllNews($(this).val(),record,"");
});