SELECT 
    v.PlateNumber,
    vc.ClassName,
    b.BranchName,
    COUNT(r.ReservationID) as TotalReservations,
    SUM(r.Duration) as TotalHoursReserved
FROM Vehicle v
LEFT JOIN Reservation r ON v.VehicleID = r.VehicleID
JOIN VehicleClass vc ON v.ClassID = vc.ClassID
JOIN Branch b ON v.BranchID = b.BranchID
GROUP BY v.VehicleID
ORDER BY TotalHoursReserved DESC;