// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ClassroomSetup {
    
    // ==========================================
    // 1. CUSTOM TYPES FIRST (Like basic building blocks)
    // These are like defining what shapes and colors exist
    // before you start building with them
    // ==========================================
    
    // ENUMS - Define your multiple choice options first
    // Like deciding what grade levels your school will have
    enum StudentLevel { 
        Beginner,    // 0
        Intermediate, // 1
        Advanced     // 2
    }
    
    enum ClassStatus {
        NotStarted,  // 0
        InProgress,  // 1
        Completed    // 2
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
    
    event StudentEnrolled(address indexed student, string name, StudentLevel level);
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
    address public principal;           // Who's in charge
    uint256 public totalStudents;      // Current student count
    uint256 public nextCourseId;       // ID counter for new courses
    bool public isSchoolOpen;          // Is school accepting students?
    
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
        if (uint8(_level) > 2) { // Since we have 3 levels (0,1,2)
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