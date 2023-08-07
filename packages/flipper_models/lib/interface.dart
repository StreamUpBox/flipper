import 'package:flipper_models/isar/receipt_signature.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';

abstract class IsarApiInterface {
  Future<List<Product>> products({required int branchId});
  Future<List<JTenant>> signup({required Map business});
  Future<Transaction?> pendingTransaction({required int branchId});
  Future<IUser> login(
      {required String userPhone, required bool skipDefaultAppSetup});
  Future<List<Business>> businesses({required int userId});
  Future<Business> getOnlineBusiness({required String userId});
  Future<List<Branch>> branches({required int businessId});
  Future<List<Stock?>> stocks({required int productId});
  Stream<Stock> stockByVariantIdStream({required int variantId});
  Stream<Transaction?> completedTransactionsStream(
      {required String status, required int branchId});
  Stream<List<Product>> productStreams({required int branchId});
  Stream<Business> businessStream({required int businessId});
  Stream<List<Discount>> discountStreams({required int branchId});
  Future<Stock?> stockByVariantId({required int variantId});
  Future<List<PColor>> colors({required int branchId});
  Future<List<Category>> categories({required int branchId});
  Stream<List<Category>> categoriesStream({required int branchId});
  Stream<Transaction?> pendingTransactionStream();
  Stream<List<Transaction>> pendingTransactionStreams();
  Future<List<IUnit>> units({required int branchId});
  Future<T?> create<T>({required T data});
  Future<T?> update<T>({required T data});

  Future<bool> delete({required int id, String? endPoint});
  Future<PColor?> getColor({required int id, String? endPoint});
  Future<Stock?> getStock({required int branchId, required int variantId});
  Future<List<Variant>> variants({
    required int branchId,
    required int productId,
  });
  Future<Variant?> variant({required int variantId});
  Future<int> addUnits<T>({required T data});

  Future<int> addVariant({
    required List<Variant> data,
    required double retailPrice,
    required double supplyPrice,
  });

  Future<int> addFavorite({required Favorite data});
  Future<List<Favorite>> getFavorites();
  Future<Favorite?> getFavoriteById({required int favId});
  Future<Favorite?> getFavoriteByProdId({required int prodId});
  Future<Favorite?> getFavoriteByIndex({required int favIndex});
  Stream<Favorite?> getFavoriteByIndexStream({required int favIndex});
  Future<int> deleteFavoriteByIndex({required int favIndex});

  Future<Product?> getProduct({required int id});
  Future<Product?> getProductByBarCode({required String barCode});
  // Future
  //this function for now figure out what is the business id on backend side.
  Future<Product> createProduct({required Product product});
  Future<Product?> isTempProductExist({required int branchId});
  Future<void> logOut();

  Future<Voucher?> consumeVoucher({required int voucherCode});

  ///create an transaction if no pending transaction exist should create a new one
  ///then if it exist should return the existing one!
  Future<Transaction> manageTransaction({
    String transactionType = 'custom',
  });

  Future<Transaction> manageCashInOutTransaction(
      {required String transactionType});

  Future<List<Transaction>> completedTransactions(
      {required int branchId, String? status = completeStatus});
  Future<TransactionItem?> getTransactionItemById({required int id});
  Stream<List<Transaction>> localCompletedTransactions();

  Future<Variant?> getCustomVariant();
  Future<Spenn> spennPayment({required double amount, required phoneNumber});
  Future<void> collectPayment(
      {required double cashReceived,
      required Transaction transaction,
      required String paymentType});

// app settings and users settings
  Future<Setting?> getSetting({required int businessId});

  Future<Setting?> createSetting({required Setting setting});
  // Stream<List<Conversation>> conversationStreamList({int? receiverId});
  // void sendMessage({required int receiverId, required Message message});
  // Stream<List<Message>> messages({required int conversationId});

  /// we treat all business as users and as contact at the same time
  /// this is because a business act as point of contact for a user
  /// and we do not to refer to the business phone number to send messages
  /// we only care about name, this deliver from our core mission that
  /// we want to make communication easy for business and users i.e customers
  ///
  Stream<List<Business>> users();
  //the method is not different from users, but users is for streaming users being added
  //to connected devices, while this method is for getting all users using List<Business>
  Stream<List<Business>> contacts();
  Future<List<Business>> getContacts();

  Future<Business?> getBusiness();
  Future<Customer?> addCustomer(
      {required Map customer, required int transactionId});
  Future assingTransactionToCustomer(
      {required int customerId, required int transactionId});
  Stream<Customer?> getCustomer({required String key});
  Stream<Customer?> getCustomerByTransactionId({required int id});

  Future<Transaction?> getTransactionById({required int id});
  Future<List<Transaction>> tickets();
  Stream<List<Transaction>> ticketsStreams();
  Stream<List<Transaction>> getTransactions();
  Stream<List<Transaction>> getLocalTransactionsStream();
  Stream<List<Transaction>> getCompletedTransactions();
  Stream<List<Transaction>> getCashInTransactions();
  Stream<List<Transaction>> getLocalCashInTransactions();
  Stream<List<Transaction>> getCashOutTransactions();
  Stream<List<Transaction>> getLocalCashOutTransactions();
  Future<List<double>> getTransactionsAmountsSum({required String period});
  Future<List<double>> getLocalTransactionsAmountsSum({required String period});
  Stream<List<Transaction>> getTransactionsByCustomerId(
      {required int customerId});
  Future<int> deleteTransactionByIndex({required int transactionIndex});

  Future<List<Variant>> getVariantByProductId({required int productId});

  Future<int> sendReport({required List<TransactionItem> transactionItems});
  Future<void> createGoogleSheetDoc({required String email});
  Future<Business?> getBusinessById({required int id});
  Future<TransactionItem?> getTransactionItemByVariantId(
      {required int variantId, required int? transactionId});
  Future<List<TransactionItem>> getTransactionItemsByTransactionId(
      {required int? transactionId});
  //abstract method to update business
  // Future<void> updateBusiness({required int id, required Map business});

  //analytics
  int lifeTimeCustomersForbranch({required int branchId});

  Future<List<Transaction>> weeklyTransactionsReport({
    required DateTime weekStartDate,
    required DateTime weekEndDate,
    required int branchId,
  });
  //save discount
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount});

  Future<List<Discount>> getDiscounts({required int branchId});

  Future<void> addTransactionItem(
      {required Transaction transaction, required TransactionItem item});

  // Conversation createConversation({required Conversation conversation});

  // Conversation? getConversationByContactId({required int contactId});
  void emptySentMessageQueue();
  bool suggestRestore();

  Future<int> userNameAvailable({required String name});

  Future<List<ITenant>> tenants({required int businessId});
  Future<ITenant?> getTenantBYUserId({required int userId});
  Future<List<ITenant>> tenantsFromOnline({required int businessId});
  Future<Business?> getBusinessFromOnlineGivenId({required int id});

  Future<void> syncProduct(
      {required Product product,
      required Variant variant,
      required Stock stock});
  bool isSubscribed({required String feature, required int businessId});
  bool subscribe({
    required String feature,
    required int businessId,
    required int agentCode,
  });
  Future<bool> checkIn({required String? checkInCode});
  Future<bool> enableAttendance(
      {required int businessId, required String email});

  Future<Profile?> profile({required int businessId});
  Future<Profile?> updateProfile({required Profile profile});
  Future<JTenant> saveTenant(String phoneNumber, String name,
      {required Business business, required Branch branch});
  Pointss addPoint({required int userId, required int point});
  Future<Subscription?> addUpdateSubscription({
    required int userId,
    required int interval,
    required double recurringAmount,
    required String descriptor,
    required List<Feature> features,
  });
  Future<Subscription?> getSubscription({required int userId});
  Future<Pointss?> getPoints({required int userId});
  void consumePoints({required int userId, required int points});
  Future<Pin?> createPin();
  Future<Pin?> getPin({required String pin});

  Future<List<Product>> productsFuture({required int branchId});

  /// get a list of transactionItems given transactionId
  Future<List<TransactionItem>> transactionItems(
      {required int transactionId, required bool doneWithTransaction});
  Stream<List<TransactionItem>> transactionItemsStream();
  Future<Variant?> getVariantById({required int id});
  Future<bool> isTaxEnabled();
  Future<Receipt?> createReceipt(
      {required ReceiptSignature signature,
      required Transaction transaction,
      required String qrCode,
      required String receiptType,
      required Counter counter});
  Future<Receipt?> getReceipt({required int transactionId});

  Future<void> refund({required int itemId});
  Future<bool> isDrawerOpen({required int cashierId});
  Future<Drawers?> getDrawer({required int cashierId});
  Future<Branch?> defaultBranch();
  Future<Business?> defaultBusiness();
  Future<Drawers?> openDrawer({required Drawers drawer});

  Future<int> size<T>({required T object});
  Future<Counter?> nSCounter({required int branchId});
  Future<Counter?> cSCounter({required int branchId});
  Future<Counter?> nRSCounter({required int branchId});
  Future<Counter?> tSCounter({required int branchId});
  Future<Counter?> pSCounter({required int branchId});
  Future<List<Counter>> unSyncedCounters({required int branchId});
  Future<void> loadCounterFromOnline({required int businessId});

  String dbPath();
  Future<Customer?> nGetCustomerByTransactionId({required int id});
  Future<bool> bindProduct({required int productId, required int tenantId});
  Future<Product?> findProductByTenantId({required int tenantId});

  Future<void> deleteAllProducts();
  Future<Stock?> getStockById({required int id});

  /// socials methods
  Stream<Social> socialsStream({required int branchId});
  Future<Social?> getSocialById({required int id});

  Future<List<BusinessType>> businessTypes();

  /// list messages
  Stream<List<Conversation>> conversations({String conversationId});
  Future<void> sendScheduleMessages();
  Future<Conversation?> getConversation({required String messageId});
  Future<List<Conversation>> getScheduleMessages();
  Future<int> registerOnSocial({String phoneNumberOrEmail, String password});
  Future<SocialToken> loginOnSocial(
      {String phoneNumberOrEmail, String password});
  Future<bool> isTokenValid(
      {required String tokenType, required int businessId});

  Stream<List<Conversation>> getTop5RecentConversations();

  //
  Future<void> patchSocialSetting({required Setting setting});
  Future<Setting?> getSocialSetting();

  Future<Device?> getDevice({required String phone});
  Future<Device?> getDeviceById({required int id});
  Stream<List<Device>> getDevices({required int businessId});
  Future<List<Device>> unpublishedDevices({required int businessId});
  Future<void> loadConversations(
      {required int businessId, int? pageSize = 10, String? pk, String? sk});
  Future<bool> updateContact(
      {required Map<String, dynamic> contact, required int businessId});

  Future<List<Social>> activesocialAccounts({required int branchId});

  Future<Stock?> addStockToVariant({required Variant variant});
  Stream<Product> getProductStream({required int prodIndex});
  Stream<List<Variant>> geVariantStreamByProductId({required int productId});

  Future<
      ({
        List<Stock> stocks,
        List<Variant> variants,
        List<Product> products,
        List<Favorite> favorites,
        List<Device> devices,
        List<Transaction> transactions,
        List<TransactionItem> transactionItems
      })> getUnSyncedData();
  Future<Conversation> sendMessage(
      {required String message, required Conversation latestConversation});
  Future<EBM?> getEbmByBranchId({required int branchId});
}
