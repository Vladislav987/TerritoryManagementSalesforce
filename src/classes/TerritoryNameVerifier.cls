/*
 * Created by User on 26.03.2019.+
 */
public with sharing class TerritoryNameVerifier {
	public static void checkUniqueName(List<Territory__c> newRecords){

		// divide  territories with children and without children

		List<Territory__c> territoriesWithoutParent = new List<Territory__c>();
		List<Territory__c> territoriesWhitParent = new List<Territory__c>();
		Set<Id> parentTerritoryIds = new Set<Id>();

		for(Territory__c elem: newRecords){
			if(elem.ParentId__c != null){
				territoriesWhitParent.add(elem);
				parentTerritoryIds.add(elem.ParentId__c);

			}else{
				territoriesWithoutParent.add(elem);
			}
		}

		// check the names of territories, if there is such a name at the level, we display an error

		if(!territoriesWhitParent.isEmpty()){
			Map<Id, Territory__c> allTerritoryWithParents = getChildTerritoryByParent(parentTerritoryIds);
			if(!allTerritoryWithParents.isEmpty()) {
				for (Territory__c elem : newRecords) {
					compareNamesOfTerritories(elem, allTerritoryWithParents.get(elem.ParentId__c).Territory__r);
				}
			}
		}

		if (!territoriesWithoutParent.isEmpty()){
			List<Territory__c> territoriesWithoutChild = getTerritoriesWithoutChild();
			for(Territory__c elem: territoriesWithoutParent){
				compareNamesOfTerritories(elem, territoriesWithoutChild);
			}
		}
	}



	private static Map<Id,Territory__c> getChildTerritoryByParent(Set<Id> parentTerritory){
		return new Map<Id,Territory__c>([
				Select id,
            Name,
            (SELECT Name, ParentId__c FROM Territory__r)
            FROM Territory__c
            Where Id IN :parentTerritory
		]);
	}

	private static void compareNamesOfTerritories(Territory__c newTerritory, List<Territory__c> oldTerritories){
		for(Territory__c elem: oldTerritories){
			if(newTerritory.Name == elem.Name){
				newTerritory.addError('You can`t add this Territory' +
														', because you already have such territory on this level');
			}
		}
	}

	private static List<Territory__c> getTerritoriesWithoutChild(){
		return [
			SELECT
				Name
			FROM Territory__c
			WHERE ParentId__c = null
		];
	}

}