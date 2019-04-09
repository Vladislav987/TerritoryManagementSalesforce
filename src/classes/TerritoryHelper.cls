/*
 * Created by User on 28.03.2019.+
 */
public with sharing class TerritoryHelper {

	public static List<Territory__c> getChildrenTerritoryByParent(Set<Id> parentsId){
		return [SELECT Id,
						Name,
						ParentId__c,
		   	   (SELECT Id FROM Territory__r)
				FROM Territory__c
				WHERE Id In:parentsId
		];
	}

	public static Set<Id> getAllTerritoriesWithChildrenByTerritoriesId(Set<Id> parentTerritoriesId) {
		Set<Id> allTerritories = new Set<Id>(parentTerritoriesId);
		Set<Id> parentId = new Set<Id>(parentTerritoriesId);

		while (!parentId.isEmpty()){
			List<Territory__c> childrenTerritories = getChildrenTerritoryByParent(parentId);
			parentId.clear();
			for(Territory__c elem: childrenTerritories){
				allTerritories.add(elem.Id);
				for (Territory__c childTerritory: elem.Territory__r){
					parentId.add(childTerritory.Id);
				}
			}
		}

		return allTerritories;
	}



	public static Map<Id,Set<Territory__c>> getTerritoriesWithParentsByAccount(List<Account> accounts) {

		Map<Id, Set<Territory__c>> accountsIdWithUpperHierarchyOfTerritories = new Map<Id, Set<Territory__c>>();
		Map<Id, Id> accountsIdWithTerritoryId= new Map<Id, Id>();

		for(Account account: accounts) {
			if (account.Territory__c != null) {
				accountsIdWithTerritoryId.put(account.Id, account.Territory__c);
			}
		}

		accountsIdWithUpperHierarchyOfTerritories = getTerritoriesWithParentsByChild(accountsIdWithTerritoryId);

		return accountsIdWithUpperHierarchyOfTerritories;
	}

	private static Map<Id, Set<Territory__c>> getTerritoriesWithParentsByChild(Map<Id, Id> territories) {
		Map<Id, Set<Territory__c>> result = new Map<Id, Set<Territory__c>>();
		Set<Territory__c> territoriesWithParents = new Set<Territory__c>();

		for(Id accountId: territories.keySet()){
			territoriesWithParents = getUpperTerritoriesHierarchy(territories.get(accountId));
			result.put(accountId, territoriesWithParents);
		}

		return result;
	}



	public static Set<Territory__c> getUpperTerritoriesHierarchy(Id territory) {
		Set<Territory__c> result = new Set<Territory__c>();
		Id parentId = territory;

		while (parentId!=null) {
			Territory__c territoriesInOneLevel = [ SELECT Id,
															Name,
			 												ParentId__r.ParentId__c,
			 									   (SELECT User__c FROM TerrUsers__r)
												    FROM Territory__c
													WHERE Id = :parentId
													LIMIT 1
			];

				if(territoriesInOneLevel.TerrUsers__r!=null){
					result.add(territoriesInOneLevel);
				}
				parentId = territoriesInOneLevel.ParentId__c;
		}
		return result;
	}
}