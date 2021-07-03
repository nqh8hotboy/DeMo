express = require('express');
var router = express.Router();
var core=require('./core');
var connect=require('./connect');
//var connect2=require('./connect2');
var SHA256 = require("crypto-js/sha256");
router.post('/create',function (req, res) {
    var datareq = req.body;
    var maloai=datareq.maloai;
    var loaisp=core.fetchFieldsIfExist(core.getfield("loaisp"),datareq);
    connect.ConnectMainServer(function (connection) {

        var queryString = "SELECT * FROM `loaisp` WHERE maloai=?";
        connection.query(queryString, [maloai], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }
            if(rows.length>0){
                res.send(core.exist(loaisp));//1002
            }else {
                var insertschedule = "INSERT INTO `loaisp` SET ? ";

                connection.query(insertschedule, loaisp, function (err, result) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    res.send(core.success({

                        items: core.convertDateToMilisecond(rows)
                    }))
                });
                //console.log(core.convertDateToMilisecond(rows));
            }
        });




    })

});

router.post('/updatelsp',function (req, res) {
    var datareq = req.body;

    var loaisp=core.fetchFieldsIfExist(core.getfield("loaisp"),datareq);

    var maloai=datareq.maloai;
    
    connect.ConnectMainServer(function (connection) {
        var insertschedule="update `loaisp` set ? where maloai=?";
        connection.query(insertschedule,[loaisp,maloai],function (err, result) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            res.send(core.success(loaisp));

        });
    })
});


router.post('/getloai', function(req, res) {
    var datareq = req.body;
    

    connect.ConnectMainServer(function (connection) {
        
                var queryString = "Select * from loaisp order by maloai asc";
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

router.post('/getloaidm', function(req, res) {
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

        queryCount = "Select count(*) as 'total'  from loaisp l";

        connection.query(queryCount, [], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from  loaisp l order by maloai asc LIMIT ?,"+record;
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


module.exports = router;
