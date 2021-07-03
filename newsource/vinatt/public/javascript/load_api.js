var lang="vi";
var record=2;
getallvideoac(0,record);
function getallvideoac(page,record) {
	
   // $(".listlct tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  var dataSend={
	  page:page,
	  record:record
	  
  }
   $(".addvideoac").html("<img src='./img/loading.gif' width='20px' height='20px'/>");
    queryData("activity/getactivity",dataSend,function (res) {
    //console.log(res);
	$(".showvideo").show();
	 $(".showdetailvideo").hide();
        if(res.code==1000){
		//console.log(res);
           $(".showdetailvideo").hide();
           buildHTMLVideoData(res);
            
        }else{
			
			 $(".addvideoac").html("Tìm không thấy video");
			  $(".numberpagevideo").html("");
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
		 
		 var htmlfirst='<div class="col-lg-12 col-md-12 alert alert-dark" style="padding-top: 10px;"  >'+
					'<h4 class="class_video">Video hoạt động</h4>'+
				'</div>';
				he=htmlfirst;
				
		html=html+ '<div class="col-lg-12 col-md-12" style="padding-top: 10px;">'+
					
					'<div class="embed-responsive embed-responsive-16by9">'+
							'<iframe width="560" controls height="315" src="'+list.urlac+'" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>				</div>'+
				'<h5 align="center">'+list.name_vi+'</h5>'+
				'<a href="#" data-id="'+list.idac+'" data-name="'+list.name_vi+'" class="click_more_video"><p>>>Xem nhiều video hơn</p></a>'+
				'</div>';
							
       
       
	  }else{
		   var htmlfirst='<div class="col-lg-12 col-md-12 alert alert-dark" style="padding-top: 10px;"  >'+
					'<h4 class="class_video">Video Activity</h4>'+
				'</div>';
				he=htmlfirst
		 html=html+ '<div class="col-lg-12 col-md-12" style="padding-top: 10px;">'+
		 	
					'<div class="embed-responsive embed-responsive-16by9">'+
							'<iframe width="560" controls height="315" src="'+list.urlac+'" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>					</div>'+
				'<h5 align="center">'+list.name_en+'</h5>'+
				'<a href="#" data-id="'+list.idac+'" data-name="'+list.name_en+'" class="click_more_video"><p>>>More Videos</p></a>'+
				'</div>';
							
        
	  }
	  $(".addvideoac").html(he+html);
    }
	 
	
    buildSlidePage($(".numberpageallvideo"),5,res.data.page,res.data.totalpage);
}
$(".numberpageallvideo").on('click','button',function () {
   
   
   getallvideoac($(this).val(),record);
});
$(".add_detail_video").on('click',".back_add_detail_video",function () {
	 $(".showdetailvideo").hide();
	  $(".showvideo").show();
});
var idac=0;
var nameactivity="";
$(".addvideoac").on('click',".click_more_video",function () {
	idac=($(this).attr("data-id"));
	nameactivity=($(this).attr("data-name"));
	 $(".showdetailvideo").show();
	  $(".showvideo").hide();
	  //console.log(idac);
	   $(".add_detail_video").html('<b class="back_add_detail_video"><<</b>&nbsp;&nbsp;&nbsp;'+nameactivity);
	getalldetialvideoactivity(idac,0,record);
})
function getalldetialvideoactivity(id,page,record) {
	
   // $(".listlct tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  var dataSend={
	  page:page,
	  record:record,
	  idac:id
	  
  }
   $(".adddetailvideoac").html("<img src='./img/loading.gif' width='20px' height='20px'/>");
    queryData("activity/getvideoactivitybyidac",dataSend,function (res) {
    console.log(res);
        if(res.code==1000){
		//console.log(res);
           
           buildHTMLAllDetailVideoData(res);
            
        }else{
			 $(".adddetailvideoac").html("Tìm không thấy video");
			 $(".numberpagevideo").html("");
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
		 
		 html=html+ '<div class="col-lg-12 col-md-12" style="padding-top: 10px;">'+
		 	
					'<div class="embed-responsive embed-responsive-16by9">'+
							'<iframe width="560" controls height="315" src="'+list.urlvideo+'" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>					</div>'+
				
			
				'</div>';	
				 			
       
       
	  }else{
		  
		   html=html+ '<div class="col-lg-12 col-md-12" style="padding-top: 10px;">'+
		 	
					'<div class="embed-responsive embed-responsive-16by9">'+
							'<iframe width="560" controls height="315" src="'+list.urlvideo+'" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>					</div>'+
			
				
				'</div>';
		
	  }
	  
	  	 $(".adddetailvideoac").html(html);
    }
	
		
	 buildSlidePage($(".numberpagevideo"),5,res.data.page,res.data.totalpage);
	
	 
}
var page_current_video=0;
$(".numberpagevideo").on('click','button',function () {
   
    page_current_video=$(this).val();
   getalldetialvideoactivity(idac,$(this).val(),record);
});