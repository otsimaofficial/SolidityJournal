// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
contract ClassroomSetup {
    // ==========================================
    // 1. CUSTOM TYPES FIRST (Like basic building blocks)
    // These are like defining what shapes and colors exist
    // before you start building with them
    // ==========================================

    // ENUMS - Define your multiple choice options first
    // Like deciding what grade levels your school will have
    enum StudentLevel {
        Beginner, // 0
        Intermediate, // 1
        Advanced // 2
    }

    enum ClassStatus {
        NotStarted, // 0
        InProgress, // 1
        Completed // 2
    }

    // STRUCTS - Define your data templates
    // Like creating a student ID card template before making actual IDs
    struct Student {
        string name;
        uint256 age;
        StudentLevel level;
        bool isActive;
        uint256 enrollmentDate;
    }

    struct Course {
        string courseName;
        address instructor;
        uint256 maxStudents;
        ClassStatus status;
    }

    // ==========================================
    // 2. EVENTS (Like designing your announcement system)
    // Define what kinds of announcements you'll make
    // These go early because functions will reference them
    // ==========================================

    event StudentEnrolled(
        address indexed student,
        string name,
        StudentLevel level
    );
    event GradeAssigned(address indexed student, uint256 grade);
    event CourseCreated(uint256 indexed courseId, string courseName);
    event ClassStatusChanged(uint256 indexed courseId, ClassStatus newStatus);

    // ==========================================
    // 3. CUSTOM ERRORS (Like defining your warning messages)
    // More gas-efficient than require() messages
    // ==========================================

    error NotAuthorized(address caller);
    error StudentNotFound(address student);
    error CourseIsFull(uint256 courseId);
    error InvalidLevel(StudentLevel provided);

    // ==========================================
    // 4. STATE VARIABLES (Like your classroom furniture and supplies)
    // The permanent "memory" of your contract
    // ==========================================

    // CONSTANTS first (Like school rules that never change)
    uint256 public constant MAX_STUDENTS_PER_CLASS = 30;
    string public constant SCHOOL_NAME = "Solidity Academy";
    uint256 public constant PASSING_GRADE = 70;

    // IMMUTABLE variables (Set once during construction)
    address public immutable SCHOOL_DISTRICT;
    uint256 public immutable FOUNDING_DATE;

    // Regular state variables (Like changeable classroom items)
    address public principal; // Who's in charge
    uint256 public totalStudents; // Current student count
    uint256 public nextCourseId; // ID counter for new courses
    bool public isSchoolOpen; // Is school accepting students?

    // ==========================================
    // 5. MAPPINGS (Like your filing cabinets and record books)
    // These reference the structs and enums defined above
    // ==========================================

    // Simple mappings
    mapping(address => uint256) public studentGrades;
    mapping(address => bool) public isEnrolled;
    mapping(uint256 => address) public courseInstructors;

    // Complex mappings using our custom types
    mapping(address => Student) public students;
    mapping(uint256 => Course) public courses;
    mapping(address => StudentLevel) public studentLevels;

    // Nested mappings (Like cross-reference tables)
    mapping(uint256 => mapping(address => bool)) public courseEnrollments; // courseId => student => enrolled
    mapping(address => uint256[]) public studentCourses; // student => array of courseIds

    // ==========================================
    // 6. ARRAYS (Like class lists and rosters)
    // ==========================================

    address[] public allStudents;
    uint256[] public activeCourses;

    // ==========================================
    // 7. MODIFIERS (Like security guards and rule checkers)
    // These come after state variables because they reference them
    // ==========================================

    modifier onlyPrincipal() {
        if (msg.sender != principal) {
            revert NotAuthorized(msg.sender);
        }
        _; // Continue with the function
    }

    modifier onlyWhenOpen() {
        require(isSchoolOpen, "School is currently closed");
        _;
    }

    modifier validStudent(address _student) {
        if (!isEnrolled[_student]) {
            revert StudentNotFound(_student);
        }
        _;
    }

    modifier validLevel(StudentLevel _level) {
        if (uint8(_level) > 2) {
            // Since we have 3 levels (0,1,2)
            revert InvalidLevel(_level);
        }
        _;
    }

    // ==========================================
    // 8. CONSTRUCTOR (The grand opening setup)
    // ==========================================

    constructor(address _schoolDistrict) {
        principal = msg.sender;
        SCHOOL_DISTRICT = _schoolDistrict;
        FOUNDING_DATE = block.timestamp;
        isSchoolOpen = true;
        totalStudents = 0;
        nextCourseId = 1;
    }

    // ==========================================
    // 9. FUNCTIONS (All the activities and operations)
    // ==========================================

    function enrollStudent(
        string memory _name,
        uint256 _age,
        StudentLevel _level
    ) public onlyWhenOpen validLevel(_level) {
        students[msg.sender] = Student({
            name: _name,
            age: _age,
            level: _level,
            isActive: true,
            enrollmentDate: block.timestamp
        });

        isEnrolled[msg.sender] = true;
        studentLevels[msg.sender] = _level;
        allStudents.push(msg.sender);
        totalStudents++;

        emit StudentEnrolled(msg.sender, _name, _level);
    }

    function createCourse(
        string memory _courseName,
        address _instructor,
        uint256 _maxStudents
    ) public onlyPrincipal returns (uint256) {
        uint256 courseId = nextCourseId;

        courses[courseId] = Course({
            courseName: _courseName,
            instructor: _instructor,
            maxStudents: _maxStudents,
            status: ClassStatus.NotStarted
        });

        courseInstructors[courseId] = _instructor;
        activeCourses.push(courseId);
        nextCourseId++;

        emit CourseCreated(courseId, _courseName);
        return courseId;
    }

    // More functions would go here...
}
contract ContractSections {
    // ==== SECTION 1: DECLARATIONS (Like the school's blueprint) ====
    // This is where you declare what the contract will "remember" and "know"

    // STATE VARIABLES (Like the school's permanent records/storage rooms)
    address public owner; // Like the principal's office - who's in charge
    uint256 public totalStudents; // Like a student counter on the wall
    bool public isSchoolOpen; // Like a sign saying "OPEN" or "CLOSED"

    // MAPPINGS (Like filing cabinets with student records)
    mapping(address => uint256) public studentGrades; // Each student's grade
    mapping(address => bool) public isEnrolled; // Who's enrolled

    // ARRAYS (Like class lists)
    address[] public allStudents; // List of all student addresses

    // STRUCTS (Like a student ID card with multiple info)
    struct Student {
        string name;
        uint256 age;
        uint256 grade;
        bool isActive;
    }

    mapping(address => Student) public students;

    // ENUMS (Like multiple choice options - A, B, C, D)
    enum GradeLevel {
        Kindergarten, // 0
        Elementary, // 1
        MiddleSchool, // 2
        HighSchool // 3
    }

    // CONSTANTS (Like school rules that never change)
    uint256 public constant MAX_STUDENTS = 1000;
    string public constant SCHOOL_NAME = "Blockchain Academy";

    // IMMUTABLE (Set once during construction, like the school's address)
    address public immutable SCHOOL_DISTRICT;

    // EVENTS (Like school announcements over the intercom)
    event StudentEnrolled(address indexed student, string name);
    event GradeUpdated(address indexed student, uint256 newGrade);
    event SchoolClosed();

    // MODIFIERS (Like security guards checking permissions)
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the principal can do this!");
        _; // This means "continue with the function"
    }

    modifier onlyWhenOpen() {
        require(isSchoolOpen, "School is closed!");
        _;
    }

    // CUSTOM ERRORS (More efficient than require messages)
    error NotAuthorized(address caller);
    error SchoolFull();
    error StudentNotFound();

    // ==== SECTION 2: CONSTRUCTOR (Like the grand opening day) ====
    // This runs ONCE when the contract is deployed (like setting up the school)
    constructor(address _schoolDistrict) {
        owner = msg.sender; // The person deploying becomes principal
        SCHOOL_DISTRICT = _schoolDistrict; // Set the district (immutable)
        isSchoolOpen = true; // Open the school
        totalStudents = 0; // Start with zero students

        // You can also do initial setup here:
        // - Set initial values
        // - Assign roles
        // - Initialize important state
    }

    // ==== SECTION 3: FUNCTIONS (Like different school activities) ====

    // PUBLIC functions (Like open school events - anyone can join)
    function enrollStudent(
        string memory _name,
        uint256 _age
    ) public onlyWhenOpen {
        if (totalStudents >= MAX_STUDENTS) {
            revert SchoolFull();
        }

        // Like filling out enrollment forms
        students[msg.sender] = Student(_name, _age, 0, true);
        isEnrolled[msg.sender] = true;
        allStudents.push(msg.sender);
        totalStudents++;

        emit StudentEnrolled(msg.sender, _name);
    }

    // EXTERNAL functions (Like school board meetings - only outsiders call these)
    function updateGrade(address _student, uint256 _grade) external onlyOwner {
        if (!isEnrolled[_student]) {
            revert StudentNotFound();
        }

        students[_student].grade = _grade;
        studentGrades[_student] = _grade;

        emit GradeUpdated(_student, _grade);
    }

    // INTERNAL functions (Like teacher meetings - only people inside school)
    function _calculateAverage() internal view returns (uint256) {
        // This can only be called by functions within this contract
        // Like internal school calculations
        uint256 total = 0;
        for (uint256 i = 0; i < allStudents.length; i++) {
            total += studentGrades[allStudents[i]];
        }
        return totalStudents > 0 ? total / totalStudents : 0;
    }

    // PRIVATE functions (Like principal's private notes - most restricted)
    function _resetSchool() private {
        // Only functions in THIS exact contract can call this
        // Like the principal's private administrative tasks
        totalStudents = 0;
        isSchoolOpen = false;
    }

    // VIEW functions (Like looking at bulletin board - just reading, no changes)
    function getStudentInfo(
        address _student
    ) public view returns (string memory name, uint256 age, uint256 grade) {
        Student memory student = students[_student];
        return (student.name, student.age, student.grade);
    }

    // PURE functions (Like math calculations - don't even need to read school data)
    function calculateLetterGrade(
        uint256 _numericalGrade
    ) public pure returns (string memory) {
        if (_numericalGrade >= 90) return "A";
        if (_numericalGrade >= 80) return "B";
        if (_numericalGrade >= 70) return "C";
        if (_numericalGrade >= 60) return "D";
        return "F";
    }

    // PAYABLE functions (Like paying school fees - can receive money)
    function payTuition() public payable onlyWhenOpen {
        require(msg.value > 0, "Must pay something!");
        require(isEnrolled[msg.sender], "Must be enrolled first!");

        // Process payment (money is automatically added to contract)
        // Like depositing tuition fees
    }

    // ==== SECTION 4: SPECIAL FUNCTIONS ====

    // RECEIVE function (Like a donation box - receives plain ETH transfers)
    receive() external payable {
        // This runs when someone sends ETH directly to contract
        // Like someone dropping money in the school donation box
        emit StudentEnrolled(msg.sender, "Anonymous Donor");
    }

    // FALLBACK function (Like a lost & found - catches everything else)
    fallback() external payable {
        // This runs when:
        // 1. Someone calls a function that doesn't exist
        // 2. Someone sends data but no matching function
        // Like when someone asks for something the school doesn't offer

        // You can handle unexpected calls here
        revert("Function not found - check the school directory!");
    }

    // ADMIN functions (Like principal's special powers)
    function closeSchool() public onlyOwner {
        isSchoolOpen = false;
        emit SchoolClosed();
        _resetSchool(); // Call private function
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance; // Like checking the school's bank account
    }

    function withdrawFunds() public onlyOwner {
        payable(owner).transfer(address(this).balance);
        // Like principal taking money to the bank
    }
}

contract OfficeBuilding {
    /**
     * VISIBILITY MODIFIERS = OFFICE BUILDING ACCESS LEVELS
     *
     * 🌍 PUBLIC = Lobby/Reception (Anyone can enter and see)
     * 🏢 EXTERNAL = Main entrance (Only visitors from outside)
     * 🏠 INTERNAL = Company floors (Employees and subsidiaries)
     * 🔒 PRIVATE = CEO's private office (Only this specific person)
     */
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
    function submitJobApplication(
        string calldata _applicantName,
        uint256 _experience
    ) external {
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

    function _calculateBonus(
        address _employee
    ) internal view returns (uint256) {
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

    function getEmployeeSalary(
        address _employee
    ) public view returns (uint256) {
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
}

contract PCAnalogyContract {
    /**
     * SMART CONTRACT DATA LOCATIONS = PC COMPONENTS ANALOGY
     *
     * 💾 STORAGE/STATE = HARD DISK (Permanent storage)
     * 🧠 MEMORY = RAM (Temporary working space)
     * 💿 CALLDATA = CD-ROM/DVD (Read-only data from external source)
     */

    // ==========================================
    // 💾 STORAGE/STATE = HARD DISK
    // - Data saved permanently (like files on your C: drive)
    // - Survives computer restarts (blockchain restarts)
    // - Slowest to access but permanent
    // - Most expensive (like buying more hard disk space)
    // ==========================================

    // These are like files permanently saved on your hard disk
    string public computerName; // Like C:\computer_name.txt
    mapping(address => string) public userFiles; // Like C:\Users\[username]\documents
    uint256[] public systemLogs; // Like C:\Windows\system32\logs

    struct UserProfile {
        string username;
        uint256 lastLogin;
        bool isAdmin;
    }

    mapping(address => UserProfile) public users; // Like C:\Users\profiles\

    // ==========================================
    // CONSTRUCTOR = INITIAL OS INSTALLATION
    // Setting up the "hard disk" when first installing
    // ==========================================

    constructor(string memory _computerName) {
        // This writes to "hard disk" (STORAGE) permanently
        computerName = _computerName; // Like naming your PC during Windows setup
        systemLogs.push(block.timestamp); // Like creating initial system logs
    }

    // ==========================================
    // FUNCTIONS DEMONSTRATING DIFFERENT DATA LOCATIONS
    // ==========================================

    /**
     * 💾 STORAGE Example: Saving files to hard disk
     * Like using File Explorer to save a document permanently
     */
    function saveUserFile(
        string memory _filename, // RAM: temporary variable while function runs
        string memory _content // RAM: temporary content
    ) public {
        // Writing to STORAGE (hard disk) - permanent save
        userFiles[msg.sender] = string.concat(_filename, ": ", _content);

        // Update user profile on "hard disk"
        users[msg.sender] = UserProfile({
            username: _filename,
            lastLogin: block.timestamp,
            isAdmin: false
        });

        // Add to system logs (permanent storage)
        systemLogs.push(block.timestamp);

        // 💡 Like clicking "Save" in Microsoft Word - data goes to hard disk permanently
    }

    /**
     * 🧠 MEMORY = RAM (Working space while program runs)
     * Like opening multiple browser tabs and doing calculations
     */
    function processDataInRAM(
        string memory _inputText, // RAM: temporary workspace
        uint256[] memory _numbers // RAM: temporary array in memory
    ) public pure returns (string memory, uint256) {
        // These variables exist in RAM (temporary while function runs)
        string memory processedText = string.concat("Processed: ", _inputText);
        uint256 sum = 0;
        uint256 average = 0;

        // Working in RAM - like calculator app doing math
        for (uint256 i = 0; i < _numbers.length; i++) {
            sum += _numbers[i]; // All calculations happen in RAM
        }

        if (_numbers.length > 0) {
            average = sum / _numbers.length;
        }

        // Return data from RAM (will be copied to caller)
        return (processedText, average);

        // 💡 When function ends = like closing the calculator app
        // All RAM data (processedText, sum, average) gets cleared!
    }

    /**
     * 💿 CALLDATA = CD-ROM/DVD (Read-only external data)
     * Like inserting a CD with data you can read but not modify
     */
    function readFromCDROM(
        string calldata _cdContent, // CD-ROM: read-only data from external source
        uint256[] calldata _cdNumbers // CD-ROM: read-only array
    ) external view returns (uint256) {
        // You can READ from the "CD" but NOT write to it
        // _cdContent = "new content";  // ❌ ERROR! Can't write to CD-ROM

        uint256 total = 0;

        // Reading data from CD-ROM (cheapest operation)
        for (uint256 i = 0; i < _cdNumbers.length; i++) {
            total += _cdNumbers[i]; // ✅ Can READ from CD-ROM
        }

        // If you need to modify the data, copy from CD to RAM first:
        uint256[] memory ramCopy = _cdNumbers; // Copy CD data to RAM
        // Now you can modify ramCopy (but original CD stays unchanged)

        return total;

        // 💡 Like inserting a software installation CD
        // You can read the files but can't change what's on the CD
    }

    /**
     * 💾 STORAGE Reference: Direct hard disk access
     * Like opening a file directly from hard disk to edit it
     */
    function editFileDirectly(address _userAddress) public {
        // Get direct reference to hard disk file (not a copy)
        UserProfile storage userFile = users[_userAddress];

        // Edit the file directly on hard disk (no copying needed)
        userFile.lastLogin = block.timestamp; // Direct hard disk write
        userFile.isAdmin = true; // Another direct write

        // 💡 Like opening a Word document and editing it directly
        // Changes save immediately to hard disk
    }

    /**
     * 🧠 RAM Copy: Loading file into memory to work with
     * Like opening a file in RAM to view/process it
     */
    function loadFileToRAM(
        address _userAddress
    ) public view returns (string memory, uint256, bool) {
        // Load a COPY of hard disk data into RAM
        UserProfile memory ramCopy = users[_userAddress];

        // You're working with a copy in RAM
        return (ramCopy.username, ramCopy.lastLogin, ramCopy.isAdmin);

        // 💡 Like opening a photo in Photoshop
        // Original file stays on hard disk, you work with RAM copy
    }

    /**
     * Mixed Example: Real computer workflow
     */
    function computerWorkflow(
        string calldata _programData, // CD-ROM: Installing software from CD
        string[] calldata _files // CD-ROM: List of files to install
    ) external {
        // Step 1: Read installation data from CD-ROM
        // (CALLDATA - cheapest, read-only)

        // Step 2: Copy to RAM for processing
        string memory installationLog = string.concat(
            "Installing: ",
            _programData
        );

        // Step 3: Process in RAM (temporary work)
        string memory welcomeMessage = string.concat(
            "Welcome to ",
            _programData
        );

        // Step 4: Save results to hard disk permanently
        userFiles[msg.sender] = installationLog; // STORAGE - permanent save

        // Step 5: Update system logs on hard disk
        systemLogs.push(block.timestamp);

        // 💡 Like installing a game:
        // 1. Read from game CD (CALLDATA)
        // 2. Use RAM while installing (MEMORY)
        // 3. Save game files to hard disk (STORAGE)
    }

    /**
     * Performance Comparison: Like checking computer specs
     */
    function performanceDemo() public {
        // STORAGE (Hard Disk) - Slow but permanent
        computerName = "Gaming PC"; // ~20,000 gas (like slow hard disk write)

        // MEMORY (RAM) - Fast but temporary
        string memory temp = "Fast"; // ~100 gas (like quick RAM access)

        // CALLDATA (CD-ROM) - Fastest read, but external only
        // (cheapest when reading function parameters)

        // 💡 Just like real computers:
        // - Hard disk: Slow but keeps data forever
        // - RAM: Fast but loses data when power off
        // - CD-ROM: Fast to read but can't write to it
    }

    /**
     * Array Examples: Different storage locations
     */
    function arrayStorageExample(
        uint256[] calldata _cdData // CD-ROM: Read-only array from external
    ) external {
        // STORAGE: Permanent array on hard disk
        systemLogs.push(999); // Like saving to C:\logs\system.txt

        // MEMORY: Temporary array in RAM
        uint256[] memory ramArray = new uint256[](5);
        ramArray[0] = 100; // Like opening calculator and doing math

        // CALLDATA: Reading from CD-ROM
        uint256 firstValue = _cdData[0]; // Like reading first file from CD

        // Copy CD data to RAM when you need to modify it
        uint256[] memory editableArray = _cdData; // Copy CD → RAM
        editableArray[0] = 500; // Now you can edit the RAM copy

        // 💡 Like copying files from CD to computer to edit them
    }

    /**
     * 🖥️ COMPLETE PC ANALOGY SUMMARY:
     *
     * 💾 STORAGE/STATE = HARD DISK
     * ✅ Permanent storage (survives restart)
     * ✅ Keeps data forever
     * ❌ Slowest access speed
     * ❌ Most expensive (gas cost)
     * 🎯 Use for: Contract's permanent data that must survive
     *
     * 🧠 MEMORY = RAM
     * ✅ Fast temporary workspace
     * ✅ Good for calculations and processing
     * ❌ Data disappears when function ends (like restart)
     * ❌ Moderate cost
     * 🎯 Use for: Temporary calculations, data processing
     *
     * 💿 CALLDATA = CD-ROM/DVD
     * ✅ Fastest to read
     * ✅ Cheapest gas cost
     * ✅ Perfect for external function inputs
     * ❌ Read-only (can't modify)
     * ❌ Only available as function parameters
     * 🎯 Use for: External function inputs you won't change
     *
     * 🔑 WORKFLOW (Like using a computer):
     * 1. Get data from CD-ROM (CALLDATA) - cheapest
     * 2. Process in RAM (MEMORY) - if you need to modify
     * 3. Save to Hard Disk (STORAGE) - if you need to remember forever
     *
     * 💡 REAL EXAMPLE:
     * Installing software = Read from CD (calldata) → Process in RAM (memory) → Save to Hard Disk (storage)
     */
}

contract SchoolDataLocations {
    /**
     * Think of this contract like a SCHOOL BUILDING:
     * - STORAGE/STATE = Permanent school records (filing cabinets, yearbooks)
     * - MEMORY = Teacher's whiteboard (temporary, erased after class)
     * - CALLDATA = Students' homework they bring from home (read-only)
     */

    // ==========================================
    // STORAGE/STATE VARIABLES
    // Like the school's permanent filing cabinets
    // Data stays here FOREVER (until changed)
    // Most expensive to use (costs gas to read/write)
    // ==========================================

    string public schoolName; // Permanent school name
    mapping(address => string) public studentNames; // Student records
    uint256[] public allGrades; // All grades ever recorded

    struct Student {
        string name;
        uint256 age;
        bool isActive;
    }

    mapping(address => Student) public students; // Student files

    // ==========================================
    // CONSTRUCTOR - Setting up the school
    // ==========================================

    constructor(string memory _schoolName) {
        // When you write to state variables, you're updating permanent records
        schoolName = _schoolName; // This goes to STORAGE permanently
    }

    // ==========================================
    // FUNCTION EXAMPLES - Different Data Locations
    // ==========================================

    /**
     * STORAGE Example: Updating permanent school records
     * Like writing in the official student transcript book
     */
    function updateStudentPermanently(
        address _studentAddress,
        string memory _name, // MEMORY: temporary copy while function runs
        uint256 _age
    ) public {
        // This creates/updates permanent records (STORAGE)
        students[_studentAddress] = Student({
            name: _name, // Data copied from MEMORY to STORAGE
            age: _age,
            isActive: true
        });

        // This also writes to permanent STORAGE
        studentNames[_studentAddress] = _name;
    }

    /**
     * MEMORY Example: Temporary calculations
     * Like using scratch paper - thrown away after use
     */
    function calculateTemporaryData(
        string memory _tempName, // MEMORY: temporary during function
        uint256[] memory _grades // MEMORY: temporary array
    ) public pure returns (string memory, uint256) {
        // These variables exist only in MEMORY (temporary)
        string memory processedName = string.concat("Student: ", _tempName);
        uint256 average = 0;

        // Calculate average using MEMORY data
        if (_grades.length > 0) {
            uint256 sum = 0;
            for (uint256 i = 0; i < _grades.length; i++) {
                sum += _grades[i]; // Reading from MEMORY
            }
            average = sum / _grades.length;
        }

        // Return MEMORY data (will be copied to caller)
        return (processedName, average);

        // After function ends, all MEMORY data disappears!
    }

    /**
     * CALLDATA Example: Reading homework brought from outside
     * Like reading a report card student brings from home (read-only)
     */
    function processHomework(
        string calldata _homeworkText, // CALLDATA: can't modify, cheapest to use
        uint256[] calldata _testScores // CALLDATA: read-only from transaction
    ) external view returns (uint256) {
        // You can READ from calldata but NOT modify it
        // This is like looking at homework but not changing it

        // _homeworkText[0] = 'X';  // ❌ ERROR! Can't modify CALLDATA

        uint256 totalScore = 0;
        for (uint256 i = 0; i < _testScores.length; i++) {
            totalScore += _testScores[i]; // ✅ Can READ CALLDATA
        }

        // If you need to modify the data, copy to MEMORY first:
        uint256[] memory modifiableScores = _testScores; // Copy to MEMORY
        // Now you can modify modifiableScores

        return totalScore;
    }

    /**
     * STORAGE Reference Example: Working directly with permanent records
     * Like editing the original student file (not a copy)
     */
    function updateStudentDirectly(address _studentAddress) public {
        // Get a REFERENCE to storage (not a copy)
        Student storage studentRef = students[_studentAddress];

        // Changes directly affect the permanent record
        studentRef.isActive = false; // Modifies STORAGE directly
        studentRef.age += 1; // Birthday! Updates permanent record

        // This is more gas-efficient than copying to memory and back
    }

    /**
     * MEMORY Copy Example: Working with temporary copy
     * Like photocopying a student file to work on
     */
    function getStudentCopy(
        address _studentAddress
    ) public view returns (string memory, uint256, bool) {
        // Get a COPY in memory (doesn't affect original)
        Student memory studentCopy = students[_studentAddress];

        // You can read from the copy
        return (studentCopy.name, studentCopy.age, studentCopy.isActive);

        // Any changes to studentCopy wouldn't affect storage
        // studentCopy.age = 999;  // This wouldn't change permanent record
    }

    /**
     * Mixed Example: When to use each type
     */
    function enrollNewStudent(
        string calldata _name, // CALLDATA: read-only input from user
        uint256 _age, // VALUE TYPE: automatically copied
        string[] calldata _subjects // CALLDATA: read-only list from user
    ) external {
        // Copy calldata to memory when you need to modify
        string memory studentName = _name; // Copy to MEMORY for processing

        // Process in memory (temporary work)
        string memory welcomeMessage = string.concat("Welcome, ", studentName);

        // Save to permanent storage
        students[msg.sender] = Student({
            name: studentName, // MEMORY → STORAGE
            age: _age,
            isActive: true
        });

        // Work with calldata directly (read-only)
        for (uint256 i = 0; i < _subjects.length; i++) {
            // Process each subject from calldata
            // string memory subject = _subjects[i];  // Could copy if needed
        }
    }

    /**
     * Gas Cost Comparison Function
     */
    function demonstrateGasCosts() public {
        // STORAGE operations (most expensive)
        schoolName = "New Name"; // ~20,000 gas

        // MEMORY operations (moderate cost)
        string memory tempName = "Temp"; // ~100 gas

        // CALLDATA operations (cheapest for reading)
        // (calldata is cheapest when passed as function parameter)
    }

    /**
     * Array Examples: Different locations
     */
    function arrayLocationExamples(
        uint256[] calldata _inputGrades // CALLDATA: read-only input
    ) external {
        // STORAGE: permanent array (expensive)
        allGrades.push(95); // Permanently stored

        // MEMORY: temporary array (moderate cost)
        uint256[] memory tempGrades = new uint256[](5);
        tempGrades[0] = 100; // Only exists during function execution

        // CALLDATA: read-only input (cheapest)
        uint256 firstGrade = _inputGrades[0]; // Just reading

        // Copy calldata to memory when you need to modify
        uint256[] memory modifiableGrades = _inputGrades;
        modifiableGrades[0] = 85; // Now you can modify the copy
    }
    //TypeError: Data location can only be specified for array, struct or mapping types, but "calldata" was given.
    //   --> contract-2053f8ffc9.sol:10:25:
    //    |
    // 10 |     function setAddress(address calldata _newAddress) public {
    //    |                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * SUMMARY - Like Different Types of Paper:
     *
     * 📋 STORAGE/STATE (Permanent Records):
     * - Like writing in permanent ink in official school records
     * - Data survives forever (until explicitly changed)
     * - Most expensive (high gas cost)
     * - Use for: contract's permanent data
     *
     * 📝 MEMORY (Scratch Paper):
     * - Like using erasable whiteboard during class
     * - Data disappears when function ends
     * - Moderate gas cost
     * - Use for: temporary calculations, processing data
     *
     * 📄 CALLDATA (Homework from Home):
     * - Like reading student's homework (can't change it)
     * - Read-only, cheapest to access
     * - Data comes from transaction input
     * - Use for: external function parameters you won't modify
     *
     * 🔑 KEY RULES:
     * 1. Use CALLDATA for external function inputs (cheapest)
     * 2. Use MEMORY for temporary work and calculations
     * 3. Use STORAGE for permanent contract data
     * 4. Copy CALLDATA → MEMORY when you need to modify
     * 5. Use STORAGE references when updating existing data
     */
}

//    function ternary(uint256 _x) public pure returns (uint256) {
//         // if (_x < 10) {
//         //     return 1;
//         // }
//         // return 2;

//         // shorthand way to write if / else statement
//         // the "?" operator is called the ternary operator
//         return _x < 10 ? 1 : 2;
//     }
