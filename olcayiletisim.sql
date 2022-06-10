-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1:3306
-- Üretim Zamanı: 10 Haz 2022, 17:26:24
-- Sunucu sürümü: 8.0.27
-- PHP Sürümü: 7.4.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `olcayiletisim`
--

DELIMITER $$
--
-- Yordamlar
--
DROP PROCEDURE IF EXISTS `OlcayIletisim_MusteriBakiye`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_MusteriBakiye` (`id` VARCHAR(64))  BEGIN
    declare borc  float;
    declare odeme float;
    
    SELECT  SUM(satis_fiyat) into borc  
    FROM    OlcayIletisim_satislar 
    WHERE   musteri_id = id;
    
    SELECT  SUM(odeme_tutar) into odeme  
    FROM    OlcayIletisim_odemeler 
    WHERE   musteri_id = id;
    
    SELECT odeme - borc;
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_MusteriBul`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_MusteriBul` (`filtre` VARCHAR(32))  BEGIN
    SELECT * FROM OlcayIletisim_musteriler
    WHERE 
        musteri_id      LIKE  CONCAT('%',filtre,'%') OR
        musteri_ad      LIKE  CONCAT('%',filtre,'%') OR
        musteri_soyad   LIKE  CONCAT('%',filtre,'%') OR
        musteri_tel     LIKE  CONCAT('%',filtre,'%') OR
        musteri_mail    LIKE  CONCAT('%',filtre,'%') OR
        musteri_adres   LIKE  CONCAT('%',filtre,'%');
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_MusteriEkle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_MusteriEkle` (`id` VARCHAR(64), `ad` VARCHAR(64), `soy` VARCHAR(64), `tel` VARCHAR(25), `mail` VARCHAR(250), `adr` VARCHAR(250))  BEGIN
    INSERT INTO OlcayIletisim_musteriler
    VALUES  (id, ad, soy, tel, mail, adr);
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_MusteriGuncelle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_MusteriGuncelle` (`id` VARCHAR(64), `ad` VARCHAR(64), `soy` VARCHAR(64), `tel` VARCHAR(25), `mail` VARCHAR(250), `adr` VARCHAR(250))  BEGIN
    UPDATE OlcayIletisim_musteriler
    SET 
        musteri_ad      = ad,
        musteri_soyad   = soy,
        musteri_tel     = tel,
        musteri_mail    = mail,
        musteri_adres   = adr
    WHERE 
        musteri_id      = id;
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_MusterilerHepsi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_MusterilerHepsi` ()  BEGIN
    SELECT 
        musteri_id      as ID,
        musteri_ad      as Adı,
        musteri_soyad   as Soyadı,
        musteri_tel     as Telefon, 
        musteri_mail    as Mail,
        musteri_adres   as Adres
    FROM OlcayIletisim_musteriler;
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_MusteriSatislar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_MusteriSatislar` (`id` VARCHAR(64))  BEGIN
    SELECT * FROM OlcayIletisim_satislar
    WHERE musteri_id = id;
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_MusteriSil`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_MusteriSil` (`id` VARCHAR(64))  BEGIN
    DELETE FROM OlcayIletisim_musteriler
    WHERE   musteri_id  = id;
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_OdemeDetay`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_OdemeDetay` ()  BEGIN
SELECT   
        o.odeme_id,
        m.musteri_id,
        CONCAT(musteri_ad,' ', musteri_soyad ) as `Müşteri Ad Soyad`,
        o.odeme_tarih as `Ödeme Tarihi`,
        o.odeme_tutar as `Ödeme Tutarı`,
        o.odeme_tur as `Ödeme Türü`,
        o.odeme_aciklama as `Açıklama`
        
FROM    OlcayIletisim_musteriler m inner join  OlcayIletisim_odemeler o 
    on m.musteri_id = o.musteri_id;
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_OdemeEkle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_OdemeEkle` (`oid` VARCHAR(64), `mid` VARCHAR(64), `tarih` DATETIME, `tutar` FLOAT, `tur` VARCHAR(25), `aciklama` VARCHAR(250))  BEGIN
    INSERT INTO OlcayIletisim_odemeler
    VALUES  (oid, mid, tarih, tutar, tur, aciklama);
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_OdemeGuncelle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_OdemeGuncelle` (`oid` VARCHAR(64), `mid` VARCHAR(64), `tarih` DATETIME, `tutar` FLOAT, `tur` VARCHAR(25), `aciklama` VARCHAR(250))  BEGIN
    UPDATE OlcayIletisim_odemeler
    SET
        musteri_id      = mid,
        odeme_tarih     = tarih,
        odeme_tutar     = tutar,
        odeme_tur       = tur,
        odeme_aciklama  = aciklama
    WHERE 
        odeme_id = oid; 
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_OdemelerToplam`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_OdemelerToplam` ()  BEGIN
    SELECT  SUM(odeme_tutar)  
    FROM    OlcayIletisim_odemeler ;
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_OdemeSil`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_OdemeSil` (`oid` VARCHAR(64))  BEGIN
    DELETE FROM OlcayIletisim_odemeler
    WHERE odeme_id = oid;
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_SatisDetay`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_SatisDetay` ()  BEGIN
SELECT   
        s.satis_id,
        m.musteri_id,
        u.urun_id,
        CONCAT(musteri_ad,' ', musteri_soyad ) as `Müşteri Ad Soyad`,
        urun_ad as `Ürün`,
        urun_kategori as `Kategori`,
        urun_fiyat as `Birim Fiyat`,
        satis_fiyat as `Satış Fiyatı`,
        satis_tarih as `Satış Tarihi`
FROM    OlcayIletisim_musteriler m inner join  OlcayIletisim_satislar s 
    on m.musteri_id = s.musteri_id 
        inner join OlcayIletisim_urunler u on s.urun_id = u.urun_id;
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_SatisEkle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_SatisEkle` (`sid` VARCHAR(64), `mid` VARCHAR(64), `uid` VARCHAR(64), `tarih` DATETIME, `fiyat` FLOAT)  BEGIN
    INSERT INTO OlcayIletisim_satislar
    VALUES  (sid, mid, uid, tarih, fiyat);
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_SatisGuncelle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_SatisGuncelle` (`sid` VARCHAR(64), `mid` VARCHAR(64), `uid` VARCHAR(64), `tarih` DATETIME, `fiyat` FLOAT)  BEGIN
    UPDATE OlcayIletisim_satislar
    SET 
        musteri_id    = mid,
        urun_id       = uid,
        satis_tarih   = tarih,
        satis_fiyat   = fiyat
    WHERE 
        satis_id      = sid;
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_SatislarToplam`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_SatislarToplam` ()  BEGIN
    SELECT  SUM(satis_fiyat)  
    FROM    OlcayIletisim_satislar ;
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_SatisSil`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_SatisSil` (`id` VARCHAR(64))  BEGIN
    DELETE FROM OlcayIletisim_satislar
    WHERE satis_id  = id;
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_UrunBul`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_UrunBul` (`filtre` VARCHAR(32))  BEGIN
    SELECT * FROM OlcayIletisim_urunler
    WHERE 
        urun_id       LIKE  CONCAT('%',filtre,'%') OR
        urun_ad       LIKE  CONCAT('%',filtre,'%') OR
        urun_kategori LIKE  CONCAT('%',filtre,'%') OR
        urun_fiyat    LIKE  CONCAT('%',filtre,'%') OR
        urun_stok     LIKE  CONCAT('%',filtre,'%') OR
        urun_birim    LIKE  CONCAT('%',filtre,'%') OR
        urun_detay    LIKE  CONCAT('%',filtre,'%') ;
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_UrunEkle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_UrunEkle` (`id` VARCHAR(64), `ad` VARCHAR(250), `kategori` VARCHAR(250), `fiyat` FLOAT, `stok` FLOAT, `birim` VARCHAR(16), `detay` VARCHAR(250))  BEGIN
    INSERT INTO OlcayIletisim_urunler
    VALUES  (id, ad, kategori, fiyat, stok, birim, detay);
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_UrunGuncelle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_UrunGuncelle` (`id` VARCHAR(64), `ad` VARCHAR(250), `kategori` VARCHAR(250), `fiyat` FLOAT, `stok` FLOAT, `birim` VARCHAR(16), `detay` VARCHAR(250))  BEGIN
    UPDATE OlcayIletisim_urunler
    SET 
        urun_ad       = ad,
        urun_kategori = kategori,
        urun_fiyat    = fiyat,
        urun_stok     = stok,
        urun_birim    = birim,
        urun_detay    = detay
    WHERE 
        urun_id       = id;
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_UrunlerHepsi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_UrunlerHepsi` ()  BEGIN
    SELECT * FROM OlcayIletisim_urunler;
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_UrunSatislar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_UrunSatislar` (`id` VARCHAR(64))  BEGIN
    SELECT * FROM OlcayIletisim_satislar
    WHERE urun_id = id;
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_UrunSil`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_UrunSil` (`id` VARCHAR(64))  BEGIN
    DELETE FROM OlcayIletisim_urunler
    WHERE urun_id  = id;
END$$

DROP PROCEDURE IF EXISTS `OlcayIletisim_UrunStokGuncelle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OlcayIletisim_UrunStokGuncelle` (`id` VARCHAR(64), `stok` FLOAT)  BEGIN
    UPDATE OlcayIletisim_urunler
    SET 
        urun_stok     = stok
    WHERE 
        urun_id       = id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `olcayiletisim_musteriler`
--

DROP TABLE IF EXISTS `olcayiletisim_musteriler`;
CREATE TABLE IF NOT EXISTS `olcayiletisim_musteriler` (
  `musteri_id` varchar(64) NOT NULL,
  `musteri_ad` varchar(64) NOT NULL,
  `musteri_soyad` varchar(64) NOT NULL,
  `musteri_tel` varchar(25) NOT NULL,
  `musteri_mail` varchar(250) NOT NULL,
  `musteri_adres` varchar(250) NOT NULL,
  PRIMARY KEY (`musteri_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `olcayiletisim_musteriler`
--

INSERT INTO `olcayiletisim_musteriler` (`musteri_id`, `musteri_ad`, `musteri_soyad`, `musteri_tel`, `musteri_mail`, `musteri_adres`) VALUES
('eae7dd3f-0800-4237-9241-ade5f98c9549', 'Olcay', 'Özdemir', '0(555) 555-5555', 'olcay@gmail.com', 'istanbul');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `olcayiletisim_odemeler`
--

DROP TABLE IF EXISTS `olcayiletisim_odemeler`;
CREATE TABLE IF NOT EXISTS `olcayiletisim_odemeler` (
  `odeme_id` varchar(64) NOT NULL,
  `musteri_id` varchar(64) NOT NULL,
  `odeme_tarih` datetime NOT NULL,
  `odeme_tutar` float NOT NULL,
  `odeme_tur` varchar(25) NOT NULL,
  `odeme_aciklama` varchar(250) NOT NULL,
  PRIMARY KEY (`odeme_id`),
  KEY `musteri_id` (`musteri_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `olcayiletisim_odemeler`
--

INSERT INTO `olcayiletisim_odemeler` (`odeme_id`, `musteri_id`, `odeme_tarih`, `odeme_tutar`, `odeme_tur`, `odeme_aciklama`) VALUES
('fa8a51eb-60da-4abc-90ef-f624499596a8', 'eae7dd3f-0800-4237-9241-ade5f98c9549', '2022-06-10 19:21:16', 1000, 'Nakit', 'Tel borcu');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `olcayiletisim_satislar`
--

DROP TABLE IF EXISTS `olcayiletisim_satislar`;
CREATE TABLE IF NOT EXISTS `olcayiletisim_satislar` (
  `satis_id` varchar(64) NOT NULL,
  `musteri_id` varchar(64) NOT NULL,
  `urun_id` varchar(64) NOT NULL,
  `satis_tarih` datetime NOT NULL,
  `satis_fiyat` float NOT NULL,
  PRIMARY KEY (`satis_id`),
  KEY `musteri_id` (`musteri_id`),
  KEY `urun_id` (`urun_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `olcayiletisim_satislar`
--

INSERT INTO `olcayiletisim_satislar` (`satis_id`, `musteri_id`, `urun_id`, `satis_tarih`, `satis_fiyat`) VALUES
('f754f89a-1582-4cdc-81a0-5e15b0bde9fd', 'eae7dd3f-0800-4237-9241-ade5f98c9549', '128d20cc-7fdd-46d2-a3c2-2eebe533cb7a', '2022-06-10 19:21:03', 2322);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `olcayiletisim_urunler`
--

DROP TABLE IF EXISTS `olcayiletisim_urunler`;
CREATE TABLE IF NOT EXISTS `olcayiletisim_urunler` (
  `urun_id` varchar(64) NOT NULL,
  `urun_ad` varchar(250) NOT NULL,
  `urun_kategori` varchar(250) NOT NULL,
  `urun_fiyat` float NOT NULL,
  `urun_stok` float NOT NULL,
  `urun_birim` varchar(16) NOT NULL,
  `urun_detay` varchar(250) NOT NULL,
  PRIMARY KEY (`urun_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `olcayiletisim_urunler`
--

INSERT INTO `olcayiletisim_urunler` (`urun_id`, `urun_ad`, `urun_kategori`, `urun_fiyat`, `urun_stok`, `urun_birim`, `urun_detay`) VALUES
('128d20cc-7fdd-46d2-a3c2-2eebe533cb7a', 'Xiaomi mi 11 lite', 'Telefon', 5000, 1000, 'Adet', 'Ekran Boyutu:6.55 İnç\r\nDahili Depolama:128 GB\r\nBellek (RAM):6 GB\r\nBatarya Kapasitesi:4250 mAh\r\nHat Sayısı:Çift Hat\r\nHızlı Şarj:Var\r\n4.5G Desteği:Var');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
