import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getBuildingData from '@salesforce/apex/BuildingDashboardController.getBuildingData';

const BUILDING_FIELDS = ['Building__c.Id', 'Building__c.Name'];

export default class BuildingDashboard extends LightningElement {
    @api recordId;
    @track buildingData;
    @track error;
    @track isLoading = true;

    @wire(getBuildingData, { buildingId: '$recordId' })
    wiredBuildingData({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.buildingData = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.buildingData = undefined;
        }
    }

    get hasData() {
        return this.buildingData && this.buildingData.floors && this.buildingData.floors.length > 0;
    }

    get buildingImageUrl() {
        return this.buildingData?.building?.Building_Image_URL__c || 
               'https://via.placeholder.com/300x200?text=Building+Image';
    }

    get formattedFloors() {
        if (!this.buildingData?.floors) return [];
        
        return this.buildingData.floors.map(floorData => {
            const floor = floorData.floor;
            const tenants = floorData.tenants || [];
            const availableSpaces = floorData.availableSpaces || [];
            
            // Sort tenants and available spaces by RSF (largest first)
            const allSpaces = [
                ...tenants.map(tenant => ({
                    ...tenant,
                    type: 'tenant',
                    displayName: tenant.Name,
                    bgColor: this.getTenantColor(tenant.Status__c),
                    textColor: 'white'
                })),
                ...availableSpaces.map(space => ({
                    ...space,
                    type: 'available',
                    displayName: 'Available',
                    bgColor: '#e5e5e5',
                    textColor: 'black'
                }))
            ].sort((a, b) => (b.RSF__c || b.rsf || 0) - (a.RSF__c || a.rsf || 0));

            return {
                ...floor,
                spaces: allSpaces,
                floorNumber: floor.Name
            };
        });
    }

    getTenantColor(status) {
        switch (status) {
            case 'Occupied': return '#4CAF50';
            case 'Available for Sublease': return '#FF9800';
            default: return '#e5e5e5';
        }
    }

    formatNumber(value) {
        if (!value) return '0';
        return new Intl.NumberFormat().format(value);
    }

    formatCurrency(value) {
        if (!value) return '$0.00';
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD'
        }).format(value);
    }

    formatPercentage(value) {
        if (!value) return '0%';
        return (value / 100).toLocaleString('en-US', {
            style: 'percent',
            minimumFractionDigits: 1,
            maximumFractionDigits: 1
        });
    }

    formatDate(dateString) {
        if (!dateString) return '';
        const date = new Date(dateString);
        return date.toLocaleDateString('en-US', {
            month: 'numeric',
            day: 'numeric',
            year: 'numeric'
        });
    }
}