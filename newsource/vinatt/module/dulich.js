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
        record=40;
    }

    var charsearch="%%";
    if(datareq.charsearch){
        charsearch="%"+datareq.charsearch+"%";
    }
    var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from dulich where name like ?";

        connection.query(queryCount, [charsearch], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select d.*,calculteRate(danhgia) as 'sao',getinfouser(d.iduser) as 'user',(round(( 6367 * acos( cos( radians(?) ) * cos( radians(lat) ) * cos( radians(lng ) - radians(?) ) + sin( radians(?) ) * sin(radians(lat)) ) ),1)) AS 'distance' from dulich d where name like ? having distance <50 order by distance asc limit ?,"+record;
                connection.query(queryString, [datareq.lat,datareq.lng,datareq.lat,charsearch,page*record], function (err, rows) {
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
    connect.ConnectMainServer(function (connection) {


        var insertschedule = "INSERT INTO `dulich` SET ?";

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
        var insertschedule="update `dulich` set ? where id=?";
        connection.query(insertschedule,[datareq,datareq.id],function (err, result) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            res.send(core.success());

        });
    })
});

router.post('/updaterating',function (req, res) {
    var datareq = req.body;
    datareq.rate=parseInt(datareq.rate);

    connect.ConnectMainServer(function (connection) {

        var insertschedule="select json_contains(danhgia,json_object('iduser',?)) as 'israte' from dulich where id=?";
        connection.query(insertschedule,[datareq.iduser,datareq.id],function (err, result) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            if(result[0].israte==1)
            {
                res.send(core.exist())
            }
            else {
                var insertschedule = "update `dulich` set danhgia=JSON_ARRAY_INSERT(danhgia, '$[0]', JSON_OBJECT('iduser',?,'sao',?)) where id=?";
                connection.query(insertschedule, [datareq.iduser, datareq.rate, datareq.id], function (err, result) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    res.send(core.success());

                });
            }
        });

    })
});
router.post('/delete',function (req, res) {
    var datareq = req.body;

    connect.ConnectMainServer(function (connection) {

        var insertschedule = "delete  from `dulich` where id=?";
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
