express = require('express');
var router = express.Router();
var core=require('./core');
var connect=require('./connect');

router.post('/createroom',function (req, res) {
    var datareq = req.body;
    if(!core.allDataRequestExist(datareq,["listuser","type"])){
        res.send(core.nonedata());
        return;
    }
    connect.ConnectMainServer(function (connection) {

        var queryInsert = "INSERT INTO `phongchat` SET ?";
        connection.query(queryInsert, datareq, function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }
            datareq.id = result.insertId;



                var resul=JSON.parse(datareq.listuser);
                var list=[];
                for(var i=0;i<resul.length;i++)
                {
                    var user={
                        iduser:parseInt(resul[i]),
                        issend:0
                    }
                    list.push(user)
                }
                var datapush = {
                    content: JSON.stringify(core.convertDateToMilisecond(datareq)),
                    key: "onnewroom",
                    receiver: JSON.stringify(list)
                }
                var queryInsertPush = "INSERT INTO `pushnotification` SET ?";
                connection.query(queryInsertPush, datapush, function (err, result) {
                    if (err) {
                        console.log(err);
                        return;
                    }
                    datapush.id=result.insertId;
                    console.log(resul)
                    for(var i in resul)
                    {
                        req.io.to(core.openMyRoom(resul[i])).emit("onnewmessage",  core.convertDateToMilisecond(datapush));
                        console.log("key iduser "+resul[i])

                        core.getKeyIOS(resul[i],function (resp) {
                            console.log("key reps "+JSON.stringify(resp))

                            if(resp!=undefined) {
                                var respo = JSON.parse(resp.keyios);

                                for (var j in respo) {
                                    console.log("key ios "+respo[j])

                                    core.pushNotificationIOS(datapush, "Có tin nhắn mới", respo[j], req)
                                }
                            }
                        })
                    }

                    datareq = core.convertDateToMilisecond(datareq);
                    res.send(core.success(datareq));
                });

                // res.send(core.success(datareq));
            });



    });
});

router.post('/sendmessage',function (req, res) {
    var datareq = req.body;
    if(!core.allDataRequestExist(datareq,["idphong","nguoigui","noidung"])){
        res.send(core.nonedata());
        return;
    }
    var person=datareq;
    if(person.ngaytao!=undefined)
    {
        person.ngaytao=new Date(parseInt(person.ngaytao))
    }
    connect.ConnectMainServer(function (connection) {
        var insertschedule="INSERT INTO `message` SET ? ";
        connection.query(insertschedule,person,function (err, result) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}

            var queryString = "SELECT *,getphong(idphong,?) as 'phong',(select infouser from users where iduser=m.nguoigui) as 'user',(select listuser from phongchat where id=m.idphong) as 'listuser' from `message` m where idphong = ? and nguoigui=? order by ngaytao desc limit 0,1";
            connection.query(queryString, [datareq.nguoigui,datareq.idphong,datareq.nguoigui], function (errr, rows) {
                if (errr) {
                    res.send(core.error(errr.message));
                    console.log(errr);
                    return;
                }
                var resul=JSON.parse(rows[0].listuser);
                var list=[];
                for(var i=0;i<resul.length;i++)
                {
                    var user={
                        iduser:parseInt(resul[i]),
                        issend:0
                    }
                    list.push(user)
                }
                var datapush = {
                    content: JSON.stringify(core.convertDateToMilisecond(rows[0])),
                    key: "onnewmessage",
                    receiver: JSON.stringify(list)
                }
                var queryInsertPush = "INSERT INTO `pushnotification` SET ?";
                connection.query(queryInsertPush, datapush, function (err, result) {
                    if (err) {
                        console.log(err);
                        return;
                    }
                    datapush.id=result.insertId;
                    console.log(resul)
                    for(var i in resul)
                    {
                        req.io.to(core.openMyRoom(resul[i])).emit("onnewmessage",  core.convertDateToMilisecond(datapush));
                        console.log("key iduser "+resul[i])

                        core.getKeyIOS(resul[i],function (resp) {
                            console.log("key reps "+JSON.stringify(resp))

                            if(resp!=undefined) {
                                var respo = JSON.parse(resp.keyios);

                                for (var j in respo) {
                                    console.log("key ios "+respo[j])

                                    core.pushNotificationIOS(datapush, "Có tin nhắn mới", respo[j], req)
                                }
                            }
                        })
                    }

                    res.send(core.success( core.convertDateToMilisecond(rows[0])))

                });

                // res.send(core.success(datareq));
            });

        });
    })
});

router.post('/getphongchat', function(req, res) {
    var datareq = req.body;

    if(!core.allDataRequestExist(datareq,["iduser"])){
        res.send(core.nonedata());
        return;
    }
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

        queryCount = "Select count(*) as 'total' from users u where iduser<>convert(?,int) and getValueJSON(u.infouser,'ten') like ?";

        connection.query(queryCount, [datareq.iduser,charsearch], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select iduser,infouser as 'user',ifnull((select if(type=1,p.name,getValueJSON(u.infouser,'ten')) from phongchat p where json_contains(`listuser`,concat('\"',u.iduser,'\"')) and type=0 and json_contains(`listuser`,concat('\"',?,'\"'))),getValueJSON(u.infouser,'ten')) as 'name',ifnull((select id from phongchat p where json_contains(`listuser`,concat('\"',u.iduser,'\"')) and type=0 and json_contains(`listuser`,concat('\"',?,'\"'))),0) as 'id',ifnull((select getLastMessage(id) from phongchat p where json_contains(`listuser`,concat('\"',u.iduser,'\"')) and type=0 and json_contains(`listuser`,concat('\"',?,'\"'))),'{}') as 'lastmessage',(select (select ngaytao from message where idphong=p.id order by ngaytao desc limit 0,1) from phongchat p where json_contains(`listuser`,concat('\"',u.iduser,'\"')) and type=0 and json_contains(`listuser`,concat('\"',?,'\"'))) as 'lasttime' from users u where u.iduser<>convert(?,int) and getValueJSON(u.infouser,'ten') like ? order by (select (select ngaytao from message where idphong=p.id order by ngaytao desc limit 0,1) from phongchat p where json_contains(`listuser`,concat('\"',u.iduser,'\"')) and type=0 and json_contains(`listuser`,concat('\"',?,'\"'))) desc, REVERSE(SUBSTRING_INDEX(REVERSE(getValueJSON(infouser,'ten')), ' ', 1)) asc limit ?,"+record
                connection.query(queryString, [datareq.iduser,datareq.iduser,datareq.iduser,datareq.iduser,datareq.iduser,charsearch,datareq.iduser,page*record], function (err, rows) {
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


router.post('/getnhomchat', function(req, res) {
    var datareq = req.body;

    if(!core.allDataRequestExist(datareq,["iduser"])){
        res.send(core.nonedata());
        return;
    }
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

        queryCount = "Select count(*) as 'total' from phongchat p where json_contains(listuser,concat('\"',?,'\"')) and type=1 and name like ?";

        connection.query(queryCount, [datareq.iduser,charsearch], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "select *,getLastMessage(id) as 'lastmessage',(select ngaytao from message where idphong=p.id order by ngaytao desc limit 0,1 ) as 'lasttime' from phongchat p where json_contains(listuser,concat('\"',?,'\"'))  and type=1 and name like ? order by lasttime desc ,name asc limit ?,"+record
                connection.query(queryString, [datareq.iduser,charsearch,page*record], function (err, rows) {
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



router.post('/getallnhom', function(req, res) {
    var datareq = req.body;

    if(!core.allDataRequestExist(datareq,["iduser"])){
        res.send(core.nonedata());
        return;
    }
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

        queryCount = "Select count(*) as 'total' from phongchat p where json_contains(listuser,concat('\"',?,'\"')) and type=1 and name like ?";

        connection.query(queryCount, [datareq.iduser,charsearch], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "select *,getLastMessage(id) as 'lastmessage',(select ngaytao from message where idphong=p.id order by ngaytao desc limit 0,1 ) as 'lasttime' from phongchat p where json_contains(listuser,concat('\"',?,'\"'))  and type=1 and name like ? order by lasttime desc ,name asc "
                connection.query(queryString, [datareq.iduser,charsearch], function (err, rows) {
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


router.post('/getallroom', function(req, res) {
    var datareq = req.body;

    if(!core.allDataRequestExist(datareq,["iduser"])){
        res.send(core.nonedata());
        return;
    }
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

        queryCount = "Select count(*) as 'total' from users u where iduser<>convert(?,int) and getValueJSON(u.infouser,'ten') like ?";

        connection.query(queryCount, [datareq.iduser,charsearch], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "Select iduser,infouser as 'user',ifnull((select if(type=1,p.name,getValueJSON(u.infouser,'ten')) from phongchat p where json_contains(`listuser`,concat('\"',u.iduser,'\"')) and type=0 and json_contains(`listuser`,concat('\"',?,'\"'))),getValueJSON(u.infouser,'ten')) as 'name',ifnull((select id from phongchat p where json_contains(`listuser`,concat('\"',u.iduser,'\"')) and type=0 and json_contains(`listuser`,concat('\"',?,'\"'))),0) as 'id',ifnull((select getLastMessage(id) from phongchat p where json_contains(`listuser`,concat('\"',u.iduser,'\"')) and type=0 and json_contains(`listuser`,concat('\"',?,'\"'))),'{}') as 'lastmessage',(select (select ngaytao from message where idphong=p.id order by ngaytao desc limit 0,1) from phongchat p where json_contains(`listuser`,concat('\"',u.iduser,'\"')) and type=0 and json_contains(`listuser`,concat('\"',?,'\"'))) as 'lasttime' from users u where u.iduser<>convert(?,int) and getValueJSON(u.infouser,'ten') like ? order by lasttime desc, REVERSE(SUBSTRING_INDEX(REVERSE(getValueJSON(infouser,'ten')), ' ', 1)) asc "
                connection.query(queryString, [datareq.iduser,datareq.iduser,datareq.iduser,datareq.iduser,datareq.iduser,charsearch], function (err, rows) {
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

router.post('/getmessage', function(req, res) {
    var datareq = req.body;

    if(!core.allDataRequestExist(datareq,["idphong"])){
        res.send(core.nonedata());
        return;
    }
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

    var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "Select count(*) as 'total' from message where idphong=?";

        connection.query(queryCount, [datareq.idphong], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "(SELECT *,getListUserSeen(listseen) as 'listseen',(select infouser from users where iduser=m.nguoigui) as 'user',(select listuser from phongchat where id=m.idphong) as 'listuser' from `message` m where  idphong=? order by ngaytao desc limit ?,?) order by ngaytao asc";
                connection.query(queryString, [datareq.idphong,page*record,record], function (err, rows) {
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


router.post('/getmessageall', function(req, res) {
    var datareq = req.body;

    if(!core.allDataRequestExist(datareq,["iduser"])){
        res.send(core.nonedata());
        return;
    }
    var record=datareq.record;
    if(record==undefined){
        record=10;
    }

    datareq.iduser=parseInt(datareq.iduser)
    var page=datareq.page;

    connect.ConnectMainServer(function (connection) {
        var queryCount="";

        queryCount = "SELECT count(*) as  'total' FROM message m where m.id in (SELECT b.id FROM message b  WHERE (SELECT COUNT(*) FROM message  c WHERE c.idphong = b.idphong AND c.ngaytao <= b.ngaytao) <= 10 and idphong in (select id from phongchat where type=? and json_contains(listuser,concat('\"',?,'\"'))) GROUP BY b.idphong) ORDER BY m.idphong desc, m.ngaytao DESC";

        connection.query(queryCount, [datareq.type,datareq.iduser], function (err, rows) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            var total = rows[0].total;
            if (total > 0) {

                var queryString = "SELECT *,getListUserSeen(listseen) as 'listseen',(select infouser from users where iduser=m.nguoigui) as 'user',(select listuser from phongchat where id=m.idphong) as 'listuser' from `message` m where m.id in (SELECT b.id FROM message b,(select id from phongchat p where type=? and json_contains(listuser,concat('\"',?,'\"')) order by (select max(ngaytao) from message k where k.idphong=p.id) desc ,name asc limit ?,10) i  WHERE (SELECT COUNT(*) FROM message  c WHERE c.idphong = b.idphong AND c.ngaytao <= b.ngaytao) <= 10 and i.id=b.idphong GROUP BY b.idphong) ORDER BY m.idphong desc, m.ngaytao DESC ";
                connection.query(queryString, [datareq.type,datareq.iduser,page*record], function (err, rows) {
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

router.post('/updateroom',function (req, res) {
    var datareq = req.body;

    connect.ConnectMainServer(function (connection) {
        var insertschedule="update `phongchat` set ? where id=?";
        connection.query(insertschedule,[datareq,datareq.id],function (err, result) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            res.send(core.success(datareq));

        });
    })
});


router.post('/updatelistseen',function (req, res) {
    var datareq = req.body;

    connect.ConnectMainServer(function (connection) {
        var insertschedule="update `message` set listseen=updateListSeen(listseen,?,?) where id=?";
        connection.query(insertschedule,[datareq.iduser,datareq.status,datareq.id],function (err, result) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            var queryString = "select listuser,p.id as 'id',getListUserSeen(listseen) as 'listseen' from phongchat p,message m where p.id=m.idphong and  m.id=?";
            connection.query(queryString,[datareq.id],function (err, result) {
                var resul=[] ;
                var u={};
                if(result.length>0) {
                    u ={ listseen:result[0].listseen,
                    idphong:result[0].id,
                    id:datareq.id};
                    resul = JSON.parse(result[0].listuser);
                }
                var list = [];
                for (var i = 0; i < resul.length; i++) {
                    var user = {
                        iduser: parseInt(resul[i]),
                        issend: 0
                    }
                    list.push(user)
                }
                var datapush = {
                    content: JSON.stringify(u),
                    key: "onseen",
                    receiver: JSON.stringify(list)
                }
                var queryInsertPush = "INSERT INTO `pushnotification` SET ?";
                connection.query(queryInsertPush, datapush, function (err, result) {
                    if (err) {
                        console.log(err);
                        return;
                    }
                    datapush.id = result.insertId;
                    console.log(resul)
                    for (var i in resul) {
                        req.io.to(core.openMyRoom(resul[i])).emit("onnewmessage", core.convertDateToMilisecond(datapush));
                        console.log("key iduser " + resul[i])

                        core.getKeyIOS(resul[i], function (resp) {
                            console.log("key reps " + JSON.stringify(resp))

                            if (resp != undefined) {
                                var respo = JSON.parse(resp.keyios);

                                for (var j in respo) {
                                    console.log("key ios " + respo[j])

                                    core.pushNotificationIOS(datapush, "", respo[j], req)
                                }
                            }
                        })
                    }
                    res.send(core.success(core.convertDateToMilisecond(datareq)))

                });
            })

        });
    })
});


router.post('/updateseenall',function (req, res) {
    var datareq = req.body;

    console.log(datareq)
    connect.ConnectMainServer(function (connection) {
        var queryString = "select id from message where nguoigui <>? and  idphong=? and json_contains(listseen,json_object('iduser',concat(?,''),'isseen',convert(?,int)))=0 and json_contains(listseen,json_object('iduser',concat(?,''),'isseen',convert(1,int)))=0";
        connection.query(queryString,[datareq.iduser,datareq.id,datareq.iduser,datareq.status,datareq.iduser],function (err, result) {
            var id=result;
            console.log(JSON.stringify(id))
        var insertschedule="update `message` set listseen=updateListSeen(listseen,?,?) where idphong=? and nguoigui <> ?";
        connection.query(insertschedule,[datareq.iduser,datareq.status,datareq.id,datareq.iduser],function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }
            var queryString = "select listuser,p.id as 'idphong',m.id as 'id',getListUserSeen(listseen) as 'listseen' from phongchat p,message m where p.id=m.idphong and nguoigui<>? and m.idphong=? and  json_contains(?,Json_object('id',convert(m.id,int)))";
            connection.query(queryString, [datareq.iduser, datareq.id,JSON.stringify(id)], function (err, result) {
                var resul=[];
                var ulist=[];
                if(result.length>0) {
                    for(var i=0;i<result.length;i++)
                    {
                        var u ={ listseen:result[i].listseen,
                            idphong:result[i].idphong,
                            id:result[i].id};
                        ulist.push(u)
                    }

                    resul = JSON.parse(result[0].listuser);
                }
                var list = [];
                if(resul.length>0) {
                    for (var i = 0; i < resul.length; i++) {
                        var user = {
                            iduser: parseInt(resul[i]),
                            issend: 0
                        }
                        list.push(user)
                    }
                    var datapush = {
                        content: JSON.stringify(ulist),
                        key: "onseenall",
                        receiver: JSON.stringify(list)
                    }
                    var queryInsertPush = "INSERT INTO `pushnotification` SET ?";
                    connection.query(queryInsertPush, datapush, function (err, result) {
                        if (err) {
                            console.log(err);
                            return;
                        }
                        datapush.id = result.insertId;
                        console.log(resul)
                        for (var i in resul) {
                            req.io.to(core.openMyRoom(resul[i])).emit("onnewmessage", core.convertDateToMilisecond(datapush));
                            console.log("key iduser " + resul[i])

                            core.getKeyIOS(resul[i], function (resp) {
                                console.log("key reps " + JSON.stringify(resp))

                                if (resp != undefined) {
                                    var respo = JSON.parse(resp.keyios);

                                    for (var j in respo) {
                                        console.log("key ios " + respo[j])

                                        core.pushNotificationIOS(datapush, "", respo[j], req)
                                    }
                                }
                            })
                        }
                        res.send(core.success(core.convertDateToMilisecond(datareq)))

                    });
                }
                else
                {
                    res.send(core.success(core.convertDateToMilisecond(datareq)))

                }
            })
        })

        });
    })
});


router.post('/deletemessage',function (req, res) {
    var datareq = req.body;

    connect.ConnectMainServer(function (connection) {
        var insertschedule="delete from `message` where id=?";
        connection.query(insertschedule,[datareq.id],function (err, result) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            res.send(core.success(datareq));

        });
    })
});


router.post('/updatepushnotify',function (req, res) {
    var datareq = req.body;
    var id=parseInt(datareq.id);
    

    connect.ConnectMainServer(function (connection) {
        var insertschedule="update `pushnotification` set receiver=updatePush(receiver,?,1) where id=?";
        connection.query(insertschedule,[datareq.iduser,datareq.id],function (err, result) {
            if(err) {res.send(core.error(err.message));console.log(err); return;}
            res.send(core.success(datareq));

        });
    })
});

router.post('/resendpushnotify',function (req, res) {
    var datareq = req.body;
    var id = parseInt(datareq.iduser);

    connect.ConnectMainServer(function (connection) {
        var insertschedule = "select * from `pushnotification` where ?=getPushNotification(?,receiver)";
        connection.query(insertschedule, [datareq.iduser, datareq.iduser], function (err, result) {
            if (err) {
                res.send(core.error(err.message));
                console.log(err);
                return;
            }

            for (var i = 0; i< result.length ; i++) {
                console.log(result[i]);
                console.log("---------------------------")

                req.io.to(core.openMyRoom(datareq.iduser)).emit("onnewmessage", core.convertDateToMilisecond(result[i]));
            }

            res.send(core.success());
        });
    })
});

module.exports = router;
