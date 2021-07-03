express = require('express');
var router = express.Router();
var core=require('./core');
var connect=require('./connect');
//var connect2=require('./connect2');
var SHA256 = require("crypto-js/sha256");

//0 admin
//1 nha cung cap
//2 so che
//3 phan phoi
//4 user thuong

router.post('/get', function(req, res) {
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

        queryCount = "Select count(*) as 'total' from nhavc,users where (users.iduser=nhavc.user) and  (diachi like ? or mst like ? or sdt like ? or  manvc like ? or  tennvc like ?)";

        connection.query(queryCount, [charsearch,charsearch,charsearch,charsearch,charsearch], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
              //  console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select distinct nhavc.*,users.password,users.username,users.iduser  from nhavc,users  where (users.iduser=nhavc.user) and (diachi like ? or mst like ? or sdt like ? or manvc like ? or tennvc like ?) order by tennvc limit ?,"+record;
                connection.query(queryString, [charsearch,charsearch,charsearch,charsearch,charsearch,page*record], function (err, rows) {
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
router.post('/create',function (req, res) {
    var datareq = req.body;
   datareq.password=SHA256(datareq.password).toString();
  
    var nhavc=core.fetchFieldsIfExist(core.getfield("nvc"),datareq);
	//console.log(nhavc);
    connect.ConnectMainServer(function (connection) {

        var queryString = "SELECT * FROM `users` WHERE username=? and password=?";
        connection.query(queryString, [datareq.username,datareq.password], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
              //  console.log(err);
                return;
            }
            
            if(rows.length>0){
                res.send(core.exist(nhavc));//1002
				
            }else {
                 var insertschedule = "INSERT INTO `users` ( `username`, `password`, `permission`,`detailname`,`phone`,`email`) VALUES ( ?, ?, ?,?,?,?)";

                connection.query(insertschedule, [datareq.username,datareq.password,datareq.permission,datareq.detailname,datareq.phone,datareq.email], function (err, result) {
                    if (err) {
                        res.send(core.error(err.message));
                      //  console.log(err);
                        return;
                    }
                    if(result.affectedRows>0){
					var insertschedule = "INSERT INTO `nhavc` SET ?";

                    nhavc.user=result.insertId;
                    connection.query(insertschedule, nhavc, function (err, result) {
                        if (err) {
                            res.send(core.error(err.message));
                          //  console.log(err);
                            return;
                        }
						 if(result.affectedRows>0){
                        res.send(core.success(nhavc));
						 }else{
							 res.send(core.fail(datareq));
						 }
                        
                    })
					}else{ //1001
					res.send(core.fail(datareq));
					}
                    
                });

            }
        });




    })

});
router.post('/updatenhavc',function (req, res) {
    var datareq = req.body;

    var sp=core.fetchFieldsIfExist(core.getfield("nvc"),datareq);

    var manvc=datareq.manvc;
    
    connect.ConnectMainServer(function (connection) {
        var insertschedule="update `nhavc` set ? where manvc=?";
        connection.query(insertschedule,[sp,manvc],function (err, result) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            res.send(core.success(sp));

        });
    })
});
router.post('/deletenhavc',function (req, res) {
    var datareq = req.body;
  
    connect.ConnectMainServer(function (connection) {
        var queryString = "SELECT * FROM `joinsanpham_nhavc` WHERE manvc=?";
        connection.query(queryString, [datareq.manvc], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
              //  console.log(err);
                return;
            }
            if(rows.length>0){ //co ton tai kiem tra tiep bang user 
			
                res.send(core.exist(datareq));

            }else //xóa
            {
                var insertschedule = "delete  from `nhavc` where manvc=?";
                connection.query(insertschedule, [datareq.manvc], function (err, result) {
                    if (err) {
                        res.send(core.error(err.message));
                    //    console.log(err);
                        return;
                    }
				 if(result.affectedRows>0){
						var insertschedule = "delete  from `users` where iduser=?";
						connection.query(insertschedule, [datareq.user], function (err, result) {
						if (err) {
                        res.send(core.error(err.message));
                       // console.log(err);
                        return;
						}
						 if(result.affectedRows>0){
							res.send(core.success())
						 }else{
							 res.send(core.fail());
						 }

						});
				 }
				else{
						res.send(core.fail());
					}
                    

                });
            }

        });


    })
});
module.exports = router;
