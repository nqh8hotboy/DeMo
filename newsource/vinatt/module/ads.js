express = require('express');
var router = express.Router();
var core=require('./core');
var connect=require('./connect');
//var connect2=require('./connect2');
var SHA256 = require("crypto-js/sha256");



router.post('/get', function(req, res) {
    var datareq = req.body;
    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from ads where  NOW() between timestart and timeend and isview=0";

        connection.query(queryCount, [], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from ads where NOW() between timestart and timeend and isview=0 order by rand() ";
                connection.query(queryString, [], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    res.send(
                        core.success(
                            {
                                totalitem: total,
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


router.post('/getslogan', function(req, res) {
    var datareq = req.body;
    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from slogan";

        connection.query(queryCount, [], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from slogan order by rand() ";
                connection.query(queryString, [], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    res.send(
                        core.success(
                            {
                                totalitem: total,
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
    connect.ConnectMainServer(function (connection) {


        var insertschedule = "INSERT INTO `ads` SET ?";

        connection.query(insertschedule, datareq, function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            res.send(core.success(nhasoche));

        })
    })

});
router.post('/update',function (req, res) {
    var datareq = req.body;
    var mansc=datareq.mansc;

    connect.ConnectMainServer(function (connection) {
        var insertschedule="update `ads` set ? where id=?";
        connection.query(insertschedule,[datareq,datareq.id],function (err, result) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            res.send(core.success(sp));

        });
    })
});
router.post('/delete',function (req, res) {
    var datareq = req.body;

    connect.ConnectMainServer(function (connection) {

        var insertschedule = "delete  from `ads` where id=?";
        connection.query(insertschedule, [datareq.id], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            res.send(core.success())

        });

    })
});



router.post('/createslogan',function (req, res) {
    var datareq = req.body;
    datareq.password=SHA256(datareq.password).toString();
    connect.ConnectMainServer(function (connection) {


        var insertschedule = "INSERT INTO `slogan` SET ?";

        connection.query(insertschedule, datareq, function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            res.send(core.success(nhasoche));

        })
    })

});
router.post('/updateslogan',function (req, res) {
    var datareq = req.body;
    var mansc=datareq.mansc;

    connect.ConnectMainServer(function (connection) {
        var insertschedule="update `slogan` set ? where id=?";
        connection.query(insertschedule,[datareq,datareq.id],function (err, result) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            res.send(core.success(sp));

        });
    })
});
router.post('/deleteslogan',function (req, res) {
    var datareq = req.body;

    connect.ConnectMainServer(function (connection) {

        var insertschedule = "delete  from `slogan` where id=?";
        connection.query(insertschedule, [datareq.id], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            res.send(core.success())

        });

    })
});
module.exports = router;
