/*
 * Created by User on 01.04.2019.+
 */
public class ContactHandler {
	public static void onBeforeInsert(List<Contact> contacts){
		String fakeAccountId = getFakeAccountId();

		for(Contact elem: contacts){
			if(elem.AccountId == null){
				elem.AccountId = fakeAccountId;
			}
		}
	}

	private static String getFakeAccountId(){
		List<Account> fakeAccount = [
				SELECT Id,
				Name
				FROM Account
				WHERE Name = 'FA'
		LIMIT 1
		];
		if(fakeAccount.isEmpty()){
			Account newFakeAccount = new Account(Name = 'FA');
			fakeAccount.add(newFakeAccount);
			insert fakeAccount;
		}
		return fakeAccount[0].Id;
	}

}