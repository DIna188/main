-- Institutions
CREATE TABLE Institutions (
    InstitutionID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Abbreviation VARCHAR(10) NOT NULL
);

-- Programs
CREATE TABLE Programs (
    ProgramID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Abbreviation VARCHAR(10) NOT NULL,
    InstitutionID INT,
    FOREIGN KEY (InstitutionID) REFERENCES Institutions(InstitutionID)
);

-- Branches
CREATE TABLE Branches (
    BranchID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    ProgramID INT,
    FOREIGN KEY (ProgramID) REFERENCES Programs(ProgramID)
);

-- Courses
CREATE TABLE Courses (
    CourseCode VARCHAR(6) PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Credits INT,
    Department VARCHAR(50)
);

-- Classifications
CREATE TABLE Classifications (
    ClassificationID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL
);

-- Program-Branch Relationship
CREATE TABLE ProgramBranches (
    ProgramBranchID INT PRIMARY KEY,
    ProgramID INT,
    BranchID INT,
    FOREIGN KEY (ProgramID) REFERENCES Programs(ProgramID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

-- Branch-Classification Relationship
CREATE TABLE BranchClassifications (
    BranchClassificationID INT PRIMARY KEY,
    BranchID INT,
    ClassificationID INT,
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
    FOREIGN KEY (ClassificationID) REFERENCES Classifications(ClassificationID)
);

-- Program-Course Relationship
CREATE TABLE ProgramCourses (
    ProgramCourseID INT PRIMARY KEY,
    ProgramID INT,
    CourseCode VARCHAR(6),
    IsMandatory BOOLEAN,
    FOREIGN KEY (ProgramID) REFERENCES Programs(ProgramID),
    FOREIGN KEY (CourseCode) REFERENCES Courses(CourseCode)
);

-- Branch-Course Relationship
CREATE TABLE BranchCourses (
    BranchCourseID INT PRIMARY KEY,
    BranchID INT,
    CourseCode VARCHAR(6),
    IsMandatory BOOLEAN,
    IsRecommended BOOLEAN,
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
    FOREIGN KEY (CourseCode) REFERENCES Courses(CourseCode)
);

-- Course Prerequisites
CREATE TABLE CoursePrerequisites (
    PrerequisiteID INT PRIMARY KEY,
    CourseCode VARCHAR(6),
    PrerequisiteCourseCode VARCHAR(6),
    FOREIGN KEY (CourseCode) REFERENCES Courses(CourseCode),
    FOREIGN KEY (PrerequisiteCourseCode) REFERENCES Courses(CourseCode)
);

-- Students
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    ProgramID INT,
    FOREIGN KEY (ProgramID) REFERENCES Programs(ProgramID)
);

-- Student-Branch Relationship
CREATE TABLE StudentBranches (
    StudentBranchID INT PRIMARY KEY,
    StudentID INT,
    BranchID INT,
    ProgramID INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
    FOREIGN KEY (ProgramID) REFERENCES Programs(ProgramID)
);

-- Student-Course Relationship
CREATE TABLE StudentCourses (
    StudentCourseID INT PRIMARY KEY,
    StudentID INT,
    CourseCode VARCHAR(6),
    Grade VARCHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseCode) REFERENCES Courses(CourseCode)
);

-- Course Limits
CREATE TABLE CourseLimits (
    CourseLimitID INT PRIMARY KEY,
    CourseCode VARCHAR(6),
    Capacity INT,
    FOREIGN KEY (CourseCode) REFERENCES Courses(CourseCode)
);

-- Waiting List
CREATE TABLE WaitingLists (
    WaitingListID INT PRIMARY KEY,
    StudentID INT,
    CourseCode VARCHAR(6),
    Position INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseCode) REFERENCES Courses(CourseCode)
);

