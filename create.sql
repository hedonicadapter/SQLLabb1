CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY IDENTITY(1,1),
    Firstname NVARCHAR(40),
    Lastname NVARCHAR(40),
    Birthday DATE
);

CREATE TABLE Books (
    ISBN13 VARCHAR(17) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    LanguageISO VARCHAR(5),
    Price DECIMAL(19,4),
    Published DATE,
    Author INT, -- Borde vara authors
    Description NVARCHAR(255),

    FOREIGN KEY (Author) REFERENCES Authors(AuthorID) ON DELETE CASCADE
)

CREATE TABLE Genres (
    GenreID INT PRIMARY KEY IDENTITY(1,1),
    Genre VARCHAR(40) UNIQUE NOT NULL,
)

CREATE TABLE GenresBooks (
    ISBN VARCHAR(17) FOREIGN KEY REFERENCES Books(ISBN13),
    GenreID INT FOREIGN KEY REFERENCES Genres(GenreID),
)

CREATE TABLE Positions (
    PositionID INT PRIMARY KEY IDENTITY(1,1),
    Position VARCHAR(40) UNIQUE NOT NULL,
)

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    Firstname NVARCHAR(40),
    Lastname NVARCHAR(40),
    Phone VARCHAR(255),
    Salary BIGINT,
    Position INT FOREIGN KEY REFERENCES Positions(PositionID)
)

CREATE TABLE Countries (
    Country NVARCHAR(40) PRIMARY KEY,
)

CREATE TABLE Cities (
    City NVARCHAR(40) PRIMARY KEY,
    Country NVARCHAR(40) FOREIGN KEY REFERENCES Countries(Country),
)

CREATE TABLE Addresses (
    AddressID INT PRIMARY KEY IDENTITY(1,1),
    City NVARCHAR(40) FOREIGN KEY REFERENCES Cities(City), 
    Street NVARCHAR(255), --kan bryta ut dessa också men det känns lite för mycket?
    ZipCode VARCHAR(10) -- ^
)

CREATE TABLE Stores (
    StoreID INT IDENTITY(1,1) PRIMARY KEY,
    StoreName NVARCHAR(40) NOT NULL,
    Phone VARCHAR(255), -- borde vara 1..m för nummer till olika avdelningar
    Address INT FOREIGN KEY REFERENCES Addresses(AddressID)
)

CREATE TABLE StoresEmployees (
    Employee INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    Store INT FOREIGN KEY REFERENCES Stores(StoreID) 
)


CREATE TABLE Inventory (
    StoreID INT FOREIGN KEY REFERENCES Stores(StoreID),
    ISBN VARCHAR(17) FOREIGN KEY REFERENCES Books(ISBN13),
    Quantity INT NOT NULL DEFAULT 0,

    PRIMARY KEY (StoreID, ISBN)
)


