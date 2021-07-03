express = require('express');
var router = express.Router();
var core=require('./core');
var connect=require('./connect');
//var connect2=require('./connect2');
var SHA256 = require("crypto-js/sha256");
router.post('/create',core.checkSession,function (req, res) {
    var datareq = req.body;
    var maloai=datareq.maloai;
    var kieucach=core.fetchFieldsIfExist(core.getfield("kieucach"),datareq);
    connect.ConnectMainServer(function (connection) {

        var queryString = "SELECT * FROM `kieucach` WHERE maloai=?";
        connection.query(queryString, [maloai], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }
            if(rows.length>0){
                res.send(core.exist(kieucach));//1002
            }else {
                var insertschedule = "INSERT INTO `kieucach` SET ? ";

                connection.query(insertschedule, kieucach, function (err, result) {
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

router.post('/updatelsp',core.checkSession,function (req, res) {
    var datareq = req.body;

    var kieucach=core.fetchFieldsIfExist(core.getfield("kieucach"),datareq);

    var maloai=datareq.maloai;
    
    connect.ConnectMainServer(function (connection) {
        var insertschedule="update `kieucach` set ? where maloai=?";
        connection.query(insertschedule,[kieucach,maloai],function (err, result) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            res.send(core.success(kieucach));

        });
    })
});

router.post('/getloai', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }


    var charsearch="%%";
    if(datareq.charsearch){
        charsearch="%"+datareq.charsearch+"%";
    }
    // var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from kieucach ";

        connection.query(queryCount, [datareq.maloai], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from kieucach";
                connection.query(queryString, [datareq.maloai], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    res.send(
                        core.success(
                            {
                                // page: page,
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
