public class AccountTriggerHandler {

    public static void afterInsert(List<Account> accountList){
        closeAllOpportunities(accountList);
    }

    public static void afterUpdate(List<Account> accountList){
        closeAllOpportunities(accountList);
    }

    public static void closeAllOpportunities(List<Account> accountList){
        try {
            Set<Id> accountIdSet = new Set<Id>();
            for(Account acc : accountList){
                if(acc.Close_All_Opp__c == true){
                    accountIdSet.add(acc.Id);
                }
            }
            if(!accountIdSet.isEmpty()){
                List<Opportunity> opportunityListToUpdate  = [SELECT Name, StageName FROM Opportunity WHERE AccountId IN: accountIdSet AND StageName != 'Closed Won'];
                if(!opportunityListToUpdate.isEmpty()){
                    for(Opportunity opp : opportunityListToUpdate){
                        opp.stageName = 'Closed Won';
                    }
                    update opportunityListToUpdate;
                }
                
            }
        } catch (Exception ex) {
            System.debug('exception is --'+ ex.getMessage());
        }
    }

    
}