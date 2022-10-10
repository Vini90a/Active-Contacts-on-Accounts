/**
* ContactTriggerService
* Atualiza um campo em Account (Active_Contacts__c) que mostra os contatos ativos atrelados a aquela conta
* @author ViniAlves
*/
public with sharing class ContactTriggerService {
    public static void updateAccounts (Set<Id> accountsToUpdate){
        
        //Para para guardar o numero de contatos ativos agrupado por conta (AccountId) 
        Map<Id, Account> accResult = new Map<Id, Account>();
        for (AggregateResult agtr : [SELECT AccountId, COUNT(Id) total 
                                     FROM Contact WHERE Active__c=true 
                                     AND AccountId IN:accountsToUpdate GROUP BY AccountId]){
            
            Id accountId = String.valueOf(agtr.get('AccountId'));
            Account acc = new Account(Id=accountId, Active_Contacts__c=Integer.valueOf(agtr.get('total')));
            accResult.put(accountId, acc);
        }

        //Bugfix - Certificar se algum dos resultados agregados da chamada acima não fique vazio (null)
        for (Id accId : accountsToUpdate){
            if(!accResult.containsKey(accId)){
                accResult.put(accId, new Account(Id=accId, Active_Contacts__c=0));
            }
        }
        //Atualizando o campo Active_Contacts__c
        update accResult.values();
    }
}
