express = require('express');
var router = express.Router();
var core=require('./core');
var connect=require('./connect');
//var connect2=require('./connect2');
var SHA256 = require("crypto-js/sha256");

router.post('/getactivityweb', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

   
    var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from activity a";

        connection.query(queryCount, [], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from activity order by createdate limit ?,"+record;
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

router.post('/getactivity', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

   
    var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from activity a where visible=1";

        connection.query(queryCount, [], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from activity where visible=1 order by createdate limit ?,"+record;
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
router.post('/getvideoactivitybyidacweb', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

    
    var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from videoactivity  where idac=?";

        connection.query(queryCount, [datareq.idac], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from videoactivity where idac=? order by createdatevi limit ?,"+record;
                connection.query(queryString, [datareq.idac,page*record], function (err, rows) {
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
router.post('/getvideoactivitybyidac', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

    
    var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from videoactivity  where idac=? and visible=1";

        connection.query(queryCount, [datareq.idac], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from videoactivity where idac=? and visible=1 order by createdatevi limit ?,"+record;
                connection.query(queryString, [datareq.idac,page*record], function (err, rows) {
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
router.post('/getallvideoactivity', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

    
    var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from videoactivity v, activity a  where v.idac=a.idac";

        connection.query(queryCount, [], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from videoactivity v, activity a  where v.idac=a.idac order by v.createdatevi desc limit ?,"+record;
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
router.post('/createvideoac',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("activity"), req.body);
    
    datareq.createdate=new Date(parseInt(datareq.createdate))
    
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "INSERT INTO `activity` SET ?";
                connection.query(queryInsertUser, datareq, function (err, result) {
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
router.post('/udpatevideoac',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("activity"), req.body);
    
    datareq.createdate=new Date(parseInt(datareq.createdate))
    
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "update `activity` SET ? where idac=? ";
                connection.query(queryInsertUser, [datareq,datareq.idac], function (err, result) {
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
router.post('/deletevideoac',function (req, res) {
    var datareq = req.body;
    
    
   
      
    connect.ConnectMainServer(function (connection) {
			var queryde = "select * from `videoactivity` where `idac`=?";
				connection.query(queryde, [datareq.idac], function (err, result) {
				if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
				}
				 if(result.length>0){
					  res.send(core.exist());
				 }else{
					 //
				var queryde = "delete from `activity` where `idac`=?";
				connection.query(queryde, [datareq.idac], function (err, result) {
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
				//
				 }
				});
				
            
			

    });
});
router.post('/createvideoaclq',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("activityvideo"), req.body);
    
    datareq.createdatevi=new Date(parseInt(datareq.createdatevi))
    
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "INSERT INTO `videoactivity` SET ?";
                connection.query(queryInsertUser, datareq, function (err, result) {
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
router.post('/udpatevideoaclq',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("activityvideo"), req.body);
    
    datareq.createdatevi=new Date(parseInt(datareq.createdatevi))
    
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "update `videoactivity` SET ? where idvi=? ";
                connection.query(queryInsertUser, [datareq,datareq.idvi], function (err, result) {
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
router.post('/deletevideoaclq',function (req, res) {
    var datareq = req.body;
    
    
   
      
    connect.ConnectMainServer(function (connection) {
		
				var queryde = "delete from `videoactivity` where `idvi`=?";
				connection.query(queryde, [datareq.idvi], function (err, result) {
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
				//
				
				
            
			

    });
});
module.exports = router;
