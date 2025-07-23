// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Think of this contract like a SCHOOL BUILDING:
 * - STORAGE/STATE = Permanent school records (filing cabinets, yearbooks)
 * - MEMORY = Teacher's whiteboard (temporary, erased after class)
 * - CALLDATA = Students' homework they bring from home (read-only)
 */

contract SchoolDataLocations {
    
    // ==========================================
    // STORAGE/STATE VARIABLES
    // Like the school's permanent filing cabinets
    // Data stays here FOREVER (until changed)
    // Most expensive to use (costs gas to read/write)
    // ==========================================
    
    string public schoolName;                    // Permanent school name
    mapping(address => string) public studentNames;  // Student records
    uint256[] public allGrades;                  // All grades ever recorded
    
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
        schoolName = _schoolName;  // This goes to STORAGE permanently
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
        string memory _name,  // MEMORY: temporary copy while function runs
        uint256 _age
    ) public {
        // This creates/updates permanent records (STORAGE)
        students[_studentAddress] = Student({
            name: _name,      // Data copied from MEMORY to STORAGE
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
        string memory _tempName,    // MEMORY: temporary during function
        uint256[] memory _grades    // MEMORY: temporary array
    ) public pure returns (string memory, uint256) {
        
        // These variables exist only in MEMORY (temporary)
        string memory processedName = string.concat("Student: ", _tempName);
        uint256 average = 0;
        
        // Calculate average using MEMORY data
        if (_grades.length > 0) {
            uint256 sum = 0;
            for (uint256 i = 0; i < _grades.length; i++) {
                sum += _grades[i];  // Reading from MEMORY
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
        string calldata _homeworkText,    // CALLDATA: can't modify, cheapest to use
        uint256[] calldata _testScores    // CALLDATA: read-only from transaction
    ) external view returns (uint256) {
        
        // You can READ from calldata but NOT modify it
        // This is like looking at homework but not changing it
        
        // _homeworkText[0] = 'X';  // ❌ ERROR! Can't modify CALLDATA
        
        uint256 totalScore = 0;
        for (uint256 i = 0; i < _testScores.length; i++) {
            totalScore += _testScores[i];  // ✅ Can READ CALLDATA
        }
        
        // If you need to modify the data, copy to MEMORY first:
        uint256[] memory modifiableScores = _testScores;  // Copy to MEMORY
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
        studentRef.isActive = false;  // Modifies STORAGE directly
        studentRef.age += 1;          // Birthday! Updates permanent record
        
        // This is more gas-efficient than copying to memory and back
    }
    
    /**
     * MEMORY Copy Example: Working with temporary copy
     * Like photocopying a student file to work on
     */
    function getStudentCopy(address _studentAddress) 
        public 
        view 
        returns (string memory, uint256, bool) 
    {
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
        string calldata _name,        // CALLDATA: read-only input from user
        uint256 _age,                 // VALUE TYPE: automatically copied
        string[] calldata _subjects   // CALLDATA: read-only list from user
    ) external {
        
        // Copy calldata to memory when you need to modify
        string memory studentName = _name;  // Copy to MEMORY for processing
        
        // Process in memory (temporary work)
        string memory welcomeMessage = string.concat("Welcome, ", studentName);
        
        // Save to permanent storage
        students[msg.sender] = Student({
            name: studentName,    // MEMORY → STORAGE
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
        schoolName = "New Name";           // ~20,000 gas
        
        // MEMORY operations (moderate cost)
        string memory tempName = "Temp";   // ~100 gas
        
        // CALLDATA operations (cheapest for reading)
        // (calldata is cheapest when passed as function parameter)
    }
    
    /**
     * Array Examples: Different locations
     */
    function arrayLocationExamples(
        uint256[] calldata _inputGrades  // CALLDATA: read-only input
    ) external {
        
        // STORAGE: permanent array (expensive)
        allGrades.push(95);  // Permanently stored
        
        // MEMORY: temporary array (moderate cost)
        uint256[] memory tempGrades = new uint256[](5);
        tempGrades[0] = 100;  // Only exists during function execution
        
        // CALLDATA: read-only input (cheapest)
        uint256 firstGrade = _inputGrades[0];  // Just reading
        
        // Copy calldata to memory when you need to modify
        uint256[] memory modifiableGrades = _inputGrades;
        modifiableGrades[0] = 85;  // Now you can modify the copy
    }
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