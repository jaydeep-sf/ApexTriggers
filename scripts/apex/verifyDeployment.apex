// Deployment Verification Script
// Run this in Anonymous Apex to verify the deployment

try {
    // Test object creation permissions
    System.debug('=== Testing Object Access ===');
    
    // Test Building object
    Schema.SObjectType buildingType = Schema.getGlobalDescribe().get('Building__c');
    if (buildingType != null) {
        System.debug('✓ Building__c object exists');
        
        // Check key fields
        Map<String, Schema.SObjectField> buildingFields = buildingType.getDescribe().fields.getMap();
        String[] requiredFields = new String[]{'Address__c', 'Building_Image_URL__c', 'Total_RSF__c'};
        
        for (String field : requiredFields) {
            if (buildingFields.containsKey(field)) {
                System.debug('✓ Building field exists: ' + field);
            } else {
                System.debug('✗ Missing Building field: ' + field);
            }
        }
    } else {
        System.debug('✗ Building__c object NOT found');
    }
    
    // Test Floor object
    Schema.SObjectType floorType = Schema.getGlobalDescribe().get('Floor__c');
    if (floorType != null) {
        System.debug('✓ Floor__c object exists');
        
        Map<String, Schema.SObjectField> floorFields = floorType.getDescribe().fields.getMap();
        String[] requiredFields = new String[]{'Building__c', 'RSF__c', 'USF__c', 'Load_Factor__c', 'Gross_SF__c'};
        
        for (String field : requiredFields) {
            if (floorFields.containsKey(field)) {
                System.debug('✓ Floor field exists: ' + field);
            } else {
                System.debug('✗ Missing Floor field: ' + field);
            }
        }
    } else {
        System.debug('✗ Floor__c object NOT found');
    }
    
    // Test Tenant object
    Schema.SObjectType tenantType = Schema.getGlobalDescribe().get('Tenant__c');
    if (tenantType != null) {
        System.debug('✓ Tenant__c object exists');
        
        Map<String, Schema.SObjectField> tenantFields = tenantType.getDescribe().fields.getMap();
        String[] requiredFields = new String[]{'Floor__c', 'RSF__c', 'USF__c', 'Load_Factor__c', 
                                                'Lease_Start_Date__c', 'Lease_End_Date__c', 
                                                'Rent_Per_SF__c', 'Status__c'};
        
        for (String field : requiredFields) {
            if (tenantFields.containsKey(field)) {
                System.debug('✓ Tenant field exists: ' + field);
            } else {
                System.debug('✗ Missing Tenant field: ' + field);
            }
        }
    } else {
        System.debug('✗ Tenant__c object NOT found');
    }
    
    // Test Apex Controller
    System.debug('=== Testing Apex Controller ===');
    Type controllerType = Type.forName('BuildingDashboardController');
    if (controllerType != null) {
        System.debug('✓ BuildingDashboardController class exists');
    } else {
        System.debug('✗ BuildingDashboardController class NOT found');
    }
    
    // Test data query capabilities
    System.debug('=== Testing Data Access ===');
    try {
        List<Building__c> testBuildings = [SELECT Id, Name FROM Building__c LIMIT 1];
        System.debug('✓ Can query Building records. Found: ' + testBuildings.size());
        
        List<Floor__c> testFloors = [SELECT Id, Name FROM Floor__c LIMIT 1];
        System.debug('✓ Can query Floor records. Found: ' + testFloors.size());
        
        List<Tenant__c> testTenants = [SELECT Id, Name FROM Tenant__c LIMIT 1];
        System.debug('✓ Can query Tenant records. Found: ' + testTenants.size());
        
    } catch (Exception e) {
        System.debug('✗ Query error: ' + e.getMessage());
    }
    
    System.debug('=== Deployment Verification Complete ===');
    System.debug('If all items show ✓, the deployment is successful!');
    System.debug('Next steps:');
    System.debug('1. Create sample data using createSampleData.apex');
    System.debug('2. Add the Building Dashboard component to a Building record page');
    System.debug('3. Navigate to a Building record to see the dashboard');
    
} catch (Exception e) {
    System.debug('Verification failed with error: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}