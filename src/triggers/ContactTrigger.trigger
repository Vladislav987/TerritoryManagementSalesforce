trigger ContactTrigger on Contact (before insert, before update, before delete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            ContactHandler.onBeforeInsert(Trigger.new);
        }
/*
        if (Trigger.isUpdate) {
            ContactTriggerHandler.beforeUpdate(Trigger.new);
        }
        if (Trigger.isDelete) {
            ContactTriggerHandler.onBeforeDelete(Trigger.oldMap);
        }
*/
    }
}