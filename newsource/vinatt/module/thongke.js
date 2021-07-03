express = require('express');
var router = express.Router();
var core=require('./core');
var connect=require('./connect');
//var connect2=require('./connect2');
var SHA256 = require("crypto-js/sha256");

router.post('/getdhpage',  function(req, res) {
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
   
  
   
	var fr=new Date(parseInt(datareq.fr));
	var end=new Date(parseInt(datareq.end));
    
    connect.ConnectMainServer(function (connection) {


        var queryCount = "SELECT * from ddh where (date(ngaydat)>=? and date(ngaydat)<=?) and statusdh=? order by ngaydat desc";

        connection.query(queryCount, [fr,end,datareq.statusdh], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }
            var total = rows.length;
            if (total > 0) {
                

                var queryString = "SELECT * from ddh where (date(ngaydat)>=? and date(ngaydat)<=?) and statusdh=? order by ngaydat desc LIMIT ?,"+record;
                connection.query(queryString, [fr,end,datareq.statusdh,page*record], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    
						res.send(core.success({
                        page: page,
                        totalitem: total,
                        totalpage: Math.ceil(total / record),
                        record: record,
                        items: core.convertDateToMilisecond(rows)
						}))
					
                
                });
            }
            else
            {
                res.send(core.notexist());
            }
        });
    });
});

router.post('/getsp',  function(req, res) {
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
    if(datareq.charsearch)
    {
        charsearch="%"+datareq.charsearch+"%";

    }


    var fr=new Date(parseInt(datareq.fr));
    var end=new Date(parseInt(datareq.end));

    connect.ConnectMainServer(function (connection) {


        var queryCount = "SELECT * from sanpham s where  (select sum(getTotalItemFromOrder(s.idsp,d.infororder)) from ddh d where (ngaydat between ? and ?) and statusdh=? )>0";

        connection.query(queryCount, [fr,end,datareq.statusdh], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }
            var total = rows.length;
            if (total > 0) {


                var queryString = "SELECT distinct s.*,l.ten as 'tenloai', k.ten as 'tenkieu',lsp.tenloai as 'tenloaisp',(select sum(getTotalItemFromOrder(s.idsp,d.infororder)) from ddh d where (ngaydat between ? and ?) and statusdh=?) as 'total',(select sum(getPriceFromOrder(s.idsp,d.infororder)) from ddh d where (ngaydat between ? and ?) and statusdh=? ) as 'totalprice' from loaisp lsp,sanpham s, loai l, kieucach k where lsp.maloai=s.maloaisp and s.loai=l.maloai and s.kieu=k.ma  having total>0 order by total desc LIMIT ?,"+record;
                connection.query(queryString, [fr,end,datareq.statusdh,fr,end,datareq.statusdh,page*record], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }

                    res.send(core.success({
                        page: page,
                        totalitem: total,
                        totalpage: Math.ceil(total / record),
                        record: record,
                        items: core.convertDateToMilisecond(rows)
                    }))


                });
            }
            else
            {
                res.send(core.notexist(datareq));
            }
        });
    });
});

module.exports = router;
