CREATE TABLE IF NOT EXISTS Country(
	idcountry SERIAL PRIMARY KEY NOT NULL,
	countryname varchar(100)
);


CREATE TABLE IF NOT EXISTS City(
	idcity SERIAL PRIMARY KEY NOT NULL,
	idcountry SERIAL,
	provincename varchar(100),
	CONSTRAINT fk_idcountry
      FOREIGN KEY(idcountry) 
	  REFERENCES Country(idcountry)	
);
	
	
CREATE TABLE IF NOT EXISTS Customer (
   idcustomer SERIAL PRIMARY KEY NOT NULL,
   idcity SERIAL,
   email varchar(255) UNIQUE NOT NULL,
   passwordc varchar(50) NOT NULL,
   namec varchar(255) NOT NULL,
   lastname varchar(50) NOT NULL,
   address varchar(255),
    CONSTRAINT fk_idcity
        FOREIGN KEY(idcity) 
        REFERENCES City(idcity)
);

CREATE TABLE IF NOT EXISTS Sell( 
	idsell SERIAL PRIMARY KEY NOT NULL,
	idcustomer SERIAL NOT NULL,
	datesell DATE DEFAULT CURRENT_DATE,
	CONSTRAINT fk_idcustomer
      FOREIGN KEY(idcustomer) 
	  REFERENCES Customer(idcustomer)
);

CREATE TABLE IF NOT EXISTS PaymentMethod( 
	idpaymentmethod SERIAL PRIMARY KEY,
	paymentmethodname varchar
);

CREATE TABLE IF NOT EXISTS Invoice( 
	idinvoice SERIAL PRIMARY KEY NOT NULL,
	idsell SERIAL,
	idpaymentmethod SERIAL,
	orderdate DATE DEFAULT CURRENT_DATE,
	approved boolean NOT NULL,
	CONSTRAINT fk_idsell
      FOREIGN KEY(idsell) 
	  REFERENCES Sell(idsell),
	CONSTRAINT fk_idpaymentmethod
      FOREIGN KEY(idpaymentmethod) 
	  REFERENCES PaymentMethod(idpaymentmethod)
);
		
CREATE TABLE IF NOT EXISTS ItemCategory( 
    iditemcategory SERIAL PRIMARY KEY NOT NULL,
    namecategory varchar NOT NULL
);

CREATE TABLE IF NOT EXISTS Item( 
    iditem SERIAL PRIMARY KEY NOT NULL,
    iditemcategory SERIAL,
    itemname varchar(100) NOT NULL,
    price NUMERIC(9,2) NOT NULL,
    tax NUMERIC(4,2) NOT NULL,
    photo bytea,
    description text NOT NULL,
    quantity int,
    CONSTRAINT fk_iditemcategory
        FOREIGN KEY(iditemcategory) 
        REFERENCES ItemCategory(iditemcategory)
);


CREATE TABLE IF NOT EXISTS SellDetails( 
    idselldetails SERIAL PRIMARY KEY,
    idsell SERIAL,
    iditem SERIAL,
    quantity int,
    CONSTRAINT fk_idsell
        FOREIGN KEY(idsell) 
        REFERENCES Sell(idsell),
    CONSTRAINT fk_iditem
        FOREIGN KEY(iditem) 
        REFERENCES Item(iditem)
);
	
	