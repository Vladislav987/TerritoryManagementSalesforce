/*
 * Created by User on 28.03.2019.+
 */
public with sharing class ReferenceHelper {

	public static List<Reference__c> getReferencesByAccountsId(Set<Id> accountIds) {
		return [SELECT Contact__c,
								Account__c
				FROM Reference__c
				WHERE Account__c IN :accountIds
		];
	}

	public static List<Account> getAccountByTerritoriesId(Set<Id> territoriesId){
		return [SELECT Id,
					Name,
					Territory__c,
			   (SELECT Account__c, Contact__c FROM Referenses__r)
				FROM Account
				WHERE Territory__c IN:territoriesID
		];
	}
}