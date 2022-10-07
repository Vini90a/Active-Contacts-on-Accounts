# Active Contacts on Accounts
## _Uma funcionalidade para a plataforma Salesforce_

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

Essa funcionalidade tem o objetivo de aprendizado para consolidar as técnicas aprendidas no curso https://www.udemy.com/course/salesforce-development/.

## Objetivo

Implementar um campo (_Active_Contact__C_) no objeto _Account_. Com a finalidade de observar o numero de contatos ativos para cada conta. 
Para determinar se a conta está ativa, foi criado um campo (_Active__C_)

## Funcionamento

Para rastrear foi criado um Trigger no objeto _Contact_ e uma classe handler desse Trigger.

Racional do Funcionamento
- Faz uma atualização do campo (Active_Contacts__c) em Account caso seja a primeira execução da classe;
- Cria um Map para guardar os Ids das Contas afetadas e soma a quantia de contatos ativos (Active__c=true);
- Faz uma requisição ao banco de dados (SOQL) com os ids das contas filtrados e guarda o valor Active_Contacts__c atual em um Map (para evitar nested loops)
- Monta uma lista de contas (List<Account>) com os valores de Id e Active_Contacts__c atualizados
- Atualiza o Banco de dados (DML)

## Autor

Vinicius Alves,
LinkedIn: https://www.linkedin.com/in/vin%C3%ADcius-alves-050806162/
TrailHead: https://trailblazer.me/id/vini90a