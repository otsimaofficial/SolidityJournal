// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * SMART CONTRACT DATA LOCATIONS = PC COMPONENTS ANALOGY
 *
 * 💾 STORAGE/STATE = HARD DISK (Permanent storage)
 * 🧠 MEMORY = RAM (Temporary working space)
 * 💿 CALLDATA = CD-ROM/DVD (Read-only data from external source)
 */
contract PCAnalogyContract {
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
        users[msg.sender] = UserProfile({username: _filename, lastLogin: block.timestamp, isAdmin: false});

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
    function loadFileToRAM(address _userAddress) public view returns (string memory, uint256, bool) {
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
        string memory installationLog = string.concat("Installing: ", _programData);

        // Step 3: Process in RAM (temporary work)
        string memory welcomeMessage = string.concat("Welcome to ", _programData);

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
