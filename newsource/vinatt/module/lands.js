express = require('express');
var router = express.Router();
var core=require('./core');
var connect=require('./connect');
//var connect2=require('./connect2');
var SHA256 = require("crypto-js/sha256");



//tao land
router.post('/create',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("lands"),req.body);
    if(!core.allDataRequestExist(datareq,["iduser","codeland","namealias","posland","arealand","createatland"])){
        res.send(core.nonedata());
        return;
    }

    datareq.createatland=new Date(parseInt(datareq.createatland))
   
    connect.ConnectMainServer(function (connection) {

        var queryInsert = "INSERT INTO `parcel_of_land` SET ?";
        connection.query(queryInsert, datareq, function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }
            datareq.id = result.insertId;
            datareq = core.convertDateToMilisecond(datareq);
            res.send(core.success(datareq));
        });

    });
});
router.post('/update',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("lands"),req.body);
    if(datareq.createatland!=undefined)
    {
        datareq.createatland=new Date(parseInt(datareq.createatland))
    }
    
    if(datareq) {
        connect.ConnectMainServer(function (connection) {
            var getstatusstring = "UPDATE `parcel_of_land` SET ? WHERE  codeland=? and iduser=?";
            connection.query(getstatusstring, [datareq,datareq.codeland,datareq.iduser],function (err, result) {
                if(err) {res.send(core.error(err.message));console.log(err); return;}
                res.send(core.success());
            });
        });
    }else{
        res.send(core.nonedata());
    }
});
//lay danh sach cac thua dat cua user co idsuer

router.post('/getbyiduser', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

    if(!core.allDataRequestExist(datareq,["page"])){
        res.send(core.nonedata());
        return;
    }

    var charsearch="%%";
    if(datareq.charsearch){
        charsearch="%"+datareq.charsearch+"%";
    }
    var page=datareq.page;
    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from parcel_of_land l, users u where l.iduser=? and l.iduser=u.iduser and (l.codeland like ? or l.namealias like ?)";

        connection.query(queryCount, [datareq.iduser,charsearch,charsearch], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from parcel_of_land l, users u where l.iduser=? and l.iduser=u.iduser and (l.codeland like ? or l.namealias like ?)  order by createatland desc limit ?, "+record;
                connection.query(queryString, [datareq.iduser,charsearch,charsearch,page*record], function (err, rows) {
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

router.post('/getalluser', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

    if(!core.allDataRequestExist(datareq,["page"])){
        res.send(core.nonedata());
        return;
    }

    var charsearch="%%";
    if(datareq.charsearch){
        charsearch="%"+datareq.charsearch+"%";
    }
    var page=datareq.page;
    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from parcel_of_land l, users u where  l.iduser=u.iduser and (l.codeland like ? or l.namealias like ?)";

        connection.query(queryCount, [charsearch,charsearch], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from parcel_of_land l, users u where  l.iduser=u.iduser and (l.codeland like ? or l.namealias like ?)  order by createatland desc limit ?, "+record;
                connection.query(queryString, [charsearch,charsearch,page*record], function (err, rows) {
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
router.post('/deleteland',function (req, res) {
    var datareq = req.body;
    if (!core.allDataRequestExist(datareq, ["codeland"])) {
        res.send(core.nonedata());
        return;
    }
    
   
      
    connect.ConnectMainServer(function (connection) {

        var queryUpdateUser = "select * from `areaproduct` where `codeland`=?";
        connection.query(queryUpdateUser, [datareq.codeland], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }
			 var total = result.length;
			if(total==0){
				//
				var queryde = "delete from `parcel_of_land` where `codeland`=?";
				connection.query(queryde, [datareq.codeland], function (err, result) {
				if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
				}

				datareq = core.convertDateToMilisecond(datareq);
				res.send(core.success(datareq));

				});
				//
            
			}else{
				  res.send(core.exist(datareq));
			}

        });

    });
});
//lay danh sach cac chung nhan
router.post('/getcert', function(req, res) {
    var datareq = req.body;
    
    connect.ConnectMainServer(function (connection) {
    
                var queryString = "Select * from certification";
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
                });

           
        })
    
});
//lay ve buoi nam roi dua vao ma buoi
router.post('/gettree', function(req, res) {
    var datareq = req.body;
    
    connect.ConnectMainServer(function (connection) {
    
                var queryString = "Select * from trees where idtypetree=?";
                connection.query(queryString, [datareq.idtypetree], function (err, rows) {
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

           
        })
    
});
router.post('/gettypetree', function(req, res) {
    var datareq = req.body;
    
    connect.ConnectMainServer(function (connection) {
    
                var queryString = "Select * from typetree";
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
                });

           
        })
    
});
router.post('/gettrees', function(req, res) {
    var datareq = req.body;
    
    connect.ConnectMainServer(function (connection) {
    
                var queryString = "Select * from trees, typetree where trees.idtypetree=typetree.idtypetree";
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
                });

           
        })
    
});
router.post('/getareaproduct', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

    if(!core.allDataRequestExist(datareq,["page"])){
        res.send(core.nonedata());
        return;
    }

    var charsearch="%%";
    if(datareq.charsearch){
        charsearch="%"+datareq.charsearch+"%";
    }
    var page=datareq.page;
    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from typetree tt, areaproduct a, trees t, certification c where tt.idtypetree=t.idtypetree and a.idtree=t.idtree and c.idcert=a.idcert and a.iduser=? and a.codeland=?";

        connection.query(queryCount, [datareq.iduser, datareq.codeland], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from typetree tt,areaproduct a, trees t, certification c where tt.idtypetree=t.idtypetree and a.idtree=t.idtree and c.idcert=a.idcert and a.iduser=? and a.codeland=? order by date_begin_area desc limit ?, "+record;
                connection.query(queryString, [datareq.iduser,datareq.codeland,page*record], function (err, rows) {
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
router.post('/create',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("areaproduct"),req.body);
    if(!core.allDataRequestExist(datareq,["idtree","iduser","codeland","area"])){
        res.send(core.nonedata());
        return;
    }

    datareq.datecert=new Date(parseInt(datareq.datecert))
    datareq.datecertexpire=new Date(parseInt(datareq.datecertexpire))
    datareq.createatarea=new Date(parseInt(datareq.createatarea))
    datareq.date_end_area=new Date(parseInt(datareq.date_end_area))
	 datareq.date_begin_area=new Date(parseInt(datareq.date_begin_area))
    // datareq.lock=1;//moi dang ky tai khoang se bi khoa
    connect.ConnectMainServer(function (connection) {

        var queryInsert = "INSERT INTO `areaproduct` SET ?";
        connection.query(queryInsert, datareq, function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }
            datareq.id = result.insertId;
            datareq = core.convertDateToMilisecond(datareq);
            res.send(core.success(datareq));
        });

    });
});
router.post('/delete',function (req, res) {
    var datareq = req.body;
    if (!core.allDataRequestExist(datareq, ["idarea"])) {
        res.send(core.nonedata());
        return;
    }
    
    connect.ConnectMainServer(function (connection) {

       
		var queryde = "delete from `areaproduct` where `idarea`=?";
        connection.query(queryde, [datareq.idarea], function (err, result) {
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

module.exports = router;
