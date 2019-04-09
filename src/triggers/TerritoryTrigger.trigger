trigger TerritoryTrigger on Territory__c (before insert, before update, before delete, after update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            TerritoryNameVerifier.checkUniqueName(Trigger.new);
        }
        if (Trigger.isUpdate) {
            TerritoryNameVerifier.checkUniqueName(Trigger.new);
            TerritoryHandler.checkAndDeleteOldAccountAndContactShares(Trigger.new, Trigger.oldMap);
        }if (Trigger.isDelete) {
            TerritoryHandler.deleteOldAccountsAndContactsShares(Trigger.old);
        }
    }

    if(Trigger.isAfter){
        if(Trigger.isUpdate) {
            TerritoryHandler.installNewSharesForAccountsAndContacts(Trigger.new, Trigger.oldMap);
        }
    }
}