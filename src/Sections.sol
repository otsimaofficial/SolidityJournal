// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Think of this like setting up a new school building
contract ContractSections {
    
    // ==== SECTION 1: DECLARATIONS (Like the school's blueprint) ====
    // This is where you declare what the contract will "remember" and "know"
    
    // STATE VARIABLES (Like the school's permanent records/storage rooms)
    address public owner;           // Like the principal's office - who's in charge
    uint256 public totalStudents;   // Like a student counter on the wall
    bool public isSchoolOpen;       // Like a sign saying "OPEN" or "CLOSED"
    
    // MAPPINGS (Like filing cabinets with student records)
    mapping(address => uint256) public studentGrades;  // Each student's grade
    mapping(address => bool) public isEnrolled;        // Who's enrolled
    
    // ARRAYS (Like class lists)
    address[] public allStudents;   // List of all student addresses
    
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
        Kindergarten,   // 0
        Elementary,     // 1  
        MiddleSchool,   // 2
        HighSchool      // 3
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
        owner = msg.sender;              // The person deploying becomes principal
        SCHOOL_DISTRICT = _schoolDistrict; // Set the district (immutable)
        isSchoolOpen = true;             // Open the school
        totalStudents = 0;               // Start with zero students
        
        // You can also do initial setup here:
        // - Set initial values
        // - Assign roles
        // - Initialize important state
    }
    
    // ==== SECTION 3: FUNCTIONS (Like different school activities) ====
    
    // PUBLIC functions (Like open school events - anyone can join)
    function enrollStudent(string memory _name, uint256 _age) public onlyWhenOpen {
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
        for (uint i = 0; i < allStudents.length; i++) {
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
    function getStudentInfo(address _student) public view returns (string memory name, uint256 age, uint256 grade) {
        Student memory student = students[_student];
        return (student.name, student.age, student.grade);
    }
    
    // PURE functions (Like math calculations - don't even need to read school data)
    function calculateLetterGrade(uint256 _numericalGrade) public pure returns (string memory) {
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