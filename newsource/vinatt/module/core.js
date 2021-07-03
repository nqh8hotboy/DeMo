//var moment=require('moment');
var code= {
    getfield: function (table) {
		var field_joinsanpham_nhapp = [
            "stt",
            "manpp",
			"idsp",
			"datetimejoin"
        ];
		var field_joinsanpham_nhasoche = [
            "stt",
            "mansc",
			"idsp",
			"datetimejoin"
        ];
		var field_joinsanpham_nhavc = [
            "stt",
            "manvc",
			"idsp",
			"datetimejoin",
			"nametx",
			"phonetx",
			"biensopt"
        ];
		
		var field_contact= [
		"id",
            "phone",
            "codetext",
			"name",
			"visible",
			"avatar"
        ];
		var field_partner = [
            "id",
            "logo",
			"link",
			"name",
			"visible"
        ];
		var field_work = [
            "idw",
            "namew",
			"visible"
        ];
	var field_detailwork = [
	"id",
            "idwork",
           
		
			"listimg",
			"createdate",
			"qrcode",
			"type",
			"othercontent",
			"urlpdf"
        ];
	
        var field_users = [
            "iduser",
            "username",
            "password",
            "permission",
			"detailname",
			"phone",
			"email",
            "keyios"
        ];

        var field_dangkysp = [
            "idsp",
            "masp",
            "mancc",
            "manpp",
            "mansc",
			"manvc",
			"biensoxe",
            "mota",
            "ngaysx",
            "hansd",
			"lo",
          //  "listthuoc",
        //    "listphan",
            "listhinh",
            "thongtinsc",
            "thongtinpp",
			"tccs",
			"createdate",
			"expire",
			"iduser",
			"externallink",
			"linkqrcode",
			"rutgonlink"
        ];

        var field_sp = [
            "idsp",
            "masp",
            "tensp",
			"tensp_en",
            
            "maloaisp",
			"gia",
			"giachuoi",
			"giachuoi_en",
			"anhsp",
			"tendvt",
			"tendvt_en",
			"ispecial",
			"desc_vi",
			"desc_en",
			"visible"
        ];
	var field_loaisp = [
            "maloai",
            "tenloai",
			"tenloai_en",
			"hinhanh"
        ];
      

        var field_npp = [
            "manpp",
            "tennpp",
            "mst",
            "diachi",
            "sdt",
            "email",
            "website",
            "sofax",
            "facebook",
            "diadiem",
            "user",
			"lat",
			"lng"
        ];

        var field_ncc = [
            "mancc",
            "tenncc",
            "mst",
            "diachi",
            "sdt",
            "email",
            "website",
            "sofax",
            "facebook",
        
            "user",
			"lat",
			"lng"
        ];
	var field_nvc = [
            "manvc",
            "tennvc",
            "mst",
            "diachi",
            "sdt",
            "email",
            "website",
            "sofax",
            "facebook",
        
            "user",
			"lat",
			"lng"
        ];

        var field_nsc = [
            "mansc",
            "tennsc",
            "mst",
            "diachi",
            "sdt",
            "email",
            "website",
            "sofax",
            "facebook",
            "diadiem",
            "thongtincssc",
            "user",
			"lat",
			"lng",
			"tccs"
			
        ];
		var field_land = [
            "iduser",
			"codeland",
			"namealias",
			"arealand",
			
			"posland",
			"createatland",
			"imgland"
            
        ];
		var field_libra = [
            "id",
			"listimage",
			"create_img",
			"idusertao"
            
        ];
		var field_certification = [
            "idcert",
			"certname"
            
        ];
		//cay trong 
		var field_trees = [
            "idtree",
			"nametree",
			"imgtree",
			"idtypetree"
            
        ];
		var field_areaproduct = [
            "idarea",
			"idtree",
			"iduser",
			"idcert",
			"datecert",
			"datecertexpire",
			"area",
			"createatarea",
			"date_end_area",
			"date_begin_area",
			"expected_productivity",
			"expected_quantity",
			"productivity",
			"quantity",
			"codeland"
            
        ];
		var field_news = [
            "idnews",
			"title_vi",
			"title_en",
			"content_vi",
			"content_en",
			"create_date",
			"urlimg",
			"iduser",
			"short_description_vi",
			"short_description_en",
			"visible"
            
        ];
		var field_intro = [
            "idintro",
			"contentintro_vi",
			"contentintro_en",
			"listimg"
            
        ];
		var field_activity = [
            "idac",
			"name_vi",
			"name_en",
			"createdate",
			"urlac",
			"idusertao",
			"visible"
            
        ];
		var field_videoactivity = [
            "idvi",
			"urlvideo",
			"idac",
			"createdatevi",
			"name_vilq",
			"name_enlq",
			"idusertao",
			"visible"
            
        ];
		var field_imageactivity = [
            "id",
			"urlimg",
			"create_date"
            
        ];
		var field_history = [
            "id",
			"iduser",
			"create_date",
			"link",
			"lat",
			"lng"
            
        ];
        switch (table) {
			case "joinnvc":
                return field_joinsanpham_nhavc;
				break;
			case "joinnsc":
                return field_joinsanpham_nhasoche;
				break;
			case "joinnhapp":
                return field_joinsanpham_nhapp;
				break;
			case "contact":
                return field_contact;
				break;
			case "partner":
                return field_partner;
				break;
			case "historyuser":
                return field_history;
				break;
			case "libra":
                return field_libra;
				break;
			case "imageactivity":
                return field_imageactivity;
				break;
			case "activityvideo":
                return field_videoactivity;
				break;
			case "activity":
                return field_activity;
				break;
			case "introducecompany":
                return field_intro;
				break;
			
            case "users":
                return field_users;
				break;
            case "sanpham":
                return field_sp;
				break;
            
				 case "loaisp":
                return field_loaisp;
				break;
           
            case "dangkysp":
                return field_dangkysp;
				break;
            case "npp":
                return field_npp;
				break;
            case "nsc":
                return field_nsc;
				break;
            case "ncc":
                return field_ncc;
                break;
			case "nvc":
                return field_nvc;
                break;
				 case "lands":
                return field_land;
                break;
			case "cert":
                return field_certification;
                break;
			case "trees":
                return field_trees;
                break;
			case "areaproduct":
                return field_areaproduct;
                break;
			case "news":
                return field_news;
                break;
			case "workfarmer":
                return field_work;
                break;
			case "detailworkfarmer":
                return field_detailwork;
                break;
        }
    },
    allDataRequestExist: function (datareq, array) {
        for (i in array) {
            var checkexist = false;
            // console.log(array[i]);
            for (j in datareq) {
                if (j == array[i]) {
                    checkexist = true;
                    break;
                }
            }
            if (!checkexist) {
                return false;
                break;
            }
        }
        return true;
    },
    fetchFieldsIfExist: function (arrayfield, datareq) {
        var data = {};
        for (i in datareq) {
            for (j in arrayfield) {
                if (i == arrayfield[j]) {
                    data[i] = datareq[i];
                    break;
                }
            }
        }
        return data;
    },

    getDate: function (str) {//lấy ngày giờ từ chuổi timestamp
        var date = new Date(str);
        var d = date.getDate() < 10 ? "0" + date.getDate() : date.getDate();
        var m = (date.getMonth() + 1) < 10 ? "0" + (date.getMonth() + 1) : (date.getMonth() + 1);
        var y = date.getFullYear() < 10 ? "0" + date.getFullYear() : date.getFullYear();
        return d + "/" + m + "/" + y;
    },
    getDateTime: function (str) {//lấy ngày giờ từ chuổi timestamp
        var date = new Date(str);
        var d = date.getDate() < 10 ? "0" + date.getDate() : date.getDate();
        var m = (date.getMonth() + 1) < 10 ? "0" + (date.getMonth() + 1) : (date.getMonth() + 1);
        var y = date.getFullYear() < 10 ? "0" + date.getFullYear() : date.getFullYear();
        var h = date.getHours() < 10 ? "0" + date.getHours() : date.getHours();
        var mu = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes();
        var ss = date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds();
        return d + "-" + m + "-" + y + " " + h + ":" + mu + ":" + ss
    },
    getDateNow: function () {
        return new Date().setHours(0, 0, 0, 0).toString().replace("00000", "");
    },
    getDateTimeNow: function () {
        var date = new Date();
        var d = date.getDate() < 10 ? "0" + date.getDate() : date.getDate();
        var m = (date.getMonth() + 1) < 10 ? "0" + (date.getMonth() + 1) : (date.getMonth() + 1);
        var y = date.getFullYear() < 10 ? "0" + date.getFullYear() : date.getFullYear();
        var h = date.getHours() < 10 ? "0" + date.getHours() : date.getHours();
        var mu = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes();
        return d + "-" + m + "-" + y + " " + h + ":" + mu
    },
    decodeDateFromString: function (stringDateMillisecond) {
        return new Date(parseInt(stringDateMillisecond) * 1000000);
    },
    randomcharacters: function (number) {
        var text = "";
        var possible = "abcdefghijklmnopqrstuvwxyz0123456789";

        for (var i = 0; i < number; i++)
            text += possible.charAt(Math.floor(Math.random() * possible.length));

        return text;
    },
    randomnumber: function (number) {
        var text = "";
        var possible = "0123456789";

        for (var i = 0; i < number; i++)
            text += possible.charAt(Math.floor(Math.random() * possible.length));

        return text;
    },
    data: function (datares, code, message) {
        if (datares == undefined) {
            datares = {};
        }
        return {
            data: datares,
            code: code,
            message: message
        }
    },
    checkSession: function (req, res, next) {
        if (req.session.user != undefined) {
            next();
        } else {
            res.send(code.nologin());
        }
    },
    checkSessionSchedules: function (req, res, next) {
        if (req.session.user != undefined) {
            next();
        } else if (req.session.useroftour != undefined) {
            if (req.session.useroftour.permission == 0) {
                res.send(code.nopermission());
            } else {
                next();
            }
        } else {
            res.send(code.nologin());
        }
    },
    checkSessionUser: function (req, res, next) {
        console.log(req.session.user);
        if (req.session.user != undefined) {
            if (req.session.user.permission == 3) {
                next();
            }
            else {
                res.send(code.nopermission());
            }
        } else {
            res.send(code.nologin());
        }
    },
    checkSessionAdmin: function (req, res, next) {
        if (req.session.user != undefined) {
            if (req.session.user.permission == 1) {
                next();
            }
            else {
                res.send(code.nopermission());
            }
        } else {
            res.send(code.nologin());
        }
    },
    checkSessionManager: function (req, res, next) {
        if (req.session.user != undefined) {
            if (req.session.user.permission == 2) {
                next();
            }
            else {
                res.send(code.nopermission());
            }
        } else {
            res.send(code.nologin());
        }
    },
    checkSessionRoot: function (req, res, next) {
        if (req.session.user != undefined) {
            if (req.session.user.permission == 0) {
                next();
            }
            else {
                res.send(code.nopermission());
            }
        } else {
            res.send(code.nologin());
        }
    },
    convertDateToMilisecond: function (data) {
        if (data instanceof Array) {
            for (i in data) {
                data[i] = code.convertDateToMilisecond(data[i]);
            }
            return data;
        }
        if (data instanceof Object) {
            for (i in data) {
                if (data[i] instanceof Date) {
                    if (i != "birthday") {
                        data[i] = data[i].getTime();
                    } else {
                        data[i] = moment(data[i]).format('DD-MM-YYYY');
                    }
                }
            }
            return data;
        }
    },
    getUsernameFromReqSession: function (req) {
        if (req.session.user) {
            return req.session.user.username;
        }
        else if (req.session.useroftour) {
            return req.session.useroftour.username;
        }
    },
    getUserFromReqSession: function (req) {
        if (req.session.user) {
            return req.session.user;
        } else {
            return undefined;
        }

    },
    openMyRoom: function (id) {
        return "Room-user-" + id;
    },
    openTourRoom: function (id) {
        return "Room-tour-" + id;
    },
    success: function (data) {
        return code.data(data, "1000");
    },
    fail: function (data) {
        return code.data(data, "1001");
    },
    exist: function (data) {
        return code.data(data, "1002");
    },
    notexist: function (data) {
        return code.data(data, "1003");
    },
    nonedata: function (data) {
        return code.data(data, "1004");
    },
    nopermission: function (data) {
        return code.data(data, "1005");
    },
    toolimited: function (data) {
        return code.data(data, "1006");
    },
    nologin: function (data) {
        return code.data(data, "9998");
    },
    error: function (data) {
        return code.data(data, "9999");
    },
    nofinish: function (data) {
        return code.data(data, "8888");
    }
};
Number.isInteger = Number.isInteger || function(value) {
        return typeof value === 'number' &&
            isFinite(value) &&
            Math.floor(value) === value;
    };
module.exports=code;
