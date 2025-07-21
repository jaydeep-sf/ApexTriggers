public with sharing class BuildingDashboardController {
    
    @AuraEnabled(cacheable=true)
    public static BuildingData getBuildingData(Id buildingId) {
        try {
            // Query building record
            Building__c building = [
                SELECT Id, Name, Address__c, Building_Image_URL__c, Total_RSF__c
                FROM Building__c 
                WHERE Id = :buildingId 
                LIMIT 1
            ];
            
            // Query floors for this building
            List<Floor__c> floors = [
                SELECT Id, Name, RSF__c, USF__c, Load_Factor__c, Gross_SF__c,
                       (SELECT Id, Name, RSF__c, USF__c, Load_Factor__c, 
                               Lease_Start_Date__c, Lease_End_Date__c, 
                               Rent_Per_SF__c, Status__c 
                        FROM Tenants__r)
                FROM Floor__c 
                WHERE Building__c = :buildingId 
                ORDER BY Name
            ];
            
            // Build the response
            BuildingData result = new BuildingData();
            result.building = building;
            result.floors = new List<FloorData>();
            
            for (Floor__c floor : floors) {
                FloorData floorData = new FloorData();
                floorData.floor = floor;
                floorData.tenants = floor.Tenants__r;
                floorData.availableSpaces = getAvailableSpaces(floor);
                result.floors.add(floorData);
            }
            
            return result;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving building data: ' + e.getMessage());
        }
    }
    
    private static List<AvailableSpace> getAvailableSpaces(Floor__c floor) {
        List<AvailableSpace> availableSpaces = new List<AvailableSpace>();
        
        // Get occupied space
        Decimal occupiedRSF = 0;
        for (Tenant__c tenant : floor.Tenants__r) {
            if (tenant.Status__c == 'Occupied' && tenant.RSF__c != null) {
                occupiedRSF += tenant.RSF__c;
            }
        }
        
        // Calculate available space
        Decimal totalRSF = floor.RSF__c != null ? floor.RSF__c : 0;
        Decimal availableRSF = totalRSF - occupiedRSF;
        
        if (availableRSF > 0) {
            AvailableSpace space = new AvailableSpace();
            space.rsf = availableRSF;
            space.status = 'Available';
            availableSpaces.add(space);
        }
        
        return availableSpaces;
    }
    
    // Wrapper classes
    public class BuildingData {
        @AuraEnabled public Building__c building { get; set; }
        @AuraEnabled public List<FloorData> floors { get; set; }
    }
    
    public class FloorData {
        @AuraEnabled public Floor__c floor { get; set; }
        @AuraEnabled public List<Tenant__c> tenants { get; set; }
        @AuraEnabled public List<AvailableSpace> availableSpaces { get; set; }
    }
    
    public class AvailableSpace {
        @AuraEnabled public Decimal rsf { get; set; }
        @AuraEnabled public String status { get; set; }
    }
}