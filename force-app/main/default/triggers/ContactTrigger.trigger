trigger ContactTrigger on Contact (before insert, after insert, after update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            
        }
        
        when AFTER_INSERT {
            contactTriggerHandle.afterInsertHandle(Trigger.new);
        }
        
        when AFTER_UPDATE{
            contactTriggerHandle.afterUpdateHandle(Trigger.new, Trigger.oldMap);
        }
    }
}