express = require('express');
var router = express.Router();
var core=require('./core');
var connect=require('./connect');
//var connect2=require('./connect2');
var SHA256 = require("crypto-js/sha256");

router.post('/updateinfouser_user',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("users"),req.body);
    if(datareq) {
        connect.ConnectMainServer(function (connection) {
            var getstatusstring = "UPDATE `users` SET ? WHERE ?";
            connection.query(getstatusstring, [datareq,{iduser:datareq.iduser}],function (err, result) {
                if(err) {res.send(core.error(err.message));console.log(err); return;}
                res.send(core.success());
            });
        });
    }else{
        res.send(core.nonedata());
    }
});


router.post('/register',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("users"),req.body);
    if(!core.allDataRequestExist(datareq,["username","password"])){
        res.send(core.nonedata());
        return;
    }
    datareq.password=SHA256(datareq.password).toString();

    // datareq.lock=1;//moi dang ky tai khoang se bi khoa
    connect.ConnectMainServer(function (connection) {
        var queryString="SELECT * FROM `users` WHERE ?";
        connection.query(queryString,{username:datareq.username},function (err, rows) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            if(rows.length>0){
                res.send(core.exist(datareq));
            }else{
                insertUser();
            }
        });
        function insertUser () {
            var queryInsertUser="INSERT INTO `users` SET ?";
            connection.query(queryInsertUser,datareq,function (err, result) {
                if(err) {res.send(core.error(err.message));console.log(err); return;}
                datareq.iduser=result.insertId;
                datareq=core.convertDateToMilisecond(datareq);
                res.send(core.success(datareq));
            });
        }
    });
});

router.post('/getfeedback',function (req, res) {
    var datareq = req.body;

    var page=datareq.page;
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }
    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from feedback";

        connection.query(queryCount, [], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select * from feedback order by createtime desc limit ?,"+record;
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

router.post('/createfeedback',function (req, res) {
    var datareq = req.body;
    var page=datareq.page;
    var queryInsertUser = "INSERT INTO `feedback` SET ?";
    connect.ConnectMainServer(function (connection) {

        connection.query(queryInsertUser, datareq, function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }
            datareq.iduser = result.insertId;
            datareq = core.convertDateToMilisecond(datareq);
            res.send(core.success(datareq));
        });
    })
});

router.post('/checkregister',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("users"),req.body);
    if(!core.allDataRequestExist(datareq,["username","password"])){
        res.send(core.nonedata());
        return;
    }
    datareq.password=SHA256(datareq.password).toString();
    datareq.dateend=new Date((parseInt(datareq.createat)+(30*24*60*60*1000)));
    datareq.createat=new Date(parseInt(datareq.createat));

    // datareq.lock=1;//moi dang ky tai khoang se bi khoa
    connect.ConnectMainServer(function (connection) {
        var queryString="SELECT * FROM `users` WHERE ?";
        connection.query(queryString,{username:datareq.username},function (err, rows) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            if(rows.length>0){
                res.send(core.exist(rows[0]));
            }else{
                res.send(core.success(datareq));
            }
        });

    });
});

router.post('/changepassword',function (req, res) {
    var datareq = req.body;
    if(!core.allDataRequestExist(datareq,["passwordold","passwordnew"])){
        res.send(core.nonedata());
        return;
    }
    var dataupdate={
        passwordold:SHA256(datareq.passwordold).toString(),
        passwordnew:SHA256(datareq.passwordnew).toString()
    };

    connect.ConnectMainServer(function (connection) {
        var queryString="SELECT * FROM `users` WHERE `iduser`=? AND `password`=?";
        connection.query(queryString,[datareq.iduser,dataupdate.passwordold],function (err, rows) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            if(rows.length==0){
                res.send(core.notexist());
            }
            else if(rows.length>0) {
                var queryUpdateString = "UPDATE `users` SET `password`=? WHERE `iduser`=?";
                connection.query(queryUpdateString, [dataupdate.passwordnew,datareq.iduser], function (err, result) {
                    if (err) {
                        res.send(core.error(err.message));
                        console.log(err);
                        return;
                    }
                    res.send(core.success(datareq));
                });
            }
        });
    });
});

router.post('/login',function (req, res) {
    console.log("zi ","ok ");

    var datareq = core.fetchFieldsIfExist(core.getfield("users"),req.body);
    // console.log(datareq);
    if(!core.allDataRequestExist(datareq,["username","password"])){
        res.send(core.nonedata());
        return;
    }
    datareq.password=SHA256(datareq.password).toString();
    console.log("zi ","ok ");
    connect.ConnectMainServer(function (connection) {

        if(datareq.keyios!=null)
        {
            console.log(datareq.keyios)
            var updateUser="update `users` set `keyios`=JSON_ARRAY_INSERT(`keyios`,'$[0]',?) where username=? and password=? and JSON_CONTAINS(`keyios`,CONCAT('\"',?,'\"')) = 0";
            connection.query(updateUser,[datareq.keyios,datareq.username,datareq.password,datareq.keyios],function (err, rows) {
                if(err) {res.send(core.error(err.message));console.log(err); return;}
                var queryString="SELECT * FROM `users` WHERE `username` = ? AND `password` = ?";
                connection.query(queryString,[datareq.username,datareq.password],function (err, rows) {
                    if(err) {res.send(core.error(err.message));console.log(err); return;}
                    if(rows.length==0){
                        res.send(core.notexist(datareq));
                    }
                    if(rows.length>0){
                        var user = rows[0];

                        res.send(core.success(core.convertDateToMilisecond(user)));

                    }
                });
            });
        }
        else
        {
           // console.log(datareq.keyios+" add ");

            var queryString="SELECT `iduser`,`username`,`password`,`permission`,`detailname`,`phone`,`email` FROM `users` WHERE `username` = ? AND `password` = ?";
            connection.query(queryString,[datareq.username,datareq.password],function (err, rows) {
                if(err) {res.send(core.error(err.message));console.log(err); return;}
                if(rows.length==0){
                    res.send(core.notexist(datareq));
                }
                if(rows.length>0){
                    var user = rows[0];

                    res.send(core.success(core.convertDateToMilisecond(user)));

                }
            });
        }


    });
});
router.post('/loginweb',function (req, res) {
    var datareq = core.fetchFieldsIfExist(core.getfield("users"),req.body);
    // console.log(datareq);
    if(!core.allDataRequestExist(datareq,["username","password"])){
        res.send(core.nonedata());
        return;
    }
    datareq.password=SHA256(datareq.password).toString();
    connect.ConnectMainServer(function (connection) {
        var queryString="SELECT * FROM `users` WHERE `username` = ? AND `password` = ?";
        connection.query(queryString,[datareq.username,datareq.password],function (err, rows) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            if(rows.length==0){
                res.send(core.notexist(datareq));
            }
            if(rows.length>0){
                var user = rows[0];
				req.session.user=user;
                res.send(core.success(core.convertDateToMilisecond(user)));

            }
        });
    });
});
router.post('/logout',function (req, res) {
    var datareq = req.body;

    if(datareq.keyios!=null)
    {
        datareq.password=SHA256(datareq.password).toString();
        connect.ConnectMainServer(function (connection) {
            console.log(datareq.keyios)
            var updateUser = "update `users` set `keyios`=JSON_REMOVE(`keyios`,replace(JSON_SEARCH(`keyios`,'one',?), '\"', '')) where username=? and password=? and JSON_CONTAINS(`keyios`,CONCAT('\"',?,'\"')) = 1";
            connection.query(updateUser, [datareq.keyios, datareq.username, datareq.password, datareq.keyios], function (err, rows) {
                if (err) {
                    res.send(core.error(err.message));
                    console.log(err);
                    return;
                }
                if (req.session.user != undefined) {

                    req.session.destroy(function (err) {
                        if (err) {
                            res.send(core.error(err));
                            console.log(err);
                            return;
                        }
                        res.send(core.success());
                    });


                } else {
                    res.send(core.success());
                }
            });
        })
    }
    else
    {
        if(req.session.user!=undefined) {

            req.session.destroy(function (err) {
                if (err) {
                    res.send(core.error(err));
                    console.log(err);
                    return;
                }
                res.send(core.success());
            });


        }else{
            res.send(core.success());
        }
    }

});
module.exports = router;
