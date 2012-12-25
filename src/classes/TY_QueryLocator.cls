public with sharing class TY_QueryLocator {
	protected ApexPages.StandardSetController ssc {get; set;}
	public List<Contact> contacts { get; private set;}
	private Datetime lastExecuteQuery;
	public TY_QueryLocator(){
		this.contacts = searchContact(1);
	}
	/* ページング関連 */
	public List<Contact> searchContact(Integer pageNumber){
		this.ssc = new ApexPages.StandardSetController(Database.getQueryLocator('select id,Name from Contact limit 10000'));
		this.ssc.setpageNumber(pageNumber); // ページ番号の設定
		this.lastExecuteQuery = system.now(); // Query実行時間の取得
		return (List<Contact>) this.ssc.getRecords();
	}
	/* タイムアウト回避 */
	public void escapeTimeoutError(){
		// 前回のQuery実行から13分経過していたら、QueryLocatorを再取得
		if(lastExecuteQuery.addMinutes(13) < system.now()){
			Integer pageNumber = this.ssc.getPageNumber(); // 現在のページ番号を取得
			this.contacts = searchContact(pageNumber); // 現在のページのContactリストを再取得
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'TimeOutのため再度読み込みました。:' + pageNumber));
		}
	}
	/* 「次へ」表示制御用 */
	public Boolean getHasNextUsers(){
		return this.ssc != null ? this.ssc.getHasNext() : false;
	}
	/* 「前へ」表示制御用 */
	public Boolean getHasPrevUsers(){
		return this.ssc != null ? this.ssc.getHasPrevious() : false;
	}
	/* 「前へ」 */
	public PageReference pagingPrev(){
        escapeTimeoutError();
        this.ssc.previous();
		this.contacts = (List<Contact>) this.ssc.getRecords();
        return null;
	}
	/* 「次へ」 */
	public PageReference pagingNext(){
        escapeTimeoutError();
        this.ssc.next();
		this.contacts = (List<Contact>) this.ssc.getRecords();
        return null;
	}
}