express = require('express');
var router = express.Router();
var core=require('./core');
var connect=require('./connect');
//var connect2=require('./connect2');
var SHA256 = require("crypto-js/sha256");



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

        queryCount = "Select count(*) as 'total' from nhapp where  mst like ? or sdt like ? or  manpp like ? or  tennpp like ?";

        connection.query(queryCount, [charsearch,charsearch,charsearch,charsearch], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select distinct nhapp.*,users.password,users.username from nhapp,users  where (users.iduser=nhapp.user) and (mst like ? or sdt like ? or manpp like ? or tennpp like ?) order by tennpp limit ?,"+record;
                connection.query(queryString, [charsearch,charsearch,charsearch,charsearch,page*record], function (err, rows) {
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
router.post('/create',function (req, res) {
    var datareq = req.body;
   datareq.password=SHA256(datareq.password).toString();
  
    var nhapp=core.fetchFieldsIfExist(core.getfield("npp"),datareq);

    connect.ConnectMainServer(function (connection) {

        var queryString = "SELECT * FROM `users` WHERE username=?";
        connection.query(queryString, [datareq.username], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }
            
            if(rows.length>0){
                res.send(core.exist(nhapp));//1002
            }else {
                var insertschedule = "INSERT INTO `users` ( `username`, `password`, `permission`,`detailname`,`phone`,`email`) VALUES ( ?, ?, ?,?,?,?)";

                connection.query(insertschedule, [datareq.username,datareq.password,datareq.permission,datareq.detailname,datareq.phone,datareq.email], function (err, result) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    
                    var insertschedule = "INSERT INTO `nhapp` SET ?";

                    nhapp.user=result.insertId;
                    connection.query(insertschedule, nhapp, function (err, result) {
                        if (err) {
                            res.send(core.error(err.message));
                            console.log(err);
                            return;
                        }

                        res.send(core.success(nhapp));
                        
                    })
                });

            }
        });




    })

});
router.post('/updatenhaphanphoi',function (req, res) {
    var datareq = req.body;

    var sp=core.fetchFieldsIfExist(core.getfield("npp"),datareq);

    var manpp=datareq.manpp;
    
    connect.ConnectMainServer(function (connection) {
        var insertschedule="update `nhapp` set ? where manpp=?";
        connection.query(insertschedule,[sp,manpp],function (err, result) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            res.send(core.success(sp));

        });
    })
});
router.post('/deletenhaphanphoi',function (req, res) {
    var datareq = req.body;
  
    connect.ConnectMainServer(function (connection) {
        var queryString = "SELECT * FROM joinsanpham_nhapp WHERE manpp=?";
        connection.query(queryString, [datareq.manpp], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
               // console.log(err);
                return;
            }
            if(rows.length>0){ //co ton tai kiem tra tiep bang user 
			
                res.send(core.exist(datareq));

            }else //xóa
            {
				
                var insertschedule = "delete  from `nhapp` where manpp=?";
                connection.query(insertschedule, [datareq.manpp], function (err, result) {
                    if (err) {
                        res.send(core.error(err.message));
                      //  console.log(err);
                        return;
                    }
					 if(result.affectedRows>0){
					var insertschedule = "delete  from `users` where iduser=?";
                connection.query(insertschedule, [datareq.user], function (err, result) {
                    if (err) {
                        res.send(core.error(err.message));
                      //  console.log(err);
                        return;
                    }
                    if(result.affectedRows>0){
                    res.send(core.success())
					}else{
						res.send(core.fail());
					}

						});
					 }else{
						 res.send(core.fail());
					 }
                    

                });
            }

        });


    })
});
module.exports = router;
