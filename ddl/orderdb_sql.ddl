CREATE DATABASE orders;
go;

USE orders;
go;


CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE genre (
    genreId          INT IDENTITY,
    genreName        VARCHAR(50),    
    PRIMARY KEY (genreId)
);

CREATE TABLE album (
    albumId			INT IDENTITY,
    albumName		VARCHAR(40),
    albumPrice		DECIMAL(10,2),
    albumImageURL	VARCHAR(100),
    albumDesc		VARCHAR(1000),
    albumArtist		VARCHAR(100),
    albumYear		INT,
    genreId			INT,
    PRIMARY KEY (albumId),
    FOREIGN KEY (genreId) REFERENCES genre(genreId)
);

CREATE TABLE orderalbum (
    orderId             INT,
    albumId           INT,
    quantity            INT, 
    price               DECIMAL(10,2), 
    PRIMARY KEY (orderId, albumId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (albumId) REFERENCES album(albumId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    orderId             INT,
    albumId           INT,
    quantity            INT, 
    price               DECIMAL(10,2), 
    PRIMARY KEY (orderId, albumId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (albumId) REFERENCES album(albumId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);

CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT, 
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE albuminventory ( 
    albumId           INT,
    warehouseId         INT,
    quantity            INT,  
    PRIMARY KEY (albumId, warehouseId),   
    FOREIGN KEY (albumId) REFERENCES album(albumId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    albumId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (albumId) REFERENCES album(albumId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO genre(genreName) VALUES ('Indie/Alternative');
INSERT INTO genre(genreName) VALUES ('Rap');
INSERT INTO genre(genreName) VALUES ('Heavy Metal');
INSERT INTO genre(genreName) VALUES ('Pop Rock');
INSERT INTO genre(genreName) VALUES ('UK Garage');
INSERT INTO genre(genreName) VALUES ('Hip Hop');
INSERT INTO genre(genreName) VALUES ('Pop');
INSERT INTO genre(genreName) VALUES ('Rock');
INSERT INTO genre(genreName) VALUES ('R&B/Soul');
INSERT INTO genre(genreName) VALUES ('Reggae');
INSERT INTO genre(genreName) VALUES ('Grunge');
INSERT INTO genre(genreName) VALUES ('Folk');
INSERT INTO genre(genreName) VALUES ('Electronic');
INSERT INTO genre(genreName) VALUES ('Jazz');
INSERT INTO genre(genreName) VALUES ('Country');


INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Currents', 34.99, 'Assets/album_art/Tame_Impala_-_Currents.png', 'Tame Impala', 1, 2015);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Lonerism', 29.99, 'Assets/album_art/Tame_Impala_-_Lonerism.png', 'Tame Impala', 1, 2012);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('good kid, m.A.A.d city', 39.99, 'Assets/album_art/KendrickGKMC.jpg', 'Kendrick Lamar', 2, 2012);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Meliora', 49.99, 'Assets/album_art/Meliora.jpeg', 'Ghost', 3, 2015);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Salad Days', 44.99, 'Assets/album_art/MacDeMarcoSaladDays.png', 'Mac DeMarco', 1, 2014);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Punisher', 44.99, 'Assets/album_art/ab67616d0000b2733040ca980277cf1445934add.jpeg', 'Phoebe Bridgers', 1, 2020);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Abbey Road', 39.99, 'Assets/album_art/Beatles_-_Abbey_Road.jpg', 'The Beatles', 4, 1969);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Untrue', 29.99, 'Assets/album_art/BurialUntrue.jpg', 'Burial', 5, 2007);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Plastic Beach', 39.99, 'Assets/album_art/Plasticbeach452.jpg', 'Gorillaz', 6, 2010);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Demon Days', 34.99, 'Assets/album_art/Gorillaz_Demon_Days.png', 'Gorillaz', 6, 2005);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Thriller', 34.99, 'Assets/album_art/Michael_Jackson_-_Thriller.png', 'Michael Jackson', 7, 1982);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('The Dark Side of the Moon', 29.99, 'Assets/album_art/Dark_Side_of_the_Moon.png', 'Pink Floyd', 8, 1973);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Apollo XXI', 24.99, 'Assets/album_art/ApolloXXI.jpg', 'Steve Lacy', 9, 2019);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Legend', 39.99, 'Assets/album_art/BobMarley-Legend.jpg', 'Bob Marley', 10, 1984);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Nevermind', 39.99, 'Assets/album_art/81l6s4l-JZL._SL1500_.jpg', 'Nirvana', 11, 1991);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Purple Rain', 24.99, 'Assets/album_art/image-asset.jpeg', 'Prince and the Revolution', 4, 1984);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Cold Spring Harbor', 19.99, 'Assets/album_art/81chUczgsmL._SL1500_.jpg', 'Billy Joel', 8, 1971);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Pet Sounds', 24.99, 'Assets/album_art/71DlyWw6ETL._SS500_.jpg', 'The Beach Boys', 4, 1966);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Ready to Die', 34.99, 'Assets/album_art/41-2ZbqjmtL.jpg', 'Notorious B.I.G.', 2, 1994);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('The Chronic', 24.99, 'Assets/album_art/9bc9f210-f051-44c7-b882-44aee7ed4a86_1.b5aa6fdf49f2044bd8a6f11c1fa5d9a0.jpeg', 'Dr. Dre', 6, 1992);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Back to Black', 19.99, 'Assets/album_art/71caoKZoCsL._SL1400_.jpg', 'Amy Winehouse', 7, 2006);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Songs in the Key of Life', 19.99, 'Assets/album_art/71j8hhKN7fL._SL1400_.jpg', 'Stevie Wonder', 9, 1976);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Blonde on Blonde', 39.99, 'Assets/album_art/81oXh1sQasL._SL1500_.jpg', 'Bob Dylan', 12, 1966);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Random Access Memories', 49.99, 'Assets/album_art/R-4570505-1368699003-9153.jpeg.jpg', 'Daft Punk', 13, 2013);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Rumours', 19.99, 'Assets/album_art/u4632-rumors.jpg.jpg', 'Fleetwood Mac', 8, 1977);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('A Love Supreme', 44.99, 'Assets/album_art/R-374507-1457737273-1090.jpeg.jpg', 'John Coltrane', 14, 1965);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('What''s Going On', 24.99, 'Assets/album_art/file-20180329-189807-fofptc.jpg', 'Marvin Gaye', 9, 1971);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Kind of Blue', 29.99, 'Assets/album_art/R-368061-1464275203-2925.jpeg.jpg', 'Miles Davis', 14, 1959);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Graceland', 24.99, 'Assets/album_art/Graceland_cover_-_Paul_Simon.jpg', 'Paul Simon', 8, 1986);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Moondance', 29.99, 'Assets/album_art/81V0S3P-XVL._SL1400_.jpg', 'Van Morrison', 9, 1970);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Is This It', 34.99, 'Assets/album_art/c1b895b7.jpg', 'The Strokes', 1, 2001);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('No Fences', 44.99, 'Assets/album_art/51uC0yguxEL.jpg', 'Garth Brooks', 15, 1990);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Revolver', 49.99, 'Assets/album_art/Revolver_1.jpg', 'The Beatles', 4, 1966);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('London Calling', 24.99, 'Assets/album_art/R-378698-1407158809-2608.jpeg.jpg', 'The Clash', 8, 1979);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Bitches Brew', 34.99, 'Assets/album_art/81m3DGSbOIL._SL1500_.jpg', 'Miles Davis', 14, 1970);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Highway 61 Revisited', 19.99, 'Assets/album_art/71kbAAdrzGL._SL1500_.jpg', 'Bob Dylan', 12, 1965);
INSERT album(albumName,albumPrice,albumImageURL,albumArtist,genreId,albumYear) VALUES ('Simon and Garfunkel''s Greatest Hits', 19.99, 'Assets/album_art/7191IOQXpXL._SL1500_.jpg', 'Simon and Garfunkel', 12, 1972);

INSERT INTO warehouse(warehouseName) VALUES ('Main warehouse');

INSERT INTO albumInventory(albumId, warehouseId, quantity) VALUES (1, 1, 5);

INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , 'test');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , 'bobby');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , 'password');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , 'pw');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , 'test');

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (1, '2019-10-15 10:25:55', 174.95);
INSERT INTO orderalbum (orderId, albumId, quantity, price) VALUES (1, 1, 5, 34.99);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-16 18:00:00', 39.99);
INSERT INTO orderalbum (orderId, albumId, quantity, price) VALUES (2, 14, 1, 39.99);
