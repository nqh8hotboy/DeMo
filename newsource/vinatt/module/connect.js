var mysql = require("mysql");
// var db_config={
//     host: "115.74.177.1", //su dung ten mien di tu internet vao laf k dc nhe'
//     user: "agritel",
//     password: "123456",
//     database: "zadmin_agritel",
//     charset: 'utf8mb4'
// };
var db_config={
     host: "localhost", //192.168.100.29
     user: "root",
     password: "", //chính xác rồi
     database: "zadmin_vinatttrace",
     charset: 'utf8_vietnamese_ci'
 };
var pool  = mysql.createPool(db_config);
var connect={
    ConnectMainServer:function (callback) {
        pool.getConnection(function(err, connection) {
            callback(connection);
            connection.release();
			
			connection.on('error', function (err) {
                console.log("Loi"+err);
				connection.release();
			
                //res.json({"code": 200, "status": "Error", "message": "Error Checking Username Duplicate"});
                return;
            });
        });
		
    }
};
module.exports=connect;
