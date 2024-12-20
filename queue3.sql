-- 特定の期間に利用可能な車両を検索（例：2024-12-24 10:00 から 4時間利用の場合）
SELECT 
    v.VehicleID, 
    v.PlateNumber, 
    vc.ClassName, 
    b.BranchName
FROM Vehicle v
JOIN VehicleClass vc ON v.ClassID = vc.ClassID
JOIN Branch b ON v.BranchID = b.BranchID
WHERE v.BranchID = 1  -- 横浜支店
AND v.VehicleID NOT IN (
    SELECT VehicleID 
    FROM Reservation 
    WHERE (
        DATETIME('2024-12-24 10:00') < DATETIME(ReturnDate || ' ' || ReturnTime)
        AND 
        DATETIME('2024-12-24 14:00') > DATETIME(RentalDate || ' ' || RentalTime)
    )
)
ORDER BY vc.ClassName;