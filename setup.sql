-- 外部キー制約
PRAGMA foreign_keys = ON;

-- 支店テーブル
CREATE TABLE Branch (
    BranchID INTEGER PRIMARY KEY,
    BranchName TEXT NOT NULL
);

-- 車両クラステーブル
CREATE TABLE VehicleClass (
    ClassID INTEGER PRIMARY KEY,
    ClassName TEXT NOT NULL
);

-- 車両テーブル
CREATE TABLE Vehicle (
    VehicleID INTEGER PRIMARY KEY,
    PlateNumber TEXT NOT NULL UNIQUE,
    BranchID INTEGER NOT NULL,
    ClassID INTEGER NOT NULL,
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (ClassID) REFERENCES VehicleClass(ClassID)
);

-- 顧客テーブル
CREATE TABLE Customer (
    CustomerID INTEGER PRIMARY KEY,
    Name TEXT NOT NULL,
    Address TEXT,
    Phone TEXT,
    Email TEXT
);

-- 保険テーブル
CREATE TABLE Insurance (
    InsuranceID INTEGER PRIMARY KEY,
    PlanName TEXT NOT NULL,
    Fee DECIMAL(10, 2) NOT NULL
);

-- 補償内容テーブル
CREATE TABLE Coverage (
    InsuranceID INTEGER NOT NULL,
    CoverageItem TEXT NOT NULL,
    CoverageAmount DECIMAL(10, 2),
    PRIMARY KEY (InsuranceID, CoverageItem),
    FOREIGN KEY (InsuranceID) REFERENCES Insurance(InsuranceID)
);

-- 予約テーブル
CREATE TABLE Reservation (
    ReservationID INTEGER PRIMARY KEY,
    RentalDate DATE NOT NULL,
    RentalTime TIME NOT NULL,
    ReturnDate DATE NOT NULL,        
    ReturnTime TIME NOT NULL,        
    Duration INTEGER NOT NULL,       -- 互換性のために残す
    CustomerID INTEGER NOT NULL,
    VehicleID INTEGER NOT NULL,
    InsuranceID INTEGER NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (VehicleID) REFERENCES Vehicle(VehicleID),
    FOREIGN KEY (InsuranceID) REFERENCES Insurance(InsuranceID),
    -- 制約条件：返却日時は予約日時より後
    CHECK (
        DATETIME(ReturnDate || ' ' || ReturnTime) > 
        DATETIME(RentalDate || ' ' || RentalTime)
    )
);

-- 予約詳細ビューの作成
CREATE VIEW ReservationDetails AS
SELECT 
    r.ReservationID,
    r.RentalDate,
    r.RentalTime,
    r.ReturnDate,   
    r.ReturnTime,   
    r.Duration,
    c.Name AS CustomerName,
    c.Phone AS CustomerPhone,
    v.PlateNumber,
    vc.ClassName,
    b.BranchName,
    i.PlanName AS InsurancePlan,
    i.Fee AS InsuranceFee
FROM Reservation r
JOIN Customer c ON r.CustomerID = c.CustomerID
JOIN Vehicle v ON r.VehicleID = v.VehicleID
JOIN VehicleClass vc ON v.ClassID = vc.ClassID
JOIN Branch b ON v.BranchID = b.BranchID
JOIN Insurance i ON r.InsuranceID = i.InsuranceID;