// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * VISIBILITY MODIFIERS = OFFICE BUILDING ACCESS LEVELS
 *
 * 🌍 PUBLIC = Lobby/Reception (Anyone can enter and see)
 * 🏢 EXTERNAL = Main entrance (Only visitors from outside)
 * 🏠 INTERNAL = Company floors (Employees and subsidiaries)
 * 🔒 PRIVATE = CEO's private office (Only this specific person)
 */
contract OfficeBuilding {
    // ==========================================
    // STATE VARIABLES WITH DIFFERENT VISIBILITY
    // (Like different types of information boards)
    // ==========================================

    // 🌍 PUBLIC STATE VARIABLES = Lobby Information Board
    // Anyone can read this (creates automatic getter function)
    string public companyName; // Like company sign in lobby
    address public ceoAddress; // Like "CEO: John Smith" on wall
    uint256 public totalEmployees; // Like employee counter display

    // 🏠 INTERNAL STATE VARIABLES = Employee Bulletin Board
    // Only this company and its subsidiaries can see
    uint256 internal monthlyRevenue; // Like internal financial reports
    mapping(address => bool) internal isEmployee; // Like employee directory

    // 🔒 PRIVATE STATE VARIABLES = CEO's Personal Notes
    // Only this specific contract can access
    string private ceoPassword; // Like CEO's personal diary
    uint256 private secretBudget; // Like confidential budget info
    mapping(address => uint256) private employeeSalaries; // Like private payroll

    // Note: EXTERNAL doesn't exist for state variables!
    // (State variables can't be "external" - doesn't make sense)

    // ==========================================
    // CONSTRUCTOR VISIBILITY
    // Constructors are SPECIAL - they run once during "building construction"
    // ==========================================

    // Constructors DON'T need visibility keywords in modern Solidity
    // They're automatically "internal" (only called during deployment)
    constructor(string memory _companyName, address _ceoAddress) {
        // Setting up the building during construction
        companyName = _companyName; // Public info anyone can see
        ceoAddress = _ceoAddress; // Public CEO info
        totalEmployees = 0; // Start with no employees

        // Private setup (only this contract knows)
        ceoPassword = "secret123"; // CEO's private info
        secretBudget = 1000000; // Confidential budget

        // Internal setup (company and subsidiaries know)
        monthlyRevenue = 50000;
    }

    // ==========================================
    // FUNCTION VISIBILITY EXAMPLES
    // ==========================================

    // 🌍 PUBLIC FUNCTIONS = Lobby Services
    // Anyone can call from anywhere (inside contract OR outside)
    function getCompanyInfo() public view returns (string memory, uint256) {
        // Like asking receptionist for basic company info
        // Both employees AND visitors can ask this
        return (companyName, totalEmployees);
    }

    function hireEmployee(address _newEmployee) public {
        // Like public HR desk - anyone can recommend someone for hiring
        // Can be called by other contracts OR from inside this contract

        if (!isEmployee[_newEmployee]) {
            isEmployee[_newEmployee] = true;
            totalEmployees++;

            // Call internal function from public function
            _updateEmployeeRecords(_newEmployee);
        }
    }

    // 🏢 EXTERNAL FUNCTIONS = Main Entrance (Visitors Only)
    // Only called from OUTSIDE the contract (like visitors to building)
    function submitJobApplication(string calldata _applicantName, uint256 _experience) external {
        // Like job application desk - only for people coming from outside
        // Cannot be called by functions inside this contract

        // Process application (external visitors only)
        if (_experience >= 5) {
            // Qualified applicant
            _processApplication(_applicantName); // Call internal helper
        }
    }

    function receivePayment() external payable {
        // Like payment window - only for external customers
        // Internal functions can't call this directly

        require(msg.value > 0, "Must send payment");
        // Process external payment
    }

    // 🏠 INTERNAL FUNCTIONS = Employee Areas
    // Only this company and its "subsidiary contracts" can access
    function _updateEmployeeRecords(address _employee) internal {
        // Like employee break room - only company staff allowed
        // Can be called by this contract AND contracts that inherit from it

        isEmployee[_employee] = true;

        // Set default salary (internal company business)
        employeeSalaries[_employee] = 50000;
    }

    function _calculateBonus(address _employee) internal view returns (uint256) {
        // Like internal payroll calculations
        // Only this company and subsidiaries can do this calculation

        if (isEmployee[_employee]) {
            return employeeSalaries[_employee] / 10; // 10% bonus
        }
        return 0;
    }

    function _processApplication(string memory _name) internal {
        // Internal HR process - only company staff can do this
        totalEmployees++; // Increment counter

        // Could do more internal processing here...
    }

    // 🔒 PRIVATE FUNCTIONS = CEO's Private Office
    // ONLY this specific contract can access (not even subsidiaries)
    function _updateCEOPassword(string memory _newPassword) private {
        // Like CEO's private office - absolutely no one else allowed
        // Even subsidiary companies can't access this

        ceoPassword = _newPassword;
    }

    function _adjustSecretBudget(uint256 _amount) private {
        // CEO's personal financial decisions
        // Most restricted access level

        secretBudget += _amount;
    }

    // ==========================================
    // PRACTICAL EXAMPLES SHOWING WHEN TO USE EACH
    // ==========================================

    // 🌍 PUBLIC: When you want maximum accessibility
    function getPublicStats() public view returns (uint256) {
        // Both internal functions AND external callers can use this
        return totalEmployees;
    }

    // 🏢 EXTERNAL: When only outsiders should call
    function customerService(string calldata _complaint) external {
        // Only for external customers, not internal employee complaints
        // More gas efficient than public for external-only functions

        // Process customer complaint
        // NOTE: Internal functions cannot call this!
    }

    // 🏠 INTERNAL: When you want inheritance-friendly functions
    function _sharedBusinessLogic() internal {
        // Subsidiary companies (inherited contracts) can use this
        // But external contracts cannot

        monthlyRevenue += 1000;
    }

    // 🔒 PRIVATE: When you want maximum security
    function _topSecretOperation() private {
        // Absolutely no one else can access this
        // Even subsidiary companies are locked out

        secretBudget *= 2; // CEO's secret financial move
    }

    // ==========================================
    // DEMONSTRATING CALLING PATTERNS
    // ==========================================

    function demonstrateInternalCalls() public {
        // PUBLIC function can call:

        // ✅ Other public functions
        getPublicStats();

        // ✅ Internal functions
        _updateEmployeeRecords(msg.sender);

        // ✅ Private functions
        _topSecretOperation();

        // ❌ Cannot call external functions directly!
        // customerService("test");  // This would ERROR

        // To call external function from inside, use this:
        this.customerService("internal complaint"); // Workaround (expensive)
    }

    // ==========================================
    // GETTER FUNCTIONS FOR PRIVATE/INTERNAL DATA
    // ==========================================

    // Since private/internal variables can't be accessed directly,
    // create public getters when needed

    function getMonthlyRevenue() public view returns (uint256) {
        // Public access to internal data (controlled exposure)
        return monthlyRevenue;
    }

    function getEmployeeSalary(address _employee) public view returns (uint256) {
        // Controlled access to private salary data
        require(msg.sender == ceoAddress, "Only CEO can view salaries");
        return employeeSalaries[_employee];
    }

    // ==========================================
    // BEST PRACTICES EXAMPLES
    // ==========================================

    // ✅ GOOD: External for user-facing functions
    function makeDeposit() external payable {
        // Users call this from outside
        require(msg.value > 0, "Must send ETH");
    }

    // ✅ GOOD: Public for functions used both ways
    function checkBalance(address _user) public view returns (uint256) {
        // Both internal logic AND external users might need this
        return address(_user).balance;
    }

    // ✅ GOOD: Internal for shared logic with inheritance
    function _validateUser(address _user) internal view returns (bool) {
        // Subsidiary contracts might need this validation
        return isEmployee[_user];
    }

    // ✅ GOOD: Private for sensitive internal operations
    function _handleCriticalSecurity() private {
        // Absolutely no one else should access this
        // Not even inherited contracts
    }
}

/**
 * 🏢 COMPLETE OFFICE BUILDING ANALOGY SUMMARY:
 *
 * 📊 STATE VARIABLES:
 * 🌍 PUBLIC = Lobby info board (anyone can read, auto-getter created)
 * 🏠 INTERNAL = Employee bulletin (this company + subsidiaries)
 * 🔒 PRIVATE = CEO's personal notes (only this contract)
 * ❌ EXTERNAL = Doesn't exist for state variables
 *
 * 🎯 FUNCTIONS:
 * 🌍 PUBLIC = Lobby services (anyone, anywhere can call)
 * 🏢 EXTERNAL = Visitor entrance (only outsiders can call)
 * 🏠 INTERNAL = Employee areas (this contract + inherited contracts)
 * 🔒 PRIVATE = CEO office (only this specific contract)
 *
 * 🏗️ CONSTRUCTOR:
 * ✅ Modern Solidity: No visibility keyword needed
 * ✅ Automatically "internal" (only called during deployment)
 * ❌ Don't use public/private/external on constructors
 *
 * 🔑 WHEN TO USE EACH:
 *
 * 🌍 Use PUBLIC when:
 * - Need access from both inside AND outside
 * - Want automatic getter for state variables
 * - General-purpose functions
 *
 * 🏢 Use EXTERNAL when:
 * - Only external callers should use it
 * - More gas efficient than public for external-only
 * - User-facing functions, API endpoints
 *
 * 🏠 Use INTERNAL when:
 * - Helper functions for this contract + inherited contracts
 * - Shared business logic
 * - Data that subsidiaries should access
 *
 * 🔒 Use PRIVATE when:
 * - Maximum security needed
 * - Sensitive operations
 * - Implementation details no one else should see
 *
 * 💡 GOLDEN RULE:
 * Start with the most restrictive (private), then open up as needed!
 * Like office security: Give minimum access required, expand only when necessary.
 */
