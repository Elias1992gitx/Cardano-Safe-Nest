class Config{
  static const apiUrl = 'nd-server-production.up.railway.app';
  static const String loginUrl = '/api/v1/login';
  static const String signUpUrl = '/api/v1/register';
  static const String forgotPasswordUrl = '/api/v1/update-user-password';
  static const String activateUserUrl = '/api/v1/activate-user';
  static const String logoutUrl = '/api/v1/logout';
  static const String socialAuth = '/api/v1/social-auth';
  static const String refreshTokenUrl = '/api/v1/refresh-token';
  static const String getCurrentUserUrl = '/api/v1/me';
  static const String updateCurrentUserUrl = '/api/v1/update-user-info';

  // Financial Institute
  static const String getFinancialInstituteByIdUrl = '/api/v1/get-financial-institute';
  static const String getAllFinancialInstitutesUrl = '/api/v1/get-all-financial-institute';
  static const String getFinancialInstitutesByInvestmentCountUrl = '/api/v1/get-by-investment-count';
  static const String getFinancialInstitutesByDealCountUrl = '/api/v1/get-by-deal-count';
  static const String getTopFinancialInstitutesByDealCountUrl = '/api/v1/get-top-by-deal-count';

  // Investment
  static const String getInvestmentByIdUrl = '/api/v1/get-investment';
  static const String getInvestmentsByUserInterestUrl = '/api/v1/user-investment-interests';
  static const String getActiveInvestmentsByCreditScoreUrl = '/api/v1/active-investment';
  static const String getInvestmentsBySectorUrl = '/api/v1/investment-by-sector';
  static const String getInvestmentsDetail = '/api/v1/investment-detail';
}
