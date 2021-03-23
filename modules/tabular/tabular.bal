import ballerina/io;

//AddLine will add a new table line
public function AddLine(string... args) {
	string formatString = buildFormatString(args);
    printString(formatString);
}

// AddHeader will write a new table line followed by a seperator
public function AddHeader(string... args) {
    foreach int i in 0..< args.length(){
        args[i] = args[i].toUpperAscii();
    }
	string fotmatString = buildFormatString(args);
    printString(fotmatString);
    fotmatString = addSeparator(args);
    printString(fotmatString);
}

function printString(string fotmatString) {
    io:print(fotmatString);
}

// addSeparator will write a new dash seperator line based on the args length
function addSeparator(string[] args) returns string {
    string buildStringLine = "";
    foreach int i in 0..< args.length() {
        int lengthOfString = args[i].length();
        int j = 0;
        while j < lengthOfString {
            buildStringLine += "-";
            j += 1;
        }
        if (i+1 < args.length() ) {
            buildStringLine += "\t";
        }
    }
    buildStringLine += "\n";
    return buildStringLine;
}

// buildFormatString will build the formatted string
function buildFormatString(string[] args) returns string {
    string buildStringLine = "";
    foreach int i in 0..< args.length() {
        buildStringLine += args[i];
        if (i+1 < args.length()) {
            buildStringLine += "\t";
        }
    }
    buildStringLine += "\n";
    return buildStringLine;
}