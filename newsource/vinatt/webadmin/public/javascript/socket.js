var connect=require('./connect');
var core = require('./core');
module.exports = function(app, io) {
    io.on('connection', function(socket) {
        socket.on("join-myroom",function (username) {
            console.log("join "+core.openMyRoom(username));
            socket.iduser=username;
            socket.join(core.openMyRoom(username));

        });


        socket.on("leave-myroom",function (username) {
            console.log("leave "+core.openMyRoom(username));
            socket.leave(core.openMyRoom(username));
        });

        socket.on("disconnect",function () {
            console.log("disconnect "+socket.iduser);
        });
    });
};