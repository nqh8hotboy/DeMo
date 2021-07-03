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
    if(datareq.mancc=="")
    {
        datareq.mancc=0

    }
	if(datareq.manvc=="")
    {
        datareq.manvc=0;

    }
	if(datareq.mansc=="")
    {
        datareq.mansc=0;

    }
    connect.ConnectMainServer(function (connection) {
        var queryString="SELECT * FROM `dangkysp` WHERE idsp=?";
        connection.query(queryString,[datareq.idsp],function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
               // console.log(err);
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
                    //    console.log(err);
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
                //console.log(err);
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
               // console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select *,checkIsPP(thongtinpp) as 'isPP',getNSC(mansc) as 'infonsc',getNCC(mancc) as 'infoncc',getNPP(manpp) as 'infonpp',getSanPham(masp) as 'infosanpham' from dangkysp where mancc=? and (select maloaisp from sanpham s where s.idsp=dangkysp.masp) = ? order by ngaysx desc limit ?, "+record;
                connection.query(queryString, [datareq.mancc,datareq.maloai,page*record], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                        //console.log(err);
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
            //    console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select *,checkIsPPByNPP(thongtinpp,?) as 'isPP',getNSC(mansc) as 'infonsc',getNCC(mancc) as 'infoncc',getNPP(manpp) as 'infonpp',getSanPham(masp) as 'infosanpham' from dangkysp where getIDNPPFromThongTinPP(?,thongtinpp) =? and (select maloaisp from sanpham s where s.idsp=dangkysp.masp) = ? order by ngaysx desc limit ?, "+record;
                connection.query(queryString, [datareq.manpp,datareq.manpp,datareq.manpp,datareq.maloai,page*record], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                        //console.log(err);
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
               // console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select *,checkIsPP(thongtinpp) as 'isPP',getNSC(mansc) as 'infonsc',getNCC(mancc) as 'infoncc',getNPP(manpp) as 'infonpp',getSanPham(masp) as 'infosanpham' from dangkysp where mansc=? and (select maloaisp from sanpham s where s.idsp=dangkysp.masp) = ? order by ngaysx desc limit ?, "+record;
                connection.query(queryString, [datareq.mansc,datareq.maloai,page*record], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                        //console.log(err);
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
               // console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select *,checkIsPP(thongtinpp) as 'isPP',getNSC(mansc) as 'infonsc',getNCC(mancc) as 'infoncc',getNPP(manpp) as 'infonpp',getSanPham(masp) as 'infosanpham' from dangkysp where (select maloaisp from sanpham s where s.idsp=dangkysp.masp) = ? order by ngaysx desc limit ?, "+record;
                connection.query(queryString, [datareq.maloai,page*record], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                      //  console.log(err);
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

        queryCount = "Select count(*) as 'total' from dangkysp where expire=? and (select maloaisp from sanpham s where  s.idsp=dangkysp.masp) = ? and (dangkysp.idsp like ?)";

        connection.query(queryCount, [datareq.expire,datareq.maloai,charsearch], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
              //  console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select *,checkIsPP(thongtinpp) as 'isPP',getNSC(mansc) as 'infonsc',getNCC(mancc) as 'infoncc',getNVC(manvc) as 'infonvc',getNPP(manpp) as 'infonpp',getSanPham(masp) as 'infosanpham' from dangkysp where expire=? and (select maloaisp from sanpham s where s.idsp=dangkysp.masp) = ? and (dangkysp.idsp like ?) order by createdate desc limit ?, "+record;
                connection.query(queryString, [datareq.expire,datareq.maloai,charsearch,page*record], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                     //   console.log(err);
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
                        //console.log(err);
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
               // console.log(err);
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
   datareq.createdate=new Date(parseInt(datareq.createdate))
    connect.ConnectMainServer(function (connection) {

        var queryUpdateUser = "UPDATE `detailwork_batch` SET listimg=?,createdate=? where id=?";
        connection.query(queryUpdateUser, [datareq.listhinh,datareq.createdate,datareq.id], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
               // console.log(err);
                return;
            }
			
					if(result.affectedRows>0){
					datareq = core.convertDateToMilisecond(datareq);
					res.send(core.success(datareq));
					}else{ //1001
					res.send(core.fail(datareq));
					}


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

					queryCount = "Select count(*) as 'total' from dangkysp where idsp = ? and expire=0";

					connection.query(queryCount, [datareq.idsp], function (err, rows) {
					if (err) {
					res.send(core.error(err.message));
				
					return;
					}

					var total = rows[0].total;
					if (total > 0) {


						var queryString = "Select *,checkIsPP(thongtinpp) as 'isPP',getNSC(mansc) as 'infonsc',getNCC(mancc) as 'infoncc',getNVC(manvc) as 'infonvc',getNPP(manpp) as 'infonpp',getSanPham(masp) as 'infosanpham' from dangkysp where idsp=? and expire=0";
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
				


						var queryString = "Select  * from workfarmer where visible=1 order by idw asc";
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
                       // console.log(err);
                        return;
                    }
					
                  //  datareq = core.convertDateToMilisecond(result.insertId);
                    res.send(core.success(result.insertId));
                });
        

    });
});
router.post('/getallqrcode', function(req, res) {
    var datareq = req.body;
   

				connect.ConnectMainServer(function (connection) {
				


						var queryString = "Select dk.*,s.tensp from dangkysp dk,sanpham s, users u where (u.permission=0 or u.permission=1) and  u.iduser=dk.iduser and s.idsp=dk.masp and  dk.iduser=? and  dk.expire=0 ";
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
   

   
   var id=parseInt(datareq.id);
    

    connect.ConnectMainServer(function (connection) {
      

                var queryString = "Select * from detailwork_batch where id=? order by createdate desc";
                connection.query(queryString, [id], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                      //  console.log(err);
                        return;
                    }
                    res.send(
                        core.success(
                            {
                               
                                items:core.convertDateToMilisecond(rows)}
                        )
                    )

                });

           
    })
});
router.post('/getdetailworkidw', function(req, res) {
    var datareq = req.body;
   

   
  // var id=parseInt(datareq.idw);
    

    connect.ConnectMainServer(function (connection) {
      

                var queryString = "Select * from detailwork_batch where idwork=? and qrcode=? order by createdate desc";
                connection.query(queryString, [datareq.idw,datareq.qrcode], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                       // console.log(err);
                        return;
                    }
                    res.send(
                        core.success(
                            {
                               
                                items:core.convertDateToMilisecond(rows)}
                        )
                    )

                });

           
    })
});
router.post('/updateexpire',function (req, res) {
  // datareq.lock=1;//moi dang ky tai khoang se bi khoa
   var datareq = req.body;
    connect.ConnectMainServer(function (connection) {

        var queryUpdateUser = "UPDATE `dangkysp` SET expire=? where `idsp`=?";
        connection.query(queryUpdateUser, [datareq.expire,datareq.idsp], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
               // console.log(err);
                return;
            }

            datareq = core.convertDateToMilisecond(datareq);
            res.send(core.success(datareq));

        });

    });
});
//update khi quet ma cho nha so che
router.post('/updatesc',function (req, res) {
 
   var datareq = req.body;
    connect.ConnectMainServer(function (connection) {
		var queryseUser = "select * from users s, nhasoche sc where s.iduser=sc.user and s.iduser=?";
        connection.query(queryseUser, [datareq.iduser], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
               // console.log(err);
                return;
            }
			if (result.length > 0) {
				var mansc=result[0].mansc;
				//
			//	console.log("mansc"+mansc);
				var queryseupdate = "select * from dangkysp where idsp=? and mansc=?";
				connection.query(queryseupdate, [datareq.idsp,mansc], function (err, results) {
				if (err) {
                res.send(core.error(err.message));
             //   console.log(err);
                return;
				}
				
				if (results.length == 0) {
					//var mansc=results[0].mansc;
					var queryUpdateUser = "UPDATE `dangkysp` SET mansc=? where `idsp`=? and expire=0";
					connection.query(queryUpdateUser, [mansc,datareq.idsp], function (err, result) {
					if (err) {
					res.send(core.error(err.message));
				//	console.log(err);
					return;
					}
					if(result.affectedRows>0){
					datareq = core.convertDateToMilisecond(datareq);
					res.send(core.success(datareq));
					}else{ //1001
					res.send(core.fail(datareq));
					}

					});
				}else{ //1002
					res.send(core.exist(datareq));
				}
				//
				});	
				
			}else{//1003
				//iduser nay chua ton tai
				res.send(core.notexist(datareq));
			}
		});
        

    });
});
//update khi quet ma cho nha phan phoi
router.post('/updatepp',function (req, res) {
 
   var datareq = req.body;
    connect.ConnectMainServer(function (connection) {
		var queryseUser = "select * from users s, nhapp sc where s.iduser=sc.user and s.iduser=?";
        connection.query(queryseUser, [datareq.iduser], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                //console.log(err);
                return;
            }
			if (result.length > 0) {
				var manpp=result[0].manpp;
				//
				var queryseupdate = "select * from dangkysp where idsp=? and manpp=?";
				connection.query(queryseupdate, [datareq.idsp,manpp], function (err, results) {
				if (err) {
                res.send(core.error(err.message));
              //  console.log(err);
                return;
				}
				
				if (results.length == 0) {
					//var manpp=results[0].manpp;
					var queryUpdateUser = "UPDATE `dangkysp` SET manpp=? where `idsp`=? and expire=0";
					connection.query(queryUpdateUser, [manpp,datareq.idsp], function (err, result) {
					if (err) {
					res.send(core.error(err.message));
					//console.log(err);
					return;
					}
					if(result.affectedRows>0){
					datareq = core.convertDateToMilisecond(datareq);
					res.send(core.success(datareq));
					}else{ //1001
					res.send(core.fail(datareq));
					}

					});
				}else{ //1002
					res.send(core.exist(datareq));
				}
				//
				});	
				
			}else{//1003
				//iduser nay chua ton tai
				res.send(core.notexist(datareq));
			}
		});
        

    });
});
//update khi quet ma cho nha phan phoi
router.post('/updatevc',function (req, res) {
 
   var datareq = req.body;
    connect.ConnectMainServer(function (connection) {
		var queryseUser = "select * from users s, nhavc sc where s.iduser=sc.user and s.iduser=?";
        connection.query(queryseUser, [datareq.iduser], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
               // console.log(err);
                return;
            }
			if (result.length > 0) {
				var manvc=result[0].manvc;
				//
				var queryseupdate = "select * from dangkysp where idsp=? and manvc=?";
				connection.query(queryseupdate, [datareq.idsp,manvc], function (err, results) {
				if (err) {
                res.send(core.error(err.message));
                //console.log(err);
                return;
				}
					
				if (results.length == 0) {
					//var manvc=results[0].manvc;
					var queryUpdateUser = "UPDATE `dangkysp` SET manvc=? where `idsp`=? and expire=0";
					connection.query(queryUpdateUser, [manvc,datareq.idsp], function (err, result) {
					if (err) {
					res.send(core.error(err.message));
				//	console.log(err);
					return;
					}
					if(result.affectedRows>0){
					datareq = core.convertDateToMilisecond(datareq);
					res.send(core.success(datareq));
					}else{ //1001
					res.send(core.fail(datareq));
					}

					});
				}else{ //1002
					res.send(core.exist(datareq));
				}
				//
				});	
				
			}else{//1003
				//iduser nay chua ton tai
				res.send(core.notexist(datareq));
			}
		});
        

    });
});
//update khi quet ma cho nha phan phoi
router.post('/updatend',function (req, res) {
 
   var datareq = req.body;
    connect.ConnectMainServer(function (connection) {
		var queryseUser = "select * from users s, nhacungcap sc where s.iduser=sc.user and s.iduser=?";
        connection.query(queryseUser, [datareq.iduser], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
             //   console.log(err);
                return;
            }
			if (result.length > 0) {
				var mancc=result[0].mancc;
				//
				var queryseupdate = "select * from dangkysp where idsp=? and mancc=?";
				connection.query(queryseupdate, [datareq.idsp,mancc], function (err, results) {
				if (err) {
                res.send(core.error(err.message));
               // console.log(err);
                return;
				}
					
				if (results.length == 0) {
					//var manvc=results[0].manvc;
					var queryUpdateUser = "UPDATE `dangkysp` SET mancc=? where `idsp`=? and expire=0";
					connection.query(queryUpdateUser, [mancc,datareq.idsp], function (err, result) {
					if (err) {
					res.send(core.error(err.message));
					//console.log(err);
					return;
					}
					if(result.affectedRows>0){
					datareq = core.convertDateToMilisecond(datareq);
					res.send(core.success(datareq));
					}else{ //1001
					res.send(core.fail(datareq));
					}

					});
				}else{ //1002
					res.send(core.exist(datareq));
				}
				//
				});	
				
			}else{//1003
				//iduser nay chua ton tai
				res.send(core.notexist(datareq));
			}
		});
        

    });
});
//get history user
router.post('/gethistory', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

   

   
    var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from historyuser";

        connection.query(queryCount, [], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                //console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from historyuser order by create_date desc limit ?, "+record;
                connection.query(queryString, [page*record], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                      //  console.log(err);
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
router.post('/createhistory',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("historyuser"), req.body);
    
    datareq.create_date=new Date(parseInt(datareq.create_date))
  
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "INSERT INTO `historyuser` SET ?";
                connection.query(queryInsertUser, datareq, function (err, result) {
                    if (err) {
                        res.send(core.error(err.message));
                        //console.log(err);
                        return;
                    }
                    datareq = core.convertDateToMilisecond(datareq);
                    res.send(core.success(datareq));
                });
       
    });
});
router.post('/deletehistory',function (req, res) {
    var datareq =  req.body;
    
    
  
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "delete from `historyuser` where  id=?";
                connection.query(queryInsertUser, [datareq.id], function (err, result) {
                    if (err) {
                        res.send(core.error(err.message));
                        //console.log(err);
                        return;
                    }
                   if(result.affectedRows>0)
				   {
					  
					   res.send(core.success());
				   }else
				   {
					   res.send(core.fail(datareq));
				   }

				});
               
       
    });
});
router.post('/getallworks', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

   
   
    var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from detailwork_batch d,workfarmer w where d.idwork=w.idw and  d.idwork=? and d.qrcode=? ";

        connection.query(queryCount, [datareq.idwork,datareq.qrcode], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
               // console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from detailwork_batch d,workfarmer w where d.idwork=w.idw and  d.idwork=? and d.qrcode=? order by createdate desc limit ?, "+record;
                connection.query(queryString, [datareq.idwork,datareq.qrcode,page*record], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                       // console.log(err);
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
router.post('/deletedetailwork',function (req, res) {
    var datareq = req.body;
  
    connect.ConnectMainServer(function (connection) {
        
                var insertschedule = "delete  from `detailwork_batch` where id=?";
                connection.query(insertschedule, [datareq.id], function (err, result) {
                    if (err) {
                        res.send(core.error(err.message));
                   //     console.log(err);
                        return;
                    }
					
				  if(result.affectedRows>0)
				   {
					    res.send(core.success());
				   }else
				   {
					    res.send(core.fail());
				   }
                   

               
                    

                });
          
	});
    
});
/////////////////////////////update nhieu nha so che 
router.post('/updateallsc',function (req, res) {
  var datareq = req.body;
   
    datareq.datetimejoin=new Date(parseInt(datareq.datetimejoin))
    connect.ConnectMainServer(function (connection) {
		var queryseUser = "select * from users s, nhasoche sc where s.iduser=sc.user and s.iduser=?";
        connection.query(queryseUser, [datareq.iduser], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
             //   console.log(err);
                return;
            }
			if (result.length > 0) {
				var mansc=result[0].mansc;
				//
				//console.log("mansc"+mansc);
				datareq.mansc=mansc;
				var queryseupdate = "select * from joinsanpham_nhasoche where idsp=? and mansc=?";
				connection.query(queryseupdate, [datareq.idsp,mansc], function (err, results) {
				if (err) {
                res.send(core.error(err.message));
                //console.log(err);
                return;
				}
				
				if (results.length == 0) {
					//var mansc=results[0].mansc;
					var queryUpdateUser = "INSERT INTO joinsanpham_nhasoche(idsp,mansc,datetimejoin) values(?,?,?)";
					connection.query(queryUpdateUser, [datareq.idsp,datareq.mansc,datareq.datetimejoin], function (err, result) {
					if (err) {
					res.send(core.error(err.message));
				//	console.log(err);
					return;
					}
					if(result.affectedRows>0){
					datareq = core.convertDateToMilisecond(datareq);
					res.send(core.success(datareq));
					}else{ //1001
					res.send(core.fail(datareq));
					}

					});
				}else{ //1002
					res.send(core.exist(datareq));
				}
				//
				});	
				
			}else{//1003
				//iduser nay chua ton tai
				res.send(core.notexist(datareq));
			}
		});
        

    });
});
router.post('/checkuservc',function (req, res) {
  var datareq =req.body;
   
   
    connect.ConnectMainServer(function (connection) {
		var queryseUser = "select * from users s, nhavc sc where s.iduser=sc.user and s.iduser=?";
        connection.query(queryseUser, [datareq.iduser], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                //console.log(err);
                return;
            }
			if (result.length > 0) {
				var manvc=result[0].manvc;
				datareq.manvc=manvc;
			//	console.log("mansc"+manvc+"isdp"+datareq.idsp);
				var queryseupdate = "select * from  joinsanpham_nhavc where (idsp=? and manvc=?)";
				connection.query(queryseupdate, [datareq.idsp,datareq.manvc], function (err, results) {
				if (err) {
                res.send(core.error(err.message));
             //   console.log(err);
                return;
				}
				
				if (results.length == 0) {
					res.send(core.nonedata(datareq));
				}else{ //1002
					res.send(core.exist(datareq));
				}
				//
				});	
				
			}else{//1003
				//iduser nay chua ton tai
				res.send(core.notexist(datareq));
			}
		});
        

    });
});
router.post('/updateallvc',function (req, res) {
  var datareq =req.body;
   
    datareq.datetimejoin=new Date(parseInt(datareq.datetimejoin))
    connect.ConnectMainServer(function (connection) {
		var queryseUser = "select * from users s, nhavc sc where s.iduser=sc.user and s.iduser=?";
        connection.query(queryseUser, [datareq.iduser], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                //console.log(err);
                return;
            }
			if (result.length > 0) {
				var manvc=result[0].manvc;
				datareq.manvc=manvc;
			//	console.log("mansc"+manvc+"isdp"+datareq.idsp);
				var queryseupdate = "select * from  joinsanpham_nhavc where (idsp=? and manvc=?)";
				connection.query(queryseupdate, [datareq.idsp,datareq.manvc], function (err, results) {
				if (err) {
                res.send(core.error(err.message));
             //   console.log(err);
                return;
				}
				
				if (results.length == 0) {
					//var mansc=results[0].mansc;
					var queryUpdateUser = "INSERT INTO joinsanpham_nhavc(idsp,manvc,datetimejoin,nametx,phonetx,biensopt) values(?,?,?,?,?,?)";
					connection.query(queryUpdateUser,[datareq.idsp,datareq.manvc,datareq.datetimejoin,datareq.nametx,datareq.phonetx,datareq.biensopt], function (err, result) {
					if (err) {
					res.send(core.error(err.message));
					//console.log(err);
					return;
					}
					if(result.affectedRows>0){
					datareq = core.convertDateToMilisecond(datareq);
					res.send(core.success(datareq));
					}else{ //1001
					res.send(core.fail(datareq));
					}

					});
				}else{ //1002
					res.send(core.exist(datareq));
				}
				//
				});	
				
			}else{//1003
				//iduser nay chua ton tai
				res.send(core.notexist(datareq));
			}
		});
        

    });
});
router.post('/updateallpp',function (req, res) {
  var datareq =  req.body;
   
    datareq.datetimejoin=new Date(parseInt(datareq.datetimejoin))
    connect.ConnectMainServer(function (connection) {
		var queryseUser = "select * from users s, nhapp sc where s.iduser=sc.user and s.iduser=?";
        connection.query(queryseUser, [datareq.iduser], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
               // console.log(err);
                return;
            }
			if (result.length > 0) {
				var manpp=result[0].manpp;
				datareq.manpp=manpp;
				//
				//console.log("mansc"+mansc);
				var queryseupdate = "select * from  joinsanpham_nhapp where idsp=? and manpp=?";
				connection.query(queryseupdate, [datareq.idsp,manpp], function (err, results) {
				if (err) {
                res.send(core.error(err.message));
               // console.log(err);
                return;
				}
				
				if (results.length == 0) {
					//var mansc=results[0].mansc;
					var queryUpdateUser = "INSERT INTO joinsanpham_nhapp(idsp,manpp,datetimejoin) values(?,?,?)";
					connection.query(queryUpdateUser,[datareq.idsp,datareq.manpp,datareq.datetimejoin], function (err, result) {
					if (err) {
					res.send(core.error(err.message));
				//	console.log(err);
					return;
					}
					if(result.affectedRows>0){
					datareq = core.convertDateToMilisecond(datareq);
					res.send(core.success(datareq));
					}else{ //1001
					res.send(core.fail(datareq));
					}

					});
				}else{ //1002
					res.send(core.exist(datareq));
				}
				//
				});	
				
			}else{//1003
				//iduser nay chua ton tai
				res.send(core.notexist(datareq));
			}
		});
        

    });
});
router.post('/getallsochejoin', function(req, res) {
    var datareq = req.body;
  
				

				connect.ConnectMainServer(function (connection) {
				 

						var queryString = "Select * from  joinsanpham_nhasoche j, nhasoche s where s.mansc=j.mansc and j.idsp=?";
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
										

            
    })
});
router.post('/getallvanchuyenjoin', function(req, res) {
    var datareq = req.body;
  
				

				connect.ConnectMainServer(function (connection) {
				 

						var queryString = "Select * from  joinsanpham_nhavc j, nhavc s where s.manvc=j.manvc and j.idsp=?";
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
										

            
    })
});
router.post('/getallphanphoijoin', function(req, res) {
    var datareq = req.body;
  
				

				connect.ConnectMainServer(function (connection) {
				 

						var queryString = "Select * from  joinsanpham_nhapp j, nhapp s where s.manpp=j.manpp and j.idsp=?";
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
										

            
    })
});
module.exports = router;
