var lang="vi";
var record=2;
 lang=getUrlParameter("lang");

var html='';
getallvideoac(0,record,html);
var totalpage=0;
function getallvideoac(page,record,html) {
	
   // $(".listlct tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  var dataSend={
	  page:page,
	  record:record
	  
  }
  // $(".addvideoac").html("<img src='./img/loading.gif' width='20px' height='20px'/>");
    queryData("activity/getactivity",dataSend,function (res) {
    //console.log(res);
	$(".showvideo").show();
	 $(".showdetailvideo").hide();
        if(res.code==1000){
		   if(lang=="vi"){
           buildHTMLVideoData(res,html);
		   }else{
			   buildHTMLVideoData_en(res,html);
		   }
            
        }else{
			if(lang=="vi"){
			 $(".addvideoac").html("Không tìm thấy dữ liệu");
			}else{
				 $(".addvideoac").html("No found data");
			}
			
        }
    });
}
function buildHTMLVideoData_en(res,html) {
   
    var data = res.data.items;
   
     totalpage=res.data.totalpage;
    var end='';
	
    for (item in data) {
        var list=data[item];
    
				
		html=html+ '<div class="col-lg-12 col-md-12" style="padding-top: 10px;">'+
					
					'<div class="embed-responsive embed-responsive-16by9">'+
							'<iframe width="560" controls height="315" src="'+list.urlac+'" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>'+
				'<h5 align="center">'+list.name_en+'</h5>'+
				'<a href="#" data-id="'+list.idac+'" data-name="'+list.name_en+'" class="click_more_video"><p><i class="fa fa-chevron-circle-right">&nbsp;More Relative Video</i></p></a>'+
				'</div></div>';
							
       
       
	
	
	
		
	  
	 
    }
  if(totalpage==0){
	 $(".addvideoac").append(html);
  }else{
  	
	
		page_current_video=page_current_video+1;
		end='<div class="col-lg-12 col-md-12 loadmore" data-page="'+page_current_video+'" style="padding-top: 10px;"><i class="fa fa-chevron-circle-down" style="color:red;">&nbsp;More</i></div>';
		$(".addvideoac").append(html+end);
	
  }
	
   
}
function buildHTMLVideoData(res,html) {
   
    var data = res.data.items;
   
     totalpage=res.data.totalpage;
    var end='';
	
    for (item in data) {
        var list=data[item];
    
				
		html=html+ '<div class="col-lg-12 col-md-12" style="padding-top: 10px;">'+
					
					'<div class="embed-responsive embed-responsive-16by9">'+
							'<iframe width="560" controls height="315" src="'+list.urlac+'" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>'+
				'<h5 align="center">'+list.name_vi+'</h5>'+
				'<a href="#" data-id="'+list.idac+'" data-name="'+list.name_vi+'" class="click_more_video"><p><i class="fa fa-chevron-circle-right">&nbsp;Xem nhiều video liên quan</i></p></a>'+
				'</div></div>';
							
       
       
	
	
	
		
	  
	 
    }
  if(totalpage==0){
	 $(".addvideoac").append(html);
  }else{
  	
	
		page_current_video=page_current_video+1;
		end='<div class="col-lg-12 col-md-12 loadmore" data-page="'+page_current_video+'" style="padding-top: 10px;"><i class="fa fa-chevron-circle-down" style="color:red;">&nbsp;Xem thêm </i></div>';
		$(".addvideoac").append(html+end);
	
  }
	
   
}

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
  //  console.log(res);
        if(res.code==1000){
		//console.log(res);
		if(lang=="vi"){
           
           buildHTMLAllDetailVideoData(res);
		}else{
			buildHTMLAllDetailVideoData_en(res);
		}
        }else{
			if(lang=="vi"){
			 $(".adddetailvideoac").html("Không có dữ liệu");
			 $(".numberpagevideo").html("");
			}else{
				 $(".adddetailvideoac").html("No found data");
				$(".numberpagevideo").html("");
			}
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
		
	 
		  
	 
	
		 
		 html=html+ '<div class="col-lg-12 col-md-12" style="padding-top: 10px;">'+
		 	
					'<div class="embed-responsive embed-responsive-16by9">'+
							'<iframe width="560" controls height="315" src="'+list.urlvideo+'" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>					</div>'+
				
			
				'</div>';	
				 			
       
       
	  
	  
	  	
    }
	 $(".adddetailvideoac").html(html);
		
	 buildSlidePage($(".numberpagevideo"),5,res.data.page,res.data.totalpage);
	
	 
}
function buildHTMLAllDetailVideoData_en(res) {
    
    var data = res.data.items;
   
  
    var html='';
 
	var stt=1;
    for (item in data) {
		var img=urlLocal+"cty.jpg";
        var list=data[item];
		if(list.urlimg!=""){
			
			img=urlLocal+list.urlimg;
    
		}
		
	 
		  
	 
	
		 
		 html=html+ '<div class="col-lg-12 col-md-12" style="padding-top: 10px;">'+
		 	
					'<div class="embed-responsive embed-responsive-16by9">'+
							'<iframe width="560" controls height="315" src="'+list.urlvideo+'" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>					</div>'+
				
			
				'</div>';	
				 			
       
       
	  
	  
	  	
    }
	 $(".adddetailvideoac").html(html);
		
	 buildSlidePage($(".numberpagevideo"),5,res.data.page,res.data.totalpage);
	
	 
}
var page_current_video=0;

$(".numberpagevideo").on('click','button',function () {
   
   
   getalldetialvideoactivity(idac,$(this).val(),record);
});

$('.addvideoac').on('click','.loadmore', function() {
 var page=  parseInt(($(this).attr("data-page")));
		
		
		//console.log(page);
		if(page!=-1 || page!=0 ){
			if(page<totalpage){
					 $(this).remove();
        getallvideoac(page,record,html);
	
			}else if(page==totalpage){
					 $(this).remove();
			}
		}
		
});
