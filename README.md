# Active Contacts on Accounts
## _Uma funcionalidade para a plataforma Salesforce_

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

Essa funcionalidade tem o objetivo de aprendizado para consolidar as técnicas aprendidas no curso https://www.udemy.com/course/salesforce-development/.

## Objetivo

Implementar um campo (_Active_Contact__C_) no objeto _Account_. Com a finalidade de observar o numero de contatos ativos para cada conta. 
Para determinar se a conta está ativa, foi criado um campo (_Active__C_)

## Funcionamento

Para rastrear foi criado um Trigger no objeto _Contact_ , uma classe handler desse Trigger; 
E afim de evitar repetições de códigos e aumentar a legibilidade dele, foi criada outra classe _ContactTriggerService_. Classe responsável por receber um Set<Id> com os Ids das Accounts que serão atualizadas

Racional do Funcionamento
- Faz uma atualização do campo (Active_Contacts__c) em Account caso seja a primeira execução da classe;
- Verifica se o campo AccountId do contato inserido não está vazio e o campo alterado foi o de contato ativo
- Chama a classe Contact TriggerService para atualizar o banco de dados (DML)


## Autor

Vinicius Alves,
LinkedIn: https://www.linkedin.com/in/vin%C3%ADcius-alves-050806162/
TrailHead: https://trailblazer.me/id/vini90a