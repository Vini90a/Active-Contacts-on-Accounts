/**
* contactTriggerHandle
* Classe para controlar o trigger em Contato 
* Atualiza um campo em Account (Active_Contacts__c) que mostra os contatos ativos atrelados a aquela conta
* @author ViniAlves
*/
public class contactTriggerHandle {

    public static Boolean firtInsertion = true;
            
     /**
     * afterInsertHandle
     * Racional do funcionamento: 
     * 	- Faz uma atualização do campo (Active_Contacts__c) em Account caso seja a primeira execução da classe
     *  - Cria um Map para guardar os Ids das Contas afetadas e soma a quantia de contatos ativos (Active__c=true)
     * 	- Faz uma requisição ao banco de dados (SOQL) com os ids das contas filtrados e guarda o valor Active_Contacts__c atual em um Map
     * 	- Monta uma lista de contas (List<Account>) com os valores de Id e Active_Contacts__c atualizados
     * 	- Atualiza o Banco de dados
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
        
        //Map para armazenar os accids e quantidades de contatos ativos para cada Id
        Map<Id, Integer> recentContacts = new Map<Id, Integer>();
        for (Contact cont : contactRecords){
            //Checando se o campo AccountId está sem valor (contato sem conta atrelada)
            if(String.isBlank(cont.AccountId) ||cont.Active__c==false){continue;}
            
            if(!recentContacts.containsKey(cont.AccountId)){
                recentContacts.put(cont.AccountId, 0);
            }            
            recentContacts.put(cont.AccountId, recentContacts.get(cont.AccountId)+1);
        }
        
        //Map para guardar as contas e seus valores anteriores de Active_Contacts__c        
        Map<Id, Integer> existingActiveAcc = new Map<Id, Integer>();
        for (Account acc : [SELECT Id, Active_Contacts__c FROM Account WHERE Id IN:recentContacts.keySet()]){
            existingActiveAcc.put(acc.Id, (Integer)acc.Active_Contacts__c);
        }       
		
        //Montando a lista para atualizar os valores das contas (valores antigos + valores adicionados novos)
		List<Account> accToUpdate = new List<Account>();        
        for (Id accIds : recentContacts.keySet()){
            Integer activeContacts =  existingActiveAcc.get(accIds)+recentContacts.get(accIds);
            accToUpdate.add(new Account(Id=accIds, Active_Contacts__c = activeContacts));
        }
        update accToUpdate;
    }
    
    
    public static void afterUpdateHandle (List<Contact> contactRecords, Map<Id, Contact> oldRecordsMap){     	
        //Map para armazenar os accids e quantidades de contatos ativos para cada Id
        Map<Id, Integer> recentContacts = new Map<Id, Integer>();
        for (Contact cont : contactRecords){
            //Checando se o campo AccountId está sem valor (contato sem conta atrelada)
            if(String.isBlank(cont.AccountId)){continue;}
            
            if(!recentContacts.containsKey(cont.AccountId)){
                recentContacts.put(cont.AccountId, 0);
            }
            if (cont.Active__c==true && oldRecordsMap.get(cont.Id).Active__c==false){
                recentContacts.put(cont.AccountId, recentContacts.get(cont.AccountId)+1);
            }
            else if (cont.Active__c==false && oldRecordsMap.get(cont.Id).Active__c==true){
                recentContacts.put(cont.AccountId, recentContacts.get(cont.AccountId)-1);
            }                        
        }
        //Map para guardar as contas e seus valores anteriores de Active_Contacts__c  
        Map<Id, Integer> existingActiveAcc = new Map<Id, Integer>();
        for (Account acc : [SELECT Id, Active_Contacts__c FROM Account WHERE Id IN:recentContacts.keySet()]){
            existingActiveAcc.put(acc.Id, (Integer)acc.Active_Contacts__c);
        }
        //Montando a lista para atualizar os valores das contas (valores antigos + valores adicionados novos)
		List<Account> accToUpdate = new List<Account>();        
        for (Id accIds : recentContacts.keySet()){
            Integer activeContacts =  existingActiveAcc.get(accIds)+recentContacts.get(accIds);
            accToUpdate.add(new Account(Id=accIds, Active_Contacts__c = activeContacts));
        }
        update accToUpdate;
    }    
}