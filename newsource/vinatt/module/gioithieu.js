express = require('express');
var router = express.Router();
var core=require('./core');
var connect=require('./connect');
//var connect2=require('./connect2');
var SHA256 = require("crypto-js/sha256");
router.post('/getintroducecompany', function(req, res) {
    var datareq = req.body;
   

    connect.ConnectMainServer(function (connection) {
      

                var queryString = "Select * from introducecompany";
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
router.post('/getimagestop', function(req, res) {
    var datareq = req.body;
   

    connect.ConnectMainServer(function (connection) {
      

                var queryString = "Select * from imagesactivity limit 0,5";
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
router.post('/getimagesactivity', function(req, res) {
    var datareq = req.body;
   
   var record=datareq.record;
    if(record==undefined){
        record=10;
    }
	var page=datareq.page;
    connect.ConnectMainServer(function (connection) {
      
var queryCount="";

        queryCount = "Select count(*) as 'total' from imagesactivity a";

        connection.query(queryCount, [], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {
                var queryString = "Select * from imagesactivity order by create_date limit ?,"+record;
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

router.post('/create',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("introducecompany"), req.body);
   

    
    connect.ConnectMainServer(function (connection) {
        var queryString="SELECT * FROM `introducecompany` WHERE idintro=?";
        connection.query(queryString,[datareq.idintro],function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }
            if (rows.length == 0) {
			//	console.log("text");
			 if(datareq.idintro==0)
			 {
				 datareq.idintro=1;
			 }
			 
                var queryInsertUser = "INSERT INTO `introducecompany` SET ?";
                connection.query(queryInsertUser, datareq, function (err, result) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    datareq = core.convertDateToMilisecond(datareq);
                    res.send(core.success(datareq));
                });
            }
            else {
				//	console.log("texts");
                var queryInsertUser = "update `introducecompany` SET contentintro_vi=?,contentintro_en=?,listimg=? where idintro=? ";
                connection.query(queryInsertUser, [datareq.contentintro_vi,datareq.contentintro_en,datareq.listimg,datareq.idintro], function (err, result) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
					if(result.affectedRows>0){
                   
                    res.send(core.success());
					}else
					{
						res.send(core.fail(datareq));
					}
                });
            }
        })

    });
});
///////////////////////Contact
router.post('/getcontact', function(req, res) {
    var datareq = req.body;
   
var record=datareq.record;
    if(record==undefined){
        record=10;
    }
	var page=datareq.page;
    connect.ConnectMainServer(function (connection) {
      
 
	 var queryCount="";

        queryCount = "Select count(*) as 'total' from contact";

        connection.query(queryCount, [], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from contact";
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
			}else{
				res.send(core.notexist(datareq));
			}
		});
 
    })
});
router.post('/createcontact',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("contact"), req.body);  
    connect.ConnectMainServer(function (connection) {
        var queryString="SELECT * FROM `contact` WHERE phone=?";
        connection.query(queryString,[datareq.phone],function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }
            if (rows.length == 0) {
			
			 
                var queryInsertUser = "INSERT INTO `contact` SET ?";
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
					    res.send(core.fail());//1001
				   }
                    
                });
            }
            else {
				
				 res.send(core.exist());//1002
            }
        })

    });
});
router.post('/udpatecontact',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("contact"), req.body);
   
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "update `contact` SET ? where id=? ";
                connection.query(queryInsertUser, [datareq,datareq.id], function (err, result) {
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
router.post('/deletecontact',function (req, res) {
    var datareq = req.body;
    
  
    
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "delete from `contact` where id=? ";
                connection.query(queryInsertUser, [datareq.id], function (err, result) {
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
///////////////////////Contact
router.post('/getpartner', function(req, res) {
    var datareq = req.body;
   var record=datareq.record;
    if(record==undefined){
        record=10;
    }
	var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
      var queryCount="";

        queryCount = "Select count(*) as 'total' from partner";

        connection.query(queryCount, [], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from partner";
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
			else{
				  res.send(core.notexist(datareq));
			}
		})
	 })
});
router.post('/createpartner',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("partner"), req.body);  
    connect.ConnectMainServer(function (connection) {
        var queryString="SELECT * FROM `partner` WHERE name=?";
        connection.query(queryString,[datareq.name],function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }
            if (rows.length == 0) {
			
			 
                var queryInsertUser = "INSERT INTO `partner` SET ?";
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
					    res.send(core.fail());//1001
				   }
                    
                });
            }
            else {
				
				 res.send(core.exist());//1002
            }
        })

    });
});
router.post('/udpatepartner',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("partner"), req.body);
   
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "update `partner` SET ? where id=? ";
                connection.query(queryInsertUser, [datareq,datareq.id], function (err, result) {
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
router.post('/deletepartner',function (req, res) {
    var datareq = req.body;
    
  
    
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "delete from `partner` where id=? ";
                connection.query(queryInsertUser, [datareq.id], function (err, result) {
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
router.post('/udpatecontactvisible',function (req, res) {
    var datareq = req.body;
   
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "update `contact` SET visible=? where id=? ";
                connection.query(queryInsertUser, [datareq.visible,datareq.id], function (err, result) {
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
router.post('/udpatepartnervisible',function (req, res) {
    var datareq = req.body;
   
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "update `partner` SET visible=? where id=? ";
                connection.query(queryInsertUser, [datareq.visible,datareq.id], function (err, result) {
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
router.post('/udpatenewsvisible',function (req, res) {
    var datareq = req.body;
   
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "update `news` SET visible=? where idnews=? ";
                connection.query(queryInsertUser, [datareq.visible,datareq.idnews], function (err, result) {
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
router.post('/udpatevideovisible',function (req, res) {
    var datareq = req.body;
   datareq.createdate=new Date(parseInt(datareq.createdate))
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "update activity SET visible=?, createdate=? where idac=? ";
                connection.query(queryInsertUser, [datareq.visible,datareq.createdate,datareq.idac], function (err, result) {
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
router.post('/udpatevideolqvisible',function (req, res) {
    var datareq = req.body;
   datareq.createdatevi=new Date(parseInt(datareq.createdatevi))
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "update videoactivity SET visible=?, createdatevi=? where idvi=? ";
                connection.query(queryInsertUser, [datareq.visible,datareq.createdatevi,datareq.idvi], function (err, result) {
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
///works
router.post('/getworks', function(req, res) {
    var datareq = req.body;
   var record=datareq.record;
    if(record==undefined){
        record=10;
    }
	var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
      var queryCount="";

        queryCount = "Select count(*) as 'total' from workfarmer";

        connection.query(queryCount, [], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from workfarmer limit ?, "+record;
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
			else{
				  res.send(core.notexist(datareq));
			}
		})
	 })
});
router.post('/udpateworksvisible',function (req, res) {
    var datareq = req.body;
   
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "update `workfarmer` SET visible=? where idw=? ";
                connection.query(queryInsertUser, [datareq.visible,datareq.idw], function (err, result) {
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

router.post('/deleteworks',function (req, res) {
    var datareq = req.body;
    
  
    
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "delete from `workfarmer` where idw=? ";
                connection.query(queryInsertUser, [datareq.idw], function (err, result) {
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
router.post('/createworks',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("workfarmer"), req.body);  
    connect.ConnectMainServer(function (connection) {
        var queryString="SELECT * FROM `workfarmer` WHERE namew=?";
        connection.query(queryString,[datareq.namew],function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }
            if (rows.length == 0) {
			
			 
                var queryInsertUser = "INSERT INTO `workfarmer` SET ?";
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
					    res.send(core.fail());//1001
				   }
                    
                });
            }
            else {
				
				 res.send(core.exist());//1002
            }
        })

    });
});
router.post('/udpateworks',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("workfarmer"), req.body);
    
    connect.ConnectMainServer(function (connection) {
       
                var queryInsertUser = "update `workfarmer` SET ? where idw=? ";
                connection.query(queryInsertUser, [datareq,datareq.idw], function (err, result) {
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
