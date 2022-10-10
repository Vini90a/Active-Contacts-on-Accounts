/**
* contactTriggerHandle
* Classe para controlar o trigger em Contato 
* @author ViniAlves
*/
public class contactTriggerHandle {

    public static Boolean firtInsertion = true;
            
     /**
     * afterInsertHandle
     * Funcionamento: 
     * 	- Faz uma atualização do campo (Active_Contacts__c) em Account caso seja a primeira execução da classe
     *  - Verifica se o campo AccountId do contato inserido não está vazio
     * 	- Chama a classe Contact TriggerService para atualizar o banco de dados
     * @return void
     */
    public static void afterInsertHandle (List<Contact> contactRecords){        
        
        //Caso a Org não tenha populado o campo Active_Contacts__c, esse trecho irá atualizar todos os campos
        if (firtInsertion=true){
            Map<Id, Integer> accActiveMap = new Map<Id, Integer>();
            for(AggregateResult agr : [SELECT AccountId, COUNT(Id) total FROM Contact WHERE Active__c=true GROUP BY AccountId ]){
                accActiveMap.put(String.valueOf(agr.get('AccountId')), Integer.valueOf(agr.get('total')));
            }
            List<Account> accList = new List<Account>();
            for (Id accIds : accActiveMap.keySet()){
                if (String.isBlank(accIds)){continue;}
                accList.add(new Account(Id=accIds, Active_Contacts__c=accActiveMap.get(accIds)));
            }
            update accList;
            firtInsertion = false;
        }
        
        //Set para armazenar os accids
        Set<Id> recentContacts = new Set<Id>();
        for (Contact cont : contactRecords){
            //Checando se o campo AccountId está sem valor (contato sem conta atrelada)
            if(String.isBlank(cont.AccountId)){continue;}           
            recentContacts.add(cont.AccountId);
        }      
        ContactTriggerService.updateAccounts(recentContacts);
    }
    
    
    public static void afterUpdateHandle (List<Contact> contactRecords, Map<Id, Contact> oldRecordsMap){     	
        //Set para armazenar os accids
        Set<Id> recentContacts = new Set<Id>();
        for (Contact cont : contactRecords){
            //Checando se o campo AccountId está sem valor (contato sem conta atrelada)
            //E também se houve mudança no campo Active__C
            if(String.isBlank(cont.AccountId) || (cont.Active__c == oldRecordsMap.get(cont.Id).active__c)){continue;}           
            recentContacts.add(cont.AccountId);

            //Bugfix - Caso foi feita uma mudança no Account, adiciona o Id do Account antigo no set para atualização
            if(cont.AccountId != oldRecordsMap.get(cont.Id).accountId){
                recentContacts.add(oldRecordsMap.get(cont.Id).accountId);
            }
        }      
        ContactTriggerService.updateAccounts(recentContacts);
    }
    
    public static void afterDeleteHandle (List<Contact> oldContacts){
        //Set para armazenar os accids
        Set<Id> recentContacts = new Set<Id>();
        for (Contact cont : oldContacts){
            //Checando se o campo AccountId está sem valor (contato sem conta atrelada)
            if(String.isBlank(cont.AccountId)){continue;}           
            recentContacts.add(cont.AccountId);
        }      
        ContactTriggerService.updateAccounts(recentContacts);      
    }

    public static void afterUndeleteHandle (List<Contact> contactRecords){
        //Set para armazenar os accids
        Set<Id> recentContacts = new Set<Id>();
        for (Contact cont : contactRecords){
            //Checando se o campo AccountId está sem valor (contato sem conta atrelada)
            if(String.isBlank(cont.AccountId)){continue;}           
            recentContacts.add(cont.AccountId);
        }      
        ContactTriggerService.updateAccounts(recentContacts);
    }
}