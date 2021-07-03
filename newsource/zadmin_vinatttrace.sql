-- phpMyAdmin SQL Dump
-- version 4.0.10.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 24, 2019 at 09:54 AM
-- Server version: 10.2.22-MariaDB
-- PHP Version: 5.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `zadmin_vinatttrace`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `calculteRate`(`jsonparam` LONGTEXT) RETURNS double
    NO SQL
BEGIN
 DECLARE x int;
 DECLARE js int;
 DECLARE id int;
 DECLARE total double;
 DECLARE star double ;
 DECLARE startotal double ;
 DECLARE l int;
	
  SET x = 0;
SET total=0.0;
SET star=0.0;
SET startotal=0.0;
SET l= (select JSON_LENGTH(jsonparam));

WHILE (x < l) DO
	SET star=json_extract(json_extract(jsonparam,concat('$[',x,']')),'$.sao');
	SET total=total+star;
	SET x=x+1;
END While;
if l>0 then
SET startotal=total/l;
end if;
RETURN startotal;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `checkIsPP`(`thongtinpp` LONGTEXT) RETURNS int(11)
    NO SQL
BEGIN
 DECLARE x int;
 DECLARE json longtext;
 DECLARE js int;
 DECLARE ob int;
 DECLARE l int;
	
SET x = 0;
SET l= (select JSON_LENGTH(thongtinpp));
SET ob=0;


test_loop : LOOP
IF x < l THEN
SET js=(select JSON_LENGTH(json_extract(json_extract(thongtinpp,  CONCAT('$[',x,']')),  '$.list')));

if js>0 then
	SET ob=1;
      LEAVE test_loop;
ELSE 
    SET x = x + 1;
END IF;
ELSE 
    LEAVE test_loop;
END IF;

END LOOP;

RETURN ob;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `checkIsPPByNPP`(`thongtinpp` LONGTEXT, `iduserpara` BIGINT) RETURNS int(11)
    NO SQL
BEGIN
 DECLARE x int;
 DECLARE json int;
 DECLARE js int;
 DECLARE ob int;
 DECLARE l int;
	
SET x = 0;
SET l= (select JSON_LENGTH(thongtinpp));
SET ob=0;
SET json=0;


test_loop : LOOP
IF x < l THEN
	SET json=CONVERT(substring(json_extract(json_extract(thongtinpp,  CONCAT('$[',x,']')),  '$.manpp'),2,5),int);
	if json=iduserpara then
		SET js=(select JSON_LENGTH(json_extract(json_extract(thongtinpp,  CONCAT('$[',x,']')),  '$.list')));
		if js>0 then
			SET ob=1;
     		LEAVE test_loop;
		END IF;	
	END IF;
    SET x = x + 1;

ELSE 
   LEAVE test_loop;
END IF;

END LOOP;

RETURN ob;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getIDNPPFromThongTinPP`(`iduserpara` BIGINT, `itemlist` LONGTEXT) RETURNS bigint(20)
    NO SQL
BEGIN
 DECLARE x int;
 DECLARE json longtext;
 DECLARE js int;
 DECLARE ob longtext;
 DECLARE l int;
	
  SET x = 0;
SET l= (select JSON_LENGTH(itemlist));



 test_loop : LOOP
IF x < l THEN
SET js=CONVERT(substring(json_extract(json_extract(itemlist,  CONCAT('$[',x,']')),  '$.manpp'),2,5),int);

SET json=concat(json,js);
if js=iduserpara then
      LEAVE test_loop;
ELSE 
    SET x = x + 1;
END IF;
ELSE 
	SET js=0;
    LEAVE test_loop;
END IF;

END LOOP;

RETURN js;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getInfoUser`(`iduserpara` INT) RETURNS longtext CHARSET utf8
    NO SQL
BEGIN
DECLARE data LONGTEXT;
SET data = IFNULL((SELECT distinct JSON_OBJECT(
    'iduser', r.`iduser`, 
    'detailname', r.`detailname`, 
    'phone', r.`phone`, 
    'email',`email`, 
    'permission', r.`permission`
)
FROM `users` r where r.`iduser` = iduserpara  ),'{}');
RETURN data;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getNCC`(`idnccpara` INT(5) UNSIGNED ZEROFILL) RETURNS longtext CHARSET utf8
    NO SQL
BEGIN
RETURN IFNULL((SELECT distinct JSON_OBJECT(
    'mancc', CONVERT(r.`mancc`,char(5)), 
    'tenncc', r.`tenncc`, 
    'mst', r.`mst`, 
    'diachi', r.`diachi`, 
    'sdt', r.`sdt`,
    'lat',r.`lat`,
    'lng',r.`lng`,
    'email', r.`email`,
    'website', r.`website`,
    'sofax', r.`sofax`,
    'facebook', r.`facebook`,
    
    'user', r.`user`
)
FROM `nhacungcap` r WHERE r.`mancc` = idnccpara), '{}');
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getNCCByIDUser`(`idnccpara` INT) RETURNS text CHARSET utf8
    NO SQL
BEGIN
RETURN IFNULL((SELECT distinct JSON_OBJECT(
    'mancc', CONVERT(r.`mancc`,char(5)), 
    'tenncc', r.`tenncc`, 
    'mst', r.`mst`, 
    'diachi', r.`diachi`, 
    'sdt', r.`sdt`,
    'lat',r.`lat`,
    'lng',r.`lng`,
    'email', r.`email`,
    'website', r.`website`,
    'sofax', r.`sofax`,
    'facebook', r.`facebook`,
    
    'user', r.`user`
)
FROM `nhacungcap` r WHERE r.`user` = idnccpara), '{}');
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getNPP`(`idnpppara` INT(5) UNSIGNED ZEROFILL) RETURNS longtext CHARSET utf8
    NO SQL
BEGIN
RETURN IFNULL((SELECT distinct JSON_OBJECT(
    'manpp', CONVERT(r.`manpp`,char(5)), 
    'tennpp', r.`tennpp`, 
    'mst', r.`mst`, 
    'diachi', r.`diachi`, 
    'sdt', r.`sdt`,
    'lat',r.`lat`,
    'lng',r.`lng`,
    'email', r.`email`,
    'website', r.`website`,
    'sofax', r.`sofax`,
    'facebook', r.`facebook`,
    'diadiem', r.`diadiem`,
    'user', r.`user`
)
FROM `nhapp` r WHERE r.`manpp` = idnpppara), '{}');
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getNPPByIDUser`(`idnpppara` INT) RETURNS text CHARSET utf8
    NO SQL
BEGIN
RETURN IFNULL((SELECT distinct JSON_OBJECT(
    'manpp', CONVERT(r.`manpp`,char(5)), 
    'tennpp', r.`tennpp`, 
    'mst', r.`mst`, 
    'diachi', r.`diachi`, 
    'sdt', r.`sdt`,
    'lat',r.`lat`,
    'lng',r.`lng`,
    'email', r.`email`,
    'website', r.`website`,
    'sofax', r.`sofax`,
    'facebook', r.`facebook`,
    'diadiem', r.`diadiem`,
    'user', r.`user`
)
FROM `nhapp` r WHERE r.`user` = idnpppara), '{}');
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getNSC`(`idnscpara` INT(5) UNSIGNED ZEROFILL) RETURNS longtext CHARSET utf8
    NO SQL
BEGIN
RETURN IFNULL((SELECT distinct JSON_OBJECT(
    'mansc',CONVERT(r.`mansc`,char(5)), 
    'tennsc', r.`tennsc`, 
    'mst', r.`mst`, 
    'diachi', r.`diachi`, 
    'sdt', r.`sdt`,
    'email', r.`email`,
    'website', r.`website`,
    'lat',r.`lat`,
    'lng',r.`lng`,
    'sofax', r.`sofax`,
    'facebook', r.`facebook`,
    'diadiem', r.`diadiem`,
    'thongtincssc', r.`thongtincssc`,
        'tccs', r.`tccs`,
    'user', r.`user`
)
FROM `nhasoche` r WHERE r.`mansc` = idnscpara), '{}');
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getNSCByIDUser`(`idnscpara` INT) RETURNS text CHARSET utf8
    NO SQL
BEGIN
RETURN IFNULL((SELECT distinct JSON_OBJECT(
    'mansc',CONVERT(r.`mansc`,char(5)), 
    'tennsc', r.`tennsc`, 
    'mst', r.`mst`, 
    'diachi', r.`diachi`, 
    'sdt', r.`sdt`,
    'email', r.`email`,
    'website', r.`website`,
    'lat',r.`lat`,
    'lng',r.`lng`,
    'sofax', r.`sofax`,
    'facebook', r.`facebook`,
    'diadiem', r.`diadiem`,
    'thongtincssc', r.`thongtincssc`,
    'tccs', r.`tccs`,
    'user', r.`user`
)
FROM `nhasoche` r WHERE r.`user` = idnscpara), '{}');
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getNVC`(`idnvcpara` INT UNSIGNED ZEROFILL) RETURNS longtext CHARSET utf8
    NO SQL
BEGIN
RETURN IFNULL((SELECT distinct JSON_OBJECT(
    'manvc', CONVERT(r.`manvc`,char(5)), 
    'tennvc', r.`tennvc`, 
    'mst', r.`mst`, 
    'diachi', r.`diachi`, 
    'sdt', r.`sdt`,
    'lat',r.`lat`,
    'lng',r.`lng`,
    'email', r.`email`,
    'website', r.`website`,
    'sofax', r.`sofax`,
    'facebook', r.`facebook`,
    
    'user', r.`user`
)
FROM `nhavc` r WHERE r.`manvc` = idnvcpara), '{}');
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getPriceFromOrder`(`idspparam` INT, `orderparam` LONGTEXT) RETURNS double
    NO SQL
BEGIN
 DECLARE x int;
 DECLARE js int;
 DECLARE id int;
 DECLARE total int;
 DECLARE price double ;
 DECLARE type longtext;
 DECLARE typestring longtext;
 DECLARE priceinfo longtext;
 DECLARE l int;
	
  SET x = 0;
SET total=0;
SET price=0.0;
SET type="";
SET typestring="";
SET priceinfo="0.0";
SET l= (select JSON_LENGTH(orderparam));

WHILE (x < l) DO
	SET id=CONVERT(substring(json_extract(json_extract(orderparam,  CONCAT('$[',x,']')),  '$.idsp'),2,5),int);
	if idspparam=id then
		SET type=json_extract(json_extract(orderparam,  CONCAT('$[',x,']')),  '$.gia');
		SET typestring=json_extract(json_extract(orderparam,  CONCAT('$[',x,']')),  '$.gia');
		if char_length(type) >3 then 
			SET type=(select substring(type,2,CHAR_LENGTH(type)-2));
			IF json_type(type)='integer' then				
				SET js=json_extract(json_extract(orderparam,  CONCAT('$[',x,']')),  '$.sl');
				SET price=price+CONVERT(type,int)*js;
			ELSEIF json_type(type)='double' then
				SET js=json_extract(json_extract(orderparam,  CONCAT('$[',x,']')),  '$.sl');
				SET price=price+CONVERT(type,double)*js;
			END IF;
		END IF;
	END IF;
	SET x=x+1;
END While;
RETURN price;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getPushNotification`(`iduser` INT, `listreceiver` LONGTEXT) RETURNS int(11)
    NO SQL
BEGIN
 DECLARE x int;
 DECLARE json int;
 DECLARE js int;
 DECLARE ob int;
 DECLARE l int;
	
SET x = 0;
SET l= (select JSON_LENGTH(listreceiver));
SET ob=0;
SET json=0;
test_loop : LOOP
IF x < l THEN
SET ob=(select json_extract(json_extract(listreceiver,  CONCAT('$[',x,']')),  '$.issend'));

SET js=(select json_extract(json_extract(listreceiver,  CONCAT('$[',x,']')),  '$.iduser'));

if js=iduser then
	if ob=0 then
		SET json=js;
	end if;
	LEAVE test_loop;

ELSE 
    SET x = x + 1;
END IF;
ELSE 
    LEAVE test_loop;
END IF;

END LOOP;

RETURN json;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getSanPham`(`idsppara` INT) RETURNS text CHARSET utf8
    NO SQL
BEGIN
RETURN IFNULL((SELECT distinct JSON_OBJECT(
    'idsp', CONVERT(r.`idsp`,char(6)), 
    'tensp', r.`tensp`, 
    'masp', r.`masp`, 
  
    
    'maloaisp', r.`maloaisp`
)
FROM `sanpham` r WHERE r.`idsp` = idsppara), '{}');
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getTotalItemFromOrder`(`idspparam` INT, `orderparam` LONGTEXT) RETURNS int(11)
    NO SQL
BEGIN
 DECLARE x int;
 DECLARE js int;
 DECLARE id int;
 DECLARE total int;
 DECLARE l int;
	
  SET x = 0;
SET total=0;
SET l= (select JSON_LENGTH(orderparam));

WHILE (x < l) DO
SET id=CONVERT(substring(json_extract(json_extract(orderparam,  CONCAT('$[',x,']')),  '$.idsp'),2,5),int);
if idspparam=id then
SET js=json_extract(json_extract(orderparam,  CONCAT('$[',x,']')),  '$.sl');
SET total=total+js;
END IF;
SET x=x+1;
END While;
RETURN total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `insert`(`param` INT, `content` INT, `rec` INT) RETURNS int(11)
    NO SQL
BEGIN

 DECLARE x int;
SET x=0;
while x<param do

insert into `pushnotification`(`content`,`key`,`receiver`) values('content','onneworder','rec');
SET x=x+1;
end while;
return 0;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `randtring`(`length` INT) RETURNS varchar(10) CHARSET utf8
    NO SQL
begin
    SET @returnStr = '';
    SET @allowedChars = '0123456789';
    SET @i = 0;

    WHILE (@i < length) DO
        SET @returnStr = CONCAT(@returnStr, substring(@allowedChars, FLOOR(RAND() * LENGTH(@allowedChars) + 1), 1));
        SET @i = @i + 1;
    END WHILE;

    RETURN @returnStr;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `activity`
--

CREATE TABLE IF NOT EXISTS `activity` (
  `idac` int(11) NOT NULL AUTO_INCREMENT,
  `name_vi` text NOT NULL,
  `name_en` text NOT NULL,
  `urlac` text NOT NULL,
  `idusertao` bigint(20) NOT NULL,
  `visible` int(11) NOT NULL DEFAULT 1,
  `createdate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`idac`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=24 ;

--
-- Dumping data for table `activity`
--

INSERT INTO `activity` (`idac`, `name_vi`, `name_en`, `urlac`, `idusertao`, `visible`, `createdate`) VALUES
(1, 'Giới Thiệu Công Ty Vina T&T', 'Introduce Vina T&T', 'https://www.youtube.com/embed/xAsH9uh0vJo', 1, 1, '2019-04-23 11:25:58'),
(15, 'Trái cây Sạch', 'Food Fuilt', 'https://www.youtube.com/embed/Vyz_qunTXyA', 1, 1, '2019-04-23 11:26:01'),
(16, 'Vùng Sản Xuất Xoài Xiêm Núm', '', 'https://www.youtube.com/embed/W0eWFmhFFR4', 1, 1, '2019-04-23 11:25:24'),
(17, 'Vùng Sản Xuất Bưởi Năm Roi Mỹ Hòa', 'My Hoa Nam Roi Pomelo', 'https://www.youtube.com/embed/nT355k_hZDQ', 1, 0, '2019-04-23 11:59:34'),
(18, 'Vùng Sản Xuất Nhãn Ido của Ông Trần Văn Thanh', '', 'https://www.youtube.com/embed/1tUZx6KkoJo', 1, 0, '2019-04-23 11:25:24'),
(19, 'Vùng Trồng Bưởi Da Xanh', '', 'https://www.youtube.com/embed/ig5TZ0ymfS4', 1, 1, '2019-04-23 11:25:24'),
(20, 'Vùng Trồng Chôm Chôm', '', 'https://www.youtube.com/embed/5hhxyFFmELo', 1, 1, '2019-04-23 11:25:24');

-- --------------------------------------------------------

--
-- Table structure for table `ads`
--

CREATE TABLE IF NOT EXISTS `ads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iduser` int(11) NOT NULL,
  `image` varchar(800) NOT NULL DEFAULT '',
  `timestart` timestamp NOT NULL DEFAULT current_timestamp(),
  `timeend` timestamp NOT NULL DEFAULT current_timestamp(),
  `gia` int(11) NOT NULL DEFAULT 0,
  `isview` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `ads`
--

INSERT INTO `ads` (`id`, `iduser`, `image`, `timestart`, `timeend`, `gia`, `isview`) VALUES
(1, 2, 'http://nongsansach.viennhacoffee.com/public/image_upload/trungchanh.png', '2018-03-14 17:00:00', '2018-07-14 17:00:00', 0, 0),
(2, 2, 'http://nongsansach.viennhacoffee.com/public/image_upload/quoan.png', '2018-03-14 17:00:00', '2018-07-14 17:00:00', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `contact`
--

CREATE TABLE IF NOT EXISTS `contact` (
  `phone` varchar(20) NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codetext` text NOT NULL,
  `name` varchar(200) NOT NULL,
  `avatar` text NOT NULL,
  `visible` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Table structure for table `dangkysp`
--

CREATE TABLE IF NOT EXISTS `dangkysp` (
  `idsp` varchar(50) NOT NULL,
  `masp` int(6) unsigned zerofill NOT NULL DEFAULT 000000,
  `mancc` int(5) unsigned zerofill NOT NULL DEFAULT 00000,
  `lo` int(11) NOT NULL DEFAULT 1,
  `manpp` int(5) unsigned zerofill NOT NULL DEFAULT 00000,
  `mansc` int(5) unsigned zerofill NOT NULL DEFAULT 00000,
  `manvc` int(5) unsigned zerofill NOT NULL,
  `biensoxe` varchar(100) NOT NULL,
  `mota` text NOT NULL DEFAULT '',
  `ngaysx` timestamp NOT NULL DEFAULT current_timestamp(),
  `createdate` timestamp NOT NULL DEFAULT current_timestamp(),
  `hansd` timestamp NOT NULL DEFAULT current_timestamp(),
  `listhinh` longtext NOT NULL DEFAULT '',
  `thongtinsc` longtext NOT NULL DEFAULT '{}',
  `thongtinpp` longtext NOT NULL DEFAULT '[]',
  `tccs` text NOT NULL DEFAULT '',
  `expire` int(11) NOT NULL DEFAULT 0,
  `iduser` bigint(20) NOT NULL,
  `externallink` text NOT NULL,
  `linkqrcode` text NOT NULL,
  `rutgonlink` text NOT NULL,
  PRIMARY KEY (`idsp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `dangkysp`
--

INSERT INTO `dangkysp` (`idsp`, `masp`, `mancc`, `lo`, `manpp`, `mansc`, `manvc`, `biensoxe`, `mota`, `ngaysx`, `createdate`, `hansd`, `listhinh`, `thongtinsc`, `thongtinpp`, `tccs`, `expire`, `iduser`, `externallink`, `linkqrcode`, `rutgonlink`) VALUES
('0000002', 000042, 00229, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"Đỏ","code":""}', '2019-04-03 17:00:00', '2019-04-04 07:52:16', '2019-04-03 17:00:00', '["image_upload/img_1554486728927"]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 169, '', 'https://www.vinatt.vn/trace.html?idsp=-0000002', ''),
('0000003', 000042, 00265, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-29 17:00:00', '2019-04-08 08:05:55', '2020-04-29 17:00:00', '["image_upload/img_1554710688483"]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 205, '', 'https://www.vinatt.vn/trace.html?idsp=-0000003', ''),
('0000004', 000067, 00213, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-03 17:00:00', '2019-04-05 08:06:05', '2020-02-04 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '<table border="1" cellspacing="0" class="Table" style="border-collapse:collapse; border:solid windowtext 1.0pt; margin-left:5.4pt">\n	<tbody>\n		<tr>\n			<td style="vertical-align:top; width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:12pt"><span style="font-family:VNI-Times"><span style="font-size:13.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">T&ecirc;n chỉ ti&ecirc;u</span></span></span></span></p>\n			</td>\n			<td style="vertical-align:top; width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">Gi&aacute; trị</span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="vertical-align:top; width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">M&agrave;u sắc vỏ quả&nbsp; L*</span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; a*</span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; b<sup>*</sup></span></span></span></p>\n			</td>\n			<td style="vertical-align:top; width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:11.0pt"><span style="color:black">14,00 &ndash; 19,00</span></span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">8,60 &ndash; 12,00</span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">7,00 - 11,20</span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="vertical-align:top; width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">Trọng lượng quả (gram)</span></span></span></p>\n			</td>\n			<td style="vertical-align:top; width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5,50 &ndash; 7,28 </span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">Tỉ lệ ăn được (%)</span></span></span></p>\n			</td>\n			<td style="width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">50,75 - 69,84</span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="height:41.0pt; width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">H&agrave;m lượng chất rắn ho&agrave; tan ( độ Brix) ( %)</span></span></span></p>\n			</td>\n			<td style="height:41.0pt; width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center">&nbsp;</p>\n\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">17,00 &ndash; 20,90</span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center">&nbsp;</p>\n			</td>\n		</tr>\n		<tr>\n			<td style="height:26.9pt; width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">H&agrave;m lượng TSS (%)</span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm">&nbsp;</p>\n			</td>\n			<td style="height:26.9pt; width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">0,62 &ndash; 0,89</span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center">&nbsp;</p>\n			</td>\n		</tr>\n		<tr>\n			<td style="height:22.55pt; width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">H&agrave;m lượng đường tổng số (%)</span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm">&nbsp;</p>\n			</td>\n			<td style="height:22.55pt; width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">6,24 &ndash; 6,40</span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center">&nbsp;</p>\n			</td>\n		</tr>\n		<tr>\n			<td style="height:24.6pt; width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">TA (g/l)</span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm">&nbsp;</p>\n			</td>\n			<td style="height:24.6pt; width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">0,07 &ndash; 0,08</span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center">&nbsp;</p>\n			</td>\n		</tr>\n		<tr>\n			<td style="height:21.55pt; width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">Vitamin C (mg/100g)</span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm">&nbsp;</p>\n			</td>\n			<td style="height:21.55pt; width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">8,80 &ndash; 12,32</span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center">&nbsp;</p>\n			</td>\n		</tr>\n		<tr>\n			<td style="height:24.6pt; width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">H&agrave;m lượng nước (%)</span></span></span></p>\n			</td>\n			<td style="height:24.6pt; width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:12pt"><span style="font-family:&quot;Times New Roman&quot;,serif"><span style="font-size:13.0pt">75,5 &ndash; 86,24</span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center">&nbsp;</p>\n			</td>\n		</tr>\n	</tbody>\n</table>\n', 0, 153, '', 'https://www.vinatt.vn/trace.html?idsp=-0000004', ''),
('0000006', 000064, 00219, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-07 17:00:00', '2019-04-09 08:02:29', '2020-04-29 17:00:00', '["image_upload/img_1554796943574"]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 159, '', 'https://www.vinatt.vn/trace.html?idsp=-0000006', ''),
('0000007', 000042, 00293, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-07 17:00:00', '2019-04-08 11:46:34', '2020-04-29 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 239, '', 'https://www.vinatt.vn/trace.html?idsp=-0000007', ''),
('0000008', 000042, 00295, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-08 17:00:00', '2019-04-08 12:39:03', '2020-04-29 17:00:00', '["image_upload/img_1554727137175"]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 242, '', 'https://www.vinatt.vn/trace.html?idsp=-0000008', ''),
('0000009', 000042, 00296, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-08 17:00:00', '2019-04-08 12:46:35', '2020-04-29 17:00:00', '["image_upload/img_1554727588334"]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 243, '', 'https://www.vinatt.vn/trace.html?idsp=-0000009', ''),
('000001', 000191, 00304, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-17 17:00:00', '2019-04-18 01:32:36', '2020-04-29 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 265, '', 'https://www.vinatt.vn/trace.html?idsp=-000001', ''),
('0000010', 000042, 00119, 2, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-08 17:00:00', '2019-04-08 12:54:25', '2020-04-29 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 59, '', 'https://www.vinatt.vn/trace.html?idsp=-0000010', ''),
('0000011', 000042, 00297, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-08 17:00:00', '2019-04-08 13:06:35', '2020-04-29 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 244, '', 'https://www.vinatt.vn/trace.html?idsp=-0000011', ''),
('0000012', 000042, 00080, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-08 17:00:00', '2019-04-08 13:12:23', '2020-04-29 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 19, '', 'https://www.vinatt.vn/trace.html?idsp=-0000012', ''),
('0000013', 000064, 00298, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-07 17:00:00', '2019-04-09 08:38:01', '2020-04-29 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 245, '', 'https://www.vinatt.vn/trace.html?idsp=-0000013', ''),
('0000014', 000042, 00299, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-29 17:00:00', '2019-04-09 08:51:00', '2020-04-29 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 246, '', 'https://www.vinatt.vn/trace.html?idsp=-0000014', ''),
('0000015', 000064, 00299, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-29 17:00:00', '2019-04-09 08:55:16', '2020-04-29 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 246, '', 'https://www.vinatt.vn/trace.html?idsp=-0000015', ''),
('0000016', 000042, 00300, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-29 17:00:00', '2019-04-09 09:08:38', '2020-04-29 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 247, '', 'https://www.vinatt.vn/trace.html?idsp=-0000016', ''),
('0000017', 000042, 00236, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-29 17:00:00', '2019-04-09 09:15:12', '2020-04-29 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 176, '', 'https://www.vinatt.vn/trace.html?idsp=-0000017', ''),
('0000018', 000042, 00301, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-29 17:00:00', '2019-04-09 09:21:07', '2020-04-29 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 248, '', 'https://www.vinatt.vn/trace.html?idsp=-0000018', 'http://l.ead.me/bb6hpy-850000000018'),
('0000019', 000064, 00302, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-29 17:00:00', '2019-04-09 12:47:47', '2020-04-29 17:00:00', '["image_upload/img_1554892325375"]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 249, '', 'https://www.vinatt.vn/trace.html?idsp=-0000019', ''),
('000002', 000065, 00305, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-18 17:00:00', '2019-04-19 06:39:36', '2020-04-29 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 266, '', 'https://www.vinatt.vn/trace.html?idsp=-000002', ''),
('0000020', 000042, 00302, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-09 17:00:00', '2019-04-10 11:06:01', '2019-04-09 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 249, '', 'https://www.vinatt.vn/trace.html?idsp=-0000020', ''),
('0000021', 000065, 00211, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-03-25 17:00:00', '2019-04-10 10:41:26', '2019-03-28 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '<table border="1" cellspacing="0" class="Table" style="border-collapse:collapse; border:solid windowtext 1.0pt; margin-left:5.4pt; width:720px">\n	<tbody>\n		<tr>\n			<td style="vertical-align:top; width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:VNI-Times"><span style="font-size:13.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">T&ecirc;n chỉ ti&ecirc;u</span></span></span></span></p>\n			</td>\n			<td style="vertical-align:top; width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">Gi&aacute; trị</span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="vertical-align:top; width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">M&agrave;u sắc vỏ quả&nbsp; L*</span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; a*</span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; b<sup>*</sup></span></span></span></p>\n			</td>\n			<td style="vertical-align:top; width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">53,60- 58,33 </span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">- 9,71- (- 6,30)</span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">32,81-34,22</span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="vertical-align:top; width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">Trọng lượng quả (gram)</span></span></span></p>\n			</td>\n			<td style="vertical-align:top; width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">&nbsp;&nbsp;&nbsp;&nbsp; 300 gram &ndash; 500gram</span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="vertical-align:top; width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">Độ chắc (kgf/cm2)</span></span></span></p>\n			</td>\n			<td style="vertical-align:top; width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">2,92 &ndash; 3,45</span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">Tỉ lệ ăn được (%)</span></span></span></p>\n			</td>\n			<td style="width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt"><span style="font-family:Symbol">&sup3;</span></span><span style="font-size:13.0pt"> 75</span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="height:14.35pt; width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">H&agrave;m lượng chất kh&ocirc; (%)</span></span></span></p>\n			</td>\n			<td style="height:14.35pt; width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt"><span style="font-family:Symbol">&sup3;</span></span><span style="font-size:13.0pt"> 25</span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">H&agrave;m lượng chất rắn ho&agrave; tan (Brix %)</span></span></span></p>\n			</td>\n			<td style="width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">&gt;18</span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">H&agrave;m lượng acid tổng số (%)</span></span></span></p>\n			</td>\n			<td style="width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">0,53 &ndash; 0,63</span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">H&agrave;m lượng đ</span><span style="font-size:13.0pt">ường</span><span style="font-size:13.0pt"> tổng số (g.100ml<sup>-1</sup>)</span></span></span></p>\n			</td>\n			<td style="width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt"><span style="font-family:Symbol">&sup3;</span></span><span style="font-size:13.0pt"> 12</span></span></span></p>\n			</td>\n		</tr>\n	</tbody>\n</table>\n', 0, 151, '', 'https://www.vinatt.vn/trace.html?idsp=-0000021', ''),
('000003', 000191, 00306, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-18 17:00:00', '2019-04-19 07:43:27', '2020-04-29 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 267, '', 'https://www.vinatt.vn/trace.html?idsp=-000003', ''),
('000004', 000065, 00120, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-21 17:00:00', '2019-04-22 07:13:14', '2020-04-29 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 60, '', 'https://www.vinatt.vn/trace.html?idsp=-000004', ''),
('000005', 000191, 00120, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-21 17:00:00', '2019-04-22 07:22:46', '2020-04-29 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 60, '', 'https://www.vinatt.vn/trace.html?idsp=-000005', ''),
('000006', 000191, 00307, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-21 17:00:00', '2019-04-22 07:31:54', '2020-04-29 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 268, '', 'https://www.vinatt.vn/trace.html?idsp=-000006', ''),
('000007', 000065, 00193, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-21 17:00:00', '2019-04-22 08:22:59', '2020-04-29 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 133, '', 'https://www.vinatt.vn/trace.html?idsp=-000007', ''),
('000008', 000191, 00308, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-21 17:00:00', '2019-04-22 07:46:08', '2020-04-29 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 269, '', 'https://www.vinatt.vn/trace.html?idsp=-000008', ''),
('000009', 000191, 00309, 1, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"","code":""}', '2019-04-21 17:00:00', '2019-04-22 08:33:53', '2020-04-29 17:00:00', '[]', '{"congnghe":[],"diadiem":[]}', '[]', '', 0, 270, '', 'https://www.vinatt.vn/trace.html?idsp=-000009', ''),
('85000000001', 000185, 00071, 2, 00000, 00000, 00000, '', '{"vietGAP":"","mausac":"Xanh đậm den","code":""}', '2019-03-25 17:00:00', '2019-03-27 01:16:04', '2019-03-28 17:00:00', '["image_upload/img_1554570481937"]', '{"congnghe":[],"diadiem":[]}', '[]', '<table border="1" cellspacing="0" class="Table" style="border-collapse:collapse; border:solid windowtext 1.0pt; margin-left:5.4pt; width:720px">\n	<tbody>\n		<tr>\n			<td style="vertical-align:top; width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:VNI-Times"><span style="font-size:13.0pt"><span style="font-family:&quot;Times New Roman&quot;,serif">T&ecirc;n chỉ ti&ecirc;u</span></span></span></span></p>\n			</td>\n			<td style="vertical-align:top; width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">Gi&aacute; trị</span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="vertical-align:top; width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">M&agrave;u sắc vỏ quả&nbsp; L*</span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; a*</span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; b<sup>*</sup></span></span></span></p>\n			</td>\n			<td style="vertical-align:top; width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">53,60- 58,33 </span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">- 9,71- (- 6,30)</span></span></span></p>\n\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">32,81-34,22</span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="vertical-align:top; width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">Trọng lượng quả (kg)</span></span></span></p>\n			</td>\n			<td style="vertical-align:top; width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 800 gr &ndash; 1,4 kg</span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="vertical-align:top; width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">Độ chắc (kgf/cm2)</span></span></span></p>\n			</td>\n			<td style="vertical-align:top; width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">2,92 &ndash; 3,45</span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">Tỉ lệ ăn được (%)</span></span></span></p>\n			</td>\n			<td style="width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">55-60%</span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="height:14.35pt; width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">H&agrave;m lượng chất kh&ocirc; (%)</span></span></span></p>\n			</td>\n			<td style="height:14.35pt; width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">9,59 - 11,87</span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">H&agrave;m lượng chất rắn ho&agrave; tan (Brix %)</span></span></span></p>\n			</td>\n			<td style="width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">9,67 - 10,82</span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">H&agrave;m lượng acid tổng số (%)</span></span></span></p>\n			</td>\n			<td style="width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">0,32 &ndash; 0,63</span></span></span></p>\n			</td>\n		</tr>\n		<tr>\n			<td style="width:270.0pt">\n			<p style="margin-left:0cm; margin-right:0cm"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">H&agrave;m lượng đ</span><span style="font-size:13.0pt">ường</span><span style="font-size:13.0pt"> tổng số (g.100ml<sup>-1</sup>)</span></span></span></p>\n			</td>\n			<td style="width:162.0pt">\n			<p style="margin-left:0cm; margin-right:0cm; text-align:center"><span style="font-size:10pt"><span style="font-family:Calibri,sans-serif"><span style="font-size:13.0pt">5,8 - 7,91</span></span></span></p>\n			</td>\n		</tr>\n	</tbody>\n</table>\n', 0, 2, '<p>Link video v&ugrave;ng trồng</p>\n\n<p><a href="https://www.youtube.com/embed/nT355k_hZDQ">https://www.youtube.com/embed/nT355k_hZDQ</a></p>\n\n<p>Link giới thiệu c&ocirc;ng ty&nbsp;</p>\n\n<p><a href="https://www.youtube.com/embed/xAsH9uh0vJo">https://www.youtube.com/embed/xAsH9uh0vJo</a></p>\n\n<p>Link giới thiệu nh&agrave; ph&acirc;n phối</p>\n\n<p><a href="https://www.youtube.com/embed/A5OaPcGmE1o">https://www.youtube.com/embed/A5OaPcGmE1o</a></p>\n', 'https://www.vinatt.vn/trace.html?idsp=-85000000001', '');

-- --------------------------------------------------------

--
-- Table structure for table `ddh`
--

CREATE TABLE IF NOT EXISTS `ddh` (
  `idddh` bigint(20) NOT NULL AUTO_INCREMENT,
  `iduserkh` bigint(20) NOT NULL,
  `inforkh` text NOT NULL,
  `ngaydat` timestamp NOT NULL DEFAULT current_timestamp(),
  `ngaygiao` timestamp NOT NULL DEFAULT current_timestamp(),
  `lat` decimal(20,16) NOT NULL,
  `lng` decimal(20,16) NOT NULL,
  `infororder` text NOT NULL DEFAULT '',
  `statusdh` int(11) NOT NULL DEFAULT 0,
  `phone` varchar(20) NOT NULL,
  `inforthanhtoan` text NOT NULL DEFAULT '',
  `feeship` double NOT NULL DEFAULT 0,
  `methodship` int(11) DEFAULT 1,
  `datetimegiaokhach` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`idddh`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=219 ;

--
-- Dumping data for table `ddh`
--

INSERT INTO `ddh` (`idddh`, `iduserkh`, `inforkh`, `ngaydat`, `ngaygiao`, `lat`, `lng`, `infororder`, `statusdh`, `phone`, `inforthanhtoan`, `feeship`, `methodship`, `datetimegiaokhach`) VALUES
(210, 4, '{"dcgiao":"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam","email":"viennhagroup@gmail.com","phone":"0939191028","ten":"Viên Thanh Nhã"}', '2018-03-17 10:57:20', '2018-03-17 10:56:07', 10.1655852000000000, 105.9227885000000000, '[{"dvt":"Kg","gia":"Giá liên hệ","idsp":"00001","sl":1,"tensp":"Bưởi Năm Roi Loại 1 Không nhánh"}]', 2, '0939191028', '{"loai":"1","sotk":"","tennh":"","tentk":""}', 0, 1, '2018-03-17 10:56:07'),
(213, 4, '{"email":"viennhagroup@gmail.com","dcgiao":"Tp.  Vĩnh Long Tỉnh Vĩnh Long","phone":"0939191028","ten":"Viên Thanh Nhã"}', '2018-03-21 22:29:45', '2018-03-21 22:36:08', 10.2413276950112800, 105.9908186377015000, '[{"gia":85000,"idsp":"00023","dvt":"Chai","tensp":"Nước Mắm Cốt Khải Hoàn N43g\\/L 510ml  Chai Sành","sl":2},{"gia":"Giá liên hệ","idsp":"00153","dvt":"Kg","tensp":"Nhãn EDaw  ","sl":2}]', 1, '0939191028', '{"loai":"1","sotk":"","tentk":"","tennh":""}', 0, 1, NULL),
(214, 4, '{"email":"viennhagroup@gmail.com","dcgiao":"Tp.  Vĩnh Long Tỉnh Vĩnh Long","phone":"0939191028","ten":"Viên Thanh Nhã"}', '2018-03-22 22:17:18', '2018-03-22 22:23:41', 10.2413550485020900, 105.9907584172729000, '[{"gia":"Giá liên hệ","idsp":"00001","dvt":"Kg","tensp":"Bưởi Năm Roi Loại 1 Không nhánh","sl":1}]', 1, '0939191028', '{"loai":"1","sotk":"","tentk":"","tennh":""}', 0, 1, NULL),
(217, 4, '{"email":"viennhagroup@gmail.com","dcgiao":"Tp.  Vĩnh Long Tỉnh Vĩnh Long","phone":"0939191028","ten":"Viên Thanh Nhã"}', '2018-03-25 11:49:08', '2018-03-25 11:55:25', 10.2413836295663500, 105.9907216539894000, '[{"gia":"Giá liên hệ","idsp":"00001","dvt":"Kg","tensp":"Bưởi Năm Roi Loại 1 Không nhánh","sl":2}]', 1, '0939191028', '{"loai":"2","sotk":"55678","tentk":"Anh Tuan","tennh":"Sacombank"}', 0, 2, '2018-03-25 11:55:25');

-- --------------------------------------------------------

--
-- Table structure for table `detailwork_batch`
--

CREATE TABLE IF NOT EXISTS `detailwork_batch` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `idwork` bigint(20) NOT NULL,
  `listimg` text NOT NULL,
  `createdate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `qrcode` varchar(50) NOT NULL,
  `urlpdf` text NOT NULL,
  `othercontent` text NOT NULL,
  `type` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=395 ;

--
-- Dumping data for table `detailwork_batch`
--

INSERT INTO `detailwork_batch` (`id`, `idwork`, `listimg`, `createdate`, `qrcode`, `urlpdf`, `othercontent`, `type`) VALUES
(221, 4, '[{"name":"","date_update_img":1554442705025,"limage":"image_upload/img_1554467904300","lat":105.9847499,"lng":10.243156}]', '2019-04-09 19:09:54', '0000001', '', '', 0),
(227, 2, '[{"name":"","date_update_img":1554454116371,"limage":"image_upload/img_1554479315747","lat":105.9858683,"lng":10.2415034}]', '2019-04-09 19:10:01', '0000001', '', '', 0),
(232, 1, '[{"name":"Bưởi năm roi","date_update_img":1554516423643,"limage":"image_upload/img_1554541622158","lat":105.9749835,"lng":10.2430509},{"name":"jjjjjjj","date_update_img":1554542200156,"limage":"image_upload/img_1554567398344","lat":105.9331047,"lng":10.1763064},{"name":"sdfs","date_update_img":1554542837708,"limage":"image_upload/img_1554568035841","lat":105.9331047,"lng":10.1763064},{"name":"sdfsdfsd","date_update_img":1554542959109,"limage":"image_upload/img_1554568157240","lat":105.9331047,"lng":10.1763064}]', '2019-04-09 19:10:05', '0000001', '', '', 0),
(243, 1, '[{"name":"","date_update_img":1554537058972,"limage":"image_upload/img_1554562257190","lat":105.933163,"lng":10.1763288}]', '2019-04-09 19:10:08', '0000001', '', '', 0),
(261, 1, '[{"name":"Ảnh bưởi năm roi","date_update_img":1554538841039,"limage":"image_upload/img_1554564039249","lat":105.9331026,"lng":10.1762296}]', '2019-04-09 19:10:12', '0000001', '', '', 0),
(269, 1, '[]', '2019-04-09 19:10:15', '0000001', '', '', 0),
(270, 1, '[{"name":"Bông hoa đep","date_update_img":1554596460028,"limage":"image_upload/img_1554621659399","lat":-122.406417,"lng":37.785834}]', '2019-04-09 19:10:18', '0000001', '', '', 0),
(271, 1, '[]', '2019-04-09 19:10:27', '0000001', '', '', 0),
(275, 4, '[{"name":"Ảnh: Nhật Kí Sản Xuất","date_update_img":1554691675328,"limage":"image_upload/img_1554716877457","lat":0,"lng":0}]', '2019-04-09 19:10:32', '0000003', '', '', 0),
(277, 1, '[{"name":"Ảnh: hộ chú Trần Hoàng Vui","date_update_img":1554692215214,"limage":"image_upload/img_1554717417347","lat":0,"lng":0}]', '2019-04-09 19:10:38', '0000003', '', '', 0),
(279, 4, '[]', '2019-04-09 19:10:44', '0000003', '', '', 0),
(280, 3, '[]', '2019-04-09 19:10:53', '0000003', '', '', 0),
(281, 4, '[{"name":"Ảnh: Nhật Kí Sản Xuất","date_update_img":1554693756001,"limage":"image_upload/img_1554718958148","lat":0,"lng":0},{"name":"Ảnh: nhật kí","date_update_img":1554694003262,"limage":"image_upload/img_1554719205408","lat":0,"lng":0}]', '2019-04-09 19:10:56', '0000004', '', '', 0),
(282, 11, '[{"name":"Ảnh: Chứng nhận VietGAP","date_update_img":1554693833763,"limage":"image_upload/img_1554719035910","lat":0,"lng":0}]', '2019-04-11 02:28:47', '0000004', '', '', 0),
(283, 8, '[{"name":"Ảnh: nhật kí Phân Bón, thuốc BVTV","date_update_img":1554695125689,"limage":"image_upload/img_1554720327837","lat":0,"lng":0},{"name":"Ảnh: nhật kí Phân Bón, thuốc BVTV","date_update_img":1554695161080,"limage":"image_upload/img_1554720363235","lat":0,"lng":0}]', '2019-04-09 19:11:06', '0000003', '', '', 0),
(284, 1, '[]', '2019-04-09 19:11:10', '0000001', '', '', 0),
(285, 1, '[{"name":"Ảnh: Hộ chú Nguyễn Văn Đội","date_update_img":1554698907245,"limage":"image_upload/img_1554724109425","lat":0,"lng":0}]', '2019-04-09 19:11:14', '0000007', '', '', 0),
(286, 3, '[{"name":"Ảnh: vùng trồng Chôm Chôm của chú Nguyễn Văn Đội","date_update_img":1554698947728,"limage":"image_upload/img_1554724149910","lat":0,"lng":0}]', '2019-04-09 19:11:18', '0000007', '', '', 0),
(287, 1, '[{"name":"","date_update_img":1554699269751,"limage":"image_upload/img_1554724471936","lat":0,"lng":0}]', '2019-04-09 19:11:24', '0000006', '', '', 0),
(288, 1, '[{"name":"Ảnh: ông Cao Thanh Quới","date_update_img":1554699394727,"limage":"image_upload/img_1554724596911","lat":0,"lng":0}]', '2019-04-09 19:11:28', '0000006', '', '', 0),
(289, 3, '[{"name":"Ảnh: vùng trồng Chôm Chôm của ông Cao Thanh Quới","date_update_img":1554699442920,"limage":"image_upload/img_1554724645106","lat":0,"lng":0},{"name":"Ảnh: Camera vùng trồng Chôm Chôm của ông Cao Thanh Quới","date_update_img":1554699506809,"limage":"image_upload/img_1554724708996","lat":0,"lng":0},{"name":"Ảnh: Camera vùng trồng Chôm Chôm của ông Cao Thanh Quới","date_update_img":1554699572954,"limage":"image_upload/img_1554724775139","lat":0,"lng":0}]', '2019-04-09 19:11:31', '0000006', '', '', 0),
(290, 2, '[{"name":"Ảnh: Lô vùng trồng Chôm Chôm của ông Cao Thanh Quới","date_update_img":1554699614271,"limage":"image_upload/img_1554724816454","lat":0,"lng":0}]', '2019-04-09 19:11:34', '0000006', '', '', 0),
(291, 1, '[{"name":"","date_update_img":1554701999913,"limage":"image_upload/img_1554727202117","lat":0,"lng":0}]', '2019-04-09 19:11:37', '0000008', '', '', 0),
(292, 3, '[{"name":"Ảnh: vùng trồng Chôm Chôm của ông Ngô Minh Thảo","date_update_img":1554702023732,"limage":"image_upload/img_1554727225934","lat":0,"lng":0},{"name":"Ảnh: vùng trồng Chôm Chôm của ông Ngô Minh Thảo","date_update_img":1554702062023,"limage":"image_upload/img_1554727264217","lat":0,"lng":0}]', '2019-04-09 19:11:42', '0000008', '', '', 0),
(293, 1, '[{"name":"Ảnh: ông Trần Tuấn Khanh","date_update_img":1554702425077,"limage":"image_upload/img_1554727627283","lat":0,"lng":0}]', '2019-04-09 19:11:47', '0000009', '', '', 0),
(294, 3, '[]', '2019-04-09 19:11:51', '0000009', '', '', 0),
(295, 1, '[{"name":"Ảnh: Hộ ông Huỳnh Văn Dảnh","date_update_img":1554703006795,"limage":"image_upload/img_1554728209005","lat":0,"lng":0}]', '2019-04-09 19:12:05', '0000010', '', '', 0),
(296, 3, '[{"name":"Ảnh: vùng trồng Chôm Chôm của ông Huỳnh Văn Dảnh (lô 1)","date_update_img":1554703051151,"limage":"image_upload/img_1554728253363","lat":0,"lng":0},{"name":"Ảnh: vùng trồng Chôm Chôm của ông Huỳnh Văn Dảnh (lô 2)","date_update_img":1554703101091,"limage":"image_upload/img_1554728303302","lat":0,"lng":0}]', '2019-04-09 19:12:08', '0000010', '', '', 0),
(297, 1, '[{"name":"Ảnh: hộ ông Lê Anh Huy","date_update_img":1554703616974,"limage":"image_upload/img_1554728819191","lat":0,"lng":0}]', '2019-04-09 19:12:12', '0000011', '', '', 0),
(298, 3, '[{"name":"Ảnh: vùng trồng Chôm Chôm của ông Lê Anh Huy","date_update_img":1554703652349,"limage":"image_upload/img_1554728854568","lat":0,"lng":0},{"name":"Ảnh: vùng trồng Chôm Chôm của ông Lê Anh Huy","date_update_img":1554703702756,"limage":"image_upload/img_1554728904976","lat":0,"lng":0}]', '2019-04-09 19:12:19', '0000011', '', '', 0),
(299, 1, '[{"name":"Ảnh: hộ ông Đào Văn Thận","date_update_img":1554704028770,"limage":"image_upload/img_1554729230982","lat":0,"lng":0}]', '2019-04-09 19:12:28', '0000012', '', '', 0),
(300, 3, '[]', '2019-04-09 19:12:35', '0000012', '', '', 0),
(301, 3, '[{"name":"Ảnh: vùng trồng Chôm Chôm của ông Đào Văn Thận","date_update_img":1554704411158,"limage":"image_upload/img_1554729613380","lat":0,"lng":0},{"name":"Ảnh: vùng trồng Chôm Chôm của ông Đào Văn Thận","date_update_img":1554704455494,"limage":"image_upload/img_1554729657714","lat":0,"lng":0},{"name":"Ảnh: vùng trồng Chôm Chôm của ông Đào Văn Thận","date_update_img":1554704475860,"limage":"image_upload/img_1554729678084","lat":0,"lng":0},{"name":"Ảnh: vùng trồng Chôm Chôm của ông Đào Văn Thận","date_update_img":1554704496884,"limage":"image_upload/img_1554729699110","lat":0,"lng":0}]', '2019-04-09 19:12:39', '0000012', '', '', 0),
(302, 9, '[]', '2019-04-09 19:12:49', '0000003', '', '', 0),
(303, 1, '[{"name":"Ảnh: hộ ông Cao Thanh Quới","date_update_img":1554771774683,"limage":"image_upload/img_1554796977930","lat":0,"lng":0}]', '2019-04-09 19:12:58', '0000006', '', '', 0),
(305, 3, '[]', '2019-04-09 19:13:04', '0000006', '', '', 0),
(307, 3, '[{"name":"Ảnh: vùng trồng Chôm Chôm của hộ ông Cao Thanh Quới","date_update_img":1554771996099,"limage":"image_upload/img_1554797199349","lat":0,"lng":0},{"name":"Ảnh: vùng trồng Chôm Chôm của hộ ông Cao Thanh Quới","date_update_img":1554772010137,"limage":"image_upload/img_1554797213386","lat":0,"lng":0}]', '2019-04-09 19:13:14', '0000006', '', '', 0),
(308, 2, '[{"name":"","date_update_img":1554772030881,"limage":"image_upload/img_1554797234123","lat":0,"lng":0}]', '2019-04-09 19:13:19', '0000006', '', '', 0),
(310, 3, '[{"name":"","date_update_img":1554773068105,"limage":"image_upload/img_1554798271362","lat":0,"lng":0},{"name":"Ảnh: vùng trồng Chôm Chôm của ông Trần Tuấn Khanh","date_update_img":1554773110445,"limage":"image_upload/img_1554798313691","lat":0,"lng":0},{"name":"Ảnh: vùng trồng Chôm Chôm của ông Trần Tuấn Khanh","date_update_img":1554773127736,"limage":"image_upload/img_1554798330993","lat":0,"lng":0}]', '2019-04-09 19:13:32', '0000009', '', '', 0),
(311, 3, '[{"name":"Ảnh: vùng trồng Chôm Chôm của hộ Trần Hoàng Vui","date_update_img":1554773399088,"limage":"image_upload/img_1554798602338","lat":0,"lng":0},{"name":"Ảnh: vùng trồng Chôm Chôm của hộ Trần Hoàng Vui","date_update_img":1554773444884,"limage":"image_upload/img_1554798648144","lat":0,"lng":0}]', '2019-04-09 19:13:36', '0000003', '', '', 0),
(312, 1, '[{"name":"Ảnh: hộ ông Dương Thành Công","date_update_img":1554774008303,"limage":"image_upload/img_1554799211499","lat":0,"lng":0}]', '2019-04-09 19:13:41', '0000013', '', '', 0),
(313, 3, '[{"name":"Ảnh: vùng trồng Chôm Chôm của hộ ông Dương Thành Công","date_update_img":1554774080016,"limage":"image_upload/img_1554799283276","lat":0,"lng":0},{"name":"Ảnh: vùng trồng Chôm Chôm của hộ ông Dương Thành Công","date_update_img":1554774128368,"limage":"image_upload/img_1554799331631","lat":0,"lng":0}]', '2019-04-09 19:13:46', '0000013', '', '', 0),
(316, 3, '[{"name":"Ảnh: vùng trồng Chôm Chôm  của hộ ông Nguyễn Văn Cầu","date_update_img":1554774762230,"limage":"image_upload/img_1554799965493","lat":0,"lng":0},{"name":"Ảnh: vùng trồng Chôm Chôm  của hộ ông Nguyễn Văn Cầu","date_update_img":1554774806260,"limage":"image_upload/img_1554800009521","lat":0,"lng":0},{"name":"Ảnh: vùng trồng Chôm Chôm  của hộ ông Nguyễn Văn Cầu","date_update_img":1554774824350,"limage":"image_upload/img_1554800027612","lat":0,"lng":0},{"name":"Ảnh: vùng trồng Chôm Chôm  của hộ ông Nguyễn Văn Cầu","date_update_img":1554774838258,"limage":"image_upload/img_1554800041523","lat":0,"lng":0}]', '2019-04-09 19:13:51', '0000014', '', '', 0),
(317, 1, '[{"name":"","date_update_img":1554774932152,"limage":"image_upload/img_1554800135417","lat":0,"lng":0}]', '2019-04-09 19:13:55', '0000014', '', '', 0),
(318, 3, '[{"name":"Ảnh: vùng trồng Chôm Chôm của ông Nguyễn Văn Đội","date_update_img":1554775238774,"limage":"image_upload/img_1554800442038","lat":0,"lng":0}]', '2019-04-09 19:14:03', '0000007', '', '', 0),
(319, 1, '[{"name":"","date_update_img":1554775739760,"limage":"image_upload/img_1554800943000","lat":0,"lng":0}]', '2019-04-09 19:14:15', '0000016', '', '', 0),
(320, 3, '[{"name":"Ảnh: vùng trồng Chôm Chôm của ông Nguyễn Văn Tấn","date_update_img":1554775780512,"limage":"image_upload/img_1554800983782","lat":0,"lng":0},{"name":"Ảnh: vùng trồng Chôm Chôm của ông Nguyễn Văn Tấn","date_update_img":1554775829068,"limage":"image_upload/img_1554801032336","lat":0,"lng":0}]', '2019-04-09 19:14:21', '0000016', '', '', 0),
(321, 1, '[{"name":"Ảnh: hộ ông Võ Thanh Trang","date_update_img":1554776148118,"limage":"image_upload/img_1554801351388","lat":0,"lng":0}]', '2019-04-09 19:14:30', '0000017', '', '', 0),
(322, 3, '[{"name":"Ảnh: vùng trồng Chôm Chôm của ông Võ Thanh Trang","date_update_img":1554776183446,"limage":"image_upload/img_1554801386718","lat":0,"lng":0}]', '2019-04-09 19:14:40', '0000017', '', '', 0),
(323, 1, '[{"name":"Ảnh: hộ ông Võ Văn Ba","date_update_img":1554776485929,"limage":"image_upload/img_1554801689202","lat":0,"lng":0}]', '2019-04-09 19:14:45', '0000018', '', '', 0),
(324, 3, '[{"name":"Ảnh: vùng trồng Chôm Chôm của ông Võ Văn Ba","date_update_img":1554776524749,"limage":"image_upload/img_1554801728016","lat":0,"lng":0}]', '2019-04-09 19:14:50', '0000018', '', '', 0),
(325, 8, '[{"name":"Ảnh: Nhật kí Phân bón, thuốc BVTV","date_update_img":1554776571409,"limage":"image_upload/img_1554801774681","lat":0,"lng":0}]', '2019-04-09 19:14:54', '0000018', '', '', 0),
(327, 1, '[{"name":"Ảnh: hộ ông Nguyễn Văn Tuấn","date_update_img":1554789190262,"limage":"image_upload/img_1554814393557","lat":0,"lng":0}]', '2019-04-09 19:15:03', '0000019', '', '', 0),
(330, 11, '[{"name":"Ảnh: giấy chứng nhận GLOBALGAP","date_update_img":1554949882066,"limage":"image_upload/img_1554975081717","lat":0,"lng":0}]', '2019-04-11 02:31:12', '0000004', '', '', 0),
(332, 8, '[{"name":"Ảnh: Nhật kí sử dụng thuốc BVTV","date_update_img":1554950157783,"limage":"image_upload/img_1554975357433","lat":0,"lng":0},{"name":"Ảnh: Nhật kí sử dụng thuốc BVTV","date_update_img":1554950172852,"limage":"image_upload/img_1554975372504","lat":0,"lng":0},{"name":"Ảnh: Nhật kí theo dõi quá trình sử dụng thuốc BVTV và Hóa Chất","date_update_img":1554950193891,"limage":"image_upload/img_1554975393542","lat":0,"lng":0}]', '2019-04-11 02:32:22', '0000004', '', '', 0),
(333, 9, '[]', '2019-04-11 02:32:22', '0000004', '', '', 0),
(334, 10, '[{"name":"Ảnh: Nhật kí theo dõi quá trình tiêu thụ sản phẩm","date_update_img":1554950340220,"limage":"image_upload/img_1554975539874","lat":0,"lng":0}]', '2019-04-11 02:32:22', '0000004', '', '', 0),
(335, 4, '[{"name":"Ảnh: Nhật kí theo dõi mua hoặc sản xuất giống trồng","date_update_img":1554950420711,"limage":"image_upload/img_1554975620365","lat":0,"lng":0}]', '2019-04-11 02:32:22', '0000004', '', '', 0),
(336, 7, '[{"name":"Ảnh: Nhật kí sử dụng phân bón, thuốc BVTV","date_update_img":1554950534716,"limage":"image_upload/img_1554975734292","lat":0,"lng":0},{"name":"Ảnh: Nhật kí theo dõi mua hoặc sản xuất phân bón","date_update_img":1554950612883,"limage":"image_upload/img_1554975812538","lat":0,"lng":0},{"name":"Ảnh: Nhật kí theo dõi quá trình sử dụgn phân bón","date_update_img":1554950663261,"limage":"image_upload/img_1554975862915","lat":0,"lng":0},{"name":"Ảnh: Nhật kí theo dõi quá trình sử dụgn phân bón","date_update_img":1554950699888,"limage":"image_upload/img_1554975899543","lat":0,"lng":0}]', '2019-04-11 02:32:22', '0000004', '', '', 0),
(337, 1, '[]', '2019-04-16 16:29:52', '85000000001', '', '', 0),
(338, 1, '[{"name":"Ảnh: hộ ông Nguyễn Văn Liểm","date_update_img":1555551230691,"limage":"image_upload/img_1555551230439","lat":0,"lng":0}]', '2019-04-18 01:33:29', '000001', '', '', 0),
(339, 2, '[{"name":"Ảnh: lô vùng trồng hộ ông Nguyễn Văn Liểm","date_update_img":1555551267382,"limage":"image_upload/img_1555551267128","lat":0,"lng":0}]', '2019-04-18 01:33:29', '000001', '', '', 0),
(340, 3, '[{"name":"Ảnh: vùng trồng của ông Nguyễn Văn Liểm","date_update_img":1555551326044,"limage":"image_upload/img_1555551325794","lat":0,"lng":0},{"name":"Ảnh: vùng trồng của ông Nguyễn Văn Liểm","date_update_img":1555551357698,"limage":"image_upload/img_1555551357447","lat":0,"lng":0},{"name":"Ảnh: vùng trồng của ông Nguyễn Văn Liểm","date_update_img":1555551376628,"limage":"image_upload/img_1555551376376","lat":0,"lng":0},{"name":"Ảnh: vùng trồng của ông Nguyễn Văn Liểm","date_update_img":1555551392925,"limage":"image_upload/img_1555551392674","lat":0,"lng":0},{"name":"Ảnh: vùng trồng của ông Nguyễn Văn Liểm","date_update_img":1555551411984,"limage":"image_upload/img_1555551411733","lat":0,"lng":0},{"name":"Ảnh: vùng trồng của ông Nguyễn Văn Liểm","date_update_img":1555551427222,"limage":"image_upload/img_1555551426903","lat":0,"lng":0},{"name":"Ảnh: vùng trồng của ông Nguyễn Văn Liểm","date_update_img":1555551443356,"limage":"image_upload/img_1555551443104","lat":0,"lng":0}]', '2019-04-18 01:33:29', '000001', '', '', 0),
(341, 1, '[{"name":"Ảnh: hộ ông Lê Văn Diễn","date_update_img":1555656012807,"limage":"image_upload/img_1555656013017","lat":0,"lng":0}]', '2019-04-19 06:39:50', '000002', '', '', 0),
(342, 2, '[{"name":"Ảnh: diện tích lô vùng trồng của ông Nguyễn Văn Diễn","date_update_img":1555656566822,"limage":"image_upload/img_1555656567030","lat":0,"lng":0}]', '2019-04-19 06:39:50', '000002', '', '', 0),
(343, 3, '[]', '2019-04-19 06:39:50', '000002', '', '', 0),
(344, 3, '[{"name":"Ảnh: vùng trồng của ông Lê Văn Diễn","date_update_img":1555656684206,"limage":"image_upload/img_1555656684413","lat":0,"lng":0},{"name":"Ảnh: vùng trồng của ông Lê Văn Diễn","date_update_img":1555656876716,"limage":"image_upload/img_1555656876922","lat":0,"lng":0},{"name":"","date_update_img":1555656906250,"limage":"image_upload/img_1555656906458","lat":0,"lng":0},{"name":"Ảnh: bao trái của hộ ông Lê Văn Diễn","date_update_img":1555656931552,"limage":"image_upload/img_1555656931757","lat":0,"lng":0}]', '2019-04-19 07:03:28', '000002', '', '', 0),
(345, 4, '[]', '2019-04-19 06:39:50', '000002', '', '', 0),
(347, 4, '[{"name":"Ảnh: Nhật kí sản xuất hộ ông Nguyễn Văn Liểm","date_update_img":1555657793177,"limage":"image_upload/img_1555657793379","lat":0,"lng":0}]', '2019-04-19 07:04:51', '000001', '', '', 0),
(348, 6, '[{"name":"Ảnh: Nhật kí phân bón, thuốc BVTV","date_update_img":1555658252499,"limage":"image_upload/img_1555658252700","lat":0,"lng":0}]', '2019-04-19 07:04:51', '000001', '', '', 0),
(349, 9, '[{"name":"Ảnh: nhật kí thu hoạch hộ ông Nguyễn Văn Liểm","date_update_img":1555658302612,"limage":"image_upload/img_1555658302817","lat":0,"lng":0}]', '2019-04-19 07:04:51', '000001', '', '', 0),
(350, 3, '[{"name":"Ảnh: vùng trồng Xoài Xanh Đài Loan hộ ông Nguyễn Văn Liểm","date_update_img":1555658557156,"limage":"image_upload/img_1555658557353","lat":0,"lng":0},{"name":"Ảnh: vùng trồng Xoài Xanh Đài Loan hộ ông Nguyễn Văn Liểm","date_update_img":1555658634738,"limage":"image_upload/img_1555658634934","lat":0,"lng":0},{"name":"Ảnh: vùng trồng Xoài Xanh Đài Loan hộ ông Nguyễn Văn Liểm","date_update_img":1555658671805,"limage":"image_upload/img_1555658672004","lat":0,"lng":0},{"name":"Ảnh: vùng trồng Xoài Xanh Đài Loan hộ ông Nguyễn Văn Liểm","date_update_img":1555658692937,"limage":"image_upload/img_1555658693068","lat":0,"lng":0},{"name":"","date_update_img":1555658730692,"limage":"image_upload/img_1555658730888","lat":0,"lng":0},{"name":"","date_update_img":1555658756238,"limage":"image_upload/img_1555658756434","lat":0,"lng":0}]', '2019-04-19 07:22:07', '000001', '', '', 0),
(351, 9, '[{"name":"Ảnh: Thu hoạch Xanh Xanh Đài Loan hộ ông Nguyễn Văn Liểm","date_update_img":1555658908858,"limage":"image_upload/img_1555658909056","lat":0,"lng":0},{"name":"Ảnh: Thu hoạch Xanh Xanh Đài Loan hộ ông Nguyễn Văn Liểm","date_update_img":1555658970324,"limage":"image_upload/img_1555658970521","lat":0,"lng":0}]', '2019-04-19 07:22:07', '000001', '', '', 0),
(353, 1, '[{"name":"Ảnh: hộ ông Lê Minh Khang","date_update_img":1555659846131,"limage":"image_upload/img_1555659846322","lat":0,"lng":0}]', '2019-04-19 07:43:46', '000003', '', '', 0),
(354, 2, '[{"name":"Ảnh: lô vùng trồng hộ ông Lê Minh Khang","date_update_img":1555659892757,"limage":"image_upload/img_1555659892948","lat":0,"lng":0}]', '2019-04-19 07:43:46', '000003', '', '', 0),
(355, 3, '[{"name":"Ảnh: vùng trồng hộ ông Lê Minh Khang","date_update_img":1555660108689,"limage":"image_upload/img_1555660108881","lat":0,"lng":0}]', '2019-04-19 07:43:46', '000003', '', '', 0),
(356, 4, '[{"name":"Ảnh: Nhật kí sản xuất Xoài theo tiêu chuẩn VietGAP của hộ ông Lê Minh Khang","date_update_img":1555660155204,"limage":"image_upload/img_1555660155397","lat":0,"lng":0}]', '2019-04-19 07:43:46', '000003', '', '', 0),
(357, 7, '[]', '2019-04-19 07:43:46', '000003', '', '', 0),
(358, 1, '[{"name":"Ảnh: hộ ông Huỳnh Trung Trực","date_update_img":1555917227701,"limage":"image_upload/img_1555917219708","lat":0,"lng":0}]', '2019-04-22 07:13:30', '000004', '', '', 0),
(359, 2, '[]', '2019-04-22 07:13:30', '000004', '', '', 0),
(360, 3, '[{"name":"","date_update_img":1555917282860,"limage":"image_upload/img_1555917274865","lat":0,"lng":0},{"name":"Ảnh: vùng trồng Xoài Xanh Đài Loan của ông Huỳnh Trung Trực","date_update_img":1555917321423,"limage":"image_upload/img_1555917313430","lat":0,"lng":0}]', '2019-04-22 07:13:30', '000004', '', '', 0),
(361, 4, '[{"name":"Ảnh: Nhật kí sản xuất xoài theo tiêu chuẩn VietGAP","date_update_img":1555917347305,"limage":"image_upload/img_1555917339309","lat":0,"lng":0}]', '2019-04-22 07:13:30', '000004', '', '', 0),
(362, 5, '[]', '2019-04-22 07:13:30', '000004', '', '', 0),
(363, 4, '[{"name":"Ảnh: Thông tin chung về tổ viên","date_update_img":1555917472950,"limage":"image_upload/img_1555917464957","lat":0,"lng":0}]', '2019-04-22 07:13:30', '000004', '', '', 0),
(365, 9, '[{"name":"Ảnh: Nhật kí thu hoạch hộ ông Huỳnh Trung Trực ","date_update_img":1555917525047,"limage":"image_upload/img_1555917517053","lat":0,"lng":0},{"name":"Ảnh: Nhật kí thu hoạch hộ ông Huỳnh Trung Trực ","date_update_img":1555917572796,"limage":"image_upload/img_1555917564800","lat":0,"lng":0}]', '2019-04-22 07:13:30', '000004', '', '', 0),
(366, 1, '[{"name":"Ảnh: hộ ông Huỳnh Trung Trực","date_update_img":1555917788351,"limage":"image_upload/img_1555917780354","lat":0,"lng":0}]', '2019-04-22 07:23:00', '000004', '', '', 0),
(367, 3, '[{"name":"Ảnh: vùng trồng hộ ông Huỳnh Trung Trực","date_update_img":1555917818766,"limage":"image_upload/img_1555917810770","lat":0,"lng":0}]', '2019-04-22 07:23:00', '000004', '', '', 0),
(368, 4, '[{"name":"Ảnh: Nhật kí sản xuất ","date_update_img":1555917891291,"limage":"image_upload/img_1555917883294","lat":0,"lng":0}]', '2019-04-22 07:23:00', '000004', '', '', 0),
(369, 1, '[{"name":"Ảnh: hộ ông Lê Thanh Vũ","date_update_img":1555918367067,"limage":"image_upload/img_1555918359070","lat":0,"lng":0}]', '2019-04-22 07:32:20', '000006', '', '', 0),
(371, 3, '[{"name":"Ảnh: vùng trồng xoài Xanh Đài Loan hộ ông Lê Thanh Vũ","date_update_img":1555918433103,"limage":"image_upload/img_1555918425104","lat":0,"lng":0},{"name":"Ảnh: vùng trồng xoài Xanh Đài Loan hộ ông Lê Thanh Vũ","date_update_img":1555918488511,"limage":"image_upload/img_1555918480511","lat":0,"lng":0},{"name":"Ảnh: vùng trồng xoài Xanh Đài Loan hộ ông Lê Thanh Vũ","date_update_img":1555918515527,"limage":"image_upload/img_1555918507524","lat":0,"lng":0},{"name":"Ảnh: vùng trồng xoài Xanh Đài Loan hộ ông Lê Thanh Vũ","date_update_img":1555918534537,"limage":"image_upload/img_1555918526538","lat":0,"lng":0},{"name":"Ảnh: vùng trồng xoài Xanh Đài Loan hộ ông Lê Thanh Vũ","date_update_img":1555918552156,"limage":"image_upload/img_1555918544156","lat":0,"lng":0}]', '2019-04-22 07:32:20', '000006', '', '', 0),
(373, 5, '[{"name":"Ảnh: nhật kí theo dõi công việc","date_update_img":1555918615374,"limage":"image_upload/img_1555918607363","lat":0,"lng":0},{"name":"Ảnh: nhật kí theo dõi công việc","date_update_img":1555918655916,"limage":"image_upload/img_1555918647914","lat":0,"lng":0},{"name":"Ảnh: Nhật kí sử dụng phân bón, thuốc BVTV","date_update_img":1555918683557,"limage":"image_upload/img_1555918675554","lat":0,"lng":0},{"name":"Ảnh: nhật kí theo dõi công việc","date_update_img":1555918726926,"limage":"image_upload/img_1555918718925","lat":0,"lng":0}]', '2019-04-22 07:32:20', '000006', '', '', 0),
(374, 4, '[{"name":"Ảnh: Nhật kí theo dõi giống cây trồng","date_update_img":1555918797204,"limage":"image_upload/img_1555918789202","lat":0,"lng":0}]', '2019-04-22 07:32:20', '000006', '', '', 0),
(375, 10, '[{"name":"Ảnh: nhật kí theo dõi bán hàng","date_update_img":1555918848249,"limage":"image_upload/img_1555918840245","lat":0,"lng":0}]', '2019-04-22 07:32:20', '000006', '', '', 0),
(376, 7, '[{"name":"Ảnh: nhật kí mua phân bón, thuốc BVTV","date_update_img":1555918918481,"limage":"image_upload/img_1555918910479","lat":0,"lng":0},{"name":"Ảnh: nhật kí mua phân bón, thuốc BVTV","date_update_img":1555918926491,"limage":"image_upload/img_1555918918489","lat":0,"lng":0}]', '2019-04-22 07:32:20', '000006', '', '', 0),
(377, 1, '[{"name":"Ảnh: hộ ông Lê Minh Pha","date_update_img":1555919358246,"limage":"image_upload/img_1555919350240","lat":0,"lng":0}]', '2019-04-22 07:46:25', '000008', '', '', 0),
(379, 3, '[{"name":"Ảnh: vùng trồng xoài Xanh Đài Loan hộ ông Lê Minh Pha","date_update_img":1555919434629,"limage":"image_upload/img_1555919426624","lat":0,"lng":0},{"name":"Ảnh: vùng trồng xoài Xanh Đài Loan hộ ông Lê Minh Pha","date_update_img":1555919636997,"limage":"image_upload/img_1555919628993","lat":0,"lng":0},{"name":"Ảnh: hệ thống cảm biến vùng trồng","date_update_img":1555919655719,"limage":"image_upload/img_1555919647715","lat":0,"lng":0},{"name":"Ảnh: vùng trồng xoài Xanh Đài Loan hộ ông Lê Minh Pha","date_update_img":1555919729187,"limage":"image_upload/img_1555919721167","lat":0,"lng":0},{"name":"Ảnh: vùng trồng xoài Xanh Đài Loan hộ ông Lê Minh Pha","date_update_img":1555919757288,"limage":"image_upload/img_1555919749284","lat":0,"lng":0}]', '2019-04-22 07:46:25', '000008', '', '', 0),
(380, 4, '[{"name":"Ảnh: Nhật kí sản xuất xoài","date_update_img":1555919781819,"limage":"image_upload/img_1555919773812","lat":0,"lng":0},{"name":"Ảnh: Thông tin chung về tổ viên","date_update_img":1555919815044,"limage":"image_upload/img_1555919807040","lat":0,"lng":0},{"name":"Ảnh: nhật kí theo dõi công việc","date_update_img":1555919869526,"limage":"image_upload/img_1555919861522","lat":0,"lng":0}]', '2019-04-22 07:46:25', '000008', '', '', 0),
(381, 7, '[]', '2019-04-22 07:46:25', '000008', '', '', 0),
(385, 4, '[]', '2019-04-22 07:59:54', '000008', '', '', 0),
(386, 7, '[{"name":"Ảnh: nhật kí mua Phân bón, thuốc BVTV","date_update_img":1555920017251,"limage":"image_upload/img_1555920009245","lat":0,"lng":0},{"name":"Ảnh: nhật kí mua Phân bón, thuốc BVTV","date_update_img":1555920057532,"limage":"image_upload/img_1555920049506","lat":0,"lng":0},{"name":"Ảnh: nhật kí mua Phân bón, thuốc BVTV","date_update_img":1555920077561,"limage":"image_upload/img_1555920069554","lat":0,"lng":0},{"name":"Ảnh: nhật kí sử dụng Phân bón, thuốc BVTV","date_update_img":1555920116920,"limage":"image_upload/img_1555920108913","lat":0,"lng":0},{"name":"Ảnh: nhật kí sử dụng Phân bón, thuốc BVTV","date_update_img":1555920149193,"limage":"image_upload/img_1555920141187","lat":0,"lng":0}]', '2019-04-22 07:59:54', '000008', '', '', 0),
(387, 9, '[{"name":"Ảnh: nhật kí thu hoạch hộ ông Lê Minh Pha","date_update_img":1555920187041,"limage":"image_upload/img_1555920179032","lat":0,"lng":0},{"name":"Ảnh: nhật kí thu hoạch hộ ông Lê Minh Pha","date_update_img":1555920231748,"limage":"image_upload/img_1555920223740","lat":0,"lng":0}]', '2019-04-22 07:59:54', '000008', '', '', 0),
(388, 1, '[{"name":"Ảnh: hộ ông Lê Văn Tính","date_update_img":1555921466233,"limage":"image_upload/img_1555921458222","lat":0,"lng":0}]', '2019-04-22 08:24:14', '000007', '', '', 0),
(389, 2, '[{"name":"Ảnh: lô vùng trồng hộ ông Lê Văn Tính","date_update_img":1555921514830,"limage":"image_upload/img_1555921506818","lat":0,"lng":0}]', '2019-04-22 08:24:14', '000007', '', '', 0),
(390, 3, '[{"name":"Ảnh: vùng trồng xoài hộ ông Lê Văn Tính","date_update_img":1555921550457,"limage":"image_upload/img_1555921542445","lat":0,"lng":0},{"name":"Ảnh: vùng trồng xoài hộ ông Lê Văn Tính","date_update_img":1555921615349,"limage":"image_upload/img_1555921607336","lat":0,"lng":0},{"name":"Ảnh: vùng trồng xoài hộ ông Lê Văn Tính","date_update_img":1555921633039,"limage":"image_upload/img_1555921625027","lat":0,"lng":0},{"name":"Ảnh: vùng trồng xoài hộ ông Lê Văn Tính","date_update_img":1555921651784,"limage":"image_upload/img_1555921643770","lat":0,"lng":0},{"name":"Ảnh: vùng trồng xoài hộ ông Lê Văn Tính","date_update_img":1555921667030,"limage":"image_upload/img_1555921659016","lat":0,"lng":0},{"name":"Ảnh: nhà kho của ông Lê Văn Tính","date_update_img":1555921678216,"limage":"image_upload/img_1555921670201","lat":0,"lng":0}]', '2019-04-22 08:24:14', '000007', '', '', 0),
(391, 1, '[{"name":"Ảnh: hộ ông Nguyễn Văn Kiệt","date_update_img":1555922059674,"limage":"image_upload/img_1555922051658","lat":0,"lng":0}]', '2019-04-22 08:34:09', '000009', '', '', 0),
(392, 2, '[{"name":"Ảnh: lô vùng trồng của ông Nguyễn Văn Kiệt","date_update_img":1555922161214,"limage":"image_upload/img_1555922153199","lat":0,"lng":0}]', '2019-04-22 08:34:09', '000009', '', '', 0),
(394, 3, '[{"name":"Ảnh: vùng trồng của hộ ông Nguyễn Văn Kiệt","date_update_img":1555922323328,"limage":"image_upload/img_1555922315303","lat":0,"lng":0},{"name":"Ảnh: vùng trồng của hộ ông Nguyễn Văn Kiệt","date_update_img":1555922360301,"limage":"image_upload/img_1555922352285","lat":0,"lng":0},{"name":"Ảnh: vùng trồng của hộ ông Nguyễn Văn Kiệt","date_update_img":1555922377465,"limage":"image_upload/img_1555922369449","lat":0,"lng":0},{"name":"Ảnh: vùng trồng của hộ ông Nguyễn Văn Kiệt","date_update_img":1555922392012,"limage":"image_upload/img_1555922383996","lat":0,"lng":0},{"name":"","date_update_img":1555922407092,"limage":"image_upload/img_1555922399072","lat":0,"lng":0}]', '2019-04-22 08:34:09', '000009', '', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `donvitinh`
--

CREATE TABLE IF NOT EXISTS `donvitinh` (
  `tendvt` varchar(100) NOT NULL,
  `tendvt_en` varchar(200) NOT NULL,
  PRIMARY KEY (`tendvt`,`tendvt_en`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `donvitinh`
--

INSERT INTO `donvitinh` (`tendvt`, `tendvt_en`) VALUES
('Chục', 'dozen'),
('Gói', 'Package'),
('Gram', 'Gram'),
('Hộp', 'Box'),
('Kg', 'kg'),
('Tạ', 'Ta'),
('Tấn', 'Ton'),
('Trái', '\nfruits');

-- --------------------------------------------------------

--
-- Table structure for table `dulich`
--

CREATE TABLE IF NOT EXISTS `dulich` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iduser` int(11) NOT NULL,
  `name` text NOT NULL DEFAULT '',
  `hinhanh` longtext DEFAULT '[]',
  `diachi` text NOT NULL DEFAULT '',
  `sdt` varchar(200) NOT NULL DEFAULT '[]',
  `gioithieu` longtext NOT NULL DEFAULT '',
  `dichvu` longtext NOT NULL DEFAULT '',
  `lat` decimal(20,16) NOT NULL DEFAULT 0.0000000000000000,
  `lng` decimal(20,16) NOT NULL DEFAULT 0.0000000000000000,
  `danhgia` longtext NOT NULL DEFAULT '[]',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=20 ;

--
-- Dumping data for table `dulich`
--

INSERT INTO `dulich` (`id`, `iduser`, `name`, `hinhanh`, `diachi`, `sdt`, `gioithieu`, `dichvu`, `lat`, `lng`, `danhgia`) VALUES
(1, 8, 'Khu du lịch Vinh Sang', '["http://www.vinhsang.com/wp-content/uploads/2015/02/03-2.jpg","https://static.mytour.vn/upload_images/Image/Tuan%20NL/Khu%20du%20lich%20Vinh%20Sang/vinhsang6.jpg","https://static.mytour.vn/upload_images/Image/Tuan%20NL/Khu%20du%20lich%20Vinh%20Sang/TOUR-VINH-LONG-TAT-MUONG-BAT-CA-CTY-TOP-TEN_2012531163930859.jpg"]', 'Tổ 14 , ấp An Thuận , xã An Bình , huyện Long Hồ , tỉnh Vĩnh Long', '["02706 277 277"," 0918 66 44 99"]', 'Tọa lạc trên mảnh đất cù lao xã An Bình, Long Hồ, Vĩnh Long. Vùng đất được thiên nhiên ưu đãi, quanh năm nước ngọt đầy ấp phù sa, bốn mùa cây trái xanh tươi. Nhà hàng trang trại Vinh Sang có thể phục vụ một lượt 300 khách, phục vụ khách lẻ, khách đoàn và tất cả các tiệc chiêu đãi, có giá ưu đãi.\n\nCon đường đến với khu du lịch sinh thái – trang trại Vinh Sang khá vất vả. Bạn đến bến phà qua cù lao An Bình sẽ được nhiều người mời gọi đi đò máy. Tuy nhiên con đường đến với Vinh Sang ít tốn kém nhất là qua phà An Bình, đi xe ôm.\n\nXe gắn máy chạy theo con đường bê tông dài khoảng 4km, luồn qua những tàn chôm chôm, nhãn, mận... giao cành, rợp mát. Nếu biết, còn có chuyến đò ngang của Vinh Sang, sát bên tòa soạn báo Vĩnh Long, sẽ đưa bạn đến nơi an toàn.\n\nKhu du lịch sinh thái - trang trại Vinh Sang (xã An Bình, huyện Long Hồ, tỉnh Vĩnh Long) được thành lập từ năm 2005, trước tết Ất Dậu. Anh Nguyễn Minh Tâm, phụ trách tổ nhiếp ảnh tại đây cho biết khu du lịch này có dạng hình tam giác mà một cạnh nằm cặp theo bờ sông Cổ Chiên, đối diện thành phố Vĩnh Long. Đó là điểm đắc địa giúp Vinh Sang có một cảnh quan hấp dẫn, thu hút nhiều khách du lịch ngay trong những ngày đầu mới đi vào khai thác với 10.000 lượt người, 2.000 - 3.000 lượt khách đi du thuyền tham quan cầu Mỹ Thuận...', '- Mò cua bắt ốc\n- Tát ao bắt cá\n- Trải nghiệm làm nông dân \n- Tham quan vườn trái cây\n- Cưỡi đà điểu\n- Câu cá sấu\n- Đạp thiên nga \n- Thuyền thúng\n- Chèo xuồng tron ao\n- Tắm sông, trượt nước\n- Nhà hàng\n- Hát bội\n- Đờn ca tài tử\n- Nhạc sống\n- Đua thuyền thúng, bắt vịt\n- Gói bánh tét, đổ bánh xèo, bánh khọt', 10.2714820000000000, 105.9533680000000000, '[]'),
(3, 8, 'Khu tưởng niệm cố chủ tịch hội đồng bộ trưởng Phạm Hùng', '["https://images.foody.vn/res/g26/256650/s180x180/foody-khu-tuong-niem-co-chu-tich-pham-hung-412-636041974802949757.jpg","https://images.foody.vn/res/g26/256650/s180x180/foody-khu-tuong-niem-co-chu-tich-pham-hung-189-636041978894747607.jpg","https://images.foody.vn/res/g26/256650/s180x180/foody-khu-tuong-niem-co-chu-tich-pham-hung-234-636041975594345951.jpg","https://images.foody.vn/res/g26/256650/s180x180/foody-khu-tuong-niem-co-chu-tich-pham-hung-276-636041979325719149.jpg"]', 'Quốc Lộ 53, Xã Long Phước,  Long Hồ, Vĩnh Long', '["02703834286"]', 'Khu tưởng niệm đồng chí Phạm Hùng được xây dựng vào năm 2000 và khánh thành vào năm 2004 nhân dịp 92 năm ngày sinh của ông. Khu tưởng niệm được xây dựng tại Long Thuận A, xã Long Phước, huyện Long Hồ, tỉnh Vĩnh Long.\n\nKhu tưởng niệm đồng chí Phạm Hùng có tổng diện tích 3,2 ha, gồm có 3 hạng mục chính: Đầu tiên từ ngoài vào là nhà lễ tân với diện tích 300 m2 là nơi đón rất nhiều đoàn khách tham quan khu tưởng niệm. Tiếp đó là nhà tưởng niệm với diện tích 1050 m2 nơi đặt di ảnh và để du khách thắp hương tưởng nhớ đến vị Chủ tịch Hội đồng Bộ trưởng Phạm Hùng. Sau đó là nhà trưng bày với diện tích 670 m2, vốn là nơi trưng bày hình ảnh, tư liệu, hiện vật thể hiện thân thế, sự nghiệp của đồng chí Phạm Hùng.\n\nNgoài ra khu tưởng niệm còn có các hạng mục được xây dựng ngoài trời như: Phòng biệt giam đồng chí Phạm Hùng tại Côn Đảo từ 1934 đến 1945, ngôi nhà làm việc của đồng chí Phạm Hùng tại căn cứ Trung ương Cục miền Nam từ năm 1967 đến 30 tháng 4 năm 1975 và căn phòng làm việc của đồng chí Phạm Hùng ở Hà Nội từ năm 1958 đến năm 1967 và từ năm 1978 đến 1988. Tất cả đều được thể hiện rất rõ nét, khái quát được từng giai đoạn đồng chí Phạm Hùng làm việc.\n\nKhu tưởng niệm đồng chí Phạm Hùng có khuôn viên rộng, với thiết kế hài hòa, thể hiện được niềm tôn kính của dân tộc với vị cố Chủ tịch Hội đồng Bộ trưởng này. Ngày nay, du khách khi đi tour du lịch Vĩnh Long, hầu như đều dành thời gian để ghé qua đây, thắp nén nhang thay cho lời tri ân gửi đến đồng chí Phạm Hùng – một người đã hết lòng vì dân vì nước.', '- Du lịch về nguồn\n- Tìm hiểu thân thế Phạm Hùng\n- Tham quan chụp ảnh lưu niệm', 10.2246960000000000, 105.9893720000000000, '[{"iduser": 4, "sao": 5}]'),
(4, 8, 'Đền thờ Cố thủ tướng Võ Văn Kiệt', '["http://media.baodansinh.vn/Images/2016/12/31/tranhuyenbtv/duong_19.jpg","http://media.baodansinh.vn/Images/2016/12/31/tranhuyenbtv/duong_16.jpg","http://www.baodongnai.com.vn/dataimages/201107/original/images511601_506683.jpg"]', 'Đường Nam Kỳ Khởi Nghĩa, Khóm 2, Thị trấn Vũng Liêm, Vũng Liêm, Vĩnh Long', '[]', 'Từ thành phố Vĩnh Long, xuôi theo quốc lộ 53 về hướng Trà Vinh khoảng 30km, ngay ngã ba Vũng Liêm là Khu tưởng niệm cố Thủ tướng Võ Văn Kiệt, gồm những hạng mục: Nhà trưng bày, nhà làm việc, khu thờ, hồ nước, vườn hoa, thảm cỏ... thoáng đãng, giản dị như một khu vườn Nam bộ. Tuy nhiên vẫn không làm mất đi sự hài hòa, nét độc đáo của những công trình kiến trúc. Tổng thể là một quần thể nhà vườn hoà nhập với các di tích cách mạng, phân lớp không gian theo trục Đông - Tây kết hợp một trục sinh hoạt nghi lễ theo hướng Bắc -  Nam. Kiến trúc tổ hợp với các khối mái thấp, không phân biệt mới - cũ, mở và lan toả trong khu nhà vườn với đường dạo, ao cá, thảm cỏ, cây xanh.\n\nKiến trúc nhắm đến không gian hoài niệm, một nơi đến thân thiện và một nơi trở về ấm áp. Vì vậy, vật liệu và các chi tiết kiến trúc chú trọng vào sự chăm chút hơn là hào nhoáng, mộc hơn là bóng bẩy. Điều này phù hợp và bắt nguồn từ chính  mong muốn của cố Thủ tướng lúc sinh thời. “Nếu mai này tôi mất đi, mấy chú làm khu tưởng niệm cho tôi lớn quá, uy nghi quá thì tôi không vô đâu”, kiến trúc sư Nguyễn Văn Tất - người tham gia kiến trúc Khu tưởng niệm tâm sự.\n\nKhu tưởng niệm được thiết kế theo lối kiến trúc thân thiện, hài hòa trong tổng thể không gian văn hóa của huyện Vũng Liêm, bao gồm: Tượng đài Lê Cẩn - Nguyễn Giao, bia Nam kỳ khởi nghĩa, cùng nhiều tư liệu, hiện vật, hình ảnh được trưng bày đã tái hiện một cách sống động quá trình hoạt động cách mạng của cố Thủ tướng Võ Văn Kiệt qua hai cuộc kháng chiến chống thực dân Pháp và đế quốc Mỹ, cũng như trong công cuộc kiến quốc sau chiến tranh.\n\nTừ khu lưu niệm đến địa chỉ về nguồn\n\nSau 4 năm đi vào hoạt động, Khu lưu niệm cố Thủ tướng Võ Văn Kiệt đã trở thành điểm đến lý tưởng của bao du khách gần xa và là “địa chỉ đỏ” để giáo dục truyền thống, lòng yêu nước cho mọi thế hệ người dân Vĩnh Long nói riêng và cả nước nói chung. Trong số 8 “Điểm du lịch tiêu biểu đồng bằng sông Cửu Long” vừa được Hiệp hội Du lịch ĐBSCL công nhận, Vĩnh Long có 2 điểm du lịch tiêu biểu cấp khu vực gồm: Khu tưởng niệm cố Chủ tịch Hội đồng Bộ trưởng Phạm Hùng và Khu lưu niệm cố Thủ tướng Võ Văn Kiệt. Đây không chỉ là niềm vinh dự của riêng ngành du lịch mà còn là niềm tự hào của các ngành, các cấp và của người dân Vĩnh Long.\n\nĐến Khu tưởng niệm, ngoài việc thăm viếng, du khách còn được chiêm ngưỡng những tác phẩm nghệ thuật độc đáo. Ấn tượng nhất là bức ảnh chân dung của cố Thủ tướng được ghép từ 15.000 bức ảnh nhỏ còn lưu lại trong suốt cuộc đời và sự nghiệp cách mạng của ông. Theo chị Nguyễn Hạnh Phúc,  hướng dẫn viên tại Khu tưởng niệm, người thực hiện bức ảnh này là hoạ sĩ Nguyễn Minh, dựa trên ý tưởng của Bí thư Tỉnh uỷ Đồng Nai Trần Đình Thành. Hoạ sĩ Nguyễn Minh mất 8 tháng để sưu tầm các ảnh nhỏ và 4 tháng để thiết kế thành bức ảnh lớn, chiều cao 1,9m, rộng 1,5m phác hoạ chân dung cố Thủ tướng với nụ cười rạng ngời ẩn trên nền là những công trình mang đậm dấu ấn của ông. Điển hình là công trình thuỷ điện Trị An, đường dây tải điện 500kV Bắc - Nam, Khu công nghiệp nhà máy lọc dầu Dung Quất (Quảng Ngãi). Bức ảnh là món quà của Tỉnh uỷ Đồng Nai tặng khu tưởng niệm tháng 4/2013 để ghi nhớ công lao của cố Thủ tướng Võ Văn Kiệt và những đóng góp to lớn của ông cho đất nước.\n\nỞ đây còn có bộ bàn ghế làm việc và bàn ghế tiếp khách mà cố Thủ tướng Chính phủ Võ Văn Kiệt sử dụng tại trụ sở Văn phòng Chính phủ (Hà Nội) trong thời gian ông đảm nhiệm chức vụ lãnh đạo Chính phủ.\n\nKhu tưởng niệm luôn thu hút đông đảo nhân dân trong và ngoài nước đến viếng, tham quan, tìm hiểu về cuộc đời thân thế sự nghiệp cách mạng của cố Thủ tướng. Hàng năm đều có hàng ngàn đoàn khách với hàng trăm ngàn lượt người đến viếng, tham quan khu tưởng niệm, trong đó có nhiều đoàn khách quốc tế.', '- Du lịch về nguồn\n- Tìm hiểu thân thế Cố thủ tướng Võ Văn Kiệt\n- Tham quan chụp ảnh lưu niệm\n', 10.0856550000000000, 106.1898580000000000, '[]'),
(5, 8, 'Khu lưu niệm Giáo sư-Viện sĩ Trần Đại Nghĩa ', '["http://khuluuniemtdn.vinhlong.gov.vn/sites/all/themes/global/img/home/03.jpg","http://khuluuniemtdn.vinhlong.gov.vn/sites/all/themes/global/img/home/05.jpg","http://khuluuniemtdn.vinhlong.gov.vn/sites/all/themes/global/img/home/01.jpg","http://khuluuniemtdn.vinhlong.gov.vn/sites/all/themes/global/img/home/02.jpg"]', 'Ấp Mỹ Phú 1, xã Tường Lộc, huyện Tam Bình, tỉnh Vĩnh Long', '["02703713559"]', 'Ngày 24/11/2013, Ủy ban nhân dân tỉnh Vĩnh Long tổ chức khởi công xây dựng Khu lưu niệm Giáo sư, Viện sĩ Trần Đại Nghĩa - Người học trò xuất sắc của Chủ tịch Hồ Chí Minh, người con ưu tú của quê hương Vĩnh Long, tại xã Tường Lộc, huyện Tam Bình. Lãnh đạo các bộ, ngành Trung ương, địa phương và đông đảo nhân dân địa phương cùng tham dự.\n\nGiáo sư, Viện sĩ Trần Đại Nghĩa tên thật là Phạm Quang Lễ, là một trong những vị tướng đầu tiên của Quân đội Nhân dân Việt Nam. Ông là nhà trí thức yêu nước, nhà khoa học lớn, có uy tín cao, đã cống hiến trọn cuộc đời cho sự nghiệp khoa học Việt Nam, đặc biệt là khoa học quân sự. Khu lưu niệm Giáo sư, Viện sĩ Trần Đại Nghĩa được thiết kế xây dựng trên diện tích khoảng 16.000 m2, theo lối không gian mở, thoáng mát, nhẹ nhàng, gần gũi, nhưng vẫn đảm bảo tính tôn nghiêm, phù hợp với truyền thống văn hóa của dân tộc Việt Nam. Khu lưu niệm bao gồm các hạng mục chính như: Nhà tưởng niệm, nhà trưng bày, phòng hội thảo, chiếu phim, sinh hoạt truyền thống, quảng trường, các hạn mục phụ trợ và cảnh quan, góp phần vào việc giữ gìn, tôn vinh đập nét thân thế, công lao, sự nghiệp của Giáo sư, Viện sĩ Trần Đại Nghĩa cũng như giáo dục truyền thống, khơi dậy niềm tự hào đối với đông đảo các tầng lớp nhân dân. Đặc biệt, là Trung tâm tích hợp dữ liệu về khoa học và công nghệ là một công trình hiện đại, mới lạ, được Bộ Khoa học và Công nghệ đầu tư xây dựng đầu tiên nằm trong khuôn viên khu lưu niệm, gồm: Cổng thông tin điện tử giới thiệu Khu lưu niệm và tích hợp thư viện điện tử giới thiệu thân thế, sự nghiệp và các công trình nghiên cứu của GS-VS Trần Đại Nghĩa, là nơi lưu giữ và quảng bá thông tin khoa học công nghệ, phục vụ khai thác sản xuất nông nghiệp, phát triển nông thôn mới vùng Đồng bằng sông Cửu Long; đồng thời phục vụ rộng rãi khách tham quan, nghiên cứu, tiếp cận thông tin khoa học công nghệ trong nước và quốc tế.', '- Tham quan khu tưởng niệm\n- Địa điểm du lịch về nguồn\n- Tìm hiểu thân thế giáo sư- viện sĩ Trần Đại Nghĩa', 10.0504250000000000, 105.9877260000000000, '[]'),
(6, 8, 'Văn Thánh Miếu Vĩnh Long', '["https://s3-ap-southeast-1.amazonaws.com/mytour-static-file/upload_images/Image/Location/4_10_2016/1/van-thanh-mieu-vinh-long-mytour-7.jpg","https://s3-ap-southeast-1.amazonaws.com/mytour-static-file/upload_images/Image/Location/4_10_2016/1/van-thanh-mieu-vinh-long-mytour-5.jpg","https://s3-ap-southeast-1.amazonaws.com/mytour-static-file/upload_images/Image/Location/4_10_2016/1/van-thanh-mieu-vinh-long-mytour-8.jpg","https://s3-ap-southeast-1.amazonaws.com/mytour-static-file/upload_images/Image/Location/4_10_2016/1/van-thanh-mieu-vinh-long-mytour-9.jpg"]', 'Trần Phú, Phường 4, Vĩnh Long', '[]', 'Văn Thánh Miếu ở Vĩnh Long tọa lạc trên một vùng đất rộng, bên bờ sông Long Hồ, thuộc phường 4, cách thị xã chừng 2km. Người khởi xướng xây dựng Văn Miếu này chính là cụ Phan Thanh Giản và cụ Đốc học Nguyễn Thông. Cùng với Văn Thánh Miếu Biên Hòa ở Đồng Nai và Văn Thánh Miếu Gia Định, Văn Thánh Miếu thuộc Vĩnh Long tạo nên bộ 3 Văn Miếu nổi tiếng ở Nam Bộ vào thế kỷ 19, khi nền Nho giáo được đề cao. Văn Thánh Miếu tại Vĩnh Long được hoàn thành trong vòng hai năm từ 1864 - 1866 nơi đây được xem là Quốc tử giám ở phương Nam\n\nVì nằm gần thị xã, đường được lát bằng bê tông dễ di chuyển nên du khách có thể thoải mái vi vu đến thăm Văn Thánh Miếu mà không gặp bất kỳ khó khăn nào. Bước chân đến Văn Thánh Miếu, khách du lịch có thể cảm nhận ngay luồng không khí mát rượi của cơn gió thoảng mang theo hơi mát từ dòng sông Long Hồ thổi vào. Cổng tam quan dẫn lối vào Văn Thánh Miếu có hai mái được sơn màu thiếp vàng - gam màu thường được vua chúa sử dụng vào thời kỳ trước. Cổng được thiết kế theo hình vòm, cổng chính lớn hơn hai cổng phụ, trên cổng có dòng Hán tự đề ‘Văn Thánh Miếu’. Cổng cột có câu đối ngợi ca đức sáng của Khổng Tử lẫn tinh thần của Văn Miếu.\n\nNơi mà du khách tham quan đầu tiên khi bước vào Văn Thánh Miếu là Văn Xương Các - thư viện chứa sách cho các học phu và cũng là nơi hội họp, học tập lẫn bàn luận văn chương. Trên lầu có thờ ba vị chuyên lo các việc học hành thi cử - Văn Xương Đế Quân, bên dưới thờ cụ Phan Thanh Giản và Sùng đức tiên sinh Võ Trường Toản cùng nhiều bậc văn sĩ khác được mến mộ lúc bấy giờ. Đây là một trong những điểm dừng chân nổi tiếng tại Vĩnh Long nên khách du lịch ra vào thường xuyên, hương khói nhang trầm nghi ngút bao trùm lên không gian, đem đến sự cảm giác yên tĩnh và tôn nghiêm chẳng kém đền tự.\n\nRời Văn Xương Các, tản bộ thêm chừng 100m, du khách sẽ đến được điện chính của Văn Thánh Miếu nằm trên nền đá cao khoảng 90cm, tạo nên khoảng cách tựa bậc thềm với bên dưới - kiểu kiến trúc quen thuộc thời xưa. Tượng đức Khổng Tử được đặt thờ ở giữa, hai bên là bốn vị cao đồ. Ngoài ra, bàn thờ bên tả hữu còn thờ cúng 12 vị học sĩ cao đồ khác nữa. Bên ngoài hai ngôi miếu nhỏ cũng được xây dựng làm nơi tưởng nhớ đến 72 vị học trò danh tiếng của Khổng Tử. Bia đá ghi lại công đức của cụ Phan Thanh Giản và những người đóng góp tạo nên Văn Thánh Miếu cũng là điểm dừng chân mà khách du lịch nên ghé để hiểu thêm về những bước thăng trầm của ‘Quốc tử giám’ tại phương Nam.\n\nKhông chỉ có những gian nhà, kiến trúc cổ xưa hay những dấu ấn còn để lại trong Văn Thánh Miếu làm người ta xao động mà khuôn viên rợp mát bóng cây nơi đây cũng làm trái tim ai bồi hồi. Khu vườn ở đây rất rộng, lại có rất nhiều cây cổ thụ, tán lá sum sê tỏa bóng mát che chắn cho từng gian nhà trong Văn Thánh Miếu khỏi nắng mưa bão tố. Nhiều loài hoa cũng được trồng xung quanh, điểm xuyến cho bức tranh Văn Miếu thêm thơ tình hơn. Dạo bước dưới bóng râm, để cơn gió phả vào tâm hồn dịu mát, nghe lá cây xào xạc quyện cùng tiếng hót líu lo của đàn chim ‘rúc rích đùa vui’ trên cành, bỗng thấy yên bình làm sao. Chỉ vậy thôi, cũng đủ làm người ta quên hết những âu lo, để quay ngược thời gian trở về quá khứ, một lần trải nghiệm cuộc sống đơn thuần nhẹ nhàng đến vậy.\n\nVề Văn Thanh Miếu Vĩnh Long, du khách có dịp tìm hiểu một phần văn hóa và lịch sử của đất nước để mở rộng góc nhìn của mình hơn. Được chiêm ngưỡng kiến trúc cổ xưa và tự hào lắm bàn tay tài hoa của các bậc cha ông thuở trước. Được hòa mình vào không gian ngọt lành mang hơi thở trong trẻo của đất trời để thư giãn. Một chuyến đi thật ngắn nhưng lại đong đầy nhiều ký ức thú vị như thế, bảo sao không nhớ, không thương được. Có về Vĩnh Long, đừng quên ghé Văn Thánh Miếu để khám phá những ‘bí ẩn’ khó quên nơi này, bạn nhé!', '- Du lịch về nguồn\n- Tham quan khu di tích, đền thờ cụ Phan Thanh Giản', 10.2433150000000000, 105.9844610000000000, '[]'),
(7, 8, 'Khu du lịch Trường Huy', '["https://i0.wp.com/khudulichtruonghuy.com/wp-content/uploads/2018/01/lang-xi-trum.jpg?resize=600%2C500","https://i2.wp.com/khudulichtruonghuy.com/wp-content/uploads/2017/12/t%C3%A1t-m%C6%B0%C6%A1ng-b%E1%BA%AFt-c%C3%A1.jpg?resize=600%2C500","https://i2.wp.com/khudulichtruonghuy.com/wp-content/uploads/2017/12/cheo-xuong-ba-la.jpg?resize=600%2C500","https://i1.wp.com/khudulichtruonghuy.com/wp-content/uploads/2017/09/cau-tinh-yeu.jpg?w=1620"]', 'Tổ 1, ấp Tân Hưng, xã Trường An, Thành phố Vĩnh Long, Vĩnh Long ', '["0898002939"]', 'Du lịch Trường Huy toạ lạc tại thành phố Vĩnh Long, cách cầu Mỹ Thuận 5km. Được quy hoạch trên tổng diện tích 350.000m2, với kinh phí đầu tư ở giai đoạn 1 khoảng 1000 tỷ VND. Đây sẽ là một dự án phát triển du lịch sinh thái bậc nhất khu vực Tây Nam Bộ và đã được UBND tỉnh Vĩnh Long phê duyệt Quyết định số 500/QĐ-UBND.\n\nMiền Tây vốn dĩ là vùng đất trù phú, được thiên nhiên ban tặng những trái thơm quả ngọt. Món ăn đa dạng làm say lòng thực khách mỗi khi về đến vùng đất tươi đẹp này. Với sự ưu đãi của thiên nhiên và nét văn hóa phong phú. Du lịch Trường Huy mong muốn mang đến những dịch vụ hàng đầu về: nghĩ dưỡng, ẩm thực, vui chơi giải trí, giáo dục, tổ chức các sự kiện. Đây sẽ là khu du lịch sinh thái hiện đại bậc nhất tại Miền Tây.\n\nKhông gian nơi đây thừa hưởng những điều kiện tốt nhất của miền Tây Nam Bộ. Tạo nên một mô hình phát triển kinh tế dịch vụ du lịch và phát triển nông nghiệp được nhiều thuận lợi. Hình ảnh cây cầu khỉ, hàng dừa xanh, phiên chợ nổi, cô gái mặc áo bà ba chèo ghe đội nón lá như một bức tranh thật sinh động về cuộc sống nông thôn.\n\nDu khách sẽ được thưởng thức những món ăn ngon mang đậm nét văn hóa của người dân miền Tây như: cá lóc nướng trui, gà đất sét, canh chua bông điên điển , v.v… Khi đến với hệ thống nhà hàng được thiết kế theo phong cách Nam bộ rất mát mẻ. Đội ngũ nhân viên lịch sự, am hiểu tường tận về văn hóa, lịch sử vùng Tây Nam Bộ. Tất cả các yếu tố trên chắc chắn sẽ làm hài lòng du khách trong và ngoài nước.\n\nThiên nhiên trù phú mang đến cho con người Miền Tây các món ăn đa dạng. Các loại rau quê kết hợp với các loại thuỷ sản nước ngọt. Đã được các đầu bếp nơi đây  gửi gắm đến thực khách những món ăn đậm chất Miền Tây. Một hương vị đậm đà đến khó quên. Trường Huy quy tụ những tinh hoa đặc sắc về ẩm thực. Không gian nghĩ dưỡng thoải mái – sang trọng – không khí trong lành. Các dịch vụ giải trí đa dạng hiện đại, là nơi vui chơi thoải mái khi dừng chân ở Miền Tây. Trường Huy sẽ là nơi dừng chân lý tưởng khi bạn đến Miền Tây du lịch.', '- Bắn súng lazer\n- Bắn súng đạn thạch\n- Banh khổng lồ\n- Banh đụng\n- Cho cá ăn\n- Cầu tình yêu\n- Cưỡi bò tót\n- Chèo xuồng ba lá\n- Đạp vịt, chèo thuyền Kayak\n- Hồ bơi\n- Khách sạn 3 sao\n- Nhà hàng\n- Làng xitrum\n- Trò chơi dân gian\n- Tát mương bắt cá\n- Tham quan vườn nhãn\n- Thú đi bộ\n- Xe điện đụng\n', 10.2427020000000000, 105.9304570000000000, '[]'),
(8, 8, 'Công viên sông Tiền', '["https://static.mytour.vn/upload_images/Image/Quang%20Dia%20Danh/26/43300448.jpg","https://static.mytour.vn/upload_images/Image/Quang%20Dia%20Danh/26/85170402.jpg","https://static.mytour.vn/upload_images/Image/Quang%20Dia%20Danh/26/27360729.jpg","https://static.mytour.vn/upload_images/Image/Quang%20Dia%20Danh/26/20223399.jpg"]', 'Tô Thị Huỳnh, P.1, Tp. Vĩnh Long, Vĩnh Long', '[]', 'Công viên sông Tiền nằm bên bờ sông Tiền, có cảnh quang đẹp, là nơi thư giản, hóng mát , cũng là nơi tổ chức các sự kiện văn hóa quan trọng của tỉnh Vĩnh Long.\nĐặc biệt, nhiều năm qua, công viên Sông Tiền luôn được chọn làm nơi tổ chức bắn pháo hoa trong đêm giao thừa Tết âm lịch của tỉnh Vĩnh Long, thu hút hàng ngàn người dân tập trung xem bắn pháo hoa, đón xuân về.\n \nCông viên nằm bên bờ sông Tiền, gần cầu Cái Cá, thuộc phường 1, thành phố Vĩnh Long, tỉnh Vĩnh Long. Công viên có cảnh quang đẹp, là nơi thư giản, hóng mát của người dân thành phố Vĩnh Long; cũng là nơi tổ chức các sự kiện văn hóa quan trọng của tỉnh. \n\nBến tàu công viên Sông Tiền có các tàu nhà hàng có sức chứa tối đa 350 khách, được thiết kế trang nhã - lịch sự - thoáng mát, với đầy đủ tiện nghi tương tự như các tàu nhà hàng trên sông Sài Gòn.\n\nCác tàu nhà hàng này phục vụ các món ăn hải sản nổi tiếng như: tôm sú hấp bia, gỏi củ hủ dừa, cà-ri dê, lẩu cá ngát..., đặc biệt với các món lẩu mang đậm nét đồng quê của miền sông nước Cửu Long. Hàng tuần vào các tối thứ bảy và chủ nhật, từ 20h - 21h30, tàu nhà hàng sẽ đưa quý khách du ngoạn trên sông Tiền, tham quan cầu Mỹ Thuận.\n\nBên cạnh đó, trong công viên sông Tiền còn có hệ thống cây xanh, các công trình tham quan, vui chơi giải trí phục vụ cho người dân thành phố và khách du lịch tới tham quan, nghỉ ngơi, thư giãn.\n\nĐến với Vĩnh Long, công viên sông Tiền sẽ là một lựa chọn phù hợp để du khách cùng người thân có những giây phút thư giãn, nghỉ ngơi trong không gian nhẹ nhàng, yên ả và có thể thưởng thức ẩm thức Vĩnh Long ngay tại đây với hệ thống tàu nhà hàng bên sông.', '- Tàu nhà hàng\r\n- Tham quan thư giãn', 10.2565030000000000, 105.9681480000000000, '[]'),
(9, 8, 'Chợ nổi Trà Ôn', '["http://phoviettravel.vn/images/tours/2016/12/07/original/9a7dulichmientay1ngaycaibe-3_1481086236.jpg","http://vgotravel.com.vn/upload/images/Seating-on-the-boat-and-exploring-Tra-On-floating-market.jpg","http://static2.yan.vn/YanNews/2167221/201712/20171203-100636-anh-11.jpg"]', 'Chợ nổi Trà Ôn, thị trấn Trà Ôn, huyện Trà Ôn, Vĩnh Long', '[]', '<div id="home-column-left">\n                        				\n                <div class="single-content"><p style="text-align: justify;"><em><a href="http://bazantravel.com/wp-content/uploads/2015/12/Chợ-nổi-Trà-Ôn-ở-Vĩnh-Long.png"><img class=" size-full wp-image-28355 alignleft" src="http://bazantravel.com/wp-content/uploads/2015/12/Chợ-nổi-Trà-Ôn-ở-Vĩnh-Long.png" alt="Chợ nổi Trà Ôn ở Vĩnh Long" width="100" height="75"></a>Chợ nổi từ lâu đã là một nét sinh hoạt văn hóa đặc trưng của người dân miền Tây Nam Bộ. Chợ nổi Trà Ôn của Vĩnh Long cũng không nằm ngoài đặc điểm đó. Chợ nổi Trà Ôn trong lòng người dân bản xứ là một khu chợ xinh đẹp, với nhiều xuồng ghe tấp nập, giải quyết nhu cầu trao đổi, mua bán hàng hóa trên sông. Bên cạnh đó, chợ nổi Trà Ôn trong lòng du khách còn là một điểm tham quan du lịch Vĩnh Long hấp dẫn, của một vùng đất trù phú.</em><span id="more-28353"></span></p>\n<div id="attachment_28354" style="width: 559px" class="wp-caption aligncenter"><a href="https://www.khamphadisan.com/wp-content/uploads/2017/09/cho-noi-tra-on-vinh-long-khamphadisan-1.jpg"><img class="size-full wp-image-28354" src="https://www.khamphadisan.com/wp-content/uploads/2017/09/cho-noi-tra-on-vinh-long-khamphadisan-1.jpg" alt="Chợ nổi Trà Ôn ở Vĩnh Long" width="549" height="360" srcset="https://www.khamphadisan.com/wp-content/uploads/2017/09/cho-noi-tra-on-vinh-long-khamphadisan-1.jpg 540w, https://www.khamphadisan.com/wp-content/uploads/2017/09/cho-noi-tra-on-vinh-long-khamphadisan-1.jpg 549w" sizes="(max-width: 549px) 100vw, 549px"></a><p class="wp-caption-text">Chợ nổi Trà Ôn ở Vĩnh Long</p></div>\n<p style="text-align: justify;">Chợ nổi Trà Ôn là khu chợ trên sông thuộc huyện Trà Ôn, tỉnh Vĩnh Long. Không ai biết chợ nổi có mặt tự bao giờ, chỉ biết rằng mỗi ngày ở chợ nổi Trà Ôn luôn dập dìu xuồng ghe mua bán. Chợ tọa lạc tại vị trí đắc địa là nằm giữa ngã ba sông Măng Thít và sông Hậu. Ở vị trí giao thương này, chợ nổi Trà Ôn không chỉ là khu chợ cung cấp sản vật cho bà con, mà còn trở thành khu chợ đầu mối lớn, cung cấp hàng hóa nông sản cho nhiều khu vực lân cận.</p>\n<p style="text-align: justify;">Hàng hóa buôn bán nhiều nhất ở chợ nổi là trái cây. Nhiều đến mức, các loại hoa quả nằm phơi mình trên những chuyến ghe như muốn lấp đầy mặt sông bằng màu sắc rực rỡ của mình. Ở chợ nổi, từ những loại trái dân dã như chuối, ổi, quýt, cam… cho đến những trái cây hạng sang như sầu riêng, măng cụt, xoài cát, cam sành, bưởi… đều có thể tìm mua được dễ dàng. Đặc biệt, tất cả đều rất tươi nguyên, và người bán hàng trên chợ nổi chỉ biết nói đúng giá cả cho dù đó là khách địa phương hay khách từ xa tới.</p>\n<p style="text-align: justify;">Có dịp đi <strong>du lịch Vĩnh Long</strong>, ghé thăm chợ nổi Trà Ôn vào buổi sớm, du khách sẽ thấy cảnh nhộn nhịp nhất trong ngày của chợ. Ở thời điểm này, bất cứ du khách nào cũng có thể dễ dàng lưu giữ lại được những khoảnh khắc sống động nhất, từ những nụ cười tươi rói của cô bán hàng, cho đến một hàng dài rồng rắn những xuồng ghe đậu sát bên nhau, tạo thành một hình dáng chợ nổi quá đỗi dễ thương.</p>\n<p style="text-align: justify;">Đêm xuống, chợ nổi Trà Ôn nhường lại sự yên tĩnh cho sông nước. Nhưng một số chiếc xuồng, ghe vẫn neo ở bến. Vì những con người trên xuồng ghe ấy không chỉ gắn bó với chợ nổi như một địa điểm để buôn bán, làm kinh tế mà còn gắn với chợ nổi như một ngôi nhà. Họ sống, sinh hoạt trên xuồng ghe và neo mình bên chợ nổi ngày này qua tháng khác.</p>\n</div>\n                       \n                    </div>', '- Du lịch sông nước\n- Trải nghiệm cuộc sống trên sông nước của người dân chợ nổi', 9.9670700000000000, 105.9194160000000000, '[]'),
(10, 8, 'Khu sinh thái Hoàng Quân', '["https://media.foody.vn/images/foody-khu-sinh-thai-hoang-quan-binh-minh-202451-389-635877706019247840.jpg","https://media.foody.vn/images/13051485_1768638840022034_3783030912299824430_n.jpg","https://media.foody.vn/images/12809698_1756054007947184_4361230502778461796_n.jpg"]', 'Khu Công Nghiệp BÌNH MINH, Ấp Mỹ Lợi (chân Cầu Cần Thơ), Xã Mỹ Hòa, Thị Xã Bình Minh\r\nVĩnh Long ', '["0901080185"]', 'Khu Du Lịch Sinh Thái HOÀNG QUÂN ngay cổng Khu Công Nghiệp BÌNH MINH, sát chân cầu Cần Thơ. Là một địa chỉ du lịch nghỉ dưỡng miệt vườn lý tưởng cho du khách với các dịch vụ: câu cá giải trí, cắm trại, các món ăn đặc sản...\r\n', '- Câu cá\r\n- Cắm trại\r\n- Chèo xuồng\r\n- Nhà hàng đặc sản\r\n- Sân tenis', 10.0355800000000000, 105.8200600000000000, '[]'),
(11, 8, 'Chùa Tiên Châu', '["http://dailytravelvietnam.com/vi/images/2016/02/chua-tien-chau-vinh-long-700x466.jpg","http://dailytravelvietnam.com/vi/images/2016/02/chua-tien-chau-vinh-long-1-700x466.jpg","http://dailytravelvietnam.com/vi/images/2016/02/chua-tien-chau-vinh-long-2-700x525.jpg"]', 'Ấp Bình Lương, An Bình, Long Hồ, Vĩnh Long', '["02703858965"]', 'Chùa Tiên Châu hay còn có tên gọi là chùa Di Đà, tọa lạc tại cù lao An Bình, nằm trên bãi Tiên, bên tả ngạn sông Cổ Chiên thuộc huyện Long Hồ, tỉnh Vĩnh Long. Chùa Tiên Châu là một trong những ngôi chùa cổ nhất ở tỉnh Vĩnh Long. Chùa được xây dựng vào năm 1750 theo hình chữ tam, ba gian nối liền nhau gồm chánh điện, hậu tổ và hậu liêu. Chùa có tất cả 96 cột gỗ tròn, các kèo, xuyên, trính đều được trạm trổ khéo léo qua bàn tay tinh xảo của các nghệ nhân đến từ kinh đô Huế. Toàn bộ gỗ xây dựng đều là danh mộc được thả bè từ Nam Vang (Phnom Penh, Campuchia) về đây. Xứng đáng là một công trình kiến trúc đáng để tham quan.\nChùa Tiên Châu hay còn có tên gọi là chùa Di Đà, tọa lạc tại cù lao An Bình, nằm trên bãi Tiên, bên tả ngạn sông Cổ Chiên thuộc huyện Long Hồ, tỉnh Vĩnh Long. Chùa Tiên Châu là một trong những ngôi chùa cổ nhất ở tỉnh Vĩnh Long.\n\nChùa được xây dựng vào năm 1750 theo hình chữ tam, ba gian nối liền nhau gồm chánh điện, hậu tổ và hậu liêu. Chùa có tất cả 96 cột gỗ tròn, các kèo, xuyên, trính đều được trạm trổ khéo léo qua bàn tay tinh xảo của các nghệ nhân đến từ kinh đô Huế. Toàn bộ gỗ xây dựng đều là danh mộc được thả bè từ Nam Vang (Phnom Penh, Campuchia) về đây. Xứng đáng là một công trình kiến trúc đáng để tham quan.\n\nPhía trước chùa là tượng Phật Bà Quan Âm đứng uy nghi trên đài sen, tay cầm bình nước cam lồ tưới xuống ban phước lành cho chúng sinh. Bên trái chùa là tượng Phật Thích Ca tĩnh tọa dưới sự che chở của chín con rồng, đằng sau là cội bồ đề râm mát. Bên phải chùa là tượng Phật Di Lặc với thần thái tươi sáng như mang mọi điều may mắn vào người đến viếng thăm. Trong chánh điện chùa Tiên Châu được trang trí vô cùng đẹp mắt, với lối kiến trúc cổ xưa thuộc hệ văn hóa đa dạng.\n\nHiện chùa vẫn còn lưu giữ được nhiều hiện vật có giá trị văn hóa nghệ thuật cao như tượng Phật Di lặc, bộ bao lam chạm Thập bát La hán, cùng nhiều bức tranh, liễn đối được chạm khắc rất tinh tế có từ thế kỷ 19 như tứ linh, tứ quý,…vv.\n\nChùa Tiên Châu là một ngôi chùa cổ chứa đựng nhiều giá trị văn hóa lịch sử lâu đời. Ngày 12 tháng 12 năm 1994, chùa Tiên Châu được ngành chức năng công nhận là “Di tích Lịch sử – Văn hóa” cấp quốc gia.', '- Du lịch tâm linh', 10.2629910000000000, 105.9691270000000000, '[]'),
(12, 8, 'Khu di tích lịch sử Cái Ngang', '["http://kinhtevadubao.vn/ckfinder/userfiles/images/IMG_8094(1).JPG","http://kinhtevadubao.vn/ckfinder/userfiles/images/IMG_8089(1).JPG","http://kinhtevadubao.vn/ckfinder/userfiles/images/IMG_8093(1).JPG","https://d4.violet.vn/uploads/blogs/751149/dscn0953_500.jpg","http://mku.edu.vn/images/website/mku/tintuc/cdnl2015k.jpg"]', 'Ấp 4,, Phú Lộc, Tam Bình, Vĩnh Long, Vietnam\r\n\r\n', '["0971643017"]', 'Cái Ngang trước đây là tên một con rạch nhỏ chảy qua các xã thuộc huyện Tam Bình. Trong hai cuộc kháng chiến chống Pháp và chống Mỹ, Cái Ngang trở thành một căn cứ chiến lược quan trọng của cách mạng; là nơi lãnh đạo, tiếp nhận chỉ thị, tiếp nhận thuốc men và hàng hóa từ Sài Gòn - Chợ Lớn về phân phối cho các tỉnh miền Tây.\n\nNăm 1966, Tỉnh ủy Cửu Long (hiện nay là Vĩnh Long) chọn Cái Ngang làm khu căn cứ chiến lược chủ yếu và chuyển hẳn về đây để làm việc vào năm 1967, khu căn cứ thuộc ấp 4 - xã Mỹ Lộc, nay là ấp 4 - xã Phú Lộc - huyện Tam Bình.\n\nKhu di tích cách mạng Cái Ngang là vùng đất liên hoàn nhiều xã của huyện Tam Bình; là vùng căn cứ của Tỉnh ủy Vĩnh Long qua nhiều thời kỳ. Đây là nơi nhân dân Vĩnh Long dưới sự lãnh đạo của Tỉnh ủy Vĩnh Long đoàn kết chiến đấu, một lòng chăm lo cho sự nghiệp cách mạng. Mặc dù phải đương đầu với kẻ địch đông về số lượng, trang bị hiện đại và có nhiều thủ đoạn thâm độc, nhưng quân dân ta vẫn chiến đấu kiên cường và trưởng thành mạnh mẽ.\n\nCơ quan Tỉnh ủy lúc đó chỉ có một nhà làm việc và một điểm nấu ăn. Công trình được xây dựng thấp, nằm gọn dưới các tàng cây để tránh máy bay địch phát hiện. Xung quanh nơi làm việc bố trí đầy đủ các hầm trú ẩn tránh bom pháo. Hệ thống hầm bí mật được Ban Căn cứ chuẩn bị chu đáo, đủ sức phục vụ Ban Chấp hành Tỉnh ủy trong các kỳ họp.\n\nChính tại khu di tích cách mạng, qua các thời kỳ kháng chiến, Tỉnh ủy Vĩnh Long đã đề ra những chủ trương, nghị quyết mệnh lệnh toàn quân, toàn dân chiến đấu và chiến thắng. Trong các chỉ thị, nghị quyết đó, nổi bật là lệnh Tổng tiến công và nổi dậy xuân Mậu Thân và chiến dịch Hồ Chí Minh lịch sử. Trong thời gian dài, Mỹ - Ngụy càn quét vào khu Căn cứ Cái Ngang để tiêu diệt nhưng đều thất bại. \n\nNăm 2001, di tích lịch sử Căn cứ Cái Ngang được phục dựng trên diện tích 5ha, gồm: bãi lửa, cầu chông, chốt bảo vệ, nhà thường trực năm 1967, nhà thường trực năm 1973, hệ thống hầm trú ẩn, nhà thông tin, hệ thống công sự chiến đấu…\n\nThời gian qua, Căn cứ Cái Ngang đã đón trên 200 nghìn lượt khách tham quan, bình quân mỗi năm đón 18 nghìn lượt khách. Hiện nay, đây là nơi được nhiều du khách trong và ngoài nước đến tham quan và tìm hiểu và cũng là địa chỉ để các cơ quan, tổ chức đoàn, đội chọn làm nơi sinh hoạt truyền thống, hành quân dã ngoại về nguồn. ', '- Du lịch về nguồn\n- Tìm hiểu di tích lịch sử  \n- Tổ chức dã ngoại\n- Sinh hoạt truyền thống\n- Hướng dẫn viên', 10.1029970000000000, 105.9598460000000000, '[]'),
(13, 8, 'Di tích cửa hữu Thành Long Hồ', '["https://static.panoramio.com.storage.googleapis.com/photos/large/71677134.jpg","http://4.bp.blogspot.com/-zNl6TnpVTmU/VL-VOVmeCgI/AAAAAAAAnk4/8CDpwy4Yds4/s1600/Long%2Bho%2B5.jpg","https://thuvientinh.vinhlong.gov.vn/documents/135306/220030/10.jpg/4960a43f-ad0b-4346-9840-b4a6d2279e36?t=1438651831843"]', '63/12 Lê Văn Tám, Phường 1, Vĩnh Long', '[]', 'Trong các tour du lịch Vĩnh Long, du khách ngoài việc chứng kiến sự sôi động của trung tâm thành phố Vĩnh Long, còn có dịp tham quan một điểm lặng ý nghĩa của nơi này. Điểm đến nằm trên một gò đất cao nhất thành phố, tại giao lộ 19/8 và đường Hoàng Thái Hiếu, chính là cây da cao lớn hiện diện ở đây, cành lá xum xuê, rợp mát, vững chãi qua ngày tháng. Đây chính là cây da mà người Vĩnh Long trân trọng, coi nó rất thiêng liêng bởi đây là dấu vết còn sót lại của thành Vĩnh Long xưa : Cây da cửa Hữu.\n\nNếu quan tâm nhiều đến các điểm du lịch Vĩnh Long và có dịp tìm hiểu văn hóa lịch sử của tỉnh, du khách sẽ thấy lịch sử có ghi lại, khoảng tháng 2 năm 1813 triều đình Huế lệnh cho quan Khâm mạng trấn thủ Lưu Phước Tường của Vĩnh Thanh trấn xây dựng thành. Thành xưa tọa lạc tại Phường 1, thành phố Vĩnh Long ngày nay. Thành đắp bằng đất, cửa chính hướng Đông Nam, lưng quay hướng Tây Bắc. Đây là thành được xây dựng kiên cố, chặt chẽ, có tầm quan trọng trong chiến lược.\n\nTrải qua thời gian dài, vì nhiều nguyên nhân, trong đó việc phải trải qua hai cuộc chiến tranh chống Phápvà Mỹ khốc liệt khiến khu di tích thành Vĩnh Long đã bị xuống cấp nghiêm trọng. Đến thập niên 50 cây da gắn liền với thành Vĩnh Long này cũng bị lụi tàn. Điều này từng được nhà văn Sơn Nam viết với sự ngậm ngùi khi một di tích lịch sử xuống cấp. Tuy nhiên, sự sống vẫn phát triển kì lạ, từ thân cây mẹ đã mọc lên cây đa con và phát triển tươi tốt cho đến ngày nay. Ngày 1/12/2000, UBND tỉnh ra quyết định công nhận Cây da cửa Hữu là di tích lịch sử – văn hóa cấp tỉnh. Đến năm 2008, cửa Hữu gồm cổng chính và cổng phụ của Vĩnh Long thành cùng nhà bia được phục dựng lại thành khu di tích đươc nhiều du khách tìm đến.\n\nTrong khung cảnh ồn ào, náo nhiệt của trung tâm thành phố Vĩnh Long vốn thiếu cây xanh thì sự hiện diện của cây da kia đã là điều thú vị nên người dân ở đây rất trân trọng.\n\nCây da cửa Hữu như một điểm nhấn giữa thành phố Vĩnh Long. Nơi di tích lịch sử nổi tiếng này còn gắn liền với nhiều câu chuyện huyền bí. Thành Vĩnh Long-cây da cửa Hữu di tích lịch sử đáng được đến thăm khi du khách có dịp về với mảnh đất Vĩnh Long nhiều duyên nợ.', '', 10.2531260000000000, 105.9703320000000000, '[]'),
(14, 8, 'Chùa cổ Long An', '["https://www.yong.vn/Content/images/travels/chua-co-long-an-vinh-long.jpg","https://media.tripnow.vn/res/g15/146309/prof/s460x300/foody-mobile-chua-la-jpg-171-635706676167159893.jpg"]', 'Quốc Lộ 54, Ấp Mỹ Trung, Xã Thiện Mỹ, Trà Ôn', '[]', '<div class="noidungbai">\n		\n	<div class="des33">Ở Vĩnh Long, có rất nhiều ngôi chùa nổi tiếng lâu đời. Trong đó có chùa cổ Long An hay còn gọi là chùa Đồng Đế. Chùa Long An cách trung tâm thị trấn Trà Ôn trên 3km, từ Quốc lộ 54 theo đường nhỏ khoảng 500m thì đến nơi. Theo những người lớn tuổi kể lại, cách đây gần 2 thế kỷ thì nơi đây còn là đồng hoang, vô cùng hoang sơ. Mọc nhiều cây đế dại, rất ít người sống ở đây. Đến thập niên 1860, có vị tu sĩ từ miền Ngũ Quảng vào chọn nơi đây làm chỗ dừng chân tu hành. Rồi khai hoang, lập chùa và qua nhiều đời trụ trì, nhiều lần tu sữa mà có được ngôi chùa như ngày hôm nay.</div><p style="text-align: justify;">Ở Vĩnh Long, có rất nhiều ngôi chùa nổi tiếng lâu đời. Trong đó có chùa cổ Long An hay còn gọi là chùa Đồng Đế. Chùa Long An cách trung tâm thị trấn Trà Ôn trên 3km, từ Quốc lộ 54 theo đường nhỏ khoảng 500m thì đến nơi. Theo những người lớn tuổi kể lại, cách đây gần 2 thế kỷ thì nơi đây còn là đồng hoang, vô cùng hoang sơ. Mọc nhiều cây đế dại, rất ít người sống ở đây. Đến thập niên 1860, có vị tu sĩ từ miền Ngũ Quảng vào chọn nơi đây làm chỗ dừng chân tu hành. Rồi khai hoang, lập chùa và qua nhiều đời trụ trì, nhiều lần tu sữa mà có được ngôi chùa như ngày hôm nay.</p>\n<p style="text-align: justify;"><a href="http://dailytravelvietnam.com/vi/images/2016/02/chua-co-long-an.jpg"><img class="size-medium wp-image-51277 aligncenter" src="http://dailytravelvietnam.com/vi/images/2016/02/chua-co-long-an-700x465.jpg" alt="chua-co-long-an" width="700" height="465"></a></p>\n<p style="text-align: justify;">Với lối kiến trúc cổ kính nên dù thời gian trôi qua nhưng khi ngắm nhìn lại ngôi chùa. Ta vẫn thấy nơi đây hiện lên nét đẹp lạ thường. Chùa có cấu trúc bao gồm chính điện, hậu liêu, nhà trai trên diện tích khoảng 500 m2, nền được cuốn gạch đại cao 0.5m. Tiền điện hướng Đông Bắc nhìn ra Quốc lộ 54. Khuôn viên ngôi chùa Long An vô cùng rộng rãi, thoáng mát với nhiều cây cổ thụ che bóng mát. Ngoài ra, còn có bờ tre, khóm trúc, vườn cây trái càng tạo nên vẻ đẹp miền sông nước Cửu Long thơ mộng, yên bình.</p>\n<p style="text-align: justify;">Qua 4,5 đời trụ trì khác nhau. Nhưng chùa cổ Long An vẫn còn lưu giữ lại từ phong cách kiến trúc đến những di vật trong chùa như: Long An tự và Đại hùng bửu điện là hai hoành phi của chùa. Và các câu liễn đối, có câu với nội dung như sau:</p>\n<p style="text-align: justify;">“Phật tức tâm, tâm tức phật tế độ hữu duyên siêu vạn kiếp. Sắc thị không, không thị sắc quang minh vô lượng chiếu thập phương.”</p>\n<p style="text-align: justify;">Tất cả bằng chữ Hán, móc chìm sơn son thếp vàng, tạo tác cách đây khoảng 100 năm. Ở nhà Hậu Tổ&nbsp; còn có bệ thờ có di ảnh cố Hòa thượng Khánh Anh, Thiện Hoa, Thiện Hòa, Nhựt Liên. Quanh sân chùa có tháp trì cốt Hòa thượng Thiện Lực, Thiện Trang…vv.</p>\n<p style="text-align: justify;">Chùa cổ Long An được xem là ngôi chùa cổ nhất của Vĩnh Long, được xây dựng hàng thế kỷ trước nên có tầm ảnh hưởng sâu sắc đối với những người dân theo đạo Phật. Tin vào Đức Phật, ghé thăm nơi đây như cầu thêm phước lành, hạnh phúc cho nhà nhà.</p>\n<p style="text-align: justify;">				</p></div>', '- Du lịch tâm linh', 9.9615170000000000, 105.9717380000000000, '[]'),
(15, 8, 'Khu du lịch Trường An', '["http://www.aseantraveller.net/source/img_news/1421.jpg","http://www.vietfuntravel.com.vn/image/data/Blog/cam-nang/du-lich-vinh-long-khu-du-lich-truong-an/du-lich-vinh-long-khu-du-lich-truong-an-1.jpg"]', 'xã Tân Ngãi, Vĩnh Long', '["0972591299"]', 'Nằm cạnh dòng sông Tiền thuộc xã Tân Ngãi, thành phố Vĩnh Long, cách trung tâm thành phố chừng 4km và được tô điểm bằng cây cầu dây văng Mỹ Thuận hiện đại, khu du lịch Trường An thật đắc địa với vị trí cửa ngõ giao lộ, nối tuyến liên thông với 13 tỉnh đồng bằng sông Cửu Long qua quốc lộ 1A. Phong cảnh nơi đây thật hữu tình, quanh năm cây trái xanh mát, lại thêm không khí rất trong lành đã biến Trường An thành khu nghỉ dưỡng lý tưởng và đẹp nhất vùng đồng bằng sông Cửu Long.\r\n\r\nTrên diện tích 16ha, các công trình xây dựng từ hạ tầng như hệ thống cầu cảnh, ao hồ, hoa kiểng đến các điểm vui chơi giải trí, các khu nhà nghỉ đều được thiết kế và phân bố hài hòa với cảnh quan khiến ai đến đây cũng đều dễ dàng nhận ra bầu khí nhẹ nhàng quen thuộc của khu nhà vườn Nam bộ.\r\n\r\nTại khu du lịch Trường An hiện có 11 biệt thự với 30 phòng nghỉ tiêu chuẩn 2 sao, các dịch vụ phụ trợ rất phong phú gồm nhà hàng 200 - 400 khách, bar rượu, massage, karaoke, càfé sân vườn, ẩm thực ngoài trời, các dịch vụ giải trí thể thao như ca nhạc, tennis, billards, câu lạc bộ thể hình, hồ bơi, câu cá, du lịch sinh thái và các loại hình du lịch trên nước như pédale l’eau, lướt ván, du thuyền… Nơi đây còn hiện diện làng du lịch Mỹ Thuận hay khu nghỉ dưỡng cao cấp với 30 nhà nghỉ và có cả phòng hội nghị…', '- Câu cá\r\n- Lướt ván\r\n- Du thuyền\r\n- Phòng hội nghị\r\n- Nhà hàng\r\n- Tennis\r\n- Billards\r\n- Hồ bơi\r\n- Khu nghĩ dưỡng', 10.2734350000000000, 105.9289210000000000, '[]'),
(16, 8, 'Vườn trái cây Sáu Tấn', '["http://2saigon.vn/wp-content/uploads/2017/07/14907098_361094694230057_6114594052201499343_n.jpg","http://2saigon.vn/wp-content/uploads/2017/07/foody-checkin-vuon-trai-cay-6-tan-225-635858710830741336.jpg","https://media.foody.vn/images/17523529_437711069901752_1683064584899534348_n.jpg","https://media.foody.vn/images/foody-checkin-vuon-trai-cay-6-tan-878-635860316662820992.jpg","https://media.foody.vn/images/14344269_340374506302076_5472228804066589251_n.jpg"]', 'Vườn Trái cây Sáu Tấn, An Thuận, An Bình, Long Hồ, Vĩnh Long, Vietnam', '["0906783899"]', 'Vườn trái cây rộng lớn, cùng các dịch vụ độc đáo như tát mương bắt cá, câu cá, được thưởng thức các món đặc sản miền Tây', '- Tát mương bắt cá\n- Tham quan vườn trái cây theo mùa\n- Võng\n- Chòi nghỉ mát\n- Các món ăn đặc sản miền Tây', 10.2726460000000000, 105.9518210000000000, '[]');
INSERT INTO `dulich` (`id`, `iduser`, `name`, `hinhanh`, `diachi`, `sdt`, `gioithieu`, `dichvu`, `lat`, `lng`, `danhgia`) VALUES
(17, 8, 'Vườn trái cây Tám Lộc', '["http://4.bp.blogspot.com/-y4HoM6Ivdso/VqnH6j361nI/AAAAAAAAADc/OQrjBRncZlk/s640/CAM07672.jpg","https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgwUpb4C4ZK7KOeUEdQUJTu-dM337nYY6GJEswUSlwh9BYs7oy","https://scontent.fvca1-2.fna.fbcdn.net/v/t1.0-9/15726395_1298132750246548_6509013208865672763_n.jpg?_nc_cat=0&oh=25a1b6696cd928251148cff177733c95&oe=5B903137"]', 'ườn trái cây Tám Lộc - ấp An Thuận - xã An Bình - huyện Long Hồ - tỉnh Vĩnh Long/ sát khu du lịch Vinh Sang', '["0703858408"]', 'Có dịp về với Miền Tây, thì quý khách không thể bỏ qua vùng đất Vĩnh Long hiền hòa với dòng sông Cổ Chiên thơ mộng. Đến với Vĩnh Long là đến với một miền quê sông nước, quý khách đến thăm vườn trái cây Tám Lộc tọa lạc trên cù lao An Bình.\r\n\r\nĐến với với Vĩnh Long, quý khách hãy đến tham quan cầu Mỹ Thuận bắc qua sông Tiền, nối hai tỉnh Tiền Giang và Vĩnh Long ở ĐBSCL. Cầu được khởi công ngày 6-7-1997 và hoàn thành ngày 21-5-2000, được xem là cây cầu dây văng đầu tiên tại Việt Nam.\r\n\r\nCù lao An Bình nằm giữa dòng sông Tiền, gồm 4 xã: An Bình, Bình Hòa Phước, Hòa Ninh và Đồng Phú, thuộc huyện Long Hồ, tỉnh Vĩnh Long. Đây là phần đất đầu của dải Cù lao Minh đất đai trù phú, màu mỡ, được phù sa bồi đắp, làm cho cây cối xanh tươi, trái cây trù phú.Vườn trái cây Tám Lộc - cù lao An Bình, Vĩnh Long\r\n\r\nĐến với vườn trái cây Tám Lộc chỉ với 25.000đ một người (trẻ em miễn phí), quý khách có thể tự tay hái trái và thưởng thức ngay tại chỗ', '- Tham qua vườn trái cây\r\n- Các món ăn đặc sản miền Tây\r\n- Lều, võng, wifi', 10.2717440000000000, 105.9537880000000000, '[]'),
(18, 8, 'Khu du lịch Chín Rồng', '["http://www.hotel84.com/hotel84-images/news/photo/lang-du-lich-chin-rong-vinh-long.jpg","http://www.dulichchinrong.vn/vnt_upload/File/Image/about1.jpg","http://www.hotel84.com/hotel84-images/news/photo/lang-du-lich-chin-rong-vinh-long5.jpg","http://www.hotel84.com/hotel84-images/news/photo/lang-du-lich-chin-rong-vinh-long11.jpg"]', 'Số 17, Đường lộ 16, Ấp Mỹ Phú 3, xã Mỹ Thạnh Trung, huyện Tam Bình , tỉnh Vĩnh Long', '["02703714679"]', 'Làng du lịch Chín Rồng tọa lạc tại số 17, Đường lộ 16, Ấp Mỹ Phú 3, xã Mỹ Thạnh Trung, huyện Tam Bình , tỉnh Vĩnh Long. Chín Rồng là sự hiện hữu của 9 nhánh của dòng sông Cửu Long hiền hòa.\r\n\r\nLàng Du Lịch Chín Rồng đã hoàn thành giai đoạn đầu với diện tích hơn 8 ha, số vốn hơn 45 tỷ đồng, sẽ đưa vào phục vụ du khách vào ngày 22 tháng 12 năm 2012.\r\n\r\nVới hệ thống công trình phục vụ du lịch kết hợp với nhà hàng, nghỉ dưỡng,khu vui chơi, giải trí và cùng với những thiết kế mang đậm bản chất miền Tây Nam Bộ kết hợp với phong cách hiện đại, vớ sự phục vụ nhiệt tình chuyênnghiệp, sẽ mang đến sự hài lòng, thoải má icho du khách đến tham quan.\r\n\r\nVới nét độc đáo của những công trình xây dựng theo kiến trúc cung đình Huế thuộc triều Nguyễn, đó là 3 căn nhà cổ lớn trị giá hơn 12 tỷ đồng. Trong đó có một căn với 74 cây cột lớn được thiết kế trên cù lao bao quanh bởi hệ thống hồ nước nhân tạo lớn.Vẻ đẹp cổ kính nơi đây là sự chạm khắc tinh xảo của những dòng chữ, câu đối trên những cây cột lớn làm từ loại gỗ quý hiếm. Cùng với khu nhà rường Huế và các cổng tam quan đã tạo nên sự phong phú và vẻ đẹp lãng mạn của quần thể kiến trúc cung đình.\r\n\r\nKhi đến, Quý khách sẽ hài lòng bởi những nét đẹp dân gian, một vùng quê miệt vườn, cây trái Vĩnh Long, một hệ thống 4 hồ nước nhân tạo rộng trên 20.000 m2 với làn nước trong xanh hòa quyện vào cỏ cây hoa lá đua nhau khoe sắc trong làn gió hiu hiu mát lành. Quý khách có thể thảnh thơi tản bộ trên những cây cầu được uốn lượn tinh tế. Có rất nhiều trò chơi, giải trí trên khu hồ như câu cá, đạp vịt,... đặc biệt với một khu nuôi thú với nhiều loại như hươu, đà điểu, cá sấu, những gian hàng quà lưu niệm,...Quý khách còn được thư giãn với hồ bơi rộng lớn.\r\n\r\nVào khu ăn uống, Quý khách sẽ được phục vụ những món ăn dân giã miền Tây: Cá lóc nướng rơm, cơm cháy kho quẹt, gà nướng đất sét, bánh xèo,......với 17 tum lá cùng với sự kết hợp của 2 nhà hàng sang trọng thoáng mát có sức chứa hàng trăm du khách. Quý khách có thể vừa ngồi uống trà, thưởng thức trái cây cùng nghe đờn ca tài tử trong 2 tum được thiết kế đặc trưng theo kiến trúc cổ Huế.\r\n\r\n Bên cạnh đó làng du lịch sẽ tiếp tục hoàn chỉnh giai đoạn 2 với 72 phòng nghỉ dưỡng đạt chuẩn  với tổng vốn trên 14 tỷ đồng.\r\n\r\nĐến với Làng Du Lịch Chín Rồng,Quý khách có thể tận hưởng không khí ấm cúng, thư giãn cùng với gia đình, bạn bè và người thân sau những phút giây căng thẳng của cuộc sống, của công việc và học tập.\r\n\r\nVới hệ thống xe điện phục vụ đi lại  giá phải chăng, Quý khách sẽ hài lòng khi đến với Làng du lịch Chín Rồng.', '- Nhà hàng\r\n- Câu cá sấu\r\n- Khu cắm trại\r\n- Đạp vịt thư giãn', 10.0579370000000000, 105.9568840000000000, '[]'),
(19, 8, 'Cửa hàng nông sản sạch Vĩnh Long', '["https://www.nongsansachvinhlong.vn/public/image_upload/img_1527295419588"]', '29/4 Trần Phú, Phường 4, thành phố Vĩnh Long, Vĩnh Long', '["0169833689"]', '', '', 10.2413995000000000, 105.9858734000000000, '[]');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE IF NOT EXISTS `feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text NOT NULL DEFAULT '',
  `createtime` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`id`, `content`, `createtime`) VALUES
(1, 'tien', '2018-03-17 02:15:18'),
(2, 'ok', '2018-03-17 02:15:27'),
(3, 'hi', '2018-03-17 10:48:58');

-- --------------------------------------------------------

--
-- Table structure for table `historyuser`
--

CREATE TABLE IF NOT EXISTS `historyuser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iduser` bigint(20) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `link` text NOT NULL DEFAULT '',
  `lat` double NOT NULL,
  `lng` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=372 ;

--
-- Dumping data for table `historyuser`
--

INSERT INTO `historyuser` (`id`, `iduser`, `create_date`, `link`, `lat`, `lng`) VALUES
(45, 2, '2019-03-27 07:06:56', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=000001&lang=vi&iduser=2&role=1', 10.2414807, 105.9858726),
(46, 1, '2019-03-27 07:07:40', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=000001&lang=vi&iduser=1&role=0', 10.2414807, 105.9858726),
(48, 13, '2019-03-27 07:23:59', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=000001&lang=vi&iduser=13&role=4', 10.2415131, 105.9858543),
(50, 2, '2019-03-27 07:42:34', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=000001&lang=vi&iduser=2&role=1', 10.2414807, 105.9858726),
(51, 13, '2019-03-27 07:43:10', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=000001&lang=vi&iduser=13&role=4', 10.2414807, 105.9858726),
(52, 1, '2019-03-27 07:43:57', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=000001&lang=vi&iduser=1&role=0', 10.2414807, 105.9858726),
(55, 1, '2019-03-27 08:36:31', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=08032828081032&lang=vi&iduser=1&role=0', 10.2414807, 105.9858726),
(59, 0, '2019-03-27 11:19:29', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?iduser=0&idsp=Optional("85000000001")&role=4&lang=vi', 10.798233032226562, 106.69023200879496),
(60, 0, '2019-03-27 11:20:02', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?iduser=0&idsp=Optional("85000000001")&role=4&lang=vi', 10.798233032226562, 106.69023200879496),
(61, 0, '2019-03-27 11:21:40', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?iduser=0&idsp=Optional("85000000001")&role=4&lang=vi', 10.798233032226562, 106.69023200879496),
(62, 0, '2019-03-27 11:21:53', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?iduser=0&idsp=Optional("85000000001")&role=4&lang=vi', 10.798233032226562, 106.69023200879496),
(63, 11, '2019-03-27 11:24:19', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?iduser=11&idsp=Optional("85000000001")&role=4&lang=vi', 10.798248291015625, 106.6902907659362),
(64, 11, '2019-03-27 12:56:49', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=000001&lang=vi&iduser=11&role=0', 10.1675078, 105.9246726),
(65, 13, '2019-03-27 12:57:46', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=000001&lang=vi&iduser=13&role=4', 10.1675078, 105.9246726),
(66, 11, '2019-03-27 13:07:55', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=000001&lang=vi&iduser=11&role=0', 10.1674644, 105.9246992),
(67, 11, '2019-03-27 13:08:22', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=000001&lang=vi&iduser=11&role=0', 10.1674644, 105.9246992),
(68, 11, '2019-03-27 13:09:29', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=000001&lang=vi&iduser=11&role=0', 10.1674644, 105.9246992),
(69, 13, '2019-03-27 13:14:36', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=000001&lang=vi&iduser=13&role=4', 10.1675406, 105.9246721),
(70, 13, '2019-03-28 01:18:11', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=000001\n\n&lang=vi&iduser=13&role=4', 10.1699298, 105.9277522),
(71, 2, '2019-03-28 01:19:11', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=000001\n\n&lang=vi&iduser=2&role=1', 10.1699296, 105.927752),
(72, 11, '2019-03-28 01:19:53', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=000001\n\n&lang=vi&iduser=11&role=0', 10.1699296, 105.927752),
(73, 11, '2019-03-28 14:45:46', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=0102360359645405&lang=vi&iduser=11&role=0', 10.1675385, 105.924659),
(74, 11, '2019-03-28 14:58:04', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=000001&lang=en&iduser=11&role=0', 10.1674784, 105.9247023),
(75, 2, '2019-03-28 15:01:53', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=000001&lang=en&iduser=2&role=1', 10.1675497, 105.9246482),
(76, 11, '2019-03-28 15:02:32', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=000001&lang=en&iduser=11&role=0', 10.1675497, 105.9246482),
(77, 11, '2019-03-28 15:04:29', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=https://service.ki-ag.com/tayninhtrack/84-1000&lang=en&iduser=11&role=0', 10.1675497, 105.9246482),
(78, 11, '2019-03-29 00:49:11', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=000001&lang=vi&iduser=11&role=0', 10.2414807, 105.9858726),
(79, 11, '2019-03-29 04:07:41', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=11&role=0', 10.241514, 105.9858569),
(80, 11, '2019-03-29 04:13:45', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=11&role=0', 10.2414807, 105.9858726),
(81, 11, '2019-03-29 04:16:14', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=0&role=0', 10.2414807, 105.9858726),
(82, 11, '2019-03-29 04:20:57', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=11&role=0', 10.2414807, 105.9858726),
(83, 11, '2019-03-29 04:28:38', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=11&role=0', 10.2414807, 105.9858726),
(84, 11, '2019-03-29 04:30:45', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=11&role=0', 10.2415173, 105.9858537),
(85, 2, '2019-03-29 07:38:08', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 10.2415162, 105.985856),
(86, 2, '2019-03-29 07:56:20', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=en&iduser=2&role=1', 10.2414902, 105.9858449),
(87, 11, '2019-03-29 09:01:10', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=11&role=0', 10.24315, 105.9844932),
(88, 2, '2019-03-29 09:25:56', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(89, 2, '2019-03-29 09:26:20', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(90, 2, '2019-03-29 09:26:40', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(91, 3, '2019-03-29 09:27:20', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=3&role=2', 0, 0),
(92, 11, '2019-03-29 09:30:41', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=11&role=0', 10.2414807, 105.9858726),
(93, 2, '2019-03-29 09:31:16', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 10.2414807, 105.9858726),
(94, 48, '2019-03-29 15:49:59', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=48&role=4', 10.1675497, 105.9246482),
(95, 2, '2019-04-02 00:18:38', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(96, 2, '2019-04-02 00:32:07', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(97, 0, '2019-04-02 05:59:17', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798255920410156, 106.69026042344672),
(98, 2, '2019-04-02 10:56:13', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 10.1675299, 105.9247552),
(99, 2, '2019-04-02 15:44:45', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=1293123&lang=vi&iduser=2&role=1', 10.1668901, 105.9290476),
(100, 2, '2019-04-02 15:49:20', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=1293123&lang=vi&iduser=2&role=1', 10.1675268, 105.9247397),
(101, 2, '2019-04-02 15:51:12', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 10.1675268, 105.9247397),
(102, 2, '2019-04-02 16:04:40', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 10.1675303, 105.9246589),
(103, 2, '2019-04-02 16:04:54', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=null&lang=vi&iduser=2&role=1', 10.1675303, 105.9246589),
(104, 2, '2019-04-02 16:14:57', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 10.1675426, 105.9247175),
(105, 2, '2019-04-02 16:16:15', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 10.1675386, 105.9247382),
(106, 2, '2019-04-02 16:23:24', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 10.1675442, 105.9246845),
(107, 14, '2019-04-02 16:26:35', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=14&role=1', 10.1675497, 105.9246599),
(108, 2, '2019-04-02 16:40:13', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(109, 2, '2019-04-02 16:42:14', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(110, 2, '2019-04-02 16:42:51', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(111, 2, '2019-04-02 16:45:37', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 10.167534, 105.9247046),
(112, 3, '2019-04-02 16:46:51', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=3&role=2', 0, 0),
(113, 2, '2019-04-02 16:49:45', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 10.1675297, 105.924734),
(114, 2, '2019-04-02 16:54:11', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(115, 2, '2019-04-02 16:54:44', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(116, 2, '2019-04-02 16:55:53', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(117, 2, '2019-04-02 16:57:41', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(118, 0, '2019-04-02 16:57:48', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798347473144531, 106.69039906012517),
(119, 2, '2019-04-02 16:58:28', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?iduser=2&idsp=85000000001&role=1&lang=vi', 10.798202514648438, 106.69038363742334),
(120, 2, '2019-04-02 16:58:41', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(121, 2, '2019-04-02 17:00:28', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(122, 2, '2019-04-02 17:01:33', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(123, 2, '2019-04-02 17:05:21', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(124, 2, '2019-04-02 17:06:57', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(125, 2, '2019-04-02 17:28:35', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(126, 2, '2019-04-02 17:31:38', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(127, 2, '2019-04-02 17:51:34', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(128, 2, '2019-04-02 17:55:04', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 10.1675268, 105.9247187),
(129, 2, '2019-04-02 17:55:13', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(130, 2, '2019-04-02 18:01:30', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(131, 2, '2019-04-02 18:10:18', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(132, 2, '2019-04-02 18:10:49', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(133, 2, '2019-04-02 18:19:54', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(134, 2, '2019-04-02 18:20:18', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(135, 2, '2019-04-02 18:22:07', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(136, 2, '2019-04-02 18:28:25', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(137, 3, '2019-04-02 18:29:33', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=3&role=2', 0, 0),
(138, 2, '2019-04-03 02:41:41', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(139, 2, '2019-04-03 02:51:21', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(140, 2, '2019-04-03 03:48:45', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(141, 2, '2019-04-03 03:49:25', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(142, 2, '2019-04-03 03:55:28', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(143, 2, '2019-04-03 04:01:57', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(144, 2, '2019-04-03 04:02:31', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 10.1658912, 105.9286805),
(145, 2, '2019-04-03 04:05:35', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(146, 3, '2019-04-03 04:07:30', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=3&role=2', 0, 0),
(147, 3, '2019-04-03 04:12:49', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=3&role=2', 0, 0),
(148, 3, '2019-04-03 04:13:29', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=3&role=2', 0, 0),
(149, 3, '2019-04-03 04:14:10', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=3&role=2', 0, 0),
(150, 3, '2019-04-03 04:15:27', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=3&role=2', 0, 0),
(151, 3, '2019-04-03 04:24:00', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=3&role=2', 0, 0),
(152, 6, '2019-04-03 04:39:50', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=6&role=5', 0, 0),
(153, 6, '2019-04-03 04:40:06', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=6&role=5', 0, 0),
(154, 4, '2019-04-03 04:40:57', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=4&role=3', 0, 0),
(155, 4, '2019-04-03 04:42:47', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=4&role=3', 0, 0),
(156, 4, '2019-04-03 04:43:05', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=4&role=3', 0, 0),
(157, 233, '2019-04-04 00:51:24', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=233&role=2', 0, 0),
(158, 0, '2019-04-04 01:22:56', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798233032226562, 106.69026262409507),
(159, 2, '2019-04-04 01:41:13', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(160, 2, '2019-04-04 01:41:53', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(161, 2, '2019-04-04 02:00:18', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(162, 2, '2019-04-04 02:18:46', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(163, 2, '2019-04-04 02:54:19', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(164, 2, '2019-04-04 03:18:56', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(165, 2, '2019-04-04 03:21:36', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(166, 2, '2019-04-04 03:22:44', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000002&lang=vi&iduser=2&role=1', 0, 0),
(167, 2, '2019-04-04 09:34:28', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(168, 2, '2019-04-04 11:15:13', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=en&iduser=2&role=1', 10.1673005, 105.9248526),
(169, 2, '2019-04-04 11:28:12', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=en&iduser=2&role=1', 10.1673005, 105.9248526),
(170, 2, '2019-04-05 03:43:06', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(171, 2, '2019-04-05 03:54:57', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(172, 2, '2019-04-05 04:12:58', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 10.2415172, 105.9858567),
(173, 2, '2019-04-05 04:13:17', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(174, 2, '2019-04-05 05:11:19', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(175, 2, '2019-04-05 05:38:48', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 10.2415296, 105.9858495),
(176, 2, '2019-04-05 06:31:44', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000005&lang=en&iduser=2&role=1', 10.243156, 105.9847499),
(177, 2, '2019-04-05 06:31:59', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000004&lang=en&iduser=2&role=1', 10.243156, 105.9847499),
(178, 2, '2019-04-05 06:32:20', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=en&iduser=2&role=1', 10.243156, 105.9847499),
(179, 2, '2019-04-05 06:34:48', 'https://www.agritechvinhlong.com/vinatt/webadmin/traceability.html?idsp=85000000001&lang=en&iduser=2&role=1', 10.2415251, 105.9858534),
(180, 2, '2019-04-05 08:48:55', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 10.2415034, 105.9858683),
(181, 2, '2019-04-06 08:40:14', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(182, 2, '2019-04-06 09:06:50', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=en&iduser=2&role=1', 0, 0),
(183, 2, '2019-04-06 09:12:37', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=en&iduser=2&role=1', 0, 0),
(184, 2, '2019-04-06 10:37:30', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(185, 2, '2019-04-06 10:38:40', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(186, 2, '2019-04-06 10:40:06', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(187, 2, '2019-04-06 10:40:29', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(188, 3, '2019-04-06 10:41:31', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=3&role=2', 0, 0),
(189, 2, '2019-04-08 03:50:10', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000003&lang=vi&iduser=2&role=1', 10.2415034, 105.9858683),
(190, 0, '2019-04-08 09:17:02', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000003&role=4&lang=vi', 10.79827880859375, 106.69022530327243),
(191, 0, '2019-04-08 09:17:35', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798362731933594, 106.6903647781412),
(192, 0, '2019-04-08 09:22:42', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798210144042969, 106.69026511731249),
(193, 0, '2019-04-08 09:26:48', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.7982177734375, 106.69028213257593),
(194, 2, '2019-04-08 09:29:18', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(195, 2, '2019-04-08 09:37:48', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(196, 2, '2019-04-09 00:52:24', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(197, 2, '2019-04-09 00:53:18', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(198, 2, '2019-04-09 00:54:59', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(199, 2, '2019-04-09 01:00:17', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(200, 2, '2019-04-09 01:00:59', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(201, 2, '2019-04-09 02:44:08', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(202, 2, '2019-04-09 02:44:51', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(203, 2, '2019-04-09 02:44:58', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(204, 2, '2019-04-09 02:45:45', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(205, 2, '2019-04-09 02:58:47', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(206, 2, '2019-04-09 02:59:07', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(207, 2, '2019-04-09 02:59:54', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(208, 2, '2019-04-09 03:00:35', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(209, 2, '2019-04-09 03:06:03', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(210, 2, '2019-04-09 03:12:14', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(211, 2, '2019-04-09 03:13:48', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(212, 2, '2019-04-09 04:40:04', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(213, 2, '2019-04-09 04:40:26', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(214, 2, '2019-04-09 04:40:48', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(215, 2, '2019-04-09 04:42:19', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(216, 2, '2019-04-09 04:44:33', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(217, 2, '2019-04-09 04:47:10', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(218, 2, '2019-04-09 09:02:40', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 10.2415104, 105.9858516),
(219, 2, '2019-04-09 10:07:10', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(220, 2, '2019-04-09 10:11:11', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(221, 2, '2019-04-09 10:12:50', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(222, 2, '2019-04-09 10:14:22', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(223, 2, '2019-04-09 10:14:39', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(224, 2, '2019-04-09 10:15:17', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(225, 2, '2019-04-09 10:16:51', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(226, 2, '2019-04-09 10:17:57', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(227, 2, '2019-04-09 10:18:52', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(228, 2, '2019-04-09 10:31:11', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=850000000020&lang=vi&iduser=2&role=1', 0, 0),
(229, 2, '2019-04-09 10:33:15', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=850000000020&lang=vi&iduser=2&role=1', 0, 0),
(230, 2, '2019-04-09 10:41:07', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000002&lang=vi&iduser=2&role=1', 0, 0),
(231, 2, '2019-04-09 10:44:43', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000002&lang=vi&iduser=2&role=1', 0, 0),
(232, 2, '2019-04-09 10:46:20', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000002&lang=vi&iduser=2&role=1', 0, 0),
(233, 2, '2019-04-09 10:49:26', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000019&lang=vi&iduser=2&role=1', 0, 0),
(234, 2, '2019-04-09 11:02:01', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000001&lang=vi&iduser=2&role=1', 0, 0),
(235, 2, '2019-04-09 11:02:24', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000020&lang=vi&iduser=2&role=1', 0, 0),
(236, 3, '2019-04-09 11:02:45', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000020&lang=vi&iduser=3&role=2', 0, 0),
(237, 3, '2019-04-09 11:03:07', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000020&lang=vi&iduser=3&role=2', 0, 0),
(238, 6, '2019-04-09 11:06:22', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000020&lang=vi&iduser=6&role=5', 0, 0),
(239, 6, '2019-04-09 11:06:44', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000020&lang=vi&iduser=6&role=5', 0, 0),
(240, 6, '2019-04-09 11:09:29', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000019&lang=vi&iduser=6&role=5', 0, 0),
(241, 4, '2019-04-09 11:09:57', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000019&lang=vi&iduser=4&role=3', 0, 0),
(242, 6, '2019-04-09 11:13:12', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000019&lang=vi&iduser=6&role=5', 0, 0),
(243, 6, '2019-04-09 11:24:33', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000019&lang=vi&iduser=6&role=5', 0, 0),
(244, 6, '2019-04-09 11:26:41', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000019&lang=vi&iduser=6&role=5', 0, 0),
(245, 6, '2019-04-09 11:27:13', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000018&lang=vi&iduser=6&role=5', 0, 0),
(246, 3, '2019-04-09 11:28:02', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000019&lang=vi&iduser=3&role=2', 0, 0),
(247, 3, '2019-04-09 11:28:24', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000016&lang=vi&iduser=3&role=2', 0, 0),
(248, 3, '2019-04-09 11:28:41', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000016&lang=vi&iduser=3&role=2', 0, 0),
(249, 6, '2019-04-09 11:34:49', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000016&lang=vi&iduser=6&role=5', 0, 0),
(250, 6, '2019-04-09 11:42:09', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000019&lang=vi&iduser=6&role=5', 0, 0),
(251, 6, '2019-04-09 11:42:32', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000019&lang=vi&iduser=6&role=5', 0, 0),
(252, 6, '2019-04-09 11:43:22', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000019&lang=vi&iduser=6&role=5', 0, 0),
(253, 6, '2019-04-09 11:43:49', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000018&lang=vi&iduser=6&role=5', 0, 0),
(254, 6, '2019-04-09 11:48:41', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000018&lang=vi&iduser=6&role=5', 0, 0),
(255, 6, '2019-04-09 11:51:08', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000018&lang=vi&iduser=6&role=5', 0, 0),
(256, 6, '2019-04-09 11:51:18', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000018&lang=vi&iduser=6&role=5', 0, 0),
(257, 6, '2019-04-09 11:52:01', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000017&lang=vi&iduser=6&role=5', 0, 0),
(258, 6, '2019-04-09 11:54:24', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000017&lang=vi&iduser=6&role=5', 0, 0),
(259, 4, '2019-04-09 11:54:57', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000017&lang=vi&iduser=4&role=3', 0, 0),
(260, 4, '2019-04-09 11:55:06', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000017&lang=vi&iduser=4&role=3', 0, 0),
(261, 4, '2019-04-09 11:55:20', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000020&lang=vi&iduser=4&role=3', 0, 0),
(262, 6, '2019-04-09 11:57:12', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000020&lang=vi&iduser=6&role=5', 0, 0),
(263, 6, '2019-04-09 11:57:23', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000020&lang=vi&iduser=6&role=5', 0, 0),
(264, 6, '2019-04-09 11:57:42', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000017&lang=vi&iduser=6&role=5', 0, 0),
(265, 250, '2019-04-09 11:59:32', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000020&lang=vi&iduser=250&role=5', 0, 0),
(266, 250, '2019-04-09 12:00:57', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000020&lang=vi&iduser=250&role=5', 0, 0),
(267, 250, '2019-04-09 12:01:08', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000017&lang=vi&iduser=250&role=5', 0, 0),
(268, 252, '2019-04-10 07:15:08', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000020&lang=vi&iduser=252&role=4', 0, 0),
(269, 252, '2019-04-10 07:19:37', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000020&lang=vi&iduser=252&role=4', 10.7927243, 106.6779258),
(270, 0, '2019-04-10 14:45:43', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=0000003&role=4&lang=vi', 10.228439331054688, 105.94800373673202),
(271, 252, '2019-04-13 04:54:33', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=85000000003&lang=vi&iduser=252&role=4', 10.7927169, 106.677926),
(272, 262, '2019-04-17 00:58:56', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000020&lang=vi&iduser=262&role=3', 0, 0),
(273, 2, '2019-04-17 21:59:11', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=2&idsp=0000003&role=1&lang=vi', 0, 106.6902770921588),
(274, 260, '2019-04-18 01:26:21', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000003&lang=vi&iduser=260&role=5', 0, 0),
(275, 260, '2019-04-18 01:34:14', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000003&lang=vi&iduser=260&role=5', 0, 0),
(276, 2, '2019-04-18 01:36:56', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=2&idsp=0000003&role=1&lang=vi', 10.792816162109375, 106.70508457357688),
(277, 260, '2019-04-18 01:38:21', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792861938476562, 106.70511608953281),
(278, 260, '2019-04-18 01:51:57', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792793273925781, 106.705061104248),
(279, 260, '2019-04-18 01:53:07', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792869567871094, 106.70507728132112),
(280, 260, '2019-04-18 01:55:05', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792839050292969, 106.70519965710743),
(281, 260, '2019-04-18 01:57:14', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792861938476562, 106.70512153776987),
(282, 260, '2019-04-18 01:58:27', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792854309082031, 106.70511960993214),
(283, 260, '2019-04-18 02:00:25', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792854309082031, 106.70511960993214),
(284, 260, '2019-04-18 02:01:04', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792854309082031, 106.70511960993214),
(285, 260, '2019-04-18 02:02:19', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792869567871094, 106.70511868792279),
(286, 260, '2019-04-18 02:03:09', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792861938476562, 106.70511583807571),
(287, 260, '2019-04-18 02:06:40', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792930603027344, 106.70508340011044),
(288, 260, '2019-04-18 02:07:13', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792877197265625, 106.70505414726837),
(289, 260, '2019-04-18 02:09:05', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792831420898438, 106.70508407066269),
(290, 260, '2019-04-18 02:26:32', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792961120605469, 106.7051734217505),
(291, 260, '2019-04-18 02:32:20', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792686462402344, 106.70507434765501),
(292, 260, '2019-04-18 02:42:39', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.7928466796875, 106.70500645423932),
(293, 260, '2019-04-18 02:43:43', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792755126953125, 106.7050679774086),
(294, 0, '2019-04-18 02:44:13', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=0000003&role=4&lang=vi', 10.792877197265625, 106.70519135902329),
(295, 0, '2019-04-18 02:44:51', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=0000003&role=4&lang=vi', 10.792831420898438, 106.70515020387872),
(296, 0, '2019-04-18 02:45:32', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=0000003&role=4&lang=vi', 10.792823791503906, 106.70514182197554),
(297, 0, '2019-04-18 02:47:50', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=0000003&role=4&lang=vi', 10.792915344238281, 106.70509060854717),
(298, 0, '2019-04-18 02:48:56', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=0000003&role=4&lang=vi', 10.792800903320312, 106.70513570318623),
(299, 0, '2019-04-18 02:52:05', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=0000003&role=4&lang=vi', 10.792762756347656, 106.70507552112146),
(300, 0, '2019-04-18 02:52:22', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=0000003&role=4&lang=vi', 10.79278564453125, 106.7050679774086),
(301, 260, '2019-04-18 02:52:56', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792808532714844, 106.70506093660994),
(302, 260, '2019-04-18 02:53:27', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792823791503906, 106.70504869903131),
(303, 260, '2019-04-18 02:56:17', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792594909667969, 106.70511080893381),
(304, 260, '2019-04-18 02:58:18', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792793273925781, 106.70513411062463),
(305, 260, '2019-04-18 02:59:06', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792747497558594, 106.70514944950743),
(306, 260, '2019-04-18 03:00:53', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792938232421875, 106.70514048087104),
(307, 260, '2019-04-18 03:02:36', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792892456054688, 106.70515615502997),
(308, 260, '2019-04-18 03:03:05', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792892456054688, 106.70515615502997),
(309, 260, '2019-04-18 03:14:11', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792854309082031, 106.70507216836019),
(310, 260, '2019-04-18 03:14:40', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792793273925781, 106.70510611506803),
(311, 260, '2019-04-18 03:15:50', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792778015136719, 106.70509010563298),
(312, 260, '2019-04-18 03:16:13', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.7928466796875, 106.70510242703064),
(313, 260, '2019-04-18 03:18:08', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792884826660156, 106.70510645034416),
(314, 260, '2019-04-18 03:18:16', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792854309082031, 106.70508834543331),
(315, 260, '2019-04-18 03:18:51', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792816162109375, 106.70507610785468),
(316, 260, '2019-04-18 03:21:35', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792694091796875, 106.705021457846),
(317, 260, '2019-04-18 03:22:23', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.79278564453125, 106.70512128631277),
(318, 260, '2019-04-18 03:22:53', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.7928466796875, 106.70510184029742),
(319, 260, '2019-04-18 03:23:05', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792861938476562, 106.70508692050977),
(320, 260, '2019-04-18 03:23:44', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792831420898438, 106.70510225939258),
(321, 260, '2019-04-18 03:23:57', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792831420898438, 106.70510225939258),
(322, 260, '2019-04-18 03:24:21', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792831420898438, 106.70510225939258),
(323, 260, '2019-04-18 03:25:12', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792854309082031, 106.70511240149541),
(324, 260, '2019-04-18 03:25:27', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792854309082031, 106.70511240149541),
(325, 260, '2019-04-18 03:26:51', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=260&idsp=0000003&role=5&lang=vi', 10.792877197265625, 106.7051287462066),
(326, 260, '2019-04-18 03:28:34', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000003&lang=vi&iduser=260&role=5', 0, 0),
(327, 260, '2019-04-18 03:29:35', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000003&lang=vi&iduser=260&role=5', 0, 0),
(328, 260, '2019-04-18 03:29:52', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000003&lang=vi&iduser=260&role=5', 0, 0),
(329, 260, '2019-04-18 03:31:10', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000003&lang=vi&iduser=260&role=5', 0, 0),
(330, 260, '2019-04-18 03:34:42', 'https://www.vinatt.vn/vinatt/webadmin/traceability.html?idsp=0000003&lang=vi&iduser=260&role=5', 0, 0),
(331, 0, '2019-04-20 14:35:05', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798240661621094, 106.69026939208311),
(332, 0, '2019-04-20 14:35:30', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798202514648438, 106.6902455874781),
(333, 0, '2019-04-20 14:37:52', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798210144042969, 106.69029378342134),
(334, 0, '2019-04-20 14:39:28', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798210144042969, 106.69030166241032),
(335, 0, '2019-04-20 14:39:38', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798240661621094, 106.69037072929245),
(336, 0, '2019-04-20 14:42:57', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798225402832031, 106.69021633463603),
(337, 0, '2019-04-20 14:44:00', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798271179199219, 106.69025011370582),
(338, 0, '2019-04-20 14:50:31', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798210144042969, 106.6902804561953),
(339, 0, '2019-04-20 15:17:31', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798233032226562, 106.69031591164571),
(340, 0, '2019-04-20 15:17:36', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798309326171875, 106.6903267243008),
(341, 0, '2019-04-20 15:25:45', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798187255859375, 106.69027765712973),
(342, 0, '2019-04-20 15:25:55', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798187255859375, 106.69027416976792),
(343, 0, '2019-04-20 15:31:03', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798210144042969, 106.69030214899414),
(344, 0, '2019-04-20 15:38:16', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798370361328125, 106.69030409316224),
(345, 0, '2019-04-20 15:38:21', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798332214355469, 106.69034684086841),
(346, 0, '2019-04-20 15:40:32', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798255920410156, 106.69034013534588),
(347, 0, '2019-04-20 15:54:27', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798210144042969, 106.69027316393954),
(348, 0, '2019-04-20 15:56:35', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798194885253906, 106.69027279155824),
(349, 0, '2019-04-20 15:57:42', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798202514648438, 106.69030555402442),
(350, 0, '2019-04-20 15:59:26', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798187255859375, 106.69033351364237),
(351, 0, '2019-04-20 16:02:55', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798202514648438, 106.6902719574656),
(352, 0, '2019-04-20 16:05:18', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798225402832031, 106.69025606485707),
(353, 0, '2019-04-20 16:06:33', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798225402832031, 106.6902784643452),
(354, 0, '2019-04-20 16:06:39', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798255920410156, 106.6901937873165),
(355, 0, '2019-04-20 16:13:03', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.7982177734375, 106.69027838654287),
(356, 0, '2019-04-20 16:19:19', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798202514648438, 106.69028900573653),
(357, 0, '2019-04-20 16:21:10', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798202514648438, 106.69028900573653),
(358, 0, '2019-04-20 16:22:03', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798202514648438, 106.69028900573653),
(359, 0, '2019-04-20 16:24:09', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798225402832031, 106.69031767184538),
(360, 0, '2019-04-20 16:29:09', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798210144042969, 106.69026643573883),
(361, 0, '2019-04-20 16:30:04', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.7982177734375, 106.69026847007376),
(362, 0, '2019-04-20 16:33:24', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798202514648438, 106.69029152030748),
(363, 0, '2019-04-20 16:41:17', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798202514648438, 106.69029263380011),
(364, 0, '2019-04-20 16:44:39', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798202514648438, 106.69027537548388),
(365, 0, '2019-04-20 16:44:45', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798202514648438, 106.69028603730511),
(366, 0, '2019-04-20 16:45:17', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798500061035156, 106.69005389335257),
(367, 0, '2019-04-20 16:45:21', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798416137695312, 106.69016084643704),
(368, 0, '2019-04-20 16:45:25', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.798561096191406, 106.69022007453181);
INSERT INTO `historyuser` (`id`, `iduser`, `create_date`, `link`, `lat`, `lng`) VALUES
(369, 0, '2019-04-22 09:33:33', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=0000020&role=4&lang=vi', 10.792793273925781, 106.67790992511654),
(370, 0, '2019-04-22 16:25:24', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.780609130859375, 106.77076034807244),
(371, 0, '2019-04-22 16:25:48', 'https://www.vinatt.vn:9000/vinatt/webadmin/traceability.html?iduser=0&idsp=85000000001&role=4&lang=vi', 10.780647277832031, 106.77074846002377);

-- --------------------------------------------------------

--
-- Table structure for table `imagesactivity`
--

CREATE TABLE IF NOT EXISTS `imagesactivity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `urlimg` text NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=44 ;

--
-- Dumping data for table `imagesactivity`
--

INSERT INTO `imagesactivity` (`id`, `urlimg`, `create_date`) VALUES
(27, 'image_upload/img_1553674114088', '2019-03-27 01:08:39'),
(28, 'image_upload/img_1553674108105', '2019-03-27 01:08:42'),
(29, 'image_upload/img_1553674099616', '2019-03-27 01:08:44'),
(30, 'image_upload/img_1553674091516', '2019-03-27 01:08:48'),
(31, 'image_upload/img_1553674085120', '2019-03-27 01:08:50'),
(32, 'image_upload/img_1553674066922', '2019-03-27 01:08:52'),
(33, 'image_upload/img_1553674059648', '2019-03-27 01:08:55'),
(34, 'image_upload/img_1553674053939', '2019-03-27 01:08:57'),
(35, 'image_upload/img_1553674048025', '2019-03-27 01:09:00'),
(36, 'image_upload/img_1553674032787', '2019-03-27 01:09:02'),
(37, 'image_upload/img_1553674038612', '2019-03-27 01:09:05'),
(38, 'image_upload/img_1553674043330', '2019-03-27 01:09:07'),
(39, 'image_upload/img_1553674028068', '2019-03-27 01:09:10'),
(40, 'image_upload/img_1553674023566', '2019-03-27 01:09:12'),
(41, 'image_upload/img_1553674018583', '2019-03-27 01:09:15'),
(42, 'image_upload/img_1553674013462', '2019-03-27 01:09:18'),
(43, 'image_upload/img_1553677030884', '2019-03-27 08:12:40');

-- --------------------------------------------------------

--
-- Table structure for table `introducecompany`
--

CREATE TABLE IF NOT EXISTS `introducecompany` (
  `idintro` int(11) NOT NULL,
  `contentintro_vi` text NOT NULL,
  `contentintro_en` text NOT NULL,
  `listimg` text NOT NULL,
  PRIMARY KEY (`idintro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `introducecompany`
--

INSERT INTO `introducecompany` (`idintro`, `contentintro_vi`, `contentintro_en`, `listimg`) VALUES
(1, '<h1 style="text-align:center"><span style="font-size:16px"><strong><span style="color:#e74c3c">C&Ocirc;NG TY TNHH THƯƠNG MẠI DỊCH VỤ XUẤT NHẬP KHẨU VINA T&amp;T</span></strong></span></h1>\n\n<h2 style="text-align:center"><span style="font-size:16px"><strong><span style="color:#e74c3c">Thương Hiệu Th&agrave;nh C&ocirc;ng</span></strong></span></h2>\n\n<h2 style="text-align:center"><span style="font-size:16px"><strong><span style="color:#e74c3c">bằng Uy T&iacute;n v&agrave; Chất Lượng Sản Phẩm</span></strong></span></h2>\n\n<p style="text-align:justify">&nbsp;</p>\n\n<p style="text-align:justify"><span style="font-size:16px"><strong>C&ocirc;ng ty</strong>&nbsp;<strong>TNHH TM DV XUẤT NHẬP KHẨU VINA T&amp;T&nbsp;</strong>(gọi tắt l&agrave;&nbsp;<strong>C&Ocirc;NG TY XUẤT NHẬP KHẨU VINA T&amp;T</strong>) với ng&agrave;nh nghề ch&iacute;nh chuy&ecirc;n về mua b&aacute;n v&agrave; chế biến:</span></p>\n\n<ul>\n	<li style="text-align:justify"><span style="font-size:16px"><strong>N&ocirc;ng Sản: Bao gồm c&aacute;c mặt h&agrave;ng như: thanh long, nh&atilde;n, ch&ocirc;m ch&ocirc;m, v&uacute; sữa, xo&agrave;i, sầu ri&ecirc;ng, sữa, mận, gạo hữu cơ,&hellip;</strong></span></li>\n	<li style="text-align:justify"><span style="font-size:16px"><strong>Thực phẩm kh&ocirc;: b&uacute;n, gạo, b&aacute;nh tr&aacute;ng, m&igrave; c&aacute;c loại, phở, hủ tiếu, tr&agrave;, b&aacute;nh kẹo, tr&aacute;i c&acirc;y sấy, caf&eacute;,...&nbsp;</strong></span></li>\n	<li style="text-align:justify"><span style="font-size:16px"><strong>Hải sản: Ngh&ecirc;u, c&aacute;, t&ocirc;m, mực&hellip;</strong></span></li>\n	<li style="text-align:justify"><span style="font-size:16px"><strong>H&agrave;ng ti&ecirc;u d&ugrave;ng: h&agrave;ng inox gia dụng, nhựa gia dụng, gi&agrave;y d&eacute;p,&hellip;</strong></span></li>\n</ul>\n\n<h3 style="text-align:justify"><span style="font-size:16px"><strong>VINA T&amp;T &ndash; PHƯƠNG CH&Acirc;M &ldquo;CHẤT LƯỢNG CỦA CH&Uacute;NG T&Ocirc;I &ndash; TH&Agrave;NH C&Ocirc;NG CỦA C&Aacute;C BẠN&rdquo;</strong></span></h3>\n\n<p style="text-align:justify"><span style="font-size:16px">Ch&uacute;ng t&ocirc;i hoạt động kinh doanh rộng khắp tr&ecirc;n c&aacute;c v&ugrave;ng miền của cả nước v&agrave; c&aacute;c nước bạn. Với nhiều năm kinh nghiệm v&agrave; uy t&iacute;n, hệ thống nh&agrave; xưởng, d&acirc;y chuyền, m&aacute;y m&oacute;c thiết bị đồng bộ v&agrave; hiện đại, c&aacute;c kho được bố tr&iacute; tại c&aacute;c điểm &ldquo;rốn&rdquo;, c&aacute;c điểm tập kết hoặc cảng biển thuận tiện cho việc thu mua, chế biến v&agrave; xuất khẩu n&ocirc;ng sản, đảm bảo phục vụ kh&aacute;ch h&agrave;ng mọi l&uacute;c mọi nơi.</span></p>\n\n<p style="text-align:justify"><span style="font-size:16px">Việc &aacute;p dụng hệ thống quản l&yacute; chất lượng h&agrave;ng h&oacute;a theo c&aacute;c ti&ecirc;u chuẩn ISO v&agrave; HACCP, C&ocirc;ng ty ch&uacute;ng t&ocirc;i đ&atilde; sản xuất v&agrave; cung cấp ra thị trường sản phẩm c&oacute; chất lượng cao, đạt ti&ecirc;u chuẩn h&agrave;ng xuất khẩu, bảo đảm y&ecirc;u cầu vệ sinh an to&agrave;n thực phẩm. C&ocirc;ng ty hiện kh&ocirc;ng ngừng cải tiến kỹ thuật, &aacute;p dụng khoa học c&ocirc;ng nghệ mới nhằm n&acirc;ng cao chất lượng sản phẩm dịch vụ.</span></p>\n\n<p style="text-align:justify"><span style="font-size:16px">Với hệ thống xe tải đa dạng về k&iacute;ch cỡ, trọng tải v&agrave; đội ngũ c&aacute;n bộ c&ocirc;ng nh&acirc;n vi&ecirc;n gi&agrave;u kinh nghiệm, nhiệt t&igrave;nh năng động. Chắc chắn ch&uacute;ng t&ocirc;i sẽ l&agrave;m h&agrave;i l&ograve;ng qu&yacute; kh&aacute;ch h&agrave;ng nếu được hợp t&aacute;c. Ch&uacute;ng t&ocirc;i cam kết sẽ thực hiện tốt tất cả c&aacute;c hợp đồng, c&aacute;c số lượng, c&aacute;c mặt h&agrave;ng, c&aacute;c lĩnh vực m&agrave; ch&uacute;ng t&ocirc;i đang hoạt động.</span></p>\n\n<p style="text-align:justify"><span style="font-size:16px">L&agrave; một doanh nghiệp c&oacute; bề d&agrave;y kinh nghiệm, c&oacute; quan hệ hợp t&aacute;c kinh doanh, đầu tư với nhiều đối t&aacute;c c&oacute; uy t&iacute;n trong nước cũng như tr&ecirc;n thế giới. C&aacute;c đối t&aacute;c của ch&uacute;ng t&ocirc;i chủ yếu l&agrave; c&aacute;c Nh&agrave; m&aacute;y chế biến, c&aacute;c C&ocirc;ng ty thương mại, c&aacute;c thị trường Trung Quốc, Nhật Bản, Mỹ, H&agrave; Lan, Ph&aacute;p, Banglades v&agrave; Ấn độ&hellip;</span></p>\n\n<h3 style="text-align:justify"><span style="font-size:16px"><strong>CAM KẾT CỦA VINA T&amp;T</strong></span></h3>\n\n<p style="text-align:justify"><span style="font-size:16px">- Ch&uacute;ng t&ocirc;i cam kết đảm bảo số lượng, chất lượng, độ ẩm v&agrave; c&aacute;c th&agrave;nh phần kỹ thuật theo đ&uacute;ng y&ecirc;u cầu của đối t&aacute;c với mỗi đơn h&agrave;ng xuất đi.</span></p>\n\n<p style="text-align:justify"><span style="font-size:16px">- Với tr&aacute;ch nhiệm cao nhất, ch&uacute;ng t&ocirc;i cam kết sản phẩm v&agrave; dịch vụ được cung cấp từ C&ocirc;ng ty sẽ l&agrave; sản phẩm v&agrave; dịch vụ tốt nhất, thoả m&atilde;n mọi nhu cầu của kh&aacute;ch h&agrave;ng.</span></p>\n\n<p style="text-align:justify"><span style="font-size:16px">Với quan niệm&nbsp;<strong><em>&ldquo;C&aacute;ch tốt nhất để cạnh tranh v&agrave; ph&aacute;t triển l&agrave; phải đảm bảo lợi &iacute;ch của kh&aacute;ch h&agrave;ng&rdquo;</em></strong>, Ch&uacute;ng t&ocirc;i mong muốn được hợp t&aacute;c kinh doanh, đầu tư c&ugrave;ng ph&aacute;t triển, c&ugrave;ng chia sẻ lợi nhuận với đối t&aacute;c trong v&agrave; ngo&agrave;i nước.</span></p>\n\n<p style="text-align:justify"><span style="font-size:16px">K&iacute;nh ch&uacute;c qu&yacute; kh&aacute;ch h&agrave;ng v&agrave; c&aacute;c đối t&aacute;c dồi d&agrave;o sức khỏe, th&agrave;nh đạt, hạnh ph&uacute;c!</span></p>\n\n<p style="text-align:justify"><span style="font-size:16px">Rất h&acirc;n hạnh được hợp t&aacute;c c&ugrave;ng Qu&yacute; Doanh nghiệp v&agrave; c&aacute; nh&acirc;n tr&ecirc;n cả nước.</span></p>\n\n<p style="text-align:justify"><span style="font-size:16px"><span style="color:#e74c3c"><strong>Qu&aacute; tr&igrave;nh h&agrave;nh th&agrave;nh v&agrave; ph&aacute;t triển</strong></span></span></p>\n\n<p><span style="font-size:16px">C&ocirc;ng ty VINA T&amp;T GROUP l&agrave; một trong những đơn vị c&oacute; uy tin, đ&atilde; khẳng định được thương hiệu trong lĩnh vực xuất nhập khẩu trong nước v&agrave; ngo&agrave;i nước. Trải qua nhiều năm x&acirc;y dựng v&agrave; ph&aacute;t triển, C&ocirc;ng ty VINA T&amp;T GROUP đang ng&agrave;y c&agrave;ng khẳng định được vị thế của m&igrave;nh. Trong suốt qu&aacute; tr&igrave;nh hoạt động, kh&ocirc;ng thể kể hết những kh&oacute; khăn cũng như những trở ngại m&agrave; tập thể bang l&atilde;nh đạo v&agrave; nh&acirc;n vi&ecirc;n C&ocirc;ng ty VINA T&amp;T GROUP phải vượt qua từ những ng&agrave;y th&aacute;ng khởi nghiệp, đổi lại đến nay c&ocirc;ng ty đ&atilde; khẳng định được uy t&iacute;n, vị thế, thương hiệu của m&igrave;nh trong lĩnh xuất nhập khẩu. Để tồn tại tr&ecirc;n thị trường cạnh tranh ng&agrave;y c&agrave;ng khốc liệt v&agrave; đ&aacute;p ứng được y&ecirc;u cầu ng&agrave;y c&agrave;ng cao của thị trường cũng như sự ph&aacute;t triển kh&ocirc;ng ngừng của đất nước, C&ocirc;ng ty đ&atilde; x&acirc;y dựng chiến lược cho ri&ecirc;ng m&igrave;nh, với đội ngũ l&atilde;nh đạo, nh&acirc;n vi&ecirc;n năng động v&agrave; c&oacute; tinh thần tr&aacute;ch nhiệm cao. C&ocirc;ng ty VINA T&amp;T GROUP mong muốn trở th&agrave;nh đối t&aacute;c tin cậy với tất cả c&aacute;c kh&aacute;ch h&agrave;ng v&agrave; sẵn s&agrave;ng hợp t&aacute;c, li&ecirc;n doanh với c&aacute;c đối t&aacute;c trong v&agrave; ngo&agrave;i nước tr&ecirc;n cơ sở đảm bảo lợi &iacute;ch của c&aacute;c b&ecirc;n.</span></p>\n', '<h1 style="text-align:center"><span style="font-size:16px"><strong>VINA T&amp;T IMPORT - EXPORT SERVICE TRADING&nbsp;CO., LTD</strong></span></h1>\n\n<h2 style="text-align:justify"><span style="font-size:16px">Successful Brands From Prestige and High Quality Products</span></h2>\n\n<p style="text-align:justify"><span style="font-size:16px"><strong>Dear Business, Partners and Customers...</strong></span></p>\n\n<p style="text-align:justify"><span style="font-size:16px">First, we would like to thank you customers and partners have cooperated with us for the last time in the supply of high quality products.</span></p>\n\n<p style="text-align:justify"><span style="font-size:16px"><strong>VINA T&amp;T IMPORT - EXPORT SERVICE TRADING&nbsp;CO., LTD&nbsp;</strong>-&nbsp;<strong>VINA T&amp;T</strong>&nbsp;unit is focused on improving the quality of agricultural products, Seafood, Consumer, Dried Food in order to meet the increasing needs of consumers and customers.</span></p>\n\n<p style="text-align:justify"><span style="font-size:16px">Throughout the years, we constantly invest equipment, modern technology line toward rebranding some agricultural commodities in the country on the National and International Markets.</span></p>\n\n<p style="text-align:justify"><span style="font-size:16px">We are proud to be the only company to provide high quality agricultural products for great manufacturers of United States. Besides, the large business reputation locally and has ordered us.</span></p>\n\n<p style="text-align:justify"><span style="font-size:16px">Currently, ViNa T&amp;T is stepping up the supply of the domestic and international market for some of the following products:</span></p>\n\n<ul>\n	<li style="text-align:justify"><span style="font-size:16px"><strong>Agricultural Products: The agricultural commodities such as dragon fruit, ring, rambutan, star apple, mango, durian, milk, plums, organic rice,...</strong></span></li>\n	<li style="text-align:justify"><span style="font-size:16px"><strong>Dry Food: Noodles, rice, cake, all kinds of noodles, rice&nbsp;noodles, dried&nbsp;noodles,&nbsp;tea, candies, dried fruit, coffee,&hellip;</strong></span></li>\n	<li style="text-align:justify"><span style="font-size:16px"><strong>Seafood: Clam, fish, shrimp, squid...</strong></span></li>\n	<li style="text-align:justify"><span style="font-size:16px"><strong>Consumer Goods: Stainless steel, household plastic, footwear,...</strong></span></li>\n</ul>\n\n<h3 style="text-align:justify"><span style="font-size:16px"><strong>VINA T &amp; T - MOTTO &quot;OUR QUALITY - YOUR SUCCESS&quot;</strong></span></h3>\n\n<p style="text-align:justify"><span style="font-size:16px">Our business activities widely in different regions of the Country and International Markets. With years of experience and reputation, the factory system, chains, machinery and modern synchronization, the warehouses are located at the points &quot;navel&quot; or the assembly point, seaport to take advantage for purchasing, processing and exporting of agricultural products and ensuring meet to customer&rsquo;s needs anytime, anywhere.</span></p>\n\n<p style="text-align:justify"><span style="font-size:16px">The application of management system about the quality of goods in accordance with ISO and HACCP, our company has been manufacturing and supplying the market with high quality products, standards about export, ensuring required hygiene and food safety. The company is constantly improving the technical, scientific application of new technologies to improve the quality of products and services.</span></p>\n\n<p style="text-align:justify"><span style="font-size:16px">With diverse systems about size of truck, tonnage and staffs of experienced workers with dynamic enthusiasm. Certainly we will satisfy customers if they are to cooperate. We are committed to implement all the contracts, the quantity, the items, the areas in which we are operating.</span></p>\n\n<p style="text-align:justify"><span style="font-size:16px">With the concept of&nbsp;<strong><em>&ldquo;THE BEST WAY TO COMPETE AND DEVELOP IS TO ENSURE IN THE CUSTOMERS&rsquo; INTERESTS&rdquo;</em></strong>, for many years, ViNa T&amp;T Import Export Service TraDing Co.,Ltd has actually created the trust of domestic and foreign customers and has developed trading relationships with many countries worldwide. Our partners are mainly the processing plant, the commercial company, the Chinese market, markets of Japan, USA, Netherlands, France, Bangladesh and India...</span></p>\n\n<h3 style="text-align:justify"><span style="font-size:16px"><strong>COMMITMENT OF VINA T &amp; T</strong></span></h3>\n\n<p style="text-align:justify"><span style="font-size:16px">- We are committed to ensure the quantity, quality, humidity and other technical components in accordance with the request of partners with each order shipped.</span></p>\n\n<p style="text-align:justify"><span style="font-size:16px">- With the highest responsibility, we are committed to products and services provided by the Company will be the best products and services, satisfying the needs of customers.</span></p>\n\n<p style="text-align:justify"><span style="font-size:16px">We know that the existence and development of a business can not separate the two sides close cooperation for mutual benefits. Our company is very pleased to contact, trade and cooperate in investment and joint venture with domestic and foreign customers. Therefore, we respectfully submit this letter to You and Your Business customers and partners all over the world. We are always pleased to welcome the cooperation from you.</span></p>\n\n<p style="text-align:justify"><span style="font-size:16px">Enterprise wish you, your clients and partners Health - Success and Development!</span></p>\n', '["image_upload/img_1553677030884","image_upload/img_1553506677030"]');

-- --------------------------------------------------------

--
-- Table structure for table `joinsanpham_nhapp`
--

CREATE TABLE IF NOT EXISTS `joinsanpham_nhapp` (
  `manpp` int(5) unsigned zerofill NOT NULL,
  `idsp` varchar(50) NOT NULL,
  `datetimejoin` timestamp NOT NULL DEFAULT current_timestamp(),
  `stt` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`stt`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `joinsanpham_nhapp`
--

INSERT INTO `joinsanpham_nhapp` (`manpp`, `idsp`, `datetimejoin`, `stt`) VALUES
(00262, '0000020', '2019-04-17 00:59:15', 5);

-- --------------------------------------------------------

--
-- Table structure for table `joinsanpham_nhasoche`
--

CREATE TABLE IF NOT EXISTS `joinsanpham_nhasoche` (
  `mansc` int(5) unsigned zerofill NOT NULL,
  `idsp` varchar(50) NOT NULL,
  `datetimejoin` timestamp NOT NULL DEFAULT current_timestamp(),
  `stt` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`stt`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `joinsanpham_nhasoche`
--

INSERT INTO `joinsanpham_nhasoche` (`mansc`, `idsp`, `datetimejoin`, `stt`) VALUES
(04379, '85000000001', '2019-04-04 00:51:38', 2);

-- --------------------------------------------------------

--
-- Table structure for table `joinsanpham_nhavc`
--

CREATE TABLE IF NOT EXISTS `joinsanpham_nhavc` (
  `manvc` int(5) unsigned zerofill NOT NULL,
  `idsp` varchar(50) NOT NULL,
  `datetimejoin` timestamp NOT NULL DEFAULT current_timestamp(),
  `nametx` varchar(500) NOT NULL,
  `phonetx` varchar(15) NOT NULL,
  `biensopt` varchar(30) NOT NULL,
  `stt` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`stt`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=13 ;

--
-- Dumping data for table `joinsanpham_nhavc`
--

INSERT INTO `joinsanpham_nhavc` (`manvc`, `idsp`, `datetimejoin`, `nametx`, `phonetx`, `biensopt`, `stt`) VALUES
(00081, '0000003', '2019-04-18 03:35:21', 'Nha', '09391', '123', 12);

-- --------------------------------------------------------

--
-- Table structure for table `libra`
--

CREATE TABLE IF NOT EXISTS `libra` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `listimage` text NOT NULL,
  `create_img` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=76 ;

--
-- Dumping data for table `libra`
--

INSERT INTO `libra` (`id`, `listimage`, `create_img`) VALUES
(31, 'image_upload/img_1553674013462', '2019-03-27 01:06:54'),
(32, 'image_upload/img_1553674018583', '2019-03-27 01:06:59'),
(33, 'image_upload/img_1553674023566', '2019-03-27 01:07:04'),
(34, 'image_upload/img_1553674028068', '2019-03-27 01:07:08'),
(35, 'image_upload/img_1553674032787', '2019-03-27 01:07:13'),
(36, 'image_upload/img_1553674038612', '2019-03-27 01:07:19'),
(37, 'image_upload/img_1553674043330', '2019-03-27 01:07:24'),
(38, 'image_upload/img_1553674048025', '2019-03-27 01:07:28'),
(39, 'image_upload/img_1553674053939', '2019-03-27 01:07:34'),
(40, 'image_upload/img_1553674059648', '2019-03-27 01:07:40'),
(41, 'image_upload/img_1553674066922', '2019-03-27 01:07:47'),
(42, 'image_upload/img_1553674085120', '2019-03-27 01:08:05'),
(43, 'image_upload/img_1553674091516', '2019-03-27 01:08:12'),
(44, 'image_upload/img_1553674099616', '2019-03-27 01:08:20'),
(45, 'image_upload/img_1553674108105', '2019-03-27 01:08:28'),
(46, 'image_upload/img_1553674114088', '2019-03-27 01:08:34'),
(47, 'image_upload/img_1553677030884', '2019-03-27 01:57:11'),
(64, 'image_upload/img_1554487271184', '2019-04-05 11:01:16'),
(65, 'image_upload/img_1555922605059', '2019-04-22 08:43:33'),
(66, 'image_upload/img_1555922623750', '2019-04-22 08:43:51'),
(67, 'image_upload/img_1555922630461', '2019-04-22 08:43:58'),
(68, 'image_upload/img_1555924031244', '2019-04-22 09:07:27'),
(69, 'image_upload/img_1555924051568', '2019-04-22 09:07:50'),
(70, 'image_upload/img_1555924792534', '2019-04-22 09:20:08'),
(73, 'image_upload/img_1555934508451', '2019-04-22 12:02:05'),
(75, 'image_upload/img_1555937249248', '2019-04-22 12:47:46');

-- --------------------------------------------------------

--
-- Table structure for table `loaisp`
--

CREATE TABLE IF NOT EXISTS `loaisp` (
  `maloai` varchar(10) NOT NULL,
  `tenloai` varchar(500) NOT NULL,
  `tenloai_en` varchar(500) NOT NULL,
  `hinhanh` text NOT NULL,
  PRIMARY KEY (`maloai`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `loaisp`
--

INSERT INTO `loaisp` (`maloai`, `tenloai`, `tenloai_en`, `hinhanh`) VALUES
('B', 'Bưởi ', 'Pomelo', 'image_upload/img_1553676561461'),
('C', 'Cam', 'Orange', 'image_upload/img_1553676570410'),
('CC', 'Chôm Chôm', 'Rambutan', 'image_upload/img_1553676578289'),
('KL', 'Khoai lang ', ' sweet potato', 'image_upload/img_1554486472670'),
('M', 'Mận', 'Plum', 'image_upload/img_1553676586125'),
('N', 'Nhãn', 'Longan', 'image_upload/img_1553676597500'),
('SR', 'Sầu Riêng', 'Durian', 'image_upload/img_1553676605265'),
('TL', 'Thanh long', 'Dragon', 'image_upload/img_1553676614343'),
('VS', 'Vú Sữa', 'Star Apple', 'image_upload/img_1554486481047'),
('X', 'Xoài ', 'Mango', 'image_upload/img_1554486490678');

-- --------------------------------------------------------

--
-- Table structure for table `news`
--

CREATE TABLE IF NOT EXISTS `news` (
  `idnews` bigint(20) NOT NULL AUTO_INCREMENT,
  `title_vi` text NOT NULL,
  `title_en` text NOT NULL,
  `content_vi` text NOT NULL,
  `content_en` text NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `urlimg` text NOT NULL,
  `iduser` bigint(20) NOT NULL,
  `short_description_vi` text NOT NULL,
  `short_description_en` text NOT NULL,
  `visible` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`idnews`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=26 ;

--
-- Dumping data for table `news`
--

INSERT INTO `news` (`idnews`, `title_vi`, `title_en`, `content_vi`, `content_en`, `create_date`, `urlimg`, `iduser`, `short_description_vi`, `short_description_en`, `visible`) VALUES
(1, 'Vina TT Group xuất khẩu xoài đầu năm', 'Vina TT Group exported the first mangos in 2019', '<p>Những ng&agrave;y xu&acirc;n chưa hết nhưng c&aacute;c nh&agrave; m&aacute;y của Vina T&amp;T Group đ&atilde; bắt tay tập trung sản xuất. Từ m&ugrave;ng 4 tết (ng&agrave;y 8-2), nh&agrave; m&aacute;y đặt tại huyện Chợ Gạo (tỉnh Tiền Giang) đ&atilde; nhận tr&aacute;i c&acirc;y từ c&aacute;c nh&agrave; vườn Tiền Giang, c&ograve;n nh&agrave; m&aacute;y huyện Cai Lậy nhận sản phẩm từ Đồng Th&aacute;p, Vĩnh Long. B&ecirc;n trong nh&agrave; m&aacute;y, h&igrave;nh ảnh những c&ocirc;ng nh&acirc;n hối hả lựa chọn từng tr&aacute;i thanh long chuyển v&agrave;o d&acirc;y chuyền chiếu xạ, đưa v&agrave;o kho lạnh để kịp chuẩn bị cho đơn h&agrave;ng xuất khẩu v&agrave;o m&ugrave;ng 7 tết (ng&agrave;y 11-2). Theo C&ocirc;ng ty Vina T&amp;T Group, trong ng&agrave;y đầu ti&ecirc;n l&agrave;m việc sau tết, c&ocirc;ng ty phải l&agrave;m thủ tục xuất khẩu 23 container nh&atilde;n, thanh long v&agrave; dừa đi Mỹ. Trong đ&oacute;, c&oacute; 16 container thanh long đi bằng đường h&agrave;ng kh&ocirc;ng, mỗi container khoảng 900kg. C&aacute;c container c&ograve;n lại đi bằng đường biển, gồm 2 container nh&atilde;n tổng cộng 36 tấn; 2 container thanh long tổng cộng 22 tấn v&agrave; 50.000 tr&aacute;i dừa tươi, ước t&iacute;nh khoảng 3 container.</p>\n', '<p>The spring days have not ended yet, but the factories of Vina T&amp;T Group have started to focus on production. From the 4th day of the Lunar New Year (February, the factory located in Cho Gao district (Tien Giang province) received fruits from Tien Giang gardeners, while the factory in Cai Lay district received products from Dong Thap and Vinh Long. Inside the factory, pictures of workers hasten to select each dragon fruit into the irradiation line and put them in cold storage to prepare for export orders on the 7th day of the Lunar New Year (February 11). According to Vina T&amp;T Group, in the first day of working after the Lunar New Year, the company had to export 23 containers of longan, dragon fruit and coconut to the US. Among them, 16 containers of dragon fruit are shipped by air, each container is about 900kg. The remaining containers are shipped by sea, including 2 containers of logan totaling 36 tons; 2 containers of dragon fruit totaling 22 tons and 50,000 fresh coconuts, estimated 3 containers.</p>\n', '2019-04-22 11:44:46', 'image_upload/img_1555924792534', 1, 'Những ngày xuân chưa hết nhưng các nhà máy của Vina T&T Group đã bắt tay tập trung sản xuất.', 'The spring days have not ended yet, but the factories of Vina T&T Group have started to focus on production.', 1),
(2, 'Việt Nam cũng đã chính thức cấp phép xuất cảng xoài sang thị trường Mỹ', 'Vietnamese authorities have officially granted export permits for mangoes to the US market', '<p style="text-align:justify">Sau 10 năm đ&agrave;m ph&aacute;n, ph&iacute;a Mỹ đ&atilde; chấp thuận cho xo&agrave;i Việt Nam ch&iacute;nh thức nhập cảng v&agrave;o thị trường n&agrave;y v&agrave; cơ quan chức năng của Việt Nam cũng đ&atilde; ch&iacute;nh thức cấp ph&eacute;p xuất cảng xo&agrave;i sang thị trường Mỹ. Theo đ&oacute;, Mỹ trở th&agrave;nh thị trường xuất cảng thứ 40 của xo&agrave;i Việt Nam, theo Người Lao Động (NLĐO).</p>\n\n<p style="text-align:center"><img alt="" src="https://www.vinatt.vn:9000/image_upload/img_1555924051568" style="height:400px; width:350px" /></p>\n\n<p style="text-align:justify">Sau khi được ph&eacute;p xuất cảng n&ecirc;u tr&ecirc;n, &ocirc;ng Nguyễn Đ&igrave;nh T&ugrave;ng, tổng GĐ C&ocirc;ng ty Vina T&amp;T, cho biết c&ocirc;ng ty &ocirc;ng sẽ ti&ecirc;n phong xuất cảng xo&agrave;i v&agrave;o thị trường Mỹ trong nay mai, với số lượng ban đầu khoảng 10 tấn xo&agrave;i c&aacute;t chu v&agrave; xo&agrave;i tượng. Sau đ&oacute; nếu ti&ecirc;u thụ tốt sẽ tăng số lượng cho thị trường n&agrave;y.</p>\n\n<p style="text-align:center"><img alt="" src="https://www.vinatt.vn:9000/image_upload/img_1555924031244" style="height:400px; width:350px" /></p>\n\n<p style="text-align:justify">NLĐO cho biết trong nhiều năm qua, Mỹ l&agrave; thị trường quen thuộc với Vina T&amp;T. Trong khoảng 15 doanh nghiệp VN xuất cảng tr&aacute;i c&acirc;y tươi v&agrave;o thị trường Mỹ, Hiện Vina T&amp;T chiếm tới 50% số lượng h&agrave;ng xuất.</p>\n', '<p style="text-align:justify">After 10 years of negotiations, the US has approved for Vietnamese mangoes to officially import into this market and the Vietnamese authorities have officially granted export permits for mangoes to the US market. Accordingly, the US became the 40th export market of Vietnamese mangoes.</p>\n\n<p style="text-align:center"><img alt="" src="https://www.vinatt.vn:9000/image_upload/img_1555924051568" style="height:300px; width:300px" /></p>\n\n<p style="text-align:justify">After being allowed to export, Mr. Nguyen Dinh Tung, General Director of Vina T&amp;T Company said that his company will pioneer mango export to the US market soon, with an initial amount of about 10 tons of Cat Chu mango and elephant-mango. After that, if the market is good, it will increase the quantity for this market.</p>\n\n<p style="text-align:center"><img alt="" src="https://www.vinatt.vn:9000/image_upload/img_1555924031244" style="height:300px; width:300px" /></p>\n\n<p style="text-align:justify">Lao Dong Newspaper said that in the past few years, the US was a familiar market for Vina T&amp;T. Of about 15 Vietnamese enterprises exporting fresh fruits to the US market, Vina T&amp;T Group currently occupy 50% of the total export volume.</p>\n', '2019-04-24 02:47:23', 'image_upload/img_1555924051568', 1, 'Sau 10 năm đàm phán, phía Mỹ đã chấp thuận cho xoài Việt Nam chính thức nhập cảng vào thị trường này và cơ quan chức năng của Việt Nam cũng đã chính thức cấp phép xuất cảng xoài sang thị trường Mỹ. ', 'After 10 years of negotiations, the US has approved for Vietnamese mangoes to officially import into this market and the Vietnamese authorities have officially granted export permits for mangoes to the US market', 1);

-- --------------------------------------------------------

--
-- Table structure for table `nhacungcap`
--

CREATE TABLE IF NOT EXISTS `nhacungcap` (
  `mancc` int(5) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `tenncc` varchar(800) NOT NULL DEFAULT '',
  `mst` varchar(100) DEFAULT '',
  `diachi` varchar(800) NOT NULL DEFAULT '',
  `sdt` varchar(30) NOT NULL DEFAULT '',
  `email` varchar(200) NOT NULL DEFAULT '',
  `lat` decimal(20,16) NOT NULL DEFAULT 0.0000000000000000,
  `lng` decimal(20,16) NOT NULL DEFAULT 0.0000000000000000,
  `website` varchar(200) DEFAULT '',
  `sofax` varchar(20) DEFAULT '',
  `facebook` varchar(500) DEFAULT '',
  `user` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`mancc`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=310 ;

--
-- Dumping data for table `nhacungcap`
--

INSERT INTO `nhacungcap` (`mancc`, `tenncc`, `mst`, `diachi`, `sdt`, `email`, `lat`, `lng`, `website`, `sofax`, `facebook`, `user`) VALUES
(00071, 'VINATT', '1501', 'VỈnh Long', '09391111', 'nha@gmail.com', 10.0009000000000000, 105.4343434300000000, 'viennhagroup.com', '02788888', 'facebook.com', 2),
(00075, 'Đoàn Văn Tài', '', 'Thành Hậu, Thành Đông, Bình Tân, Vĩnh Long', '0987120982', '', 10.1175990000000000, 105.7440790000000000, '', '', '', 14),
(00076, 'Đinh Văn Hùng', '', 'Mỹ Lợi, Mỹ Hòa, Bình Minh, Vĩnh Long', '0364522059', '', 10.0249960000000000, 105.8232890000000000, '', '', '', 15),
(00077, 'Đinh Quốc Hết', '', 'Mỹ Lợi, Mỹ Hòa, Bình Minh', '0907438211', '', 10.0307340000000000, 105.8322660000000000, '', '', '', 16),
(00078, 'Đinh Công Khâm', '', 'Mỹ Phước 1, Mỹ Hòa, Bình Minh, Vĩnh Long', '0918256567', '', 10.0211930000000000, 105.8363000000000000, '', '', '', 17),
(00079, 'Đào Văn Đầy', '', 'Hưng Hòa, Tân Hưng, Bình Tân', '01693325290', '', 10.1816870000000000, 105.7278650000000000, '', '', '', 18),
(00080, 'Đào Văn Thận', '', 'Ấp Phú An 2, Bình Hòa Phước, Long Hồ, Vĩnh Long', '0902799717', '', 10.2920890000000000, 106.0177140000000000, '', '', '', 19),
(00081, 'Võ Văn Nhọn', '', 'Mỹ Hưng 2, Mỹ Hòa, Bình Minh, Vĩnh Long', '0766818482', '', 10.0222440000000000, 105.8397210000000000, '', '', '', 20),
(00082, 'Võ Văn Lĩnh', '', 'Hưng Lợi, Tân Hưng, Bình Tân, Vĩnh Long', '01699258098', '', 10.1701630000000000, 105.7190100000000000, '', '', '', 21),
(00083, 'Võ Văn Hòa', '', 'Mỹ Hưng 2, Mỹ Hòa, Bình Minh, Vĩnh Long', '0933241533', '', 10.0192540000000000, 105.8397560000000000, '', '', '', 22),
(00084, 'Võ Văn Hoa', '', 'Mỹ Thới 1, Mỹ Hòa, Bình Minh, Vĩnh Long', '0397354488', '', 10.0229830000000000, 105.8383830000000000, '', '', '', 23),
(00085, 'Võ Văn Dững', '', 'Mỹ Hưng 2, Mỹ Hoà, Bình Minh, Vĩnh Long', '0939246241', '', 10.0139500000000000, 105.8354650000000000, '', '', '', 24),
(00086, 'Võ Thị Cẩm', '', 'Mỹ Thới 1, Mỹ Hòa, Bình Minh, Vĩnh Long', '0393752805', '', 10.0133690000000000, 105.8338770000000000, '', '', '', 25),
(00087, 'Võ Thanh Xuân', '', ' Mỹ Thới 1, Mỹ Hòa, Bình Minh, Vĩnh Long', '0961428407', '', 10.0130830000000000, 105.8352500000000000, '', '', '', 26),
(00088, 'Võ Sĩ Phụng Sơn', '', 'Tổ 14, Hòa Lợi, Hòa Ninh, Long Hồ, Vĩnh Long', '0369426462', '', 10.2815410000000000, 105.9960410000000000, '', '', '', 27),
(00089, 'Võ Phi Thường', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh, Vĩnh Long', '0974482538', '', 10.0334220000000000, 105.8301720000000000, '', '', '', 28),
(00090, 'Trương Văn Tám', '', 'Ấp Mỹ Thới 1, Mỹ Hòa, Bình Minh, Vĩnh Long', '0345612101', '', 10.0246850000000000, 105.8267390000000000, '', '', '', 29),
(00091, 'Trương Văn Sáng', '', 'Mỹ Thới 1, Mỹ Hòa, Bình Minh, Vĩnh Long', '0789650609', '', 10.0246220000000000, 105.8266530000000000, '', '', '', 30),
(00092, 'Trương Văn Liêm', '', 'Hưng Lợi, Tân Hưng, Bình Tân, Vĩnh Long', '01668512936', '', 10.1835090000000000, 105.7389250000000000, '', '', '', 31),
(00093, 'Trương Văn Khanh', '', 'Mỹ Thới 1, Mỹ Hòa, Bình Minh, Vĩnh Long', '0789704816', '', 10.0305080000000000, 105.8370280000000000, '', '', '', 32),
(00094, 'Trương Văn Anh', '', 'Mỹ Hưng 2, Mỹ Hòa, Bình Minh', '0342202696', '', 10.0227850000000000, 105.8371990000000000, '', '', '', 33),
(00095, 'Trương Trung Tính', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh, Vĩnh Long', '0346707831', '', 10.0176550000000000, 105.8350560000000000, '', '', '', 34),
(00096, 'Trương Thanh Việt', '', 'Mỹ Thới 1, Mỹ Hòa, Bình Minh, Vĩnh Long', '0776134436', '', 10.0201160000000000, 105.8374490000000000, '', '', '', 35),
(00097, 'Trương Thanh Tùng', '', 'Mỹ Thới 1, Mỹ Hòa, Bình Minh, Vĩnh Long', '0939525309', '', 10.0223350000000000, 105.8381680000000000, '', '', '', 36),
(00098, 'Trịnh Đình Thanh', '', 'Thành Hậu, Thành Đông, Bình Tân, Vĩnh Long', '01288781954', '', 10.1146860000000000, 105.7685000000000000, '', '', '', 37),
(00099, 'Trịnh Văn Đen', '', 'Hưng Hòa, Tân Hưng, Bình Tân, Vĩnh Long', '0919717797', '', 10.1747180000000000, 105.7296030000000000, '', '', '', 38),
(00100, 'Trịnh Minh Thuận', '', 'Hưng Hòa, Tân Hưng, Bình Tân, Vĩnh Long', '0949040403', '', 10.1690940000000000, 105.7350720000000000, '', '', '', 39),
(00101, 'Trần Văn Vui', '', 'Thành An, Thành Đông, Bình Tân, Vĩnh Long', '01287987939', '', 10.1182310000000000, 105.7733570000000000, '', '', '', 40),
(00102, 'Trần Văn Vũ', '', 'Thành An, Thành Đông, Bình Tân, Vĩnh Long', '01208877231', '', 10.1193820000000000, 105.7727240000000000, '', '', '', 41),
(00103, 'Trần Văn Tư', '', '283/16, Hòa Lợi, Hòa Ninh, Long Hồ, Vĩnh Long', '0976075534', '', 10.2514390000000000, 106.0698320000000000, '', '', '', 42),
(00104, 'Trần  Văn Thơm', '', '208/11 Hòa Lợi, Hòa Ninh, Long Hồ, Vĩnh Long', '02703859251', '', 10.2514710000000000, 106.0699070000000000, '', '', '', 43),
(00105, 'Trần Văn Sáu', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh, Vĩnh Long', '0353457870', '', 10.0107110000000000, 105.8347630000000000, '', '', '', 44),
(00107, 'Cao Thanh Quới', '', 'Bình Hòa Phước, Long Hồ, Vĩnh Long', '0902799718', '', 10.2809299213439140, 106.0276385396719000, '', '', '', 46),
(00109, 'Trần Văn Phước', '', 'Thành Hậu, Thành Đông, Bình Tân, Vĩnh Long', '01203822367', '', 10.1026020000000000, 105.7558180000000000, '', '', '', 49),
(00110, 'Nguyễn Ngọc Đầy', '', 'ấp Mỹ Thới 1, Mỹ Hòa, Bình Minh ', '0967288959', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 50),
(00111, 'Nguyễn Ngọc Nhân', '', 'Vĩnh Long', '0902937051', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 51),
(00112, 'Nguyễn Ngọc Hùng', '', 'Mỹ Lợi, Mỹ Hòa, Bình Minh, Vĩnh Long', '0939392049', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 52),
(00113, 'Nguyễn Minh Thế', '', 'Mỹ Phước 1, Mỹ Hòa, Bình Minh', '0348270671', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 53),
(00115, 'Nguyễn Minh Kha', '', 'Mỹ Phước, Mỹ Hòa, Bình Minh', '0398657359', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 55),
(00116, 'Nguyễn Minh Kha', '', 'Hòa Lợi, Hòa Ninh, Long Hồ, Vĩnh Long', '0776565809', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 56),
(00117, 'Huỳnh Văn Hữu', '', 'Mỹ Thới 1, Mỹ Hòa, Bình Minh', '0964510132', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 57),
(00118, 'Huỳnh Văn Hoàng', '', 'Vĩnh Long', '0857131318', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 58),
(00119, 'Huỳnh Văn Dảnh', '', 'Bình Hòa Phước, Long Hồ, Vĩnh Long', '0984180646', '', 10.2848355015995580, 106.0223985090851800, '', '', '', 59),
(00120, 'Huỳnh Trung Trực', '', 'Rạch Sâu, Quới Thiện, Vũng Liêm', '01667240248', '', 10.1687950000000000, 106.1894400000000000, '', '', '', 60),
(00121, 'Huỳnh Thị Tuyết', '', 'Mỹ Thới 1, Mỹ Hòa, Bình Minh', '0368515882', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 61),
(00122, 'Huỳnh Thanh Vân', '', 'Vĩnh Long', '0765331479', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 62),
(00123, 'Huỳnh Phi Công', '', 'Mỹ Hưng 2, Mỹ Hòa, Bình Minh', '0767528446', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 63),
(00124, 'Huỳnh Ngọc Thạch', '', 'Mỹ Thới 2, Mỹ Hòa, Bình Minh', '0382406566', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 64),
(00125, 'Huỳnh Ngọc Phượng', '', 'Mỹ Hưng 2, Mỹ Hòa, Bình Minh', '0932935852', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 65),
(00126, 'Huỳnh Ngọc Có', '', 'Thành An, Thành Đông, Bình Tân', '0939856336', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 66),
(00127, 'Huỳnh Hữu Chậm', '', 'Hưng Hòa, Tân Hưng, Bình Tân', '01268219713', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 67),
(00128, 'Nguyễn Minh Hiếu', '', 'Thành Hậu, Thành Đông, Bình Tân', '0933743141', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 68),
(00129, 'Nguyễn Hữu Đức', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh', '0766818876', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 69),
(00130, 'Nguyễn Hữu Út', '', 'Thành Hậu, Thành Đông, Bình Tân', '01263511122', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 70),
(00131, 'Nguyễn Hữu Tuấn', '', 'Mỹ Thới 1, Mỹ Hòa, Bình Minh', '0854504946', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 71),
(00132, 'Nguyễn Hữu Lực', '', 'Mỹ An, Mỹ Hòa, Bình Minh', '0778198768', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 72),
(00133, 'Nguyễn Hữu Hoảnh', '', 'Thành Hậu, Thành Đông, Bình Tân', '01283698556', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 73),
(00134, 'Nguyễn Hùng Cường', '', 'Phú Thành, Tân Phú, Tam Bình', '0378895055', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 74),
(00135, 'Nguyễn Hùng Anh', '', '214/12, Hòa Lợi, Hòa Ninh, Long Hồ, Vĩnh Long', '0702595898', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 75),
(00136, 'Nguyễn Hồng Vinh', '', 'Hưng Nghĩa, Tân Hưng, Bình Tân', '0949443062', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 76),
(00137, 'Nguyễn Hồng Thạnh', '', 'Vĩnh Long', '0939497946', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 77),
(00138, 'Huỳnh Văn Rành', '', 'Mỹ Phước 1, Mỹ Hòa, Bình Minh', '0335477702', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 78),
(00139, 'Huỳnh Văn Lợi', '', 'Tổ 17, Hòa Lợi, Hòa Ninh, Long Hồ', '0363012179', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 79),
(00140, 'Nguyễn Hoài Thương', '', 'Hưng Lợi, Tân Hưng, Bình Tân', '0964576334', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 80),
(00141, 'Nguyễn Công Tâm', '', 'Vĩnh Long', '0989742449', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 81),
(00142, 'Nguyễn Cao Miên', '', 'HTX Rau Củ Quả Tân Bình', '0939217279', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 82),
(00143, 'Ngô Văn Tua', '', 'Thành An, Thành Đông, Bình Tân', '012223699243', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 83),
(00144, 'Huỳnh Văn Suôl', '', 'Vĩnh Long', '0388902564', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 84),
(00145, 'Huỳnh Văn Sáu', '', 'Mỹ An, Mỹ Hòa, Bình Minh', '0939749441', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 85),
(00146, 'Ngô Văn Tám', '', 'Mỹ Thới 1, Mỹ Hòa, Bình Minh', '0702158501', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 86),
(00147, 'Ngô Văn Phước', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh', '0989990344', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 87),
(00148, 'Ngô Ngọc Kết', '', 'Thành An, Thành Đông, Bình Tân', '02703759193', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 88),
(00149, 'Mai Thanh Long', '', 'Bình Hòa 1, Bình Hòa Phước, Long Hồ, Vĩnh Long', '01695004646', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 89),
(00150, 'Mai Thanh Liêm', '', 'Hưng Hòa, Tân Hưng, Bình Tân', '0972892076', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 90),
(00151, 'Mạch Thanh Sang', '', 'Hưng Lợi, Tân Hưng, Bình Tân', '01665744145', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 91),
(00152, 'Huỳnh Văn Tửu', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh', '0983585566', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 92),
(00153, 'Huỳnh Văn Tư', '', 'Mỹ Thới 1, Mỹ Hòa, Bình Minh', '0704436542', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 93),
(00154, 'Khúc Kim Vùng', '', 'Hưng Thịnh, Tân Hưng, Bình Tân', '01665838320', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 94),
(00155, 'Lê Chí Đức', '', 'Mỹ Hưng 2, Mỹ Hòa, Bình Minh', '0796704239', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 95),
(00156, 'Lê Cẩm Nguyệt', '', 'Thành Hậu, Thành Đông, Bình Tân', '01665258709', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 96),
(00157, 'Lê Huỳnh Quốc Duy', '', 'Mỹ Thới 2, Mỹ Hòa, Bình Minh', '0795290095', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 97),
(00158, 'Lê Hoàng Phúc', '', 'Mỹ Hưng 2, Mỹ Hòa, Bình Minh', '0942815071', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 98),
(00159, 'Lê Quốc Tài', '', 'Mỹ Thới 1, Mỹ Hòa, Bình Minh', '0972658649', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 99),
(00160, 'Lê Phú Hiệp', '', 'Thành Hậu, Thành Đông, Bình Tân', '01228711322', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 100),
(00161, 'Lê Minh Quân', '', 'Hưng Lợi, Tân Hưng, Bình Tân', '0939037956', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 101),
(00162, 'Lê Tấn Kiệt', '', 'Vĩnh Long', '01694377106', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 102),
(00163, 'Lê Tấn Biết', '', 'Vĩnh Long', '02702217650', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 103),
(00164, 'Lê Thành Nguyên', '', 'Hưng Hòa, Tân Hưng, Bình Tân', '0965563420', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 104),
(00165, 'Lê Tấn Kiệt', '', 'Hưng Lợi, Tân Hưng, Bình Tân', '01208757579', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 105),
(00166, 'Lê Thanh Quang', '', 'ấp Bình Hòa 1, Bình Hòa Phước, Vĩnh Long', '0902856455', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 106),
(00167, 'Lê Thanh Nhã', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh', '0395454840', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 107),
(00168, 'Lê Tích Nhơn', '', 'Mỹ Hưng 2, Mỹ Hòa, Bình Minh', '0918405785', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 108),
(00169, 'Lê Văn Chánh', '', 'Vĩnh Long', '0327291848', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 109),
(00170, 'Lê Văn Be', '', 'Mỹ Thới 1, Mỹ Hòa, Bình Minh', '0362808964', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 110),
(00171, 'Lê Văn Giữ', '0799525372', 'Mỹ An, Mỹ Hòa, Bình Minh', '', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 111),
(00172, 'Huỳnh Văn Cò', '', 'Hưng Hòa, Tân Hưng, Bình Tân', '01656464322', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 112),
(00173, 'Lê Văn Hiệp', '', 'Hòa Lợi, Hòa Ninh, Long Hồ Vĩnh Long', '0388271790', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 113),
(00174, 'Lê Văn Hết', '', 'Vĩnh Long', '0982068574', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 114),
(00175, 'Lê Văn Hoằng', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh', '0355912564', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 115),
(00176, 'Lê Văn Hoàng', '', 'Mỹ Thới 1, Mỹ Hòa, Bình?Minh', '0334958008', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 116),
(00177, 'Lê Văn Hương', '', 'Mỹ Hưng 2, Mỹ Hòa, Bình Minh', '0333693260', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 117),
(00178, 'Lê Văn Hòn', '', 'Vĩnh Long', '0355243050', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 118),
(00179, 'Lê Văn Kha', '', 'Hưng Lợi, Tân Hưng, Bình Tân', '01234500223', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 119),
(00180, 'Lê Văn Hữu', '', 'Hưng Lợi, Tân Hưng, Bình Tân', '01663319008', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 120),
(00181, 'Lê Văn Minh', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh', '0939896935', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 121),
(00182, 'Lê Văn Lộc', '', 'Thành Hậu, Thành Đông, Bình Tân', '01253848889', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 122),
(00183, 'Lê Văn Năm', '', 'Mỹ Thới 1, Mỹ Hòa, Bình Minh', '0949489924', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 123),
(00184, 'Lê Văn Mười', '', 'Thành An, Thành Đông, Bình Tân', '0946727657', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 124),
(00185, 'Lê Văn Nhựt', '', 'Vĩnh Long', '0907990619', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 125),
(00186, 'Lê Văn Nhẹ', '', 'Mỹ Thới 1, Mỹ Hòa, Bình Minh', '0919494072', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 126),
(00187, 'Huỳnh Văn Thàng', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh', '0985449283', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 127),
(00188, 'Huỳnh Văn Thái', '', 'Mỹ Hưng 2, Mỹ Hòa, Bình Minh', '0939793812', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 128),
(00189, 'Lê Văn Sĩ', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh', '0388169666', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 129),
(00190, 'Lê Văn Rùm', '', 'Mỹ Hưng 2, Mỹ Hòa, Bình Minh', '0939808375', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 130),
(00191, 'Lê Văn Tám', '', 'ấp Quang Trạch, xã Trung Chánh', '0335025352', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 131),
(00192, 'Lê Văn Sơn', '', 'Thành Hậu, Thành Đông, Bình Tân', '0942679710', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 132),
(00193, 'Lê Văn Tính', '', 'Quang Trạch, Trung Chánh, Vũng Liêm', '0988879386', '', 10.1263420000000000, 106.1394850000000000, '', '', '', 133),
(00194, 'Lê Văn Thổ', '', 'Hưng Hòa, Tân Hưng, Bình Tân', '0984622500', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 134),
(00195, 'Lê Việt Ánh', '', 'Thành Hậu, Thành Đông, Bình Tân', '0943985227', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 135),
(00196, 'Lê Văn Toàn', '', '234/13, Hòa Lợi, Hòa Ninh, Long Hồ, Vĩnh Long', '0355278205', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 136),
(00197, 'Lê Đức Hậu', '', 'Mỹ Thới 1, Mỹ Hòa, Bình Minh', '0939133165', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 137),
(00198, 'Lê Việt Hải', '', 'Thành Hậu, Thành Đông, Bình Tân', '01206574246', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 138),
(00199, 'Lương Văn Sáu', '', 'ấp Hưng Hòa, Tân Hưng, Bình Tân', '01689705361', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 139),
(00200, 'Lê Thị Kim Dung', '', 'Vĩnh Long', '0917917346', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 140),
(00201, 'Lê Thị Cẩm Thi', '', 'Vĩnh Long', '01687179392', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 141),
(00202, 'Hồ Văn E', '', 'Tổ 13, Hòa Lợi, Hòa Ninh, Long Hò, Vĩnh Long', '0704325719', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 142),
(00203, 'Hồ Ngọc Văn', '', 'Thành Hậu, Thành Đông, Bình Tân', '0967521576', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 143),
(00204, 'Hồ Minh Điện', '', 'Thành Hậu, Thành Đông, Bình Tân', '01667088253', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 144),
(00205, 'Hồ Chí Cường', '', 'Hưng Thuận, Tân Hưng, Bình Tân', '0982193243', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 145),
(00206, 'Hà Văn Năm', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh', '0988996584', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 146),
(00207, 'Dương Văn Út Chót', '', '42/3 Hòa Lợi, Hòa ninh, Long Hồ, Vĩnh Long', '0938547284', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 147),
(00208, 'Dương Tấn Lộc', '', '106/6 Hòa Lợi, Hòa Ninh, Long Hồ, Vĩnh Long', '0783901765', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 148),
(00209, 'Dương Nguyễn Minh Kha', '', '140/9 Phú An 2', '0907073970', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 149),
(00210, 'Dương Nguyễn Anh Thuấn', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh', '0366021692', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 150),
(00211, 'Dương Khắc Hoàng', '', '210/11 Hòa Lợi, Hòa Ninh, Long Hồ', '0384777045', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 151),
(00212, 'Dương Huỳnh Long', '', 'Mỹ An, Mỹ Hòa, Bình Minh', '0901779635', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 152),
(00213, 'Dương Cánh Dân', '', '211/11 Hòa Lợi, Hòa Ninh, Long Hồ, Vĩnh Long', '0388690161', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 153),
(00214, 'Chung Văn Tuyền', '', 'Hưng Hòa, Tân Hưng, Bình Tân', '01222102167', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 154),
(00215, 'Chú Sáu Hồng', '', 'Phú Quới, Long Hồ', '0342467633', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 155),
(00216, 'Chiêm Văn Giàu', '', 'Thành Hậu, Thành Đông, Bình Tân', '01204956362', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 156),
(00217, 'Cao Văn Lên', '', 'Hưng Hòa, Tân Hưng, Bình Tân', '01654471433', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 157),
(00218, 'Cao Văn Bảy', '', 'Mỹ Hưng 2, Mỹ Hòa, Bình Minh', '0939512235', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 158),
(00219, 'Cao Thanh Quới', '', 'Vĩnh Long', '0378826619', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 159),
(00220, 'Cao Hữu Minh', '', 'HTX Rau Củ Quả Tân Bình', '0939802781', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 160),
(00221, 'Bùi Văn Kiếm', '', 'Hưng Lợi, Tân Hưng, Bình Tân', '0985870067', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 161),
(00222, 'Bùi Văn Hải', '', 'Hưng Lợi, Tân Hưng, Bình Tân', '01683529179', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 162),
(00223, 'Bùi Văn Giang', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh', '0772375480', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 163),
(00224, 'Bùi Thanh Dự', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh', '0567438327', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 164),
(00225, 'Bùi Công Tùng', '', 'Thành Hậu, Thành Đông, Bình Tân', '0977358745', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 165),
(00226, 'Bùi Công Danh', '', 'Thành Hậu, Thành Đông, Bình Tân', '0977358693', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 166),
(00227, 'Biện Như Thùy', '', 'Hưng Hòa, Tân Hưng, Bình Tân', '0916734908', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 167),
(00228, 'Bành Ngọc Nghĩa', '', 'Phường 1, TPVL', '0916804648', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 168),
(00229, 'Bạch Văn Thắng', '', 'Vĩnh Long', '01203142164', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 169),
(00230, 'Nguyễn Văn Trà', '', 'Vĩnh Long', '01689793799', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 170),
(00231, 'Nguyễn Văn Toàn', '', 'Vĩnh Long', '01698234404', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 171),
(00232, 'Nguyễn Văn Tú', '', 'HTX Nông Nghiệp Kinh Mới', '0939502734', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 172),
(00233, 'Nguyễn Văn Trạng', '', 'Mỹ An, Mỹ Hòa, Bình Minh', '0363466917', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 173),
(00234, 'Đặng Hoàng Minh', '', 'HTX Rau Củ Quả Tân Bình', '01672299406', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 174),
(00235, 'Võ Văn Vũ', '', 'An Lạc Tây, Trung Hiếu, Vũng Liêm', '0383120029', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 175),
(00236, 'Võ Thanh Trang', '', 'ấp Bình Hòa 2, Bình Hòa Phước, Long Hồ', '0795887590', '', 10.2818638473272260, 106.0264134407043500, '', '', '', 176),
(00237, 'Võ Ngọc Thạch', '', 'Hòa Lợi, Hòa Ninh, Long Hồ, Vĩnh Long', '0765099983', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 177),
(00238, 'Trần Văn Pháp', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh', '0358829998', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 178),
(00239, 'Trần Văn Nhóc', '', 'Mỹ Hưng 2, Mỹ Hòa, Bình Minh', '0389905416', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 179),
(00240, 'Trần Văn Lành', '', 'Huwg Hòa, Tân Hưng, Bình Tân', '01225435074', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 180),
(00241, 'Trần Văn Lần', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh', '0778881433', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 181),
(00242, 'Nguyễn Văn Tùng', '', 'Vĩnh Long', '01664222458', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 182),
(00244, 'Nguyễn Văn Đời', '', 'Thành Hậu, Thành Đông, Bình Tân', '01663492287', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 184),
(00245, 'Nguyễn Văn Đang', '', 'Vĩnh Long', '01699734243', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 185),
(00246, 'Nguyễn Văn Được', '', 'Hưng Hòa, Tân Hưng, Bình Tân', '01683074789', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 186),
(00247, 'Nguyễn Văn Đức', '', 'Tổ 10, Hòa Lợi, Hòa Ninh, Long Hồ, Vĩnh Long', '0939901195', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 187),
(00248, 'Phạm Cao Sơn', '', 'Vĩnh Long', '0328545554', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 188),
(00249, 'Phạm Thanh Chánh', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh', '0366914337', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 189),
(00250, 'Phạm Hoàng Giang', '', 'Hưng Hòa, Tân Hưng, Bình Tân', '01678283811', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 190),
(00251, 'Phạm Văn Hùng', '', 'Hưng Hòa, Tân Hưng, Bình Tân', '01649949594', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 191),
(00252, 'Phạm Văn Bé Ba', '', 'Hưng Hòa, Tân Hưng, Bình Tân', '01289514517', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 192),
(00253, 'Phạm Văn Quốc', '', 'Phú Thành, Tân Phú, Tam Bình', '0786405943', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 193),
(00254, 'Phạm Văn Phước', '', 'Hưng Lợi, Tân Hưng, Bình Tân', '0988089695', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 194),
(00255, 'Phạm Văn Út', '', 'Hòa Lợi, Hòa Ninh, Long Hồ, Vĩnh Long', '0354488930', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 195),
(00256, 'Phạm Văn Tâm', '', 'Thành Hậu Thành Đông, Bình Tân', '01283968848', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 196),
(00257, 'Phan Thanh Long', '', 'Vĩnh Long', '0983391279', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 197),
(00258, 'Phan Bùi Thị Hữu Thúy', '', 'Khóm 3, Phường 3, đường Mậu Thân, TPVL', '0919018590', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 198),
(00259, 'Phan Thành Tâm', '', 'Vĩnh Long', '0395851433', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 199),
(00260, 'Phan Thanh Nhã', '', 'Hưng Hòa, Tân Hưng, Bình Tân', '01202955564', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 200),
(00261, 'Phan Văn Mến', '', 'HTX Rau Củ Quả Tân Bình', '0939715879', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 201),
(00262, 'Phan Toàn Định', '', 'Hưng Lợi, Tân Hưng, Bình Tân', '0933661480', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 202),
(00263, 'Trần Ngọc Hấn', '', 'Hưng Lợi, Tân Hưng, Bình Tân', '01682428870', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 203),
(00264, 'Tô Huỳnh Như', '', 'An Điền 1, Trung Hiếu, Vũng Liêm', '0988255938', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 204),
(00265, 'Trần Hoàng Vui', '', 'ấp Phú An 2, Bình Hòa Phước, Long Hồ, Vĩnh Long', '0909571260', '', 10.2909890000000000, 106.0187580000000000, '', '', '', 205),
(00266, 'Trần Hoàng Em', '', 'Hòa Lợi, Hòa Ninh, Long Hồ, Vĩnh Long', '0984601140', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 206),
(00267, 'Trần Minh Luân', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh', '0385940920', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 207),
(00268, 'Trần Minh Chánh', '', 'Quang Trạch, Trung Chánh', '0333524653', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 208),
(00269, 'Trần Ngọc Hên', '', 'Mỹ Thới 1, Mỹ Hòa, Bình Minh', '0395190618', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 209),
(00270, 'Trần Minh Nguyên', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh', '0932977783', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 210),
(00271, 'Trần Quang Thủ', '', 'Hưng Thịnh, Tân Hưng, Bình Tân', '01652706054', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 211),
(00272, 'Trần Như Phước', '', 'Vĩnh Long', '0939233536', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 212),
(00273, 'Trần Thanh Tuấn', '', 'Mỹ Hưng 2, Mỹ Hòa, Bình Minh', '0983958970', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 213),
(00274, 'Trần Tấn Khanh', '', 'Vĩnh Long', '0767040549', '', 10.2909770000000000, 106.0187620000000000, '', '', '', 214),
(00275, 'Trần Thanh Vũ', '', 'Mỹ An, Mỹ Hòa, Bình Minh', '0939419975', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 215),
(00276, 'Trần Thanh Vĩnh', '', 'Mỹ Phước 2, Mỹ Hòa, Bình Minh', '0783936930', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 216),
(00277, 'Trần Thị Hồng Thơi', '', 'Vĩnh Long', '0989222709', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 217),
(00278, 'Trần Thị Hằng', '', '114/6 Hòa Lợi, Hòa Ninh, Long Hồ, Vĩnh Long', '0385668017', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 218),
(00279, 'Trần Thị Phi Thuyền', '', 'Vũng Liêm', '0912561727', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 219),
(00280, 'Trần Thị Kim Ánh', '', 'Hòa Lợi, Hòa Ninh, Vĩnh Long', '0904457586', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 220),
(00281, 'Trần Văn Bé Ba', '', 'Mỹ An, Mỹ Hòa, Bình Minh', '0366180166', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 221),
(00282, 'Trần Trọng Nghĩa', '', 'Thành Hậu, Thành Đông, Bình Tân', '01222116790', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 222),
(00283, 'Trần Văn Cà Tha', '', 'Bình Hòa 1, Bình Hòa Phước, Long Hồ, Vĩnh Long', '0977278747', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 223),
(00284, 'Trần Văn Bờ Em', '', 'Vĩnh Long', '0385642559', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 224),
(00285, 'Trần Văn Dinh', '', '32, ấp Thành Lợi, xã Thành Đông, Bình Tân', '0913673943', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 225),
(00286, 'Trần Văn Căi', '', 'HTX Rau Củ Quả Tân Bình', '01266889684', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 226),
(00287, 'Trần Văn Dũng', '', 'ấp Mỹ Phước 1, Mỹ Hòa, Bình Minh', '0822521828', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 227),
(00288, 'Trần Văn Dũng', '', 'Tổ 4, Hòa Lợi, Hòa Ninh, Long Hồ, Vĩnh Long', '0979459941', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 228),
(00289, 'Trần Văn Hoài', '', 'Thành Hậu, Thành Đông, Bình Tân', '01214324765', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 229),
(00290, 'Trần Văn Hiền', '', 'Thành Hậu, Thành Đông, Bình Tân', '01675280203', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 230),
(00291, 'Trần Văn Khởi', '', 'Bình Hòa 1, Bình Hòa Phước, Long Hồ, Vĩnh Long', '0984265480', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 231),
(00292, 'Trần Văn Hoàng', '', 'ấp Đông Hòa 1, Đông Thành, Bình Minh', '0922341021', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 232),
(00293, 'Nguyễn Văn Đội', '', 'Bình Hòa Thới 2, Bình Phước, Long Hồ, Vĩnh Long', '', '', 10.2830415600144460, 106.0224642232060400, '', '', '', 239),
(00295, 'Ngô Minh Thảo', '', 'Bình Hòa Phước, Long Hồ, Vĩnh Long', '0762932552', '', 10.2829429226217900, 106.0223995149135700, '', '', '', 242),
(00296, 'Trần Tuấn Khanh', '', 'Bình Hòa Phước, Long Hồ, Vĩnh Long', '0767040541', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 243),
(00297, 'Lê Anh Huy', '', 'Bình Hòa Phước, Long Hồ, Vĩnh Long', '0776890967', '', 10.2813180000000000, 106.0107450000000000, '', '', '', 244),
(00298, 'Dương Thành Công', '', 'ấp Phú An 2, Bình Hòa Phước, Long Hồ, Vĩnh Long', '0907972554', '', 10.2915930000000000, 106.0179160000000000, '', '', '', 245),
(00299, 'Nguyễn Văn Cầu', '', 'Phú An 2, Bình Hòa Phước, Long Hồ, Vĩnh Long', '0377772030', '', 10.2814820000000000, 106.0092040000000000, '', '', '', 246),
(00300, 'Nguyễn Văn Tấn', '', 'Bình Hòa 2, Bình Hòa Phước, Long Hồ, Vĩnh Long', '', '', 10.2859713074515930, 106.0282970219850500, '', '', '', 247),
(00301, 'Võ Văn Ba', '', 'Bình Hòa 2, Bình Hòa Phước, Long Hồ, Vĩnh Long', '', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 248),
(00302, 'Nguyễn Văn Tuấn', '', 'Bình Hòa Phước, Long Hồ, Vĩnh Long', '0913754433', '', 10.2820344015096710, 106.0227602720260600, '', '', '', 249),
(00303, 'nha', '', '', '', '', 0.0000000000000000, 0.0000000000000000, '', '', '', 254),
(00304, 'Nguyễn Văn Liểm', '', 'Quang Trạch, Trung Chánh, Vũng Liêm', '0367651586', '', 10.1247350000000000, 106.1394930000000000, '', '', '', 265),
(00305, 'Lê Văn Diễn', '', 'Rạch sâu, Quới Thiện, Vũng Liêm', '01637126097', '', 10.1666475000000000, 106.1918940000000000, '', '', '', 266),
(00306, 'Lê Minh Khang', '', 'Rạch sâu, Quới Thiện, Vũng Liêm', '0165898726', '', 10.1675310000000000, 106.1870710000000000, '', '', '', 267),
(00307, 'Lê Thanh Vũ', '', 'Rạch Sâu, Quới An, Vũng Liêm', '01699313383', '', 10.1686320000000000, 106.1941830000000000, '', '', '', 268),
(00308, 'Lê Minh Pha', '', 'Rạch Sâu, Quới Thiện, Vũng Liêm', '01659429602', '', 10.1683360000000000, 106.1920070000000000, '', '', '', 269),
(00309, 'Nguyễn Văn Kiệt', '', 'Trường Định, Quới An, Vũng Liêm', '0978398958', '', 10.1520320000000000, 106.1649140000000000, '', '', '', 270);

-- --------------------------------------------------------

--
-- Table structure for table `nhapp`
--

CREATE TABLE IF NOT EXISTS `nhapp` (
  `manpp` int(5) unsigned zerofill NOT NULL,
  `tennpp` varchar(800) NOT NULL DEFAULT '',
  `mst` varchar(100) DEFAULT '',
  `diachi` varchar(800) NOT NULL DEFAULT '',
  `sdt` varchar(20) NOT NULL DEFAULT '',
  `email` varchar(200) DEFAULT '',
  `lat` decimal(20,16) NOT NULL DEFAULT 0.0000000000000000,
  `lng` decimal(20,16) NOT NULL DEFAULT 0.0000000000000000,
  `website` varchar(200) DEFAULT '',
  `sofax` varchar(20) DEFAULT '',
  `facebook` varchar(500) DEFAULT '',
  `diadiem` longtext DEFAULT '[]',
  `user` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`manpp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `nhapp`
--

INSERT INTO `nhapp` (`manpp`, `tennpp`, `mst`, `diachi`, `sdt`, `email`, `lat`, `lng`, `website`, `sofax`, `facebook`, `diadiem`, `user`) VALUES
(00262, 'CÔNG TY TNHH TM DV XNK VINA T&T', '', '79 Trần Huy Liệu Phường 12, Quận Phú Nhuận, TP. HCM', '028 3844 8277', 'tommy.vinatt@gmail.com', 0.0000000000000000, 0.0000000000000000, 'http://vinatt.com', '', '', '[]', 262);

--
-- Triggers `nhapp`
--
DROP TRIGGER IF EXISTS `insertIdNpp`;
DELIMITER //
CREATE TRIGGER `insertIdNpp` BEFORE INSERT ON `nhapp`
 FOR EACH ROW BEGIN
  SET NEW.manpp =  LPAD(LAST_INSERT_ID(), 3, '0');

  END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `nhasoche`
--

CREATE TABLE IF NOT EXISTS `nhasoche` (
  `mansc` int(5) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `tennsc` varchar(800) NOT NULL DEFAULT '',
  `mst` varchar(100) DEFAULT '',
  `diachi` varchar(800) NOT NULL DEFAULT '',
  `sdt` varchar(20) NOT NULL DEFAULT '',
  `email` varchar(200) DEFAULT '',
  `lat` decimal(20,16) NOT NULL DEFAULT 0.0000000000000000,
  `lng` decimal(20,16) NOT NULL DEFAULT 0.0000000000000000,
  `website` varchar(200) DEFAULT '',
  `sofax` varchar(20) DEFAULT '',
  `facebook` varchar(500) DEFAULT '',
  `diadiem` longtext DEFAULT '[]',
  `thongtincssc` text DEFAULT '[]',
  `user` bigint(20) NOT NULL DEFAULT 0,
  `tccs` text NOT NULL DEFAULT '',
  PRIMARY KEY (`mansc`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4383 ;

--
-- Dumping data for table `nhasoche`
--

INSERT INTO `nhasoche` (`mansc`, `tennsc`, `mst`, `diachi`, `sdt`, `email`, `lat`, `lng`, `website`, `sofax`, `facebook`, `diadiem`, `thongtincssc`, `user`, `tccs`) VALUES
(04382, 'CÔNG TY TNHH TM DV XNK VINA T&T', '', '79 Trần Huy Liệu Phường 12, Quận Phú Nhuận, TP. HCM', '+84 949 80 9000', 'tommy.vinatt@gmail.com', 0.0000000000000000, 0.0000000000000000, 'http://vinatt.com', '', '', '[]', '[]', 263, '');

-- --------------------------------------------------------

--
-- Table structure for table `nhavc`
--

CREATE TABLE IF NOT EXISTS `nhavc` (
  `manvc` int(5) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `tennvc` varchar(800) NOT NULL DEFAULT '',
  `mst` varchar(100) DEFAULT '',
  `diachi` varchar(800) NOT NULL DEFAULT '',
  `sdt` varchar(30) NOT NULL DEFAULT '',
  `email` varchar(200) NOT NULL DEFAULT '',
  `lat` decimal(20,16) NOT NULL DEFAULT 0.0000000000000000,
  `lng` decimal(20,16) NOT NULL DEFAULT 0.0000000000000000,
  `website` varchar(200) DEFAULT '',
  `sofax` varchar(20) DEFAULT '',
  `facebook` varchar(500) DEFAULT '',
  `user` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`manvc`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=84 ;

--
-- Dumping data for table `nhavc`
--

INSERT INTO `nhavc` (`manvc`, `tennvc`, `mst`, `diachi`, `sdt`, `email`, `lat`, `lng`, `website`, `sofax`, `facebook`, `user`) VALUES
(00081, 'CÔNG TY TNHH TM DV XNK VINA T&T', '', '79 Trần Huy Liệu Phường 12, Quận Phú Nhuận, TP. HCM', '+84 949 80 9000', 'tommy.vinatt@gmail.com', 0.0000000000000000, 0.0000000000000000, 'http://vinatt.com', '', '', 260);

-- --------------------------------------------------------

--
-- Table structure for table `partner`
--

CREATE TABLE IF NOT EXISTS `partner` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `logo` text NOT NULL,
  `name` varchar(200) NOT NULL,
  `link` text NOT NULL,
  `visible` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=18 ;

--
-- Dumping data for table `partner`
--

INSERT INTO `partner` (`id`, `logo`, `name`, `link`, `visible`) VALUES
(2, 'image_upload/img_1554487149671', 'Công Ty TNHH Chế Biến Thực Phẩm & Bánh Kẹo Phạm Nguyên 1', 'http://www.phamnguyenfoods.com/', 1),
(3, 'image_upload/img_1554487159123', 'Cty Vận Chuyển Hàng Hóa Quốc Tế 2Hnew', 'http://www.2hnew.com/', 1),
(4, 'image_upload/img_1554487173384', 'YI Bao Produce Group Inc', 'http://www.yibaoproduce.com/', 1),
(5, 'image_upload/img_1554487180836', 'Cà Phê Trung Nguyên', 'https://trungnguyenlegend.com/', 1),
(6, 'image_upload/img_1554487188380', 'CÔNG TY CỔ PHẦN NHÔM NHỰA KIM HẰNG', 'http://kimhangonline.vn/', 1),
(7, 'image_upload/img_1554487195738', 'Công Ty TNHH Dịch Vụ Vận Chuyển CMU Logistics', 'cmulogistics.com', 1),
(8, 'image_upload/img_1554487206972', 'Tổng Công Ty Cà Phê Việt Nam', 'https://www.vinacafe.com.vn/', 1),
(9, 'image_upload/img_1554487226433', 'CÔNG TY CỔ PHẦN THỰC PHẨM XANH', 'http://gfood.com.vn/', 1),
(10, 'image_upload/img_1554487216397', 'Lam''s Seafood Market', 'https://www.lamsseafood.com', 1),
(11, 'image_upload/img_1554487232710', 'Công Ty TNHH Phoenix Inox', 'll', 1);

-- --------------------------------------------------------

--
-- Table structure for table `pushnotification`
--

CREATE TABLE IF NOT EXISTS `pushnotification` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `content` longtext NOT NULL,
  `key` varchar(50) NOT NULL,
  `receiver` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=280 ;

--
-- Dumping data for table `pushnotification`
--

INSERT INTO `pushnotification` (`id`, `content`, `key`, `receiver`) VALUES
(17, '{"idddh":98,"iduserkh":0,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0999\\",\\"ten\\":\\"\\"}","ngaydat":"2018-01-11T01:02:36.000Z","ngaygiao":"2018-01-11T01:02:28.000Z","lat":10.16543625389241,"lng":105.922739859769,"infororder":"[{\\"gia\\":0,\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0999","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":null}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(18, '{"idddh":100,"iduserkh":0,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0966618746\\",\\"ten\\":\\"\\"}","ngaydat":"2018-01-11T01:16:26.000Z","ngaygiao":"2018-01-11T01:16:11.000Z","lat":10.16547271517121,"lng":105.9227705375346,"infororder":"[{\\"gia\\":0,\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0966618746","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":null}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(19, '{"idddh":101,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-11T04:00:48.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(20, '{"idddh":102,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-11T04:00:54.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(21, '{"idddh":103,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-11T04:00:55.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(22, '{"idddh":104,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-11T04:00:56.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(23, '{"idddh":105,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-11T04:00:58.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(24, '{"idddh":106,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-11T04:00:59.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(25, '{"idddh":107,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-11T05:22:45.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":10.16569478,"lng":105.92262242,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(26, '{"idddh":108,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-11T05:22:48.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":10.16569478,"lng":105.92262242,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(27, '{"idddh":109,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-11T05:22:59.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":10.16569478,"lng":105.92262242,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(28, '{"idddh":110,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-11T07:46:44.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":10.16569478,"lng":105.92262242,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(29, '{"idddh":111,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-11T07:46:45.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":10.16569478,"lng":105.92262242,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(30, '{"idddh":112,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-11T07:46:56.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":10.16569478,"lng":105.92262242,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(31, '{"idddh":113,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-11T07:47:33.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(32, '{"idddh":114,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-11T07:47:34.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(33, '{"idddh":115,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-11T08:22:40.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(34, '{"idddh":116,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-11T08:22:41.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(35, '{"idddh":117,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-11T08:22:47.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(36, '{"idddh":117,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-11T08:22:47.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(37, '{"idddh":119,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-12T00:53:06.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(38, '{"idddh":120,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-12T00:53:07.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(39, '{"idddh":121,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":"2018-01-12T00:53:08.000Z","ngaygiao":"2018-01-11T04:00:27.000Z","lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":"2018-01-11T04:00:27.000Z"}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(40, '{"idddh":119,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515718386000,"ngaygiao":1515643227000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515643227000}', 'onupdatetimeship', '[{"iduser":4,"issend":1}]'),
(41, '{"idddh":119,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515718386000,"ngaygiao":1515643227000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515643227000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(42, '{"idddh":115,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515658960000,"ngaygiao":1515643227000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515643227000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(43, '{"idddh":113,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515656853000,"ngaygiao":1515643227000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"gia\\":50000,\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515643227000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(44, '{"idddh":122,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"q\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515815891000,"ngaygiao":1515815882000,"lat":0,"lng":0,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":3,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515815882000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(45, '{"idddh":123,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"q\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515815897000,"ngaygiao":1515815882000,"lat":0,"lng":0,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":3,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515815882000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(46, '{"idddh":123,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"q\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515815897000,"ngaygiao":1515815882000,"lat":0,"lng":0,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":3,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515815882000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(47, '{"idddh":122,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"q\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515815891000,"ngaygiao":1515815882000,"lat":0,"lng":0,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":3,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515815882000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(48, '{"idddh":124,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"d\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515816611000,"ngaygiao":1515816598000,"lat":0,"lng":0,"infororder":"[{\\"dvt\\":\\"500g\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00078\\",\\"sl\\":20000,\\"tensp\\":\\"Trà Thảo Dược Hoàng Đế 2 Vị  \\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515816598000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(49, '{"idddh":124,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"d\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515816611000,"ngaygiao":1515816598000,"lat":0,"lng":0,"infororder":"[{\\"dvt\\":\\"500g\\",\\"gia\\":\\"2000\\",\\"idsp\\":\\"00078\\",\\"sl\\":20000,\\"tensp\\":\\"Trà Thảo Dược Hoàng Đế 2 Vị  \\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515816598000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(50, '{"idddh":124,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"d\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515816611000,"ngaygiao":1515816598000,"lat":0,"lng":0,"infororder":"[{\\"dvt\\":\\"500g\\",\\"gia\\":\\"2000\\",\\"idsp\\":\\"00078\\",\\"sl\\":20000,\\"tensp\\":\\"Trà Thảo Dược Hoàng Đế 2 Vị  \\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515816598000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(51, '{"idddh":122,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"q\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515815891000,"ngaygiao":1515815882000,"lat":0,"lng":0,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":3,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515815882000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(52, '{"idddh":121,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515718388000,"ngaygiao":1515643227000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515643227000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(53, '{"idddh":120,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515718387000,"ngaygiao":1515643227000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515643227000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(54, '{"idddh":119,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515718386000,"ngaygiao":1515643227000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515643227000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(55, '{"idddh":118,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515658967000,"ngaygiao":1515643227000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515643227000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(56, '{"idddh":116,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515658961000,"ngaygiao":1515643227000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515643227000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(57, '{"idddh":115,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515658960000,"ngaygiao":1515643227000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515643227000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(58, '{"idddh":114,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515656854000,"ngaygiao":1515643227000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515643227000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(59, '{"idddh":113,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Tp. Cà Mau, Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515656853000,"ngaygiao":1515643227000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"gia\\":\\"50000\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515643227000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(60, '{"idddh":125,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515818227000,"ngaygiao":1515818223000,"lat":10.16554614,"lng":105.92275041,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":95,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515818223000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(61, '{"idddh":126,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515818332000,"ngaygiao":1515818322000,"lat":10.1652344,"lng":105.92301494,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":5,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515818322000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(62, '{"idddh":126,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515818332000,"ngaygiao":1515818322000,"lat":10.1652344,"lng":105.92301494,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":5,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515818322000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(63, '{"idddh":125,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515818227000,"ngaygiao":1515818223000,"lat":10.16554614,"lng":105.92275041,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":95,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515818223000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(64, '{"idddh":127,"iduserkh":62,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1515818441000,"ngaygiao":1515818428000,"lat":10.1652344,"lng":105.92301494,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":5,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515818428000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(65, '{"idddh":128,"iduserkh":62,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1515818468000,"ngaygiao":1515818461000,"lat":10.16529593,"lng":105.92295331,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00012\\",\\"sl\\":5,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Có nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515818461000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(66, '{"idddh":128,"iduserkh":62,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1515818468000,"ngaygiao":1515818461000,"lat":10.16529593,"lng":105.92295331,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00012\\",\\"sl\\":5,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Có nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515818461000}', 'onacceptorder', '[{"iduser":62,"issend":1}]'),
(67, '{"idddh":127,"iduserkh":62,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1515818441000,"ngaygiao":1515818428000,"lat":10.1652344,"lng":105.92301494,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":5,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515818428000}', 'onacceptorder', '[{"iduser":62,"issend":1}]'),
(68, '{"idddh":129,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515837474000,"ngaygiao":1515837462000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515837462000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(69, '{"idddh":130,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515844335000,"ngaygiao":1515844325000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515844325000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(70, '{"idddh":130,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515844335000,"ngaygiao":1515844325000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515844325000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(71, '{"idddh":131,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"24 Trần Phú, Phường 4, Vĩnh Long, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515899454000,"ngaygiao":1515506768000,"lat":10.2427643,"lng":105.9853366,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":38,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Chai\\",\\"gia\\":\\"80000.0\\",\\"idsp\\":\\"00021\\",\\"sl\\":2,\\"tensp\\":\\"Nước mắm Khải Hoàn Phú Quốc N30g/L 1 lít  Chai nhựa\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515506768000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(72, '{"idddh":131,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"24 Trần Phú, Phường 4, Vĩnh Long, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515899454000,"ngaygiao":1515506768000,"lat":10.2427643,"lng":105.9853366,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":38,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Chai\\",\\"gia\\":\\"80000.0\\",\\"idsp\\":\\"00021\\",\\"sl\\":2,\\"tensp\\":\\"Nước mắm Khải Hoàn Phú Quốc N30g/L 1 lít  Chai nhựa\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515506768000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(73, '{"idddh":129,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515837474000,"ngaygiao":1515837462000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515837462000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(74, '{"idddh":132,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515899740000,"ngaygiao":1515899715000,"lat":10.1656044,"lng":105.9231129,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515899715000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(75, '{"idddh":133,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515903695000,"ngaygiao":1515903691000,"lat":10.1656044,"lng":105.9231129,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00016\\",\\"sl\\":12,\\"tensp\\":\\"Bưởi Năm Roi Loại 3 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515903691000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(76, '{"idddh":133,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515903695000,"ngaygiao":1515903691000,"lat":10.1656044,"lng":105.9231129,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"25000\\",\\"idsp\\":\\"00016\\",\\"sl\\":12,\\"tensp\\":\\"Bưởi Năm Roi Loại 3 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":20000,"methodship":1,"datetimegiaokhach":1515903691000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(77, '{"idddh":132,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515899740000,"ngaygiao":1515899715000,"lat":10.1656044,"lng":105.9231129,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"25000\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":25000,"methodship":1,"datetimegiaokhach":1515899715000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(78, '{"idddh":134,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"22 Nguyễn Huệ, Vĩnh Long, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515918926000,"ngaygiao":1515903770000,"lat":10.2416808,"lng":105.9576567,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00017\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Da Xanh Loại 1 Có nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00015\\",\\"sl\\":3,\\"tensp\\":\\"Bưởi Năm Roi Loại 3 Có nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"2\\",\\"sotk\\":\\"55678\\",\\"tennh\\":\\"Sacombank\\",\\"tentk\\":\\"Anh Tuan\\"}","feeship":0,"methodship":2,"datetimegiaokhach":1515903770000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(79, '{"idddh":135,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"22 Nguyễn Chí Thanh, Phường 16, Hồ Chí Minh, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515919120000,"ngaygiao":1515919091000,"lat":10.756277,"lng":106.650449,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2000,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00017\\",\\"sl\\":5000,\\"tensp\\":\\"Bưởi Da Xanh Loại 1 Có nhánh\\"},{\\"dvt\\":\\"Chai\\",\\"gia\\":\\"80000.0\\",\\"idsp\\":\\"00021\\",\\"sl\\":1,\\"tensp\\":\\"Nước mắm Khải Hoàn Phú Quốc N30g/L 1 lít  Chai nhựa\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515919091000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(80, '{"idddh":135,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"22 Nguyễn Chí Thanh, Phường 16, Hồ Chí Minh, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515919120000,"ngaygiao":1515919091000,"lat":10.756277,"lng":106.650449,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2000,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00017\\",\\"sl\\":5000,\\"tensp\\":\\"Bưởi Da Xanh Loại 1 Có nhánh\\"},{\\"dvt\\":\\"Chai\\",\\"gia\\":\\"80000.0\\",\\"idsp\\":\\"00021\\",\\"sl\\":1,\\"tensp\\":\\"Nước mắm Khải Hoàn Phú Quốc N30g/L 1 lít  Chai nhựa\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515919091000}', 'onacceptorder', '[{"iduser":4,"issend":1}]');
INSERT INTO `pushnotification` (`id`, `content`, `key`, `receiver`) VALUES
(81, '{"idddh":134,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"22 Nguyễn Huệ, Vĩnh Long, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515918926000,"ngaygiao":1515903770000,"lat":10.2416808,"lng":105.9576567,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"12000\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"14000\\",\\"idsp\\":\\"00017\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Da Xanh Loại 1 Có nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"9000\\",\\"idsp\\":\\"00015\\",\\"sl\\":3,\\"tensp\\":\\"Bưởi Năm Roi Loại 3 Có nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"2\\",\\"sotk\\":\\"55678\\",\\"tennh\\":\\"Sacombank\\",\\"tentk\\":\\"Anh Tuan\\"}","feeship":32000,"methodship":2,"datetimegiaokhach":1515903770000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(82, '{"idddh":136,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"ca mau\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515931578000,"ngaygiao":1515931564000,"lat":0,"lng":0,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515931564000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(83, '{"idddh":137,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Tt. Vũng Liêm\\",\\"phone\\":\\"0966618746\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515931627000,"ngaygiao":1515931617000,"lat":10.0964137837912,"lng":106.1891873897052,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0966618746","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515931617000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(84, '{"idddh":137,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Tt. Vũng Liêm\\",\\"phone\\":\\"0966618746\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515931627000,"ngaygiao":1515931617000,"lat":10.0964137837912,"lng":106.1891873897052,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"25000\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0966618746","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515931617000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(85, '{"idddh":136,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"ca mau\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515931578000,"ngaygiao":1515931564000,"lat":0,"lng":0,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"25000\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515931564000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(86, '{"idddh":135,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"22 Nguyễn Chí Thanh, Phường 16, Hồ Chí Minh, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515919120000,"ngaygiao":1515919091000,"lat":10.756277,"lng":106.650449,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"15000\\",\\"idsp\\":\\"00001\\",\\"sl\\":2000,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"20000\\",\\"idsp\\":\\"00017\\",\\"sl\\":5000,\\"tensp\\":\\"Bưởi Da Xanh Loại 1 Có nhánh\\"},{\\"dvt\\":\\"Chai\\",\\"gia\\":\\"80000.0\\",\\"idsp\\":\\"00021\\",\\"sl\\":1,\\"tensp\\":\\"Nước mắm Khải Hoàn Phú Quốc N30g/L 1 lít  Chai nhựa\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515919091000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(87, '{"idddh":138,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515976800000,"ngaygiao":1515976793000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515976793000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(88, '{"idddh":139,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Tp. Vĩnh Long, Vĩnh Long, Việt Nam\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515981263000,"ngaygiao":1515981232000,"lat":10.2448442,"lng":105.958865,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00051\\",\\"tensp\\":\\"Tiêu đỏ Phú Quốc 100g  \\",\\"dvt\\":\\"Hộp\\",\\"sl\\":1},{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00014\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 2 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515981232000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(89, '{"idddh":139,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Tp. Vĩnh Long, Vĩnh Long, Việt Nam\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515981263000,"ngaygiao":1515981232000,"lat":10.2448442,"lng":105.958865,"infororder":"[{\\"dvt\\":\\"Hộp\\",\\"gia\\":\\"15000\\",\\"idsp\\":\\"00051\\",\\"sl\\":1,\\"tensp\\":\\"Tiêu đỏ Phú Quốc 100g  \\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"20000\\",\\"idsp\\":\\"00014\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 2 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":20000,"methodship":1,"datetimegiaokhach":1515981232000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(90, '{"idddh":138,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515976800000,"ngaygiao":1515976793000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"30000\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":25000,"methodship":1,"datetimegiaokhach":1515976793000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(91, '{"idddh":140,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515986823000,"ngaygiao":1515986782000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515986782000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(92, '{"idddh":141,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cần Thơ, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515986861000,"ngaygiao":1515986840000,"lat":10.045161799999999,"lng":105.7468535,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515986840000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(93, '{"idddh":141,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cần Thơ, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515986861000,"ngaygiao":1515986840000,"lat":10.045161799999999,"lng":105.7468535,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515986840000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(94, '{"idddh":140,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515986823000,"ngaygiao":1515986782000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515986782000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(95, '{"idddh":140,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515986823000,"ngaygiao":1515986782000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515986782000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(96, '{"idddh":142,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Xã Thanh Đức\\",\\"phone\\":\\"0966618746\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516144603000,"ngaygiao":1516144589000,"lat":10.24121110972983,"lng":105.9910408744394,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0966618746","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516144589000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(97, '{"idddh":142,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Xã Thanh Đức\\",\\"phone\\":\\"0966618746\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516144603000,"ngaygiao":1516144589000,"lat":10.24121110972983,"lng":105.9910408744394,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"0966618746","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516144589000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(98, '{"idddh":142,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Xã Thanh Đức\\",\\"phone\\":\\"0966618746\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516144603000,"ngaygiao":1516144589000,"lat":10.24121110972983,"lng":105.9910408744394,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":2,"phone":"0966618746","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516144589000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(99, '{"idddh":139,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Tp. Vĩnh Long, Vĩnh Long, Việt Nam\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515981263000,"ngaygiao":1515981232000,"lat":10.2448442,"lng":105.958865,"infororder":"[{\\"dvt\\":\\"Hộp\\",\\"gia\\":\\"15000\\",\\"idsp\\":\\"00051\\",\\"sl\\":1,\\"tensp\\":\\"Tiêu đỏ Phú Quốc 100g  \\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"20000\\",\\"idsp\\":\\"00014\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 2 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":20000,"methodship":1,"datetimegiaokhach":1515981232000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(100, '{"idddh":138,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515976800000,"ngaygiao":1515976793000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"30000\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":25000,"methodship":1,"datetimegiaokhach":1515976793000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(101, '{"idddh":143,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516148790000,"ngaygiao":1516148778000,"lat":10.16330094002605,"lng":105.9253811634529,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00030\\",\\"tensp\\":\\"Chà Bông Bò Minh Hòa 100g  \\",\\"dvt\\":\\"100g\\",\\"sl\\":1}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":2,\\"sotk\\":\\"7300001323\\",\\"tentk\\":\\"Vien Thanh nha\\",\\"tennh\\":\\"BIDV Vĩnh Long\\"}","feeship":0,"methodship":2,"datetimegiaokhach":1516148778000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(102, '{"idddh":143,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516148790000,"ngaygiao":1516148778000,"lat":10.16330094002605,"lng":105.9253811634529,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00030\\",\\"tensp\\":\\"Chà Bông Bò Minh Hòa 100g  \\",\\"dvt\\":\\"100g\\",\\"sl\\":1}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":2,\\"sotk\\":\\"7300001323\\",\\"tentk\\":\\"Vien Thanh nha\\",\\"tennh\\":\\"BIDV Vĩnh Long\\"}","feeship":0,"methodship":2,"datetimegiaokhach":1516148778000}', 'onacceptorder', '[{"iduser":62,"issend":1}]'),
(103, '{"idddh":143,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516148790000,"ngaygiao":1516148778000,"lat":10.16330094002605,"lng":105.9253811634529,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00030\\",\\"tensp\\":\\"Chà Bông Bò Minh Hòa 100g  \\",\\"dvt\\":\\"100g\\",\\"sl\\":1}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":2,\\"sotk\\":\\"7300001323\\",\\"tentk\\":\\"Vien Thanh nha\\",\\"tennh\\":\\"BIDV Vĩnh Long\\"}","feeship":0,"methodship":2,"datetimegiaokhach":1516148778000}', 'onshiporder', '[{"iduser":62,"issend":1}]'),
(104, '{"idddh":137,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Tt. Vũng Liêm\\",\\"phone\\":\\"0966618746\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515931627000,"ngaygiao":1515931617000,"lat":10.0964137837912,"lng":106.1891873897052,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"25000\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0966618746","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515931617000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(105, '{"idddh":136,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"ca mau\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515931578000,"ngaygiao":1515931564000,"lat":0,"lng":0,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"25000\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515931564000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(106, '{"idddh":134,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"22 Nguyễn Huệ, Vĩnh Long, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515918926000,"ngaygiao":1515903770000,"lat":10.2416808,"lng":105.9576567,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"12000\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"14000\\",\\"idsp\\":\\"00017\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Da Xanh Loại 1 Có nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"9000\\",\\"idsp\\":\\"00015\\",\\"sl\\":3,\\"tensp\\":\\"Bưởi Năm Roi Loại 3 Có nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"2\\",\\"sotk\\":\\"55678\\",\\"tennh\\":\\"Sacombank\\",\\"tentk\\":\\"Anh Tuan\\"}","feeship":32000,"methodship":2,"datetimegiaokhach":1515903770000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(107, '{"idddh":133,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1515903695000,"ngaygiao":1515903691000,"lat":10.1656044,"lng":105.9231129,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"25000\\",\\"idsp\\":\\"00016\\",\\"sl\\":12,\\"tensp\\":\\"Bưởi Năm Roi Loại 3 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":20000,"methodship":1,"datetimegiaokhach":1515903691000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(108, '{"idddh":144,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516149073000,"ngaygiao":1515981151000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515981151000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(109, '{"idddh":145,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516149208000,"ngaygiao":1516149194000,"lat":10.16325491359811,"lng":105.9266878260634,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00018\\",\\"tensp\\":\\"Bưởi Da Xanh Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516149194000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(110, '{"idddh":145,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516149208000,"ngaygiao":1516149194000,"lat":10.16325491359811,"lng":105.9266878260634,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00018\\",\\"tensp\\":\\"Bưởi Da Xanh Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516149194000}', 'onacceptorder', '[{"iduser":62,"issend":1}]'),
(111, '{"idddh":144,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516149073000,"ngaygiao":1515981151000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1515981151000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(112, '{"idddh":146,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516149650000,"ngaygiao":1516149628000,"lat":10.16556564463401,"lng":105.9228413487415,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516149628000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(113, '{"idddh":147,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516149876000,"ngaygiao":1516149852000,"lat":10.16558047806284,"lng":105.9227803557508,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516149852000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(114, '{"idddh":147,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516149876000,"ngaygiao":1516149852000,"lat":10.16558047806284,"lng":105.9227803557508,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516149852000}', 'onacceptorder', '[{"iduser":62,"issend":1}]'),
(115, '{"idddh":148,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0989501288\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516150020000,"ngaygiao":1516150008000,"lat":10.16385683780991,"lng":105.9269961276665,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":2},{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00014\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 2 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":11},{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00014\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 2 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":4}]","statusdh":0,"phone":"0989501288","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516150008000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(116, '{"idddh":148,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0989501288\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516150020000,"ngaygiao":1516150008000,"lat":10.16385683780991,"lng":105.9269961276665,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":2},{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00014\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 2 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":11},{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00014\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 2 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":4}]","statusdh":1,"phone":"0989501288","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516150008000}', 'onacceptorder', '[{"iduser":62,"issend":1}]'),
(117, '{"idddh":146,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516149650000,"ngaygiao":1516149628000,"lat":10.16556564463401,"lng":105.9228413487415,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":2233,"methodship":1,"datetimegiaokhach":1516149628000}', 'onacceptorder', '[{"iduser":62,"issend":1}]'),
(118, '{"idddh":149,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Tp. Vĩnh Long, Vĩnh Long, Việt Nam\\",\\"phone\\":\\"0937899000\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516150498000,"ngaygiao":1516150457000,"lat":10.2448442,"lng":105.958865,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1},{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0937899000","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516150457000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(119, '{"idddh":150,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0989501288\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516150934000,"ngaygiao":1516150921000,"lat":10.16561420073089,"lng":105.9228986481678,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00012\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Có nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":2}]","statusdh":0,"phone":"0989501288","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516150921000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(120, '{"idddh":150,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0989501288\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516150934000,"ngaygiao":1516150921000,"lat":10.16561420073089,"lng":105.9228986481678,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00012\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Có nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":2}]","statusdh":1,"phone":"0989501288","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516150921000}', 'onacceptorder', '[{"iduser":62,"issend":1}]'),
(121, '{"idddh":149,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Tp. Vĩnh Long, Vĩnh Long, Việt Nam\\",\\"phone\\":\\"0937899000\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516150498000,"ngaygiao":1516150457000,"lat":10.2448442,"lng":105.958865,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1},{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"0937899000","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516150457000}', 'onacceptorder', '[{"iduser":62,"issend":1}]'),
(122, '{"idddh":150,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0989501288\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516150934000,"ngaygiao":1516150921000,"lat":10.16561420073089,"lng":105.9228986481678,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00012\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Có nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":2}]","statusdh":2,"phone":"0989501288","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516150921000}', 'onshiporder', '[{"iduser":62,"issend":1}]'),
(123, '{"idddh":151,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516151463000,"ngaygiao":1516151458000,"lat":10.16549885,"lng":105.92283803,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":8,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516151458000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(124, '{"idddh":152,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516151490000,"ngaygiao":1516151485000,"lat":10.16549885,"lng":105.92283803,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":5,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516151485000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(125, '{"idddh":152,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516151490000,"ngaygiao":1516151485000,"lat":10.16549885,"lng":105.92283803,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":5,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516151485000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(126, '{"idddh":151,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516151463000,"ngaygiao":1516151458000,"lat":10.16549885,"lng":105.92283803,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":8,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516151458000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(127, '{"idddh":152,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516151490000,"ngaygiao":1516151485000,"lat":10.16549885,"lng":105.92283803,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":5,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516151485000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(128, '{"idddh":151,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516151463000,"ngaygiao":1516151458000,"lat":10.16549885,"lng":105.92283803,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":8,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516151458000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(129, '{"idddh":153,"iduserkh":66,"inforkh":"{\\"email\\":\\"nssvl@gamil.com\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"012512512512\\",\\"ten\\":\\"Nông sản sạch Vĩnh Long\\"}","ngaydat":1516153865000,"ngaygiao":1516153863000,"lat":10.16521820862615,"lng":105.9233899282889,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"012512512512","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516153863000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(130, '{"idddh":154,"iduserkh":66,"inforkh":"{\\"email\\":\\"nssvl@gamil.com\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"012512512512\\",\\"ten\\":\\"Nông sản sạch Vĩnh Long\\"}","ngaydat":1516153947000,"ngaygiao":1516153945000,"lat":10.16521820862615,"lng":105.9233899282889,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"012512512512","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516153945000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(131, '{"idddh":155,"iduserkh":68,"inforkh":"{\\"dcgiao\\":\\"to 13 ap an lac 1, xa trung an, vung liem, vinh long\\",\\"email\\":\\"sochethanhlong@gmailcom\\",\\"phone\\":\\"012134142\\",\\"ten\\":\\"So che Thanh Long\\"}","ngaydat":1516157138000,"ngaygiao":1516156983000,"lat":0,"lng":0,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"012134142","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516156983000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(132, '{"idddh":156,"iduserkh":68,"inforkh":"{\\"dcgiao\\":\\"ap an lac 1, trung an, vung liem, vinh long\\",\\"email\\":\\"sochethanhlong@gmailcom\\",\\"phone\\":\\"0124412\\",\\"ten\\":\\"So che Thanh Long\\"}","ngaydat":1516157785000,"ngaygiao":1516157714000,"lat":10.0306944,"lng":106.1522126,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0124412","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516157714000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(133, '{"idddh":157,"iduserkh":68,"inforkh":"{\\"dcgiao\\":\\"to 1 trung hoa 1, trung an, vung liem, vinh long\\",\\"email\\":\\"sochethanhlong@gmailcom\\",\\"phone\\":\\"012412412\\",\\"ten\\":\\"So che Thanh Long\\"}","ngaydat":1516157825000,"ngaygiao":1516157798000,"lat":10.0306944,"lng":106.1522126,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"012412412","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516157798000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(134, '{"idddh":158,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"to 1 trung hoa 1, trung an, vung liem, vinh long\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516161454000,"ngaygiao":1516161384000,"lat":10.0306944,"lng":106.1522126,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":5,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516161384000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(135, '{"idddh":158,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"to 1 trung hoa 1, trung an, vung liem, vinh long\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516161454000,"ngaygiao":1516161384000,"lat":10.0306944,"lng":106.1522126,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":5,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516161384000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(136, '{"idddh":157,"iduserkh":68,"inforkh":"{\\"dcgiao\\":\\"to 1 trung hoa 1, trung an, vung liem, vinh long\\",\\"email\\":\\"sochethanhlong@gmailcom\\",\\"phone\\":\\"012412412\\",\\"ten\\":\\"So che Thanh Long\\"}","ngaydat":1516157825000,"ngaygiao":1516157798000,"lat":10.0306944,"lng":106.1522126,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"012412412","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516157798000}', 'onacceptorder', '[{"iduser":68,"issend":1}]'),
(137, '{"idddh":156,"iduserkh":68,"inforkh":"{\\"dcgiao\\":\\"ap an lac 1, trung an, vung liem, vinh long\\",\\"email\\":\\"sochethanhlong@gmailcom\\",\\"phone\\":\\"0124412\\",\\"ten\\":\\"So che Thanh Long\\"}","ngaydat":1516157785000,"ngaygiao":1516157714000,"lat":10.0306944,"lng":106.1522126,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0124412","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516157714000}', 'onacceptorder', '[{"iduser":68,"issend":1}]'),
(138, '{"idddh":153,"iduserkh":66,"inforkh":"{\\"email\\":\\"nssvl@gamil.com\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"012512512512\\",\\"ten\\":\\"Nông sản sạch Vĩnh Long\\"}","ngaydat":1516153865000,"ngaygiao":1516153863000,"lat":10.16521820862615,"lng":105.9233899282889,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"012512512512","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516153863000}', 'onacceptorder', '[{"iduser":66,"issend":0}]'),
(139, '{"idddh":159,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"to 1 ap kinh xa trung ngai vung liem vinh long\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516189104000,"ngaygiao":1516189039000,"lat":10.0474369,"lng":106.1963248,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":5,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516189039000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(140, '{"idddh":160,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516245453000,"ngaygiao":1516245439000,"lat":10.16549945344232,"lng":105.9228053224328,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516245439000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(141, '{"idddh":160,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516245453000,"ngaygiao":1516245439000,"lat":10.16549945344232,"lng":105.9228053224328,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516245439000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(142, '{"idddh":161,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516246378000,"ngaygiao":1516246377000,"lat":10.16558180564098,"lng":105.9228420351687,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516246377000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(143, '{"idddh":162,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Phường 5 Tp.  Vĩnh Long Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516260342000,"ngaygiao":1516260339000,"lat":10.253545,"lng":105.979103,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516260339000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(144, '{"idddh":163,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Ga Sài Gòn 1 Nguyễn Thông, Thành phố Hồ Chí Minh Thành Phố Hồ Chí Minh\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516261011000,"ngaygiao":1516261009000,"lat":10.78212562399201,"lng":106.6769081354141,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516261009000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(145, '{"idddh":164,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Phường 5 Tp.  Vĩnh Long Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516261171000,"ngaygiao":1516261167000,"lat":10.24132193998456,"lng":105.9909099620823,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516261167000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(146, '{"idddh":164,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Phường 5 Tp.  Vĩnh Long Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516261171000,"ngaygiao":1516261167000,"lat":10.24132193998456,"lng":105.9909099620823,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516261167000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(147, '{"idddh":163,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Ga Sài Gòn 1 Nguyễn Thông, Thành phố Hồ Chí Minh Thành Phố Hồ Chí Minh\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516261011000,"ngaygiao":1516261009000,"lat":10.78212562399201,"lng":106.6769081354141,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516261009000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(148, '{"idddh":162,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Phường 5 Tp.  Vĩnh Long Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516260342000,"ngaygiao":1516260339000,"lat":10.253545,"lng":105.979103,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516260339000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(149, '{"idddh":161,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516246378000,"ngaygiao":1516246377000,"lat":10.16558180564098,"lng":105.9228420351687,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516246377000}', 'onacceptorder', '[{"iduser":4,"issend":1}]');
INSERT INTO `pushnotification` (`id`, `content`, `key`, `receiver`) VALUES
(150, '{"idddh":159,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"to 1 ap kinh xa trung ngai vung liem vinh long\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516189104000,"ngaygiao":1516189039000,"lat":10.0474369,"lng":106.1963248,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":5,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516189039000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(151, '{"idddh":155,"iduserkh":68,"inforkh":"{\\"dcgiao\\":\\"to 13 ap an lac 1, xa trung an, vung liem, vinh long\\",\\"email\\":\\"sochethanhlong@gmailcom\\",\\"phone\\":\\"012134142\\",\\"ten\\":\\"So che Thanh Long\\"}","ngaydat":1516157138000,"ngaygiao":1516156983000,"lat":0,"lng":0,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"012134142","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516156983000}', 'onacceptorder', '[{"iduser":68,"issend":0}]'),
(152, '{"idddh":154,"iduserkh":66,"inforkh":"{\\"email\\":\\"nssvl@gamil.com\\",\\"dcgiao\\":\\"Xã Phú Quới\\",\\"phone\\":\\"012512512512\\",\\"ten\\":\\"Nông sản sạch Vĩnh Long\\"}","ngaydat":1516153947000,"ngaygiao":1516153945000,"lat":10.16521820862615,"lng":105.9233899282889,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"012512512512","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516153945000}', 'onacceptorder', '[{"iduser":66,"issend":0}]'),
(153, '{"idddh":164,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Phường 5 Tp.  Vĩnh Long Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516261171000,"ngaygiao":1516261167000,"lat":10.24132193998456,"lng":105.9909099620823,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516261167000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(154, '{"idddh":163,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Ga Sài Gòn 1 Nguyễn Thông, Thành phố Hồ Chí Minh Thành Phố Hồ Chí Minh\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516261011000,"ngaygiao":1516261009000,"lat":10.78212562399201,"lng":106.6769081354141,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516261009000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(155, '{"idddh":162,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Phường 5 Tp.  Vĩnh Long Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516260342000,"ngaygiao":1516260339000,"lat":10.253545,"lng":105.979103,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516260339000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(156, '{"idddh":165,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516266929000,"ngaygiao":1516266919000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516266919000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(157, '{"idddh":166,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Vĩnh Long, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516266955000,"ngaygiao":1516266946000,"lat":10.086128100000002,"lng":106.0169971,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516266946000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(158, '{"idddh":166,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Vĩnh Long, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516266955000,"ngaygiao":1516266946000,"lat":10.086128100000002,"lng":106.0169971,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516266946000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(159, '{"idddh":165,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516266929000,"ngaygiao":1516266919000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516266919000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(160, '{"idddh":166,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Vĩnh Long, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516266955000,"ngaygiao":1516266946000,"lat":10.086128100000002,"lng":106.0169971,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516266946000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(161, '{"idddh":167,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516274559000,"ngaygiao":1516274502000,"lat":10.16537076,"lng":105.9230399,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516274502000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(162, '{"idddh":168,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516278882000,"ngaygiao":1516278865000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516278865000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(163, '{"idddh":168,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516278882000,"ngaygiao":1516278865000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516278865000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(164, '{"idddh":167,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516274559000,"ngaygiao":1516274502000,"lat":10.16537076,"lng":105.9230399,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516274502000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(165, '{"idddh":169,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Đường Trần Phú Đường Trần Phú, H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516322741000,"ngaygiao":1516322736000,"lat":10.2277515,"lng":105.9896007,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00018\\",\\"tensp\\":\\"Bưởi Da Xanh Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516322736000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(166, '{"idddh":170,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Khoueng Oudomxai Khoueng Oudomxai\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516327150000,"ngaygiao":1516327147000,"lat":20.3827697,"lng":101.5710077,"infororder":"[{\\"gia\\":\\"80000.0\\",\\"idsp\\":\\"00021\\",\\"tensp\\":\\"Nước mắm Khải Hoàn Phú Quốc N30g\\\\/L 1 lít  Chai nhựa\\",\\"dvt\\":\\"Chai\\",\\"sl\\":1}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516327147000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(167, '{"idddh":170,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Khoueng Oudomxai Khoueng Oudomxai\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516327150000,"ngaygiao":1516327147000,"lat":20.3827697,"lng":101.5710077,"infororder":"[{\\"gia\\":\\"80000.0\\",\\"idsp\\":\\"00021\\",\\"tensp\\":\\"Nước mắm Khải Hoàn Phú Quốc N30g\\\\/L 1 lít  Chai nhựa\\",\\"dvt\\":\\"Chai\\",\\"sl\\":1}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516327147000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(168, '{"idddh":171,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516338632000,"ngaygiao":1516150169000,"lat":10.1656044,"lng":105.9231129,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00013\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 2 Có nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516150169000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(169, '{"idddh":172,"iduserkh":62,"inforkh":"{\\"dcgiao\\":\\"49 Trần Đại Nghĩa, Phường 4, Vĩnh Long, Việt Nam, Vĩnh Long, Vĩnh Long, Thành phố Vĩnh Long, Việt Nam\\",\\"email\\":\\"\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516426799000,"ngaygiao":1516426706000,"lat":10.2488188,"lng":105.9780545,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516426706000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(170, '{"idddh":172,"iduserkh":62,"inforkh":"{\\"dcgiao\\":\\"49 Trần Đại Nghĩa, Phường 4, Vĩnh Long, Việt Nam, Vĩnh Long, Vĩnh Long, Thành phố Vĩnh Long, Việt Nam\\",\\"email\\":\\"\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516426799000,"ngaygiao":1516426706000,"lat":10.2488188,"lng":105.9780545,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"20000\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516426706000}', 'onacceptorder', '[{"iduser":62,"issend":1}]'),
(171, '{"idddh":173,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516442150000,"ngaygiao":1516442139000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516442139000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(172, '{"idddh":173,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516442150000,"ngaygiao":1516442139000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516442139000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(173, '{"idddh":171,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516338632000,"ngaygiao":1516150169000,"lat":10.1656044,"lng":105.9231129,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00013\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 2 Có nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516150169000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(174, '{"idddh":169,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Đường Trần Phú Đường Trần Phú, H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516322741000,"ngaygiao":1516322736000,"lat":10.2277515,"lng":105.9896007,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00018\\",\\"tensp\\":\\"Bưởi Da Xanh Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516322736000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(175, '{"idddh":174,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"xã Hoà Bình, Vĩnh Long, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516443341000,"ngaygiao":1516443310000,"lat":10.035354,"lng":106.0581397,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516443310000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(176, '{"idddh":174,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"xã Hoà Bình, Vĩnh Long, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516443341000,"ngaygiao":1516443310000,"lat":10.035354,"lng":106.0581397,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516443310000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(177, '{"idddh":175,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516443471000,"ngaygiao":1516443465000,"lat":10.1654655,"lng":105.9229256,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516443465000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(178, '{"idddh":176,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516666314000,"ngaygiao":1516666312000,"lat":10.1656065129528,"lng":105.9228701541912,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00019\\",\\"tensp\\":\\"Bưởi Da Xanh Loại 2 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516666312000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(179, '{"idddh":176,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516666314000,"ngaygiao":1516666312000,"lat":10.1656065129528,"lng":105.9228701541912,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00019\\",\\"tensp\\":\\"Bưởi Da Xanh Loại 2 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516666312000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(180, '{"idddh":175,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516443471000,"ngaygiao":1516443465000,"lat":10.1654655,"lng":105.9229256,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516443465000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(181, '{"idddh":177,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Hải Nam Hải Nam\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516666405000,"ngaygiao":1516666403000,"lat":19.198096,"lng":109.7494054,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516666403000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(182, '{"idddh":177,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Hải Nam Hải Nam\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516666405000,"ngaygiao":1516666403000,"lat":19.198096,"lng":109.7494054,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516666403000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(183, '{"idddh":177,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Hải Nam Hải Nam\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516666405000,"ngaygiao":1516666403000,"lat":19.198096,"lng":109.7494054,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516666403000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(184, '{"idddh":178,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516678888000,"ngaygiao":1516678883000,"lat":10.16562036239557,"lng":105.9228071664515,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":2,\\"sotk\\":\\"7300001323\\",\\"tentk\\":\\"Vien Thanh nha\\",\\"tennh\\":\\"BIDV Vĩnh Long\\"}","feeship":0,"methodship":2,"datetimegiaokhach":1516678883000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(185, '{"idddh":178,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516678888000,"ngaygiao":1516678883000,"lat":10.16562036239557,"lng":105.9228071664515,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":2,\\"sotk\\":\\"7300001323\\",\\"tentk\\":\\"Vien Thanh nha\\",\\"tennh\\":\\"BIDV Vĩnh Long\\"}","feeship":0,"methodship":2,"datetimegiaokhach":1516678883000}', 'onacceptorder', '[{"iduser":62,"issend":1}]'),
(186, '{"idddh":179,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516678976000,"ngaygiao":1516678973000,"lat":10.16557586046156,"lng":105.9228694529161,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":2}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516678973000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(187, '{"idddh":180,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516690897000,"ngaygiao":1516690890000,"lat":10.16555909068339,"lng":105.9225104470792,"infororder":"[{\\"gia\\":\\"80000.0\\",\\"idsp\\":\\"00021\\",\\"tensp\\":\\"Nước mắm Khải Hoàn Phú Quốc N30g\\\\/L 1 lít  Chai nhựa\\",\\"dvt\\":\\"Chai\\",\\"sl\\":1}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516690890000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(188, '{"idddh":180,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516690897000,"ngaygiao":1516690890000,"lat":10.16555909068339,"lng":105.9225104470792,"infororder":"[{\\"gia\\":\\"80000.0\\",\\"idsp\\":\\"00021\\",\\"tensp\\":\\"Nước mắm Khải Hoàn Phú Quốc N30g\\\\/L 1 lít  Chai nhựa\\",\\"dvt\\":\\"Chai\\",\\"sl\\":1}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516690890000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(189, '{"idddh":179,"iduserkh":62,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nha\\"}","ngaydat":1516678976000,"ngaygiao":1516678973000,"lat":10.16557586046156,"lng":105.9228694529161,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":2}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516678973000}', 'onacceptorder', '[{"iduser":62,"issend":1}]'),
(190, '{"idddh":180,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516690897000,"ngaygiao":1516690890000,"lat":10.16555909068339,"lng":105.9225104470792,"infororder":"[{\\"gia\\":\\"80000.0\\",\\"idsp\\":\\"00021\\",\\"tensp\\":\\"Nước mắm Khải Hoàn Phú Quốc N30g\\\\/L 1 lít  Chai nhựa\\",\\"dvt\\":\\"Chai\\",\\"sl\\":1}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516690890000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(191, '{"idddh":181,"iduserkh":4,"inforkh":"{\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\"}","ngaydat":1516693552000,"ngaygiao":1516693549000,"lat":10.16537929886036,"lng":105.92284019115,"infororder":"[{\\"idsp\\":\\"00025\\",\\"gia\\":\\"30000.0\\",\\"sl\\":1,\\"tensp\\":\\"Đường Thốt Nốt Bột 500g  \\",\\"dvt\\":\\"500g\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\",\\"loai\\":1}","feeship":0,"methodship":1,"datetimegiaokhach":1516693549000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(192, '{"idddh":181,"iduserkh":4,"inforkh":"{\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\"}","ngaydat":1516693552000,"ngaygiao":1516693549000,"lat":10.16537929886036,"lng":105.92284019115,"infororder":"[{\\"idsp\\":\\"00025\\",\\"gia\\":\\"30000.0\\",\\"sl\\":1,\\"tensp\\":\\"Đường Thốt Nốt Bột 500g  \\",\\"dvt\\":\\"500g\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\",\\"loai\\":1}","feeship":0,"methodship":1,"datetimegiaokhach":1516693549000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(193, '{"idddh":181,"iduserkh":4,"inforkh":"{\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\"}","ngaydat":1516693552000,"ngaygiao":1516693549000,"lat":10.16537929886036,"lng":105.92284019115,"infororder":"[{\\"idsp\\":\\"00025\\",\\"gia\\":\\"30000.0\\",\\"sl\\":1,\\"tensp\\":\\"Đường Thốt Nốt Bột 500g  \\",\\"dvt\\":\\"500g\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\",\\"loai\\":1}","feeship":0,"methodship":1,"datetimegiaokhach":1516693549000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(194, '{"idddh":182,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cổng A ĐHCT, Xuân Khánh, Ninh Kiều, Cần Thơ, Việt Nam, Ninh Kiều, Cần Thơ, Xuân Khánh, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1516764106000,"ngaygiao":1516064510000,"lat":10.030444627119518,"lng":105.77163325781606,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":25,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1516064510000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(195, '{"idddh":183,"iduserkh":64,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0773980178\\",\\"ten\\":\\"Cơ sở Sáng Lợi\\"}","ngaydat":1517203602000,"ngaygiao":1517203600000,"lat":10.16540121753715,"lng":105.9227815178278,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0773980178","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517203600000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(196, '{"idddh":184,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"â\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517220482000,"ngaygiao":1517220470000,"lat":48.3705449,"lng":10.89779,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":5,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517220470000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(197, '{"idddh":185,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517226200000,"ngaygiao":1517226182000,"lat":10.16548652,"lng":105.92260197,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":5,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517226182000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(198, '{"idddh":185,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517226200000,"ngaygiao":1517226182000,"lat":10.16548652,"lng":105.92260197,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":5,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517226182000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(199, '{"idddh":184,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"â\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517220482000,"ngaygiao":1517220470000,"lat":48.3705449,"lng":10.89779,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":5,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517220470000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(200, '{"idddh":183,"iduserkh":64,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0773980178\\",\\"ten\\":\\"Cơ sở Sáng Lợi\\"}","ngaydat":1517203602000,"ngaygiao":1517203600000,"lat":10.16540121753715,"lng":105.9227815178278,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"0773980178","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517203600000}', 'onacceptorder', '[{"iduser":64,"issend":1}]'),
(201, '{"idddh":185,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517226200000,"ngaygiao":1517226182000,"lat":10.16548652,"lng":105.92260197,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":5,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517226182000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(202, '{"idddh":184,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"â\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517220482000,"ngaygiao":1517220470000,"lat":48.3705449,"lng":10.89779,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":5,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517220470000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(203, '{"idddh":183,"iduserkh":64,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0773980178\\",\\"ten\\":\\"Cơ sở Sáng Lợi\\"}","ngaydat":1517203602000,"ngaygiao":1517203600000,"lat":10.16540121753715,"lng":105.9227815178278,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":2,"phone":"0773980178","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517203600000}', 'onshiporder', '[{"iduser":64,"issend":1}]'),
(204, '{"idddh":186,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517278116000,"ngaygiao":1517278115000,"lat":10.16554945282618,"lng":105.9228131445441,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517278115000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(205, '{"idddh":186,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517278116000,"ngaygiao":1517278115000,"lat":10.16554945282618,"lng":105.9228131445441,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517278115000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(206, '{"idddh":187,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517278252000,"ngaygiao":1517278240000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517278240000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(207, '{"idddh":188,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cần Thơ, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517278289000,"ngaygiao":1517278282000,"lat":10.045161799999999,"lng":105.7468535,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517278282000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(208, '{"idddh":189,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517304787000,"ngaygiao":1517304751000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00015\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 3 Có nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517304751000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(209, '{"idddh":190,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517304968000,"ngaygiao":1517304962000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517304962000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(210, '{"idddh":191,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517305224000,"ngaygiao":1517305214000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517305214000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(211, '{"idddh":192,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517305484000,"ngaygiao":1517305478000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517305478000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(212, '{"idddh":193,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517305596000,"ngaygiao":1517305592000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517305592000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(213, '{"idddh":194,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517305721000,"ngaygiao":1517305713000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517305713000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(214, '{"idddh":195,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517305909000,"ngaygiao":1517305902000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517305902000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(215, '{"idddh":196,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517305984000,"ngaygiao":1517305977000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517305977000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(216, '{"idddh":197,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517306076000,"ngaygiao":1517306064000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517306064000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(217, '{"idddh":198,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517306193000,"ngaygiao":1517306186000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517306186000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(218, '{"idddh":199,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517306349000,"ngaygiao":1517306337000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517306337000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(219, '{"idddh":200,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517306679000,"ngaygiao":1517306666000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517306666000}', 'onneworder', '[{"iduser":4,"issend":1}]');
INSERT INTO `pushnotification` (`id`, `content`, `key`, `receiver`) VALUES
(220, '{"idddh":201,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517307099000,"ngaygiao":1517307068000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517307068000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(221, '{"idddh":202,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517307114000,"ngaygiao":1517307105000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517307105000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(222, '{"idddh":187,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517278252000,"ngaygiao":1517278240000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517278240000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(223, '{"idddh":188,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cần Thơ, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517278289000,"ngaygiao":1517278282000,"lat":10.045161799999999,"lng":105.7468535,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517278282000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(224, '{"idddh":202,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517307114000,"ngaygiao":1517307105000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517307105000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(225, '{"idddh":201,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517307099000,"ngaygiao":1517307068000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517307068000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(226, '{"idddh":201,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517307099000,"ngaygiao":1517307068000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517307068000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(227, '{"idddh":200,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517306679000,"ngaygiao":1517306666000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517306666000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(228, '{"idddh":199,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517306349000,"ngaygiao":1517306337000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517306337000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(229, '{"idddh":198,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517306193000,"ngaygiao":1517306186000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"50000\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":25000,"methodship":1,"datetimegiaokhach":1517306186000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(230, '{"idddh":197,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517306076000,"ngaygiao":1517306064000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"55000\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":20000,"methodship":1,"datetimegiaokhach":1517306064000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(231, '{"idddh":196,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517305984000,"ngaygiao":1517305977000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517305977000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(232, '{"idddh":195,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517305909000,"ngaygiao":1517305902000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517305902000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(233, '{"idddh":194,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517305721000,"ngaygiao":1517305713000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517305713000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(234, '{"idddh":193,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517305596000,"ngaygiao":1517305592000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517305592000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(235, '{"idddh":192,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517305484000,"ngaygiao":1517305478000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517305478000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(236, '{"idddh":191,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517305224000,"ngaygiao":1517305214000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517305214000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(237, '{"idddh":190,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517304968000,"ngaygiao":1517304962000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517304962000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(238, '{"idddh":189,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517304787000,"ngaygiao":1517304751000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00015\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 3 Có nhánh\\"},{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517304751000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(239, '{"idddh":203,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517392483000,"ngaygiao":1517392475000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517392475000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(240, '{"idddh":203,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517392483000,"ngaygiao":1517392475000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517392475000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(241, '{"idddh":204,"iduserkh":138,"inforkh":"{\\"email\\":\\"0966618745\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0966618745\\",\\"ten\\":\\"Long\\"}","ngaydat":1517477590000,"ngaygiao":1517477589000,"lat":10.16544207931512,"lng":105.9227940068635,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00018\\",\\"tensp\\":\\"Bưởi Da Xanh Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0966618745","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517477589000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(242, '{"idddh":204,"iduserkh":138,"inforkh":"{\\"email\\":\\"0966618745\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0966618745\\",\\"ten\\":\\"Long\\"}","ngaydat":1517477590000,"ngaygiao":1517477589000,"lat":10.16544207931512,"lng":105.9227940068635,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00018\\",\\"tensp\\":\\"Bưởi Da Xanh Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0966618745","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517477589000}', 'ondeleteorder', '[{"iduser":138,"issend":0}]'),
(243, '{"idddh":205,"iduserkh":141,"inforkh":"{\\"email\\":\\"0966618745\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0966618745\\",\\"ten\\":\\"PL\\"}","ngaydat":1517481588000,"ngaygiao":1517481586000,"lat":10.16540146899425,"lng":105.9228333179894,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00012\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Có nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":0,"phone":"0966618745","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517481586000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(244, '{"idddh":205,"iduserkh":141,"inforkh":"{\\"email\\":\\"0966618745\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0966618745\\",\\"ten\\":\\"PL\\"}","ngaydat":1517481588000,"ngaygiao":1517481586000,"lat":10.16540146899425,"lng":105.9228333179894,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00012\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Có nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":1,"phone":"0966618745","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517481586000}', 'onacceptorder', '[{"iduser":141,"issend":0}]'),
(245, '{"idddh":206,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517482654000,"ngaygiao":1517482645000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517482645000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(246, '{"idddh":206,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517482654000,"ngaygiao":1517482645000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"55000\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":25000,"methodship":1,"datetimegiaokhach":1517482645000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(247, '{"idddh":207,"iduserkh":146,"inforkh":"{\\"email\\":\\"0989501288\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0989501288\\",\\"ten\\":\\"vo huynh ngan\\"}","ngaydat":1517579258000,"ngaygiao":1517579251000,"lat":10.16565225553714,"lng":105.9228445497397,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00036\\",\\"tensp\\":\\"Nước Tương TAMARI Nguyên Dương   Chai nhựa\\",\\"dvt\\":\\"Chai\\",\\"sl\\":1}]","statusdh":0,"phone":"0989501288","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517579251000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(248, '{"idddh":207,"iduserkh":146,"inforkh":"{\\"email\\":\\"0989501288\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0989501288\\",\\"ten\\":\\"vo huynh ngan\\"}","ngaydat":1517579258000,"ngaygiao":1517579251000,"lat":10.16565225553714,"lng":105.9228445497397,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00036\\",\\"tensp\\":\\"Nước Tương TAMARI Nguyên Dương   Chai nhựa\\",\\"dvt\\":\\"Chai\\",\\"sl\\":1}]","statusdh":1,"phone":"0989501288","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517579251000}', 'onacceptorder', '[{"iduser":146,"issend":0}]'),
(249, '{"idddh":207,"iduserkh":146,"inforkh":"{\\"email\\":\\"0989501288\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0989501288\\",\\"ten\\":\\"vo huynh ngan\\"}","ngaydat":1517579258000,"ngaygiao":1517579251000,"lat":10.16565225553714,"lng":105.9228445497397,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00036\\",\\"tensp\\":\\"Nước Tương TAMARI Nguyên Dương   Chai nhựa\\",\\"dvt\\":\\"Chai\\",\\"sl\\":1}]","statusdh":2,"phone":"0989501288","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517579251000}', 'onshiporder', '[{"iduser":146,"issend":0}]'),
(250, '{"idddh":203,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517392483000,"ngaygiao":1517392475000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"55000\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":22000,"methodship":1,"datetimegiaokhach":1517392475000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(251, '{"idddh":206,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517482654000,"ngaygiao":1517482645000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"55000\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":25000,"methodship":1,"datetimegiaokhach":1517482645000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(252, '{"idddh":205,"iduserkh":141,"inforkh":"{\\"email\\":\\"0966618745\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0966618745\\",\\"ten\\":\\"PL\\"}","ngaydat":1517481588000,"ngaygiao":1517481586000,"lat":10.16540146899425,"lng":105.9228333179894,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00012\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Có nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":2,"phone":"0966618745","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":22000,"methodship":1,"datetimegiaokhach":1517481586000}', 'onshiporder', '[{"iduser":141,"issend":0}]'),
(253, '{"idddh":198,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517306193000,"ngaygiao":1517306186000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"50000\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":25000,"methodship":1,"datetimegiaokhach":1517306186000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(254, '{"idddh":187,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517278252000,"ngaygiao":1517278240000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517278240000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(255, '{"idddh":186,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Xã Phú Quới H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517278116000,"ngaygiao":1517278115000,"lat":10.16554945282618,"lng":105.9228131445441,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"dvt\\":\\"Kg\\",\\"sl\\":1}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517278115000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(256, '{"idddh":197,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Cà Mau, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517306076000,"ngaygiao":1517306064000,"lat":9.1526728,"lng":105.1960795,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"55000\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":20000,"methodship":1,"datetimegiaokhach":1517306064000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(257, '{"idddh":208,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Vũng Liêm, Vĩnh Long, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517722855000,"ngaygiao":1517722840000,"lat":10.058632000000001,"lng":106.1345705,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517722840000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(258, '{"idddh":209,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Tt. Vũng Liêm H. Vũng Lient Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517722951000,"ngaygiao":1517722949000,"lat":10.09654683606677,"lng":106.1889816298652,"infororder":"[{\\"gia\\":\\"23000.0\\",\\"idsp\\":\\"00037\\",\\"tensp\\":\\"Tương Hột Phước Khang 520g  Chai nhựa\\",\\"dvt\\":\\"Keo\\",\\"sl\\":1}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517722949000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(259, '{"idddh":209,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Tt. Vũng Liêm H. Vũng Lient Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517722951000,"ngaygiao":1517722949000,"lat":10.09654683606677,"lng":106.1889816298652,"infororder":"[{\\"gia\\":\\"23000.0\\",\\"idsp\\":\\"00037\\",\\"tensp\\":\\"Tương Hột Phước Khang 520g  Chai nhựa\\",\\"dvt\\":\\"Keo\\",\\"sl\\":1}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":1,\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517722949000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(260, '{"idddh":208,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Vũng Liêm, Vĩnh Long, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1517722855000,"ngaygiao":1517722840000,"lat":10.058632000000001,"lng":106.1345705,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1517722840000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(261, '{"idddh":210,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1521284240000,"ngaygiao":1521284167000,"lat":10.1655852,"lng":105.9227885,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1521284167000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(262, '{"idddh":210,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1521284240000,"ngaygiao":1521284167000,"lat":10.1655852,"lng":105.9227885,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1521284167000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(263, '{"idddh":211,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1521284290000,"ngaygiao":1521284284000,"lat":10.1653008,"lng":105.9229603,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1521284284000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(264, '{"idddh":212,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Vũng Liêm, Vĩnh Long, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1521531593000,"ngaygiao":1521531569000,"lat":10.058632000000001,"lng":106.1345705,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1521531569000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(265, '{"idddh":212,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Vũng Liêm, Vĩnh Long, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1521531593000,"ngaygiao":1521531569000,"lat":10.058632000000001,"lng":106.1345705,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1521531569000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(266, '{"idddh":211,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1521284290000,"ngaygiao":1521284284000,"lat":10.1653008,"lng":105.9229603,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":2,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1521284284000}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(267, '{"idddh":213,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Tp.  Vĩnh Long Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1521671385000,"ngaygiao":1521671768000,"lat":10.24132769501128,"lng":105.9908186377015,"infororder":"[{\\"gia\\":85000,\\"idsp\\":\\"00023\\",\\"dvt\\":\\"Chai\\",\\"tensp\\":\\"Nước Mắm Cốt Khải Hoàn N43g\\\\/L 510ml  Chai Sành\\",\\"sl\\":2},{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00153\\",\\"dvt\\":\\"Kg\\",\\"tensp\\":\\"Nhãn EDaw  \\",\\"sl\\":2}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":null}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(268, '{"idddh":213,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Tp.  Vĩnh Long Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1521671385000,"ngaygiao":1521671768000,"lat":10.24132769501128,"lng":105.9908186377015,"infororder":"[{\\"gia\\":85000,\\"idsp\\":\\"00023\\",\\"dvt\\":\\"Chai\\",\\"tensp\\":\\"Nước Mắm Cốt Khải Hoàn N43g\\\\/L 510ml  Chai Sành\\",\\"sl\\":2},{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00153\\",\\"dvt\\":\\"Kg\\",\\"tensp\\":\\"Nhãn EDaw  \\",\\"sl\\":2}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":null}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(269, '{"idddh":210,"iduserkh":4,"inforkh":"{\\"dcgiao\\":\\"Đường KDC Phước yên A, Phú Quới, Long Hồ, Vĩnh Long, Việt Nam, Long Hồ, Vĩnh Long, Phú Quới, Việt Nam\\",\\"email\\":\\"viennhagroup@gmail.com\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1521284240000,"ngaygiao":1521284167000,"lat":10.1655852,"lng":105.9227885,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"sl\\":1,\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\"}]","statusdh":2,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1521284167000}', 'onshiporder', '[{"iduser":4,"issend":1}]'),
(270, '{"idddh":214,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Tp.  Vĩnh Long Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1521757038000,"ngaygiao":1521757421000,"lat":10.24135504850209,"lng":105.9907584172729,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"dvt\\":\\"Kg\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"sl\\":1}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":null}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(271, '{"idddh":214,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Tp.  Vĩnh Long Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1521757038000,"ngaygiao":1521757421000,"lat":10.24135504850209,"lng":105.9907584172729,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"dvt\\":\\"Kg\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"sl\\":1}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":null}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(272, '{"idddh":215,"iduserkh":112,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"vien vo phu khang\\"}","ngaydat":1521952459000,"ngaygiao":1521952837000,"lat":10.16541513149642,"lng":105.9228941706064,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"dvt\\":\\"Kg\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"sl\\":2}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"2\\",\\"sotk\\":\\"55678\\",\\"tentk\\":\\"Anh Tuan\\",\\"tennh\\":\\"Sacombank\\"}","feeship":0,"methodship":2,"datetimegiaokhach":null}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(273, '{"idddh":216,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1521952527000,"ngaygiao":1521952911000,"lat":10.16539891251378,"lng":105.9228859563413,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"dvt\\":\\"Kg\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"sl\\":2}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":null}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(274, '{"idddh":217,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Tp.  Vĩnh Long Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1521978548000,"ngaygiao":1521978925000,"lat":10.24138362956635,"lng":105.9907216539894,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"dvt\\":\\"Kg\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"sl\\":2}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"2\\",\\"sotk\\":\\"55678\\",\\"tentk\\":\\"Anh Tuan\\",\\"tennh\\":\\"Sacombank\\"}","feeship":0,"methodship":2,"datetimegiaokhach":1521978925000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(275, '{"idddh":217,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"Tp.  Vĩnh Long Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1521978548000,"ngaygiao":1521978925000,"lat":10.24138362956635,"lng":105.9907216539894,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"dvt\\":\\"Kg\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"sl\\":2}]","statusdh":1,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"2\\",\\"sotk\\":\\"55678\\",\\"tentk\\":\\"Anh Tuan\\",\\"tennh\\":\\"Sacombank\\"}","feeship":0,"methodship":2,"datetimegiaokhach":1521978925000}', 'onacceptorder', '[{"iduser":4,"issend":1}]'),
(276, '{"idddh":216,"iduserkh":4,"inforkh":"{\\"email\\":\\"viennhagroup@gmail.com\\",\\"dcgiao\\":\\"H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"Viên Thanh Nhã\\"}","ngaydat":1521952527000,"ngaygiao":1521952911000,"lat":10.16539891251378,"lng":105.9228859563413,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"dvt\\":\\"Kg\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"sl\\":2}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tentk\\":\\"\\",\\"tennh\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":null}', 'ondeleteorder', '[{"iduser":4,"issend":1}]'),
(277, '{"idddh":215,"iduserkh":112,"inforkh":"{\\"email\\":\\"\\",\\"dcgiao\\":\\"H. Long Hồ Tỉnh Vĩnh Long\\",\\"phone\\":\\"0939191028\\",\\"ten\\":\\"vien vo phu khang\\"}","ngaydat":1521952459000,"ngaygiao":1521952837000,"lat":10.16541513149642,"lng":105.9228941706064,"infororder":"[{\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00001\\",\\"dvt\\":\\"Kg\\",\\"tensp\\":\\"Bưởi Năm Roi Loại 1 Không nhánh\\",\\"sl\\":2}]","statusdh":0,"phone":"0939191028","inforthanhtoan":"{\\"loai\\":\\"2\\",\\"sotk\\":\\"55678\\",\\"tentk\\":\\"Anh Tuan\\",\\"tennh\\":\\"Sacombank\\"}","feeship":0,"methodship":2,"datetimegiaokhach":null}', 'ondeleteorder', '[{"iduser":112,"issend":1}]'),
(278, '{"idddh":218,"iduserkh":174,"inforkh":"{\\"dcgiao\\":\\"số 3 trưng nữ vương\\",\\"email\\":\\"thao117815@gmail.com\\",\\"phone\\":\\"01692064737\\",\\"ten\\":\\"hồ\\"}","ngaydat":1531989320000,"ngaygiao":1531989253000,"lat":0,"lng":0,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00152\\",\\"sl\\":1,\\"tensp\\":\\"Chôm Chôm  \\"}]","statusdh":0,"phone":"01692064737","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1531989253000}', 'onneworder', '[{"iduser":4,"issend":1}]'),
(279, '{"idddh":218,"iduserkh":174,"inforkh":"{\\"dcgiao\\":\\"số 3 trưng nữ vương\\",\\"email\\":\\"thao117815@gmail.com\\",\\"phone\\":\\"01692064737\\",\\"ten\\":\\"hồ\\"}","ngaydat":1531989320000,"ngaygiao":1531989253000,"lat":0,"lng":0,"infororder":"[{\\"dvt\\":\\"Kg\\",\\"gia\\":\\"Giá liên hệ\\",\\"idsp\\":\\"00152\\",\\"sl\\":1,\\"tensp\\":\\"Chôm Chôm  \\"}]","statusdh":0,"phone":"01692064737","inforthanhtoan":"{\\"loai\\":\\"1\\",\\"sotk\\":\\"\\",\\"tennh\\":\\"\\",\\"tentk\\":\\"\\"}","feeship":0,"methodship":1,"datetimegiaokhach":1531989253000}', 'ondeleteorder', '[{"iduser":174,"issend":0}]');

-- --------------------------------------------------------

--
-- Table structure for table `sanpham`
--

CREATE TABLE IF NOT EXISTS `sanpham` (
  `idsp` int(6) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `masp` varchar(100) NOT NULL,
  `tensp` varchar(500) NOT NULL,
  `tensp_en` varchar(500) NOT NULL,
  `maloaisp` text NOT NULL,
  `gia` double NOT NULL,
  `giachuoi` varchar(500) NOT NULL DEFAULT '',
  `giachuoi_en` varchar(500) NOT NULL,
  `anhsp` text NOT NULL,
  `tendvt` varchar(100) NOT NULL,
  `tendvt_en` varchar(500) NOT NULL,
  `ispecial` int(11) NOT NULL DEFAULT 1,
  `desc_vi` text NOT NULL,
  `desc_en` text NOT NULL,
  `visible` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`idsp`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=192 ;

--
-- Dumping data for table `sanpham`
--

INSERT INTO `sanpham` (`idsp`, `masp`, `tensp`, `tensp_en`, `maloaisp`, `gia`, `giachuoi`, `giachuoi_en`, `anhsp`, `tendvt`, `tendvt_en`, `ispecial`, `desc_vi`, `desc_en`, `visible`) VALUES
(000042, 'CCRD', 'Chôm Chôm Râu Dài', 'Râu Dài Rambutan', 'CC', 3500, 'Giá liên hệ', 'Contact price', 'image_upload/img_1554486523215', 'Kg', 'Kg', 1, '', '', 1),
(000064, 'CCJava', 'Chôm Chôm Java', 'Java Rambutam', 'CC', 34234230, 'Giá liên hệ', 'Contact price', 'image_upload/img_1553673810636', 'Kg', 'Kg\n', 1, '', '', 1),
(000065, 'XoaiCatnum', 'Xoài Cát Núm', 'Cát Núm Mango', 'X', 0, 'Giá liên hệ', 'Contact price', 'image_upload/img_1554486587263', 'Kg', 'Kg\n', 1, '', '', 1),
(000066, 'XoaiHL', 'Xoài Hòa Lộc', 'Hòa Lộc Mango', 'X', 0, 'Giá liên hệ', 'Contact price', 'image_upload/img_1553673779190', 'Kg', 'Kg\n', 1, '', '', 1),
(000067, 'nhan', 'Nhãn Edaw', 'Edaw Longan', 'N', 0, 'Giá liên hệ', 'Contact price', 'image_upload/img_1553673719907', 'Kg', 'Kg', 1, '', '', 1),
(000068, 'SRRi6', 'Sầu Riêng Ri6', 'Ri6 Durian', 'SR', 54000, 'Giá liên hệ', 'Contact price', 'image_upload/img_1553673731209', 'Kg', 'Kg', 1, '', '', 1),
(000160, 'XCC', 'Xoài Cát Chu', 'Chu Mango', 'X', 0, 'Giá liên hệ', 'Contact price', 'image_upload/xoai.png', 'Kg', 'Kg', 1, '', '', 1),
(000169, 'ManXD', 'Mận Xanh Đường', 'Xanh Đường Plum', 'M', 0, 'Giá liên hệ', 'Contact price', 'image_upload/img_1553673708380', 'Kg', '', 1, '', '', 1),
(000171, 'TLRT', 'Thanh Long Ruột Trắng', 'White Dragon', 'TL', 0, 'Giá liên hệ', 'Contact Price', 'image_upload/tlt.png', 'Kg', 'Kg', 1, '', '', 1),
(000172, 'TLRD', 'Thanh Long Ruột Đỏ', 'Red Dragon', 'TL', 0, 'Giá liên hệ', 'Contact Price', 'image_upload/tldo.png', 'Kg', 'Kg', 1, '', '', 1),
(000173, 'CS', 'Cam Sành', 'Sành Orange', 'C', 0, 'Giá liên hệ', 'Contact Price', 'image_upload/img_1553673694121', 'Kg', 'Kg', 1, '', '', 1),
(000185, '000005', 'Bưởi Năm Roi', 'Nam Roi Pomelo', 'B', 0, 'Liên hệ', 'Contact price', 'image_upload/img_1553673680886', 'Chục', 'dozen', 1, '', '', 1),
(000186, 'VS', 'Trái Vú Sữa', 'Star Apple', 'VS', 0, 'Giá liên hệ', '', 'image_upload/img_1554486563250', 'Kg', 'kg', 1, '', '', 1),
(000187, 'KL', 'Khoai Lang Tím', ' sweet potato', 'KL', 0, 'Giá liên hệ', '', 'image_upload/img_1554486534204', 'Kg', 'kg', 1, '', '', 1),
(000190, '000006', 'Bưởi Da Xanh', 'Da Xanh Pomelo', 'B', 0, 'Giá liên hệ ', 'Price contract', 'image_upload/img_1554486508672', 'Kg', 'kg', 1, '', '', 1),
(000191, 'XDL', 'Xoài Đài Loan', 'Đài Loan Mango', 'X', 0, 'Giá liên hệ', 'Contract price', 'image_upload/img_1555561982598', 'Kg', 'kg', 1, '', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `slogan`
--

CREATE TABLE IF NOT EXISTS `slogan` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `noidung` varchar(800) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `slogan`
--

INSERT INTO `slogan` (`id`, `noidung`) VALUES
(1, 'Sản phẩm đạt tiêu chuẩn VietGAP'),
(2, 'Sản phẩm tươi ngon  từ các nhà vườn');

-- --------------------------------------------------------

--
-- Table structure for table `taikhoan`
--

CREATE TABLE IF NOT EXISTS `taikhoan` (
  `sotk` varchar(50) NOT NULL,
  `tentk` varchar(200) NOT NULL,
  `nganhang` varchar(500) NOT NULL,
  PRIMARY KEY (`sotk`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `taikhoan`
--

INSERT INTO `taikhoan` (`sotk`, `tentk`, `nganhang`) VALUES
('55678', 'Anh Tuan', 'Sacombank'),
('7300001323', 'Vien Thanh nha', 'BIDV Vĩnh Long');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `iduser` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL DEFAULT '',
  `password` varchar(500) NOT NULL DEFAULT '',
  `permission` int(11) NOT NULL DEFAULT 4,
  `detailname` varchar(500) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(200) NOT NULL,
  `keyios` longtext NOT NULL DEFAULT '[]',
  PRIMARY KEY (`iduser`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=273 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`iduser`, `username`, `password`, `permission`, `detailname`, `phone`, `email`, `keyios`) VALUES
(1, '0939191028', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 0, 'Nhã Viên', '4242342342', '4234', '[]'),
(2, 'nongdan', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 1, 'Khánh Vân', '', '', '[]'),
(5, 'nguoidung', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 4, 'fdsfsd', '', 'fdsf', '[]'),
(11, 'quanlylh', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 6, 'Chị Thúy', '123456789', 'test1@gmail.com', '12345'),
(12, 'test2@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 4, 'Test2', '12345678', '12345678', '12345'),
(14, '0987120982', '0ca189836ab1fb46ed09e1bfac545785b63f761ed797ab58e6f334bdd12cad79', 1, 'Đoàn Văn Tài', '0987120982', '', '[]'),
(15, '0364522059', '799f7d8521dc24bda34d7d4e83f17b756b68a51c45c2567193aaee40d9381219', 1, 'Đinh Văn Hùng', '', '', '[]'),
(16, '0907438211', '88adcfdacacdb16ab1ceaa72a991e189607009cc9dde6e1a42a4508ae5ed89c4', 1, 'Đinh Quốc Hết', '0907438211', '', '[]'),
(17, '0918256567', '103bd4f24cf2e2b6c9572716d5e557f664bbcafec4788c20239f50e408d39431', 1, 'Đinh Công Khâm', '0918256567', '', '[]'),
(18, '01693325290', 'a85f6b8a1a2f634332a2e8a80e8c7ea50508cf418c7659c162612cd2971e0b58', 1, 'Đào Văn Đầy', '01693325290', '', '[]'),
(19, '0902799717', '7a0ebeb8916fb25e8b50a400121d61fd56b30249d7c0045be72911e0d5da18c8', 1, 'Đào Văn Thận', '0902799717', '', '[]'),
(20, '0766818482', '29841ee94b4ec3e09581388b061a8cdd81366651fc1cd128171cb1dc07bbc7e4', 1, 'Võ Văn Nhọn', '0766818482', '', '[]'),
(21, '01699258098', '9d9c207434d20f0da783a6e7511784e8fca4bcefe1958bb6d2917b3e2d2de3fc', 1, 'Võ Văn Lĩnh', '01699258098', '', '[]'),
(22, '0933241533', '64a9a04ed42e04320f373a9c762686fa817cc4aede2ba4f94a1749683b624534', 1, 'Võ Văn Hòa', '0933241533', '', '[]'),
(23, '0397354488', 'b86eb1e81a55600882d77f05c201fad7b254c5c0ee9fdd5d172d44c40e768764', 1, 'Võ Văn Hòa', '0397354488', '', '[]'),
(24, '0939246241', 'b77d2c4adadb79df31004fefd85e578c032665ee63f0dec2378bbc319a03751f', 1, 'Võ Văn Dững', '0939246241', '', '[]'),
(25, '0393752805', '86385d9cadc81450a62d787379184c83af6de5a861a1bba37de22df2d50ca5bb', 1, 'Võ Thị Cẩm', '0393752805', '', '[]'),
(26, '0961428407', '0b4f47e47a5bac6efcd4ac666e48ccfb53ea9025e5b8f068e84e6f171cfdc578', 1, 'Võ Thanh Xuân', '0961428407', '', '[]'),
(27, '0369426462', 'd7bb4b5dfd6e5ed5e1fa7b805c4bbfc9f1ccdce93bf28f0e658f253527f5db34', 1, 'Võ Sĩ Phụng Sơn', '0369426462', '', '[]'),
(28, '0974482538', '8697653d007b69c9383ae76ea46036ec05e15b76d75e0681cf2f3a6dc8c78a09', 1, 'Võ Phi Thường', '0974482538', '', '[]'),
(29, '0345612101', '2e5d363d09846f88f7fd2ce1033a302aff0b7f8b70ef52aba4f22a6f39d43278', 1, 'Trương Văn Tám', '0345612101', '', '[]'),
(30, '0789650609', 'ec4b73f2c301178f03dcc6e7a35f6f7fb28fb061badc0c59a80ddbf37faa3c75', 1, 'Trương Văn Sáng', '0789650609', '', '[]'),
(31, '01668512936', '0a7ac801ff3554a046868864432d252be78948ca5c60d66526d99903bfb8c752', 1, 'Trương Văn Liêm', '01668512936', '', '[]'),
(32, '0789704816', '5e9a714b1de6fc7f974c9bb9d2783b9c18b291d8fc9259b2e1f5094af5fd6fa6', 1, 'Trương Văn Khanh', '0789704816', '', '[]'),
(33, '0342202696', '4728104c01a8ab3def5707ad04d2e03629b1efd8dc2099a53925f9c49016f384', 1, 'Trương Văn Anh', '0342202696', '', '[]'),
(34, '0346707831', '69e593022d26c7291a02f1e508d635e27e30eac70542b83aceb7ab3878ae77cb', 1, 'Trương Trung Tính', '0346707831', '', '[]'),
(35, '0776134436', '6a1bb9f25214526e4ae423640b8f861207cf58ba4efa049783164ddf50bfe633', 1, 'Trương Thanh Việt', '0776134436', '', '[]'),
(36, '0939525309', '7ef1b2a4304d6b291c952289a9f9708d6394b49b6bdbab8fd8e8d946a056dfd9', 1, 'Trương Thanh Tùng', '0939525309', '', '[]'),
(37, '01288781954', 'cbd3d2015a00d14f639b5356f726685d1cb641e6929e5e742d5ef0fd9fb9093e', 1, 'Trịnh Đình Thanh', '01288781954', '', '[]'),
(38, '0919717797', '6c509ae3b93e2454f5af48074b814c88924991e8df1ebd83e53fd23af4cfd0c7', 1, 'Trịnh Văn Đen', '0919717797', '', '[]'),
(39, '0949040403', '341182fe848d583f25d2297e6b4191d3bca58705d6de8f2b472130600f2b93c4', 1, 'Trịnh Minh Thuận', '0949040403', '', '[]'),
(40, '01287987939', '187f412638a21e20f2d3e28a6154d8c427b1ff3026814878b1d7f26a938be2d3', 1, 'Trần Văn Vui', '01287987939', '', '[]'),
(41, '01208877231', '8a5f060c92548510fc51d26832716304f1deb154cbe63375a822976f8e0b90b6', 1, 'Trần Văn Vũ', '01208877231', '', '[]'),
(42, '0976075534', 'c367e2582b7c371a728c6af9d8f2c1a15410112fdfa35dc4bb4ff2eb36e9cc6f', 1, 'Trần Văn Tư', '0976075534', '', '[]'),
(43, '02703859251', '8112558918d2b1709539f727f5b56e8773a920cf1292521363cafa6c01a542b4', 1, 'Trần  Văn Thơm', '02703859251', '', '[]'),
(44, '0353457870', 'ab5a42c2183fb3df1bdf0aa70f2912a5f23b2d6bc61fc7b5a2672b07474319e4', 1, 'Trần Văn Sáu', '0353457870', '', '[]'),
(46, '0902799718', 'cb9ae2b8858b390b25b54997275f1b7c9cdef1ed851d99db9c67e37de3c9ffb7', 1, 'Cao Thanh Quới', '0902799718', '', '[]'),
(48, 'nguyen', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 4, 'Nguyễn Thảo Nguyên', '0352812020', 'thaonguyennt1804@gmail.com', ''),
(49, '01203822367', 'd2f48d75a89882309cdcc7239fb99dde882a1e4637b5fa538f3bcb47773bf6ea', 1, 'Trần Văn Phước', '01203822367', '', '[]'),
(50, '0967288959', 'ce9bf11eb11f78bcdb2409ce6288fd704f6d382cb28d095cceab9070d1b50e91', 1, 'Nguyễn Ngọc Đầy', '0967288959', '', '[]'),
(51, '0902937051', '860d1f97cb0b98cab33aec4a5193d58b0716815953d99a7f7d414d565c1bff7b', 1, 'Nguyễn Ngọc Nhân', '0902937051', '', '[]'),
(52, '0939392049', 'b513ee27cc50dc5171bfff22d6997caa94598da524cf5495b5be04fc5eec0848', 1, 'Nguyễn Ngọc Hùng', '0939392049', '', '[]'),
(53, '0348270671', 'd3aaf2da8a445fe1ae42e4ce0afca4e136e81568c27f0122c65261cdcdb340af', 1, 'Nguyễn Minh Thế', '0348270671', '', '[]'),
(55, '0398657359', '60858f1519eb1f717ad1a5f0ff0324740f0f7cdcf0f6dba7a818d3d71c4fe56e', 1, 'Nguyễn Minh Kha', '0398657359', '', '[]'),
(56, '0776565809', 'af8599e1598166ea389952a9d0dbb4ecdb6f2a63ae855617d2f156c9111f1225', 1, 'Nguyễn Minh Kha', '0776565809', '', '[]'),
(57, '0964510132', 'aa0f1f4c912c467580565affd86f6fa93712ea057f07302aa680e210aeb72731', 1, 'Huỳnh Văn Hữu', '0964510132', '', '[]'),
(58, '0857131318', '06063e17762719dff1695027845baf37fae566e7367ea14673e51b6c39e3624c', 1, 'Huỳnh Văn Hoàng', '0857131318', '', '[]'),
(59, '0984180646', '1d2b4dc5b3ae9121404af1bf404d1363263caa7565ea43674214ed571b11dc62', 1, 'Huỳnh Văn Dảnh', '0984180646', '', '[]'),
(60, '01667240248', 'bcec77811ed03d42c5b7a901a4d577e60a9b8871718663b01f7ca46bc3c3bf96', 1, 'Huỳnh Trung Trực', '01667240248', '', '[]'),
(61, '0368515882', 'a0406d795752461937bad716d3b02030cdafc0b443f342919478115e5698077d', 1, 'Huỳnh Thị Tuyết', '0368515882', '', '[]'),
(62, '0765331479', 'd505c9f311c6617280c7d46ea8f3750dd23bb496891d2265d1f49ad4ba3b3361', 1, 'Huỳnh Thanh Vân', '0765331479', '', '[]'),
(63, '0767528446', '9997a45791a31b580b8f1cfcdca9fc1e8184f6b7077dacff0d1675e2a3fc14f2', 1, 'Huỳnh Phi Công', '0767528446', '', '[]'),
(64, '0382406566', '6d8392ec3293f32f85bea085304680ec81669b73046f441c42b28bf1b92a1ab8', 1, 'Huỳnh Ngọc Thạch', '0382406566', '', '[]'),
(65, '0932935852', 'eda4f1ce13bd158e08f6407ade938d4311452d05cd7dd6333029a4bcc87e81fc', 1, 'Huỳnh Ngọc Phượng', '0932935852', '', '[]'),
(66, '0939856336', '04356828b4d48d3f6dcd2ebd3da1ddc4a72b4fe919b4b6727881dfdb9e614bc0', 1, 'Huỳnh Ngọc Có', '0939856336', '', '[]'),
(67, '01268219713', '1b1860935a5e7838df8dd2c75384f6b8e418eeb9389c0bd0482d17a259bf57df', 1, 'Huỳnh Hữu Chậm', '01268219713', '', '[]'),
(68, '0933743141', 'bdbf53248d5b5f3f2b639ee1fc91484cc55faa16079bacf1f28e289ed8163cde', 1, 'Nguyễn Minh Hiếu', '0933743141', '', '[]'),
(69, '0766818876', '7626cc7870abc0ddc67ab01ef3b36bbeb6cd993ecbbfeefbb62f7f03c2da65c9', 1, 'Nguyễn Hữu Đức', '0766818876', '', '[]'),
(70, '01263511122', 'f123618f990a4a5294b7eb58926d3b75a9ff132f73b66f69b3f1834099cef1de', 1, 'Nguyễn Hữu Út', '01263511122', '', '[]'),
(71, '0854504946', 'aeb515a5654344dd8b694107b752aab3301ac27a8e4ec8c0f5ee19ef6e243a17', 1, 'Nguyễn Hữu Tuấn', '0854504946', '', '[]'),
(72, '0778198768', '00f539902e8d1a6d34e4f1f798e5884ef45359910298203f28919752c7f3ad13', 1, 'Nguyễn Hữu Lực', '0778198768', '', '[]'),
(73, '01283698556', 'b777d3e54b7113009f11b54e33719b83585925669521c2d5d9c9024e55286e3c', 1, 'Nguyễn Hữu Hoảnh', '01283698556', '', '[]'),
(74, '0378895055', 'be03144b551eec94fd744bdafa08097396a3fd54257a2e65fd1f7e98003d010a', 1, 'Nguyễn Hùng Cường', '0378895055', '', '[]'),
(75, '0702595898', '4c4e075a159c094feded08c3e0a705c9cc1b2dc5295788313b4940173e89163e', 1, 'Nguyễn Hùng Anh', '0702595898', '', '[]'),
(76, '0949443062', '03efec109295918ab633df9c6f69ab8c918a0895abed8ce49d8e73728d7ac2be', 1, 'Nguyễn Hồng Vinh', '0949443062', '', '[]'),
(77, '0939497946', '840eb35d23325e9d2e7a76a3ac7535c4af26c6ddf34cf406cdb2ac159fa378a4', 1, 'Nguyễn Hồng Thạnh', '0939497946', '', '[]'),
(78, '0335477702', 'f25332fcdca50283df7b03b1f802a6a2e3bdfe6f2c6a7bd161a5dcbc1aeba1be', 1, 'Huỳnh Văn Rành', '0335477702', '', '[]'),
(79, '0363012179', '1aa1b3fd973beb0f201e243c0af64313605796af2d632c70d6046358b0a8ea32', 1, 'Huỳnh Văn Lợi', '0363012179', '', '[]'),
(80, '0964576334', '4d249fb8878e871cc695384c6f836f5161d65cf1ee3c03f9b8ea6fa25087b1df', 1, 'Nguyễn Hoài Thương', '0964576334', '', '[]'),
(81, '0989742449', '8af27fba30763f059bd580c4ecf790fecc105df0af8e94efe2284f1a6b8c2e87', 1, 'Nguyễn Công Tâm', '0989742449', '', '[]'),
(82, '0939217279', 'f63268da4700487ab2e40a1910bb08d3476ba7bda281dce4c011d0b5e00ddf46', 1, 'Nguyễn Cao Miên', '0939217279', '', '[]'),
(83, '012223699243', 'be3f1edf26379da02441ac710f95cf8025e602a9801c8db46c943c5f7f85ceab', 1, 'Ngô Văn Tua', '012223699243', '', '[]'),
(84, '0388902564', '1955279ddf8c2f200b92a3735f791cd1f303f3f782f6d66b03e65df708f090a8', 1, 'Huỳnh Văn Suôl', '0388902564', '', '[]'),
(85, '0939749441', '475db1d7f7c2b60419fa53a6f48c421a8b12021014323d9fa4bc4d1ca4657e1d', 1, 'Huỳnh Văn Sáu', '0939749441', '', '[]'),
(86, '0702158501', '2240a2dbbfc423c488c2f9c7c8c62d3573642d0130f39fdc93ef3faef3d8c738', 1, 'Ngô Văn Tám', '0702158501', '', '[]'),
(87, '0989990344', 'c729dda031af0caccbdaa53852b96fb092a08593144a8c3227e15c4b64263c74', 1, 'Ngô Văn Phước', '0989990344', '', '[]'),
(88, '02703759193', '97bdd128df338860b65999af48aa447ef060b4e8f729dfb028cc5adddb6b014a', 1, 'Ngô Ngọc Kết', '02703759193', '', '[]'),
(89, '01695004646', '40d5496ee09e45aaaeb0a509cbe85412d6ba77cc94ec7aa82829b66b19cdf82b', 1, 'Mai Thanh Long', '01695004646', '', '[]'),
(90, '0972892076', 'a9f9dfe49603825c593309796face4bec36c778cf3b97ef6d681f7e481771203', 1, 'Mai Thanh Liêm', '0972892076', '', '[]'),
(91, '01665744145', 'ad8e2a3ee0364b363d54ba9042d18e0de4ed229f09672bb764c648e86a481131', 1, 'Mạch Thanh Sang', '01665744145', '', '[]'),
(92, '0983585566', '692c1aeb5be4e252b79184e32dc16b8746a48e5baf975c4bef758cec79a4e656', 1, 'Huỳnh Văn Tửu', '0983585566', '', '[]'),
(93, '0704436542', '753a12781de0243dad73a867c9479c92f9169ec27bacb377ad44d8128f53e367', 1, 'Huỳnh Văn Tư', '0704436542', '', '[]'),
(94, '01665838320', '2542fbfe3f130ad195c37212d2f97111ba654fb98d91d0a69422a916899e0a67', 1, 'Khúc Kim Vùng', '01665838320', '', '[]'),
(95, '0796704239', '29352d124f7360f57a4ab7a13e23726baf8d2995fd87b8393ce0549c44013a6e', 1, 'Lê Chí Đức', '0796704239', '', '[]'),
(96, '01665258709', '9ed06762c2ec874e05b2fef1c21a944bba6c7712efff3159fb3df42dd7dea39e', 1, 'Lê Cẩm Nguyệt', '01665258709', '', '[]'),
(97, '0795290095', 'c9df79f512664e8beeb037b93dbe4697404a6497d8d871f4bada19bcfb1be3db', 1, 'Lê Huỳnh Quốc Duy', '0795290095', '', '[]'),
(98, '0942815071', '4ce5072378a6ba167e1847a28726a2d5d3f859ac407611e79d9851f0edc1bba5', 1, 'Lê Hoàng Phúc', '0942815071', '', '[]'),
(99, '0972658649', '151a405ebffcf391107d6199acdcef0f65c4c4d045ea16a01916d2cad7a3a37d', 1, 'Lê Quốc Tài', '0972658649', '', '[]'),
(100, '01228711322', 'd60cd89c363ef6b37d8f3cb544c7c8878a7af5ecee275d6565b36a9916c349e9', 1, 'Lê Phú Hiệp', '01228711322', '', '[]'),
(101, '0939037956', '06f5e118346221add1767f97f9c34532fa2e66f50cbaf34055eba05eee7f0198', 1, 'Lê Minh Quân', '0939037956', '', '[]'),
(102, '01694377106', '6d2fb14c0e7e056b10087f166d594a6c111f95264489de9c7f0362eae53d6ea5', 1, 'Lê Tấn Kiệt', '01694377106', '', '[]'),
(103, '02702217650', 'f03d58a425be1c733c7474abadb9488b85c387c3e9f7297ff9b34d2ff35623c4', 1, 'Lê Tấn Biết', '02702217650', '', '[]'),
(104, '0965563420', '4dee907824bf77bb2f1b9d171fb2fb592a3d2024b892a948036414d884921e6c', 1, 'Lê Thành Nguyên', '0965563420', '', '[]'),
(105, '01208757579', '0d6a26baeeb16e236547f69f13a7873afa4e62a57647e6041f2ee527242e1662', 1, 'Lê Tấn Kiệt', '01208757579', '', '[]'),
(106, '0902856455', '2ff28b4915bf61b4d44b198992e6800360c8bf36774055c44831a4cdebee04e9', 1, 'Lê Thanh Quang', '0902856455', '', '[]'),
(107, '0395454840', '78e2cb467195510afc0beb106adb1deaeaf8817c104839b7a1d77797e157bcc8', 1, 'Lê Thanh Nhã', '0395454840', '', '[]'),
(108, '0918405785', '96d3769a3af043709d70b8035a18fe443e3ef49d01f773baf0d39132aa9cbdc2', 1, 'Lê Tích Nhơn', '0918405785', '', '[]'),
(109, '0327291848', 'f1ce3084ea86d589c5ae9041dc3328a02c46ec4447a1c90eaecec13135c70745', 1, 'Lê Văn Chánh', '0327291848', '', '[]'),
(110, '0362808964', 'fcdf3f7de680bc75d630be3e8ce688dc15d6f74e2e1428c0dfbc5887c405c049', 1, 'Lê Văn Be', '0362808964', '', '[]'),
(111, '0799525372', '069a20563c3212aa6b6300acf8b19a4298e610e381fced51df0d94b1249a0aea', 1, 'Lê Văn Giữ', '', '', '[]'),
(112, '01656464322', 'a78809081c3fecd6a971436ac1b655f1a927224d3001d0832b2325f4eaed5539', 1, 'Huỳnh Văn Cò', '01656464322', '', '[]'),
(113, '0388271790', '44461f1d7e0c8888212d20867c5b75ec1ad1c776f62cf6648ae9191feba38c99', 1, 'Lê Văn Hiệp', '0388271790', '', '[]'),
(114, '0982068574', 'e959258c58ae6268208288c9f1264ba2f9147be245cbfc52793515eff91bb113', 1, 'Lê Văn Hết', '0982068574', '', '[]'),
(115, '0355912564', '47ff392c25e67075842d229fda90a3891faf1503b12ac1963b3f4e01263e7cf3', 1, 'Lê Văn Hoằng', '0355912564', '', '[]'),
(116, '0334958008', '5d24e2653f8b635e2d4b1fdae09e4f80b96abfea429dce4e67c7a0e73b5ab00b', 1, 'Lê Văn Hoàng', '0334958008', '', '[]'),
(117, '0333693260', '8978ee4a33c82a93e1cfe950621e7162ad7a7aaf21752f88ab5b59a3c894d40d', 1, 'Lê Văn Hương', '0333693260', '', '[]'),
(118, '0355243050', '1abc9de75db23bf04b6927d21e281d1fefa3f54b4c18c918c75b364a3ca5ac79', 1, 'Lê Văn Hòn', '0355243050', '', '[]'),
(119, '01234500223', '769dbdb4acc23bcd539ba913fd6c5f5a99cec61eeb1e28f8e99e67e22a0568da', 1, 'Lê Văn Kha', '01234500223', '', '[]'),
(120, '01663319008', '26cc158bafccf3a11dae92178e8cabf22f9e012fcf1d682a484f65c42dcbaf7b', 1, 'Lê Văn Hữu', '01663319008', '', '[]'),
(121, '0939896935', 'e709c2674cd71633fa442c03d4a63d748ce84e5ef90a238804a07a8367d1a986', 1, 'Lê Văn Minh', '0939896935', '', '[]'),
(122, '01253848889', '1f935695245db80d522ecbf34ce512fcc18849cc9568c4816b3c87eb76f96d46', 1, 'Lê Văn Lộc', '01253848889', '', '[]'),
(123, '0949489924', '3e6ad78d0b99aa965e9d6c0d0442f50f77c9d37661b52092d23972be9c37287e', 1, 'Lê Văn Năm', '0949489924', '', '[]'),
(124, '0946727657', 'b35c5b6f4482c86a724a31f335d10b54cc16a0972fa74c8837606413e0d99d7b', 1, 'Lê Văn Mười', '0946727657', '', '[]'),
(125, '0907990619', '82ff0b6f7eb77ed5540f86fabc3583b36536819a2cd44282c7d30e02dbd34144', 1, 'Lê Văn Nhựt', '0907990619', '', '[]'),
(126, '0919494072', 'c5950e445878f7797b977175146964757b573270936b25c2fa5852429e062d51', 1, 'Lê Văn Nhẹ', '0919494072', '', '[]'),
(127, '0985449283', '662610ebb3b0fa23cac43b9834e5997f8264dd0e17863b4a295d6d782d681d78', 1, 'Huỳnh Văn Thàng', '0985449283', '', '[]'),
(128, '0939793812', 'af2a4eaff42d783baab4460e9af71453fadacbad37f87278a914b9cff9f8343d', 1, 'Huỳnh Văn Thái', '0939793812', '', '[]'),
(129, '0388169666', '3a2265274806b3890d23d608cd8a2e357eb226478e8aeb05cd1adfaa67cc0b5d', 1, 'Lê Văn Sĩ', '0388169666', '', '[]'),
(130, '0939808375', 'f1a355d3fe596cf57ce33f516e8dd9909c4a98a97114e6564417eb903c9f2990', 1, 'Lê Văn Rùm', '0939808375', '', '[]'),
(131, '0335025352', '6a1f8f4ce9c9bcd69b451d17a2806d74d8cf174ddd6af3f9dd48a1f38524dba7', 1, 'Lê Văn Tám', '0335025352', '', '[]'),
(132, '0942679710', 'bcb57c5406c74527790394bafdc7c3b5a536a2328f28e3ed875ced7ac53d4f47', 1, 'Lê Văn Sơn', '0942679710', '', '[]'),
(133, '0988879386', 'bdc089c3bbe65528c8ac5b54c2305edb9be3e622f2c8076aa5d9c92a0244b2bd', 1, 'Lê Văn Tính', '0988879386', '', '[]'),
(134, '0984622500', 'd72935a011cadf8845e4eb74a4f54f8d826bf2c19b3ceb12848fd468f8aaa856', 1, 'Lê Văn Thổ', '0984622500', '', '[]'),
(135, '0943985227', 'cbec1b07309c096a019d47735a54cdb3aad485a4e448153f417ddc79b57983f4', 1, 'Lê Việt Ánh', '0943985227', '', '[]'),
(136, '0355278205', 'b488b221328eefff8daad0e3b0786cbb5fb0b49662272b537a37e9951492d7de', 1, 'Lê Văn Toàn', '0355278205', '', '[]'),
(137, '0939133165', '8f4861b9c04c508b705bfd23b3d1a2bacb79e7dcdf4c4a0d641b4a570a662fe7', 1, 'Lê Đức Hậu', '0939133165', '', '[]'),
(138, '01206574246', 'd6b02053280fd0ae05a267bdfb2f88a3c04dea975308cacc4020b1ba10f3954e', 1, 'Lê Việt Hải', '01206574246', '', '[]'),
(139, '01689705361', 'da246c19e1c67787a0119e1295b166685ccc338dc4c6b554d514c819419e8e7d', 1, 'Lương Văn Sáu', '01689705361', '', '[]'),
(140, '0917917346', '56ea424fc02fb916e3b119e6427bf61a938eee4a99947ba0921342db5c2179fc', 1, 'Lê Thị Kim Dung', '0917917346', '', '[]'),
(141, '01687179392', '2e24e3210f9d57bf805c8e08d02f457da0763b35af37ba6ae73995eb6ce36287', 1, 'Lê Thị Cẩm Thi', '01687179392', '', '[]'),
(142, '0704325719', '322cf41f17aa7c288b5a936f7d5b7a7290f5cbabc66519d0e8c6f78a5e868621', 1, 'Hồ Văn E', '0704325719', '', '[]'),
(143, '0967521576', 'e3fefc3d37d1fb0b0ad54f1fee9e34d60c128815f95c056f009bb673d9e65e6b', 1, 'Hồ Ngọc Văn', '0967521576', '', '[]'),
(144, '01667088253', 'ed1efa0c466e497198488c8999b37907ba6c5a58506102e26de1c78999b86330', 1, 'Hồ Minh Điện', '01667088253', '', '[]'),
(145, '0982193243', '0a9904e99e5cae0880ca546ccbec6de435213b902423bcd03014d4906e13b637', 1, 'Hồ Chí Cường', '0982193243', '', '[]'),
(146, '0988996584', 'a2441dde0807b6cf846383feaf3b8f2f64aec494011fc8c65b7e493e5cfd54e8', 1, 'Hà Văn Năm', '0988996584', '', '[]'),
(147, '0938547284', '1426206716f10a9d4018c3f585ab1fe3fdef100006eb08dea79699ba11fbbc82', 1, 'Dương Văn Út Chót', '0938547284', '', '[]'),
(148, '0783901765', 'acd29353df0dc7d527408353f8379fcdf164f2e9db09a0b41f3ea66bdd276e14', 1, 'Dương Tấn Lộc', '0783901765', '', '[]'),
(149, '0907073970', '412d56c590311515b849403345489dc09bbfe277e90fbec913190e877ba1a5f9', 1, 'Dương Nguyễn Minh Kha', '0907073970', '', '[]'),
(150, '0366021692', '69a8d6df358cb6891cd11101ae49cc3d1fb3bbea0625bc01d497dc9f543b6092', 1, 'Dương Nguyễn Anh Thuấn', '0366021692', '', '[]'),
(151, '0384777045', '404f6cc1599264a7b1bcb6b6981aea8740bc498cab4ddda52355a55cf4668c00', 1, 'Dương Khắc Hoàng', '0384777045', '', '[]'),
(152, '0901779635', '09221c7619896c1518951ddbb03467750f84f074119cd0268af83c34c4392765', 1, 'Dương Huỳnh Long', '0901779635', '', '[]'),
(153, '0388690161', '962fad23e32227b2aa338343e89cbe911f34ec903311c8493ac7de367104c284', 1, 'Dương Cánh Dân', '0388690161', '', '[]'),
(154, '01222102167', '058212c817fdf8a92f94728fdfa5b92d1e455ad9eaec32d0a171b9b2533074fe', 1, 'Chung Văn Tuyền', '01222102167', '', '[]'),
(155, '0342467633', '5cf31725f4c2233a96ddcd72dc9680bbed1e0173f1682dce248a77a5284a83fc', 1, 'Chú Sáu Hồng', '0342467633', '', '[]'),
(156, '01204956362', '87f4885ed1e142ea873306e1b96091cdf2ccf9b7b88696c6e535d979101fb3ba', 1, 'Chiêm Văn Giàu', '01204956362', '', '[]'),
(157, '01654471433', 'e9480225e9d1c2b9d8e6757f27ed6932a387e6270a65c70c14c7a16c7ecd382e', 1, 'Cao Văn Lên', '01654471433', '', '[]'),
(158, '0939512235', '83ccc8fbae7ab1ebcb035013db34ed49eee42b0b832b47dc23e3659409c3a08f', 1, 'Cao Văn Bảy', '0939512235', '', '[]'),
(159, '0378826619', 'c03696b7874b3151c348d41a0e300b66129484cc3432e66243d3451b66f1ffc0', 1, 'Cao Thanh Quới', '0378826619', '', '[]'),
(160, '0939802781', '95559f2ab5ceb8ad8408a263c2573f470e7881b644339bb21dbfa4c9aed6cad5', 1, 'Cao Hữu Minh', '0939802781', '', '[]'),
(161, '0985870067', 'e35dabadc4b0bccf2f3ea07354a0a4a7ded13b395c16832053adf7a66ee0e296', 1, 'Bùi Văn Kiếm', '0985870067', '', '[]'),
(162, '01683529179', 'f2c334a1bac03d59b8a285336633b9c56e19b84fc5ef001217eaa3b4366f0c4b', 1, 'Bùi Văn Hải', '01683529179', '', '[]'),
(163, '0772375480', '50f6041915b8fce289485e6b533f948b4846a496c9e386b293e1a702b7d4c09a', 1, 'Bùi Văn Giang', '0772375480', '', '[]'),
(164, '0567438327', 'a181aae570c70f9787cece37640eaaa09ce19d8d0abb4df63acdfb122d83b305', 1, 'Bùi Thanh Dự', '0567438327', '', '[]'),
(165, '0977358745', 'a32eade2e4931dbb103787f3239e1b082aa92ca11c8b7d208358426b87fd9b67', 1, 'Bùi Công Tùng', '0977358745', '', '[]'),
(166, '0977358693', '54f2eaeb79a56b81349ad2c76fcf90e146c968a4c4278a7f7e7a968cadefae83', 1, 'Bùi Công Danh', '0977358693', '', '[]'),
(167, '0916734908', '601cfbaf46d189a624cd02c12928dc30427e623e167cf3f76f7d6e871bcffaf7', 1, 'Biện Như Thùy', '0916734908', '', '[]'),
(168, '0916804648', '5f0340681463cba8b28119e17c43e9c7dba6c8b92366b2ccbe8acb8a93942beb', 1, 'Bành Ngọc Nghĩa', '0916804648', '', '[]'),
(169, '01203142164', '4d71e3eaafd4ff536b656b3f0579f88ecc249c5d560b08bf0b6a5bbc4734792c', 1, 'Bạch Văn Thắng', '01203142164', '', '[]'),
(170, '01689793799', '601e58bbc9c79db3a72052d9890c9959b41ee95c758f879f26750e8d93568afa', 1, 'Nguyễn Văn Trà', '01689793799', '', '[]'),
(171, '01698234404', '24e85951f6273499353a60908a7519fe340f5b936a59a2752f73280845b95d1a', 1, 'Nguyễn Văn Toàn', '01698234404', '', '[]'),
(172, '0939502734', '3878f4a0bbb2c69024718ebb72602247fe9dc851f5d75e336ee77297030ea220', 1, 'Nguyễn Văn Tú', '0939502734', '', '[]'),
(173, '0363466917', 'cc5a5ff0429e4d161e149647e1997848fa47f269d441190f81aebb03c85e2936', 1, 'Nguyễn Văn Trạng', '0363466917', '', '[]'),
(174, '01672299406', 'ee68f46a07d11f9845fe94a39fde3a6fe96158fab8f1be060c0ef1c149991959', 1, 'Đặng Hoàng Minh', '01672299406', '', '[]'),
(175, '0383120029', '1b368c014dd22d23ca73820f3fb2799a2ca106a9a8e31752de7e76489f530d16', 1, 'Võ Văn Vũ', '0383120029', '', '[]'),
(176, '0795887590', '2996ff287309a4aec241bc2423f8fc0b2f783c3ac903045820605dfb19387afa', 1, 'Võ Thanh Trang', '0795887590', '', '[]'),
(177, '0765099983', '0fb54965e8a635184cf580e3adcdd104b0592df7ce8e6d930f40a4c8ecb19f1b', 1, 'Võ Ngọc Thạch', '0765099983', '', '[]'),
(178, '0358829998', '3d536f834062922a7a2bea99484a61c452e4a98cbce9c9426067d37322b446cf', 1, 'Trần Văn Pháp', '0358829998', '', '[]'),
(179, '0389905416', 'ce3a7c8c6b976e88da2daf4d71ccbb9b93027112977a3c16d6f3ddf6eec019f7', 1, 'Trần Văn Nhóc', '0389905416', '', '[]'),
(180, '01225435074', 'c0532b843708ae9fda60215169ec287685303613f13587980f8599796d1997e7', 1, 'Trần Văn Lành', '01225435074', '', '[]'),
(181, '0778881433', '310145bf337b46dc82252a36cd725779718223e05d20fdb0f62ea033e60bb2e2', 1, 'Trần Văn Lần', '0778881433', '', '[]'),
(182, '01664222458', '3bbea00cc9e74bc00a8a56a9d183b66ba006922479e36a18129e6de84442d9a5', 1, 'Nguyễn Văn Tùng', '01664222458', '', '[]'),
(184, '01663492287', '0d04058727e2e1ac61c6d6d11100f90da6952f99fb9b0f3df9094ba282b7a6eb', 1, 'Nguyễn Văn Đời', '01663492287', '', '[]'),
(185, '01699734243', 'cb5ada66a4d0724f6ab998102d0bf21d5d93f2a71db92765282da25a81978db9', 1, 'Nguyễn Văn Đang', '01699734243', '', '[]'),
(186, '01683074789', 'a4a056424d3db133123c67e06bc728def281f6f8356e21bd4918ac35088ffe92', 1, 'Nguyễn Văn Được', '01683074789', '', '[]'),
(187, '0939901195', '20eadfbc6e73f348e8568995629849d9781c7f009507044e24a2a0d575d9137c', 1, 'Nguyễn Văn Đức', '0939901195', '', '[]'),
(188, '0328545554', '91a68db1c4704cfcdc03bb1186c1b9ed791902951b9563e762f41dd174f8b89e', 1, 'Phạm Cao Sơn', '0328545554', '', '[]'),
(189, '0366914337', 'd7433383ab785b6c4b96d2a488d2339d4cb7e57f48ad32b1505bda6ae9db12d9', 1, 'Phạm Thanh Chánh', '0366914337', '', '[]'),
(190, '01678283811', 'b5f72cc3f7a3c4e165d548175cd8edc72baec912ba588f07c50885c83641feec', 1, 'Phạm Hoàng Giang', '01678283811', '', '[]'),
(191, '01649949594', '7588be63cd7c86eebd5471f8c6319fe18919e10dccd5efa06ddbf2e4aa237267', 1, 'Phạm Văn Hùng', '01649949594', '', '[]'),
(192, '01289514517', 'f5c088b42996921557174700e9d1ef9e866db94e187ce1f2547e5aac0507a744', 1, 'Phạm Văn Bé Ba', '01289514517', '', '[]'),
(193, '0786405943', '25a6373ed9005b073c598e438b8029508d62ae15b11e611892d953caa83f8fae', 1, 'Phạm Văn Quốc', '0786405943', '', '[]'),
(194, '0988089695', '593c855e3c07700998815a619806fb8d5c1a30af352e57f707a7c25c6e81b12b', 1, 'Phạm Văn Phước', '0988089695', '', '[]'),
(195, '0354488930', 'cee141795b6bdfc4b236329312a39a1451671ec544b3e5e7b41c30eb028d11df', 1, 'Phạm Văn Út', '0354488930', '', '[]'),
(196, '01283968848', '81ed76273b05cead5f52d234156bb150ae895cd5d686218b56cc6997f29310c0', 1, 'Phạm Văn Tâm', '01283968848', '', '[]'),
(197, '0983391279', '6d8fd3309dc94d32ff6a90ff9813cf5ddb11f08ed3202c98a4c7beeb1906a732', 1, 'Phan Thanh Long', '0983391279', '', '[]'),
(198, '0919018590', 'bbe946004680e09acf7ff500ec29157a12ab9f94c02309bb769c9c9fd5f317fe', 1, 'Phan Bùi Thị Hữu Thúy', '0919018590', '', '[]'),
(199, '0395851433', 'ff014c5029b275f3785a1f6cfc775eb5d344f000c777db035f47b8dd20cdfd54', 1, 'Phan Thành Tâm', '0395851433', '', '[]'),
(200, '01202955564', 'ae03ccea74f810f50a97af374b0e54d31187840b695746a819e032d6a7475d34', 1, 'Phan Thanh Nhã', '01202955564', '', '[]'),
(201, '0939715879', '102f755bb5531af297d315eba258b7858cbc5c0d20088f6c4ab310330420f888', 1, 'Phan Văn Mến', '0939715879', '', '[]'),
(202, '0933661480', '8b29148c66466b3d93a9fab4cf4de88c75678a174f4a5ef63677154388f254a8', 1, 'Phan Toàn Định', '0933661480', '', '[]'),
(203, '01682428870', 'b5b3cbcc76f45a2a463f776c012bee06f7e34dc6b147fdbb5aa9b466181d7baf', 1, 'Trần Ngọc Hấn', '01682428870', '', '[]'),
(204, '0988255938', '04efb47f74d6314cb4fe6d03649b5ffa9f451a15dcd7a21872eaedf1ad5cca19', 1, 'Tô Huỳnh Như', '0988255938', '', '[]'),
(205, '0909571260', '21e3a84d771e532d8d3c391d1a353fdd42b6ac82ec5afcd17945065014ec9913', 1, 'Trần Hoàng Vui', '0909571260', '', '[]'),
(206, '0984601140', 'f0402f10e49c2c569184db7aa3567646d06c17255b4942bb2f865d47061ce03d', 1, 'Trần Hoàng Em', '0984601140', '', '[]'),
(207, '0385940920', '6ce1631b174bb6612502d815865ed9ce166902111120fa4504082e2ce78ae579', 1, 'Trần Minh Luân', '0385940920', '', '[]'),
(208, '0333524653', '67fb026283a5d8216fe090f20b3a457a4da3771ad721f90ab16d6eadf57a42f4', 1, 'Trần Minh Chánh', '0333524653', '', '[]'),
(209, '0395190618', '50acef65ab223381eec8b5e0127d03619fb250e2cad26d4f197ca969baed8511', 1, 'Trần Ngọc Hên', '0395190618', '', '[]'),
(210, '0932977783', '4ee5da7f2e240eca4cd8e922a3b98274ca46791faa920e0b477c72126985e0c6', 1, 'Trần Minh Nguyên', '0932977783', '', '[]'),
(211, '01652706054', 'a87cafa56b3295f53f73137b35511e0592c9059397c70cf3931280396e75ea00', 1, 'Trần Quang Thủ', '01652706054', '', '[]'),
(212, '0939233536', 'ee8a9c60dee5944a849a8759ec16f41a3baee29ef3ef96c84a76a840eec89645', 1, 'Trần Như Phước', '0939233536', '', '[]'),
(213, '0983958970', '4360fb8352cd4e59258d37290666bddb05d3474e79aaad151013fe3fe22a3922', 1, 'Trần Thanh Tuấn', '0983958970', '', '[]'),
(214, '0767040549', '8aa959e3237eda96b64c35d1fac0a83cc9f9901a3028699c51b6a66d8621c0cc', 1, 'Trần Tấn Khanh', '0767040549', '', '[]'),
(215, '0939419975', '9b9c3c2a61e92eb83982233818b196863ca515a0a7d84635cc07b563fa1b55a6', 1, 'Trần Thanh Vũ', '0939419975', '', '[]'),
(216, '0783936930', '8f086c8f57aecfb1bd8f04624e5bf4c8d771d452bf4e23f4d774743340943649', 1, 'Trần Thanh Vĩnh', '0783936930', '', '[]'),
(217, '0989222709', '7afc4d2f71b9aced82b35412311b5694f0399e4ce45e722a6839d270972d1a05', 1, 'Trần Thị Hồng Thơi', '0989222709', '', '[]'),
(218, '0385668017', '7c5acfd249847889cce2ce623a8d48b60f4299b052a1e3117d9f9152e71beeda', 1, 'Trần Thị Hằng', '0385668017', '', '[]'),
(219, '0912561727', 'fedff527ff643073557f732519e972d8ef412919d7ab212fe552480dbeea70cf', 1, 'Trần Thị Phi Thuyền', '0912561727', '', '[]'),
(220, '0904457586', '858ebfce781f28915509b32a841238a82d07d3e5332fbe2110e9e5ee6db1da2b', 1, 'Trần Thị Kim Ánh', '0904457586', '', '[]'),
(221, '0366180166', '173cf377d89c980eaa1878d5804ccef1a8b338f1df4d77c83294727e872f6110', 1, 'Trần Văn Bé Ba', '0366180166', '', '[]'),
(222, '01222116790', '9d2bb85ffb5ff795acfa537d533acb31e74a5671291f2b5281f6e973304bacb5', 1, 'Trần Trọng Nghĩa', '01222116790', '', '[]'),
(223, '0977278747', '7ab0731c5a55cfb72275e628e82f4d255d459cbbedfa4ee300316a2789c9cf71', 1, 'Trần Văn Cà Tha', '0977278747', '', '[]'),
(224, '0385642559', '4d83ea5784bf0a31db145ff9d10fc481551ef7534f75a1381f4d026835d0be87', 1, 'Trần Văn Bờ Em', '0385642559', '', '[]'),
(225, '0913673943', '2f40bdbe85d9a013728896904ad4e80d3cd9cbd03d3ef94e72e8fbc1f78fa8ab', 1, 'Trần Văn Dinh', '0913673943', '', '[]'),
(226, '01266889684', 'dd9e933b64411b81194aaa194e58cf033252d45cd92e1d8bb6fd2182f4128bb0', 1, 'Trần Văn Căi', '01266889684', '', '[]'),
(227, '0822521828', '7ca0c9eafbe2bcce06b9d50277dda6cf8d8007a8abd147f0db5a895f8ed59e59', 1, 'Trần Văn Dũng', '0822521828', '', '[]'),
(228, '0979459941', 'c9eb12142d98a84354feea8f622385431e8f232331d57612ec1cc2bac95852ce', 1, 'Trần Văn Dũng', '0979459941', '', '[]'),
(229, '01214324765', '125907ea1f6bbdb1026299d74b9e2e51c94c0a3b359caa4bfd76c263539d3398', 1, 'Trần Văn Hoài', '01214324765', '', '[]'),
(230, '01675280203', '3abaeeb21b7c5bab09cd4190469b4b11eb4a20d58515ee716b788b53a1da5310', 1, 'Trần Văn Hiền', '01675280203', '', '[]'),
(231, '0984265480', '9fe48d63c3970e254850f9316a1e3663939fc0833f828d2e9318ab3be0b922fb', 1, 'Trần Văn Khởi', '0984265480', '', '[]'),
(232, '0922341021', '60ee756c863364ae45bc158f939d013167bf7b0aea266208ed97a0d26f7d8a76', 1, 'Trần Văn Hoàng', '0922341021', '', '[]'),
(239, 'chudoi', '6d31b452b653e0992431aa74be5bd31500ef1c61eee2fb2a43a486c0103ea27d', 1, 'Nguyễn Văn Đội', '', '', '[]'),
(242, '0762932552', 'e53b648bf91869fa18b2270ca917dc78a10bc660c230a63366323a66883eb99b', 1, 'Ngô Minh Thảo', '0762932552', '', '[]'),
(243, '0767040541', '784ad91e057d473a6d17b5895a88f294c972867eba07aeef84ca4bd68a63d1a6', 1, 'Trần Tuấn Khanh', '0767040541', '', '[]'),
(244, '0776890967', 'd14d6d74282d93e6b27bb6e6e6466fd2380ffda87d42f5857270af1353b24c12', 1, 'Lê Anh Huy', '0776890967', '', '[]'),
(245, '0907972554', '94ffbbb94724d5839bd10be5a2ebceaad0f67db0e6b014ba21da92d1d0c0acef', 1, 'Dương Thành Công', '0907972554', '', '[]'),
(246, '0377772030', 'cbc4284b6c3a0e549458e480957a75ac449ec25d7816cf86353eb9f191a7b9a7', 1, 'Nguyễn Văn Cầu', '0377772030', '', '[]'),
(247, 'nguyenvantan', 'b7e740ede42508db84124c4d9f125f7300f51abec57963c03fd3dc55150933f0', 1, 'Nguyễn Văn Tấn', '', '', '[]'),
(248, 'vovanba', '92aef1d401afa9066a35f9e3f62f06837f53c6597fcba97e5da46dc64dd93c6f', 1, 'Võ Văn Ba', '', '', '[]'),
(249, '0913754433', '2eb59991b4f9430dea708f529b7b5fd23b5be2ef577b02ba55dd1506c2cde80f', 1, 'Nguyễn Văn Tuấn', '0913754433', '', '[]'),
(252, 'nguyenminh', '5653e996479032ccdada3ed444f2788aa48c64d3ca8f40d330dce4f73aa77c97', 4, 'nguyễn minh', '0906359986', 'nguyenminh30091987@gmail.com', ''),
(253, 'Danny', '19a6583bb02e7e83001689dabd357555b4473fba9f624601b94a3d9de96c48f6', 4, 'Võ Minh Đức', '0941916060', 'vominhduc@vinatt.com', ''),
(260, 'nhavanchuyen', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 5, 'CÔNG TY TNHH TM DV XNK VINA T&T', '+84 949 80 9000', 'tommy.vinatt@gmail.com', '[]'),
(262, 'nhapp', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 3, 'CÔNG TY TNHH TM DV XNK VINA T&T', '+84 28 3844 8277', 'tommy.vinatt@gmail.com', '[]'),
(263, 'nhasc', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 2, 'CÔNG TY TNHH TM DV XNK VINA T&T', '+84 949 80 9000', 'tommy.vinatt@gmail.com', '[]'),
(265, '0367651586', 'e55914fcdbeb576696cf26e0eb1749b972cdc3dd86d71b38d6161e42ad3f9dae', 1, 'Nguyễn Văn Liểm', '0367651586', '', '[]'),
(266, '01637126097', '6c88c11eb8620c217650cb2aca9353a29089d8941a93262411493442fc995096', 1, 'Lê Văn Diễn', '01637126097', '', '[]'),
(267, '0165898726', '8d2da95c6c4de3c0c8be4e8d910ac42fc060fb0e188597d3c26ed0a08dc3bbb3', 1, 'Lê Minh Khang', '0165898726', '', '[]'),
(268, '01699313383', '81aa2a9cce9ae3bdd9c99c1301a9c54cfaf33edd3d64fdc38dd0171ac8d2af7c', 1, 'Lê Thanh Vũ', '01699313383', '', '[]'),
(269, '01659429602', '82691f5604a29de69c962e632b0fd64d3578216dc5dada93697628c88693c497', 1, 'Lê Minh Pha', '01659429602', '', '[]'),
(270, '0978398958', '4614650cb6e083bea158e1e026626d0c618a4838b571b74746f3028907c0279c', 1, 'Nguyễn Văn Kiệt', '0978398958', '', '[]'),
(271, '0906359986', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 0, 'Minh', '4242342342', '4234', '[]');

-- --------------------------------------------------------

--
-- Table structure for table `videoactivity`
--

CREATE TABLE IF NOT EXISTS `videoactivity` (
  `idvi` int(11) NOT NULL AUTO_INCREMENT,
  `urlvideo` text NOT NULL,
  `name_vilq` varchar(300) NOT NULL,
  `name_enlq` varchar(300) NOT NULL,
  `idac` int(11) NOT NULL,
  `createdatevi` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `idusertao` bigint(20) NOT NULL,
  `visible` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`idvi`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=14 ;

--
-- Dumping data for table `videoactivity`
--

INSERT INTO `videoactivity` (`idvi`, `urlvideo`, `name_vilq`, `name_enlq`, `idac`, `createdatevi`, `idusertao`, `visible`) VALUES
(1, 'https://www.youtube.com/embed/A5OaPcGmE1o', 'A', 'A', 1, '2019-04-23 12:00:26', 1, 0),
(2, 'https://www.youtube-nocookie.com/embed/DvAANeMHpfQ', '', '', 1, '2019-03-26 11:13:45', 1, 1),
(4, 'https://www.youtube-nocookie.com/embed/uPK1U8IBTwM', '', '', 1, '2019-03-11 12:18:59', 0, 1),
(13, 'https://www.youtube-nocookie.com/embed/DvAANeMHpfQ', 'abc', 'bac', 7, '2019-03-26 18:54:41', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `workfarmer`
--

CREATE TABLE IF NOT EXISTS `workfarmer` (
  `idw` bigint(20) NOT NULL AUTO_INCREMENT,
  `namew` varchar(500) NOT NULL,
  `visible` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`idw`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=137 ;

--
-- Dumping data for table `workfarmer`
--

INSERT INTO `workfarmer` (`idw`, `namew`, `visible`) VALUES
(1, 'Ảnh Nông Dân- Hộ sản xuất', 1),
(2, 'Ảnh Lô Vùng Trồng', 1),
(3, 'Ảnh vùng trồng', 1),
(4, 'Nhật ký chăm sóc', 1),
(5, 'Nhà cung cấp phân bón', 1),
(6, 'Nhà cung cấp thuốc BVTV', 1),
(7, 'Nhật ký sử dụng phân bón', 1),
(8, 'Nhật ký sử dụng Thuốc BVTV', 1),
(9, 'Nhật ký thu hoạch', 1),
(10, 'Nhật ký sau thu hoạch', 1),
(11, 'GCN VIETGAP-GlobalGAP-Khác', 1),
(12, 'Giấy chứng nhận mẫu nước', 1),
(13, 'Giấy chứng nhận mẫu đất', 1),
(14, 'Giấy chứng nhận mẫu thực vật', 1);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
