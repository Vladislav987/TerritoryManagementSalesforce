/*
 * Created by User on 28.03.2019.+
 */
public with sharing class ShareHelperForAccounts {

		public static AccountShare createAccountShareByUserIdAndAccountId(Id userId, Id accountId){
			AccountShare accountShare = new AccountShare();

			accountShare.AccountId = accountId;
			accountShare.UserOrGroupId = userId;
			accountShare.AccountAccessLevel = 'Edit';
			accountShare.ContactAccessLevel = 'None';
			accountShare.OpportunityAccessLevel ='None';
			accountShare.CaseAccessLevel = 'None';

			return accountShare;
		}

	public static void deleteAccountsSharesByUsersIdAndAccountsId(Set<Id> usersId, Set<Id> accountsId){
		List<AccountShare> accountShares = [
					SELECT Id,
					UserOrGroupId,
					AccountId,
					RowCause
					FROM AccountShare
					WHERE UserOrGroupId IN:usersId
					AND AccountId IN:accountsId
					AND RowCause ='Manual'
		];

		if(!accountShares.isEmpty()){
			delete accountShares;
		}
	}
}