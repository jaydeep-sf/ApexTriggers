// Create Sample Building Data
// Run this in Anonymous Apex to create test data

// Create Building
Building__c building = new Building__c(
    Name = 'Commerce Center',
    Address__c = '123 Business District, Corporate City, NY 10001',
    Total_RSF__c = 76151,
    Building_Image_URL__c = 'https://via.placeholder.com/300x200?text=Commerce+Center'
);
insert building;

// Create Floors
List<Floor__c> floors = new List<Floor__c>();

// Floor 3
floors.add(new Floor__c(
    Name = '3',
    Building__c = building.Id,
    RSF__c = 97351,
    USF__c = 80533,
    Load_Factor__c = 17.28,
    Gross_SF__c = 80533
));

// Floor 2
floors.add(new Floor__c(
    Name = '2',
    Building__c = building.Id,
    RSF__c = 94122,
    USF__c = 72285,
    Load_Factor__c = 23.20,
    Gross_SF__c = 75676
));

// Floor 1
floors.add(new Floor__c(
    Name = '1',
    Building__c = building.Id,
    RSF__c = 77796,
    USF__c = 59683,
    Load_Factor__c = 23.28,
    Gross_SF__c = 62070
));

// BSMT
floors.add(new Floor__c(
    Name = 'BSMT',
    Building__c = building.Id,
    RSF__c = 76151,
    USF__c = 269269,
    Load_Factor__c = 21.08,
    Gross_SF__c = 218279
));

insert floors;

// Create Tenants
List<Tenant__c> tenants = new List<Tenant__c>();

// Floor 3 Tenants
Floor__c floor3 = floors[0];
tenants.add(new Tenant__c(
    Name = 'DSV Air & Sea',
    Floor__c = floor3.Id,
    RSF__c = 97351,
    USF__c = 80533,
    Load_Factor__c = 17.28,
    Status__c = 'Occupied',
    Lease_Start_Date__c = Date.newInstance(2020, 10, 31),
    Lease_End_Date__c = Date.newInstance(2031, 10, 31),
    Rent_Per_SF__c = 40.00
));

// Floor 2 Tenants
Floor__c floor2 = floors[1];
tenants.add(new Tenant__c(
    Name = 'Allied World Assurance',
    Floor__c = floor2.Id,
    RSF__c = 21010,
    USF__c = 15968,
    Load_Factor__c = 24.00,
    Status__c = 'Occupied',
    Lease_Start_Date__c = Date.newInstance(2020, 1, 1),
    Lease_End_Date__c = Date.newInstance(2026, 1, 1),
    Rent_Per_SF__c = 41.39
));

tenants.add(new Tenant__c(
    Name = 'Siemens Corporation',
    Floor__c = floor2.Id,
    RSF__c = 65562,
    USF__c = 50579,
    Load_Factor__c = 22.85,
    Status__c = 'Occupied',
    Lease_Start_Date__c = Date.newInstance(2020, 9, 30),
    Lease_End_Date__c = Date.newInstance(2032, 9, 30),
    Rent_Per_SF__c = 43.18
));

// Floor 1 Tenants
Floor__c floor1 = floors[2];
tenants.add(new Tenant__c(
    Name = 'Mazars',
    Floor__c = floor1.Id,
    RSF__c = 13950,
    USF__c = 11350,
    Load_Factor__c = 24.00,
    Status__c = 'Occupied',
    Lease_Start_Date__c = Date.newInstance(2020, 7, 31),
    Lease_End_Date__c = Date.newInstance(2034, 7, 31),
    Rent_Per_SF__c = 42.00
));

tenants.add(new Tenant__c(
    Name = 'Bank of Nova Scotia',
    Floor__c = floor1.Id,
    RSF__c = 15099,
    USF__c = 11584,
    Load_Factor__c = 23.28,
    Status__c = 'Occupied',
    Lease_Start_Date__c = Date.newInstance(2020, 7, 31),
    Lease_End_Date__c = Date.newInstance(2031, 7, 31),
    Rent_Per_SF__c = 44.74
));

tenants.add(new Tenant__c(
    Name = 'Helsim Therapeutics',
    Floor__c = floor1.Id,
    RSF__c = 18500,
    USF__c = 14567,
    Load_Factor__c = 24.50,
    Status__c = 'Occupied',
    Lease_Start_Date__c = Date.newInstance(2020, 11, 30),
    Lease_End_Date__c = Date.newInstance(2033, 11, 30),
    Rent_Per_SF__c = 44.22
));

tenants.add(new Tenant__c(
    Name = 'Credit Agricole Corporate & Investment Bank',
    Floor__c = floor1.Id,
    RSF__c = 20800,
    USF__c = 16300,
    Load_Factor__c = 19.53,
    Status__c = 'Occupied',
    Lease_Start_Date__c = Date.newInstance(2020, 2, 28),
    Lease_End_Date__c = Date.newInstance(2031, 2, 28),
    Rent_Per_SF__c = 46.36
));

insert tenants;

System.debug('Sample building data created successfully!');
System.debug('Building ID: ' + building.Id);
System.debug('Navigate to the Building record page to see the dashboard.');