trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {
    switch on Trigger.operationType {       
        when AFTER_INSERT {
            contactTriggerHandle.afterInsertHandle(Trigger.new);
        }        
        when AFTER_UPDATE{
            contactTriggerHandle.afterUpdateHandle(Trigger.new, Trigger.oldMap);
        }
        when AFTER_DELETE{
            contactTriggerHandle.afterDeleteHandle(Trigger.old);
        }
        when AFTER_UNDELETE{
            contactTriggerHandle.afterUndeleteHandle(Trigger.new);
        }   
    }
}