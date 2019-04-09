/*
 * Created by User on 29.03.2019.
 */
public with sharing class TerrUserHelper {


	public static Map<Id, Set<Id>> getUsersIdByTerritory(Map<Id, Set<Territory__c>> territoryIdWithFathersTerritory) {
		Map<Id, Set<Id>> result = new Map<Id, Set<Id>>();
		Set<Id> usersId =new Set<Id>();
		for(Id idTerritory: territoryIdWithFathersTerritory.keySet()){
			usersId = getUsersIdByTerritories(territoryIdWithFathersTerritory.get(idTerritory));
			if(!usersId.isEmpty()){
				result.put(idTerritory, usersId);
			}
		}
		return result;
	}

	private static Set<Id> getUsersIdByTerritories(Set<Territory__c> territories) {
		Set<Id> usersId = new Set<Id>();
		Set<Id> territoriesId = new Set<Id>();
		for(Territory__c elem: territories){
			territoriesId.add(elem.Id);
		}
		List<TerrUser__c> terrUsers= [SELECT Id,
							Territory__c,
							User__c
							FROM TerrUser__c
							WHERE Territory__c IN :territoriesId];
		for(TerrUser__c terrUser: terrUsers){
			if(terrUser.User__c!=null){
				usersId.add(terrUser.User__c);
			}

		}
		return usersId;
	}
}