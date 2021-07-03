var connect=require('./connect');
var core = require('./core');
module.exports = function(app, io) {
    io.on('connection', function(socket) {
        socket.on("join-myroom",function (iduser) {
            console.log("join "+core.openMyRoom(iduser));
            socket.iduser=iduser;
            socket.join(core.openMyRoom(iduser));

        });


        socket.on("leave-myroom",function (iduser) {
            console.log("leave "+core.openMyRoom(iduser));
            socket.leave(core.openMyRoom(iduser));
        });

        socket.on("disconnect",function () {
            console.log("disconnect "+socket.iduser);
        });
    });
};