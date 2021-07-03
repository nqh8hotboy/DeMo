express = require('express');
var router = express.Router();
var core=require('./core');
var connect=require('./connect');
var apn = require('apn');

//var connect2=require('./connect2');
var SHA256 = require("crypto-js/sha256");

router.post('/getallspvinatt', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

   
   
     var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from loaisp lsp,sanpham s where s.visible=1 and lsp.maloai=s.maloaisp ";

        connection.query(queryCount, [], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from loaisp lsp,sanpham s where s.visible=1 and lsp.maloai=s.maloaisp  LIMIT ?,"+record;
                connection.query(queryString, [page*record], function (err, rows) {
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
router.post('/udpatespvisible',function (req, res) {
    var datareq = req.body;
   
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "update `sanpham` SET visible=? where idsp=? ";
                connection.query(queryInsertUser, [datareq.visible,datareq.idsp], function (err, result) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
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
router.post('/getallspvinattbymaloai', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }
var charsearch="%%";
    if(datareq.charsearch){
        charsearch="%"+datareq.charsearch+"%";
    }

   
   
     var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from loaisp lsp,sanpham s where lsp.maloai=s.maloaisp and s.maloaisp = ? and (s.masp like ? or s.tensp like ? or s.tensp_en like ?)";

        connection.query(queryCount, [datareq.maloaisp,charsearch,charsearch,charsearch], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from loaisp lsp,sanpham s where lsp.maloai=s.maloaisp  and s.maloaisp = ? and ( s.masp like ? or s.tensp like ? or s.tensp_en like ?)  LIMIT ?,"+record;
                connection.query(queryString, [datareq.maloaisp,charsearch,charsearch,charsearch,page*record], function (err, rows) {
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

router.post('/getallspvinattspecial', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

   
   
     var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from loaisp lsp,sanpham s where lsp.maloai=s.maloaisp and s.ispecial=1 ";

        connection.query(queryCount, [], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from loaisp lsp,sanpham s where lsp.maloai=s.maloaisp and s.ispecial=1  LIMIT ?,"+record;
                connection.query(queryString, [page*record], function (err, rows) {
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
//////////////////////////////
router.post('/create',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("sanpham"), req.body);
    

    // datareq.lock=1;//moi dang ky tai khoang se bi khoa
    connect.ConnectMainServer(function (connection) {
        var queryString="SELECT * FROM `sanpham` WHERE masp=? and maloaisp=?";
        connection.query(queryString,[datareq.masp,datareq.maloaisp],function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }
            if (rows.length > 0) {
                res.send(core.exist(datareq));
            }
            else {
                var queryInsertUser = "INSERT INTO `sanpham` SET ?";
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


router.post('/updatesanpham',function (req, res) {
    var datareq = req.body;

    var sp=core.fetchFieldsIfExist(core.getfield("sanpham"),datareq);

    var idsp=datareq.idsp;
    
    connect.ConnectMainServer(function (connection) {
        var insertschedule="update `sanpham` set ? where idsp=?";
        connection.query(insertschedule,[sp,idsp],function (err, result) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            res.send(core.success(sp));

        });
    })
});
router.post('/deletesanpham',function (req, res) {
    var datareq = req.body;
    //var cv=core.fetchFieldsIfExist(core.getfield("chucvu"),datareq);
    connect.ConnectMainServer(function (connection) {
 var queryString = "Select * from dangkysp where masp=?";
                connection.query(queryString,[datareq.masp], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
					if(rows.length>0)
					{
						res.send(core.exist());//1002
					}else{
				var insertschedule = "delete  from `sanpham` where idsp=?";
					connection.query(insertschedule, [datareq.idsp], function (err, result) {
					if (err) {
					res.send(core.error(err.message));
					console.log(err);
					return;
					}
					
					 if(result.affectedRows>0)
				   {
					  
					   res.send(core.success());
				   }else
				   {
					   res.send(core.fail(datareq));//1001
				   }

					});
					}
 });
    });
});
router.post('/getdvt', function(req, res) {
    var datareq = req.body;
    

    connect.ConnectMainServer(function (connection) {
       
                var queryString = "Select * from donvitinh";
                connection.query(queryString,[], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    res.send(
                        core.success(
                            {
                                
                               
                                items:core.convertDateToMilisecond(rows)}
                        )
                    )
                   
                });

	});
       
});
router.post('/createDDH',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("ddh"), req.body);
    datareq.ngaydat=new Date(parseInt(datareq.ngaydat));
    datareq.ngaygiao=new Date(parseInt(datareq.ngaygiao));
   datareq.datetimegiaokhach=new Date(parseInt(datareq.datetimegiaokhach));

    // datareq.lock=1;//moi dang ky tai khoang se bi khoa
    connect.ConnectMainServer(function (connection) {
                var queryInsertUser = "INSERT INTO `ddh` SET ?";
                connection.query(queryInsertUser, datareq, function (err, result) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    datareq = core.convertDateToMilisecond(datareq);
                    var queryString = "SELECT ddh.* from ddh order by ngaydat desc limit 0,1";
                    connection.query(queryString, [], function (err, rows) {
                        if (err) {
                            console.log(err);
                            return;
                        }
                        getIdAdmin(function (response) {

                            var datapush = {
                                content: JSON.stringify(core.convertDateToMilisecond(rows[0])),
                                key: "onneworder",
                                receiver: JSON.stringify(response)
                            }
                            var queryInsertPush = "INSERT INTO `pushnotification` SET ?";
                            connection.query(queryInsertPush, datapush, function (err, result) {
                                if (err) {
                                    console.log(err);
                                    return;
                                }
                                datapush.id=result.insertId;

                                for (var i in response) {
                                    req.io.to(core.openMyRoom(response[i].iduser)).emit("onnewmessage",  core.convertDateToMilisecond(datapush));
                                    getKeyIOS(response[i].iduser,function (resp) {
                                        var respo=JSON.parse(resp.keyios);
                                        for(var j in respo)
                                        {
                                            console.log(respo[j])

                                            pushNotificationIOS(datapush,"Có đơn đặt hàng mới",respo[j],req)
                                        }
                                    })
                                }

                                res.send(core.success({items: core.convertDateToMilisecond(rows)}))

                            });
                        })
                    });
                })
           

    });
});

function pushNotificationIOS(content,message,id,req) {
    var note = new apn.Notification();

    note.expiry = Math.floor(Date.now() / 1000) + (3600*24); // Expires 1 hour from now.
    note.badge = 1;
    note.sound = "ping.aiff";
    note.alert =message;
    note.payload = content;
    note.topic = "vn.viennha.nssvl";

    req.apnProvider.send(note, id).then(
    );

    req.apnProvider.shutdown();
}

function getIdAdmin(callback) {
    connect.ConnectMainServer(function (connection) {
        var queryString = "Select `iduser`,permission as 'issend' from users where permission =0";
        connection.query(queryString, [], function (err, rows) {
            callback(rows);
        });
    })
}

function getKeyIOS(iduser,callback) {
    connect.ConnectMainServer(function (connection) {
        var queryString = "Select `keyios` from users where iduser =?";
        connection.query(queryString, [iduser], function (err, rows) {
            callback(rows[0]);
        });
    })
}


router.post('/getddh', function(req, res) {
    var datareq = req.body;
    if (!core.allDataRequestExist(datareq, ["page"])) {
        res.send(core.nonedata());
        return;
    }
    var page = parseInt(datareq.page);
    var record = datareq.record;
    if (record === undefined) {
        record = 10;
    }

    

    connect.ConnectMainServer(function (connection) {
       
         var queryCount = "Select * from ddh where iduserkh=? order by ngaydat desc"; 


        connection.query(queryCount, [datareq.iduser], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }
            var total = rows.length;
            if (total > 0) {
                var queryString = "Select * from ddh where iduserkh=? order by ngaydat desc LIMIT ?,"+record;
                connection.query(queryString,[datareq.iduser,page*record], function (err, rows) {
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
			}else{
				  res.send(core.notexist());
			}

	});
	});
});
router.post('/getddhadmin', function(req, res) {
    var datareq = req.body;
    if (!core.allDataRequestExist(datareq, ["page"])) {
        res.send(core.nonedata());
        return;
    }
    var page = parseInt(datareq.page);
    var record = datareq.record;
    if (record === undefined) {
        record = 10;
    }

    var charsearch="%%";
    if(datareq.charsearch){
        charsearch="%"+datareq.charsearch+"%";
    }

    connect.ConnectMainServer(function (connection) {
       
         var queryCount = "Select * from ddh   where statusdh=? and (idddh like ? or phone like ?) order by ngaydat desc"; 


        connection.query(queryCount, [datareq.statusdh,charsearch,charsearch], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }
            var total = rows.length;
            if (total > 0) {
                var queryString = "Select * from ddh  where statusdh=? and (idddh like ? or phone like ?) order by ngaydat desc LIMIT ?,"+record;
                connection.query(queryString,[datareq.statusdh,charsearch,charsearch,page*record], function (err, rows) {
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
			}else{
				  res.send(core.notexist());
			}

	});
	});
});
router.post('/updatestatusddh',function (req, res) {
    var datareq = req.body;

  

    var id=datareq.idddh;
	var st=datareq.statusdh;
    
    connect.ConnectMainServer(function (connection) {
        var insertschedule="update `ddh` set statusdh=? where idddh=?";
        connection.query(insertschedule,[st,id],function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var queryString = "SELECT * from ddh where idddh=?";
            connection.query(queryString, [id], function (err, rows) {
                if (err) {
                    console.log(err);
                }
                var user = {
                    iduser: rows[0].iduserkh,
                    issend: 0
                }
                var arr = [];
                arr.push(user)
                var datapush;
                if (st == 1) {
                    datapush = {
                        content: JSON.stringify(core.convertDateToMilisecond(rows[0])),
                        key: "onacceptorder",
                        receiver: JSON.stringify(arr)
                    }
                }
                else {
                    datapush = {
                        content: JSON.stringify(core.convertDateToMilisecond(rows[0])),
                        key: "onshiporder",
                        receiver: JSON.stringify(arr)
                    }
                }

                var queryInsertPush = "INSERT INTO `pushnotification` SET ?";
                connection.query(queryInsertPush, datapush, function (err, result) {
                    if (err) {
                        console.log(err);
                        return;
                    }
                    datapush.id = result.insertId;
                    if(st==1)
                    {
                        getKeyIOS(rows[0].iduserkh,function (resp) {
                            resp=JSON.parse(resp.keyios);

                            for(var j in resp)
                            {
                                pushNotificationIOS(datapush,"Đơn hàng của bạn đã được chấp nhận",resp[j],req)
                            }

                        })
                    }
                    else
                    {
                        getKeyIOS(rows[0].iduserkh,function (resp) {
                            resp=JSON.parse(resp.keyios);

                            for(var j in resp)
                            {
                                pushNotificationIOS(datapush,"Đã giao hàng",resp[j],req)
                            }

                        })

                    }

                    req.io.to(core.openMyRoom(rows[0].iduserkh)).emit("onnewmessage", core.convertDateToMilisecond(datapush));


                    res.send(core.success(datareq)
                    )

                });
            });

        });
    })
});
router.post('/huydh',function (req, res) {
    var datareq = req.body;

  

    var id=datareq.idddh;
 
    connect.ConnectMainServer(function (connection) {

        var queryString = "SELECT * from ddh where idddh=?";
        connection.query(queryString, [id], function (err, rows) {
            if (err) {
                console.log(err);
                return;
            }
            var user = {
                iduser: rows[0].iduserkh,
                issend: 0
            }
            var arr = [];
            arr.push(user)
            var datapush = {
                    content: JSON.stringify(core.convertDateToMilisecond(rows[0])),
                    key: "ondeleteorder",
                    receiver: JSON.stringify(arr)
                }


            var insertschedule = "delete from `ddh` where idddh=?";
            connection.query(insertschedule, [id], function (err, result) {
                if (err) {
                    res.send(core.error(err.message));
                    console.log(err);
                    return;
                }
                var queryInsertPush = "INSERT INTO `pushnotification` SET ?";
                connection.query(queryInsertPush, datapush, function (err, result) {
                    if (err) {
                        console.log(err);
                        return;
                    }
                    datapush.id = result.insertId;

                    getKeyIOS(rows[0].iduserkh,function (resp) {
                        resp=JSON.parse(resp.keyios);

                        for(var j in resp)
                        {
                            pushNotificationIOS(datapush,"Đơn hàng của bạn đã bị từ chối",resp[j],req)
                        }

                    })

                    req.io.to(core.openMyRoom(rows[0].iduserkh)).emit("onnewmessage", core.convertDateToMilisecond(datapush));


                    res.send(core.success(datareq)
                    )

                });
            });
        });
    })
});
router.post('/updateapgia',function (req, res) {
    var datareq = req.body;

  

    var id=datareq.idddh;
	var st=datareq.infororder;
    
    connect.ConnectMainServer(function (connection) {
        var insertschedule="update `ddh` set infororder=? where idddh=?";
        connection.query(insertschedule,[st,id],function (err, result) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            res.send(core.success(datareq));

        });
    })
});
router.post('/updateapship',function (req, res) {
    var datareq = req.body;

  

    var id=datareq.idddh;
	var st=datareq.feeship;
    
    connect.ConnectMainServer(function (connection) {
        var insertschedule="update `ddh` set feeship=? where idddh=?";
        connection.query(insertschedule,[st,id],function (err, result) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            res.send(core.success(datareq));

        });
    })
});
router.post('/updategioship',function (req, res) {
    var datareq = req.body;

  

    var id=parseInt(datareq.idddh);
	var st=new Date(parseInt(datareq.datetimegiaokhach));
    
    connect.ConnectMainServer(function (connection) {
        var insertschedule="update `ddh` set datetimegiaokhach=? where idddh=?";
        connection.query(insertschedule,[st,id],function (err, result) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            var queryString = "SELECT * from ddh where idddh=?";
            connection.query(queryString, [id], function (err, rows) {
                if (err) {
                    console.log(err);
                }
                var user = {
                    iduser: rows[0].iduserkh,
                    issend: 0
                }
                var arr = [];
                arr.push(user)
                var datapush = {
                        content: JSON.stringify(core.convertDateToMilisecond(rows[0])),
                        key: "onupdatetimeship",
                        receiver: JSON.stringify(arr)
                    }

                var queryInsertPush = "INSERT INTO `pushnotification` SET ?";
                connection.query(queryInsertPush, datapush, function (err, result) {
                    if (err) {
                        console.log(err);
                        return;
                    }
                    datapush.id = result.insertId;
                    getKeyIOS(rows[0].iduserkh,function (resp) {
                        resp=JSON.parse(resp.keyios);

                        for(var j in resp)
                        {
                            pushNotificationIOS(datapush,"Giờ giao hàng đã thay đổi",resp[j],req)
                        }

                    })
                    req.io.to(core.openMyRoom(rows[0].iduserkh)).emit("onnewmessage", core.convertDateToMilisecond(datapush));


                    res.send(core.success(datareq)
                    )

                });
            });
        });
    })
});
router.post('/gettk', function(req, res) {
    var datareq = req.body;
   
    connect.ConnectMainServer(function (connection) {
       
                var queryString = "Select * from taikhoan";
                connection.query(queryString, [], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    res.send(
                        core.success(
                            {
                               
                                items:core.convertDateToMilisecond(rows)}
                        )
                    )
                    // res.send(core.success({

                    // items: rows
                    //}))
                });

            
    })
});

router.post('/updatepushnotify',function (req, res) {
    var datareq = req.body;
    var id=parseInt(datareq.id);

    connect.ConnectMainServer(function (connection) {
        var insertschedule="update `pushnotification` set receiver=? where id=?";
        connection.query(insertschedule,[datareq.receiver,datareq.id],function (err, result) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            resendPush(datareq.iduser,function (resu) {
                for (var i = 0; i< resu.length ; i++) {
                    console.log(resu[i]);
                    console.log("---------------------------")

                    req.io.to(core.openMyRoom(datareq.iduser)).emit("onnewmessage", core.convertDateToMilisecond(result[i]));
                }
            })
            res.send(core.success(datareq));

        });
    })
});

router.post('/resendpushnotify',function (req, res) {
    var datareq = req.body;
    var id = parseInt(datareq.iduser);

    connect.ConnectMainServer(function (connection) {
        var insertschedule = "select * from `pushnotification` where ?=getPushNotification(?,receiver)";
        connection.query(insertschedule, [datareq.iduser, datareq.iduser], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            for (var i = 0; i< result.length ; i++) {
                console.log(result[i]);
                console.log("---------------------------")

                req.io.to(core.openMyRoom(datareq.iduser)).emit("onnewmessage", core.convertDateToMilisecond(result[i]));
            }

            res.send(core.success());
        });
    })
});

function resendPush(iduser,callback) {
    connect.ConnectMainServer(function (connection) {
        var insertschedule = "select * from `pushnotification` where ?=getPushNotification(?,receiver) limit 0,1";
        connection.query(insertschedule, [iduser, iduser], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            callback(result)
            // res.send(core.success());
        });
    })
}


module.exports = router;
