# Building Dashboard for Salesforce

This solution provides a comprehensive dashboard view for building records, displaying floor plans, tenant information, and space availability in a visual format similar to commercial real estate management systems.

## Features

- **Visual Building Overview**: Displays building image, address, and total square footage
- **Floor-by-Floor Layout**: Tabular view with visual floor plan representation
- **Tenant Information**: Shows occupied spaces with lease details, rent information, and lease expiration dates
- **Available Space Tracking**: Highlights available spaces and spaces available for sublease
- **Responsive Design**: Works on desktop and mobile devices
- **Real-time Data**: Uses cacheable Apex methods for optimal performance

## Data Model

### Custom Objects Created

1. **Building__c**
   - Name (Text)
   - Address__c (Text)
   - Building_Image_URL__c (URL)
   - Total_RSF__c (Number)

2. **Floor__c**
   - Name (Text) - Floor Number
   - Building__c (Master-Detail to Building)
   - RSF__c (Number) - Rentable Square Feet
   - USF__c (Number) - Usable Square Feet
   - Load_Factor__c (Percent)
   - Gross_SF__c (Number) - Gross Square Feet

3. **Tenant__c**
   - Name (Text) - Tenant Name
   - Floor__c (Master-Detail to Floor)
   - RSF__c (Number) - Rentable Square Feet
   - USF__c (Number) - Usable Square Feet
   - Load_Factor__c (Percent)
   - Lease_Start_Date__c (Date)
   - Lease_End_Date__c (Date)
   - Rent_Per_SF__c (Currency)
   - Status__c (Picklist: Available, Occupied, Available for Sublease)

## Components

### Apex Controller
- **BuildingDashboardController.cls**: Handles data retrieval and processing
  - `getBuildingData(Id buildingId)`: Main method to fetch building, floor, and tenant data
  - Wrapper classes for structured data response
  - Calculates available space automatically

### Lightning Web Component
- **buildingDashboard**: Main dashboard component
  - JavaScript controller with data formatting utilities
  - HTML template with responsive table layout
  - CSS styling for visual appeal and mobile compatibility
  - Color-coded tenant status representation

## Installation

1. **Deploy the Metadata**:
   ```bash
   sfdx force:source:deploy -p force-app/main/default -u your-org-alias
   ```

2. **Create Sample Data** (Optional):
   - Open Developer Console or VS Code
   - Run the script in `scripts/apex/createSampleData.apex` in Anonymous Apex

3. **Add Component to Building Record Pages**:
   - Navigate to Setup > Object Manager > Building > Lightning Record Pages
   - Edit the record page or create a new one
   - Drag the "Building Dashboard" component to the page
   - Save and activate the page

## Usage

### For System Administrators

1. **Creating Buildings**:
   - Navigate to the Buildings tab
   - Create a new Building record with Name, Address, Total RSF, and Building Image URL

2. **Adding Floors**:
   - From a Building record, create related Floor records
   - Enter floor number, RSF, USF, Load Factor, and Gross SF

3. **Managing Tenants**:
   - From Floor records, create Tenant records
   - Enter tenant details including lease dates, rent, and status

### For End Users

1. **Viewing Dashboard**:
   - Navigate to any Building record
   - The dashboard will automatically load showing:
     - Building image and details
     - Floor-by-floor breakdown
     - Visual representation of occupied and available spaces
     - Tenant lease information

2. **Understanding the Display**:
   - **Green blocks**: Occupied spaces
   - **Gray blocks**: Available spaces
   - **Orange blocks**: Available for sublease
   - Each block shows tenant name, RSF, lease dates, and rent information

## Customization

### Color Coding
You can modify tenant status colors in the `getTenantColor()` method in `buildingDashboard.js`:

```javascript
getTenantColor(status) {
    switch (status) {
        case 'Occupied': return '#4CAF50';           // Green
        case 'Available for Sublease': return '#FF9800'; // Orange
        default: return '#e5e5e5';                   // Gray
    }
}
```

### Additional Fields
To add more fields to the dashboard:

1. Add fields to the custom objects
2. Update the SOQL queries in `BuildingDashboardController.cls`
3. Modify the HTML template in `buildingDashboard.html`
4. Update the CSS styling if needed

### Layout Modifications
- Modify `buildingDashboard.css` to change the visual appearance
- Adjust the responsive breakpoints for different screen sizes
- Customize the table layout and spacing

## Technical Details

### Performance Considerations
- Uses `@AuraEnabled(cacheable=true)` for optimal performance
- Minimal SOQL queries with efficient relationship queries
- Responsive design with CSS Grid and Flexbox

### Browser Compatibility
- Supports all modern browsers
- Mobile-responsive design
- Lightning Design System components for consistency

### Security
- Uses `with sharing` in Apex controller
- Respects Salesforce security model and field-level security
- Component exposed only to appropriate Lightning page types

## Troubleshooting

### Common Issues

1. **Component Not Displaying Data**:
   - Verify the Building record has related Floor and Tenant records
   - Check field-level security permissions
   - Ensure the Apex class is deployed and active

2. **Visual Layout Issues**:
   - Clear browser cache
   - Check CSS conflicts with other components
   - Verify Lightning Design System is loading properly

3. **Data Not Loading**:
   - Check Apex debug logs for errors
   - Verify SOQL query permissions
   - Ensure proper object relationships

### Debug Steps

1. Open Developer Console
2. Check Debug Logs for any errors
3. Verify data exists using SOQL queries:
   ```sql
   SELECT Id, Name FROM Building__c
   SELECT Id, Name, Building__c FROM Floor__c WHERE Building__c = 'BUILDING_ID'
   ```

## Future Enhancements

Potential improvements for future versions:

1. **Interactive Floor Plans**: Click-to-drill-down functionality
2. **Export Capabilities**: PDF generation of floor plans
3. **Advanced Filtering**: Filter by lease expiration, tenant type, etc.
4. **Occupancy Analytics**: Charts and graphs for space utilization
5. **Mobile App**: Native mobile application for field use
6. **Integration**: Connect with external property management systems

## Support

For technical support or enhancement requests:
1. Check the Salesforce debug logs
2. Review the component documentation
3. Test with sample data first
4. Contact your Salesforce administrator

---

**Version**: 1.0  
**API Version**: 58.0  
**Last Updated**: January 2025