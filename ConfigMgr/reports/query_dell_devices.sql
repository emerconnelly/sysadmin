/*
Prequisites:
- 'Dell Command | Monitor' installed on client
- DCIM .mof files imported and enabled in ConfigMgr > Client Settings > Hardware Inventory
- 'l' (city) and 'st' (state) attributes enabled in ConfigMgr > AD User Discovery > AD Attributes
*/

SELECT
    DISTINCT SYS.ResourceID,
    CONSOLE.TopConsoleUser0 AS 'Top User',
    U.Full_User_Name0 AS 'Name',
    CONCAT(U.l, ', ', U.st) AS 'Location',
    SYS.Name0 AS 'Hostname',
    OS.Version0 AS 'Windows Version',
    CS.Model0 AS 'Model',
    BIOS.SerialNumber0 AS 'ServiceTag',
    DCIM_CHASSIS.ManufactureDate00 AS 'Manufacture Date',
    DCIM_CHASSIS.FirstPowerOnDate00 AS 'First Power-on Date',
    CPU.Name AS 'CPU Model',
    CPU.[# of CPUs],
    CPU.[Cores per CPU],
    CPU.[Logical CPU Count],
    RAM.[# Memory Slots],
    RAM.[Memory (GB)],
    LDISK.[Total Space (GB)],
    LDISK.[Free Space (GB)]
FROM
    v_R_System SYS
    LEFT JOIN v_GS_SYSTEM_CONSOLE_USAGE CONSOLE ON SYS.ResourceID = CONSOLE.ResourceID
    LEFT JOIN v_R_User U ON CONSOLE.TopConsoleUser0 = U.Unique_User_Name0
    LEFT JOIN v_GS_OPERATING_SYSTEM OS ON OS.ResourceID = SYS.ResourceID
    LEFT JOIN v_GS_COMPUTER_SYSTEM CS ON CS.ResourceID = SYS.ResourceID
    LEFT JOIN v_HS_PC_BIOS BIOS ON BIOS.ResourceID = SYS.ResourceID
    LEFT JOIN DELL_DCIM_Chassis_DATA DCIM_CHASSIS ON SYS.ResourceID = DCIM_CHASSIS.MachineID
    LEFT JOIN (
        SELECT
            DISTINCT(CPU.SystemName0) AS [System Name],
            CPU.Manufacturer0 AS Manufacturer,
            CPU.ResourceID,
            CPU.Name0 AS Name,
            COUNT(CPU.ResourceID) AS [# of CPUs],
            CPU.NumberOfCores0 AS [Cores per CPU],
            CPU.NumberOfLogicalProcessors0 AS [Logical CPU Count]
        FROM
            [dbo].[v_GS_PROCESSOR] CPU
        GROUP BY
            CPU.SystemName0,
            CPU.Manufacturer0,
            CPU.Name0,
            CPU.NumberOfCores0,
            CPU.NumberOfLogicalProcessors0,
            CPU.ResourceID
    ) CPU ON CPU.ResourceID = SYS.ResourceID
    LEFT JOIN (
        SELECT
            DISTINCT SUM(ISNULL(RAM.Capacity0, 0)) / 1024 AS [Memory (GB)],
            COUNT(RAM.ResourceID) AS [# Memory Slots],
            RAM.ResourceID
        FROM
            [dbo].[v_GS_PHYSICAL_MEMORY] RAM
        GROUP BY
            RAM.ResourceID,
            RAM.Capacity0
    ) RAM ON SYS.ResourceID = RAM.ResourceID
    LEFT JOIN (
        SELECT
            DISTINCT LDISK.FreeSpace0 / 1024 AS [Free Space (GB)],
            LDISK.Size0 / 1024 AS [Total Space (GB)],
            LDISK.ResourceID
        FROM
            [dbo].[v_GS_LOGICAL_DISK] LDISK
        WHERE
            LDISK.DeviceID0 = 'C:'
        GROUP BY
            LDISK.ResourceID,
            LDISK.FreeSpace0,
            LDISK.Size0
    ) LDISK ON SYS.ResourceID = LDISK.ResourceID
WHERE
    DCIM_CHASSIS.CreationClassName00 LIKE '%Chassis%'
    AND BIOS.SerialNumber0 IS NOT NULL
GROUP BY
    SYS.ResourceID,
    CONSOLE.TopConsoleUser0,
    U.Full_User_Name0,
    U.l,
    U.st,
    SYS.Name0,
    DCIM_CHASSIS.ManufactureDate00,
    DCIM_CHASSIS.FirstPowerOnDate00,
    CPU.Name,
    CPU.[# of CPUs],
    CPU.[Cores per CPU],
    CPU.[Logical CPU Count],
    OS.Version0,
    CS.Model0,
    BIOS.SerialNumber0,
    RAM.[# Memory Slots],
    RAM.[Memory (GB)],
    LDISK.[Free Space (GB)],
    LDISK.[Total Space (GB)]
ORDER BY
    DCIM_CHASSIS.ManufactureDate00
