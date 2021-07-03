express = require('express');
var router = express.Router();
var core=require('./core');
var connect=require('./connect');
//var connect2=require('./connect2');
var path=require('path');
var fs = require('fs');
var SHA256 = require("crypto-js/sha256");

router.post('/getnewsweb', function(req, res) {
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

        queryCount = "Select count(*) as 'total' from news n, users u where n.iduser=u.iduser and (n.title_vi like ? or n.title_vi like ?)";

        connection.query(queryCount, [charsearch,charsearch], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from news n, users u where  n.iduser=u.iduser and (n.title_vi like ? or n.title_vi like ?)  order by create_date desc limit ?, "+record;
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
router.post('/getnews', function(req, res) {
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

        queryCount = "Select count(*) as 'total' from news n, users u where n.visible=1 and  n.iduser=u.iduser and (n.title_vi like ? or n.title_vi like ?)";

        connection.query(queryCount, [charsearch,charsearch], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from news n, users u where n.visible=1 and  n.iduser=u.iduser and (n.title_vi like ? or n.title_vi like ?)  order by create_date desc limit ?, "+record;
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
router.post('/delete',function (req, res) {
    var datareq = req.body;
    if (!core.allDataRequestExist(datareq, ["idnews"])) {
        res.send(core.nonedata());
        return;
    }
    
   
      
    connect.ConnectMainServer(function (connection) {

    
				//
				var queryde = "delete from `news` where `idnews`=?";
				connection.query(queryde, [datareq.idnews], function (err, result) {
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
					   res.send(core.fail(datareq));
				   }

				});
				//
            
			

    });
});
//lay anh tu thu vien
router.post('/getallimages', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

    if(!core.allDataRequestExist(datareq,["page"])){
        res.send(core.nonedata());
        return;
    }

   
    var page=datareq.page;
    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from  libra";

        connection.query(queryCount, [], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from  libra  order by create_img desc limit ?, "+record;
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
                });

            }
            else
            {
                res.send(core.notexist(datareq));
            }
        })
    })
});
router.post('/createlibra',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("libra"), req.body);
    
    datareq.create_img=new Date(parseInt(datareq.create_img))
    
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "INSERT INTO `libra` SET ?";
                connection.query(queryInsertUser, datareq, function (err, result) {
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
router.post('/getallimagesactivity', function(req, res) {
    var datareq = req.body;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

    if(!core.allDataRequestExist(datareq,["page"])){
        res.send(core.nonedata());
        return;
    }

   
    var page=datareq.page;
    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from  imagesactivity";

        connection.query(queryCount, [], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from  imagesactivity  order by create_date desc limit ?, "+record;
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
                });

            }
            else
            {
                res.send(core.notexist(datareq));
            }
        })
    })
});
router.post('/createimagesactivty',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("imageactivity"), req.body);
    
    datareq.create_date=new Date(parseInt(datareq.create_date))
    
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "INSERT INTO `imagesactivity` SET ?";
                connection.query(queryInsertUser, datareq, function (err, result) {
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
///
router.post('/deletelibra',function (req, res) {
    var datareq =  req.body;
    
   
    
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "delete from `libra` where id=?";
                connection.query(queryInsertUser, [datareq.id], function (err, result) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                   if(result.affectedRows>0)
				   {
					   ///////////////
					   var pathfilename='./public/'+datareq.urllink;
			
	
						fs.stat(pathfilename, function (err, stats) {


						if (err) {
						res.send(core.fail());
						}

							fs.unlink(pathfilename,function(err){
							if(err) return console.log(err);
								//res.send(core.success());
							});  
						});
					   //////////////
					   res.send(core.success());
				   }else
				   {
					   res.send(core.fail(datareq));
				   }
                });
     
    });
});
//check ton tai 
router.post('/checkimageactivty', function(req, res) {
    var datareq = req.body;
    
    connect.ConnectMainServer(function (connection) {
       

                var queryString = "Select * from imagesactivity where urlimg=?";
                connection.query(queryString, [datareq.urlimg], function (err, rows) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
					if(rows.length>0){
						res.send(
                        core.exist())
					}else
					{
						res.send(
                        core.notexist())
					}
                });

           
    })
});
router.post('/deleteimagesactivity',function (req, res) {
    var datareq = req.body;
    
    
   
      
    connect.ConnectMainServer(function (connection) {

    
				//
				var queryde = "delete from `imagesactivity` where `id`=?";
				connection.query(queryde, [datareq.id], function (err, result) {
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
router.post('/createnews',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("news"), req.body);
    
    datareq.create_date=new Date(parseInt(datareq.create_date))
    
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "INSERT INTO `news` SET ?";
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
router.post('/udpatenews',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("news"), req.body);
    
    datareq.create_date=new Date(parseInt(datareq.create_date))
    
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "update `news` SET ? where idnews=? ";
                connection.query(queryInsertUser, [datareq,datareq.idnews], function (err, result) {
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
module.exports = router;
