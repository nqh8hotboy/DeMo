var resalltktheoloai;

function builddsthongke(page) {
     var ddh_tungay=moment($(".tkloai_tungay").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
    var ddh_denngay=moment($(".tkloai_denngay").val(),'DD-MM-YYYY HH:mm:ss').toDate().getTime();
	var statusdh=$(".cb_trangthaitk").val();
    var dataSend={

       
       page:page,
	   record:2,
	   fr:ddh_tungay,
	   end:ddh_denngay,
	   statusdh:statusdh
    }
   $(".listthongke").html("");
    $(".listthongke tbody").html("<img src='img/loading.gif' width='20px' height='20px'/>");
  
    queryData("thongke/getdhpage",dataSend,function (res) {
     
        if(res.code==1000){
		
            $(".listthongke").html("");
            buildHTMLTKData(res);
            
        }else{
            $(".listthongke").html("Tìm không thấy");
        }
    });
}

$(".btn_tim_tk").click(function () {
   msp=[];
   builddsthongke(0);
  
});
function compare(a, b) {
  // Use toUpperCase() to ignore character casing
  const genreA = a.tensp.toUpperCase();
  const genreB = b.tensp.toUpperCase();

  let comparison = 0;
  if (genreA > genreB) {
    comparison = 1;
  } else if (genreA < genreB) {
    comparison = -1;
  }
  return comparison;
}
var msp=[];

function buildHTMLTKData(res) {
    
    var data = res.data.items;
  // console.log(data);
    resalltktheoloai=data;
	
	for (item in data) {
        var list=data[item];
		var re=JSON.parse(list.infororder);
		for(j in re){
			var l=re[j];
			msp.push(l);
		}
//	console.log(re);
//	msp.push(re);
	}
   
    var html='';
 
	var stt=1;
	msp.sort(compare);
	
	var finalArr = msp.reduce((m, o) => {
    var found = m.find(p => p.idsp === o.idsp);
    if (found) {
        found.sl += o.sl;
		if(Number.isInteger(o.gia)){
		found.gia += parseFloat(o.gia);
		}
     
       // found.femaleCount += o.femaleCount;
    } else {
        m.push(o);
    }
    return m;
}, []);
//console.log(finalArr);
    for (var k in finalArr) {
        var kq=finalArr[k];
      
       
        html=html +
            '<tr>' +

            '<td class="btn-show-info-cv">' + stt + '</td>' +
           
            '<td class="btn-show-info-cv">' + kq.tensp+ '</td>'+
             '<td class="btn-show-info-cv">' + kq.sl+ '</td>'+
               '<td class="btn-show-info-cv">' +formatNumber((kq.sl * kq.gia)  , '.', ',') + '</td>'+
           
            
            '</tr>';
        stt++;
      
    }
     $(".listthongke").html(html);
	console.log(msp);
	 $(".sumddh").html("Tổng số đơn đặt hàng:"+res.data.totalitem)
	buildSlidePage($(".pageddhtk"),5,res.data.page,res.data.totalpage);
}
var tkdh_current=0;
$(".pageddhtk").on('click','button',function () {
    //console.log("nha"+$(this).val());
    tkdh_current=$(this).val();
    builddsthongke($(this).val());
    msp=[];
});
