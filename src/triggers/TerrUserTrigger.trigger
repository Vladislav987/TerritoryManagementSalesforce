trigger TerrUserTrigger on TerrUser__c(before insert, before update, before delete, after update) {

    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            TerrUserHandler.deleteOldAccountsAndContactsShares(Trigger.old);
        }
        if (Trigger.isInsert) {
            TerrUserHandler.insertNewAccountsAndContactsShares(Trigger.new);

        }
        if (Trigger.isDelete) {
            TerrUserHandler.deleteOldAccountsAndContactsShares(Trigger.old);
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            TerrUserHandler.insertNewAccountsAndContactsShares(Trigger.new);
        }
    }
}