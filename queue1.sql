SELECT DISTINCT v.VehicleID, v.PlateNumber, vc.ClassName, b.BranchName
FROM Vehicle v
JOIN VehicleClass vc ON v.ClassID = vc.ClassID
JOIN Branch b ON v.BranchID = b.BranchID
WHERE v.BranchID = 1  -- 横浜支店
AND v.VehicleID NOT IN (
    SELECT VehicleID 
    FROM Reservation 
    WHERE (
        -- 指定期間（例：2024-12-24 10:00 から 2024-12-25 10:00）と予約期間が重複するものを除外
        (DATETIME(RentalDate || ' ' || RentalTime) <= '2024-12-25 10:00' AND
         DATETIME(ReturnDate || ' ' || ReturnTime) >= '2024-12-24 10:00')
    )
);