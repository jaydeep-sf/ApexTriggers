trigger TriggerOnAccount on Account (after insert, after update) {
    Switch on Trigger.OperationType{
        When AFTER_INSERT{
            AccountTriggerHandler.afterInsert(trigger.new);
        }
        When AFTER_UPDATE{
            AccountTriggerHandler.afterUpdate(trigger.new);
        }
    }
}