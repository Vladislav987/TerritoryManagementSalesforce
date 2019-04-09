/*
 * Created by User on 29.03.2019.+-
 */
public with sharing class TerrUserHandler {

	public static void insertNewAccountsAndContactsShares(List<TerrUser__c> newTerrUser) {
		List<AccountShare> accountsShares = new List<AccountShare>();
		List<ContactShare> contactsShares = new List<ContactShare>();
		Map<Id, Set<Id>> usersIdWithTerritoryIncludeChildren = new Map<Id, Set<Id>>();

		for (TerrUser__c terrUser : newTerrUser) {
			if (usersIdWithTerritoryIncludeChildren.containsKey(terrUser.User__c)) {
				usersIdWithTerritoryIncludeChildren.get(terrUser.User__c).add(terrUser.Territory__c);
			} else {
				if (terrUser.User__c != null) {
					usersIdWithTerritoryIncludeChildren.put(terrUser.User__c, new Set<Id>{terrUser.Territory__c});
				}
			}

			for (Id userId : usersIdWithTerritoryIncludeChildren.keySet()) {
				Set<Id> territoriesIdIncludeChildren = new Set<Id>();
				territoriesIdIncludeChildren =
						TerritoryHelper.getAllTerritoriesWithChildrenByTerritoriesId(usersIdWithTerritoryIncludeChildren.get(userId));
				System.debug(territoriesIdIncludeChildren);

				usersIdWithTerritoryIncludeChildren.put(userId, territoriesIdIncludeChildren);

				List<Account> accounts = ReferenceHelper.getAccountByTerritoriesId(usersIdWithTerritoryIncludeChildren.get(userId));
				for (Account account : accounts) {
					accountsShares.add(ShareHelperForAccounts.createAccountShareByUserIdAndAccountId(userId, account.Id));
					contactsShares.addAll(ShareHelperForContacts.createContactsSharesByUsersIdAndReferences(userId, account.Referenses__r));
				}

			}

			//Переместить ниже

/*
			if (!accountsShares.isEmpty()) {
				insert accountsShares;
				if (!contactsShares.isEmpty()) {
					insert contactsShares;
				}
			}
*/
		}
		if (!accountsShares.isEmpty()) {
			insert accountsShares;
			if (!contactsShares.isEmpty()) {
				insert contactsShares;
			}
		}

	}


	public static void deleteOldAccountsAndContactsShares(List<TerrUser__c> oldTerrUser) {
		Set<Id> accountsIdByTerritory = new Set<Id>();
		Set<Id> contactsIdByAccount = new Set<Id>();
		Map<Id, Set<Id>> usersIdWithTerritoryIncludeChildren = new Map<Id, Set<Id>>();

		for (TerrUser__c elem : oldTerrUser) {
			if (usersIdWithTerritoryIncludeChildren.containsKey(elem.User__c)) {
				usersIdWithTerritoryIncludeChildren.get(elem.User__c).add(elem.Territory__c);
			} else {
				usersIdWithTerritoryIncludeChildren.put(elem.User__c, new Set<Id>{elem.Territory__c});
			}


			for (Id userId : usersIdWithTerritoryIncludeChildren.keySet()) {
				Set<Id> territoriesIdIncludeChildren = new Set<Id>();
				territoriesIdIncludeChildren =
						TerritoryHelper.getAllTerritoriesWithChildrenByTerritoriesId(usersIdWithTerritoryIncludeChildren.get(userId));
				System.debug(territoriesIdIncludeChildren);

				usersIdWithTerritoryIncludeChildren.put(userId, territoriesIdIncludeChildren);

				List<Account> accountsByTerritory = ReferenceHelper.getAccountByTerritoriesId(usersIdWithTerritoryIncludeChildren.get(userId));
				for (Account account: accountsByTerritory){
					accountsIdByTerritory.add(account.Id);
					for(Reference__c reference: account.Referenses__r){
						contactsIdByAccount.add(reference.Contact__c);
					}
				}
			}

			ShareHelperForAccounts.deleteAccountsSharesByUsersIdAndAccountsId(usersIdWithTerritoryIncludeChildren.keySet(), accountsIdByTerritory);
			ShareHelperForContacts.deleteContactsSharesByUsersIdAndContactsId(usersIdWithTerritoryIncludeChildren.keySet(), contactsIdByAccount);

		}
	}
}
