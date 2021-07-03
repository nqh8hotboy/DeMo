express = require('express');
var router = express.Router();
var core=require('./core');
var connect=require('./connect');
var path=require('path');
var fs = require('fs');

router.post('/create',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("dangkysp"), req.body);
    if (!core.allDataRequestExist(datareq, ["idsp","masp","ngaysx","hansd","listhinh"])) {
        res.send(core.nonedata());
        return;
    }

    datareq.ngaysx=new Date(parseInt(datareq.ngaysx))
    datareq.hansd=new Date(parseInt(datareq.hansd))
    datareq.masp=parseInt(datareq.masp)
    if(datareq.mancc)
    {
        datareq.mancc=parseInt(datareq.mancc)

    }
    connect.ConnectMainServer(function (connection) {
        var queryString="SELECT * FROM `dangkysp` WHERE idsp=?";
        connection.query(queryString,[datareq.idsp],function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }
            if (rows.length > 0) {
                res.send(core.exist(datareq));
            }
            else {
                var queryInsertUser = "INSERT INTO `dangkysp` SET ?";
                connection.query(queryInsertUser, datareq, function (err, result) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    datareq = core.convertDateToMilisecond(datareq);
                    res.send(core.success(datareq));
                });
            }
        })

    });
});

router.post('/update',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("dangkysp"), req.body);
    if (!core.allDataRequestExist(datareq, ["idsp"])) {
        res.send(core.nonedata());
        return;
    }
    if(datareq.manpp)
    {
        datareq.manpp=parseInt(datareq.manpp)
    }
    if(datareq.mansc)
    {
        datareq.mansc=parseInt(datareq.mansc)
    }
    if(datareq.mancc)
    {
        datareq.mancc=parseInt(datareq.mancc)
    }
    if(datareq.masp)
    {
        datareq.masp=parseInt(datareq.masp)
    }
    if(datareq.hansd)
    {
        datareq.hansd=new Date(parseInt(datareq.hansd))

    }
    if(datareq.ngaysx)
    {
        datareq.ngaysx=new Date(parseInt(datareq.ngaysx))

    }
    // datareq.lock=1;//moi dang ky tai khoang se bi khoa
    connect.ConnectMainServer(function (connection) {

        var queryUpdateUser = "UPDATE `dangkysp` SET ? where `idsp`=?";
        connection.query(queryUpdateUser, [datareq,datareq.idsp], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            datareq = core.convertDateToMilisecond(datareq);
            res.send(core.success(datareq));

        });

    });
});



router.post('/getbyncc', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

    if(!core.allDataRequestExist(datareq,["mancc"])){
        res.send(core.nonedata());
        return;
    }

    if(!datareq.maloai)
    {
        datareq.maloai="B";
    }
    datareq.mancc=parseInt(datareq.mancc)
    var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from dangkysp where mancc=? and (select maloaisp from sanpham s where s.idsp=dangkysp.masp) = ?";

        connection.query(queryCount, [datareq.mancc,datareq.maloai], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select *,checkIsPP(thongtinpp) as 'isPP',getNSC(mansc) as 'infonsc',getNCC(mancc) as 'infoncc',getNPP(manpp) as 'infonpp',getSanPham(masp) as 'infosanpham' from dangkysp where mancc=? and (select maloaisp from sanpham s where s.idsp=dangkysp.masp) = ? order by ngaysx desc limit ?, "+record;
                connection.query(queryString, [datareq.mancc,datareq.maloai,page*record], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    res.send(
                        core.success(
                            {
                                page: page,
                                totalitem: total,
                                totalpage: Math.ceil(total / record),
                                record: record,
                                items:core.convertDateToMilisecond(rows)}
                        )
                    )
                });

            }
            else
            {
                res.send(core.notexist(datareq));
            }
        })
    })
});

router.post('/getbynpp', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

    if(!core.allDataRequestExist(datareq,["manpp"])){
        res.send(core.nonedata());
        return;
    }
    if(!datareq.maloai)
    {
        datareq.maloai="B";
    }

    datareq.manpp=parseInt(datareq.manpp)
    var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from dangkysp where getIDNPPFromThongTinPP(?,thongtinpp) =? and (select maloaisp from sanpham s where s.idsp=dangkysp.masp) = ?";

        connection.query(queryCount, [datareq.manpp,datareq.manpp,datareq.maloai], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select *,checkIsPPByNPP(thongtinpp,?) as 'isPP',getNSC(mansc) as 'infonsc',getNCC(mancc) as 'infoncc',getNPP(manpp) as 'infonpp',getSanPham(masp) as 'infosanpham' from dangkysp where getIDNPPFromThongTinPP(?,thongtinpp) =? and (select maloaisp from sanpham s where s.idsp=dangkysp.masp) = ? order by ngaysx desc limit ?, "+record;
                connection.query(queryString, [datareq.manpp,datareq.manpp,datareq.manpp,datareq.maloai,page*record], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    res.send(
                        core.success(
                            {
                                page: page,
                                totalitem: total,
                                totalpage: Math.ceil(total / record),
                                record: record,
                                items:core.convertDateToMilisecond(rows)}
                        )
                    )
                    // res.send(core.success({

                    // items: rows
                    //}))
                });

            }
            else
            {
                res.send(core.notexist(datareq));
            }
        })
    })
});

router.post('/getbynsc', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

    if(!core.allDataRequestExist(datareq,["mansc"])){
        res.send(core.nonedata());
        return;
    }
    if(!datareq.maloai)
    {
        datareq.maloai="B";
    }

    datareq.mansc=parseInt(datareq.mansc)
    var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from dangkysp where mansc=? and (select maloaisp from sanpham s where s.idsp=dangkysp.masp) = ?";

        connection.query(queryCount, [datareq.mansc,datareq.maloai], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select *,checkIsPP(thongtinpp) as 'isPP',getNSC(mansc) as 'infonsc',getNCC(mancc) as 'infoncc',getNPP(manpp) as 'infonpp',getSanPham(masp) as 'infosanpham' from dangkysp where mansc=? and (select maloaisp from sanpham s where s.idsp=dangkysp.masp) = ? order by ngaysx desc limit ?, "+record;
                connection.query(queryString, [datareq.mansc,datareq.maloai,page*record], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    res.send(
                        core.success(
                            {
                                page: page,
                                totalitem: total,
                                totalpage: Math.ceil(total / record),
                                record: record,
                                items:core.convertDateToMilisecond(rows)}
                        )
                    )

                });

            }
            else
            {
                res.send(core.notexist(datareq));
            }
        })
    })
});


router.post('/getbyadmin', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

    if(!datareq.maloai)
    {
        datareq.maloai="B";
    }

    datareq.mansc=parseInt(datareq.mansc)
    var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from dangkysp where (select maloaisp from sanpham s where s.idsp=dangkysp.masp) = ?";

        connection.query(queryCount, [datareq.maloai], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select *,checkIsPP(thongtinpp) as 'isPP',getNSC(mansc) as 'infonsc',getNCC(mancc) as 'infoncc',getNPP(manpp) as 'infonpp',getSanPham(masp) as 'infosanpham' from dangkysp where (select maloaisp from sanpham s where s.idsp=dangkysp.masp) = ? order by ngaysx desc limit ?, "+record;
                connection.query(queryString, [datareq.maloai,page*record], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    res.send(
                        core.success(
                            {
                                page: page,
                                totalitem: total,
                                totalpage: Math.ceil(total / record),
                                record: record,
                                items:core.convertDateToMilisecond(rows)}
                        )
                    )

                });

            }
            else
            {
                res.send(core.notexist(datareq));
            }
        })
    })
});
router.post('/getbyadminweb', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

    if(!datareq.maloai)
    {
        datareq.maloai="B";
    }
 var charsearch="%%";
    if(datareq.charsearch){
        charsearch="%"+datareq.charsearch+"%";
    }
    datareq.mansc=parseInt(datareq.mansc)
    var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from dangkysp where (select maloaisp from sanpham s where s.idsp=dangkysp.masp) = ? and (dangkysp.idsp like ?)";

        connection.query(queryCount, [datareq.maloai,charsearch], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select *,checkIsPP(thongtinpp) as 'isPP',getNSC(mansc) as 'infonsc',getNCC(mancc) as 'infoncc',getNPP(manpp) as 'infonpp',getSanPham(masp) as 'infosanpham' from dangkysp where (select maloaisp from sanpham s where s.idsp=dangkysp.masp) = ? and (dangkysp.idsp like ?) order by createdate desc limit ?, "+record;
                connection.query(queryString, [datareq.maloai,charsearch,page*record], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    res.send(
                        core.success(
                            {
                                page: page,
                                totalitem: total,
                                totalpage: Math.ceil(total / record),
                                record: record,
                                items:core.convertDateToMilisecond(rows)}
                        )
                    )

                });

            }
            else
            {
                res.send(core.notexist(datareq));
            }
        })
    })
});
router.post('/delete',function (req, res) {
    var datareq = req.body;
  
    connect.ConnectMainServer(function (connection) {
        
                var insertschedule = "delete  from `dangkysp` where idsp=?";
                connection.query(insertschedule, [datareq.idsp], function (err, result) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
					
				
                    
                    res.send(core.success());

               
                    

                });
          
	});
    
});
//xóa link image
router.post('/removellink',function (req, res) {
   var datareq = req.body;
  
   var pathfilename='./public/'+datareq.urllink;
			
	
		fs.stat(pathfilename, function (err, stats) {
 //  console.log("thu"+stats);//here we got all information of file in stats variable

   if (err) {
       res.send(core.fail());
   }

   fs.unlink(pathfilename,function(err){
        if(err) return console.log(err);
        res.send(core.success());
   });  
});
});
router.post('/updatenhapp',function (req, res) {
  // datareq.lock=1;//moi dang ky tai khoang se bi khoa
   var datareq = req.body;
    connect.ConnectMainServer(function (connection) {

        var queryUpdateUser = "UPDATE `dangkysp` SET thongtinpp=? where `idsp`=?";
        connection.query(queryUpdateUser, [datareq.thongtinpp,datareq.idsp], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            datareq = core.convertDateToMilisecond(datareq);
            res.send(core.success(datareq));

        });

    });
});

router.post('/updatedangkyspbyidsp',function (req, res) {
  // datareq.lock=1;//moi dang ky tai khoang se bi khoa
   var datareq = req.body;
    connect.ConnectMainServer(function (connection) {

        var queryUpdateUser = "UPDATE `dangkysp` SET listhinh=? where `idsp`=?";
        connection.query(queryUpdateUser, [datareq.listhinh,datareq.idsp], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            datareq = core.convertDateToMilisecond(datareq);
            res.send(core.success(datareq));

        });

    });
});
router.post('/updatedetailwork_batch',function (req, res) {
  // datareq.lock=1;//moi dang ky tai khoang se bi khoa
   var datareq = req.body;
    connect.ConnectMainServer(function (connection) {

        var queryUpdateUser = "UPDATE `detailwork_batch` SET listimg=? where `idwork`=?";
        connection.query(queryUpdateUser, [datareq.listhinh,datareq.idwork], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            datareq = core.convertDateToMilisecond(datareq);
            res.send(core.success(datareq));

        });

    });
});
//lay thong tin san pham truy suất nguon goc
router.post('/getbyid', function(req, res) {
    var datareq = req.body;
    if(!core.allDataRequestExist(datareq,["idsp"])){
        res.send(core.nonedata());
        return;
    }
				

				connect.ConnectMainServer(function (connection) {
				 var queryCount="";

					queryCount = "Select count(*) as 'total' from dangkysp where idsp = ?";

					connection.query(queryCount, [datareq.idsp], function (err, rows) {
					if (err) {
					res.send(core.error(err.message));
				
					return;
					}

					var total = rows[0].total;
					if (total > 0) {


						var queryString = "Select *,checkIsPP(thongtinpp) as 'isPP',getNSC(mansc) as 'infonsc',getNCC(mancc) as 'infoncc',getNPP(manpp) as 'infonpp',getSanPham(masp) as 'infosanpham' from dangkysp where idsp=?";
						connection.query(queryString, [datareq.idsp], function (err, rows) {
						if (err) {
							res.send(core.error(err.message));
                      //  console.log(err);
							return;
						}
						res.send(
							core.success(
                            {
								
                                items:core.convertDateToMilisecond(rows)
							}
                        )
						)
						});
					}else{
						res.send(core.nonedata());//1004
					}						

            })
    })
});

//////////////////////////////////////////////////////////////////////////////////danh sach cong viec
router.post('/getallwork', function(req, res) {
    var datareq = req.body;
   

				connect.ConnectMainServer(function (connection) {
				


						var queryString = "Select  * from workfarmer";
						connection.query(queryString, [], function (err, rows) {
						if (err) {
							res.send(core.error(err.message));
                      //  console.log(err);
							return;
						}
						res.send(
							core.success(
                            {
								
                                items:core.convertDateToMilisecond(rows)
							}
                        )
						)
						});
					
    })
});
router.post('/creatework',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("detailworkfarmer"), req.body);
   

    datareq.createdate=new Date(parseInt(datareq.createdate))
   
   
    connect.ConnectMainServer(function (connection) {
        
                var queryInsertUser = "INSERT INTO `detailwork_batch` SET ?";
                connection.query(queryInsertUser, datareq, function (err, result) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    datareq = core.convertDateToMilisecond(datareq);
                    res.send(core.success(datareq));
                });
        

    });
});
router.post('/getallqrcode', function(req, res) {
    var datareq = req.body;
   

				connect.ConnectMainServer(function (connection) {
				


						var queryString = "Select dk.*,s.tensp from dangkysp dk,sanpham s where s.idsp=dk.masp and  dk.iduser=? and  dk.expire=0";
						connection.query(queryString, [datareq.iduser], function (err, rows) {
						if (err) {
							res.send(core.error(err.message));
                      //  console.log(err);
							return;
						}
						res.send(
							core.success(
                            {
								
                                items:core.convertDateToMilisecond(rows)
							}
                        )
						)
						});
					
    })
});
router.post('/getdetailwork', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

   
 
    var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from detailwork_batch where qrcode=? and idwork=?";

        connection.query(queryCount, [datareq.qrcode,datareq.idwork], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from detailwork_batch where qrcode=? and idwork=? order by createdate desc limit ?, "+record;
                connection.query(queryString, [datareq.qrcode,datareq.idwork,page*record], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    res.send(
                        core.success(
                            {
                                page: page,
                                totalitem: total,
                                totalpage: Math.ceil(total / record),
                                record: record,
                                items:core.convertDateToMilisecond(rows)}
                        )
                    )

                });

            }
            else
            {
                res.send(core.notexist(datareq));
            }
        })
    })
});
module.exports = router;
